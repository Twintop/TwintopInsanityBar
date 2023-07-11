---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
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

function TRB.Functions.Threshold:RepositionThreshold(settings, thresholdLine, parentFrame, thresholdWidth, resourceThreshold, resourceMax)
	if thresholdLine == nil then
		print("|cFFFFFF00TRB Warning: |r RepositionThreshold() called without a valid thresholdLine!")
		return
	end

	if resourceMax == nil or resourceMax == 0 then
		resourceMax = TRB.Data.character.maxResource
		if resourceMax == 0 then
			resourceMax = 100
		end
	end

	local min, max = parentFrame:GetMinMaxValues()
	local factor = (max - (settings.bar.border * 2)) / resourceMax

	if settings ~= nil and settings.bar ~= nil then
		thresholdLine:SetPoint("LEFT", parentFrame,	"LEFT",	(resourceThreshold * factor), 0)
	
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
end

function TRB.Functions.Threshold:SetThresholdIcon(threshold, settingKey, settings)
	if threshold.icon == nil then
		return
	end

	threshold.icon.texture:SetTexture(TRB.Data.spells[settingKey].texture)
	
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
		threshold.icon.texture = threshold.icon.texture or threshold.icon:CreateTexture(nil, "BACKGROUND")
---@diagnostic disable-next-line: param-type-mismatch
		threshold.icon.texture:SetAllPoints(threshold.icon)
---@diagnostic disable-next-line: param-type-mismatch
		threshold.icon.cooldown = threshold.icon.cooldown or CreateFrame("Cooldown", nil, threshold.icon, "CooldownFrameTemplate")
---@diagnostic disable-next-line: param-type-mismatch
		threshold.icon.cooldown:SetAllPoints(threshold.icon)
		threshold.icon.cooldown:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
		threshold.icon.cooldown:SetFrameStrata(TRB.Data.settings.core.strata.level)

		if settings.thresholds.icons.border < 1 then
			threshold.icon:SetBackdrop({
				insets = {0, 0, 0, 0}
			})
		else
			threshold.icon:SetBackdrop({
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				tile = true,
				tileSize = 4,
				edgeSize = settings.thresholds.icons.border,
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

function TRB.Functions.Threshold:AdjustThresholdDisplay(spell, threshold, showThreshold, currentFrameLevel, pairOffset, thresholdColor, snapshot, settings)
	TwintopTempSettings = settings
	if settings.thresholds[spell.settingKey].enabled and showThreshold then
		local currentTime = GetTime()
		local frameLevel = currentFrameLevel
		local outOfRange = settings.thresholds.outOfRange == true and UnitAffectingCombat("player") and IsSpellInRange(spell.name, "target") == 0

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
			spell.thresholdUsable = true
		else
			spell.thresholdUsable = false
		end

		if settings.thresholds.icons.desaturated == true then
			threshold.icon.texture:SetDesaturated(not spell.thresholdUsable or outOfRange)
		end
		
		if settings.thresholds.icons.showCooldown and spell.hasCooldown and snapshot.startTime ~= nil and currentTime < (snapshot.startTime + snapshot.duration) and (snapshot.maxCharges == nil or snapshot.charges < snapshot.maxCharges) then
			threshold.icon.cooldown:SetCooldown(snapshot.startTime, snapshot.duration)
		else
			threshold.icon.cooldown:SetCooldown(0, 0)
		end
	else
		threshold:Hide()
		spell.thresholdUsable = false
	end
end

function TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, potion, conjuredChillglobe, character, resourceFrame, calculateManaGainFunction)
	local currentTime = GetTime()
	local potionCooldownThreshold = 0
	local potionThresholdColor = specSettings.colors.threshold.over

	if potion.onCooldown then
		if specSettings.thresholds.potionCooldown.enabled then
			if specSettings.thresholds.potionCooldown.mode == "gcd" then
				local gcd = TRB.Functions.Character:GetCurrentGCDTime()
				potionCooldownThreshold = gcd * specSettings.thresholds.potionCooldown.gcdsMax
			elseif specSettings.thresholds.potionCooldown.mode == "time" then
				potionCooldownThreshold = specSettings.thresholds.potionCooldown.timeMax
			end
		end
	end

	if not potion.onCooldown or (potionCooldownThreshold > math.abs(potion.startTime + potion.duration - currentTime)) then
		if potion.onCooldown then
			potionThresholdColor = specSettings.colors.threshold.unusable
		end
		local ampr1Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank1.mana, true)
		if specSettings.thresholds.aeratedManaPotionRank1.enabled and (castingBarValue + ampr1Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[1], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr1Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[1]:Show()
				
			if specSettings.thresholds.icons.showCooldown and potion.onCooldown then
				resourceFrame.thresholds[1].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				resourceFrame.thresholds[1].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[1]:Hide()
		end
		
		local ampr2Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank2.mana, true)
		if specSettings.thresholds.aeratedManaPotionRank2.enabled and (castingBarValue + ampr2Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[2], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr2Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[2]:Show()
				
			if specSettings.thresholds.icons.showCooldown and potion.onCooldown then
				resourceFrame.thresholds[2].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				resourceFrame.thresholds[2].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[2]:Hide()
		end
		
		local ampr3Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank3.mana, true)
		if specSettings.thresholds.aeratedManaPotionRank3.enabled and (castingBarValue + ampr3Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[3], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr3Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[3]:Show()
				
			if specSettings.thresholds.icons.showCooldown and potion.onCooldown then
				resourceFrame.thresholds[3].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				resourceFrame.thresholds[3].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[3]:Hide()
		end

		local poffr1Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank1.mana, true)
		if specSettings.thresholds.potionOfFrozenFocusRank1.enabled and (castingBarValue + poffr1Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[4], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr1Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[4]:Show()
				
			if specSettings.thresholds.icons.showCooldown and potion.onCooldown then
				resourceFrame.thresholds[4].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				resourceFrame.thresholds[4].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[4]:Hide()
		end

		local poffr2Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank2.mana, true)
		if specSettings.thresholds.potionOfFrozenFocusRank2.enabled and (castingBarValue + poffr2Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[5], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr2Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[5].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[5]:Show()
				
			if specSettings.thresholds.icons.showCooldown and potion.onCooldown then
				resourceFrame.thresholds[5].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				resourceFrame.thresholds[5].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[5]:Hide()
		end

		local poffr3Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank3.mana, true)
		if specSettings.thresholds.potionOfFrozenFocusRank3.enabled and (castingBarValue + poffr3Total) < character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[6], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr3Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[6].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[6].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[6]:Show()
				
			if specSettings.thresholds.icons.showCooldown and potion.onCooldown then
				resourceFrame.thresholds[6].icon.cooldown:SetCooldown(potion.startTime, potion.duration)
			else
				resourceFrame.thresholds[6].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[6]:Hide()
		end
		
		local toggle = specSettings.thresholds.icons.desaturated and potion.onCooldown
		resourceFrame.thresholds[1].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[2].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[3].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[4].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[5].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[6].icon.texture:SetDesaturated(toggle)
	else
		resourceFrame.thresholds[1]:Hide()
		resourceFrame.thresholds[2]:Hide()
		resourceFrame.thresholds[3]:Hide()
		resourceFrame.thresholds[4]:Hide()
		resourceFrame.thresholds[5]:Hide()
		resourceFrame.thresholds[6]:Hide()
	end
	
	if character.items.conjuredChillglobe.isEquipped and (currentMana / character.maxResource) < character.items.conjuredChillglobe.manaThresholdPercent then
		local conjuredChillglobeTotal = calculateManaGainFunction(character.items.conjuredChillglobe[character.items.conjuredChillglobe.equippedVersion].mana, true)
		if specSettings.thresholds.conjuredChillglobe.enabled and (castingBarValue + conjuredChillglobeTotal) < character.maxResource and (not conjuredChillglobe.onCooldown or specSettings.thresholds.conjuredChillglobe.cooldown) then
			if conjuredChillglobe.onCooldown then
				potionThresholdColor = specSettings.colors.threshold.unusable
			end
			TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[7], resourceFrame, specSettings.thresholds.width, (castingBarValue + conjuredChillglobeTotal), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[7].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[7].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[7]:Show()
				
			if specSettings.thresholds.icons.showCooldown and conjuredChillglobe.onCooldown then
				resourceFrame.thresholds[7].icon.cooldown:SetCooldown(conjuredChillglobe.startTime, conjuredChillglobe.duration)
			else
				resourceFrame.thresholds[7].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[7]:Hide()
		end
	else
		resourceFrame.thresholds[7]:Hide()
	end
end
