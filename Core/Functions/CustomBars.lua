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

---@class TRB.Classes.Settings.CustomBar
---@field public guid string
---@field public name string
---@field public source TRB.Classes.Settings.CustomBarSource
---@field public segmented boolean? # A count bar's one node per stack or charge; nil follows the maximum
---@field public fillRecharge boolean? # A segmented charges bar's recharging charge fills as it recharges; nil is on

---@class TRB.Classes.CustomBarSourceOption
---@field public kind trbCustomBarSourceKind
---@field public spellId integer
---@field public spellName string
---@field public icon string?
---@field public label string

---@class TRB.Classes.CustomBarRuntime
---@field public key string
---@field public bar TRB.Classes.Settings.CustomBar
---@field public definition TRB.Classes.BarTypeDefinition
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
local pendingVisibility = false
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
function CustomBars:GetSources(classId, specId)
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
			local hasCharges = spell.hasCharges == true or snapshot.cooldown.useManualCharges == true
			-- A charge ability's duration is its recharge, unless the spell also names a buff.
			local durationIsBuff = not hasCharges or spell.buffId ~= nil or spell.isBuff == true
			if spell.duration ~= nil and durationIsBuff and not snapshot.buff.alwaysSimple then
				Add(self.kinds.buffTime, spell, name)
			end
			if spell.maxStacks ~= nil then
				Add(self.kinds.buffStacks, spell, name)
			end
			if hasCharges then
				Add(self.kinds.charges, spell, name)
				Add(self.kinds.rechargeTime, spell, name)
				-- The time until every charge is back needs a plain count, which only hand-counted charges have in combat.
				if snapshot.cooldown.useManualCharges == true and snapshot.cooldown.manualMaxCharges > 1 then
					Add(self.kinds.totalRechargeTime, spell, name)
				end
			elseif spell.hasCooldown == true then
				Add(self.kinds.cooldownTime, spell, name)
			end
		end
	end
	table.sort(sources, function(a, b)
		if a.label ~= b.label then
			return a.label < b.label
		end
		return a.spellId < b.spellId
	end)
	return sources
end

---What a bar tracks, as the table and the dropdown show it.
---@param classId integer?
---@param specId integer?
---@param source TRB.Classes.Settings.CustomBarSource?
---@return string
function CustomBars:GetSourceLabel(classId, specId, source)
	if source == nil then
		return ""
	end
	local snapshots = GetSnapshots(classId, specId)
	local snapshot = snapshots ~= nil and snapshots[source.spellId] or nil
	local name = snapshot ~= nil and snapshot.spell ~= nil and GetSpellName(snapshot.spell) or source.spellName
	return string.format(L["CustomBarsSourceFormat"], name or tostring(source.spellId), kindLabels[source.kind] or "")
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
---@param snapshots table<integer, TRB.Classes.Snapshot>?
---@return boolean created
local function SyncDefinition(bar, classId, specId, snapshots)
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local key = CustomBars:GetBarKey(bar.guid)
	local kind = bar.source.kind
	local isCount = CustomBars:IsCountKind(kind)
	local max = 1
	if isCount then
		max = GetCountMax(kind, snapshots ~= nil and snapshots[bar.source.spellId] or nil) or knownMax[key] or 1
		knownMax[key] = max
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
					or entry.fillRecharge ~= CustomBars:FillsRecharge(bar) then
					return false
				end
			end
		end
	end
	return count == #runtime
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
	local snapshots = GetSnapshots(classId, specId)
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
				changed = SyncDefinition(bar, classId, specId, snapshots) or changed
			end
		end
	end
	for key, definition in pairs(registry:GetAll()) do
		if definition.isUserBar and definition.ownerClassId == classId and definition.ownerSpecId == specId and not seen[key] then
			registry:Unregister(key)
			changed = true
		end
	end
	if changed then
		TRB.Functions.Settings:ResetTextureMedia()
		TRB.Functions.OptionsUi.Textures:ResetLockMembers()
	end
	local character = TRB.Data.character
	if character ~= nil and character.classId == classId and character.specId == specId and not RuntimeMatches(bars) then
		runtimeKey = nil
	end
end

---A specialization's saved bar text list, or an empty one.
---@param spec table
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function GetBarTextList(spec)
	return spec.displayText ~= nil and spec.displayText.barText or {}
end

---Adds a bar's default bar text.
---@param spec table
---@param bar TRB.Classes.Settings.CustomBar
local function AddDefaultText(spec, bar)
	if spec.displayText == nil or spec.displayText.barText == nil then
		return
	end
	local anchorName, variable, onRechargingCharge = GetDefaultText(bar)
	local labelFormat = onRechargingCharge and L["CustomBarsRechargingAnchorLabel"] or L["CustomBarsAnchorLabel"]
	table.insert(spec.displayText.barText, TRB.Functions.Settings:LoadDefaultOtherBarTextSettings(anchorName, string.format(labelFormat, bar.name),
		variable, "CENTER", onRechargingCharge and 12 or 14))
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
	change(bar)
	self:SyncRegistry(classId, specId, spec)
	local newAnchor, newVariable, onRechargingCharge = GetDefaultText(bar)
	if oldAnchor == newAnchor and oldVariable == newVariable then
		return
	end
	local oldText = DefaultTextOf(oldVariable)
	local labelFormat = onRechargingCharge and L["CustomBarsRechargingAnchorLabel"] or L["CustomBarsAnchorLabel"]
	for _, entry in ipairs(GetBarTextList(spec)) do
		local position = entry.position
		if position ~= nil and position.relativeToFrame == oldAnchor and entry.text == oldText then
			entry.text = DefaultTextOf(newVariable)
			position.relativeToFrame = newAnchor
			position.relativeToFrameName = string.format(labelFormat, bar.name)
		end
	end
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
		source = { kind = source.kind, spellId = source.spellId, spellName = source.spellName },
	}
	-- A charge ability the game counts hasn't been read yet, and its maximum decides the bar's shape and default text.
	if source.kind == self.kinds.charges then
		local snapshots = GetSnapshots(classId, specId)
		local snapshot = snapshots ~= nil and snapshots[source.spellId] or nil
		if snapshot ~= nil and not snapshot.cooldown.useManualCharges then
			snapshot.cooldown:RefreshCharges()
		end
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
		bar.source = { kind = source.kind, spellId = source.spellId, spellName = source.spellName }
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

---The character's own specialization settings, which a custom bar keeps in every form.
---@return table?
local function GetOwnSpec()
	local character = TRB.Data.character
	if character == nil or character.compositeKey == nil then
		return nil
	end
	local entry = TRB.Functions.Character:GetSpecRegistryEntry(character.compositeKey)
	local classSettings = entry ~= nil and TRB.Data.settings ~= nil and TRB.Data.settings[entry.className] or nil
	return classSettings ~= nil and classSettings[entry.specName] or nil
end

---Rebuilds the live spec's bar list after its settings or the spec changed.
---@return boolean rebuilt
local function EnsureRuntime()
	local character = TRB.Data.character
	local compositeKey = character ~= nil and character.compositeKey or nil
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
	local bars = CustomBars:GetBars(GetOwnSpec())
	local boundBars = {}
	if bars ~= nil then
		for guid, bar in pairs(bars) do
			local key = CustomBars:GetBarKey(guid)
			local definition = registry:Get(key)
			if definition ~= nil then
				local kind = bar.source.kind
				---@type TRB.Classes.CustomBarRuntime
				local entry = {
					key = key,
					bar = bar,
					definition = definition,
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
					StacksMax = function() return not entry.isTimer and knownMax[key] ~= nil end,
				} }
			end
		end
	end
	if #boundBars > 0 or runtimeHasBoundVariables then
		runtimeHasBoundVariables = #boundBars > 0
		TRB.Functions.BarText:SetBoundBarVariables(boundBars)
	end
	pendingCooldownSync = pendingCooldownSync or hadCooldowns or runtimeHasCooldowns
	pendingVisibility = true
	return true
end

---The live spec's bar keys, for the bar groups and anchor lists.
---@return TRB.Classes.CustomBarRuntime[]
function CustomBars:GetRuntime()
	EnsureRuntime()
	return runtime
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
		if buff.isActive == true and (buff.endTime == nil or buff.endTime > now) then
			return buff.applications or 0
		end
		return 0
	end
	if snapshot.cooldown.useManualCharges then
		return snapshot.cooldown.manualCharges
	end
	return snapshot.cooldown.charges or 0
end

---Writes each bar's own bar text variables. A secret time or count reaches the lookup only as a formatted string.
---@param lookup table<string, any>
function CustomBars:WriteLookup(lookup)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	local snapshots = snapshotData ~= nil and snapshotData.snapshots or nil
	local now = GetTime()
	local kinds = self.kinds
	for _, entry in ipairs(runtime) do
		local timeText, stacksText, stacksMaxText = "", "", ""
		local snapshot = snapshots ~= nil and snapshots[entry.spellId] or nil
		if snapshot ~= nil then
			if not entry.isTimer then
				stacksText = TRB.Functions.Number:RoundTo(ReadCount(entry.kind, snapshot, now), 0)
				if knownMax[entry.key] ~= nil then
					stacksMaxText = tostring(knownMax[entry.key])
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
		lookup[entry.timeVar] = timeText
		lookup[entry.stacksVar] = stacksText
		lookup[entry.stacksMaxVar] = stacksMaxText
	end
end

---Appends the spells whose cooldowns the live spec's bars read, for the cooldown tracker.
---@param spells TRB.Classes.SpellBase[]
function CustomBars:AppendCooldownSpells(spells)
	EnsureRuntime()
	if not runtimeHasCooldowns then
		return
	end
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	local snapshots = snapshotData ~= nil and snapshotData.snapshots or nil
	if snapshots == nil then
		return
	end
	for _, entry in ipairs(runtime) do
		local source = entry.bar.source
		local snapshot = self:IsCooldownKind(source.kind) and snapshots[source.spellId] or nil
		-- Charges a class module counts by hand are its own to keep.
		if snapshot ~= nil and snapshot.spell ~= nil and not snapshot.cooldown.useManualCharges then
			spells[#spells + 1] = snapshot.spell
		end
	end
end

---Appends the live spec's custom bars to a visibility pass, each carrying whether it is active for When Active.
---@param entries TRB.Classes.BarVisibilityEntry[]
---@param barGroups table<string, TRB.Classes.BarGroup>?
function CustomBars:AppendVisibilityEntries(entries, barGroups)
	EnsureRuntime()
	if #runtime == 0 or barGroups == nil then
		return
	end
	local settings = TRB.Functions.Character:GetSpecSettingsByKey(TRB.Data.character.compositeKey)
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
	-- No duration objects on this client: write the remaining time each tick instead.
	if C_DurationUtil == nil then
		if entry.active then
			node:SetMinMax(0, duration)
			node:SetValue(endTime - now, false)
		elseif redraw or entry.endTime ~= nil then
			ClearNode(node)
		end
		entry.endTime = entry.active and endTime or nil
		return
	end
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
	if C_DurationUtil == nil or length == nil or length <= 0 then
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
local function RenderRechargeFill(entry, group, settings, count, recharge, redraw)
	local isSecret = issecretvalue(count)
	if redraw or isSecret or entry.trackerCount ~= count then
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
---filled node. A secret count is written every tick, since it can't be compared.
---@param entry TRB.Classes.CustomBarRuntime
---@param group TRB.Classes.BarGroup
---@param settings table # The spec cache settings
---@param count number
---@param max integer
---@param redraw boolean
local function RenderCount(entry, group, settings, count, max, redraw)
	local isSecret = issecretvalue(count)
	entry.active = isSecret or count > 0
	if not redraw and not isSecret and entry.count == count and entry.max == max then
		return
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

---Draws the live spec's custom bars. Runs on the 20Hz tick, ahead of the visibility pass.
function CustomBars:Render()
	EnsureRuntime()
	if pendingCooldownSync then
		pendingCooldownSync = false
		TRB.Functions.ThresholdCooldowns:Sync()
	end
	if pendingVisibility then
		pendingVisibility = false
		TRB.Functions.BarVisibility:MarkDirty()
	end
	if #runtime == 0 or not TRB.Data.specSupported then
		return
	end
	local barGroups = TRB.Frames.barGroups --[[@as table<string, TRB.Classes.BarGroup>?]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	if barGroups == nil or snapshotData == nil then
		return
	end

	local settings = TRB.Functions.Class:GetActiveDisplaySettings()
	if settings == nil then
		return
	end
	local now = GetTime()
	local kinds = self.kinds
	local snapshots = snapshotData.snapshots
	local activityChanged = false
	local needsLayout = false
	local timerActive = false
	for _, entry in ipairs(runtime) do
		local group = barGroups[entry.key]
		local node = group ~= nil and group.nodes[1] or nil
		local source = entry.bar.source
		local snapshot = snapshots[source.spellId]
		if group ~= nil and node ~= nil then
			local wasActive = entry.active
			local layout = layoutVersions[group] or 0
			-- A rebuilt bar or a layout pass leaves the nodes without what was written to them.
			local redraw = entry.frame ~= node.frame or entry.layout ~= layout
			entry.frame = node.frame
			entry.layout = layout
			if snapshot == nil then
				entry.active = false
				if redraw then
					ClearNode(node)
				end
			elseif source.kind == kinds.buffTime then
				local buff = snapshot.buff
				RenderPlainTimer(entry, node, buff.isActive == true, buff.endTime, buff.duration, now, redraw)
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
					needsLayout = ApplyLiveMax(entry, max) or needsLayout
				end
				RenderCount(entry, group, settings, count, max or knownMax[entry.key] or 1, redraw)
				if source.kind == kinds.charges then
					local recharging = IsRecharging(snapshot.cooldown, now)
					if entry.recharging ~= recharging then
						entry.recharging = recharging
						TRB.Data.lookupDirty = true
					end
					if group.chargeTracker ~= nil then
						local recharge = entry.fillRecharge and GetRechargeObject(entry, snapshot.cooldown) or nil
						RenderRechargeFill(entry, group, settings, count, recharge, redraw)
						-- A bar with no charges left still has something to show while one recharges.
						entry.active = entry.active or recharge ~= nil
					end
				end
			end
			activityChanged = activityChanged or entry.active ~= wasActive
			timerActive = timerActive or (entry.isTimer and entry.active) or entry.recharging == true
		end
	end

	if needsLayout then
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, barGroups)
	end
	anyTimerActive = timerActive
	if activityChanged then
		TRB.Functions.BarVisibility:MarkDirty()
		-- A timer that started or ended changes what its bar text shows.
		TRB.Data.lookupDirty = true
	end
end
