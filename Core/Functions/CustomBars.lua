local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.CustomBars = {}

-- Bars the user adds per specialization, filled from that spec's snapshots.
local CustomBars = TRB.Functions.CustomBars
local L = TRB.Localization

---@alias trbCustomBarSourceKind "buffTime"|"buffStacks"|"cooldownTime"|"rechargeTime"|"totalRechargeTime"|"charges"

---@class TRB.Classes.Settings.CustomBarSource
---@field public kind trbCustomBarSourceKind
---@field public spellId integer
---@field public spellName string? # Shown where the spec's snapshots aren't loaded
---@field public provider string? # Which provider reads it; nil is the spec's own tracking

---@class TRB.Classes.Settings.CustomBar
---@field public guid string
---@field public name string
---@field public source TRB.Classes.Settings.CustomBarSource
---@field public segmented boolean? # A count bar's one node per stack or charge; nil follows the maximum
---@field public fillRecharge boolean? # A segmented charges bar's recharging charge fills as it recharges; nil is on
---@field public maxCount integer? # A count bar's last plain maximum, for a login where it can't be read

---@class TRB.Classes.CustomBarSourceOption
---@field public kind trbCustomBarSourceKind
---@field public spellId integer
---@field public spellName string
---@field public icon string? # Texture markup, as a spell's icon is
---@field public label string
---@field public provider string? # Set by GetSources; nil is the spec's own tracking

---@class TRB.Classes.CustomBarRuntime
---@field public key string
---@field public bar TRB.Classes.Settings.CustomBar
---@field public definition TRB.Classes.BarTypeDefinition
---@field public provider TRB.Classes.CustomBarProvider
---@field public kind trbCustomBarSourceKind
---@field public spellId integer
---@field public isTimer boolean
---@field public fillRecharge boolean # Whether a charges bar draws its recharging charge filling
---@field public recharging boolean? # Whether a charges bar's next charge is recharging
---@field public rechargeEnd number? # The hand-counted recharge the fill's duration object was built for
---@field public rechargeLength number?
---@field public rechargeObject any?
---@field public boundRecharge any? # The duration object the recharge fill last took
---@field public trackerCount number? # The plain count the charge tracker last took
---@field public fillTexture string? # The recharge fill's texture and color as last applied
---@field public fillColor string?
---@field public fillColor2 string?
---@field public fillGradient string?
---@field public rechargeColors table?
---@field public timeVar string # The bar's own bar text variables
---@field public stacksVar string
---@field public stacksMaxVar string
---@field public active boolean
---@field public frame Frame? # The node frame the fill was last written to
---@field public layout integer? # The group's layout pass the fill was last written after
---@field public endTime number?
---@field public duration number?
---@field public pausedRemaining number? # The frozen time a paused buff's bar holds
---@field public untimed boolean? # Whether a typed buff with no duration is drawn full while it is up
---@field public version integer?
---@field public count number?
---@field public max number?
---@field public nodeKeys string[]? # Each node's value cache key

CustomBars.kinds = {
	buffTime = "buffTime",
	buffStacks = "buffStacks",
	cooldownTime = "cooldownTime",
	rechargeTime = "rechargeTime",
	totalRechargeTime = "totalRechargeTime",
	charges = "charges",
}

-- A count bar with no saved choice is segmented up to this many stacks or charges.
CustomBars.segmentedAutoMax = 10

---One place custom bars can be fed from. The spec's own tracking is the only one so far.
---@class TRB.Classes.CustomBarProvider
---@field public label string # What the Add Bar menu calls it
---@field public shortLabel string? # What a bar's Tracks text says its value comes from
---@field public GetIdSources (fun(spellId: integer): TRB.Classes.CustomBarSourceOption[])? # What a spell ID the user typed can be tracked as; a provider with this takes typed IDs
---@field public promptText string? # What the spell ID prompt asks for
---@field public noSourcesText string? # Format for the message when a typed spell has nothing to track
---@field public GetSources fun(classId: integer?, specId: integer?): TRB.Classes.CustomBarSourceOption[] # What it offers a specialization, unsorted
---@field public GetSourceName fun(classId: integer?, specId: integer?, source: TRB.Classes.Settings.CustomBarSource): string? # The tracked spell's current name
---@field public ReadMax fun(classId: integer, specId: integer, source: TRB.Classes.Settings.CustomBarSource): integer? # A count source's maximum, when known in plain form
---@field public OnAdd fun(classId: integer, specId: integer, source: TRB.Classes.Settings.CustomBarSource)? # Runs once a bar on the source is saved
---@field public AppendCooldownSpell fun(entry: TRB.Classes.CustomBarRuntime, spells: TRB.Classes.SpellBase[], ownSnapshots: table<TRB.Classes.SpellBase, TRB.Classes.Snapshot>?)? # Adds the spell whose cooldown the cooldown tracker should read, with its snapshot when the spec doesn't hold it
---@field public WriteLookup fun(entry: TRB.Classes.CustomBarRuntime, now: number): string, string, string # The bar's time, stacks, and maximum stacks as text
---@field public Render fun(entry: TRB.Classes.CustomBarRuntime, group: TRB.Classes.BarGroup, node: TRB.Classes.BarNode, settings: table, now: number, redraw: boolean): boolean # Draws the bar; true when the bars need laying out again

CustomBars.defaultProvider = "snapshot"

---@type table<string, TRB.Classes.CustomBarProvider>
local providers = {}

---@param name string
---@param provider TRB.Classes.CustomBarProvider? # nil withdraws it
function CustomBars:RegisterProvider(name, provider)
	providers[name] = provider
end

---What the Add Bar menu calls a provider.
---@param name string? # nil is the spec's own tracking
---@return string
function CustomBars:GetProviderLabel(name)
	local provider = providers[name or self.defaultProvider]
	return provider ~= nil and provider.label or ""
end

---The provider that reads a source, or nil for one this version doesn't have.
---@param source TRB.Classes.Settings.CustomBarSource
---@return TRB.Classes.CustomBarProvider?
local function ProviderOf(source)
	return providers[source.provider or CustomBars.defaultProvider]
end

---@type TRB.Classes.CustomBarProvider
---@diagnostic disable-next-line: missing-fields
local snapshotProvider = { label = L["CustomBarsAddGroupSnapshot"], shortLabel = L["CustomBarsProviderShortSnapshot"] }
CustomBars:RegisterProvider(CustomBars.defaultProvider, snapshotProvider)

local kindLabels = {
	buffTime = L["CustomBarsKindBuffTime"],
	buffStacks = L["CustomBarsKindBuffStacks"],
	cooldownTime = L["CustomBarsKindCooldownTime"],
	rechargeTime = L["CustomBarsKindRechargeTime"],
	totalRechargeTime = L["CustomBarsKindTotalRechargeTime"],
	charges = L["CustomBarsKindCharges"],
}

---@type TRB.Classes.CustomBarRuntime[]
local runtime = {}
---@type table<string, TRB.Classes.CustomBarRuntime>
local runtimeByKey = {}
-- Whether the last rebuild registered any bar text variables, and whether any timer bar is running.
local runtimeHasBoundVariables = false
local anyTimerActive = false
---@type string?
local runtimeKey = nil
local runtimeHasCooldowns = false
local pendingCooldownSync = false
local pendingAuraSync = false
local pendingVisibility = false
-- A rebuilt bar list has groups to build and drop, and the new ones to texture and color.
local pendingGroups = false
local pendingAppearance = false
-- A count bar's last plain maximum, kept while the live one is secret or not yet read.
---@type table<string, integer>
local knownMax = {}
-- Bumped by each layout pass of a group, which can replace what the fill was written to.
---@type table<TRB.Classes.BarGroup, integer>
local layoutVersions = setmetatable({}, { __mode = "k" })

---@param kind trbCustomBarSourceKind?
---@return boolean
function CustomBars:IsCountKind(kind)
	return kind == self.kinds.buffStacks or kind == self.kinds.charges
end

---@param kind trbCustomBarSourceKind?
---@return boolean
function CustomBars:IsCooldownKind(kind)
	return kind == self.kinds.cooldownTime or kind == self.kinds.rechargeTime or kind == self.kinds.totalRechargeTime
		or kind == self.kinds.charges
end

---Whether a bar draws its recharging charge filling: a charges bar, unless the user turned it off.
---@param bar TRB.Classes.Settings.CustomBar
---@return boolean
function CustomBars:FillsRecharge(bar)
	return bar.source.kind == self.kinds.charges and bar.fillRecharge ~= false
end

---@param kind trbCustomBarSourceKind?
---@return string
function CustomBars:GetKindLabel(kind)
	return kindLabels[kind] or ""
end

---@param guid string
---@return string
function CustomBars:GetBarKey(guid)
	return TRB.Classes.BarTypeRegistry.userBarKeyPrefix .. (string.gsub(guid, "-", ""))
end

---The Relative to Frame name of bar text bound to a bar.
---@param key string
---@return string
function CustomBars:GetAnchorName(key)
	return "CustomBar::" .. key
end

---The Relative to Frame name of bar text bound to a charges bar's recharging charge.
---@param key string
---@return string
function CustomBars:GetRechargingAnchorName(key)
	return "CustomBarRecharging::" .. key
end

---A bar's default bar text, centered: a timer's time, a count's stacks or charges, or, on a charges bar that fills
---its recharging charge, the recharge's time on that charge.
---@param bar TRB.Classes.Settings.CustomBar
---@return string anchorName
---@return string variable
---@return boolean onRechargingCharge
local function GetDefaultText(bar)
	local key = CustomBars:GetBarKey(bar.guid)
	local definition = TRB.Classes.BarTypeRegistry:GetInstance():Get(key)
	if definition ~= nil and definition.fillsRecharge then
		return CustomBars:GetRechargingAnchorName(key), "$abilityTime", true
	end
	return CustomBars:GetAnchorName(key), CustomBars:IsCountKind(bar.source.kind) and "$abilityStacks" or "$abilityTime", false
end

---@param variable string
---@return string
local function DefaultTextOf(variable)
	return "{" .. variable .. "}[" .. variable .. "]"
end

---@param spec table?
---@return table<string, TRB.Classes.Settings.CustomBar>?
function CustomBars:GetBars(spec)
	return spec ~= nil and spec.customBars ~= nil and spec.customBars.bars or nil
end

---Whether a saved bar can be read at all, which a hand-edited or damaged import might not be.
---@param bar any
---@return boolean
local function IsUsable(bar)
	return type(bar) == "table" and type(bar.source) == "table" and kindLabels[bar.source.kind] ~= nil and type(bar.source.spellId) == "number"
		and ProviderOf(bar.source) ~= nil
end

---A specialization's custom bars, by name.
---@param spec table?
---@return TRB.Classes.Settings.CustomBar[]
function CustomBars:GetOrdered(spec)
	local ordered = {}
	local bars = self:GetBars(spec)
	if bars ~= nil then
		for guid, bar in pairs(bars) do
			if IsUsable(bar) then
				bar.guid = guid
				bar.name = bar.name or ""
				ordered[#ordered + 1] = bar
			end
		end
	end
	table.sort(ordered, function(a, b)
		if a.name ~= b.name then
			return a.name < b.name
		end
		return a.guid < b.guid
	end)
	return ordered
end

---The snapshots a specialization tracks, or nil for a class that isn't loaded.
---@param classId integer?
---@param specId integer?
---@return table<integer, TRB.Classes.Snapshot>?
local function GetSnapshots(classId, specId)
	if classId == nil or specId == nil then
		return nil
	end
	local compositeKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	local cache = compositeKey ~= nil and TRB.Data.specCache[compositeKey] or nil
	return cache ~= nil and cache.snapshotData ~= nil and cache.snapshotData.snapshots or nil
end

---@param spell TRB.Classes.SpellBase
---@return string?
local function GetSpellName(spell)
	if spell.name ~= nil and spell.name ~= "" then
		return spell.name
	end
	local spellInfo = C_Spell.GetSpellInfo(spell.id)
	return spellInfo ~= nil and spellInfo.name or nil
end

---What a specialization's snapshots can feed a bar with: timers and counts whose maximum is known.
---@param classId integer?
---@param specId integer?
---@return TRB.Classes.CustomBarSourceOption[]
function snapshotProvider.GetSources(classId, specId)
	local kinds = CustomBars.kinds
	local sources = {}
	local snapshots = GetSnapshots(classId, specId)
	if snapshots == nil then
		return sources
	end

	---@param kind trbCustomBarSourceKind
	---@param spell TRB.Classes.SpellBase
	---@param name string
	local function Add(kind, spell, name)
		sources[#sources + 1] = {
			kind = kind,
			spellId = spell.id,
			spellName = name,
			icon = spell.icon,
			label = string.format(L["CustomBarsSourceFormat"], name, kindLabels[kind]),
		}
	end

	for _, snapshot in pairs(snapshots) do
		local spell = snapshot.spell
		local name = spell ~= nil and GetSpellName(spell) or nil
		if spell ~= nil and name ~= nil then
			-- A hand-counted single charge is a plain cooldown.
			local hasCharges = spell.hasCharges == true
				or (snapshot.cooldown.useManualCharges == true and (snapshot.cooldown.manualMaxCharges > 1 or spell.hasCooldown ~= true))
			-- A charge ability's duration is its recharge, unless the spell also names a buff.
			local durationIsBuff = not hasCharges or spell.buffId ~= nil or spell.isBuff == true
			if spell.duration ~= nil and durationIsBuff and not snapshot.buff.alwaysSimple then
				Add(kinds.buffTime, spell, name)
			end
			if spell.maxStacks ~= nil then
				Add(kinds.buffStacks, spell, name)
			end
			if hasCharges then
				Add(kinds.charges, spell, name)
				Add(kinds.rechargeTime, spell, name)
				-- The time until every charge is back needs a plain count, which only hand-counted charges have in combat.
				if snapshot.cooldown.useManualCharges == true and snapshot.cooldown.manualMaxCharges > 1 then
					Add(kinds.totalRechargeTime, spell, name)
				end
			elseif spell.hasCooldown == true then
				Add(kinds.cooldownTime, spell, name)
			end
		end
	end
	return sources
end

---Every source a specialization's bars can track, by label.
---@param classId integer?
---@param specId integer?
---@return TRB.Classes.CustomBarSourceOption[]
function CustomBars:GetSources(classId, specId)
	local sources = {}
	for name, provider in pairs(providers) do
		for _, source in ipairs(provider.GetSources(classId, specId)) do
			if name ~= self.defaultProvider then
				source.provider = name
			end
			sources[#sources + 1] = source
		end
	end
	table.sort(sources, function(a, b)
		if a.label ~= b.label then
			return a.label < b.label
		elseif a.spellId ~= b.spellId then
			return a.spellId < b.spellId
		end
		return (a.provider or "") < (b.provider or "")
	end)
	return sources
end

---@param classId integer?
---@param specId integer?
---@param source TRB.Classes.Settings.CustomBarSource
---@return string?
function snapshotProvider.GetSourceName(classId, specId, source)
	local snapshots = GetSnapshots(classId, specId)
	local snapshot = snapshots ~= nil and snapshots[source.spellId] or nil
	return snapshot ~= nil and snapshot.spell ~= nil and GetSpellName(snapshot.spell) or nil
end

---What a bar tracks and where that comes from, as the table and the closed dropdown show it.
---@param classId integer?
---@param specId integer?
---@param source TRB.Classes.Settings.CustomBarSource?
---@return string
function CustomBars:GetSourceLabel(classId, specId, source)
	if source == nil then
		return ""
	end
	local provider = ProviderOf(source)
	local name = provider ~= nil and provider.GetSourceName(classId, specId, source) or source.spellName
	local via = provider ~= nil and (provider.shortLabel or provider.label) or nil
	if via == nil then
		return string.format(L["CustomBarsSourceFormat"], name or tostring(source.spellId), kindLabels[source.kind] or "")
	end
	return string.format(L["CustomBarsSourceViaFormat"], name or tostring(source.spellId), kindLabels[source.kind] or "", via)
end

---A count source's maximum, when the snapshot knows it in plain form.
---@param kind trbCustomBarSourceKind
---@param snapshot TRB.Classes.Snapshot?
---@return integer?
local function GetCountMax(kind, snapshot)
	if snapshot == nil or snapshot.spell == nil then
		return nil
	end
	if kind == CustomBars.kinds.buffStacks then
		return snapshot.spell.maxStacks
	end
	local cooldown = snapshot.cooldown
	if cooldown.useManualCharges then
		return cooldown.manualMaxCharges
	end
	local max = cooldown.maxCharges
	if max ~= nil and not issecretvalue(max) and max > 0 then
		return max
	end
	return nil
end

---@param classId integer
---@param specId integer
---@param source TRB.Classes.Settings.CustomBarSource
---@return integer?
function snapshotProvider.ReadMax(classId, specId, source)
	local snapshots = GetSnapshots(classId, specId)
	return GetCountMax(source.kind, snapshots ~= nil and snapshots[source.spellId] or nil)
end

---A game-counted charge ability hasn't been read yet, and its maximum decides the bar's shape and default text.
---@param classId integer
---@param specId integer
---@param source TRB.Classes.Settings.CustomBarSource
function snapshotProvider.OnAdd(classId, specId, source)
	if source.kind ~= CustomBars.kinds.charges then
		return
	end
	local snapshots = GetSnapshots(classId, specId)
	local snapshot = snapshots ~= nil and snapshots[source.spellId] or nil
	if snapshot ~= nil and not snapshot.cooldown.useManualCharges then
		snapshot.cooldown:RefreshCharges()
	end
end

---Whether a count bar draws one node per stack or charge.
---@param bar TRB.Classes.Settings.CustomBar
---@param max integer
---@return boolean
function CustomBars:IsSegmented(bar, max)
	if not self:IsCountKind(bar.source.kind) then
		return false
	end
	if bar.segmented ~= nil then
		return bar.segmented == true
	end
	return max <= self.segmentedAutoMax
end

---@return table
local function DefaultColors()
	return TRB.Functions.Settings:DefaultCustomBarColors("FF00B4FF", "FF000000")
end

---Fills in whatever standard bar data a custom bar is missing, so a new or imported bar lays out.
---@param spec table
---@param key string
local function EnsureBarData(spec, key)
	local settings = TRB.Functions.Settings
	spec.bars = spec.bars or {}
	spec.colors = spec.colors or {}
	spec.colors.bars = spec.colors.bars or {}
	spec.displayBar = spec.displayBar or {}
	spec.textures = spec.textures or {}
	if spec.bars[key] == nil then
		spec.bars[key] = settings:DefaultCustomBarDimensions()
	end
	if spec.colors.bars[key] == nil then
		spec.colors.bars[key] = DefaultColors()
	end
	if spec.colors.bars[key].endCap == nil then
		spec.colors.bars[key].endCap = settings:DefaultEndCapColorEntry()
	end
	if spec.displayBar[key] == nil then
		spec.displayBar[key] = settings:DefaultUserBarVisibility()
	end
	local textures = spec.textures
	local keys = settings:GetTextureKeysForBar(key)
	if textures[keys.bar] == nil then
		-- A new bar starts with the main bar's textures, which the locks then keep matched.
		local defaults = settings:DefaultCustomBarTextures()
		textures[keys.bar] = textures.resourceBar or defaults.bar
		textures[keys.bar .. "Name"] = textures.resourceBarName or defaults.barName
		textures[keys.border] = textures.border or defaults.border
		textures[keys.border .. "Name"] = textures.borderName or defaults.borderName
		textures[keys.background] = textures.background or defaults.background
		textures[keys.background .. "Name"] = textures.backgroundName or defaults.backgroundName
	end
end

---Brings a bar's registry definition in line with its saved settings and the live maximum.
---@param bar TRB.Classes.Settings.CustomBar
---@param classId integer
---@param specId integer
---@return boolean created
local function SyncDefinition(bar, classId, specId)
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local key = CustomBars:GetBarKey(bar.guid)
	local kind = bar.source.kind
	local isCount = CustomBars:IsCountKind(kind)
	local max = 1
	if isCount then
		local provider = ProviderOf(bar.source)
		local read = provider ~= nil and provider.ReadMax(classId, specId, bar.source) or nil
		if read ~= nil then
			knownMax[key] = read
			bar.maxCount = read
		end
		-- Unread, as on a login in combat: the last one saved shapes the bar until it can be.
		max = read or knownMax[key] or bar.maxCount or 1
	end
	local segmented = CustomBars:IsSegmented(bar, max)

	local definition = registry:Get(key)
	local created = definition == nil
	if definition == nil then
		definition = TRB.Classes.BarTypeDefinition:New({
			key = key,
			isUserBar = true,
			ownerClassId = classId,
			ownerSpecId = specId,
			hasCustomThresholds = false,
			defaultDimensionsFunc = function(classic)
				return TRB.Functions.Settings:DefaultCustomBarDimensions(classic)
			end,
			defaultColorsFunc = DefaultColors,
			defaultTexturesFunc = function()
				return TRB.Functions.Settings:DefaultCustomBarTextures()
			end,
			onLayout = function(group)
				layoutVersions[group] = (layoutVersions[group] or 0) + 1
			end,
		})
		registry:Register(definition)
	end
	definition.displayName = bar.name
	definition.globalDisplayName = bar.name
	definition.isMultiNode = segmented
	definition.hasSpacing = segmented
	definition.maxNodes = segmented and max or 1
	definition.minMaxMode = segmented and "stepped" or "custom"
	definition.timerDrivenFill = not isCount
	definition.fillsRecharge = segmented and max > 1 and CustomBars:FillsRecharge(bar)
	definition.usesSecretValue = CustomBars:IsCooldownKind(kind)
	return created
end

---Whether the live bar list still describes the saved bars, so an unrelated settings change leaves it alone.
---@param bars table<string, TRB.Classes.Settings.CustomBar>?
---@return boolean
local function RuntimeMatches(bars)
	local count = 0
	if bars ~= nil then
		for guid, bar in pairs(bars) do
			if IsUsable(bar) then
				count = count + 1
				local entry = runtimeByKey[CustomBars:GetBarKey(guid)]
				if entry == nil or entry.bar ~= bar or entry.kind ~= bar.source.kind or entry.spellId ~= bar.source.spellId
					or entry.provider ~= ProviderOf(bar.source)
					or entry.fillRecharge ~= CustomBars:FillsRecharge(bar) then
					return false
				end
			end
		end
	end
	return count == #runtime
end

---The composite key of the specialization whose bars are drawn: the character's own, or the one a form shows instead.
---@return string?
local function GetDisplayedKey()
	local character = TRB.Data.character
	if character == nil or character.compositeKey == nil then
		return nil
	end
	-- Edit Mode and Preview Mode place the character's own bars, whatever its form.
	if TRB.Functions.EditMode:IsShowingAllBars() then
		return character.compositeKey
	end
	return TRB.Functions.Class:GetActiveDisplayCompositeKey() or character.compositeKey
end

---Whether a specialization's bars are the ones being drawn.
---@param classId integer?
---@param specId integer?
---@return boolean
function CustomBars:IsDisplayedSpec(classId, specId)
	if classId == nil or specId == nil then
		return false
	end
	local displayedKey = GetDisplayedKey()
	return displayedKey ~= nil and TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId) == displayedKey
end

---Registers a specialization's custom bars and drops the definitions of any it no longer has.
---@param classId integer?
---@param specId integer?
---@param spec table? # The specialization's saved settings
function CustomBars:SyncRegistry(classId, specId, spec)
	if classId == nil or specId == nil or spec == nil then
		return
	end
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local changed = false
	local seen = {}
	local bars = self:GetBars(spec)
	if bars ~= nil then
		for guid, bar in pairs(bars) do
			if IsUsable(bar) then
				bar.guid = guid
				bar.name = bar.name or ""
				local key = self:GetBarKey(guid)
				seen[key] = true
				EnsureBarData(spec, key)
				changed = SyncDefinition(bar, classId, specId) or changed
			end
		end
	end
	for key, definition in pairs(registry:GetAll()) do
		if definition.isUserBar and definition.ownerClassId == classId and definition.ownerSpecId == specId and not seen[key] then
			registry:Unregister(key)
			knownMax[key] = nil
			changed = true
		end
	end
	if changed then
		TRB.Functions.Settings:ResetTextureMedia()
		TRB.Functions.OptionsUi.Textures:ResetLockMembers()
	end
	if self:IsDisplayedSpec(classId, specId) and not RuntimeMatches(bars) then
		runtimeKey = nil
	end
end

---A specialization's saved bar text list, or an empty one.
---@param spec table
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function GetBarTextList(spec)
	return spec.displayText ~= nil and spec.displayText.barText or {}
end

---The label bar text bound to a bar is given, on the bar or on its recharging charge.
---@param name string
---@param onRechargingCharge boolean
---@return string
local function AnchorLabel(name, onRechargingCharge)
	return string.format(onRechargingCharge and L["CustomBarsRechargingAnchorLabel"] or L["CustomBarsAnchorLabel"], name)
end

---Adds a bar's default bar text.
---@param spec table
---@param bar TRB.Classes.Settings.CustomBar
local function AddDefaultText(spec, bar)
	if spec.displayText == nil or spec.displayText.barText == nil then
		return
	end
	local anchorName, variable, onRechargingCharge = GetDefaultText(bar)
	table.insert(spec.displayText.barText, TRB.Functions.Settings:LoadDefaultOtherBarTextSettings(anchorName, AnchorLabel(bar.name, onRechargingCharge),
		variable, "CENTER", onRechargingCharge and 12 or 14))
end

---Renames the anchor of every bar text entry bound to a bar, and the entry itself where it still carries the
---name it was given.
---@param spec table
---@param bar TRB.Classes.Settings.CustomBar
---@param oldName string
local function RelabelText(spec, bar, oldName)
	local key = CustomBars:GetBarKey(bar.guid)
	local anchorName, rechargingAnchorName = CustomBars:GetAnchorName(key), CustomBars:GetRechargingAnchorName(key)
	for _, entry in ipairs(GetBarTextList(spec)) do
		local position = entry.position
		local frame = position ~= nil and position.relativeToFrame or nil
		if frame == anchorName or frame == rechargingAnchorName then
			local label = AnchorLabel(bar.name, frame == rechargingAnchorName)
			if entry.name == AnchorLabel(oldName, false) or entry.name == AnchorLabel(oldName, true) then
				entry.name = label
			end
			position.relativeToFrameName = label
		end
	end
end

---Renames a bar, taking the names of the bar text bound to it along.
---@param spec table # The specialization's saved settings
---@param classId integer
---@param specId integer
---@param bar TRB.Classes.Settings.CustomBar
---@param name string
function CustomBars:Rename(spec, classId, specId, bar, name)
	local oldName = bar.name
	bar.name = name
	RelabelText(spec, bar, oldName)
	self:SyncRegistry(classId, specId, spec)
end

---Changes a bar's settings, then moves its default bar text along with what the change made the default, where
---that text is still as it was added.
---@param spec table # The specialization's saved settings
---@param classId integer
---@param specId integer
---@param bar TRB.Classes.Settings.CustomBar
---@param change fun(bar: TRB.Classes.Settings.CustomBar)
function CustomBars:Change(spec, classId, specId, bar, change)
	local oldAnchor, oldVariable = GetDefaultText(bar)
	local oldName = bar.name
	change(bar)
	self:SyncRegistry(classId, specId, spec)
	local newAnchor, newVariable = GetDefaultText(bar)
	if oldAnchor ~= newAnchor or oldVariable ~= newVariable then
		local oldText = DefaultTextOf(oldVariable)
		for _, entry in ipairs(GetBarTextList(spec)) do
			local position = entry.position
			if position ~= nil and position.relativeToFrame == oldAnchor and entry.text == oldText then
				entry.text = DefaultTextOf(newVariable)
				position.relativeToFrame = newAnchor
			end
		end
	end
	RelabelText(spec, bar, oldName)
end

---What a specialization's bar text list is after an import replaced it: imported text bound to a custom bar the
---specialization doesn't have is dropped, and its own text on a custom bar the import carried none for is kept.
---@param spec table # The merged specialization settings
---@param imported TRB.Classes.Settings.DisplayTextEntry[]
---@param own TRB.Classes.Settings.DisplayTextEntry[]? # The list the import replaces
---@return TRB.Classes.Settings.DisplayTextEntry[]
function CustomBars:ReconcileImportedText(spec, imported, own)
	local registry = TRB.Classes.BarTypeRegistry
	local keys = {}
	for guid in pairs(self:GetBars(spec) or {}) do
		keys[self:GetBarKey(guid)] = true
	end
	---@param entry any
	---@return string?
	local function UserBarKeyOf(entry)
		local position = type(entry) == "table" and entry.position or nil
		local key = type(position) == "table" and TRB.Functions.BarText:GetAnchorBarKey(position.relativeToFrame) or nil
		return registry:IsUserBar(key) and key or nil
	end
	local result = {}
	local carried = {}
	for _, entry in ipairs(imported) do
		local key = UserBarKeyOf(entry)
		if key == nil or keys[key] then
			result[#result + 1] = entry
			if key ~= nil then
				carried[key] = true
			end
		end
	end
	for _, entry in ipairs(own or {}) do
		local key = UserBarKeyOf(entry)
		if key ~= nil and keys[key] and not carried[key] then
			result[#result + 1] = entry
		end
	end
	return result
end

---Adds a bar to a specialization's saved settings.
---@param spec table # The specialization's saved settings
---@param classId integer
---@param specId integer
---@param source TRB.Classes.CustomBarSourceOption
---@return string guid
function CustomBars:Add(spec, classId, specId, source)
	spec.customBars = spec.customBars or {}
	spec.customBars.bars = spec.customBars.bars or {}
	local guid = TRB.Functions.String:Guid()
	spec.customBars.bars[guid] = {
		guid = guid,
		name = source.spellName,
		source = { kind = source.kind, spellId = source.spellId, spellName = source.spellName, provider = source.provider },
	}
	local provider = ProviderOf(spec.customBars.bars[guid].source)
	if provider ~= nil and provider.OnAdd ~= nil then
		provider.OnAdd(classId, specId, spec.customBars.bars[guid].source)
	end
	self:SyncRegistry(classId, specId, spec)
	AddDefaultText(spec, spec.customBars.bars[guid])
	return guid
end

---Changes what a bar tracks. A name and default bar text still following the old source follow the new one.
---@param spec table # The specialization's saved settings
---@param classId integer
---@param specId integer
---@param bar TRB.Classes.Settings.CustomBar
---@param source TRB.Classes.CustomBarSourceOption
function CustomBars:SetSource(spec, classId, specId, bar, source)
	self:Change(spec, classId, specId, bar, function()
		if bar.name == bar.source.spellName then
			bar.name = source.spellName
		end
		bar.source = { kind = source.kind, spellId = source.spellId, spellName = source.spellName, provider = source.provider }
		bar.segmented = nil
	end)
end

---Deletes a bar and its standard bar data from a specialization's saved settings.
---@param spec table # The specialization's saved settings
---@param classId integer
---@param specId integer
---@param guid string
function CustomBars:Delete(spec, classId, specId, guid)
	local bars = self:GetBars(spec)
	if bars == nil or bars[guid] == nil then
		return
	end
	local key = self:GetBarKey(guid)
	bars[guid] = nil
	if spec.bars ~= nil then
		spec.bars[key] = nil
	end
	if spec.colors ~= nil and spec.colors.bars ~= nil then
		spec.colors.bars[key] = nil
	end
	if spec.displayBar ~= nil then
		spec.displayBar[key] = nil
	end
	if spec.textures ~= nil then
		for _, textureKey in ipairs(TRB.Functions.Settings:GetTextureKeysForBar(key).all) do
			spec.textures[textureKey] = nil
			spec.textures[textureKey .. "Name"] = nil
		end
		if spec.textures.useGlobal ~= nil then
			spec.textures.useGlobal[key] = nil
		end
	end
	local barText = GetBarTextList(spec)
	local anchorName, rechargingAnchorName = self:GetAnchorName(key), self:GetRechargingAnchorName(key)
	for index = #barText, 1, -1 do
		local position = barText[index].position
		if position ~= nil and (position.relativeToFrame == anchorName or position.relativeToFrame == rechargingAnchorName) then
			table.remove(barText, index)
		end
	end
	self:SyncRegistry(classId, specId, spec)
end

---A specialization's saved settings.
---@param compositeKey string?
---@return table?
local function GetSavedSpec(compositeKey)
	if compositeKey == nil or TRB.Data.settings == nil then
		return nil
	end
	local entry = TRB.Functions.Character:GetSpecRegistryEntry(compositeKey)
	if entry == nil then
		return nil
	end
	local classSettings = TRB.Data.settings[entry.className]
	return classSettings ~= nil and classSettings[entry.specName] or nil
end

---The bar text bound to the displayed bars while a form shows another specialization's, which the character's own
---list doesn't hold.
---@return TRB.Classes.Settings.DisplayTextEntry[]?
function CustomBars:GetDisplayedBoundText()
	local displayedKey = GetDisplayedKey()
	if displayedKey == nil or displayedKey == TRB.Data.character.compositeKey then
		return nil
	end
	local spec = GetSavedSpec(displayedKey)
	local bars = self:GetBars(spec)
	if spec == nil or bars == nil or next(bars) == nil then
		return nil
	end
	local keys = {}
	for guid in pairs(bars) do
		keys[self:GetBarKey(guid)] = true
	end
	local bound = {}
	for _, entry in ipairs(GetBarTextList(spec)) do
		local barKey = entry.position ~= nil and TRB.Functions.BarText:GetAnchorBarKey(entry.position.relativeToFrame) or nil
		if barKey ~= nil and keys[barKey] then
			bound[#bound + 1] = entry
		end
	end
	return bound
end

---Rebuilds the displayed spec's bar list after its settings, the spec, or the form changed.
---@return boolean rebuilt
local function EnsureRuntime()
	local compositeKey = GetDisplayedKey()
	if compositeKey == nil or runtimeKey == compositeKey then
		return false
	end
	runtimeKey = compositeKey
	local hadCooldowns = runtimeHasCooldowns
	runtimeHasCooldowns = false
	anyTimerActive = false
	wipe(runtime)
	wipe(runtimeByKey)
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local bars = CustomBars:GetBars(GetSavedSpec(compositeKey))
	local boundBars = {}
	if bars ~= nil then
		for guid, bar in pairs(bars) do
			local key = CustomBars:GetBarKey(guid)
			local definition = registry:Get(key)
			local provider = definition ~= nil and IsUsable(bar) and ProviderOf(bar.source) or nil
			if provider ~= nil then
				local kind = bar.source.kind
				---@type TRB.Classes.CustomBarRuntime
				local entry = {
					key = key,
					bar = bar,
					definition = definition,
					provider = provider,
					kind = kind,
					spellId = bar.source.spellId,
					isTimer = not CustomBars:IsCountKind(kind),
					fillRecharge = CustomBars:FillsRecharge(bar),
					timeVar = "$" .. key .. "Time",
					stacksVar = "$" .. key .. "Stacks",
					stacksMaxVar = "$" .. key .. "StacksMax",
					active = false,
				}
				runtime[#runtime + 1] = entry
				runtimeByKey[key] = entry
				runtimeHasCooldowns = runtimeHasCooldowns or CustomBars:IsCooldownKind(kind)
				-- A bare check asks whether there is a value at all.
				boundBars[#boundBars + 1] = { key = key, resolvers = {
					Time = function() return (entry.isTimer and entry.active) or entry.recharging == true end,
					Stacks = function() return not entry.isTimer and entry.active end,
					StacksMax = function() return not entry.isTimer and (knownMax[key] or bar.maxCount) ~= nil end,
				} }
			end
		end
	end
	if #boundBars > 0 or runtimeHasBoundVariables then
		runtimeHasBoundVariables = #boundBars > 0
		TRB.Functions.BarText:SetBoundBarVariables(boundBars)
	end
	pendingCooldownSync = pendingCooldownSync or hadCooldowns or runtimeHasCooldowns
	-- The buffs followed by spell ID are read from the bar list.
	pendingAuraSync = TRB.Flavor.playerAuras == true
	pendingVisibility = true
	pendingGroups = true
	pendingAppearance = #runtime > 0
	return true
end

---The displayed spec's bars, for the bar groups and anchor lists.
---@return TRB.Classes.CustomBarRuntime[]
function CustomBars:GetRuntime()
	EnsureRuntime()
	return runtime
end

---Records that a layout pass has brought the bar groups in line with the bar list.
function CustomBars:GroupsBuilt()
	pendingGroups = false
end

---The settings the displayed bars lay out and draw with: their own specialization's.
---@return table?
function CustomBars:GetDisplayedSettings()
	EnsureRuntime()
	local cache = runtimeKey ~= nil and TRB.Data.specCache ~= nil and TRB.Data.specCache[runtimeKey] or nil
	return cache ~= nil and cache.settings or nil
end

---Whether a timer bar is running, which keeps bar text counting down while nothing else changes.
---@return boolean
function CustomBars:HasActiveTimer()
	return anyTimerActive
end

---A count source's current stacks or charges, which can be secret for charges.
---@param kind trbCustomBarSourceKind
---@param snapshot TRB.Classes.Snapshot
---@param now number
---@return number
local function ReadCount(kind, snapshot, now)
	if kind == CustomBars.kinds.buffStacks then
		local buff = snapshot.buff
		-- A paused buff or one with no timer has no end to have passed.
		if buff.isActive == true and (buff.isPaused or buff.currentlySimple or buff.endTime == nil or buff.endTime == 0 or buff.endTime > now) then
			return buff.applications or 0
		end
		return 0
	end
	if snapshot.cooldown.useManualCharges then
		return snapshot.cooldown.manualCharges
	end
	-- Only the nil check: a secret count can't be tested for truth.
	local charges = snapshot.cooldown.charges
	if charges == nil then
		return 0
	end
	return charges
end

---A bar's time, stacks, and maximum stacks as text. A secret time or count is only ever formatted.
---@param entry TRB.Classes.CustomBarRuntime
---@param now number
---@return string timeText
---@return string stacksText
---@return string stacksMaxText
---@param snapshot TRB.Classes.Snapshot?
local function LookupSnapshot(entry, now, snapshot)
	local kinds = CustomBars.kinds
	local timeText, stacksText, stacksMaxText = "", "", ""
	if snapshot ~= nil then
		if not entry.isTimer then
			stacksText = TRB.Functions.Number:RoundTo(ReadCount(entry.kind, snapshot, now), 0)
			local max = knownMax[entry.key] or entry.bar.maxCount
			if max ~= nil then
				stacksMaxText = tostring(max)
			end
			-- A charges bar's time is its next charge's recharge.
			if entry.recharging then
				local cooldown = snapshot.cooldown
				if cooldown.useManualCharges then
					timeText = TRB.Functions.BarText:TimerPrecision((cooldown.manualCooldownExpires or now) - now)
				elseif cooldown.rechargeDurationObject ~= nil then
					timeText = TRB.Functions.BarText:TimerPrecision(cooldown.rechargeDurationObject:GetRemainingDuration())
				end
			end
		elseif entry.active and entry.pausedRemaining ~= nil then
			timeText = TRB.Functions.BarText:TimerPrecision(entry.pausedRemaining)
		elseif entry.active and entry.endTime ~= nil then
			-- A plain timer, which only the hand-tracked sources have.
			timeText = TRB.Functions.BarText:TimerPrecision(entry.endTime - now)
		elseif entry.active then
			local durationObject = nil
			if entry.kind == kinds.cooldownTime then
				durationObject = snapshot.cooldown:GetDurationObject()
			elseif entry.kind == kinds.rechargeTime then
				durationObject = snapshot.cooldown.rechargeDurationObject
			end
			if durationObject ~= nil then
				timeText = TRB.Functions.BarText:TimerPrecision(durationObject:GetRemainingDuration())
			end
		end
	end
	return timeText, stacksText, stacksMaxText
end

---@param entry TRB.Classes.CustomBarRuntime
---@param now number
---@return string timeText
---@return string stacksText
---@return string stacksMaxText
function snapshotProvider.WriteLookup(entry, now)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	return LookupSnapshot(entry, now, snapshotData ~= nil and snapshotData.snapshots[entry.spellId] or nil)
end

---Writes each bar's own bar text variables.
---@param lookup table<string, any>
function CustomBars:WriteLookup(lookup)
	local now = GetTime()
	for _, entry in ipairs(runtime) do
		lookup[entry.timeVar], lookup[entry.stacksVar], lookup[entry.stacksMaxVar] = entry.provider.WriteLookup(entry, now)
	end
end

---Whether a class module times a spell's cooldown itself, which the cooldown tracker would overwrite.
---@param snapshot TRB.Classes.Snapshot
---@return boolean
local function IsHandTimed(snapshot)
	return snapshot.cooldown.useManualCharges == true or (snapshot.spell ~= nil and snapshot.spell.attributes.handTimedCooldown == true)
end

---@param entry TRB.Classes.CustomBarRuntime
---@param spells TRB.Classes.SpellBase[]
function snapshotProvider.AppendCooldownSpell(entry, spells)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	local snapshots = snapshotData ~= nil and snapshotData.snapshots or nil
	local source = entry.bar.source
	local snapshot = snapshots ~= nil and CustomBars:IsCooldownKind(source.kind) and snapshots[source.spellId] or nil
	-- A cooldown a class module counts or times by hand is its own to keep.
	if snapshot ~= nil and snapshot.spell ~= nil and not IsHandTimed(snapshot) then
		spells[#spells + 1] = snapshot.spell
	end
end

---Appends the spells whose cooldowns the displayed bars read, for the cooldown tracker.
---@param spells TRB.Classes.SpellBase[]
---@param ownSnapshots table<TRB.Classes.SpellBase, TRB.Classes.Snapshot>? # Filled with the snapshots the spec doesn't hold
function CustomBars:AppendCooldownSpells(spells, ownSnapshots)
	EnsureRuntime()
	if not runtimeHasCooldowns then
		return
	end
	for _, entry in ipairs(runtime) do
		if entry.provider.AppendCooldownSpell ~= nil then
			entry.provider.AppendCooldownSpell(entry, spells, ownSnapshots)
		end
	end
end

---Appends the displayed custom bars to a visibility pass, each carrying whether it is active for When Active.
---@param entries TRB.Classes.BarVisibilityEntry[]
---@param barGroups table<string, TRB.Classes.BarGroup>?
function CustomBars:AppendVisibilityEntries(entries, barGroups)
	EnsureRuntime()
	if #runtime == 0 or barGroups == nil then
		return
	end
	local settings = self:GetDisplayedSettings()
	local displayBar = settings ~= nil and settings.displayBar or nil
	for _, entry in ipairs(runtime) do
		TRB.Functions.BarVisibility:AddEntry(entries, barGroups[entry.key], displayBar and displayBar[entry.key], true,
			entry.definition.maxNodes, nil)
		entries[#entries].isActive = entry.active
	end
end

---Empties a node whose source isn't running.
---@param node TRB.Classes.BarNode
local function ClearNode(node)
	node:ClearTimerDuration()
	node:SetMinMax(0, 1)
	node:SetValue(0, false)
end

---Draws a timer bar from a duration object, binding it only when the timer changed.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param rebind boolean
---@param durationObject any?
local function RenderTimer(entry, node, rebind, durationObject)
	if not rebind then
		return
	end
	if entry.active and durationObject ~= nil then
		node:SetMinMax(0, 1)
		node:SetTimerDuration(durationObject, Enum.StatusBarInterpolation.Immediate, Enum.StatusBarTimerDirection.RemainingTime)
	else
		ClearNode(node)
	end
end

---Draws a timer whose end and length are plain numbers: a hand-tracked buff, or a recharge a class module counts.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param running boolean
---@param endTime number?
---@param duration number?
---@param now number
---@param redraw boolean
local function RenderPlainTimer(entry, node, running, endTime, duration, now, redraw)
	entry.active = running and endTime ~= nil and endTime > now and duration ~= nil and duration > 0
	local wasBound = entry.endTime ~= nil
	local rebind = redraw or wasBound ~= entry.active or (entry.active and (entry.endTime ~= endTime or entry.duration ~= duration))
	if not rebind then
		return
	end
	entry.endTime = entry.active and endTime or nil
	entry.duration = entry.active and duration or nil
	local durationObject = nil
	if entry.active then
		durationObject = C_DurationUtil.CreateDuration()
		if durationObject ~= nil then
			durationObject:SetTimeSpan(endTime - duration, endTime)
		end
	end
	RenderTimer(entry, node, true, durationObject)
end

---Holds a paused buff's bar at its frozen time.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param buff TRB.Classes.SnapshotBuff
---@param redraw boolean
local function RenderPausedTimer(entry, node, buff, redraw)
	local remaining = buff.previousRemaining or 0
	entry.active = true
	if not redraw and entry.pausedRemaining == remaining then
		return
	end
	entry.pausedRemaining = remaining
	entry.endTime = nil
	entry.duration = nil
	node:ClearTimerDuration()
	node:SetMinMax(0, math.max(buff.duration or 0, remaining, 1))
	node:SetValue(remaining, false)
	TRB.Data.lookupDirty = true
end

---Draws a charge ability's running recharge.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param cooldown TRB.Classes.SnapshotCooldown
---@param now number
---@param redraw boolean
local function RenderRechargeTime(entry, node, cooldown, now, redraw)
	if cooldown.useManualCharges then
		RenderPlainTimer(entry, node, cooldown.manualCharges < cooldown.manualMaxCharges, cooldown.manualCooldownExpires,
			cooldown.manualCooldownDuration, now, redraw)
		return
	end
	entry.active = cooldown.isActive == true
	local rebind = redraw or entry.version ~= cooldown.version
	entry.version = cooldown.version
	RenderTimer(entry, node, rebind, entry.active and cooldown.rechargeDurationObject or nil)
end

---Draws the time until a hand-counted charge ability has every charge back, against a full set's recharge.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param cooldown TRB.Classes.SnapshotCooldown
---@param now number
---@param redraw boolean
local function RenderTotalRechargeTime(entry, node, cooldown, now, redraw)
	local endTime, duration = nil, nil
	local missing = 0
	if cooldown.useManualCharges then
		local recharge = cooldown.manualRechargeDuration or cooldown.manualCooldownDuration
		missing = cooldown.manualMaxCharges - cooldown.manualCharges
		if missing > 0 and cooldown.manualCooldownExpires ~= nil and recharge ~= nil then
			-- The running recharge, then a full one for each charge queued behind it.
			endTime = cooldown.manualCooldownExpires + (missing - 1) * recharge
			duration = cooldown.manualMaxCharges * recharge
		end
	end
	RenderPlainTimer(entry, node, missing > 0, endTime, duration, now, redraw)
end

---Whether a charge ability's next charge is recharging.
---@param cooldown TRB.Classes.SnapshotCooldown
---@param now number
---@return boolean
local function IsRecharging(cooldown, now)
	if cooldown.useManualCharges then
		return cooldown.manualCharges < cooldown.manualMaxCharges and cooldown.manualCooldownExpires ~= nil
			and cooldown.manualCooldownExpires > now
	end
	return cooldown.isActive == true
end

---The duration object a charges bar's recharge fill runs on: the game's, or one built from a hand-counted recharge.
---@param entry TRB.Classes.CustomBarRuntime
---@param cooldown TRB.Classes.SnapshotCooldown
---@return any?
local function GetRechargeObject(entry, cooldown)
	if not entry.recharging then
		entry.rechargeEnd, entry.rechargeLength, entry.rechargeObject = nil, nil, nil
		return nil
	end
	if not cooldown.useManualCharges then
		return cooldown.rechargeDurationObject
	end
	local expires, length = cooldown.manualCooldownExpires, cooldown.manualCooldownDuration
	if length == nil or length <= 0 then
		return nil
	end
	-- The same object while the recharge is unchanged, so the fill isn't bound again every tick.
	if entry.rechargeEnd ~= expires or entry.rechargeLength ~= length then
		local object = C_DurationUtil.CreateDuration()
		if object ~= nil then
			object:SetTimeSpan(expires - length, expires)
		end
		entry.rechargeEnd, entry.rechargeLength, entry.rechargeObject = expires, length, object
	end
	return entry.rechargeObject
end

---Draws a segmented charges bar's recharging charge through the group's charge tracker, which lands the fill on
---the charge after the count without reading a secret one.
---@param entry TRB.Classes.CustomBarRuntime
---@param group TRB.Classes.BarGroup
---@param settings table # The spec cache settings
---@param count number
---@param recharge any? # The recharge's duration object, or nil with nothing recharging
---@param redraw boolean
---@param changed boolean # Whether a secret count may have changed since it was last written
local function RenderRechargeFill(entry, group, settings, count, recharge, redraw, changed)
	local isSecret = issecretvalue(count)
	if redraw or (isSecret and (changed or entry.trackerCount ~= nil)) or (not isSecret and entry.trackerCount ~= count) then
		entry.trackerCount = not isSecret and count or nil
		group:SetChargeTrackerValue(count)
	end
	local colors = settings.colors ~= nil and settings.colors.bars ~= nil and settings.colors.bars[entry.key] or nil
	local fill = colors ~= nil and colors.bar or nil
	local texture = settings.textures ~= nil and settings.textures[entry.key .. "Bar"] or nil
	if fill ~= nil and (redraw or entry.fillTexture ~= texture or entry.fillColor ~= fill.color or entry.fillColor2 ~= fill.color2
		or entry.fillGradient ~= fill.gradientDirection) then
		entry.fillTexture, entry.fillColor, entry.fillColor2, entry.fillGradient = texture, fill.color, fill.color2, fill.gradientDirection
		-- A new table each time: the tracker keeps the one it was last given.
		local rechargeColors = {}
		for i = 1, group.nodeCount do
			rechargeColors[i] = fill
		end
		entry.rechargeColors = rechargeColors
		group:SetChargeRechargeAppearance(texture, rechargeColors)
	end
	if redraw or entry.boundRecharge ~= recharge then
		entry.boundRecharge = recharge
		group:SetChargeRechargeDuration(recharge)
	end
end

---Draws a tracked cooldown's remaining time.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param cooldown TRB.Classes.SnapshotCooldown
---@param redraw boolean
local function RenderCooldownTime(entry, node, cooldown, redraw)
	entry.active = cooldown.onCooldown == true
	local rebind = redraw or entry.version ~= cooldown.version
	entry.version = cooldown.version
	RenderTimer(entry, node, rebind, entry.active and cooldown:GetDurationObject() or nil)
end

---Draws a count across a group's nodes through SetBarNodeValue, which also keeps the End Cap on the highest
---filled node. A secret count can't be compared, so it is written when its cooldown reports a change.
---@param entry TRB.Classes.CustomBarRuntime
---@param group TRB.Classes.BarGroup
---@param settings table # The spec cache settings
---@param count number
---@param max integer
---@param redraw boolean
---@param changed boolean # Whether a secret count may have changed since it was last written
local function RenderCount(entry, group, settings, count, max, redraw, changed)
	local isSecret = issecretvalue(count)
	entry.active = isSecret or count > 0
	if not redraw and entry.max == max then
		if isSecret then
			-- A plain count held from before means the secret one hasn't been written yet.
			if not changed and entry.count == nil then
				return
			end
		elseif entry.count == count then
			return
		end
	end
	entry.count = not isSecret and count or nil
	entry.max = max
	-- A secret count's change comes with a charge event, which marks the bar text itself.
	if not isSecret then
		TRB.Data.lookupDirty = true
	end
	local nodeKeys = entry.nodeKeys
	if nodeKeys == nil then
		nodeKeys = {}
		entry.nodeKeys = nodeKeys
	end
	if entry.definition.isMultiNode then
		-- Stepped nodes: each takes the same count, scaled 1:1 against its own step's top.
		for i = 1, group.nodeCount do
			local node = group.nodes[i]
			if node ~= nil then
				if nodeKeys[i] == nil then
					nodeKeys[i] = entry.key .. "_" .. i
				end
				TRB.Functions.Bar:SetBarNodeValue(settings, nodeKeys[i], node, count, i)
			end
		end
		return
	end
	local node = group.nodes[1]
	if node ~= nil then
		node:SetMinMax(0, max)
		TRB.Functions.Bar:SetBarNodeValue(settings, entry.key, node, count, max)
	end
end

---Applies a newly learned maximum to a count bar's definition, and reports that the bars need laying out again.
---@param entry TRB.Classes.CustomBarRuntime
---@param max integer
---@return boolean
local function ApplyLiveMax(entry, max)
	local definition = entry.definition
	knownMax[entry.key] = max
	entry.bar.maxCount = max
	local segmented = CustomBars:IsSegmented(entry.bar, max)
	local nodes = segmented and max or 1
	definition.fillsRecharge = segmented and max > 1 and entry.fillRecharge
	if definition.isMultiNode == segmented and definition.maxNodes == nodes then
		return false
	end
	definition.isMultiNode = segmented
	definition.hasSpacing = segmented
	definition.maxNodes = nodes
	definition.minMaxMode = segmented and "stepped" or "custom"
	return true
end

---Draws a bar from a snapshot of its spell.
---@param entry TRB.Classes.CustomBarRuntime
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode
---@param settings table # The spec cache settings
---@param now number
---@param redraw boolean
---@param snapshot TRB.Classes.Snapshot?
---@return boolean needsLayout
local function RenderSnapshot(entry, group, node, settings, now, redraw, snapshot)
	local kinds = CustomBars.kinds
	local source = entry.bar.source
	local needsLayout = false
	if snapshot == nil then
		entry.active = false
		if redraw then
			ClearNode(node)
		end
	elseif source.kind == kinds.buffTime and snapshot.buff.isPaused and snapshot.buff.isActive == true then
		RenderPausedTimer(entry, node, snapshot.buff, redraw)
	elseif source.kind == kinds.buffTime then
		local buff = snapshot.buff
		-- Leaving a pause: the timer has to be bound again.
		if entry.pausedRemaining ~= nil then
			entry.pausedRemaining = nil
			redraw = true
		end
		RenderPlainTimer(entry, node, buff.isActive == true, buff.endTime, buff.duration, now, redraw)
	elseif source.kind == kinds.cooldownTime and snapshot.cooldown.useManualCharges then
		-- A cooldown its class module counts by hand runs on the hand-counted recharge.
		RenderRechargeTime(entry, node, snapshot.cooldown, now, redraw)
	elseif source.kind == kinds.cooldownTime and IsHandTimed(snapshot) then
		local cooldown = snapshot.cooldown
		local started, length = cooldown.startTime, cooldown.duration
		local timed = started ~= nil and length ~= nil and length > 0
		RenderPlainTimer(entry, node, timed, timed and started + length or nil, length, now, redraw)
	elseif source.kind == kinds.cooldownTime then
		RenderCooldownTime(entry, node, snapshot.cooldown, redraw)
	elseif source.kind == kinds.rechargeTime then
		RenderRechargeTime(entry, node, snapshot.cooldown, now, redraw)
	elseif source.kind == kinds.totalRechargeTime then
		RenderTotalRechargeTime(entry, node, snapshot.cooldown, now, redraw)
	else
		local count = ReadCount(source.kind, snapshot, now)
		local max = GetCountMax(source.kind, snapshot)
		if max ~= nil then
			needsLayout = ApplyLiveMax(entry, max)
		end
		-- The cooldown tracker's version moves with every charge gained or spent.
		local changed = entry.version ~= snapshot.cooldown.version
		entry.version = snapshot.cooldown.version
		RenderCount(entry, group, settings, count, max or knownMax[entry.key] or entry.bar.maxCount or 1, redraw, changed)
		if source.kind == kinds.charges then
			local recharging = IsRecharging(snapshot.cooldown, now)
			if entry.recharging ~= recharging then
				entry.recharging = recharging
				TRB.Data.lookupDirty = true
			end
			if group.chargeTracker ~= nil then
				local recharge = entry.fillRecharge and GetRechargeObject(entry, snapshot.cooldown) or nil
				RenderRechargeFill(entry, group, settings, count, recharge, redraw, changed)
				-- A bar with no charges left still has something to show while one recharges.
				entry.active = entry.active or recharge ~= nil
			end
		end
	end
	return needsLayout
end

---@param entry TRB.Classes.CustomBarRuntime
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode
---@param settings table # The spec cache settings
---@param now number
---@param redraw boolean
---@return boolean needsLayout
function snapshotProvider.Render(entry, group, node, settings, now, redraw)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	return RenderSnapshot(entry, group, node, settings, now, redraw, snapshotData ~= nil and snapshotData.snapshots[entry.bar.source.spellId] or nil)
end

-- An ability by the spell ID the user typed, read through a snapshot of its own.
CustomBars.spellProvider = "spell"

-- Kept apart for a spell read with and without charges, since a talent can give it charges.
---@type table<boolean, table<integer, TRB.Classes.Snapshot>>
local spellSnapshots = { [true] = {}, [false] = {} }

---@param source TRB.Classes.Settings.CustomBarSource
---@return TRB.Classes.Snapshot
local function GetSpellSnapshot(source)
	local hasCharges = source.kind ~= CustomBars.kinds.cooldownTime
	local snapshot = spellSnapshots[hasCharges][source.spellId]
	if snapshot == nil then
		-- A spell with no global cooldown never reads as off it at its cast, so the tracker has to be told.
		local _, globalCooldown = GetSpellBaseCooldown(source.spellId)
		local spell = TRB.Classes.SpellBase:New({
			id = source.spellId,
			hasCooldown = true,
			hasCharges = hasCharges,
			offGcd = globalCooldown == 0
		})
		snapshot = TRB.Classes.Snapshot:New(spell)
		spellSnapshots[hasCharges][source.spellId] = snapshot
	end
	return snapshot
end

---What the client says an ability can be tracked as: its charges and recharge, or its cooldown.
---@param spellId integer
---@return TRB.Classes.CustomBarSourceOption[]
function CustomBars:GetSpellIdSources(spellId)
	local sources = {}
	local name = C_Spell.GetSpellName(spellId)
	if name == nil then
		return sources
	end
	local kinds = self.kinds
	local texture = C_Spell.GetSpellTexture(spellId)
	local offered = {}
	if C_Spell.GetSpellCharges(spellId) ~= nil then
		offered = { kinds.charges, kinds.rechargeTime }
	elseif (GetSpellBaseCooldown(spellId) or 0) > 0 then
		offered = { kinds.cooldownTime }
	end
	for _, kind in ipairs(offered) do
		sources[#sources + 1] = {
			kind = kind,
			spellId = spellId,
			spellName = name,
			icon = texture ~= nil and string.format("|T%s:0|t", texture) or nil,
			label = string.format(L["CustomBarsSourceFormat"], name, kindLabels[kind]),
			provider = self.spellProvider,
		}
	end
	return sources
end

---@type TRB.Classes.CustomBarProvider
local spellProvider = {
	label = L["CustomBarsAddGroupSpellId"],
	shortLabel = L["CustomBarsProviderShortSpellId"],
	promptText = L["CustomBarsSpellIdPromptText"],
	noSourcesText = L["CustomBarsSpellIdNoCooldown"],
	GetIdSources = function(spellId)
		return CustomBars:GetSpellIdSources(spellId)
	end,
	-- The abilities this specialization's bars already name, so a bar can change what it tracks of one.
	GetSources = function(classId, specId)
		local sources = {}
		local compositeKey = classId ~= nil and specId ~= nil and TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId) or nil
		local seen = {}
		for _, bar in pairs(CustomBars:GetBars(GetSavedSpec(compositeKey)) or {}) do
			local source = type(bar) == "table" and bar.source or nil
			if type(source) == "table" and source.provider == CustomBars.spellProvider and type(source.spellId) == "number" and not seen[source.spellId] then
				seen[source.spellId] = true
				for _, option in ipairs(CustomBars:GetSpellIdSources(source.spellId)) do
					sources[#sources + 1] = option
				end
			end
		end
		return sources
	end,
	GetSourceName = function(_, _, source)
		return C_Spell.GetSpellName(source.spellId)
	end,
	ReadMax = function(_, _, source)
		local charges = source.kind == CustomBars.kinds.charges and C_Spell.GetSpellCharges(source.spellId) or nil
		local max = charges ~= nil and charges.maxCharges or nil
		if max ~= nil and not issecretvalue(max) and max > 0 then
			return max
		end
		return nil
	end,
	OnAdd = function(_, _, source)
		if source.kind == CustomBars.kinds.charges then
			GetSpellSnapshot(source).cooldown:RefreshCharges()
		end
	end,
	AppendCooldownSpell = function(entry, spells, ownSnapshots)
		local snapshot = GetSpellSnapshot(entry.bar.source)
		spells[#spells + 1] = snapshot.spell
		if ownSnapshots ~= nil then
			ownSnapshots[snapshot.spell] = snapshot
		end
	end,
	WriteLookup = function(entry, now)
		return LookupSnapshot(entry, now, GetSpellSnapshot(entry.bar.source))
	end,
	Render = function(entry, group, node, settings, now, redraw)
		return RenderSnapshot(entry, group, node, settings, now, redraw, GetSpellSnapshot(entry.bar.source))
	end,
}
CustomBars:RegisterProvider(CustomBars.spellProvider, spellProvider)

---The providers that take a spell ID the user types, in menu order.
---@return string[]
function CustomBars:GetTypedProviders()
	local names = {}
	for name, provider in pairs(providers) do
		if provider.GetIdSources ~= nil then
			names[#names + 1] = name
		end
	end
	table.sort(names, function(a, b)
		return providers[a].label < providers[b].label
	end)
	return names
end

---What a typed spell ID can be tracked as through a provider, and that provider's prompt and no-source texts.
---@param name string
---@param spellId integer?
---@return TRB.Classes.CustomBarSourceOption[] sources
---@return string? promptText
---@return string? noSourcesText
function CustomBars:GetTypedSources(name, spellId)
	local provider = providers[name]
	if provider == nil or provider.GetIdSources == nil then
		return {}, nil, nil
	end
	return spellId ~= nil and provider.GetIdSources(spellId) or {}, provider.promptText, provider.noSourcesText
end

-- A buff by the spell ID the user typed, where the player's auras are never secret. Any rank and any caster count.
CustomBars.auraProvider = "aura"

---What the client says a buff can be tracked as: its duration, and its stacks when it stacks.
---@param spellId integer
---@return TRB.Classes.CustomBarSourceOption[]
function CustomBars:GetAuraIdSources(spellId)
	local sources = {}
	local name = C_Spell.GetSpellName(spellId)
	if name == nil then
		return sources
	end
	local kinds = self.kinds
	local texture = C_Spell.GetSpellTexture(spellId)
	local offered = { kinds.buffTime }
	if (C_Spell.GetSpellMaxCumulativeAuraApplications(spellId) or 0) > 1 then
		offered[#offered + 1] = kinds.buffStacks
	end
	for _, kind in ipairs(offered) do
		sources[#sources + 1] = {
			kind = kind,
			spellId = spellId,
			spellName = name,
			icon = texture ~= nil and string.format("|T%s:0|t", texture) or nil,
			label = string.format(L["CustomBarsSourceFormat"], name, kindLabels[kind]),
			provider = self.auraProvider,
		}
	end
	return sources
end

---Appends the spell IDs of the auras the displayed bars follow, for the aura reader: a harmful spell's is the
---player's debuff on the target, any other a buff on the player.
---@param buffSpellIds integer[]
---@param debuffSpellIds integer[]
function CustomBars:AppendAuraSpellIds(buffSpellIds, debuffSpellIds)
	EnsureRuntime()
	for _, entry in ipairs(runtime) do
		if entry.bar.source.provider == self.auraProvider then
			if C_Spell.IsSpellHarmful(entry.spellId) == true then
				debuffSpellIds[#debuffSpellIds + 1] = entry.spellId
			else
				buffSpellIds[#buffSpellIds + 1] = entry.spellId
			end
		end
	end
end

---A followed buff's stacks: a buff that doesn't stack counts as one while it is up.
---@param entry TRB.Classes.CustomBarRuntime
---@return number
local function ReadAuraCount(entry)
	local isActive, _, _, applications = TRB.Functions.Aura:GetFollowedAura(entry.spellId)
	if not isActive then
		return 0
	end
	return math.max(applications, 1)
end

---Holds a typed buff that has no duration, such as a stance or form, full while it is up.
---@param entry TRB.Classes.CustomBarRuntime
---@param node TRB.Classes.BarNode
---@param redraw boolean
local function RenderUntimedTimer(entry, node, redraw)
	entry.active = true
	if not redraw and entry.untimed then
		return
	end
	entry.untimed = true
	entry.endTime = nil
	entry.duration = nil
	node:ClearTimerDuration()
	node:SetMinMax(0, 1)
	node:SetValue(1, false)
	TRB.Data.lookupDirty = true
end

---@type TRB.Classes.CustomBarProvider
local auraProvider = {
	label = L["CustomBarsAddGroupAuraId"],
	shortLabel = L["CustomBarsProviderShortSpellId"],
	promptText = L["CustomBarsAuraIdPromptText"],
	GetIdSources = function(spellId)
		return CustomBars:GetAuraIdSources(spellId)
	end,
	-- The buffs this specialization's bars already name, so a bar can change what it tracks of one.
	GetSources = function(classId, specId)
		local sources = {}
		local compositeKey = classId ~= nil and specId ~= nil and TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId) or nil
		local seen = {}
		for _, bar in pairs(CustomBars:GetBars(GetSavedSpec(compositeKey)) or {}) do
			local source = type(bar) == "table" and bar.source or nil
			if type(source) == "table" and source.provider == CustomBars.auraProvider and type(source.spellId) == "number" and not seen[source.spellId] then
				seen[source.spellId] = true
				for _, option in ipairs(CustomBars:GetAuraIdSources(source.spellId)) do
					sources[#sources + 1] = option
				end
			end
		end
		return sources
	end,
	GetSourceName = function(_, _, source)
		return C_Spell.GetSpellName(source.spellId)
	end,
	ReadMax = function(_, _, source)
		local max = source.kind == CustomBars.kinds.buffStacks and C_Spell.GetSpellMaxCumulativeAuraApplications(source.spellId) or nil
		if max ~= nil and not issecretvalue(max) and max > 0 then
			return max
		end
		return nil
	end,
	WriteLookup = function(entry, now)
		local timeText, stacksText, stacksMaxText = "", "", ""
		if entry.isTimer then
			if entry.active and entry.endTime ~= nil then
				timeText = TRB.Functions.BarText:TimerPrecision(entry.endTime - now)
			end
		else
			stacksText = TRB.Functions.Number:RoundTo(ReadAuraCount(entry), 0)
			local max = knownMax[entry.key] or entry.bar.maxCount
			if max ~= nil then
				stacksMaxText = tostring(max)
			end
		end
		return timeText, stacksText, stacksMaxText
	end,
	Render = function(entry, group, node, settings, now, redraw)
		if entry.isTimer then
			local isActive, expirationTime, duration = TRB.Functions.Aura:GetFollowedAura(entry.spellId)
			if isActive and (expirationTime or 0) == 0 then
				RenderUntimedTimer(entry, node, redraw)
				return false
			end
			-- A buff that lost its untimed fill is drawn afresh.
			local wasUntimed = entry.untimed == true
			entry.untimed = nil
			RenderPlainTimer(entry, node, isActive, expirationTime, duration, now, redraw or wasUntimed)
			return false
		end
		RenderCount(entry, group, settings, ReadAuraCount(entry), knownMax[entry.key] or entry.bar.maxCount or 1, redraw, true)
		return false
	end,
}
if TRB.Flavor.playerAuras then
	CustomBars:RegisterProvider(CustomBars.auraProvider, auraProvider)
end

---Draws the displayed custom bars. Runs on the 20Hz tick, ahead of the visibility pass.
function CustomBars:Render()
	EnsureRuntime()
	if pendingCooldownSync then
		pendingCooldownSync = false
		TRB.Functions.ThresholdCooldowns:Sync()
	end
	if pendingAuraSync then
		pendingAuraSync = false
		TRB.Functions.Aura:RefreshConditionSpells()
	end
	if pendingVisibility then
		pendingVisibility = false
		TRB.Functions.BarVisibility:MarkDirty()
	end
	if (#runtime == 0 and not pendingGroups) or not TRB.Data.specSupported then
		return
	end
	local barGroups = TRB.Frames.barGroups --[[@as table<string, TRB.Classes.BarGroup>?]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	if barGroups == nil or snapshotData == nil then
		return
	end

	local settings = self:GetDisplayedSettings()
	if settings == nil then
		return
	end
	if pendingGroups then
		-- The list changed outside a layout pass, which is what builds and drops the groups their text is on.
		pendingGroups = false
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
		TRB.Functions.BarText:CreateBarTextFrames()
		TRB.Functions.BarText:InvalidateLookupMemoization()
	end
	if pendingAppearance then
		pendingAppearance = false
		TRB.Functions.Bar:ApplyCustomBarGroupsAppearance(settings, barGroups, true)
	end
	local now = GetTime()
	local activityChanged = false
	local needsLayout = false
	local timerActive = false
	for _, entry in ipairs(runtime) do
		local group = barGroups[entry.key]
		local node = group ~= nil and group.nodes[1] or nil
		if group ~= nil and node ~= nil then
			local wasActive = entry.active
			local layout = layoutVersions[group] or 0
			-- A rebuilt bar or a layout pass leaves the nodes without what was written to them.
			local redraw = entry.frame ~= node.frame or entry.layout ~= layout
			entry.frame = node.frame
			entry.layout = layout
			needsLayout = entry.provider.Render(entry, group, node, settings, now, redraw) or needsLayout
			activityChanged = activityChanged or entry.active ~= wasActive
			timerActive = timerActive or (entry.isTimer and entry.active) or entry.recharging == true
		end
	end

	if needsLayout then
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
		TRB.Functions.Bar:ApplyCustomBarGroupsAppearance(settings, barGroups, true)
		-- A rebuilt group has new frames for its text to anchor to.
		TRB.Functions.BarText:CreateBarTextFrames()
		TRB.Functions.BarText:InvalidateLookupMemoization()
	end
	anyTimerActive = timerActive
	if activityChanged then
		TRB.Functions.BarVisibility:MarkDirty()
		-- A timer that started or ended changes what its bar text shows.
		TRB.Data.lookupDirty = true
	end
end
