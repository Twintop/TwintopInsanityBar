---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.Threshold = {}


local function SetThresholdIconSizeAndPosition(settings, thresholdLine)
	if thresholdLine.icon ~= nil then
		local setPoint = "TOP"
		local setPointRelativeTo = "BOTTOM"
		
		if settings.thresholds.icons.relativeTo == "TOP" then
			setPoint = "BOTTOM"
			setPointRelativeTo = "TOP"
		elseif settings.thresholds.icons.relativeTo == "CENTER" then
			setPoint = "CENTER"
			setPointRelativeTo = "CENTER"
		elseif settings.thresholds.icons.relativeTo == "BOTTOM" then
			setPoint = "TOP"
			setPointRelativeTo = "BOTTOM"
		end
	
		thresholdLine.icon:ClearAllPoints()
		thresholdLine.icon:SetPoint(setPoint, thresholdLine, setPointRelativeTo, settings.thresholds.icons.xPos, settings.thresholds.icons.yPos)
		thresholdLine.icon:SetSize(settings.thresholds.icons.width, settings.thresholds.icons.height)
	end
end

function TRB.Functions.Threshold:RepositionThreshold(settings, thresholdLine, parentFrame, resourceThreshold, resourceMax, debug)
	if settings == nil or settings.bar == nil or thresholdLine == nil then
		return
	end

	if resourceMax == nil or resourceMax == 0 then
		resourceMax = TRB.Data.character.maxResource
		if resourceMax == 0 then
			resourceMax = 100
		end
	end

	local _, max = parentFrame:GetMinMaxValues()
	local factor = (max - (settings.bar.border * 2)) / resourceMax

	thresholdLine:SetPoint("LEFT", parentFrame,	"LEFT",	(resourceThreshold * factor), 0)

	SetThresholdIconSizeAndPosition(settings, thresholdLine)
end

---Sets the icon for a threshold
---@param threshold frame
---@param spell TRB.Classes.SpellThreshold
---@param settings table
function TRB.Functions.Threshold:SetThresholdIcon(threshold, spell, settings)
	if threshold.icon == nil then
		return
	end

	threshold.icon.texture:SetTexture(spell.texture)
	
	if settings.thresholds.icons.enabled then
		threshold.icon:Show()
	else
		threshold.icon:Hide()
	end
end

function TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, hasIcon)
	--[[
		Threshold StrataFrameLevel info, decreasing:
		- Starts at 1200 for unusable
		- Starts at 1400 for not enough resources
		- Starts at 1600 for usable
		- Counter increments by 3 on every render in modules that source threshold data from the spell table
		- Threshold Line Frame is X-2, Icon Frame Level is X-1, Cooldown Frame Level is X, for X = Counter
		Example:
		Threshold doesn't have enough resources and is the 4th threshold processed.
		Counter = 9 (seen 3).
		Line = 1389, Icon = 1390, Cooldown = 1391

		This is done to maintain backward compatability for how threshold line stacking used to work before this change.
	]]
	local borderSubtraction = 0

	if not settings.thresholds.overlapBorder then
		borderSubtraction = settings.bar.border * 2
	end

	threshold:SetWidth(settings.thresholds.width)
	threshold:SetHeight(settings.bar.height - borderSubtraction)
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settings.colors.threshold.under, true))
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:Hide()
	
	if hasIcon == true then
		threshold.icon = threshold.icon or CreateFrame("Frame", nil, threshold, "BackdropTemplate")
		threshold.icon:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
		threshold.icon:SetFrameStrata(TRB.Data.settings.core.strata.level)
---@diagnostic disable-next-line: inject-field
		threshold.icon.texture = threshold.icon.texture or threshold.icon:CreateTexture(nil, "BACKGROUND")
		threshold.icon.texture:SetAllPoints(threshold.icon)
---@diagnostic disable-next-line: inject-field
		threshold.icon.cooldown = threshold.icon.cooldown or CreateFrame("Cooldown", nil, threshold.icon, "CooldownFrameTemplate")
		threshold.icon.cooldown:SetAllPoints(threshold.icon)
		threshold.icon.cooldown:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
		threshold.icon.cooldown:SetFrameStrata(TRB.Data.settings.core.strata.level)

		if settings.thresholds.icons.border < 1 then
---@diagnostic disable-next-line: missing-fields
			threshold.icon:SetBackdrop({
---@diagnostic disable-next-line: missing-fields
				insets = {0, 0, 0, 0}
			})
		else
---@diagnostic disable-next-line: missing-fields
			threshold.icon:SetBackdrop({
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				tile = true,
				tileSize = 4,
				edgeSize = settings.thresholds.icons.border,
---@diagnostic disable-next-line: missing-fields
				insets = {0, 0, 0, 0}
			})
		end
		threshold.icon:SetBackdropColor(0, 0, 0, 0)
		threshold.icon:SetBackdropBorderColor(0, 0, 0, 1)

		if settings.thresholds.icons.enabled then
			threshold.icon:Show()
			SetThresholdIconSizeAndPosition(settings, threshold)
		else
			threshold.icon:Hide()
		end
	end
end

function TRB.Functions.Threshold:RedrawThresholdLines(settings)
	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame

	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			TRB.Functions.Threshold:ResetThresholdLine(resourceFrame.thresholds[x], settings, true)
		end
	end

	entries = TRB.Functions.Table:Length(passiveFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			TRB.Functions.Threshold:ResetThresholdLine(passiveFrame.thresholds[x], settings, false)
			passiveFrame.thresholds[x].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settings.colors.threshold.mindbender, true))
		end
	end

	TRB.Frames.resourceFrame = resourceFrame
	TRB.Frames.passiveFrame = passiveFrame
end

---Adjusts the display level, color, and cooldown status of a threshold and its icon.
---@param spell table
---@param threshold table
---@param showThreshold boolean
---@param currentFrameLevel integer
---@param pairOffset integer
---@param thresholdColor string
---@param snapshot TRB.Classes.Snapshot
---@param settings table
function TRB.Functions.Threshold:AdjustThresholdDisplay(spell, threshold, showThreshold, currentFrameLevel, pairOffset, thresholdColor, snapshot, settings)
	if settings.thresholds[spell.settingKey].enabled and showThreshold then
		local currentTime = GetTime()
		local frameLevel = currentFrameLevel
		local outOfRange = settings.thresholds.outOfRange == true and UnitAffectingCombat("player") and IsSpellInRange(spell.name, "target") == 0
		local thresholdUsable = false

		if outOfRange then
			thresholdColor = settings.colors.threshold.outOfRange
			frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
		end

		if not spell.hasCooldown then
			frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
		end

		threshold:Show()
		threshold:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
		threshold.icon:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
		threshold.icon.cooldown:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
---@diagnostic disable-next-line: undefined-field
		threshold.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
		threshold.icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(thresholdColor, true))
		if currentFrameLevel >= TRB.Data.constants.frameLevels.thresholdOver then
			thresholdUsable = true
		end
		
		if settings.thresholds.icons.desaturated == true then
			threshold.icon.texture:SetDesaturated(not thresholdUsable or outOfRange)
		end
		
		if settings.thresholds.icons.showCooldown and spell.hasCooldown and snapshot.cooldown:GetRemainingTime(currentTime) > 0 and (snapshot.maxCharges == nil or snapshot.charges < snapshot.maxCharges) then
			threshold.icon.cooldown:SetCooldown(snapshot.cooldown.startTime, snapshot.cooldown.duration)
		else
			threshold.icon.cooldown:SetCooldown(0, 0)
		end
	else
		threshold:Hide()
	end
end

---Updates all shared ability/item thresholds for a healer specialization.
---@param currentMana number # Current amount of mana the player has
---@param castingBarValue number # How much mana the player has minus the mana cost of their current hardcasted spell
---@param settings table # Settings for the specific specialization.
---@param potion TRB.Classes.SnapshotCooldown # Cooldown information about potions.
---@param conjuredChillglobe TRB.Classes.SnapshotCooldown # Cooldown information about Conjured Chillglobe.
---@param character table # Character snapshot info
---@param frame Frame # Frame that these thresholds are drawn on and children of.
---@param calculateManaGainFunction function # The class or specialization specific function to determine mana gain.
function TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, settings, potion, conjuredChillglobe, character, frame, calculateManaGainFunction)
	local currentTime = GetTime()
	local potionCooldownThreshold = 0
	local potionThresholdColor = settings.colors.threshold.over

	if potion.onCooldown then
		if settings.thresholds.potionCooldown.enabled then
			if settings.thresholds.potionCooldown.mode == "gcd" then
				local gcd = TRB.Functions.Character:GetCurrentGCDTime()
				potionCooldownThreshold = gcd * settings.thresholds.potionCooldown.gcdsMax
			elseif settings.thresholds.potionCooldown.mode == "time" then
				potionCooldownThreshold = settings.thresholds.potionCooldown.timeMax
			end
		end
	end

	if not potion.onCooldown or (potionCooldownThreshold > math.abs(potion.startTime + potion.duration - currentTime)) then
		if potion.onCooldown then
			potionThresholdColor = settings.colors.threshold.unusable
		end
		local ampr1Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank1.mana, true)
		if settings.thresholds.aeratedManaPotionRank1.enabled and (castingBarValue + ampr1Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[1], frame, (castingBarValue + ampr1Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[1]:Show()
				
			if settings.thresholds.icons.showCooldown and potion.onCooldown then
				frame.thresholds[1].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				frame.thresholds[1].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[1]:Hide()
		end
		
		local ampr2Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank2.mana, true)
		if settings.thresholds.aeratedManaPotionRank2.enabled and (castingBarValue + ampr2Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[2], frame, (castingBarValue + ampr2Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[2].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[2]:Show()
				
			if settings.thresholds.icons.showCooldown and potion.onCooldown then
				frame.thresholds[2].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				frame.thresholds[2].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[2]:Hide()
		end
		
		local ampr3Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank3.mana, true)
		if settings.thresholds.aeratedManaPotionRank3.enabled and (castingBarValue + ampr3Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[3], frame, (castingBarValue + ampr3Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[3].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[3]:Show()
				
			if settings.thresholds.icons.showCooldown and potion.onCooldown then
				frame.thresholds[3].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				frame.thresholds[3].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[3]:Hide()
		end

		local poffr1Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank1.mana, true)
		if settings.thresholds.potionOfFrozenFocusRank1.enabled and (castingBarValue + poffr1Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[4], frame, (castingBarValue + poffr1Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[4].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[4]:Show()
				
			if settings.thresholds.icons.showCooldown and potion.onCooldown then
				frame.thresholds[4].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				frame.thresholds[4].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[4]:Hide()
		end

		local poffr2Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank2.mana, true)
		if settings.thresholds.potionOfFrozenFocusRank2.enabled and (castingBarValue + poffr2Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[5], frame, (castingBarValue + poffr2Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[5].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[5].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[5]:Show()
				
			if settings.thresholds.icons.showCooldown and potion.onCooldown then
				frame.thresholds[5].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				frame.thresholds[5].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[5]:Hide()
		end

		local poffr3Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank3.mana, true)
		if settings.thresholds.potionOfFrozenFocusRank3.enabled and (castingBarValue + poffr3Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[6], frame, (castingBarValue + poffr3Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[6].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[6].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[6]:Show()
				
			if settings.thresholds.icons.showCooldown and potion.onCooldown then
				frame.thresholds[6].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				frame.thresholds[6].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[6]:Hide()
		end
		
		local toggle = settings.thresholds.icons.desaturated and potion.onCooldown
		frame.thresholds[1].icon.texture:SetDesaturated(toggle)
		frame.thresholds[2].icon.texture:SetDesaturated(toggle)
		frame.thresholds[3].icon.texture:SetDesaturated(toggle)
		frame.thresholds[4].icon.texture:SetDesaturated(toggle)
		frame.thresholds[5].icon.texture:SetDesaturated(toggle)
		frame.thresholds[6].icon.texture:SetDesaturated(toggle)
	else
		frame.thresholds[1]:Hide()
		frame.thresholds[2]:Hide()
		frame.thresholds[3]:Hide()
		frame.thresholds[4]:Hide()
		frame.thresholds[5]:Hide()
		frame.thresholds[6]:Hide()
	end
	
	if character.items.conjuredChillglobe.isEquipped and (currentMana / character.maxResource) < character.items.conjuredChillglobe.manaThresholdPercent then
		local conjuredChillglobeTotal = calculateManaGainFunction(character.items.conjuredChillglobe.mana, true)
		if settings.thresholds.conjuredChillglobe.enabled and (castingBarValue + conjuredChillglobeTotal) < character.maxResource and (not conjuredChillglobe.onCooldown or settings.thresholds.conjuredChillglobe.cooldown) then
			if conjuredChillglobe.onCooldown then
				potionThresholdColor = settings.colors.threshold.unusable
			end
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[7], frame, (castingBarValue + conjuredChillglobeTotal), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[7].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			frame.thresholds[7].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			frame.thresholds[7]:Show()
				
			if settings.thresholds.icons.showCooldown and conjuredChillglobe.onCooldown then
				frame.thresholds[7].icon.cooldown:SetCooldown(conjuredChillglobe.startTime, conjuredChillglobe.duration)
			else
				frame.thresholds[7].icon.cooldown:SetCooldown(0, 0)
			end
		else
			frame.thresholds[7]:Hide()
		end
	else
		frame.thresholds[7]:Hide()
	end
end

---Updates all shared passive thresholds for a healer specialization.
---@param settings table # Settings for the specific specialization.
---@param spells TRB.Classes.Healer.HealerSpells # Spells used by the specialization.
---@param snapshots TRB.Classes.Snapshot[] # Snapshots that contain information about all shared passive regen healer spells.
---@param frame Frame # Frame that these thresholds are drawn on and children of.
---@param castingBarValue number # Current value of the casting bar.
---@return number, number # The total mana regen of all shared passive regen healer spells.
function TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(settings, spells, snapshots, frame, castingBarValue)
	local passiveValue = 0
	if settings.bar.showPassive then
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 1, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 2, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 3, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 4, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 5, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 6, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 7, castingBarValue, passiveValue)
	else
		TRB.Frames.passiveFrame.thresholds[1]:Hide()
		TRB.Frames.passiveFrame.thresholds[2]:Hide()
		TRB.Frames.passiveFrame.thresholds[3]:Hide()
		TRB.Frames.passiveFrame.thresholds[4]:Hide()
		TRB.Frames.passiveFrame.thresholds[5]:Hide()
		TRB.Frames.passiveFrame.thresholds[6]:Hide()
		TRB.Frames.passiveFrame.thresholds[7]:Hide()
	end
	return passiveValue, 6
end

---Updates a passive threshold for a healer specialization.
---@param settings table # Settings for the specific specialization.
---@param snapshot TRB.Classes.Healer.HealerRegenBase # Snapshot of the shared passive regen healer spell we're updating the threshold line of.
---@param frame Frame # Frame that these thresholds are drawn on and children of.
---@param thresholdId integer # Threshold to be updated
---@param castingBarValue number # Current value of the casting bar.
---@param passiveValue number # The total mana regen of all previous shared passive regen healer spells.
---@return number # The total mana regen of all shared passive regen healer spells so far.
function TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshot, frame, thresholdId, castingBarValue, passiveValue)
	if frame == nil or frame.thresholds == nil then
		return passiveValue
	end

	if snapshot.mana > 0 then
		passiveValue = passiveValue + snapshot.mana

		if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, frame.thresholds[thresholdId], frame, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
			---@diagnostic disable-next-line: undefined-field
			frame.thresholds[thresholdId].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settings.colors.threshold.mindbender, true))
			frame.thresholds[thresholdId]:Show()
		else
			frame.thresholds[thresholdId]:Hide()
		end
	else
		frame.thresholds[thresholdId]:Hide()
	end
	
	return passiveValue
end