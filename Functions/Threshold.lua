---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Threshold = {}


---Returns the anchoring parameters for positioning a threshold line based on fill direction.
---@param fillDirection trbFillDirection? # The fill direction of the bar
---@param effectiveWidth number # The rendered width of the parent frame
---@param effectiveHeight number # The rendered height of the parent frame
---@param value number # The resource value at which to position the threshold
---@param maxResource number # The maximum resource value
---@return string anchorPoint # The anchor point on the threshold line
---@return string parentAnchor # The anchor point on the parent frame
---@return number xOffset # The x-axis offset
---@return number yOffset # The y-axis offset
---@return number effectiveSize # The effective dimension used for factor calculation
local function GetThresholdAnchorInfo(fillDirection, effectiveWidth, effectiveHeight, value, maxResource)
	if fillDirection == "rightLeft" then
		local factor = effectiveWidth / maxResource
		return "RIGHT", "RIGHT", -math.floor(value * factor), 0, effectiveWidth
	elseif fillDirection == "bottomTop" then
		local factor = effectiveHeight / maxResource
		return "BOTTOM", "BOTTOM", 0, math.floor(value * factor), effectiveHeight
	elseif fillDirection == "topBottom" then
		local factor = effectiveHeight / maxResource
		return "TOP", "TOP", 0, -math.floor(value * factor), effectiveHeight
	else -- "leftRight" or nil (default)
		local factor = effectiveWidth / maxResource
		return "LEFT", "LEFT", math.floor(value * factor), 0, effectiveWidth
	end
end

---Returns true if the given fill direction is vertical (bottomTop or topBottom).
---@param fillDirection trbFillDirection? # The fill direction
---@return boolean
local function IsVerticalFillDirection(fillDirection)
	return fillDirection == "bottomTop" or fillDirection == "topBottom"
end

---@param thresholdLine Frame
---@param fillDirection trbFillDirection?
---@param effectiveWidth number
---@param effectiveHeight number
---@param lineThickness number
---@param borderSubtraction number
local function SetThresholdLineDimensions(thresholdLine, fillDirection, effectiveWidth, effectiveHeight, lineThickness, borderSubtraction)
	local crossSection = IsVerticalFillDirection(fillDirection) and effectiveWidth or effectiveHeight
	crossSection = math.max((crossSection or 0) - (borderSubtraction or 0), 0)

	if IsVerticalFillDirection(fillDirection) then
		thresholdLine:SetWidth(crossSection)
		thresholdLine:SetHeight(lineThickness)
	else
		thresholdLine:SetWidth(lineThickness)
		thresholdLine:SetHeight(crossSection)
	end
end


---Configures a threshold icon's anchor point, position, and size based on the spec's threshold icon settings.
---For vertical bars, "Above" (TOP) remaps to LEFT, "Below" (BOTTOM) remaps to RIGHT.
---@param settings table # The spec settings containing thresholds.icons configuration
---@param thresholdLine table # The threshold frame whose .icon child will be repositioned and resized
---@param fillDirection trbFillDirection? # The fill direction of the parent bar (nil defaults to horizontal)
local function SetThresholdIconSizeAndPosition(settings, thresholdLine, fillDirection)
	if thresholdLine.icon ~= nil then
		local isVertical = IsVerticalFillDirection(fillDirection)
		local relativeTo = settings.thresholds.icons.relativeTo

		local setPoint, setPointRelativeTo
		if isVertical then
			-- Vertical bar: remap Above(TOP)→LEFT, Below(BOTTOM)→RIGHT, Center→Center
			if relativeTo == "TOP" then
				setPoint = "RIGHT"
				setPointRelativeTo = "LEFT"
			elseif relativeTo == "CENTER" then
				setPoint = "CENTER"
				setPointRelativeTo = "CENTER"
			else -- "BOTTOM" or default
				setPoint = "LEFT"
				setPointRelativeTo = "RIGHT"
			end
		else
			-- Horizontal bar: original behavior
			if relativeTo == "TOP" then
				setPoint = "BOTTOM"
				setPointRelativeTo = "TOP"
			elseif relativeTo == "CENTER" then
				setPoint = "CENTER"
				setPointRelativeTo = "CENTER"
			else -- "BOTTOM" or default
				setPoint = "TOP"
				setPointRelativeTo = "BOTTOM"
			end
		end

		thresholdLine.icon:ClearAllPoints()
		thresholdLine.icon:SetPoint(setPoint, thresholdLine, setPointRelativeTo, settings.thresholds.icons.xPos, settings.thresholds.icons.yPos)
		thresholdLine.icon:SetSize(settings.thresholds.icons.width, settings.thresholds.icons.height)
	end
end

---Repositions a primary resource bar threshold line at the correct pixel offset for the given resource value, using cached values to avoid redundant updates.
---Supports both horizontal and vertical bar orientations via settings.bar.fillDirection.
---@param settings table # The spec settings containing bar and threshold configuration
---@param key string # Cache key identifying this threshold for deduplication
---@param thresholdLine Frame # The threshold frame to reposition
---@param showThreshold boolean # Whether the threshold should be visible; returns early if false
---@param parentFrame Frame # The parent bar frame used for width calculation and anchoring
---@param value number # The resource value at which to position the threshold
---@param maxResource number? # The maximum resource value (defaults to character's maxResource or 100)
---@param growRight boolean? # Whether the bar grows left-to-right (default true); ignored when fillDirection is present
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

	local fillDirection = settings.bar.fillDirection
	if fillDirection == nil then
		fillDirection = growRight and "leftRight" or "rightLeft"
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	local cache = TRB.Data.cache.values.threshold[key]

	-- Derive effective dimensions from the parent frame's actual rendered size.
	local effectiveWidth = parentFrame:GetWidth()
	local effectiveHeight = parentFrame:GetHeight()
	local lineThickness = cache.lineThickness or settings.thresholds.properties.width
	local overlapBorder = cache.overlapBorder
	if overlapBorder == nil then
		overlapBorder = settings.thresholds.properties.overlapBorder
	end
	local borderSubtraction = 0
	if not overlapBorder then
		borderSubtraction = settings.bar.border * 2
	end
	SetThresholdLineDimensions(thresholdLine, fillDirection, effectiveWidth, effectiveHeight, lineThickness, borderSubtraction)

	-- Use the appropriate axis for the cache key
	local effectiveSize = IsVerticalFillDirection(fillDirection) and effectiveHeight or effectiveWidth

	if cache.value ~= value or cache.maxResource ~= maxResource or cache.effectiveSize ~= effectiveSize or cache.fillDirection ~= fillDirection then
		local anchorPoint, parentAnchor, xOffset, yOffset = GetThresholdAnchorInfo(fillDirection, effectiveWidth, effectiveHeight, value, maxResource)

		thresholdLine:ClearAllPoints()
		thresholdLine:SetPoint(anchorPoint, parentFrame, parentAnchor, xOffset, yOffset)
		cache.value = value
		cache.maxResource = maxResource
		cache.effectiveSize = effectiveSize
		cache.fillDirection = fillDirection
	end

	if cache.icon ~= thresholdLine.icon then
		SetThresholdIconSizeAndPosition(settings, thresholdLine, fillDirection)
		cache.icon = thresholdLine.icon
	end
end

---Sets the icon for a threshold
---@param spell TRB.Classes.SpellThreshold
---@param key string
---@param threshold frame
---@param settings table
---@param thresholdOverrides table? Per-threshold overrides from thresholdDictionary (optional)
function TRB.Functions.Threshold:SetThresholdIcon(spell, key, threshold, settings, thresholdOverrides)
	if threshold == nil or threshold.icon == nil then
		return
	end

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	local cache = TRB.Data.cache.values.threshold[key]

	if cache.texture ~= spell.texture then
		threshold.icon.texture:SetTexture(spell.texture)
		cache.texture = spell.texture
	end

	-- Determine icon visibility: per-threshold override > global setting
	local iconOverrides = thresholdOverrides and thresholdOverrides.icon
	local showIcon = settings.thresholds.icons.enabled
	if iconOverrides and iconOverrides.enabled then
		showIcon = iconOverrides.show ~= false
	end

	if showIcon then
		if cache.iconShown ~= true then
			threshold.icon:Show()
			cache.iconShown = true
		end

		-- Determine effective icon size/position: per-threshold override > global
		local activeIconOverrides
		if iconOverrides ~= nil and iconOverrides.enabled and iconOverrides.show ~= false then
			activeIconOverrides = iconOverrides
		end
		local width, height, xPos, yPos
		if activeIconOverrides ~= nil then
			width = activeIconOverrides.width ~= nil and activeIconOverrides.width or settings.thresholds.icons.width
			height = activeIconOverrides.height ~= nil and activeIconOverrides.height or settings.thresholds.icons.height
			xPos = activeIconOverrides.xPos ~= nil and activeIconOverrides.xPos or settings.thresholds.icons.xPos
			yPos = activeIconOverrides.yPos ~= nil and activeIconOverrides.yPos or settings.thresholds.icons.yPos
		else
			width = settings.thresholds.icons.width
			height = settings.thresholds.icons.height
			xPos = settings.thresholds.icons.xPos
			yPos = settings.thresholds.icons.yPos
		end

		-- Determine effective relativeTo: per-threshold override > global
		local effectiveRelativeTo = settings.thresholds.icons.relativeTo
		if activeIconOverrides ~= nil and activeIconOverrides.relativeTo ~= nil then
			effectiveRelativeTo = activeIconOverrides.relativeTo
		end

		if cache.iconWidth ~= width or cache.iconHeight ~= height or cache.iconXPos ~= xPos or cache.iconYPos ~= yPos or cache.iconRelativeTo ~= effectiveRelativeTo or cache.iconFillDirection ~= settings.bar.fillDirection then
			local isVertical = IsVerticalFillDirection(settings.bar.fillDirection)

			local setPoint, setPointRelativeTo
			if isVertical then
				-- Vertical bar: remap Above(TOP)→LEFT, Below(BOTTOM)→RIGHT, Center→Center
				if effectiveRelativeTo == "TOP" then
					setPoint = "RIGHT"
					setPointRelativeTo = "LEFT"
				elseif effectiveRelativeTo == "CENTER" then
					setPoint = "CENTER"
					setPointRelativeTo = "CENTER"
				else -- "BOTTOM" or default
					setPoint = "LEFT"
					setPointRelativeTo = "RIGHT"
				end
			else
				-- Horizontal bar: original behavior
				if effectiveRelativeTo == "TOP" then
					setPoint = "BOTTOM"
					setPointRelativeTo = "TOP"
				elseif effectiveRelativeTo == "CENTER" then
					setPoint = "CENTER"
					setPointRelativeTo = "CENTER"
				else -- "BOTTOM" or default
					setPoint = "TOP"
					setPointRelativeTo = "BOTTOM"
				end
			end

			threshold.icon:ClearAllPoints()
			threshold.icon:SetPoint(setPoint, threshold, setPointRelativeTo, xPos, yPos)
			threshold.icon:SetSize(width, height)
			cache.iconWidth = width
			cache.iconHeight = height
			cache.iconXPos = xPos
			cache.iconYPos = yPos
			cache.iconRelativeTo = effectiveRelativeTo
			cache.iconFillDirection = settings.bar.fillDirection
		end

		-- Determine effective icon border: per-threshold override > global
		local effectiveBorder = settings.thresholds.icons.border
		if activeIconOverrides ~= nil and activeIconOverrides.border ~= nil then
			effectiveBorder = activeIconOverrides.border
		end

		if cache.iconBorder ~= effectiveBorder then
			if effectiveBorder < 1 then
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
					edgeSize = effectiveBorder,
---@diagnostic disable-next-line: missing-fields
					insets = {0, 0, 0, 0}
				})
			end
			threshold.icon:SetBackdropColor(0, 0, 0, 0)
			threshold.icon:SetBackdropBorderColor(0, 0, 0, 1)
			cache.iconBorder = effectiveBorder
		end

		-- Mark that this icon has been fully configured, so RepositionThreshold doesn't reset it
		cache.icon = threshold.icon
	else
		if cache.iconShown ~= false then
			threshold.icon:Hide()
			cache.iconShown = false
		end
		-- Still mark the icon reference so RepositionThreshold doesn't reconfigure a hidden icon
		cache.icon = threshold.icon
	end
end

---Resets a primary bar threshold line to its default size, texture, frame level, and icon configuration, hiding it until repositioned.
---@param threshold Frame # The threshold frame to reset
---@param settings table # The spec settings containing bar dimensions, threshold properties, icon configuration, and color defaults
---@param hasIcon boolean? # Whether this threshold should have an icon sub-frame created and configured
function TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, hasIcon)
	hasIcon = hasIcon or false
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

	-- For vertical bars, the threshold is a horizontal stripe (swap width/height)
	SetThresholdLineDimensions(threshold, settings.bar.fillDirection, settings.bar.width, settings.bar.height, settings.thresholds.properties.width, borderSubtraction)
---@diagnostic disable-next-line: inject-field
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:Hide()
---@diagnostic disable-next-line: inject-field
	threshold.hasIcon = hasIcon

	if hasIcon == true then
---@diagnostic disable-next-line: inject-field
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
			SetThresholdIconSizeAndPosition(settings, threshold, settings.bar.fillDirection)
		else
			threshold.icon:Hide()
		end
	end
	TRB.Functions.Color:SetThresholdColor(threshold, settings.colors.threshold.over.color, true)
end



---Resets a combo point (secondary resource) bar threshold line to its default size, texture, frame level, and icon configuration.
---@param threshold Frame # The threshold frame to reset
---@param settings table # The spec settings containing comboPoints dimensions, threshold properties, icon configuration, and color defaults
---@param hasIcon? boolean # Whether this threshold should have an icon sub-frame created and configured
function TRB.Functions.Threshold:ResetThresholdLineComboPoint(threshold, settings, hasIcon)
	if settings.comboPoints == nil then
		return
	end
	hasIcon = hasIcon or false
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
	
	-- For vertical growth, the threshold is a horizontal stripe (swap width/height)
	local isVertical = IsVerticalFillDirection(settings.comboPoints.fillDirection)
	if isVertical then
		threshold:SetWidth(settings.comboPoints.width)
		threshold:SetHeight(settings.thresholds.properties.width)
	else
		threshold:SetWidth(settings.thresholds.properties.width)
		threshold:SetHeight(settings.comboPoints.height)
	end
---@diagnostic disable-next-line: inject-field
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:Show()
---@diagnostic disable-next-line: inject-field
	threshold.hasIcon = hasIcon

	if hasIcon == true then
---@diagnostic disable-next-line: inject-field
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
			SetThresholdIconSizeAndPosition(settings, threshold, settings.comboPoints.fillDirection)
		else
			threshold.icon:Hide()
		end
	end
	
	TRB.Functions.Color:SetThresholdColor(threshold, settings.colors.comboPoints.border.color, true)
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

---Repositions a combo point (secondary resource) bar threshold line at the correct pixel offset, showing or hiding it based on the showThreshold flag.
---Supports both horizontal and vertical bar orientations via settings.comboPoints.fillDirection.
---@param settings table # The spec settings containing comboPoints configuration
---@param key string # Cache key identifying this threshold for deduplication
---@param thresholdLine Frame # The threshold frame to reposition
---@param showThreshold boolean # Whether the threshold should be visible; hides and returns early if false
---@param parentFrame Frame # The parent combo point frame used for anchoring
---@param value number # The resource value at which to position the threshold
---@param maxResource number? # The maximum resource value (defaults to character's maxResource or 100)
---@param growRight boolean? # Whether the bar grows left-to-right (default true); ignored when fillDirection is present
function TRB.Functions.Threshold:RepositionThresholdComboPoint(settings, key, thresholdLine, showThreshold, parentFrame, value, maxResource, growRight)
	if not showThreshold or settings == nil or settings.comboPoints == nil or thresholdLine == nil then
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

	local fillDirection = settings.comboPoints.fillDirection
	if fillDirection == nil then
		fillDirection = growRight and "leftRight" or "rightLeft"
	end

	local renderFrame = thresholdLine:GetParent()
	local effectiveWidth = renderFrame and renderFrame:GetWidth() or 0
	local effectiveHeight = renderFrame and renderFrame:GetHeight() or 0
	SetThresholdLineDimensions(thresholdLine, fillDirection, effectiveWidth, effectiveHeight, settings.thresholds.properties.width, 0)
	local effectiveSize = IsVerticalFillDirection(fillDirection) and effectiveHeight or effectiveWidth

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].value ~= value or TRB.Data.cache.values.threshold[key].maxResource ~= maxResource or TRB.Data.cache.values.threshold[key].effectiveSize ~= effectiveSize or TRB.Data.cache.values.threshold[key].fillDirection ~= fillDirection then
		local anchorPoint, parentAnchor, xOffset, yOffset = GetThresholdAnchorInfo(fillDirection, effectiveWidth, effectiveHeight, value, maxResource)

		thresholdLine:ClearAllPoints()
		thresholdLine:SetPoint(anchorPoint, renderFrame, parentAnchor, xOffset, yOffset)
		TRB.Data.cache.values.threshold[key].value = value
		TRB.Data.cache.values.threshold[key].maxResource = maxResource
		TRB.Data.cache.values.threshold[key].effectiveSize = effectiveSize
		TRB.Data.cache.values.threshold[key].fillDirection = fillDirection
	end

	if TRB.Data.cache.values.threshold[key].icon ~= thresholdLine.icon then
		SetThresholdIconSizeAndPosition(settings, thresholdLine, fillDirection)
		TRB.Data.cache.values.threshold[key].icon = thresholdLine.icon
	end
end

---Repositions a threshold line for custom bar groups (stagger, defensives, etc.)
---Supports both horizontal and vertical bar orientations via fillDirection parameter.
---@param key string # Cache key for the threshold
---@param thresholdLine Frame # The threshold frame to reposition
---@param showThreshold boolean # Whether to show the threshold
---@param parentFrame Frame # The parent frame to anchor to
---@param value number # The value at which to position the threshold
---@param maxResource number # The maximum resource value
---@param barWidth number # The width of the bar
---@param barBorder number # The border size of the bar
---@param growRight boolean? # Whether the bar grows right (default true); ignored when fillDirection is present
---@param fillDirection trbFillDirection? # The fill direction of the bar (nil defaults to leftRight/rightLeft based on growRight)
function TRB.Functions.Threshold:RepositionThresholdCustomBar(key, thresholdLine, showThreshold, parentFrame, value, maxResource, barWidth, barBorder, growRight, fillDirection)
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

	if fillDirection == nil then
		fillDirection = growRight and "leftRight" or "rightLeft"
	end

	if maxResource == nil or maxResource == 0 then
		maxResource = 100
	end

	local renderFrame = thresholdLine:GetParent()
	local effectiveWidth = renderFrame and renderFrame:GetWidth() or 0
	local effectiveHeight = renderFrame and renderFrame:GetHeight() or 0
	local lineThickness
	if IsVerticalFillDirection(fillDirection) then
		lineThickness = thresholdLine:GetHeight()
	else
		lineThickness = thresholdLine:GetWidth()
	end
	if lineThickness == nil or lineThickness <= 0 then
		lineThickness = 1
	end
	SetThresholdLineDimensions(thresholdLine, fillDirection, effectiveWidth, effectiveHeight, lineThickness, 0)
	local effectiveSize = IsVerticalFillDirection(fillDirection) and effectiveHeight or effectiveWidth

	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	if TRB.Data.cache.values.threshold[key].value ~= value or TRB.Data.cache.values.threshold[key].maxResource ~= maxResource or TRB.Data.cache.values.threshold[key].effectiveSize ~= effectiveSize or TRB.Data.cache.values.threshold[key].fillDirection ~= fillDirection then
		local anchorPoint, parentAnchor, xOffset, yOffset = GetThresholdAnchorInfo(fillDirection, effectiveWidth, effectiveHeight, value, maxResource)

		thresholdLine:ClearAllPoints()
		thresholdLine:SetPoint(anchorPoint, renderFrame, parentAnchor, xOffset, yOffset)
		TRB.Data.cache.values.threshold[key].value = value
		TRB.Data.cache.values.threshold[key].maxResource = maxResource
		TRB.Data.cache.values.threshold[key].effectiveSize = effectiveSize
		TRB.Data.cache.values.threshold[key].fillDirection = fillDirection
	end
end

---Redraws all threshold lines across primary and secondary bar groups by resetting their appearance and clearing the threshold position cache.
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

	if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
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

---Resolves the effective under/over threshold colors for a ColorCurve, accounting for per-threshold overrides.
---Call this BEFORE BuildThresholdCurve to bake override colors into the curve.
---For static mode, returns the static color for both under and over (curve becomes a flat line).
---For dynamic mode with overrides, returns the override color for the overridden state(s).
---@param spell TRB.Classes.SpellThreshold # The spell threshold being processed
---@param settings TRB.Classes.Settings.SpecializationSettingsBase # The spec settings
---@return string underColor # Effective under color (ARGB hex)
---@return string overColor # Effective over color (ARGB hex)
function TRB.Functions.Threshold:ResolveThresholdCurveColors(spell, settings)
	local underColor = settings.colors.threshold.under.color
	local overColor = settings.colors.threshold.over.color

	local dictEntry = settings.thresholds and settings.thresholds.thresholdDictionary
		and settings.thresholds.thresholdDictionary[spell.settingKey]

	if dictEntry and dictEntry.colors then
		if dictEntry.colors.colorMode == "static" and dictEntry.colors.staticColor and dictEntry.colors.staticColor.color then
			return dictEntry.colors.staticColor.color, dictEntry.colors.staticColor.color
		end

		local function GetMode(colorEntry)
			if colorEntry == nil then return "shared" end
			if colorEntry.mode ~= nil then return colorEntry.mode end
			if colorEntry.enabled then return "override" end
			return "shared"
		end

		local underMode = GetMode(dictEntry.colors.under)
		if underMode == "hidden" then
			underColor = "00000000"
		elseif underMode == "override" and dictEntry.colors.under and dictEntry.colors.under.color then
			underColor = dictEntry.colors.under.color
		end

		local overMode = GetMode(dictEntry.colors.over)
		if overMode == "hidden" then
			overColor = "00000000"
		elseif overMode == "override" and dictEntry.colors.over and dictEntry.colors.over.color then
			overColor = dictEntry.colors.over.color
		end
	end

	return underColor, overColor
end

---Applies a ColorCurve-based color to a threshold (e.g., 2x/3x multicast or split-cost min/max).
---This method checks for valid target and range before applying the curve color.
---If no valid target or out of range, it returns false so the caller can fall back to normal color handling.
---@param spell TRB.Classes.SpellThreshold # The spell threshold being processed
---@param threshold table # The threshold frame
---@param thresholdCurve table # The ColorCurve created by BuildThresholdCurve
---@param resourceType number # The resource type (e.g., TRB.Data.resource or Enum.PowerType.*)
---@param settings TRB.Classes.Settings.SpecializationSettingsBase # The spec settings
---@param iconCurve table? # Optional icon vertex color curve for desaturation mimicry
---@param currentFrameLevel integer # The frame level for this threshold (thresholdOver, thresholdUnder, etc.)
---@param pairOffset integer # Offset for stacking multiple thresholds
---@param isUsable boolean # Whether the base (1x) threshold is usable (has enough resources)
---@return boolean # True if curve color was applied, false if caller should use normal color handling
function TRB.Functions.Threshold:ApplyThresholdCurveColor(spell, threshold, thresholdCurve, resourceType, settings, iconCurve, currentFrameLevel, pairOffset, isUsable)
	if not threshold or not thresholdCurve then
		return false
	end

	local outOfRange = not spell:GetIsSpellInRange()
	local thresholdColor = nil
	local frameLevel = currentFrameLevel

	-- Check if we're out of range
	if TRB.Data.character.inCombat and TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(settings) then
		if settings.colors.threshold.outOfRange.show then
			if outOfRange and settings.colors.threshold.outOfRange.enabled then
				thresholdColor = settings.colors.threshold.outOfRange.color
				frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
			end
		else
			if outOfRange and threshold then
				TRB.Functions.Threshold:Hide(spell.settingKey, threshold)
				return false
			end
		end
	else
		outOfRange = false
	end

	-- Apply frame levels
	local effectiveLevel = frameLevel - pairOffset
	local thresholdFrameLevel = effectiveLevel - TRB.Data.constants.frameLevels.thresholdOffsetLine
	local thresholdIconLevel = effectiveLevel - TRB.Data.constants.frameLevels.thresholdOffsetIcon
	local thresholdIconCooldownLevel = effectiveLevel - TRB.Data.constants.frameLevels.thresholdOffsetCooldown

	threshold:SetFrameLevel(thresholdFrameLevel)
	if threshold.icon then
		threshold.icon:SetFrameLevel(thresholdIconLevel)
		if threshold.icon.cooldown then
			threshold.icon.cooldown:SetFrameLevel(thresholdIconCooldownLevel)
		end
	end

	-- Handle desaturation and icon vertex color
	-- When base threshold is NOT usable or out of range: use SetDesaturated(true) and reset vertex color to white
	-- When usable and in range: use iconCurve for vertex color (gray->white transition), don't use SetDesaturated
	if threshold.icon and threshold.icon.texture then
		if not isUsable or outOfRange then
			-- Not usable or out of range - use standard desaturation if enabled, reset vertex color
			if settings.thresholds.icons.desaturated == true then
				threshold.icon.texture:SetDesaturated(true)
			end
			threshold.icon.texture:SetVertexColor(1, 1, 1, 1) -- Reset to white
		else
			-- Usable and in range - DON'T desaturate, use iconCurve for vertex color
			threshold.icon.texture:SetDesaturated(false)
			-- Apply icon vertex color curve if provided (for desaturation mimicry)
			if iconCurve and settings.thresholds.icons.desaturated then
				local iconColorResult = TRB.Functions.Color:EvaluateThresholdCurve(iconCurve, resourceType)
				if iconColorResult then
					TRB.Functions.Color:SetIconVertexColorFromCurve(threshold, iconColorResult)
				end
			else
				threshold.icon.texture:SetVertexColor(1, 1, 1, 1) -- Reset to white if no curve
			end
		end
	end

	-- If we have an out-of-range color, use that instead of the curve
	if thresholdColor ~= nil then
		TRB.Functions.Color:SetThresholdColor(threshold, thresholdColor, true)
		-- Reset icon alpha in case the curve previously set it to 0 (hidden mode)
		if threshold.icon and threshold.hasIcon then
			threshold.icon:SetAlpha(1)
		end
		return true
	end

	-- Valid target and in range - apply the curve color
	local curveColorResult = TRB.Functions.Color:EvaluateThresholdCurve(thresholdCurve, resourceType)
	if curveColorResult then
		TRB.Functions.Color:SetThresholdColorFromCurve(threshold, curveColorResult)
	end

	return true
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
---@param thresholdOverrides table? Per-threshold overrides from thresholdDictionary (optional)
---@return boolean
function TRB.Functions.Threshold:AdjustThresholdDisplay(spell, key, threshold, showThreshold, currentFrameLevel, pairOffset, thresholdColor, snapshot, settings, thresholdOverrides)
	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}
	local cache = TRB.Data.cache.values.threshold[key]

	-- When thresholdColor is nil, a ColorCurve is managing the visual color externally
	-- (e.g., Shadow Word: Madness x2/x3, Druid form thresholds). The override colors are
	-- already baked into the curve via ResolveThresholdCurveColors, so skip the dynamic
	-- under/over/unusable color override block (which relies on frameLevel, and frameLevel
	-- is unreliable for curve thresholds since isUsable checks the shared base spell ID).
	local curveManagesColor = (thresholdColor == nil)
	if curveManagesColor then
		cache.color = nil
	end

	if spell.settingKey and settings.thresholds.thresholdDictionary[spell.settingKey] and settings.thresholds.thresholdDictionary[spell.settingKey].enabled and showThreshold then
		local currentTime = GetTime()
		local frameLevel = currentFrameLevel
		local outOfRange = not spell:GetIsSpellInRange()
		local colorOverrides = thresholdOverrides and thresholdOverrides.colors

		-- Per-threshold color overrides: each color type has a mode (shared/override/hidden)
		-- Static color mode: always show with a fixed color, bypass all dynamic color logic
		local isStaticColorMode = colorOverrides ~= nil and colorOverrides.colorMode == "static"
		if colorOverrides ~= nil and isStaticColorMode then
			local staticColor = colorOverrides.staticColor
			if staticColor ~= nil and staticColor.color ~= nil then
				thresholdColor = staticColor.color
			end
		elseif colorOverrides ~= nil and not curveManagesColor then
			local function GetMode(colorEntry)
				if colorEntry == nil then return "shared" end
				if colorEntry.mode ~= nil then return colorEntry.mode end
				if colorEntry.enabled then return "override" end
				return "shared"
			end

			local hideThreshold = false

			if frameLevel == TRB.Data.constants.frameLevels.thresholdUnusable then
				local mode = GetMode(colorOverrides.unusable)
				if mode == "hidden" then
					hideThreshold = true
				elseif mode == "override" and colorOverrides.unusable and colorOverrides.unusable.color then
					thresholdColor = colorOverrides.unusable.color
				end
			elseif frameLevel >= TRB.Data.constants.frameLevels.thresholdOver then
				local mode = GetMode(colorOverrides.over)
				if mode == "hidden" then
					hideThreshold = true
				elseif mode == "override" and colorOverrides.over and colorOverrides.over.color then
					thresholdColor = colorOverrides.over.color
				end
			else
				local mode = GetMode(colorOverrides.under)
				if mode == "hidden" then
					hideThreshold = true
				elseif mode == "override" and colorOverrides.under and colorOverrides.under.color then
					thresholdColor = colorOverrides.under.color
				end
			end

			if hideThreshold then
				TRB.Functions.Threshold:Hide(key, threshold)
				return false
			end
		end

		-- Dynamic-only checks: OOR and unusable can hide the threshold
		if not isStaticColorMode then

		-- Check if we're out of range
		-- Per-threshold out-of-range overrides take precedence over global settings
		local function GetOorMode(colorEntry)
			if colorEntry == nil then return "shared" end
			if colorEntry.mode ~= nil then return colorEntry.mode end
			if colorEntry.show == false then return "hidden" end
			if colorEntry.enabled then return "override" end
			return "shared"
		end

		local oorMode = "shared"
		local outOfRangeOverride = colorOverrides and colorOverrides.outOfRange
		if outOfRangeOverride ~= nil then
			oorMode = GetOorMode(outOfRangeOverride)
		end

		if TRB.Data.character.inCombat and TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(settings) then
			if oorMode == "hidden" then
				if outOfRange and threshold then
					TRB.Functions.Threshold:Hide(key, threshold)
					return false
				end
			elseif oorMode == "override" then
				if outOfRange then
					thresholdColor = (outOfRangeOverride and outOfRangeOverride.color) or settings.colors.threshold.outOfRange.color
					frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
				end
			else
				-- "shared": use global OOR settings
				if settings.colors.threshold.outOfRange.show then
					if outOfRange and settings.colors.threshold.outOfRange.enabled then
						thresholdColor = settings.colors.threshold.outOfRange.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
					end
				else
					if outOfRange and threshold then
						TRB.Functions.Threshold:Hide(key, threshold)
						return false
					end
				end
			end
		else
			outOfRange = false
		end
		
		-- Check if the threshold is unusable 
		if frameLevel == TRB.Data.constants.frameLevels.thresholdUnusable then
			if not TRB.Functions.Threshold:ShouldShowUnusableThresholds(settings) then
				if threshold then
					TRB.Functions.Threshold:Hide(key, threshold)
				end
				return false
			end
		end

		end -- not isStaticColorMode
		
		if threshold ~= nil then
			if threshold.texture == nil or threshold.icon == nil then
				TRB.Functions.Threshold:ResetThresholdLine(threshold, settings, true)
			end

			TRB.Functions.Threshold:SetThresholdIcon(spell, key, threshold, settings, thresholdOverrides)

			-- Per-threshold line width override (thickness of the line)
			local lineThickness = settings.thresholds.properties.width
			if thresholdOverrides and thresholdOverrides.line and thresholdOverrides.line.enabled and thresholdOverrides.line.width then
				lineThickness = thresholdOverrides.line.width
			end
			if cache.lineThickness ~= lineThickness then
				cache.lineThickness = lineThickness
			end

			-- Per-threshold overlap border override (cross-section dimension)
			local effectiveOverlapBorder = settings.thresholds.properties.overlapBorder
			if thresholdOverrides and thresholdOverrides.line and thresholdOverrides.line.enabled and thresholdOverrides.line.overlapBorder ~= nil then
				effectiveOverlapBorder = thresholdOverrides.line.overlapBorder
			end
			if cache.overlapBorder ~= effectiveOverlapBorder then
				cache.overlapBorder = effectiveOverlapBorder
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

			-- Only apply color if thresholdColor is provided (nil means color is handled externally via curve)
			if thresholdColor ~= nil and cache.color ~= thresholdColor then
				TRB.Functions.Color:SetThresholdColor(threshold, thresholdColor, true)
				cache.color = thresholdColor
			end

			if currentFrameLevel >= TRB.Data.constants.frameLevels.thresholdOver then
				thresholdUsable = true
			end
			
			-- Only apply desaturation if thresholdColor is provided (nil means desaturation is handled externally via curve)
			if thresholdColor ~= nil then
				-- Determine effective desaturated: per-threshold override > global
				local effectiveDesaturated = settings.thresholds.icons.desaturated
				if thresholdOverrides and thresholdOverrides.icon and thresholdOverrides.icon.enabled and thresholdOverrides.icon.desaturated ~= nil then
					effectiveDesaturated = thresholdOverrides.icon.desaturated
				end

				if effectiveDesaturated == true then
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
			end
			
			if settings.thresholds.icons.showCooldown and spell.hasCooldown and snapshot.cooldown:GetRemainingTime(currentTime) > 0 and (snapshot.maxCharges == nil or snapshot.charges < snapshot.maxCharges) then
				threshold.icon.cooldown:SetCooldown(snapshot.cooldown.startTime, snapshot.cooldown.duration)
				cache.cooldown = true
			elseif cache.cooldown then
				threshold.icon.cooldown:SetCooldown(0, 0)
				cache.cooldown = false
			end
		end
	else
		TRB.Functions.Threshold:Hide(key, threshold)
		return false
	end
	return true
end

---Hides a threshold frame if it is currently visible.
---@param key string # Cache key for the threshold (reserved for future cache invalidation)
---@param threshold Frame? # The threshold frame to hide; safely ignored if nil
function TRB.Functions.Threshold:Hide(key, threshold)
	--[[
	TRB.Data.cache.values.threshold[key] = TRB.Data.cache.values.threshold[key] or {}

	if TRB.Data.cache.values.threshold[key].shown ~= false then
		threshold:Hide()
		TRB.Data.cache.values.threshold[key].shown = false
	end
	]]
	
	if threshold and threshold:IsVisible() then
		threshold:Hide()
	end
end

---Shows a threshold frame if it is not currently visible.
---@param key string # Cache key for the threshold (reserved for future cache invalidation)
---@param threshold Frame # The threshold frame to show
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