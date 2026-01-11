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

function TRB.Functions.Threshold:RepositionThreshold(settings, key, thresholdLine, showThreshold, parentFrame, value, maxResource, growRight)
	if not showThreshold or settings == nil or settings.bar == nil or thresholdLine == nil then
		return
	end

	if growRight == nil then
		growRight = true
	end

	if maxResource == nil or maxResource == 0 then
		maxResource = TRB.Data.character.maxResource
		if maxResource == 0 then
			maxResource = 100
		end
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].value ~= value or TRB.Data.cache.values.threshold[key].maxResource ~= maxResource then
		--local _, max = parentFrame:GetMinMaxValues()
		--local factor = (max - (settings.bar.border * 2)) / maxResource
		--local max = TRB.Data.character.maxResourceUnmodified
		local factor = (settings.bar.width - (settings.bar.border * 2)) / maxResource

		if growRight then
			thresholdLine:SetPoint("LEFT", parentFrame, "LEFT", math.floor(value * factor), 0)
		else
			thresholdLine:SetPoint("RIGHT", parentFrame, "LEFT", math.ceil(value * factor), 0)
		end
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

	if not settings.thresholds.properties.overlapBorder then
		borderSubtraction = settings.bar.border * 2
	end

	threshold:SetWidth(settings.thresholds.properties.width)
	threshold:SetHeight(settings.bar.height - borderSubtraction)
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
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
	TRB.Functions.Color:SetThresholdColor(threshold, settings.colors.threshold.over.color, true)
end



function TRB.Functions.Threshold:ResetThresholdLineComboPoint(threshold, settings)
	if settings.comboPoints == nil then
		return
	end
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
	
	threshold:SetWidth(settings.thresholds.properties.width)
	threshold:SetHeight(settings.comboPoints.height)
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:Show()
	threshold.hasIcon = false
	
	TRB.Functions.Color:SetThresholdColor(threshold, settings.colors.comboPoints.border, true)
end

---Resets a threshold line for custom bar groups (stagger, defensives, etc.)
---@param threshold Frame # The threshold frame to reset
---@param width number # The width of the threshold line
---@param height number # The height of the threshold line
---@param borderColor string # The RGBA hex color string for the threshold
function TRB.Functions.Threshold:ResetThresholdLineCustomBar(threshold, width, height, borderColor)
	threshold:SetWidth(width)
	threshold:SetHeight(height)
---@diagnostic disable-next-line: inject-field
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:Show()
---@diagnostic disable-next-line: inject-field
	threshold.hasIcon = false
	
	TRB.Functions.Color:SetThresholdColor(threshold, borderColor, true)
end

function TRB.Functions.Threshold:RepositionThresholdComboPoint(settings, key, thresholdLine, showThreshold, parentFrame, value, maxResource, growRight)
	if not showThreshold or settings == nil or settings.bar == nil or thresholdLine == nil then
		-- Hide the threshold line if showThreshold is false
		if thresholdLine and not showThreshold then
			thresholdLine:Hide()
		end
		return
	end

	-- Show the threshold line since showThreshold is true
	thresholdLine:Show()

	if growRight == nil then
		growRight = true
	end

	if maxResource == nil or maxResource == 0 then
		maxResource = TRB.Data.character.maxResource
		if maxResource == 0 then
			maxResource = 100
		end
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].value ~= value or TRB.Data.cache.values.threshold[key].maxResource ~= maxResource then
		--local _, max = parentFrame:GetMinMaxValues()
		--local factor = (max - (settings.bar.border * 2)) / maxResource
		--local max = TRB.Data.character.maxResourceUnmodified
		local factor = (settings.bar.width - (settings.comboPoints.border * 2)) / maxResource

		if growRight then
			thresholdLine:SetPoint("LEFT", parentFrame, "LEFT", math.floor(value * factor), 0)
		else
			thresholdLine:SetPoint("RIGHT", parentFrame, "LEFT", math.ceil(value * factor), 0)
		end
		TRB.Data.cache.values.threshold[key].value = value
		TRB.Data.cache.values.threshold[key].maxResource = maxResource
	end

	if TRB.Data.cache.values.threshold[key].icon ~= thresholdLine.icon then
		SetThresholdIconSizeAndPosition(settings, thresholdLine)
		TRB.Data.cache.values.threshold[key].icon = thresholdLine.icon
	end
end

---Repositions a threshold line for custom bar groups (stagger, defensives, etc.)
---@param key string # Cache key for the threshold
---@param thresholdLine Frame # The threshold frame to reposition
---@param showThreshold boolean # Whether to show the threshold
---@param parentFrame Frame # The parent frame to anchor to
---@param value number # The value at which to position the threshold
---@param maxResource number # The maximum resource value
---@param barWidth number # The width of the bar
---@param barBorder number # The border size of the bar
---@param growRight boolean? # Whether the bar grows right (default true)
function TRB.Functions.Threshold:RepositionThresholdCustomBar(key, thresholdLine, showThreshold, parentFrame, value, maxResource, barWidth, barBorder, growRight)
	if not showThreshold or thresholdLine == nil then
		-- Hide the threshold line if showThreshold is false
		if thresholdLine and not showThreshold then
			thresholdLine:Hide()
		end
		return
	end

	-- Show the threshold line since showThreshold is true
	thresholdLine:Show()

	if growRight == nil then
		growRight = true
	end

	if maxResource == nil or maxResource == 0 then
		maxResource = 100
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].value ~= value or TRB.Data.cache.values.threshold[key].maxResource ~= maxResource then
		local factor = (barWidth - (barBorder * 2)) / maxResource

		thresholdLine:ClearAllPoints()
		if growRight then
			thresholdLine:SetPoint("LEFT", parentFrame, "LEFT", math.floor(value * factor), 0)
		else
			thresholdLine:SetPoint("RIGHT", parentFrame, "LEFT", math.ceil(value * factor), 0)
		end
		TRB.Data.cache.values.threshold[key].value = value
		TRB.Data.cache.values.threshold[key].maxResource = maxResource
	end
end

function TRB.Functions.Threshold:RedrawThresholdLines()
	if TRB.Data.barConstructedForSpec == nil or TRB.Data.barConstructedForSpec == "" then
		return
	end

	local settings = TRB.Data.specCache[TRB.Data.barConstructedForSpec].settings

	-- Try BarGroups system first (new OOP system)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups then
		-- Redraw primary bar thresholds
		if barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local thresholds = primaryNode:GetThresholds()
				if thresholds and #thresholds > 0 then
					for _, threshold in ipairs(thresholds) do
						TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, true)
					end
				end
			end
		end

		-- Redraw secondary bar thresholds (e.g., Stagger for Brewmaster)
		if barGroups.secondary then
			for i = 1, barGroups.secondary.maxNodes do
				local node = barGroups.secondary:GetNode(i)
				if node then
					local thresholds = node:GetThresholds()
					if thresholds and #thresholds > 0 then
						for _, threshold in ipairs(thresholds) do
							TRB.Functions.Threshold:ResetThresholdLineComboPoint(threshold, settings)
						end
					end
				end
			end
		end
	end

	TRB.Data.cache.values.threshold = {}
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return boolean
function TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(settings)
	-- Some specs don't have this setting because range checks don't apply, e.g. healers
	if settings.colors.threshold.outOfRange == nil then
		return false
	end

	return (
		not settings.colors.threshold.outOfRange.show or
		(settings.colors.threshold.outOfRange.show and settings.colors.threshold.outOfRange.enabled)
	)
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return boolean
function TRB.Functions.Threshold:ShouldShowUnusableThresholds(settings)
	return (
		not settings.colors.threshold.unusable.show or
		(settings.colors.threshold.unusable.show and settings.colors.threshold.unusable.enabled)
	)
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
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return boolean
function TRB.Functions.Threshold:AdjustThresholdDisplay(spell, key, threshold, showThreshold, currentFrameLevel, pairOffset, thresholdColor, snapshot, settings)
	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	local cache = TRB.Data.cache.values.threshold[key]
	if settings.thresholds.thresholdDictionary[spell.settingKey].enabled and showThreshold then
		local currentTime = GetTime()
		local frameLevel = currentFrameLevel
		local outOfRange = not spell:GetIsSpellInRange()

		-- Check is we're out of range
		if TRB.Data.character.inCombat and TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(settings) then
			if settings.colors.threshold.outOfRange.show then
				if outOfRange and settings.colors.threshold.outOfRange.enabled then
					thresholdColor = settings.colors.threshold.outOfRange.color
					frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
				end
			else
				if outOfRange then
					TRB.Functions.Threshold:Hide(key, threshold)
					return false
				end
			end
		else
			outOfRange = false
		end
		
		-- Check if the threshold is unusable 
		if frameLevel == TRB.Data.constants.frameLevels.thresholdUnusable then
			if not TRB.Functions.Threshold:ShouldShowUnusableThresholds(settings) then
				TRB.Functions.Threshold:Hide(key, threshold)
				return false
			end
		end

		if threshold.texture == nil or threshold.icon == nil then
			TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, true)
		end

		TRB.Functions.Threshold:SetThresholdIcon(spell, key, threshold, settings)

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
			TRB.Functions.Color:SetThresholdColor(threshold, thresholdColor, true)
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
		return false
	end
	return true
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