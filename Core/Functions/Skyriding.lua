local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Skyriding = {}

-- The Skyriding bars render outside ProcessBars, so their updater re-asserts their visibility while any shows.

-- Nil on a flavor without skyriding, where the public functions return before anything reads it. Load-time checks
-- test TRB.Flavor.skyriding instead, since a top-level nil test makes the language server treat it as nilable.
local SKYRIDING = TRB.Flavor.skyriding --[[@as TRB.Flavor.Skyriding]]
local BAR_KEYS = TRB.Classes.BarTypeRegistry.skyridingBarKeys

-- Yards per second at 100% speed.
local RUN_SPEED = 7

-- The speed caps of the zone the player is in: the Dragon Isles' own, or the lower ones everywhere else.
local speedCaps = (TRB.Flavor.skyriding ~= nil and SKYRIDING.speedCaps.default or nil) --[[@as TRB.Flavor.SkyridingSpeedCap]]
local DRAGON_ISLES_MAP_IDS = {}
if TRB.Flavor.skyriding ~= nil then
	for _, mapId in ipairs(SKYRIDING.dragonIslesMapIds) do
		DRAGON_ISLES_MAP_IDS[mapId] = true
	end
end

-- The Speed bar's passive speed cap line, made on first use, and what it was last drawn with.
local passiveLine = nil
local passiveLineDrawn = { color = nil, width = nil, height = nil, thickness = nil }

-- Settings, visibility, colors, and the speed read run at 20Hz; Smooth eases the Speed fill between ticks.
local UPDATER_THROTTLE = 0.05
local updaterSinceLastUpdate = UPDATER_THROTTLE

-- Charge bar -> the spell whose charges it shows.
local CHARGE_SPELL_IDS = {}
-- The spells whose own cooldown the Whirling Surge bar follows, as a set for event filtering.
local COOLDOWN_SPELL_IDS = {}
if TRB.Flavor.skyriding ~= nil then
	CHARGE_SPELL_IDS.skyridingCharges = SKYRIDING.chargeSpellId
	CHARGE_SPELL_IDS.secondWind = SKYRIDING.secondWindSpellId
	for _, spellId in ipairs(SKYRIDING.cooldownSpellIds) do
		COOLDOWN_SPELL_IDS[spellId] = true
	end
end

-- Per charge bar, read on SPELL_UPDATE_CHARGES: the count (secret where the spell isn't whitelisted), the max,
-- the refilling charge's duration object, and the raw recharge length and rate the probe reports.
local chargeState = {}
-- Per charge bar, the recharge fill colors its tracker holds by reference, one per node.
local rechargeColors = {}
for barKey in pairs(CHARGE_SPELL_IDS) do
	chargeState[barKey] = { current = nil, max = nil, recharge = nil, duration = nil, rate = nil }
	rechargeColors[barKey] = {}
end

-- Whirling Surge or Lightning Rush on its own cooldown: its duration object, and when it ends while that is readable.
local cooldownState = { duration = nil, expiry = nil, spellId = nil }
-- The duration object bound to the Whirling Surge node.
local boundCooldown = nil

-- Thrill of the Skies and Ground Skimming, read only from the buff ids Blizzard doesn't flag always secret.
local buffState = { thrill = false, skimming = false }
local readableThrillIds = {}
local readableSkimmingIds = {}

-- Lightning Rush: whether its choice node swaps it in for Whirling Surge, and whether it can be cast now.
local lightningRush = { selected = false, usable = true }
-- Static Charge's stacks and GetTime() expiry while it is up and readable.
local staticCharge = { stacks = nil, expiration = nil }
local staticChargeReadable = false

-- The live speed in yards per second (secret on the ground while unit stats are restricted), its percent of run
-- speed when plain, and the GetTime() it was read at.
local speedValue = nil
local speedPercent = nil
local speedReadAt = nil

-- Per bar: the alpha last applied, the alpha it is headed for, and the fade-out in progress.
local appliedAlpha = {}
local targetAlpha = {}
local fadeStart = {}
local fadeFrom = {}
-- Per bar, the visibility resolved at the last tick, which the frames between ticks fade with.
local cachedVisibility = {}

-- Bar text icons, built once spell data has loaded.
local icons = {}

local moduleEnabled = false
-- Whether any Skyriding bar is enabled, which is what the charge and cooldown events are registered for.
local eventsEnabled = false

-- TEMPORARY DIAGNOSTIC (/trb skyriding): secrecy, each flight's top speed, and the live recharge per buff state.
local probeEnabled = false
local probeFlightTop = nil
local probeLandedAt = nil
local probeSessionTop = 0
local probeLastState = nil
local probeLastRecharge = nil

local updaterFrame = CreateFrame("Frame")
updaterFrame:Hide()
local eventFrame = CreateFrame("Frame")

local function ForceThrottleTick()
	updaterSinceLastUpdate = UPDATER_THROTTLE
end

---@param fmt string
---@param ... any
local function ProbePrint(fmt, ...)
	print("|cFFFF8800TRB Skyriding:|r " .. string.format(fmt, ...))
end

---@param value any
---@return string
local function Describe(value)
	if value == nil then
		return "nil"
	end
	if issecretvalue(value) then
		return "secret"
	end
	if type(value) == "number" and value ~= math.floor(value) then
		return string.format("%.2f", value)
	end
	return tostring(value)
end

---Returns the composed active display settings, or nil.
---@return table?
local function GetActiveSettings()
	return TRB.Functions.Class:GetActiveDisplaySettings()
end

---Returns a bar's settings, colors, and visibility from the composed settings, plus those settings.
---@param barKey string
---@return table? barSettings, table? colors, table? visibility, table? settings
local function GetBarConfig(barKey)
	local settings = GetActiveSettings()
	if settings == nil then
		return nil, nil, nil, nil
	end
	local barSettings = settings.bars and settings.bars[barKey]
	local colors = settings.colors and settings.colors.bars and settings.colors.bars[barKey]
	local visibility = settings.displayBar and settings.displayBar[barKey]
	return barSettings, colors, visibility, settings
end

---Whether the bar is enabled at all: not Never Show, and Always Show or some show condition is ticked.
---@param visibility table?
---@return boolean
local function IsEnabled(visibility)
	if visibility == nil or visibility.neverShow == true then
		return false
	end
	if visibility.alwaysShow == true then
		return true
	end
	local conditions = visibility.conditions
	if conditions == nil then
		return true
	end
	for _, ticked in pairs(conditions) do
		if ticked == true then
			return true
		end
	end
	return false
end

-- The environment snapshot every Skyriding bar reads, refilled at most once per frame, and the scratch entry
-- ShouldForceHideBar reads the settings from.
local context = setmetatable({}, TRB.Classes.BarVisibilityContext)
local contextTime = nil
local hideEntry = {}

---@return TRB.Classes.BarVisibilityContext
local function GetContext()
	local now = GetTime()
	if contextTime ~= now then
		TRB.Classes.BarVisibilityContext:FillFromGameState(context, false)
		contextTime = now
	end
	return context
end

---The alpha a bar should rest at now: 0 while disabled or a hide condition holds, else its active or inactive alpha.
---@param visibility table?
---@return number
local function GetTargetAlpha(visibility)
	if visibility == nil or not IsEnabled(visibility) then
		return 0
	end
	local ctx = GetContext()
	hideEntry.visibilitySettings = visibility
	if TRB.Functions.BarVisibility:ShouldForceHideBar(ctx, hideEntry) then
		return 0
	end
	local conditions = visibility.conditions
	if visibility.alwaysShow or (conditions ~= nil and TRB.Functions.BarVisibility:MatchesShowConditions(ctx, conditions)) then
		return (visibility.activeAlpha or 100) / 100
	end
	return (visibility.inactiveAlpha or 0) / 100
end

---Steps a bar toward its target alpha: up at once, down after the fade delay and across the fade duration.
---@param barKey string
---@param target number
---@param visibility table?
---@param now number
---@return number alpha
---@return boolean fading
local function StepAlpha(barKey, target, visibility, now)
	local current = appliedAlpha[barKey] or 0
	if target >= current then
		fadeStart[barKey] = nil
		return target, false
	end
	if fadeStart[barKey] == nil then
		fadeStart[barKey] = now
		fadeFrom[barKey] = current
	end
	local delay = (visibility and visibility.fadeDelay) or 0
	local duration = (visibility and visibility.fadeDuration) or 0
	local elapsed = now - fadeStart[barKey]
	if elapsed < delay then
		return current, true
	end
	if duration <= 0 or elapsed >= delay + duration then
		fadeStart[barKey] = nil
		return target, false
	end
	local from = fadeFrom[barKey]
	return from + (target - from) * ((elapsed - delay) / duration), true
end

---Shows a bar at an alpha, marking visibility dirty on a hidden->visible flip.
---@param group TRB.Classes.BarGroup
---@param alpha number
local function ShowAt(group, alpha)
	group.targetAlpha = alpha
	group.currentAlpha = alpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	group:ShowNodes(group.nodeCount)
	group.containerFrame:SetAlpha(alpha)
	group.healedHideVersion = group.hideVersion
end

---@param group TRB.Classes.BarGroup
local function HideGroup(group)
	group.targetAlpha = 0
	group.currentAlpha = 0
	if group.isVisible then
		group:Hide()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	group.containerFrame:SetAlpha(0)
end

---Applies a fill color plus the bar's border and background.
---@param node TRB.Classes.BarNode
---@param colors table
---@param fill table?
local function ApplyColors(node, colors, fill)
	if fill ~= nil then
		TRB.Functions.Color:ApplyFillColor(node, fill)
	end
	if colors.border ~= nil then
		node:SetBorderColor(colors.border.color)
	end
	if colors.background ~= nil then
		node:SetBackgroundColorFromString(colors.background.color)
	end
end

---The bar texture a bar's nodes use, which Texture Lock swaps for the main bar's.
---@param settings table?
---@param barKey string
---@return string?
local function GetBarTexture(settings, barKey)
	local textures = settings and settings.textures
	if textures == nil then
		return nil
	end
	if textures.textureLock then
		return textures.resourceBar
	end
	return textures[barKey .. "Bar"]
end

---Reads the live speed: forward speed while gliding, movement speed otherwise.
---@param now number
local function ReadSpeed(now)
	local isGliding, _, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
	local speed = forwardSpeed
	if not isGliding then
		speed = GetUnitSpeed("player")
	end
	speedValue = speed
	speedReadAt = now
	if speed == nil or issecretvalue(speed) then
		speedPercent = nil
	else
		speedPercent = speed / RUN_SPEED * 100
	end

	if probeEnabled then
		if isGliding and speedPercent ~= nil then
			probeFlightTop = math.max(probeFlightTop or 0, speedPercent)
			probeLandedAt = nil
		elseif not isGliding and probeFlightTop ~= nil then
			-- A second on the ground ends the flight, so a skim past the ground doesn't split one in two.
			probeLandedAt = probeLandedAt or now
			if now - probeLandedAt >= 1 then
				probeSessionTop = math.max(probeSessionTop, probeFlightTop)
				ProbePrint("Flight top speed %.0f%% (%.1f yd/s); session top %.0f%%.", probeFlightTop, probeFlightTop * RUN_SPEED / 100, probeSessionTop)
				probeFlightTop = nil
				probeLandedAt = nil
			end
		end
	end
end

---Prints the skyriding state flags when they change, which answers how a mount, a form, or Soar reads.
local function ProbeState()
	if not probeEnabled then
		return
	end
	local _, canGlide = C_PlayerInfo.GetGlidingInfo()
	local state = string.format("canGlide %s, mounted %s, form %s -> Skyriding %s", tostring(canGlide), tostring(IsMounted()), tostring(GetShapeshiftFormID()), tostring(GetContext().isSkyriding))
	if state ~= probeLastState then
		probeLastState = state
		ProbePrint("%s.", state)
	end
end

---Prints the Charges bar's recharge whenever its length, rate, or the buffs change while a charge refills.
local function ProbeCharges()
	local state = chargeState.skyridingCharges
	if not probeEnabled or state == nil or state.recharge == nil then
		return
	end
	local key = Describe(state.duration) .. "|" .. Describe(state.rate) .. "|" .. tostring(buffState.thrill) .. "|" .. tostring(buffState.skimming)
	if key ~= probeLastRecharge then
		probeLastRecharge = key
		ProbePrint("Charges %s/%s recharging over %ss at rate %s; Thrill of the Skies %s, Ground Skimming %s.", Describe(state.current), Describe(state.max),
			Describe(state.duration), Describe(state.rate), buffState.thrill and "up" or "down", buffState.skimming and "up" or "down")
	end
end

---Reads a charge bar's charges. Outside a layout pass, a maximum the bar isn't laid out for re-lays the bars out.
---@param barKey string
---@param duringLayout boolean?
local function RefreshCharges(barKey, duringLayout)
	local spellId = CHARGE_SPELL_IDS[barKey]
	local state = chargeState[barKey]
	local info = C_Spell.GetSpellCharges(spellId)
	if info == nil then
		state.current, state.max, state.recharge, state.duration, state.rate = nil, nil, nil, nil, nil
		return
	end
	state.current = info.currentCharges
	state.max = info.maxCharges
	state.duration = info.cooldownDuration
	state.rate = info.chargeModRate
	state.recharge = nil
	if info["isActive"] then
		state.recharge = C_Spell.GetSpellChargeDuration(spellId)
	end

	local barGroups = TRB.Frames.barGroups
	local group = barGroups and barGroups[barKey]
	if not duringLayout and group ~= nil and state.max > 0 and group.nodeCount ~= math.min(state.max, group.maxNodes) then
		local settings = GetActiveSettings()
		if settings ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
		end
	end
end

---Finds whichever of Whirling Surge and Lightning Rush is on its own cooldown. The abilities' shared lock
---doesn't count, and while the values are secret the duration object still drives the fill.
local function RefreshCooldown()
	local previousExpiry = cooldownState.expiry
	cooldownState.duration = nil
	cooldownState.expiry = nil
	cooldownState.spellId = nil
	for _, spellId in ipairs(SKYRIDING.cooldownSpellIds) do
		local info = C_Spell.GetSpellCooldown(spellId)
		if info ~= nil and info["isActive"] then
			local startTime, duration, modRate = info.startTime, info.duration, info.modRate
			if issecretvalue(startTime) or issecretvalue(duration) then
				cooldownState.duration = C_Spell.GetSpellCooldownDuration(spellId, true)
				cooldownState.spellId = spellId
				return
			end
			if duration > SKYRIDING.abilityLockDuration then
				if modRate == nil or issecretvalue(modRate) or modRate <= 0 then
					modRate = 1
				end
				cooldownState.duration = C_Spell.GetSpellCooldownDuration(spellId, true)
				cooldownState.expiry = startTime + (duration / modRate)
				cooldownState.spellId = spellId
				if probeEnabled and cooldownState.expiry ~= previousExpiry then
					ProbePrint("Spell %d cooldown %ss at rate %s.", spellId, Describe(duration), Describe(modRate))
				end
				return
			end
		end
	end
end

---The player's aura for a spell, or nil while it is down or restricted (a secret read).
---@param spellId integer
---@return AuraData?
local function ReadAura(spellId)
	local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId)
	if issecretvalue(aura) then
		return nil
	end
	return aura
end

---Whether any of these buffs is on the player.
---@param spellIds integer[]
---@return boolean
local function IsAnyBuffUp(spellIds)
	for _, spellId in ipairs(spellIds) do
		if ReadAura(spellId) ~= nil then
			return true
		end
	end
	return false
end

---Reads whether Lightning Rush replaces Whirling Surge and, if so, whether it can be cast.
local function RefreshLightningRush()
	local lightningRushId = SKYRIDING.cooldownSpellIds[2]
	local selected = C_Spell.GetOverrideSpell(SKYRIDING.cooldownSpellIds[1]) == lightningRushId
	local usable = not selected or C_Spell.IsSpellUsable(lightningRushId) == true
	if selected ~= lightningRush.selected or usable ~= lightningRush.usable then
		lightningRush.selected = selected
		lightningRush.usable = usable
		ForceThrottleTick()
		if probeEnabled then
			ProbePrint("Lightning Rush selected %s, usable %s; Static Charge %s.", tostring(selected), tostring(usable), Describe(staticCharge.stacks))
		end
	end
end

local function RefreshStaticCharge()
	local stacks, expiration = nil, nil
	local aura = staticChargeReadable and ReadAura(SKYRIDING.staticChargeBuffId) or nil
	if aura ~= nil then
		stacks = aura.applications
		expiration = aura.expirationTime
		if issecretvalue(stacks) or issecretvalue(expiration) then
			stacks, expiration = nil, nil
		else
			-- A single stack can read as 0 applications.
			stacks = math.max(stacks or 0, 1)
			if expiration == nil or expiration <= 0 then
				expiration = nil
			end
		end
	end
	staticCharge.stacks = stacks
	staticCharge.expiration = expiration
end

local function RefreshBuffs()
	local thrill = IsAnyBuffUp(readableThrillIds)
	local skimming = IsAnyBuffUp(readableSkimmingIds)
	RefreshStaticCharge()
	if thrill ~= buffState.thrill or skimming ~= buffState.skimming then
		buffState.thrill = thrill
		buffState.skimming = skimming
		ForceThrottleTick()
		if probeEnabled then
			ProbePrint("Thrill of the Skies %s, Ground Skimming %s.", thrill and "up" or "down", skimming and "up" or "down")
		end
		ProbeCharges()
	end
	RefreshLightningRush()
end

---Whether Blizzard lets an aura be read at least some of the time, i.e. it isn't flagged always secret.
---@param spellId integer
---@return boolean
local function IsAuraReadable(spellId)
	if C_Secrets == nil or C_Secrets.GetSpellAuraSecrecy == nil or Enum.SecrecyLevel == nil then
		return false
	end
	return C_Secrets.GetSpellAuraSecrecy(spellId) ~= Enum.SecrecyLevel.AlwaysSecret
end

---Keeps the buff ids that may be read from their auras.
---@param spellIds integer[]
---@param into integer[]
local function CollectReadableBuffIds(spellIds, into)
	wipe(into)
	for _, spellId in ipairs(spellIds) do
		if IsAuraReadable(spellId) then
			into[#into + 1] = spellId
		end
	end
end

---Listens for the buffs and Lightning Rush's usability only while the player can glide.
---@param canGlide boolean
local function SyncGlideEvents(canGlide)
	if eventsEnabled and canGlide then
		if #readableThrillIds > 0 or #readableSkimmingIds > 0 or staticChargeReadable then
			eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
		end
		eventFrame:RegisterEvent("SPELL_UPDATE_USABLE")
		RefreshBuffs()
	else
		eventFrame:UnregisterEvent("UNIT_AURA")
		eventFrame:UnregisterEvent("SPELL_UPDATE_USABLE")
		staticCharge.stacks, staticCharge.expiration = nil, nil
		if buffState.thrill or buffState.skimming then
			buffState.thrill = false
			buffState.skimming = false
			ForceThrottleTick()
		end
	end
end

local function BuildIcons()
	local iconSpellIds = {
		["#surgeForward"] = SKYRIDING.chargeSpellId,
		["#whirlingSurge"] = SKYRIDING.cooldownSpellIds[1],
		["#lightningRush"] = SKYRIDING.cooldownSpellIds[2],
		["#secondWind"] = SKYRIDING.secondWindSpellId,
		["#thrillOfTheSkies"] = SKYRIDING.thrillOfTheSkiesBuffIds[1],
		["#groundSkimming"] = SKYRIDING.groundSkimmingBuffIds[1],
		["#staticCharge"] = SKYRIDING.staticChargeBuffId,
	}
	for var, spellId in pairs(iconSpellIds) do
		local texture = C_Spell.GetSpellTexture(spellId)
		icons[var] = texture ~= nil and string.format("|T%s:0|t", texture) or ""
	end
end

local function RefreshAll()
	CollectReadableBuffIds(SKYRIDING.thrillOfTheSkiesBuffIds, readableThrillIds)
	CollectReadableBuffIds(SKYRIDING.groundSkimmingBuffIds, readableSkimmingIds)
	staticChargeReadable = IsAuraReadable(SKYRIDING.staticChargeBuffId)
	RefreshCharges("skyridingCharges")
	RefreshCharges("secondWind")
	RefreshCooldown()
	RefreshLightningRush()
	BuildIcons()
end

---Picks the speed caps from the player's map, walking up its parents to the Dragon Isles.
local function RefreshZone()
	local caps = SKYRIDING.speedCaps.default
	local mapId = C_Map.GetBestMapForUnit("player")
	-- Map parents end at Cosmic; the cap keeps a malformed chain from looping.
	for _ = 1, 10 do
		if mapId == nil or mapId == 0 then
			break
		end
		if DRAGON_ISLES_MAP_IDS[mapId] then
			caps = SKYRIDING.speedCaps.dragonIsles
			break
		end
		local info = C_Map.GetMapInfo(mapId)
		mapId = info and info.parentMapID
	end
	if caps ~= speedCaps then
		speedCaps = caps
		ForceThrottleTick()
		if probeEnabled then
			ProbePrint("Speed caps now %d%% top, %d%% passive.", caps.max, caps.passive)
		end
	end
end

---Draws the passive speed cap line at its share of the Speed bar, hidden while its color is off.
---@param node TRB.Classes.BarNode
---@param colors table
---@param settings table?
local function RenderPassiveLine(node, colors, settings)
	local entry = colors.passiveSpeedCap
	local show = entry ~= nil and entry.enabled == true
	if passiveLine == nil and not show then
		return
	end
	local frame = node:GetFrame()
	if passiveLine == nil then
		passiveLine = CreateFrame("Frame", nil, frame) --[[@as TRB.Classes.ThresholdFrame]]
	end

	-- Set up like an end cap: its own width and color, or the border's color, kept inside the side borders.
	local thickness = math.max(1, (entry and tonumber(entry.width)) or 2)
	local barSettings = settings and settings.bars and settings.bars.skyridingSpeed
	local fillDirection = barSettings and barSettings.fillDirection
	local isVertical = TRB.Functions.Bar:IsVerticalFill(fillDirection)
	local width = isVertical and frame:GetWidth() or thickness
	local height = isVertical and thickness or frame:GetHeight()
	local color = entry and entry.color or "FFFFFFFF"
	if entry ~= nil and entry.useBorderColor and colors.border ~= nil then
		color = colors.border.color
	end
	local drawn = passiveLineDrawn
	if show and (drawn.color ~= color or drawn.width ~= width or drawn.height ~= height or drawn.thickness ~= thickness) then
		TRB.Functions.Threshold:ResetThresholdLineCustomBar(passiveLine, width, height, color, thickness)
		drawn.color, drawn.width, drawn.height, drawn.thickness = color, width, height, thickness
	end
	TRB.Functions.Threshold:RepositionThresholdCustomBar("skyridingPassiveSpeed", passiveLine, show, frame, speedCaps.passive, speedCaps.max,
		frame:GetWidth(), barSettings and barSettings.border, nil, fillDirection, thickness, false)
end

---@param group TRB.Classes.BarGroup
---@param colors table
---@param settings table?
---@param visibility table?
local function RenderSpeed(group, colors, settings, visibility)
	local node = group:GetNode(1)
	if node == nil then
		return
	end
	node:SetMinMax(0, speedCaps.max * RUN_SPEED / 100)
	if speedValue ~= nil then
		node:SetValue(speedValue, visibility ~= nil and visibility.smooth == true)
	end
	local fill = colors.bar
	local thrill, skimming = colors.thrillOfTheSkies, colors.groundSkimming
	if buffState.thrill and thrill ~= nil and thrill.enabled then
		fill = thrill
	elseif buffState.skimming and skimming ~= nil and skimming.enabled then
		fill = skimming
	end
	ApplyColors(node, colors, fill)
	node:ApplyEndCap(colors.endCap, colors.border and colors.border.color)
	RenderPassiveLine(node, colors, settings)
end

---@param barKey string
---@param group TRB.Classes.BarGroup
---@param colors table
---@param settings table?
local function RenderCharges(barKey, group, colors, settings)
	local state = chargeState[barKey]
	local count = state.current or 0
	-- The refilling charge's fill edge carries the end cap. With nothing refilling it falls to the highest full
	-- charge, which a secret count can't name.
	local capNode = (state.recharge ~= nil or issecretvalue(count)) and 0 or count
	local colorEntries = rechargeColors[barKey]
	for i = 1, group.nodeCount do
		local node = group:GetNode(i)
		if node ~= nil then
			node:SetMinMax(i - 1, i)
			node:SetValue(count, false)
			ApplyColors(node, colors, colors.bar)
			node:ApplyEndCap(colors.endCap, colors.border and colors.border.color)
			if node.endCapConfig ~= nil then
				node.overlaySlots.endCap:SetEndCapShown(i == capNode)
			end
		end
		colorEntries[i] = colors.recharging
	end
	for i = group.nodeCount + 1, #colorEntries do
		colorEntries[i] = nil
	end
	-- The refilling charge is count + 1, which a secret count can't name; the tracker's fill edge lands on it instead.
	group:SetChargeTrackerValue(count)
	group:SetChargeRechargeAppearance(GetBarTexture(settings, barKey), colorEntries)
	local borderColor = colors.border and colors.border.color
	group:SetChargeRechargeEndCap(colors.endCap, borderColor, borderColor)
	group:SetChargeRechargeDuration(state.recharge)
end

---@param group TRB.Classes.BarGroup
---@param colors table
local function RenderCooldown(group, colors)
	local node = group:GetNode(1)
	if node == nil then
		return
	end
	local duration = cooldownState.duration
	if duration == nil then
		if node.hasTimerDuration then
			node:ClearTimerDuration()
		end
		boundCooldown = nil
		node:SetMinMax(0, 1)
		node:SetValue(1, false)
	elseif duration ~= boundCooldown or not node.hasTimerDuration then
		node:SetMinMax(0, 1)
		node:SetTimerDuration(duration, Enum.StatusBarInterpolation.Immediate, Enum.StatusBarTimerDirection.ElapsedTime)
		boundCooldown = duration
	end
	local fill = colors.bar
	if duration == nil then
		-- Off cooldown, a Lightning Rush still short of ten Static Charge stacks can't be cast.
		local unusable = colors.unusable
		if lightningRush.selected and not lightningRush.usable and unusable ~= nil and unusable.enabled then
			fill = unusable
		else
			fill = colors.ready
		end
	end
	ApplyColors(node, colors, fill)
	node:ApplyEndCap(colors.endCap, colors.border and colors.border.color)
end

---@param barKey string
---@param group TRB.Classes.BarGroup
---@param colors table?
---@param settings table?
---@param visibility table?
local function RenderBar(barKey, group, colors, settings, visibility)
	if colors == nil then
		return
	end
	if barKey == "skyridingSpeed" then
		RenderSpeed(group, colors, settings, visibility)
	elseif barKey == "whirlingSurge" then
		RenderCooldown(group, colors)
	else
		RenderCharges(barKey, group, colors, settings)
	end
end

---Whether any Skyriding bar should be on screen, or still is. Edit Mode previews them through ProcessBars instead.
---@return boolean
local function NeedsUpdater()
	if TRB.Functions.EditMode:IsInEditMode() then
		return false
	end
	local barGroups = TRB.Frames.barGroups
	for _, barKey in ipairs(BAR_KEYS) do
		local group = barGroups and barGroups[barKey]
		if group ~= nil then
			if group.isVisible or fadeStart[barKey] ~= nil then
				return true
			end
			local _, _, visibility = GetBarConfig(barKey)
			if GetTargetAlpha(visibility) > 0 then
				return true
			end
		end
	end
	return false
end

local function SyncUpdater()
	if NeedsUpdater() then
		ForceThrottleTick()
		updaterFrame:Show()
	end
end

updaterFrame:SetScript("OnUpdate", function(_, sinceLastUpdate)
	if TRB.Functions.EditMode:IsInEditMode() then
		updaterFrame:Hide()
		return
	end
	updaterSinceLastUpdate = updaterSinceLastUpdate + (sinceLastUpdate or 0)
	local throttleTick = updaterSinceLastUpdate >= UPDATER_THROTTLE
	if throttleTick then
		updaterSinceLastUpdate = 0
	end
	local now = GetTime()
	-- A render transition hides every group for a moment, so showing through it would flicker.
	local inTransition = TRB.Functions.Bar:IsRenderTransitionActive()

	if throttleTick then
		ReadSpeed(now)
		if cooldownState.expiry ~= nil and now >= cooldownState.expiry then
			RefreshCooldown()
		end
		ProbeState()
	end

	local needsUpdater = inTransition
	local barGroups = TRB.Frames.barGroups
	for _, barKey in ipairs(BAR_KEYS) do
		local group = barGroups and barGroups[barKey]
		if group ~= nil then
			local colors, settings, visibility
			if throttleTick then
				_, colors, visibility, settings = GetBarConfig(barKey)
				cachedVisibility[barKey] = visibility
				targetAlpha[barKey] = GetTargetAlpha(visibility)
			else
				visibility = cachedVisibility[barKey]
			end
			local target = targetAlpha[barKey] or 0
			local alpha, fading = StepAlpha(barKey, target, visibility, now)
			if fading or alpha > 0 or target > 0 then
				needsUpdater = true
			end

			if not inTransition then
				if alpha > 0 then
					if throttleTick then
						RenderBar(barKey, group, colors, settings, visibility)
					end
					-- Between ticks, only after something hid the group or a node, or while the alpha moves.
					if throttleTick or appliedAlpha[barKey] ~= alpha or group.healedHideVersion ~= group.hideVersion then
						ShowAt(group, alpha)
					end
				elseif group.isVisible or appliedAlpha[barKey] ~= 0 then
					HideGroup(group)
				end
				appliedAlpha[barKey] = alpha
			end
		end
	end

	if not needsUpdater then
		updaterFrame:Hide()
	end
end)

eventFrame:SetScript("OnEvent", function(_, event, ...)
	if event == "SPELL_UPDATE_CHARGES" then
		RefreshCharges("skyridingCharges")
		RefreshCharges("secondWind")
		ForceThrottleTick()
		ProbeCharges()
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		local spellId, baseSpellId = ...
		-- A secret id can't key a table, so it refreshes like a nil (update everything) one.
		if spellId ~= nil and issecretvalue(spellId) then
			spellId = nil
		end
		if baseSpellId ~= nil and issecretvalue(baseSpellId) then
			baseSpellId = nil
		end
		if spellId == nil or COOLDOWN_SPELL_IDS[spellId] or (baseSpellId ~= nil and COOLDOWN_SPELL_IDS[baseSpellId]) then
			RefreshCooldown()
			ForceThrottleTick()
		end
	elseif event == "UNIT_AURA" then
		RefreshBuffs()
	elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_MAP_CHANGED" then
		RefreshZone()
	elseif event == "SPELL_UPDATE_USABLE" or event == "SPELLS_CHANGED" then
		-- SPELLS_CHANGED covers picking Lightning Rush or Whirling Surge from the mount journal.
		RefreshLightningRush()
	elseif event == "PLAYER_ENTERING_WORLD" then
		RefreshZone()
		if eventsEnabled then
			RefreshAll()
		end
		local _, canGlide = C_PlayerInfo.GetGlidingInfo()
		SyncGlideEvents(canGlide == true)
		TRB.Functions.Skyriding:RefreshVisibility()
	else
		if event == "PLAYER_CAN_GLIDE_CHANGED" then
			SyncGlideEvents((...) == true)
		end
		-- A mount, form, vehicle, or death change may flip a show or hide condition, and the mounted state
		-- the conditions read settles a moment after the event.
		SyncUpdater()
		C_Timer.After(0.1, SyncUpdater)
	end
end)

---Public wrapper over IsEnabled. Layout consults this to collapse a disabled bar's reserved space.
---@param visibility table?
---@return boolean
function TRB.Functions.Skyriding:IsEnabled(visibility)
	return IsEnabled(visibility)
end

---Registers the events that keep the bars' state live. The charge and cooldown events follow SyncEnabledState.
function TRB.Functions.Skyriding:Enable()
	if SKYRIDING == nil then
		return
	end
	moduleEnabled = true
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED")
	eventFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
	eventFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	eventFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	eventFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	eventFrame:RegisterEvent("PLAYER_DEAD")
	eventFrame:RegisterEvent("PLAYER_ALIVE")
	eventFrame:RegisterEvent("PLAYER_UNGHOST")
	-- A garrison or other seamless exit changes the map without a loading screen.
	eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	eventFrame:RegisterEvent("PLAYER_MAP_CHANGED")
	RefreshZone()
	self:SyncEnabledState()
end

---Registers the charge and cooldown events only while a Skyriding bar is enabled, so nobody else pays for them.
function TRB.Functions.Skyriding:SyncEnabledState()
	if SKYRIDING == nil or not moduleEnabled then
		return
	end
	local anyEnabled = false
	for _, barKey in ipairs(BAR_KEYS) do
		local _, _, visibility = GetBarConfig(barKey)
		if IsEnabled(visibility) then
			anyEnabled = true
			break
		end
	end
	if anyEnabled ~= eventsEnabled then
		eventsEnabled = anyEnabled
		if anyEnabled then
			eventFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
			eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
			eventFrame:RegisterEvent("SPELLS_CHANGED")
			RefreshAll()
		else
			eventFrame:UnregisterEvent("SPELL_UPDATE_CHARGES")
			eventFrame:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
			eventFrame:UnregisterEvent("SPELLS_CHANGED")
		end
		local _, canGlide = C_PlayerInfo.GetGlidingInfo()
		SyncGlideEvents(canGlide == true)
	end
	self:RefreshVisibility()
end

---Re-resolves every bar's display after a settings or environment change; the updater parks itself once nothing shows.
function TRB.Functions.Skyriding:RefreshVisibility()
	if SKYRIDING == nil or TRB.Functions.EditMode:IsInEditMode() then
		return
	end
	ForceThrottleTick()
	updaterFrame:Show()
end

---Wakes the parked updater when a bar should now show: a show condition changing only marks visibility dirty,
---so ProcessBars calls this.
function TRB.Functions.Skyriding:EnsureIdleState()
	if SKYRIDING == nil or updaterFrame:IsShown() then
		return
	end
	SyncUpdater()
end

---Whether any Skyriding bar is on screen. Its anchored bar text depends on this.
---@return boolean
function TRB.Functions.Skyriding:IsRendering()
	local barGroups = TRB.Frames.barGroups
	if barGroups == nil then
		return false
	end
	for _, barKey in ipairs(BAR_KEYS) do
		local group = barGroups[barKey]
		if group ~= nil and group.isVisible then
			return true
		end
	end
	return false
end

---Whether a Skyriding bar is fading out, which holds its anchored text on its last value.
---@param barKey string
---@return boolean
function TRB.Functions.Skyriding:IsFadingOut(barKey)
	return fadeStart[barKey] ~= nil
end

---Whether any Skyriding variable can change right now: a bar is on screen, or a recharge or cooldown runs.
---@return boolean
function TRB.Functions.Skyriding:HasLiveValues()
	if SKYRIDING == nil then
		return false
	end
	return self:IsRendering() or chargeState.skyridingCharges.recharge ~= nil or chargeState.secondWind.recharge ~= nil
		or cooldownState.duration ~= nil or staticCharge.expiration ~= nil
end

---The live speed in percent of run speed, or nil while it is unknown. Speed has no event, so it is read on demand.
---@return number?
function TRB.Functions.Skyriding:GetSpeedPercent()
	if SKYRIDING == nil then
		return nil
	end
	local now = GetTime()
	if speedReadAt ~= now then
		ReadSpeed(now)
	end
	return speedPercent
end

---A charge bar's charges (may be secret), maximum, and the refilling charge's remaining seconds (nil when full).
---@param barKey string
---@return number? charges, integer? maxCharges, number? remaining
function TRB.Functions.Skyriding:GetChargeValues(barKey)
	local state = chargeState[barKey]
	if state == nil or state.max == nil then
		return nil, nil, nil
	end
	local remaining = nil
	if state.recharge ~= nil then
		remaining = state.recharge:GetRemainingDuration()
	end
	return state.current, state.max, remaining
end

---Seconds left on Whirling Surge's or Lightning Rush's cooldown, or nil when it is ready.
---@return number?
function TRB.Functions.Skyriding:GetCooldownRemaining()
	if cooldownState.duration == nil then
		return nil
	end
	return cooldownState.duration:GetRemainingDuration()
end

---@return boolean thrillOfTheSkies, boolean groundSkimming
function TRB.Functions.Skyriding:GetBuffStates()
	return buffState.thrill, buffState.skimming
end

---Static Charge's stacks and seconds left, or nil while it is down or can't be read.
---@return integer? stacks, number? remaining
function TRB.Functions.Skyriding:GetStaticCharge()
	if staticCharge.stacks == nil then
		return nil, nil
	end
	local remaining = nil
	if staticCharge.expiration ~= nil then
		remaining = math.max(0, staticCharge.expiration - GetTime())
	end
	return staticCharge.stacks, remaining
end

---Bar text icon strings keyed by variable.
---@return table<string, string>
function TRB.Functions.Skyriding:GetIcons()
	return icons
end

---A charge bar's live node count, read on the spot when it isn't known yet. Called from inside layout passes.
---@param barKey string
---@return integer?
function TRB.Functions.Skyriding:GetLiveNodeCount(barKey)
	local state = chargeState[barKey]
	if state == nil then
		return nil
	end
	if state.max == nil then
		RefreshCharges(barKey, true)
	end
	return state.max
end

---Turns the temporary probe on or off.
function TRB.Functions.Skyriding:ToggleProbe()
	if SKYRIDING == nil then
		print("|cFFFF8800TRB Skyriding:|r This client has no skyriding.")
		return
	end
	probeEnabled = not probeEnabled
	if not probeEnabled then
		ProbePrint("Probe OFF. Session top speed %.0f%%.", math.max(probeSessionTop, probeFlightTop or 0))
		return
	end
	probeSessionTop = 0
	probeFlightTop = nil
	probeLandedAt = nil
	probeLastState = nil
	probeLastRecharge = nil

	local function CooldownSecrecy(spellId)
		if C_Secrets == nil or C_Secrets.GetSpellCooldownSecrecy == nil or spellId == nil then
			return "n/a"
		end
		return tostring(C_Secrets.GetSpellCooldownSecrecy(spellId))
	end
	local function AuraSecrecy(spellId)
		if C_Secrets == nil or C_Secrets.GetSpellAuraSecrecy == nil or spellId == nil then
			return "n/a"
		end
		return tostring(C_Secrets.GetSpellAuraSecrecy(spellId))
	end
	ProbePrint("Probe ON. Secrecy (0 never, 1 always, 2 in context): charges %s, Whirling Surge %s, Lightning Rush %s, Second Wind %s; Thrill of the Skies %s/%s, Ground Skimming %s, Static Charge %s.",
		CooldownSecrecy(SKYRIDING.chargeSpellId), CooldownSecrecy(SKYRIDING.cooldownSpellIds[1]), CooldownSecrecy(SKYRIDING.cooldownSpellIds[2]),
		CooldownSecrecy(SKYRIDING.secondWindSpellId), AuraSecrecy(SKYRIDING.thrillOfTheSkiesBuffIds[1]), AuraSecrecy(SKYRIDING.thrillOfTheSkiesBuffIds[2]),
		AuraSecrecy(SKYRIDING.groundSkimmingBuffIds[1]), AuraSecrecy(SKYRIDING.staticChargeBuffId))
	ProbePrint("Reading %d Thrill of the Skies and %d Ground Skimming ids; Static Charge %s. Now: Thrill of the Skies %s, Ground Skimming %s; Lightning Rush selected %s, usable %s.",
		#readableThrillIds, #readableSkimmingIds, staticChargeReadable and "readable" or "unreadable", buffState.thrill and "up" or "down",
		buffState.skimming and "up" or "down", tostring(lightningRush.selected), tostring(lightningRush.usable))
	local charges = chargeState.skyridingCharges
	local secondWind = chargeState.secondWind
	ProbePrint("Charges %s/%s, Second Wind %s/%s, bars enabled %s. Fly, dive as fast as you can, then land; each flight reports its top speed.",
		Describe(charges.current), Describe(charges.max), Describe(secondWind.current), Describe(secondWind.max), tostring(eventsEnabled))
	ProbeState()
	ProbeCharges()
end
