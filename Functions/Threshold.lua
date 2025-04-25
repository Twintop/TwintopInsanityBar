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

function TRB.Functions.Threshold:RepositionThreshold(settings, key, thresholdLine, showThreshold, parentFrame, value, maxResource)
	if not showThreshold or settings == nil or settings.bar == nil or thresholdLine == nil then
		return
	end

	if maxResource == nil or maxResource == 0 then
		maxResource = TRB.Data.character.maxResource
		if maxResource == 0 then
			maxResource = 100
		end
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].value ~= value or TRB.Data.cache.values.threshold[key].maxResource ~= maxResource then
		local _, max = parentFrame:GetMinMaxValues()
		local factor = (max - (settings.bar.border * 2)) / maxResource

		thresholdLine:SetPoint("LEFT", parentFrame,	"LEFT",	math.floor(value * factor), 0)
		TRB.Data.cache.values.threshold[key].value = value
		TRB.Data.cache.values.threshold[key].maxResource = maxResource
	end

	if TRB.Data.cache.values.threshold[key].icon ~= thresholdLine.icon then
		SetThresholdIconSizeAndPosition(settings, thresholdLine)
		TRB.Data.cache.values.threshold[key].icon = thresholdLine.icon
	end
end

---Sets the icon for a threshold
---@param spell TRB.Classes.SpellThreshold
---@param key string
---@param threshold frame
---@param settings table
function TRB.Functions.Threshold:SetThresholdIcon(spell, key, threshold, settings)
	if threshold.icon == nil then
		return
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	local cache = TRB.Data.cache.values.threshold[key]

	if cache.texture ~= spell.texture then
		threshold.icon.texture:SetTexture(spell.texture)
		cache.texture = spell.texture
	end
	
	if settings.thresholds.icons.enabled then
		if cache.iconShown ~= true then
			threshold.icon:Show()
			cache.iconShown = true
		end
	else
		if cache.iconShown ~= false then
			threshold.icon:Hide()
			cache.iconShown = false
		end
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
	threshold.hasIcon = hasIcon

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

	TRB.Data.cache.values.threshold = {}
end

---Adjusts the display level, color, and cooldown status of a threshold and its icon.
---@param spell TRB.Classes.SpellThreshold
---@param key string
---@param threshold table
---@param showThreshold boolean
---@param currentFrameLevel integer
---@param pairOffset integer
---@param thresholdColor string
---@param snapshot TRB.Classes.Snapshot
---@param settings table
function TRB.Functions.Threshold:AdjustThresholdDisplay(spell, key, threshold, showThreshold, currentFrameLevel, pairOffset, thresholdColor, snapshot, settings)
	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	local cache = TRB.Data.cache.values.threshold[key]
	if settings.thresholds[spell.settingKey].enabled and showThreshold then
		local currentTime = GetTime()
		local frameLevel = currentFrameLevel
		local outOfRange = false

		if threshold.texture == nil or threshold.icon == nil then
			TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, true)
		end

		TRB.Functions.Threshold:SetThresholdIcon(spell, key, threshold, settings)
		
		-- Split these out to only call methods if we need to
		if settings.thresholds.outOfRange then
			if TRB.Data.character.inCombat then
				if C_Spell.IsSpellInRange(spell.name, "target") == false then
					outOfRange = true
					thresholdColor = settings.colors.threshold.outOfRange
					frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
				end
			end
		end

		local thresholdUsable = false

		if not spell.hasCooldown then
			frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
		end
		
		TRB.Functions.Threshold:Show(key, threshold)

		-- Only check this first one as if one is different then all will be different
		if cache.frameLevel ~= frameLevel then
			local effectiveLevel = frameLevel - pairOffset
			local thresholdFrameLevel = effectiveLevel - TRB.Data.constants.frameLevels.thresholdOffsetLine
			local thresholdIconLevel = effectiveLevel - TRB.Data.constants.frameLevels.thresholdOffsetIcon
			local thresholdIconCooldownLevel = effectiveLevel - TRB.Data.constants.frameLevels.thresholdOffsetCooldown

			threshold:SetFrameLevel(thresholdFrameLevel)
			threshold.icon:SetFrameLevel(thresholdIconLevel)
			threshold.icon.cooldown:SetFrameLevel(thresholdIconCooldownLevel)

			cache.frameLevel = frameLevel
		end

		if cache.color ~= thresholdColor then
			threshold.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(thresholdColor, true))
			threshold.icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(thresholdColor, true))
			cache.color = thresholdColor
		end

		if currentFrameLevel >= TRB.Data.constants.frameLevels.thresholdOver then
			thresholdUsable = true
		end
		
		if settings.thresholds.icons.desaturated == true then
			if cache.desaturated ~= (not thresholdUsable or outOfRange) then
				threshold.icon.texture:SetDesaturated(not thresholdUsable or outOfRange)
				cache.desaturated = not thresholdUsable or outOfRange
			end
		else
			if cache.desaturated ~= false then
				threshold.icon.texture:SetDesaturated(false)
				cache.desaturated = false
			end
		end
		
		if settings.thresholds.icons.showCooldown and spell.hasCooldown and snapshot.cooldown:GetRemainingTime(currentTime) > 0 and (snapshot.maxCharges == nil or snapshot.charges < snapshot.maxCharges) then
			threshold.icon.cooldown:SetCooldown(snapshot.cooldown.startTime, snapshot.cooldown.duration)
			cache.cooldown = true
		elseif cache.cooldown then
			threshold.icon.cooldown:SetCooldown(0, 0)
			cache.cooldown = false
		end
	else
		TRB.Functions.Threshold:Hide(key, threshold)
	end
end

function TRB.Functions.Threshold:Hide(key, threshold)
	--[[
	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}

	if TRB.Data.cache.values.threshold[key].shown ~= false then
		threshold:Hide()
		TRB.Data.cache.values.threshold[key].shown = false
	end
	]]
	
	if threshold:IsVisible() then
		threshold:Hide()
	end
end

function TRB.Functions.Threshold:Show(key, threshold)
	--[[
	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].shown ~= true then
		threshold:Show()
		TRB.Data.cache.values.threshold[key].shown = true
	end
	]]

	if not threshold:IsVisible() then
		threshold:Show()
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
	if settings.colors.bar.showPassive then
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 1, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 2, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 3, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 4, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 5, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 6, castingBarValue, passiveValue)
		passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], frame, 7, castingBarValue, passiveValue)
		TRB.Data.cache.values.threshold["showPassiveDisabled"] = false
	else
		if TRB.Data.cache.values.threshold["showPassiveDisabled"] ~= true then
			TRB.Frames.passiveFrame.thresholds[1]:Hide()
			TRB.Frames.passiveFrame.thresholds[2]:Hide()
			TRB.Frames.passiveFrame.thresholds[3]:Hide()
			TRB.Frames.passiveFrame.thresholds[4]:Hide()
			TRB.Frames.passiveFrame.thresholds[5]:Hide()
			TRB.Frames.passiveFrame.thresholds[6]:Hide()
			TRB.Frames.passiveFrame.thresholds[7]:Hide()
			TRB.Data.cache.values.threshold["showPassiveDisabled"] = true
		end
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
---@param overrideMana number? # Override amount of mana. Used mostly when the snapshot isn't HealerRegenBase, like in the case of Shadowfiend for Priests
---@return number # The total mana regen of all shared passive regen healer spells so far.
function TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(settings, snapshot, frame, thresholdId, castingBarValue, passiveValue, overrideMana)
	if frame == nil or frame.thresholds == nil then
		return passiveValue
	end
	TRB.Data.cache.values.threshold[snapshot.spell.id] = TRB.Data.cache.values.threshold[snapshot.spell.id] or {}
	local cache = TRB.Data.cache.values.threshold[snapshot.spell.id]

	local mana = overrideMana or snapshot.mana
	if mana > 0 then
		passiveValue = passiveValue + mana

		if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
			TRB.Functions.Threshold:RepositionThreshold(settings, snapshot.spell.id, frame.thresholds[thresholdId], true, frame, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
			---@diagnostic disable-next-line: undefined-field
			
			if cache.color ~= settings.colors.threshold.mindbender then
				frame.thresholds[thresholdId].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settings.colors.threshold.mindbender, true))
				cache.color = settings.colors.threshold.mindbender
			end

			if cache.shown ~= true then
				frame.thresholds[thresholdId]:Show()
				cache.shown = true
			end
		elseif cache.shown == true then
			frame.thresholds[thresholdId]:Hide()
			cache.shown = false
		end
	elseif cache.shown == true then
		frame.thresholds[thresholdId]:Hide()
		cache.shown = false
	end
	
	return passiveValue
end