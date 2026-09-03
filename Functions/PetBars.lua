---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.PetBars = {}

--[[
	Functions.PetBars: render + event bridge for the Pet Health and Pet Resource bars.

	Both fill from the "pet" unit token. UnitHealth/UnitPower are secret in restricted content, so the
	value goes straight from the API into SetValue and the health color comes from a UnitHealthPercent
	curve -- nothing is compared or stored. The max is plain, so it can set the node's scale.

	Which power the resource bar shows comes from UnitPowerType("pet"): Focus for a Hunter pet, Energy
	for a demon or a ghoul, Mana for a Water Elemental.

	Like the cast bars and the Other Bars these are NOT in BarVisibility:ProcessBars, so the updater
	re-asserts alpha/visibility while a bar is on screen to self-heal after render transitions.
]]

local BAR_KEYS = { "petPower", "petHealth" }

-- Live pet state: "none", "permanent", "temporary" (a timed summon) or "dead".
local petState = "none"
-- The power type the resource bar is showing, or nil when the pet has none, and its localized name.
local petPowerType = nil
local petPowerName = nil
-- The pet's name, or nil. Read on pet change; used by $petName.
local petName = nil

-- Post-state fade timers keyed by bar key: GetTime() when the fade began, or nil when not fading.
local fadeStart = {}
-- Bars force-hidden mid-show, so clearing the condition brings them straight back.
local forceHidden = {}
-- Per-bar cache of the last throttle tick's resolved visibility table, reused between ticks.
local cachedVisibility = {}
-- Whether each bar was showing at the last throttle tick, so a state change can start a fade.
local wasShowing = {}

-- Cached health color curve and the settings signature it was built from.
local healthCurve = nil
local healthCurveKey = nil

-- The active spec's pet record, plus a reusable spell-shaped table for the talent lookup so the gate
-- check allocates nothing per tick. petGateSpell is nil on a spec whose pet is baseline.
local petSpecInfo = nil
local petGateSpell = nil

---Re-reads the active spec's pet record.
local function RefreshPetSpec()
	petSpecInfo = TRB.Classes.BarTypeRegistry:GetPetSpecInfo(TRB.Data.character.classId, TRB.Data.character.specId)
	local talentId = petSpecInfo ~= nil and petSpecInfo.talentId or nil
	if talentId == nil then
		petGateSpell = nil
	elseif petGateSpell == nil or petGateSpell.id ~= talentId then
		petGateSpell = { id = talentId, talentId = talentId }
	end
end

---Whether this spec can have a pet at all right now: it owns one, and the talent granting it (where the
---pet is talented rather than baseline) is picked. Read live rather than latched on the talent event --
---the talent cache behind it is rebuilt a moment later, so a latch would hold the old configuration.
---@return boolean
local function IsPetGateActive()
	if petSpecInfo == nil then
		return false
	end
	if petGateSpell == nil then
		return true
	end
	local talents = TRB.Data.talents
	return talents ~= nil and talents:IsTalentActive(petGateSpell)
end

local updaterFrame = CreateFrame("Frame")
updaterFrame:Hide()

-- 20Hz throttle, matching the cast bars and the Other Bars. Health and power are read on the tick;
-- between ticks only a running fade has anything to do.
local UPDATER_THROTTLE = 0.05
local updaterSinceLastUpdate = UPDATER_THROTTLE

---Returns the composed active display settings, or nil.
local function GetActiveSettings()
	return TRB.Functions.Class:GetActiveDisplaySettings()
end

---Returns the bar settings / colors / visibility for a bar key from composed settings.
---@param barKey string
---@return table? barSettings, table? colors, table? visibility
local function GetBarConfig(barKey)
	local settings = GetActiveSettings()
	if settings == nil then
		return nil, nil, nil
	end
	local barSettings = settings.bars and settings.bars[barKey]
	local colors = settings.colors and settings.colors.bars and settings.colors.bars[barKey]
	local visibility = settings.displayBar and settings.displayBar[barKey]
	return barSettings, colors, visibility
end

---Whether the bar is enabled at all: not Never Show, and something could still make it appear --
---Always Show, or at least one pet state ticked.
---@param visibility table?
---@return boolean
local function IsEnabled(visibility)
	-- Ahead of Always Show: a spec that has not picked its pet talent has no pet to bar, so nothing here
	-- should hold layout space or render.
	if not IsPetGateActive() then
		return false
	end
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
	return conditions.petPermanent == true or conditions.petTemporary == true
		or conditions.petDead == true or conditions.petMissing == true
end

---Public wrapper over IsEnabled. Layout consults this to collapse a disabled bar's reserved space.
---@param visibility table?
---@return boolean
function TRB.Functions.PetBars:IsEnabled(visibility)
	return IsEnabled(visibility)
end

---Whether the current pet state satisfies the bar's show conditions.
---@param visibility table?
---@return boolean
local function MatchesPetState(visibility)
	if visibility == nil then
		return false
	end
	if visibility.alwaysShow == true then
		return true
	end
	local conditions = visibility.conditions
	if conditions == nil then
		return false
	end
	if petState == "permanent" then
		return conditions.petPermanent == true
	elseif petState == "temporary" then
		return conditions.petTemporary == true
	elseif petState == "dead" then
		return conditions.petDead == true
	end
	return conditions.petMissing == true
end

-- Environment snapshot the hide conditions are evaluated against, plus the scratch entry
-- ShouldForceHideBar reads the settings from. Shared by both bars, rebuilt once per frame.
local hideContext = nil
local hideContextTime = nil
local hideEntry = {}

---@return TRB.Classes.BarVisibilityContext
local function GetHideContext()
	local now = GetTime()
	if hideContextTime ~= now or hideContext == nil then
		hideContext = TRB.Classes.BarVisibilityContext:NewFromGameState(false, nil)
		hideContextTime = now
	end
	return hideContext
end

---Whether a hard-hide condition currently suppresses the bar.
---@param visibility table?
---@return boolean
local function IsForceHidden(visibility)
	if visibility == nil or visibility.hideConditions == nil then
		return false
	end
	hideEntry.visibilitySettings = visibility
	return TRB.Functions.BarVisibility:ShouldForceHideBar(GetHideContext(), hideEntry)
end

---Container alpha the bar rests at while its show condition is unmet, ignoring hide conditions.
---@param visibility table?
---@return number # 0..1
local function GetRestingAlpha(visibility)
	if visibility == nil or not IsEnabled(visibility) then
		return 0
	end
	return ((visibility.inactiveAlpha) or 0) / 100
end

---Returns the bar group + single node for a bar key, or nils.
---@param barKey string
---@return TRB.Classes.BarGroup?, TRB.Classes.BarNode?
local function GetGroupNode(barKey)
	local barGroups = TRB.Frames.barGroups
	local group = barGroups and barGroups[barKey] or nil
	local node = group and group:GetNode(1) or nil
	return group, node
end

-- ============================================================================
-- Pet state
-- ============================================================================

---Whether the pet currently out is a timed summon. GetPetTimeRemaining reports the milliseconds left on
---one and nothing at all for a pet you keep, which is the only distinction the API draws.
---@return boolean
local function IsTemporaryPet()
	local getRemaining = (C_PetInfo and C_PetInfo.GetPetTimeRemaining) or GetPetTimeRemaining
	if type(getRemaining) ~= "function" then
		return false
	end
	local remaining = getRemaining()
	return remaining ~= nil and not issecretvalue(remaining) and remaining > 0
end

---Re-reads the pet from the API. Returns true when anything the bars render changed.
---@return boolean changed
local function RefreshPetState()
	local newState = "none"
	local newPowerType = nil
	local newPowerName = nil
	local newName = nil

	if UnitExists("pet") then
		if UnitIsDead("pet") then
			newState = "dead"
		elseif IsTemporaryPet() then
			newState = "temporary"
		else
			newState = "permanent"
		end
		newName = UnitName("pet")
		local powerType, powerToken = UnitPowerType("pet")
		if powerType ~= nil and (UnitPowerMax("pet", powerType) or 0) > 0 then
			newPowerType = powerType
			-- The power token doubles as the key of Blizzard's own localized global string ("FOCUS", "MANA").
			newPowerName = powerToken ~= nil and _G[powerToken] or nil
		end
	end

	local changed = newState ~= petState or newPowerType ~= petPowerType or newName ~= petName
	petState = newState
	petPowerType = newPowerType
	petPowerName = newPowerName
	petName = newName
	return changed
end

---Public wrapper over IsPetGateActive. The Pet Cast Bar gates on this too.
---@return boolean
function TRB.Functions.PetBars:IsPetGateActive()
	return IsPetGateActive()
end

---The live pet state: "none", "permanent", "temporary" or "dead".
---@return string
function TRB.Functions.PetBars:GetPetState()
	return petState
end

---Whether a pet is out at all, dead ones included -- a dead pet still has values worth reading out.
---@return boolean
function TRB.Functions.PetBars:HasPet()
	return petState ~= "none"
end

---The pet's name, or nil when there is no pet.
---@return string?
function TRB.Functions.PetBars:GetPetName()
	return petName
end

---The power type the resource bar is showing, or nil when the pet has none.
---@return integer?
function TRB.Functions.PetBars:GetPetPowerType()
	return petPowerType
end

---The localized name of the power the pet uses ("Focus", "Energy", ...), or nil.
---@return string?
function TRB.Functions.PetBars:GetPetPowerName()
	return petPowerName
end

---Whether either pet bar is currently on screen. Bar text anchored to one needs isTracking to stay
---true for as long as it is, exactly like the Other Bars timers.
---@return boolean
function TRB.Functions.PetBars:IsRendering()
	for _, barKey in ipairs(BAR_KEYS) do
		local group = select(1, GetGroupNode(barKey))
		if group ~= nil and group.isVisible and (group.currentAlpha or 0) > 0 then
			return true
		end
	end
	return false
end

-- ============================================================================
-- Rendering
-- ============================================================================

---Builds (or reuses) the pet health color curve from the bar's threshold color settings. Same shape as
---the player health bar's: three points, stepped or linear, or one flat color.
---@param colors table?
---@return any? # A ColorCurve
local function GetHealthCurve(colors)
	if colors == nil then
		return nil
	end
	local curveType = colors.type
	local low = (colors.low and colors.low.color) or "FFFF0000"
	local medium = (colors.medium and colors.medium.color) or "FFFFFF00"
	local high = (colors.high and colors.high.color) or "FF00FF00"
	local lowThreshold = (colors.low and colors.low.threshold) or 0
	local mediumThreshold = (colors.medium and colors.medium.threshold) or 0.3
	local highThreshold = (colors.high and colors.high.threshold) or 0.7
	local key = tostring(curveType) .. low .. medium .. high .. lowThreshold .. mediumThreshold .. highThreshold

	if healthCurve ~= nil and healthCurveKey == key then
		return healthCurve
	end

	local highR, highG, highB, highA = TRB.Functions.Color:GetRGBAFromString(high, true)
	local curve = C_CurveUtil.CreateColorCurve()

	if curveType ~= "step" and curveType ~= "linear" then
		curve:SetType(Enum.LuaCurveType.Step)
		curve:AddPoint(0, CreateColor(highR, highG, highB, highA))
	else
		local lowR, lowG, lowB, lowA = TRB.Functions.Color:GetRGBAFromString(low, true)
		local medR, medG, medB, medA = TRB.Functions.Color:GetRGBAFromString(medium, true)

		local adjMedium = mediumThreshold
		if adjMedium >= highThreshold then
			adjMedium = highThreshold - 0.000001
		end
		local adjLow = lowThreshold
		if adjLow >= adjMedium then
			adjLow = adjMedium - 0.000001
		end

		curve:SetType(curveType == "linear" and Enum.LuaCurveType.Linear or Enum.LuaCurveType.Step)
		curve:AddPoint(adjLow, CreateColor(lowR, lowG, lowB, lowA))
		curve:AddPoint(adjMedium, CreateColor(medR, medG, medB, medA))
		curve:AddPoint(highThreshold, CreateColor(highR, highG, highB, highA))
	end

	healthCurve = curve
	healthCurveKey = key
	return curve
end

---Applies border, background and end cap, letting any Color Indicator targeting this bar take them over.
---@param node TRB.Classes.BarNode
---@param barKey string
---@param colors table?
local function ApplyChromeColors(node, barKey, colors)
	if colors == nil then
		return
	end
	local Color = TRB.Functions.Color
	local indicatorKey = barKey .. "Bar"
	local indicators = Color:GetResolvedIndicators(indicatorKey)
	Color:ApplyResolvedBorderOrBackground(node, indicatorKey, "border",
		(indicators and indicators.border) or (colors.border and colors.border.color))
	Color:ApplyResolvedBorderOrBackground(node, indicatorKey, "background",
		(indicators and indicators.background) or (colors.background and colors.background.color))
	node:ApplyEndCap(colors.endCap, colors.border and colors.border.color)
	Color:ApplyResolvedEndCap(node, indicatorKey)
	TRB.Functions.Glow:ApplyIndicatorGlow(node, indicatorKey)
end

---Writes the pet health bar's scale, value and fill color. With no pet at all -- which a bar showing on
---the "No pet" state reaches -- the unit APIs have nothing to answer, so the bar rests empty.
---@param node TRB.Classes.BarNode
---@param colors table?
local function UpdateHealthFill(node, colors)
	if petState == "none" then
		node:SetMinMax(0, 1)
		node:SetValue(0)
		return
	end
	local maxHealth = UnitHealthMax("pet")
	if maxHealth == nil then
		maxHealth = 1
	end
	node:SetMinMax(0, maxHealth)
	node:SetValue(UnitHealth("pet", true) or 0)
	local curve = GetHealthCurve(colors)
	if curve ~= nil then
		node:SetColorCurve(UnitHealthPercent("pet", true, curve))
	end
end

---Writes the pet resource bar's scale, value and fill color. An empty bar is the honest render for a
---pet with no power type at all.
---@param node TRB.Classes.BarNode
---@param colors table?
local function UpdatePowerFill(node, colors)
	if petPowerType == nil then
		node:SetMinMax(0, 1)
		node:SetValue(0)
	else
		local maxPower = UnitPowerMax("pet", petPowerType)
		if maxPower == nil then
			maxPower = 1
		end
		node:SetMinMax(0, maxPower)
		node:SetValue(UnitPower("pet", petPowerType, true) or 0)
	end
	local fill = colors and colors.bar
	if fill ~= nil then
		local indicators = TRB.Functions.Color:GetResolvedIndicators("petPowerBar")
		local indicated = indicators and indicators.bar
		if indicated ~= nil then
			TRB.Functions.Color:ApplyFillColor(node, indicated)
		elseif fill.gradientDirection ~= nil and fill.gradientDirection ~= "disabled" and fill.color2 ~= nil then
			node:SetColorGradient(fill.color, fill.color2, fill.gradientDirection)
		else
			node:SetColor(fill.color)
		end
	end
end

---Shows a bar's group/node at the given alpha, marking visibility dirty on a hidden->visible flip.
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode?
---@param alpha number
local function ShowAt(group, node, alpha)
	group.targetAlpha = alpha
	group.currentAlpha = alpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	if node ~= nil then
		node:Show()
	end
	if group.containerFrame then
		group.containerFrame:SetAlpha(alpha)
	end
end

---Applies the fully-hidden state for a bar.
---@param barKey string
local function ApplyHiddenState(barKey)
	local group = select(1, GetGroupNode(barKey))
	if group == nil then
		return
	end
	group.targetAlpha = 0
	group.currentAlpha = 0
	if group.isVisible then
		group:Hide()
	end
	if group.containerFrame then
		group.containerFrame:SetAlpha(0)
	end
end

---Applies the full visible render for a bar: fill, colors, alpha, Show.
---@param barKey string
local function ApplyVisibleState(barKey)
	local group, node = GetGroupNode(barKey)
	if group == nil or node == nil then
		return
	end
	local _, colors, visibility = GetBarConfig(barKey)
	if barKey == "petHealth" then
		UpdateHealthFill(node, colors)
	else
		UpdatePowerFill(node, colors)
	end
	ApplyChromeColors(node, barKey, colors)
	ShowAt(group, node, ((visibility and visibility.activeAlpha) or 100) / 100)
end

---Rests a bar at its idle display: an empty frame at the inactive alpha, or fully hidden.
---@param barKey string
local function ApplyInactiveState(barKey)
	local group, node = GetGroupNode(barKey)
	if group == nil or node == nil then
		return
	end
	local _, colors, visibility = GetBarConfig(barKey)
	if IsForceHidden(visibility) or GetRestingAlpha(visibility) <= 0 then
		ApplyHiddenState(barKey)
		return
	end
	node:SetMinMax(0, 1)
	node:SetValue(0)
	ApplyChromeColors(node, barKey, colors)
	ShowAt(group, node, GetRestingAlpha(visibility))
end

---Begins the fade-out honoring fadeDelay/fadeDuration, resting at the inactive alpha when done.
---@param barKey string
local function BeginFadeOut(barKey)
	forceHidden[barKey] = nil
	local _, _, visibility = GetBarConfig(barKey)
	local delay = (visibility and visibility.fadeDelay) or 0
	local duration = (visibility and visibility.fadeDuration) or 0
	if not IsEnabled(visibility) or IsForceHidden(visibility) or (delay <= 0 and duration <= 0) then
		fadeStart[barKey] = nil
		ApplyInactiveState(barKey)
	else
		fadeStart[barKey] = GetTime()
	end
	TRB.Functions.BarVisibility:MarkDirty()
end

---Whether the per-frame updater is still needed. A bar whose pet state matches keeps ticking even while
---force-hidden -- mounting up would otherwise shut it down and dismounting would never bring it back.
---A bar with nothing to show costs nothing: the pet events restart the updater.
---@return boolean
local function NeedsUpdater()
	for _, barKey in ipairs(BAR_KEYS) do
		if fadeStart[barKey] ~= nil then
			return true
		end
		local _, _, visibility = GetBarConfig(barKey)
		if IsEnabled(visibility) and (MatchesPetState(visibility) or GetRestingAlpha(visibility) > 0) then
			return true
		end
	end
	return false
end

local function SyncUpdater()
	if NeedsUpdater() then
		updaterSinceLastUpdate = UPDATER_THROTTLE
		updaterFrame:Show()
	else
		updaterFrame:Hide()
	end
end

---Re-resolves both bars against the current pet state and settings.
function TRB.Functions.PetBars:RefreshVisibility()
	for _, barKey in ipairs(BAR_KEYS) do
		local _, _, visibility = GetBarConfig(barKey)
		local shouldShow = IsEnabled(visibility) and MatchesPetState(visibility)
		if shouldShow and IsForceHidden(visibility) then
			forceHidden[barKey] = true
			fadeStart[barKey] = nil
			ApplyHiddenState(barKey)
		elseif shouldShow then
			forceHidden[barKey] = nil
			fadeStart[barKey] = nil
			ApplyVisibleState(barKey)
		elseif wasShowing[barKey] then
			BeginFadeOut(barKey)
		else
			ApplyInactiveState(barKey)
		end
		wasShowing[barKey] = shouldShow
		cachedVisibility[barKey] = visibility
	end
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

-- ============================================================================
-- Per-frame updater
-- ============================================================================
updaterFrame:SetScript("OnUpdate", function(_, sinceLastUpdate)
	updaterSinceLastUpdate = updaterSinceLastUpdate + (sinceLastUpdate or 0)
	local throttleTick = updaterSinceLastUpdate >= UPDATER_THROTTLE
	if throttleTick then
		updaterSinceLastUpdate = 0
	end

	local now = GetTime()
	local needsUpdater = false

	-- Nothing announces a pet dying, reviving, or a timed summon expiring, so the state is re-read here
	-- rather than event-driven. Bounded to 20Hz, and only while a bar could be up.
	if throttleTick and RefreshPetState() then
		TRB.Data.lookupDirty = true
	end

	for _, barKey in ipairs(BAR_KEYS) do
		local visibility
		if throttleTick then
			visibility = select(3, GetBarConfig(barKey))
			cachedVisibility[barKey] = visibility
		else
			visibility = cachedVisibility[barKey]
		end

		if throttleTick then
			local shouldShow = IsEnabled(visibility) and MatchesPetState(visibility)
			if shouldShow and IsForceHidden(visibility) then
				forceHidden[barKey] = true
				fadeStart[barKey] = nil
				ApplyHiddenState(barKey)
			elseif shouldShow then
				forceHidden[barKey] = nil
				fadeStart[barKey] = nil
				-- Unconditional: this is also what self-heals the bar after a render transition.
				ApplyVisibleState(barKey)
			elseif wasShowing[barKey] then
				BeginFadeOut(barKey)
			elseif fadeStart[barKey] == nil then
				ApplyInactiveState(barKey)
			end
			wasShowing[barKey] = shouldShow
		end

		if wasShowing[barKey] or GetRestingAlpha(visibility) > 0 then
			needsUpdater = true
		end

		if fadeStart[barKey] ~= nil then
			needsUpdater = true
			local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
			local idleAlpha = IsForceHidden(visibility) and 0 or GetRestingAlpha(visibility)
			local delay = (visibility and visibility.fadeDelay) or 0
			local duration = (visibility and visibility.fadeDuration) or 0
			local elapsed = now - fadeStart[barKey]
			if elapsed >= delay + duration then
				fadeStart[barKey] = nil
				ApplyInactiveState(barKey)
			else
				local alpha = activeAlpha
				if elapsed > delay and duration > 0 then
					alpha = activeAlpha + (idleAlpha - activeAlpha) * ((elapsed - delay) / duration)
				end
				local group, node = GetGroupNode(barKey)
				if group ~= nil then
					ShowAt(group, node, alpha)
				end
			end
		end
	end

	if not needsUpdater then
		SyncUpdater()
	end
end)

-- ============================================================================
-- Event routing
-- ============================================================================

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(_, event)
	if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_POWER_UPDATE" or event == "UNIT_MAXPOWER" then
		-- The bars read the values themselves each throttle tick, so these only mark bar text stale.
		TRB.Data.lookupDirty = true
		return
	end

	RefreshPetSpec()
	if RefreshPetState() then
		TRB.Data.lookupDirty = true
	end
	TRB.Functions.PetBars:RefreshVisibility()

	if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
		-- The Pet Cast Bar shares this gate. Its talent cache is rebuilt a moment after the event, and a
		-- gate that is still closed leaves the updater parked, so re-resolve once more after it lands.
		TRB.Functions.TargetCastbar:RefreshVisibility()
		C_Timer.After(0.5, function()
			TRB.Functions.PetBars:RefreshVisibility()
			TRB.Functions.TargetCastbar:RefreshVisibility()
		end)
	end
end)

---Registers the pet events and resolves the initial display. Unit events are filtered to "pet", so a
---character that never has one pays almost nothing.
function TRB.Functions.PetBars:Enable()
	eventFrame:RegisterUnitEvent("UNIT_PET", "player")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- A spec change can enable or disable both bars, and nothing else would restart the updater. A talent
	-- change does the same on the two specs whose pet is talented.
	eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	eventFrame:RegisterUnitEvent("UNIT_DISPLAYPOWER", "pet")
	eventFrame:RegisterUnitEvent("UNIT_HEALTH", "pet")
	eventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", "pet")
	eventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "pet")
	eventFrame:RegisterUnitEvent("UNIT_MAXPOWER", "pet")

	RefreshPetSpec()
	RefreshPetState()
	self:RefreshVisibility()
end

---Unregisters everything and tears down both bars.
function TRB.Functions.PetBars:Disable()
	eventFrame:UnregisterAllEvents()
	for _, barKey in ipairs(BAR_KEYS) do
		fadeStart[barKey] = nil
		forceHidden[barKey] = nil
		wasShowing[barKey] = false
		ApplyHiddenState(barKey)
	end
	updaterFrame:Hide()
end
