---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Castbar = {}

--[[
	Functions.Castbar: the render + event bridge for the castbar bar type.
	Drives TRB.Data.castbar (Classes/Castbar.lua) from UNIT_SPELLCAST_* events (fed by
	Functions/SpellCast.lua), places the static overlays/threshold lines (latency, pushback,
	channel ticks, empower stages) once per cast, and runs a dedicated per-frame updater for a
	smooth fill and the show/hide fade. Bar text values are exposed separately by Functions/BarText.
	Also hooks the C_TradeSkillUI craft calls to merge bulk crafting into one channel-style bar.
]]

-- Dedicated per-frame frame: drives the smooth fill + self-healing visibility while a cast is active.
-- Enabled on cast start, disabled once idle.
local castbarFrame = CreateFrame("Frame")
castbarFrame:Hide()
local isRunning = false
-- GetTime() of the most recent cast end while a fade-out (fadeDelay/fadeDuration) is in progress.
local fadeOutStart = nil
-- Latency makes the server fire the natural end-of-cast STOP a beat before GetTime() reaches endTime
-- (the "safe to queue" window shown as the latency zone), so the fill would otherwise freeze a few
-- percent short and fade from there. On a natural finish we keep advancing the fill to done across the
-- fade instead. { from, to, remaining }; nil when no completion is animating. See CaptureCompletion.
local fillComplete = nil
-- Whether the OnShow re-assert hook has been installed on PlayerCastingBarFrame.
local blizzardCastbarHookInstalled = false
-- Permanently-hidden holder frame the Blizzard cast bar gets reparented under, and its original
-- parent for restoring. Reparenting is taint-safe (C-side only, no Blizzard Lua runs), unlike SetUnit.
local blizzardCastbarHolder = nil
local blizzardCastbarOriginalParent = nil

-- Bulk crafting: the queued craft count (numCasts, argument 2 of every C_TradeSkillUI craft call) is
-- captured here and consumed by the next tradeskill UNIT_SPELLCAST_START. Timestamped so a queue whose
-- cast never starts (e.g. missing reagents) can't leak onto a later, unrelated craft.
local pendingCraftCount = nil
local pendingCraftTime = 0
local PENDING_CRAFT_WINDOW = 5.0

local function OnCraftQueued(_, numCasts)
	local count = tonumber(numCasts)
	pendingCraftCount = (count ~= nil and count > 0) and math.floor(count) or nil
	pendingCraftTime = GetTime()
end

for _, craftFunction in ipairs({ "CraftRecipe", "CraftSalvage", "CraftEnchant" }) do
	if type(C_TradeSkillUI[craftFunction]) == "function" then
		hooksecurefunc(C_TradeSkillUI, craftFunction, OnCraftQueued)
	end
end

---Takes (and clears) the pending bulk-craft count, if still fresh.
---@return integer?
local function ConsumePendingCraftCount()
	local count = pendingCraftCount
	pendingCraftCount = nil
	if count ~= nil and GetTime() - pendingCraftTime <= PENDING_CRAFT_WINDOW then
		return count
	end
	return nil
end

---Whether the player's active cast is a tradeskill (profession craft) cast.
---@return boolean
local function IsTradeskillCast()
	local isTradeSkill = select(6, UnitCastingInfo("player"))
	return not issecretvalue(isTradeSkill) and isTradeSkill == true
end

---Returns the form-resolved display settings (on Druid the form's spec, per GetActiveDisplayCompositeKey),
---the castbar bar settings, and castbar colors (or nils).
---@return table? settings, table? barSettings, table? colors
function TRB.Functions.Castbar:GetActiveSettings()
	local settings = TRB.Functions.Class:GetActiveDisplaySettings()
	if settings == nil then
		return nil, nil, nil
	end
	local barSettings = settings.bars and settings.bars.castbar
	local colors = settings.colors and settings.colors.bars and settings.colors.bars.castbar
	return settings, barSettings, colors
end

---Returns the castbar visibility entry (displayBar.castbar) from the given (or active) composed settings.
---@param settings table?
---@return table?
function TRB.Functions.Castbar:GetVisibilitySettings(settings)
	if settings == nil then
		settings = TRB.Functions.Class:GetActiveDisplaySettings()
	end
	return settings and settings.displayBar and settings.displayBar.castbar
end

---Whether the castbar is enabled at all: "Never Show" -- or no show options checked at all (not Always
---Show, no cast-type conditions) -- fully disables castbar processing: the model stays idle, no events are
---tracked, and the Blizzard cast bar is not suppressed. Exactly like the old opt-in checkbox being unchecked.
---@param visibility table?
---@return boolean
function TRB.Functions.Castbar:IsEnabled(visibility)
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
	return conditions.casting == true or conditions.channeling == true or conditions.empowered == true
end

---Whether another addon already manages/hides the Blizzard cast bar: unit cleared (SetUnit(nil)),
---cast events unregistered (UnregisterAllEvents), or parked under a foreign hidden parent. Leave
---such a bar alone -- suppressing it would start an ownership fight over the frame.
---@return boolean
local function IsBlizzardCastbarExternallyManaged()
	if PlayerCastingBarFrame.unit == nil then
		return true
	end
	if not PlayerCastingBarFrame:IsEventRegistered("UNIT_SPELLCAST_START") then
		return true
	end
	local parent = PlayerCastingBarFrame:GetParent()
	return parent ~= nil and parent ~= blizzardCastbarHolder and not parent:IsVisible()
end

---Hides or restores the default Blizzard cast bar per the active spec's settings: hidden while
---`bars.castbar.disableBlizzardCastbar` is set and the addon castbar is enabled (see IsEnabled).
---Checked on load/spec/talent changes, option toggles, and the Blizzard bar's own OnShow.
---@param settings table? # Composed spec settings to evaluate; defaults to the active display settings (pass explicitly during spec activation, before the composite key is stamped)
function TRB.Functions.Castbar:UpdateBlizzardCastbarVisibility(settings)
	if PlayerCastingBarFrame == nil then
		return
	end
	if settings == nil then
		settings = TRB.Functions.Class:GetActiveDisplaySettings()
	end
	local barSettings = settings and settings.bars and settings.bars.castbar
	local visibility = self:GetVisibilitySettings(settings)
	local shouldDisable = barSettings ~= nil and barSettings.disableBlizzardCastbar == true and self:IsEnabled(visibility)
	-- Blizzard re-parents the cast bar back to UIParent on spec/talent changes (Edit Mode relayout),
	-- so compare actual parentage rather than a cached flag.
	local currentlyDisabled = blizzardCastbarHolder ~= nil and PlayerCastingBarFrame:GetParent() == blizzardCastbarHolder
	if shouldDisable == currentlyDisabled then
		return
	end
	if shouldDisable then
		-- Another addon already manages the Blizzard bar: don't fight it for the frame.
		if IsBlizzardCastbarExternallyManaged() then
			return
		end
		if blizzardCastbarHolder == nil then
			blizzardCastbarHolder = CreateFrame("Frame")
			blizzardCastbarHolder:Hide()
		end
		blizzardCastbarOriginalParent = PlayerCastingBarFrame:GetParent()
		PlayerCastingBarFrame:SetParent(blizzardCastbarHolder)
		-- Catch future re-parents: re-evaluate whenever the Blizzard bar becomes visible again.
		if not blizzardCastbarHookInstalled then
			blizzardCastbarHookInstalled = true
			PlayerCastingBarFrame:HookScript("OnShow", function()
				TRB.Functions.Castbar:UpdateBlizzardCastbarVisibility()
			end)
		end
	else
		PlayerCastingBarFrame:SetParent(blizzardCastbarOriginalParent or UIParent)
	end
end

---Applies an enabled-state change from recomposed settings: tears down any active render when the
---castbar is now disabled, then re-evaluates Blizzard cast bar suppression. Idempotent.
---@param settings table? # Composed spec settings; defaults to the form-resolved display settings
function TRB.Functions.Castbar:SyncEnabledState(settings)
	if settings == nil then
		settings = TRB.Functions.Class:GetActiveDisplaySettings()
	end
	if not self:IsEnabled(self:GetVisibilitySettings(settings)) then
		local model = TRB.Data.castbar
		if model ~= nil and model:IsActive() then
			model:Stop()
		end
		self:EndRender()
	end
	self:UpdateBlizzardCastbarVisibility(settings)
end

---Whether the given cast state ("cast"/"channel"/"empower") may show per the visibility conditions.
---@param visibility table?
---@param state string
---@return boolean
function TRB.Functions.Castbar:IsCastTypeAllowed(visibility, state)
	if visibility == nil or visibility.neverShow == true then
		return false
	end
	if visibility.alwaysShow then
		return true
	end
	local conditions = visibility.conditions
	if conditions == nil then
		return true
	end
	if state == "channel" then
		return conditions.channeling == true
	elseif state == "empower" then
		return conditions.empowered == true
	end
	return conditions.casting == true
end

---Whether a hard-hide condition (In Vehicle) currently suppresses the castbar display. The model keeps
---tracking while force-hidden so the bar reappears mid-cast when the condition clears.
---@param visibility table?
---@return boolean
function TRB.Functions.Castbar:IsForceHidden(visibility)
	local hideConditions = visibility and visibility.hideConditions
	return hideConditions ~= nil and hideConditions.inVehicle == true and UnitInVehicle("player") == true
end

---Container alpha to rest at while no cast is active: activeAlpha when Always Show, else inactiveAlpha.
---0 whenever the castbar is disabled (Never Show / nothing checked).
---@param visibility table?
---@return number # 0..1
function TRB.Functions.Castbar:GetIdleAlpha(visibility)
	if visibility == nil or not self:IsEnabled(visibility) then
		return 0
	end
	if visibility.alwaysShow then
		return (visibility.activeAlpha or 100) / 100
	end
	return (visibility.inactiveAlpha or 0) / 100
end

---Returns the castbar BarGroup, or nil if not constructed.
---@return TRB.Classes.BarGroup?
function TRB.Functions.Castbar:GetGroup()
	local barGroups = TRB.Frames.barGroups
	return barGroups and barGroups.castbar or nil
end

---Returns the castbar's single node, or nil.
---@return TRB.Classes.BarNode?
function TRB.Functions.Castbar:GetNode()
	local group = self:GetGroup()
	return group and group:GetNode(1) or nil
end

-- Built-in tick profiles are static code data (the global set plus the active spec's registered set),
-- resolved from code -- NOT persisted -- so edits to the definitions always take effect on reload. Each
-- spec's resolved table is cached after the first lookup (keyed by compositeKey, like tickModifiersCache).
---@type table<string, table<integer, TRB.Classes.Settings.CastbarTickProfile>>
local tickProfilesCache = {}

---Returns the active spec's built-in tick profiles keyed by spellId (global profiles overlaid with the
---spec's own, spec winning on collision), or nil when no character/spec context is available.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>?
local function GetBuiltInTickProfiles()
	local character = TRB.Data.character
	local key = character and character.compositeKey
	if key == nil then
		return nil
	end
	local profiles = tickProfilesCache[key]
	if profiles == nil then
		profiles = TRB.Functions.Settings:DefaultGlobalCastbarTickProfiles()
		local registry = TRB.Data.castbarTickProfilesRegistry
		local getter = registry and registry[key]
		if type(getter) == "function" then
			TRB.Functions.Table:Merge(profiles, getter())
		end
		tickProfilesCache[key] = profiles
	end
	return profiles
end

---Resolves a channel tick profile for a spellId from the active spec's built-in code data.
---@param barSettings table?
---@param spellId integer?
---@return table?
function TRB.Functions.Castbar:GetTickProfile(barSettings, spellId)
	if barSettings == nil or spellId == nil or issecretvalue(spellId) then
		return nil
	end
	local profiles = GetBuiltInTickProfiles()
	if profiles == nil then
		return nil
	end
	return profiles[spellId]
end

---A talent/buff-conditional tick rule for a channeled spell, registered per spec in
---TRB.Data.castbarTickModifiersRegistry (code data, not settings; keyed "class_spec" like the profiles
---registry). bonusTicks: a number is a flat bonus whenever the talent is active; a table is the TOTAL
---bonus keyed by talent rank (unmapped ranks resolve to 0). tickMultiplier scales the count instead of
---adding to it (e.g. Double Tap's 80% more shots). Every rule's flat bonus lands before any multiplier, so
---a multiplier scales the count the other talents already built. Rules only apply to fixedCount profiles.
---bonusDuration shortens/lengthens the channel alongside its tick change (e.g. Cenarius' Guidance takes
---Convoke to 3s/12 ticks); it only feeds the reconstructed duration, since authoritative channel timing
---already reflects the talent.
---@class TRB.Classes.CastbarTickModifier
---@field public talentId integer # Talent (definition spellId) gating this rule, checked via the TRB.Data.talents cache
---@field public buffId integer? # When set, the player must also have this buff when the channel starts (checked against the spec's tracked snapshot when one exists, else a live aura scan)
---@field public bonusTicks (number|table<integer, number>)? # Flat bonus ticks (may be negative); omit on a multiplier-only rule
---@field public bonusDuration (number|table<integer, number>)? # Flat unhasted seconds added to baseDuration (may be negative); a table is the TOTAL bonus keyed by talent rank
---@field public tickMultiplier number? # Multiplies the tick count (post-bonus), rounded to a whole tick

-- Modifier rules are static code data; each spec's getter result is cached after the first lookup
-- (false = spec has no registered modifiers).
---@type table<string, table<integer, TRB.Classes.CastbarTickModifier[]>|false>
local tickModifiersCache = {}

---Returns the active spec's tick modifier rules for a spellId, or nil when none are registered.
---@param spellId integer
---@return TRB.Classes.CastbarTickModifier[]?
local function GetTickModifiers(spellId)
	local character = TRB.Data.character
	local key = character and character.compositeKey
	if key == nil then
		return nil
	end
	local rules = tickModifiersCache[key]
	if rules == nil then
		local registry = TRB.Data.castbarTickModifiersRegistry
		local getter = registry and registry[key]
		rules = type(getter) == "function" and getter() or false
		tickModifiersCache[key] = rules
	end
	return rules and rules[spellId] or nil
end

---Evaluates one modifier rule against live talent/buff state.
---@param rule TRB.Classes.CastbarTickModifier
---@return number # Flat bonus ticks this rule contributes (0 when its conditions aren't met)
---@return number # Tick count multiplier this rule contributes (1 when its conditions aren't met)
---@return number # Flat bonus duration in seconds this rule contributes (0 when its conditions aren't met)
local function EvaluateTickModifier(rule)
	local talents = TRB.Data.talents
	local talent = talents and talents.talents and talents.talents[rule.talentId] or nil
	if talent == nil or not talent:IsActive() then
		return 0, 1, 0
	end
	if rule.buffId ~= nil then
		-- Prefer the spec's tracked snapshot (handles secret aura data via instance-id binding);
		-- fall back to a live aura scan for buffs no spec module tracks.
		local snapshotData = TRB.Data.snapshotData
		local snapshot = snapshotData and snapshotData.snapshots and snapshotData.snapshots[rule.buffId]
		if snapshot ~= nil then
			if not snapshot.buff.isActive then
				return 0, 1, 0
			end
		elseif TRB.Functions.Aura:FindBuffById(rule.buffId) == nil then
			return 0, 1, 0
		end
	end
	local bonus = rule.bonusTicks
	if type(bonus) == "table" then
		bonus = bonus[talent.currentRank] or 0
	end
	local bonusDuration = rule.bonusDuration
	if type(bonusDuration) == "table" then
		bonusDuration = bonusDuration[talent.currentRank] or 0
	end
	return bonus or 0, rule.tickMultiplier or 1, bonusDuration or 0
end

-- Supercharged (charged) combo point slots, tracked because a finisher's charged point is already gone
-- from GetUnitChargedPowerPoints by the time UNIT_SPELLCAST_CHANNEL_START fires: with two supercharged
-- points the API reports the one left over, with one it reports none at all. Keeping the previous set (and
-- when it last changed) lets a channel start tell "this cast just consumed one" apart from "there were
-- none", which the live reading alone cannot do.
---@type integer[]
local chargedPoints = {}
---@type integer[]
local previousChargedPoints = {}
local chargedPointsChangedAt = 0

-- How recently the charged set must have changed for that change to be attributable to the cast starting
-- now. The consuming update and CHANNEL_START arrive together; a GCD separates them from any earlier cast.
local CHARGED_POINT_CONSUME_GRACE = 0.5

---Reads the player's charged combo point slot indices, dropping any the game hides.
---@return integer[]
local function ReadChargedPoints()
	local read = GetUnitChargedPowerPoints("player")
	local indices = {}
	if read ~= nil then
		for i = 1, #read do
			local index = read[i]
			if index ~= nil and not issecretvalue(index) then
				indices[#indices + 1] = index
			end
		end
	end
	return indices
end

local chargedPointsFrame = CreateFrame("Frame")
chargedPointsFrame:RegisterUnitEvent("UNIT_POWER_POINT_CHARGE", "player")
chargedPointsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
chargedPointsFrame:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		-- Charge events only fire on a change, so seed from the live state: a reload mid-charge would
		-- otherwise leave the tracker blind until the next charge came along.
		chargedPoints = ReadChargedPoints()
		previousChargedPoints = chargedPoints
		return
	end
	previousChargedPoints = chargedPoints
	chargedPoints = ReadChargedPoints()
	chargedPointsChangedAt = GetTime()
end)

---Counts charged slots that are filled by (and so spendable from) the given combo point count.
---@param indices integer[]
---@param comboPoints integer
---@return integer
local function CountSpendableChargedPoints(indices, comboPoints)
	local count = 0
	for i = 1, #indices do
		if indices[i] <= comboPoints then
			count = count + 1
		end
	end
	return count
end

---Whether the finisher starting now spends a supercharged combo point. The live set answers this whenever
---a charged point survives the cast; when it comes back empty, the previous set does -- but only if it
---changed just now, which is what tells a point consumed by this cast apart from one spent long ago.
---@param comboPoints integer
---@return boolean
local function SpendsChargedPoint(comboPoints)
	if CountSpendableChargedPoints(ReadChargedPoints(), comboPoints) > 0 then
		return true
	end
	if (GetTime() - chargedPointsChangedAt) > CHARGED_POINT_CONSUME_GRACE then
		return false
	end
	return CountSpendableChargedPoints(previousChargedPoints, comboPoints) > 0
end

---Resolves a per-cast tick count for a profile whose count varies (tickCountSource) rather than being a
---static tickCount. Read at channel start, which still sees the resource the finisher is about to spend.
---@param profile table
---@return integer? # Tick count for this cast, nil when the resource can't be read
local function ResolveDynamicTickCount(profile)
	if profile.tickCountSource ~= "comboPointsSpent" then
		return nil
	end
	local comboPoints = UnitPower("player", Enum.PowerType.ComboPoints, false)
	if comboPoints == nil or issecretvalue(comboPoints) or comboPoints <= 0 then
		return nil
	end
	-- A finisher consumes a single supercharged combo point, spending it as more than one point and so
	-- ticking more than once, no matter how many are charged.
	local bonusPerCharged = profile.bonusTicksPerChargedPoint or 0
	if bonusPerCharged > 0 and SpendsChargedPoint(comboPoints) then
		return comboPoints + bonusPerCharged
	end
	return comboPoints
end

---Resolves the effective tick profile for a channel start: the baseline profile with its per-cast tick
---count resolved (when it has one) and any registered talent/buff-conditional bonus ticks applied.
---Returns a copy when either applies -- the built-in profile is never mutated. Call once per channel start
---and reuse via model.profile: the combo points a dynamic count reads, and buff-gated bonuses (e.g. a buff
---consumed by this very cast), are both gone by the time the channel is underway.
---@param barSettings table?
---@param spellId integer?
---@return table?
function TRB.Functions.Castbar:ResolveTickProfile(barSettings, spellId)
	local profile = self:GetTickProfile(barSettings, spellId)
	if profile == nil then
		return nil
	end

	-- An unreadable dynamic count leaves nothing to lay out: render the channel without tick marks.
	local dynamicCount
	if profile.tickCountSource ~= nil then
		dynamicCount = ResolveDynamicTickCount(profile)
		if dynamicCount == nil then
			return nil
		end
	end

	local baseCount = dynamicCount or profile.tickCount or 0
	local bonus = 0
	local multiplier = 1
	local durationBonus = 0
	local rules = GetTickModifiers(spellId)
	if rules ~= nil and profile.mode == "fixedCount" and baseCount > 0 then
		for _, rule in ipairs(rules) do
			local ruleBonus, ruleMultiplier, ruleDuration = EvaluateTickModifier(rule)
			bonus = bonus + ruleBonus
			multiplier = multiplier * ruleMultiplier
			durationBonus = durationBonus + ruleDuration
		end
	end
	if dynamicCount == nil and bonus == 0 and multiplier == 1 and durationBonus == 0 then
		return profile
	end

	local effective = {}
	for k, v in pairs(profile) do
		effective[k] = v
	end
	-- Flat bonuses land first: a multiplier (e.g. Double Tap) scales the count the talents already built.
	effective.tickCount = math.floor(((baseCount + bonus) * multiplier) + 0.5)
	if dynamicCount ~= nil then
		-- Only used to reconstruct the channel when the game reports secret times; the tick spacing itself
		-- comes from the authoritative duration.
		effective.baseDuration = (profile.baseTickRate or 0) * effective.tickCount
	elseif durationBonus ~= 0 and profile.baseDuration ~= nil then
		-- Talents that shorten the channel along with its ticks (e.g. Cenarius' Guidance). Only reached on a
		-- reconstructed channel; authoritative timing already reflects the talent.
		effective.baseDuration = math.max(profile.baseDuration + durationBonus, 0)
	end
	return effective
end

-- ============================================================================
-- Overlay / threshold-line texture pool (fraction-positioned, on the node frame)
-- ============================================================================

---Lazily builds (and returns) the castbar overlay texture pool bound to the current node frame.
---Rebuilt if the node frame changed (e.g., bar groups were reconstructed).
---@param node TRB.Classes.BarNode
---@return table
local function GetOverlayPool(node)
	local frame = node.frame
	---@diagnostic disable-next-line: inject-field
	local pool = frame._trbCastbarOverlays
	if pool and pool.frame == frame then
		return pool
	end
	pool = { frame = frame, ticks = {}, empower = {}, segments = {} }
	pool.latency = frame:CreateTexture(nil, "OVERLAY")
	pool.latency:SetColorTexture(1, 0, 0, 0.5)
	pool.latency:Hide()
	pool.pushback = frame:CreateTexture(nil, "OVERLAY")
	pool.pushback:SetColorTexture(1, 0, 1, 0.5)
	pool.pushback:Hide()
	---@diagnostic disable-next-line: inject-field
	frame._trbCastbarOverlays = pool
	return pool
end

---Places a vertical (horizontal bar) or horizontal (vertical bar) line at a timeline fraction.
---@param tex table # Texture
---@param node TRB.Classes.BarNode
---@param frac number # Timeline fraction 0..1 (0 = fill start)
---@param isVertical boolean # True when the bar fills vertically
---@param thickness number
local function PlaceLine(tex, node, frac, isVertical, thickness)
	local border = node.border or 0
	local w, h = node.width, node.height
	local innerW = math.max(1, w - 2 * border)
	local innerH = math.max(1, h - 2 * border)
	local fillDirection = node.fillDirection or "leftRight"
	tex:ClearAllPoints()
	if isVertical then
		local yFromBottom
		if fillDirection == "topBottom" then
			yFromBottom = border + (1 - frac) * innerH
		else
			yFromBottom = border + frac * innerH
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", border, yFromBottom - thickness / 2)
		tex:SetSize(innerW, thickness)
	else
		local xFromLeft
		if fillDirection == "rightLeft" then
			xFromLeft = border + (1 - frac) * innerW
		else
			xFromLeft = border + frac * innerW
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", xFromLeft - thickness / 2, border)
		tex:SetSize(thickness, innerH)
	end
end

---Places a filled region spanning timeline fractions [fA, fB] (fA < fB).
---@param tex table # Texture
---@param node TRB.Classes.BarNode
---@param fA number
---@param fB number
---@param isVertical boolean
local function PlaceRegion(tex, node, fA, fB, isVertical)
	local border = node.border or 0
	local w, h = node.width, node.height
	local innerW = math.max(1, w - 2 * border)
	local innerH = math.max(1, h - 2 * border)
	local fillDirection = node.fillDirection or "leftRight"
	if fA > fB then fA, fB = fB, fA end
	tex:ClearAllPoints()
	if isVertical then
		local y1, y2
		if fillDirection == "topBottom" then
			y1 = border + (1 - fB) * innerH
			y2 = border + (1 - fA) * innerH
		else
			y1 = border + fA * innerH
			y2 = border + fB * innerH
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", border, y1)
		tex:SetSize(innerW, math.max(1, y2 - y1))
	else
		local x1, x2
		if fillDirection == "rightLeft" then
			x1 = border + (1 - fB) * innerW
			x2 = border + (1 - fA) * innerW
		else
			x1 = border + fA * innerW
			x2 = border + fB * innerW
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", x1, border)
		tex:SetSize(math.max(1, x2 - x1), innerH)
	end
end

---Returns a pooled tick line texture at index i, creating it on demand.
local function GetTickTexture(pool, node, i)
	if pool.ticks[i] == nil then
		local t = node.frame:CreateTexture(nil, "OVERLAY")
		t:SetDrawLayer("OVERLAY", 2)
		pool.ticks[i] = t
	end
	return pool.ticks[i]
end

---Returns a pooled empower stage line texture at index i, creating it on demand.
local function GetEmpowerTexture(pool, node, i)
	if pool.empower[i] == nil then
		local t = node.frame:CreateTexture(nil, "OVERLAY")
		t:SetDrawLayer("OVERLAY", 3)
		pool.empower[i] = t
	end
	return pool.empower[i]
end

---Returns a pooled empower segment-fill texture at index i, creating it on demand. Sits at ARTWORK --
---above the bar background but below the OVERLAY latency/pushback/tick/boundary overlays, so those still
---render on top of the segment fills.
local function GetSegmentTexture(pool, node, i)
	if pool.segments[i] == nil then
		local t = node.frame:CreateTexture(nil, "ARTWORK")
		t:SetDrawLayer("ARTWORK", 1)
		pool.segments[i] = t
	end
	return pool.segments[i]
end

---Hides all pooled overlay textures.
local function HideOverlays(pool)
	if pool == nil then return end
	if pool.latency then pool.latency:Hide() end
	if pool.pushback then pool.pushback:Hide() end
	for _, t in ipairs(pool.ticks) do t:Hide() end
	for _, t in ipairs(pool.empower) do t:Hide() end
	for _, t in ipairs(pool.segments) do t:Hide() end
end

-- ============================================================================
-- Per-state fill color
-- ============================================================================

---Whether PvP is currently "enabled" for the target-class-color PvP-only sub-option: player flagged,
---War Mode desired, or inside a battleground/arena instance. Mirrors the visibility system's PvP rules.
---@return boolean
local function IsPvpEnabled()
	if UnitIsPVP("player") or C_PvP.IsWarModeDesired() then
		return true
	end
	local instanceType = TRB.Data.character.instanceType
	return instanceType == "pvp" or instanceType == "arena"
end

---Resolves the current target's class color as an AARRGGBB hex string when the "color cast bar by target
---class" option applies: the target is a player, hostile (or friendly when the friendly sub-option is set),
---and PvP is enabled when the PvP-only sub-option is set. Returns nil to fall through to the configured
---cast colors. Called every frame while a cast is on screen, so the checks are ordered cheapest-first.
---@param barSettings table?
---@return string?
local function GetTargetClassColor(barSettings)
	if barSettings == nil or barSettings.targetClassColor ~= true then
		return nil
	end
	if not UnitExists("target") or not UnitIsPlayer("target") then
		return nil
	end
	-- Enemy players by default; friendly targets only recolor when the friendly sub-option opts them in.
	if UnitIsFriend("player", "target") and barSettings.targetClassColorFriendly ~= true then
		return nil
	end
	if barSettings.targetClassColorPvpOnly == true and not IsPvpEnabled() then
		return nil
	end
	local _, classFilename = UnitClass("target")
	if classFilename == nil or issecretvalue(classFilename) then
		return nil
	end
	local color = C_ClassColor.GetClassColor(classFilename)
	if color == nil then
		return nil
	end
	return TRB.Functions.Color:ConvertColorDecimalToHex(color.r, color.g, color.b, 1)
end

---Hides only the pooled empower segment-fill textures, leaving the latency overlay intact. Used when a
---target-class-color override replaces the segmented empower fill with a single color.
---@param node TRB.Classes.BarNode
local function HideEmpowerSegments(node)
	local pool = GetOverlayPool(node)
	for _, t in ipairs(pool.segments) do t:Hide() end
end

---Applies the fill color for the current cast state (and empower stage), honoring uninterruptible.
---An indicator claiming the fill outranks the uninterruptible color: the uninterruptible border still
---marks the cast, so nothing is lost by letting the indicator through.
---@param node TRB.Classes.BarNode
---@param colors table
---@param model TRB.Classes.Castbar
---@param barSettings table? # Castbar settings; when empowerSegmentedFill is set the empower fill is blanked
local function ApplyStateFillColor(node, colors, model, barSettings)
	local Color = TRB.Functions.Color
	if colors == nil then return end

	-- Color the fill by the current target's class color (PvP identification aid). It replaces the
	-- configured per-state colors -- including the empower stage colors and the uninterruptible color --
	-- but sits just below an active fill indicator, which still wins (resolved in the cast/channel path).
	local classColor = GetTargetClassColor(barSettings)

	-- Empowered casts always use the empower stage colors, even when uninterruptible: stage progression
	-- is the point of the bar, so it should never be flattened to a plain "can't interrupt" color. For the
	-- same reason indicators don't claim the empower fill either.
	if model.state == "empower" then
		-- Target class color overrides the stage colors entirely; the caller suppresses (and clears) the
		-- segmented fill so this single color shows through.
		if classColor ~= nil then
			Color:ApplyFillColor(node, classColor)
			return
		end
		-- Segmented-fill mode: blank the main fill so DrawEmpowerSegments can paint each level's segment in
		-- its own color; there is no single advancing fill color to apply here.
		if barSettings and barSettings.empowerSegmentedFill then
			Color:ApplyFillColor(node, "00000000")
			return
		end
		local stageColors = colors.empowerStages
		-- GetCurrentEmpowerStage returns the absolute empower level reached: 0 while charging toward Level I,
		-- then 1..N as each level threshold is crossed. Color maps directly: stage 0 -> base, stage N ->
		-- levelN (clamped to the game's max of 4 empower levels).
		local stage = model:GetCurrentEmpowerStage()
		local entry
		if stageColors then
			if stage <= 0 then
				entry = stageColors.base
			else
				entry = stageColors["level" .. math.min(stage, 4)]
			end
		end
		Color:ApplyFillColor(node, entry or colors.bar)
		return
	end

	local isChannel = model.state == "channel"
	local indicators = Color:GetResolvedIndicators("castbar")
	local entry = indicators and indicators[isChannel and "channel" or "bar"]
	-- Target class color sits below an active indicator but above the uninterruptible/configured colors.
	if entry == nil and classColor ~= nil then
		entry = classColor
	end
	if entry == nil and model.notInterruptible then
		entry = colors.uninterruptible
	end
	if entry == nil then
		entry = isChannel and (colors.channel or colors.bar) or colors.bar
	end
	Color:ApplyFillColor(node, entry)
end

---Applies the border and background colors for the current cast. A flat indicator targeting either one wins;
---failing that the border falls back to the uninterruptible border while the cast can't be interrupted, then
---to the configured colors. Whatever color that settles on, a gradient (secret-value) indicator targeting
---the element then turns it into a resource-threshold curve.
---Unlike the resource bars, the cast bar has no per-frame color push of its own -- its border/background
---are otherwise only set by ApplyCustomBarGroupsAppearance on a settings change -- so this is what lets an
---indicator (or an uninterruptible cast) recolor it while it is on screen. The setters cache, so calling
---this every frame costs nothing when the color hasn't moved.
---@param node TRB.Classes.BarNode
---@param colors table?
---@param model TRB.Classes.Castbar? # Omitted for the idle bar, which is never uninterruptible
local function ApplyBorderAndBackgroundColor(node, colors, model)
	if colors == nil then return end
	local Color = TRB.Functions.Color
	local indicators = Color:GetResolvedIndicators("castbar")

	local border = indicators and indicators.border
	if border == nil and model ~= nil and model.notInterruptible and model.state ~= "empower"
		and colors.uninterruptibleBorder then
		border = colors.uninterruptibleBorder.color
	end
	if border == nil and colors.border then
		border = colors.border.color
	end
	Color:ApplyResolvedBorderOrBackground(node, "castbar", "border", border)

	local background = indicators and indicators.background
	if background == nil and colors.background then
		background = colors.background.color
	end
	Color:ApplyResolvedBorderOrBackground(node, "castbar", "background", background)
	Color:ApplyResolvedEndCap(node, "castbar")
end

---Draws the per-level empower segment fills (segmented-fill mode). The main bar fill is blanked in this
---mode; each segment between empower thresholds fills in its own level color up to the live progress.
---Boundaries are {0} + empowerStageFractions + {1.0}: segment 0 is `base`, segment k is `levelN` (clamped
---to 4) -- the same stage->color mapping as ApplyStateFillColor's single-color path. Redrawn every frame.
---@param node TRB.Classes.BarNode
---@param colors table
---@param model TRB.Classes.Castbar
---@param fill number # Current timeline fill fraction (0..1)
local function DrawEmpowerSegments(node, colors, model, fill)
	local pool = GetOverlayPool(node)
	local stageColors = colors and colors.empowerStages
	local fractions = model.empowerStageFractions
	local n = fractions and #fractions or 0
	if stageColors == nil or n == 0 then
		-- Fractions not computed yet: nothing to segment, so clear any leftover segment textures.
		for _, t in ipairs(pool.segments) do t:Hide() end
		return
	end

	local isVertical = TRB.Functions.Bar:IsVerticalFill(node.fillDirection)
	local drawn = 0
	-- N+1 segments (k = 0..n): [0,f1], [f1,f2], ..., [fn,1.0]. Each fills from its start to min(fill, end).
	for k = 0, n do
		local a = (k == 0) and 0 or fractions[k]
		local b = (k == n) and 1 or fractions[k + 1]
		if b > a and fill > a + 0.0001 then
			local entry = (k == 0) and stageColors.base or stageColors["level" .. math.min(k, 4)]
			local color = (type(entry) == "table" and entry.color) or entry
			if color then
				drawn = drawn + 1
				local t = GetSegmentTexture(pool, node, drawn)
				local cr, cg, cb, ca = TRB.Functions.Color:GetRGBAFromString(color, true)
				t:SetColorTexture(cr, cg, cb, ca)
				PlaceRegion(t, node, a, math.min(fill, b), isVertical)
				t:Show()
			end
		end
	end
	-- Hide any pooled segment textures not used this frame (e.g. earlier stages once fill passes them is
	-- fine -- they stay drawn; this only trims the tail beyond the highest-index segment drawn).
	for i = drawn + 1, #pool.segments do
		pool.segments[i]:Hide()
	end
end

-- ============================================================================
-- Setup (once per cast) and teardown
-- ============================================================================

---Returns the latency overlay fraction actually shown for the current cast/channel (0 when disabled by
---settings or when latency is zero). SetupOverlays draws the zone on the bar's ending side (high-fraction
---end for casts/empowers, low-fraction end for depleting channels). Also feeds cast pushback placement so
---the pushback region sits flush against the latency zone.
---@param model TRB.Classes.Castbar
---@param barSettings table?
---@param colors table?
---@return number
local function GetShownLatencyFraction(model, barSettings, colors)
	if not (colors and colors.latency and colors.latency.enabled and barSettings and barSettings.showLatency ~= false) then
		return 0
	end
	return model:GetLatencyFraction() or 0
end

---Places the static overlays and threshold lines for the freshly-started cast/channel/empower.
---@param model TRB.Classes.Castbar
function TRB.Functions.Castbar:SetupOverlays(model)
	local node = self:GetNode()
	if node == nil then return end
	local _, barSettings, colors = self:GetActiveSettings()
	local pool = GetOverlayPool(node)
	HideOverlays(pool)

	local isVertical = TRB.Functions.Bar:IsVerticalFill(node.fillDirection)
	local tickThickness = (barSettings and barSettings.tickWidth) or 1

	-- Latency zone: the final `latency` window (safe-to-queue region), drawn on the bar's ending side. A
	-- cast/empower grows L->R and ends at fraction 1, so its zone is [1-latFrac, 1]; a channel depletes
	-- toward fraction 0, so its ending-side zone is [0, latFrac].
	local latFrac = GetShownLatencyFraction(model, barSettings, colors)
	if latFrac > 0 then
		-- latFrac > 0 implies colors.latency exists (see GetShownLatencyFraction).
		---@diagnostic disable-next-line: need-check-nil
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colors.latency.color, true)
		pool.latency:SetColorTexture(r, g, b, a)
		if model.state == "channel" then
			PlaceRegion(pool.latency, node, 0, latFrac, isVertical)
		else
			PlaceRegion(pool.latency, node, 1 - latFrac, 1, isVertical)
		end
		pool.latency:Show()
	end

	-- Channel ticks sit at each tick's bar fraction (see ComputeChannelTicks, which mirrors fixedRate for depletion).
	if colors and colors.tick and colors.tick.enabled ~= false and barSettings and barSettings.showTicks ~= false
		and model.state == "channel" and model.ticks then
		-- The empower stage lines below deliberately keep the configured tick color: the indicator target is
		-- scoped to channel ticks, and empower lines only borrow that color for want of one of their own.
		local indicators = TRB.Functions.Color:GetResolvedIndicators("castbar")
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString((indicators and indicators.tick) or colors.tick.color, true)
		-- Latency-sized ticks (spell channels only): each mark spans one latency window toward the higher-time end.
		local tickLatFrac = 0
		if barSettings.tickLatencyWidth == true and not model.tradeskill then
			tickLatFrac = model:GetLatencyFraction() or 0
			-- Regions that would merge into a solid fill (latency window >= tick interval) degrade to plain lines.
			local spacing = (model.tickInterval ~= nil and model.duration ~= nil and model.duration > 0) and (model.tickInterval / model.duration) or 0
			if spacing <= 0 or tickLatFrac >= spacing then
				tickLatFrac = 0
			end
		end
		for i, tick in ipairs(model.ticks) do
			if tick.fraction >= -0.0001 and tick.fraction < 1.0001 then
				local t = GetTickTexture(pool, node, i)
				t:SetColorTexture(r, g, b, a)
				if tickLatFrac > 0 then
					-- Ticks are stored in decreasing-fraction order; cap at the neighbor so a carried
					-- partial tick's shortened gap can't overlap the region next to it.
					local cap = (i > 1 and model.ticks[i - 1].fraction) or 1
					PlaceRegion(t, node, tick.fraction, math.min(tick.fraction + tickLatFrac, cap, 1), isVertical)
				else
					PlaceLine(t, node, tick.fraction, isVertical, tickThickness)
				end
				t:Show()
			end
		end
	end

	-- Empower stage boundary lines.
	if barSettings and barSettings.showEmpowerStages ~= false and model.state == "empower"
		and model.empowerStageFractions then
		local lineColor = (colors and colors.tick and colors.tick.color) or "FFFFFFFF"
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(lineColor, true)
		for i, frac in ipairs(model.empowerStageFractions) do
			-- Skip the final boundary at ~1.0 (the bar end needs no line).
			if frac > 0.0001 and frac < 0.9999 then
				local t = GetEmpowerTexture(pool, node, i)
				t:SetColorTexture(r, g, b, a)
				PlaceLine(t, node, frac, isVertical, tickThickness)
				t:Show()
			end
		end
	end
end

---Repositions the pushback overlay to reflect the current accumulated pushback (called on delay events).
---@param model TRB.Classes.Castbar
function TRB.Functions.Castbar:UpdatePushbackOverlay(model)
	local node = self:GetNode()
	if node == nil then return end
	local _, barSettings, colors = self:GetActiveSettings()
	local pool = GetOverlayPool(node)
	pool.pushback:Hide()
	if colors == nil or colors.pushback == nil or colors.pushback.enabled == false then return end
	if barSettings and barSettings.showPushback == false then return end
	local pbFrac = model:GetPushbackFraction()
	if pbFrac == nil then return end
	local isVertical = TRB.Functions.Bar:IsVerticalFill(node.fillDirection)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colors.pushback.color, true)
	pool.pushback:SetColorTexture(r, g, b, a)
	-- Pushback sits flush against the inner edge of the latency zone (or the bar end when no latency
	-- overlay is shown), since latency always occupies the final stretch of the timeline.
	local outer = 1 - GetShownLatencyFraction(model, barSettings, colors)
	PlaceRegion(pool.pushback, node, math.max(0, outer - pbFrac), outer, isVertical)
	pool.pushback:Show()
end

---Applies the full visible render state (dimensions, fill color, overlays, alpha, Show) onto the
---castbar group/node. Idempotent and cheap to call every frame; the expensive overlay/color setup is
---only re-run when the node's frame changes (i.e., bar groups were reconstructed out from under us).
---Deliberately bypasses the BarGroup fade system: render transitions and HideResourceBar zero every
---group's alpha AND hide it, but the castbar isn't part of BarVisibility:ProcessBars so nothing ever
---restores it. Re-asserting alpha/visibility directly here each frame makes the castbar self-heal.
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode
---@param colors table?
---@param model TRB.Classes.Castbar
---@param barSettings table?
---@param visibility table? # displayBar.castbar entry; supplies activeAlpha
function TRB.Functions.Castbar:ApplyVisibleState(group, node, colors, model, barSettings, visibility)
	-- The fill color and the overlay textures are only worth rebuilding when something they depend on moves:
	-- a new node frame, or an indicator flipping mid-cast (which the version stamp reports).
	local indicatorVersion = TRB.Functions.Color:GetResolvedIndicatorVersion()
	local targetColor = GetTargetClassColor(barSettings)
	if self._renderedFrame ~= node.frame or self._renderedIndicatorVersion ~= indicatorVersion then
		self._renderedFrame = node.frame
		self._renderedIndicatorVersion = indicatorVersion
		self._renderedTargetColor = targetColor
		node:SetMinMax(0, 1)
		ApplyStateFillColor(node, colors, model, barSettings)
		self:SetupOverlays(model)
	elseif self._renderedTargetColor ~= targetColor then
		-- Target (and so its class color) changed mid-cast: re-apply just the fill. Empower re-applies
		-- ApplyStateFillColor every frame from the updater, so it needs no handling here.
		self._renderedTargetColor = targetColor
		if model.state ~= "empower" then
			ApplyStateFillColor(node, colors, model, barSettings)
		end
	end
	-- Not version-gated: a gradient indicator is a curve over a secret resource value, so its color moves
	-- with the resource, not with the indicator flipping on and off.
	ApplyBorderAndBackgroundColor(node, colors, model)
	-- Track the casting spell's icon every frame so a chained cast swapping spells mid-render updates it.
	-- SetIconTexture no-ops when the texture is unchanged, so this stays cheap.
	if barSettings ~= nil and barSettings.icon ~= nil and barSettings.icon.enabled then
		node:SetIconTexture(model.spell and model.spell.iconId or nil)
		node:SetIconVisible(model.spell ~= nil)
	end
	local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
	-- Keep the shared fade fields synced so anything that consults them stays consistent, but we
	-- drive the actual container alpha directly rather than through UpdateFade.
	group.targetAlpha = activeAlpha
	group.currentAlpha = activeAlpha
	if not group.isVisible then
		group:Show()
		-- The group just transitioned hidden->visible (fresh cast, or after a render transition /
		-- reconstruction hid it). Mark visibility dirty so the next ProcessBars re-runs BarText:Show and
		-- reveals this castbar's anchored text frames (whose isVisible tracks this group's isVisible).
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(activeAlpha)
end

---Applies the fully-hidden state (alpha 0 + Hide) without touching the model.
---@param group TRB.Classes.BarGroup
local function ApplyHiddenState(group)
	group.targetAlpha = 0
	group.currentAlpha = 0
	if group.isVisible then
		group:Hide()
	end
	group.containerFrame:SetAlpha(0)
end

---Applies the idle (no active cast) visible state: empty fill, no overlays, resting at idleAlpha.
---Used for Always Show and non-zero inactive alpha; re-asserted per frame so it self-heals after
---render transitions the same way the active render does. The border/background still track their
---indicators here -- the bar is on screen, so an indicator targeting it should show.
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode
---@param idleAlpha number # 0..1
---@param colors table?
function TRB.Functions.Castbar:ApplyIdleState(group, node, idleAlpha, colors)
	if self._renderedFrame ~= nil then
		self._renderedFrame = nil
		self._renderedIndicatorVersion = nil
		self._renderedTargetColor = nil
		---@diagnostic disable-next-line: inject-field
		HideOverlays(node.frame._trbCastbarOverlays)
	end
	node:SetMinMax(0, 1)
	node:SetValue(0)
	-- No spell is casting, so the icon has nothing to show. Its reserved strip stays claimed by the
	-- layout, keeping the bar the same size whether idle or active. Clearing the texture (rather than
	-- just hiding) stops a layout rebuild from resurrecting the last cast's icon.
	node:SetIconTexture(nil)
	-- No model: an idle bar is never uninterruptible, so only the indicator/configured colors apply.
	ApplyBorderAndBackgroundColor(node, colors, nil)
	group.targetAlpha = idleAlpha
	group.currentAlpha = idleAlpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(idleAlpha)
end

---Begins showing the castbar for a freshly-started cast: sizes the node, applies color/overlays, shows
---it at the active alpha, and starts the per-frame updater. No-op if the castbar is disabled (Never Show).
function TRB.Functions.Castbar:BeginRender()
	local settings, barSettings, colors = self:GetActiveSettings()
	local visibility = self:GetVisibilitySettings(settings)
	if not self:IsEnabled(visibility) then
		return
	end
	local group = self:GetGroup()
	local node = self:GetNode()
	if group == nil or node == nil then
		return
	end
	local model = TRB.Data.castbar
	fadeOutStart = nil
	fillComplete = nil

	node:SetValue(0)
	-- Force ApplyVisibleState to (re)place the colors and overlays for this fresh cast
	self._renderedFrame = nil
	self._renderedIndicatorVersion = nil
	self._renderedTargetColor = nil
	if self:IsForceHidden(visibility) then
		-- Hard-hide condition active (e.g. In Vehicle): keep tracking but stay hidden; the per-frame
		-- updater reveals the bar mid-cast if the condition clears.
		ApplyHiddenState(group)
	else
		self:ApplyVisibleState(group, node, colors, model, barSettings, visibility)
	end

	-- Mark visibility dirty so the next ProcessBars pass re-evaluates and (via its castbar-active check)
	-- keeps isTracking true — that's what makes the shared, class-driven UpdateResourceBarText keep
	-- rendering this castbar's anchored bar text for the duration of the cast. Bar text is NOT rendered
	-- here or from the per-frame updater; it flows through the single existing path (no double updates).
	TRB.Functions.BarVisibility:MarkDirty()

	isRunning = true
	castbarFrame:Show()
end

---Ends the castbar render, hiding instantly and clearing overlays. Used for disable (Never Show) and
---other immediate teardowns; natural cast ends go through BeginFadeOut instead.
function TRB.Functions.Castbar:EndRender()
	local group = self:GetGroup()
	local node = self:GetNode()
	self._renderedFrame = nil
	self._renderedIndicatorVersion = nil
	self._renderedTargetColor = nil
	fadeOutStart = nil
	fillComplete = nil
	if node then
		---@diagnostic disable-next-line: inject-field
		HideOverlays(node.frame._trbCastbarOverlays)
		node:SetIconTexture(nil)
	end
	if group then
		ApplyHiddenState(group)
	end
	-- Re-evaluate visibility now the cast is over: isTracking / bar text can revert to whatever the
	-- standard bars dictate (e.g. hide out of combat), and the castbar-anchored text stops updating.
	TRB.Functions.BarVisibility:MarkDirty()
	isRunning = false
	castbarFrame:Hide()
end

---Captures a fill-completion animation for a natural cast/channel finish, so the fade-out advances the
---fill the rest of the way to "done" (cast/tradeskill -> full, channel -> empty) instead of freezing it
---a few percent short. Latency makes the STOP event land inside the timeline's ending latency window, so
---only a stop within that window (plus jitter margin) counts as a finish -- a cast aborted well before
---the end (interrupt/cancel) fails the check and keeps its frozen fill. Empower is excluded: its release
---is deliberate and the fill at release reflects the stage reached, so it must not snap to full. Call
---with the model still active, before Stop().
---@param model TRB.Classes.Castbar
function TRB.Functions.Castbar:CaptureCompletion(model)
	fillComplete = nil
	if model.state ~= "cast" and model.state ~= "channel" then
		return
	end
	local _, remaining, _, fill = model:GetProgress()
	-- A genuine finish lands within the end-of-timeline latency window; anything with more time left was
	-- cut short. The margin covers latency jitter between cast start (when model.latency was sampled) and now.
	if remaining > (model.latency or 0) + 0.2 then
		return
	end
	fillComplete = {
		from = fill,
		to = (model.state == "channel") and 0 or 1,
		remaining = remaining
	}
end

---Begins the post-cast fade-out honoring fadeDelay/fadeDuration, resting at the idle alpha (Always Show /
---inactive alpha) when done. Falls back to an instant EndRender when no fade is configured and nothing
---rests visible.
function TRB.Functions.Castbar:BeginFadeOut()
	local settings = TRB.Functions.Class:GetActiveDisplaySettings()
	local visibility = self:GetVisibilitySettings(settings)
	local group = self:GetGroup()
	local delay = (visibility and visibility.fadeDelay) or 0
	local duration = (visibility and visibility.fadeDuration) or 0
	if group == nil or not self:IsEnabled(visibility) or self:IsForceHidden(visibility)
		or (delay <= 0 and duration <= 0 and self:GetIdleAlpha(visibility) <= 0) then
		self:EndRender()
		return
	end
	-- The per-frame updater's idle branch drives the hold, fade, and final resting state.
	fadeOutStart = GetTime()
	isRunning = true
	castbarFrame:Show()
end

---Ensures the idle Always Show / inactive-alpha display is running when no cast is active. Cheap and
---safe to call every tick (ProcessBars does); starts the per-frame updater when the resting alpha is
---non-zero so the idle bar renders and self-heals.
function TRB.Functions.Castbar:EnsureIdleState()
	if isRunning then
		return
	end
	local model = TRB.Data.castbar
	if model ~= nil and model:IsActive() then
		return
	end
	local visibility = self:GetVisibilitySettings(nil)
	if self:GetIdleAlpha(visibility) > 0 then
		isRunning = true
		castbarFrame:Show()
	end
end

-- ============================================================================
-- Per-frame updater
-- ============================================================================

castbarFrame:SetScript("OnUpdate", function()
	local self = TRB.Functions.Castbar
	local model = TRB.Data.castbar
	local group = self:GetGroup()
	if group == nil then
		isRunning = false
		castbarFrame:Hide()
		return
	end
	local node = group:GetNode(1)
	local settings, barSettings, colors = self:GetActiveSettings()
	local visibility = self:GetVisibilitySettings(settings)

	if model and model:IsActive() and node then
		local now = GetTime()

		-- Safety: if events were missed and the timeline elapsed, tear down.
		if model.endTime and now > model.endTime + 0.25 then
			model:Stop()
			self:BeginFadeOut()
			return
		end

		-- Bulk crafting halted early (no next craft within the grace window after a craft completed:
		-- out of reagents, profession window closed, crafting stopped): end the merged bar.
		if model.tradeskillWaitUntil ~= nil and now > model.tradeskillWaitUntil then
			model:Stop()
			self:BeginFadeOut()
			return
		end

		-- Yield to an active render transition: it deliberately hides ALL bars briefly during a
		-- reconstruction. We simply re-assert on the next frame after it ends, so the castbar isn't
		-- left permanently hidden (which is exactly what happened before: the transition hides + zeroes
		-- the castbar's alpha, ProcessBars restores every OTHER bar afterward, but never the castbar).
		if not TRB.Functions.Bar:IsRenderTransitionActive() then
			if not self:IsEnabled(visibility) then
				-- Never Show flipped mid-cast: stop tracking entirely.
				model:Stop()
				self:EndRender()
				return
			end
			if self:IsForceHidden(visibility) then
				ApplyHiddenState(group)
			else
				self:ApplyVisibleState(group, node, colors, model, barSettings, visibility)

				local _, _, _, fill = model:GetProgress(now)
				node:SetValue(fill)

				-- Empower fill advances with the current stage. In segmented mode the main fill is blanked
				-- and each level's segment fills to the live progress in its own color instead -- unless a
				-- target class color override is active, which paints a single color and clears the segments.
				if model.state == "empower" then
					ApplyStateFillColor(node, colors, model, barSettings)
					if barSettings and barSettings.empowerSegmentedFill then
						if GetTargetClassColor(barSettings) ~= nil then
							HideEmpowerSegments(node)
						else
							DrawEmpowerSegments(node, colors, model, fill)
						end
					end
				end
			end
		end
	elseif node then
		-- Idle: hold/fade out after a cast ends, then rest at the idle alpha (Always Show / inactive
		-- alpha) or fully hide and stop the updater until the next cast.
		local idleAlpha = self:GetIdleAlpha(visibility)
		if self:IsForceHidden(visibility) then
			idleAlpha = 0
			fadeOutStart = nil
			fillComplete = nil
		end

		if fadeOutStart ~= nil and self:IsEnabled(visibility) then
			local delay = (visibility and visibility.fadeDelay) or 0
			local duration = (visibility and visibility.fadeDuration) or 0
			local elapsed = GetTime() - fadeOutStart
			local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
			local fadeAlpha
			if elapsed < delay then
				-- Hold the finished bar at active alpha for the fade delay.
				fadeAlpha = activeAlpha
			elseif duration > 0 and elapsed < delay + duration then
				fadeAlpha = activeAlpha + (idleAlpha - activeAlpha) * ((elapsed - delay) / duration)
			end
			if fadeAlpha ~= nil then
				-- Self-heal like the active render: transitions/HideResourceBar hide every group and only
				-- ProcessBars entries get restored, so re-assert visibility each frame while fading.
				if not TRB.Functions.Bar:IsRenderTransitionActive() then
					-- Keep advancing the fill to done across the hold/fade so a latency-early STOP doesn't
					-- leave it frozen short. Move at the cast's own pace (remaining time) when the visible
					-- window allows; otherwise compress into that window so it still reaches the end on screen.
					if fillComplete ~= nil then
						local window = delay + duration
						local span = fillComplete.remaining
						if window > 0 and window < span then span = window end
						local ct = (span > 0) and math.min(1, elapsed / span) or 1
						node:SetValue(fillComplete.from + (fillComplete.to - fillComplete.from) * ct)
					end
					group.targetAlpha = fadeAlpha
					group.currentAlpha = fadeAlpha
					if not group.isVisible then
						group:Show()
						TRB.Functions.BarVisibility:MarkDirty()
					end
					node:Show()
					group.containerFrame:SetAlpha(fadeAlpha)
				end
				return
			end
			fadeOutStart = nil
			fillComplete = nil
		end

		if idleAlpha > 0 then
			-- Keep running: the idle display must self-heal against render transitions.
			if not TRB.Functions.Bar:IsRenderTransitionActive() then
				self:ApplyIdleState(group, node, idleAlpha, colors)
			end
		else
			self._renderedFrame = nil
			self._renderedIndicatorVersion = nil
			ApplyHiddenState(group)
			isRunning = false
			castbarFrame:Hide()
		end
	end
end)

-- ============================================================================
-- Event bridge (called from Functions/SpellCast.lua)
-- ============================================================================

---Handles a player UNIT_SPELLCAST_* event for the castbar model + render.
---@param event trbSpellCastType|string
---@param spellId integer?
function TRB.Functions.Castbar:OnSpellCastEvent(event, spellId)
	local model = TRB.Data.castbar
	if model == nil then
		return
	end
	local settings, barSettings = self:GetActiveSettings()
	local visibility = self:GetVisibilitySettings(settings)

	-- Only track when the castbar is enabled for this spec ("Never Show" disables it). Keeping the model
	-- idle otherwise ensures IsActive() (which ProcessBars' isTracking and UpdateResourceBarText's
	-- early-out consult) is only ever true when the castbar is actually in use.
	if not self:IsEnabled(visibility) then
		if model:IsActive() then
			model:Stop()
			self:EndRender()
		end
		return
	end

	---Stops tracking a start event whose cast type is deselected in the Show Bar When conditions.
	---@param state string
	---@return boolean # true when the event should be ignored
	local function RejectDisallowedType(state)
		if self:IsCastTypeAllowed(visibility, state) then
			return false
		end
		-- A tracked cast may chain into a disallowed type (e.g. cast into channel): end the old render.
		if model:IsActive() then
			model:Stop()
			self:BeginFadeOut()
		end
		return true
	end

	if event == "UNIT_SPELLCAST_START" then
		-- Bulk crafting: merge the run of individual craft casts into one channel-style bar whose total
		-- time is queued items * single craft cast time (self-correcting as each craft starts).
		if barSettings and barSettings.mergeTradeskill ~= false and IsTradeskillCast() then
			local queued = ConsumePendingCraftCount()
			-- Same-recipe check: a different craft started during the grace gap must not be absorbed
			-- into the old merge (unknown/secret ids pass, favoring continuation).
			local sameRecipe = model.spellId == nil or spellId == nil or issecretvalue(spellId) or spellId == model.spellId
			if queued == nil and model.tradeskill and sameRecipe then
				-- Next craft of the active merge: advance the shared timeline and re-place the overlays
				-- (boundary ticks + latency zone) for the re-extrapolated duration.
				model:ContinueTradeskill()
				if isRunning then self:SetupOverlays(model) end
				return
			end
			if queued ~= nil and queued > 1 then
				if RejectDisallowedType("channel") then return end
				model:StartTradeskill(spellId, queued)
				self:BeginRender()
				return
			end
			-- Single craft (queued 1/unknown): fall through to the standard cast path.
		end
		if RejectDisallowedType("cast") then return end
		model:StartCast(spellId)
		self:BeginRender()
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		if RejectDisallowedType("channel") then return end
		-- Resolve the channel spellId (event arg may be secret) before the profile lookup.
		local channelId = spellId
		if channelId == nil or issecretvalue(channelId) then
			channelId = select(8, UnitChannelInfo("player"))
			if issecretvalue(channelId) then channelId = nil end
		end
		local profile = self:ResolveTickProfile(barSettings, channelId)
		model:StartChannel(channelId, profile)
		self:BeginRender()
	elseif event == "UNIT_SPELLCAST_EMPOWER_START" then
		if RejectDisallowedType("empower") then return end
		model:StartEmpower(spellId)
		self:BeginRender()
	elseif event == "UNIT_SPELLCAST_DELAYED" then
		model:Delayed()
		if isRunning then self:UpdatePushbackOverlay(model) end
	elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		model:ChannelUpdate()
		if isRunning then
			-- Channel end shifted (e.g. a chain): recompute ticks from the profile resolved at channel
			-- start (buff-gated bonuses must not re-evaluate mid-channel -- the buff may have been consumed
			-- by this very cast), then re-place overlays so the latency zone reflects the new duration.
			if model.profile then
				model:ComputeChannelTicks(model.profile, model:GetHasteMultiplier())
			end
			self:SetupOverlays(model)
		end
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP"
		or event == "UNIT_SPELLCAST_EMPOWER_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		-- Nothing tracked for this cast (type disallowed at start): there is no render to fade out.
		if not model:IsActive() then
			return
		end
		-- One craft of a bulk-crafting merge finished with more queued: keep the merged bar running
		-- through the inter-cast gap (an INTERRUPTED cancels the whole merge like any other cast).
		if event == "UNIT_SPELLCAST_STOP" and model.tradeskill and model:TradeskillCastStopped() then
			return
		end
		-- A natural finish (not an interrupt) advances the fill to done across the fade; capture it
		-- from the still-active model before Stop() wipes the timeline. INTERRUPTED keeps its frozen fill.
		if event ~= "UNIT_SPELLCAST_INTERRUPTED" then
			self:CaptureCompletion(model)
		end
		-- Chain carry (when eligible) is banked inside Stop from state the model already tracks.
		model:Stop()
		self:BeginFadeOut()
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- A successful instant cast produces no bar; only tear down if the tracked cast finished.
		-- START/CHANNEL_START/STOP drive the visible lifecycle, so nothing to do here.
	end
end
