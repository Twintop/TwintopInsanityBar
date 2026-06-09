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

	-- A width of 0 should make the line effectively invisible. Rather than hiding the
	-- frame or zeroing its alpha (which would also hide child elements like the icon),
	-- render a fully transparent 0.001px-wide line by setting the alpha on the line
	-- texture only, leaving child frames untouched. The sub-pixel width keeps anchored
	-- child elements aligned as if the line had no meaningful footprint.
	local invisible = (lineThickness or 0) <= 0
	if invisible then
		lineThickness = 0.001
		if thresholdLine.texture ~= nil then
			thresholdLine.texture:SetAlpha(0)
		end
	else
		if thresholdLine.texture ~= nil then
			thresholdLine.texture:SetAlpha(1)
		end
	end

	if IsVerticalFillDirection(fillDirection) then
		thresholdLine:SetWidth(crossSection)
		thresholdLine:SetHeight(lineThickness)
	else
		thresholdLine:SetWidth(lineThickness)
		thresholdLine:SetHeight(crossSection)
	end
end

---@param value any
---@return boolean
local function IsSecretValue(value)
	if value == nil or type(issecretvalue) ~= "function" then
		return false
	end

	return issecretvalue(value)
end

---@param value any
---@param fallback number?
---@return number
local function GetPlainNumber(value, fallback)
	if value == nil or IsSecretValue(value) or type(value) ~= "number" then
		return fallback or 0
	end

	return value
end

---@param value any
---@param fallback number?
---@return number
local function GetPositivePlainNumber(value, fallback)
	local plainFallback = GetPlainNumber(fallback, 100)
	if plainFallback <= 0 then
		plainFallback = 100
	end

	local plainValue = GetPlainNumber(value, plainFallback)
	if plainValue <= 0 then
		return plainFallback
	end

	return plainValue
end

---Returns the primary bar's current maximum resource using the SAME logic as the
---regular threshold rendering path (see the class modules' `maxPrimaryBarResourceUnnormalized`
---computation). The range is `0 - current max`, where the current max comes from the live
---game value and is only capped by the optional `maxResource.value` override when it is enabled.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param fallback number
---@return number
local function GetPrimaryBarMaxValue(settings, fallback)
	local maxResource = TRB.Data.character and TRB.Data.character.maxResourceUnmodified
	if maxResource == nil or maxResource <= 0 then
		maxResource = GetPositivePlainNumber(fallback, 100)
	end

	if settings.maxResource ~= nil and settings.maxResource.enabled == true and GetPlainNumber(settings.maxResource.value, 0) > 0 then
		maxResource = math.min(settings.maxResource.value, maxResource)
	end

	return GetPositivePlainNumber(maxResource, 100)
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

	-- The per-threshold "show" flag hides the icon on its own, even when the icon override
	-- section isn't enabled. Both the "Show ability icon?" checkbox and the "No Icon" icon
	-- type write to this flag, so either one (OR) suppresses the icon. Toggling it back on
	-- falls through to the normal show path below, which redraws the icon and border as usual.
	if iconOverrides and iconOverrides.show == false then
		showIcon = false
	end

	-- No texture means no icon to show: covers both "none" source type and item/spell/icon
	-- source types where the ID is 0 (unset) or invalid. Without this, an empty icon frame
	-- would be displayed even though there is nothing to render.
	if spell.texture == nil then
		showIcon = false
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
			-- ClearAllPoints/SetSize invalidate BackdropTemplate rendering; force the
			-- border block below to re-call SetBackdrop on this same pass.
			cache.iconBorder = nil
		end

		-- Determine effective icon border: per-threshold override > global. The override is
		-- stored as a string (slider/edit-box value), so coerce to a number before any numeric
		-- comparison below; fall back to 0 if it isn't parseable.
		local effectiveBorder = settings.thresholds.icons.border
		if activeIconOverrides ~= nil and activeIconOverrides.border ~= nil then
			effectiveBorder = tonumber(activeIconOverrides.border) or 0
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
			-- SetBackdrop resets the border color, so restore the last threshold color applied by
			-- SetThresholdColor/SetThresholdColorFromCurve. Falls back to black only on the very
			-- first pass before any color has been applied. Without this, re-applying the backdrop
			-- (e.g. on a border/position change, or after a cache clear on login/spec switch) would
			-- leave the border black until the next color pass, which is delayed by the bar-text
			-- update early-out.
			local bc = threshold.icon.borderColorCache
			if bc ~= nil then
				threshold.icon:SetBackdropBorderColor(bc[1], bc[2], bc[3], bc[4])
			else
				threshold.icon:SetBackdropBorderColor(0, 0, 0, 1)
			end
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

		if settings.thresholds.icons.enabled then
			threshold.icon:Show()
			SetThresholdIconSizeAndPosition(settings, threshold, settings.bar.fillDirection)
		else
			threshold.icon:Hide()
		end

		-- Apply backdrop AFTER ClearAllPoints/SetSize: BackdropTemplate rendering is
		-- invalidated by those layout operations, so SetBackdrop must come last.
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

		if settings.thresholds.icons.enabled then
			threshold.icon:Show()
			SetThresholdIconSizeAndPosition(settings, threshold, settings.comboPoints.fillDirection)
		else
			threshold.icon:Hide()
		end

		-- Apply backdrop AFTER ClearAllPoints/SetSize: BackdropTemplate rendering is
		-- invalidated by those layout operations, so SetBackdrop must come last.
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
	end

	TRB.Functions.Color:SetThresholdColor(threshold, settings.colors.comboPoints.border.color, true)
end

---Resets a threshold line for custom bar groups (stagger, defensives, etc.)
---@param threshold Frame # The threshold frame to reset
---@param width number # The width of the threshold line
---@param height number # The height of the threshold line
---@param borderColor string # The RGBA hex color string for the threshold
---@param lineThickness? number # The configured threshold line thickness
function TRB.Functions.Threshold:ResetThresholdLineCustomBar(threshold, width, height, borderColor, lineThickness)
	threshold:SetWidth(width)
	threshold:SetHeight(height)
---@diagnostic disable-next-line: inject-field
	threshold.lineThickness = lineThickness or math.min(width or 1, height or 1)
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
---@param lineThickness? number # The configured threshold line thickness
---@param overlapBorder? boolean # Whether threshold lines should overlap the bar border
function TRB.Functions.Threshold:RepositionThresholdCustomBar(key, thresholdLine, showThreshold, parentFrame, value, maxResource, barWidth, barBorder, growRight, fillDirection, lineThickness, overlapBorder)
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
	-- Configured widths can be stored as numeric strings in saved settings. The regular
	-- RepositionThreshold path never compares the value (it passes it straight to SetWidth,
	-- which coerces), but this function needs it as a number for its caching logic.
	lineThickness = tonumber(lineThickness)
	-- An explicit configured width of 0 means the line should be invisible. Preserve it
	-- so SetThresholdLineDimensions can render a fully-transparent 1px line instead of
	-- hiding the frame (which would also hide the icon child). Only fall back to a
	-- sensible default when the value is missing or negative.
	if lineThickness ~= 0 then
		if lineThickness == nil or lineThickness < 0 then
			lineThickness = tonumber(thresholdLine.lineThickness)
		end
		if lineThickness == nil or lineThickness <= 0 then
			if IsVerticalFillDirection(fillDirection) then
				lineThickness = thresholdLine:GetHeight()
			else
				lineThickness = thresholdLine:GetWidth()
			end
		end
		if lineThickness == nil or lineThickness <= 0 then
			lineThickness = 1
		end
	end
---@diagnostic disable-next-line: inject-field
	thresholdLine.lineThickness = lineThickness
	local borderSubtraction = 0
	if overlapBorder == false then
		borderSubtraction = (tonumber(barBorder) or 0) * 2
	end
	SetThresholdLineDimensions(thresholdLine, fillDirection, effectiveWidth, effectiveHeight, lineThickness, borderSubtraction)
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

---@param frame Frame|StatusBar?
---@return number currentValue
---@return number maxValue
local function GetStatusBarValues(frame)
	if frame == nil or type(frame.GetValue) ~= "function" then
		return 0, 100
	end

	local currentValue = GetPlainNumber(frame:GetValue(), 0)
	local maxValue = 100
	if type(frame.GetMinMaxValues) == "function" then
		local _, frameMax = frame:GetMinMaxValues()
		maxValue = GetPositivePlainNumber(frameMax, 100)
	end

	return currentValue, maxValue
end

---Returns the registered BarTypeDefinition for a bar key, or nil for non-registry bars.
---@param barKey string
---@return TRB.Classes.BarTypeDefinition?
local function GetBarTypeDefinition(barKey)
	local registry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
	return registry and registry:Get(barKey) or nil
end

---Returns the number of nodes a single nodeColors key occupies, honoring getNodeCountForKey
---(multi-charge nodes such as Holy Words) and the per-node enabled flag.
---@param barTypeDef TRB.Classes.BarTypeDefinition
---@param nodeConfig table
---@param colorSettings table?
---@return integer
local function GetNodeCountForKey(barTypeDef, nodeConfig, colorSettings)
	local isEnabled = true
	if nodeConfig.hasEnabled then
		isEnabled = colorSettings and colorSettings.nodeColors and colorSettings.nodeColors[nodeConfig.key]
			and colorSettings.nodeColors[nodeConfig.key].enabled or false
	end
	if not isEnabled then
		return 0
	end
	if barTypeDef.getNodeCountForKey then
		return barTypeDef.getNodeCountForKey(nodeConfig.key, colorSettings) or 0
	end
	return 1
end

---Computes the contiguous node run (1-based start index and node count) that a given
---amalgamation sub-type occupies within its bar group, respecting node ordering and the
---enabled state of preceding types.
---@param barTypeDef TRB.Classes.BarTypeDefinition
---@param colorSettings table?
---@param nodeKey string
---@return integer? startIndex
---@return integer nodeCount
local function GetAmalgamationNodeRun(barTypeDef, colorSettings, nodeKey)
	if barTypeDef.nodeColors == nil then
		return nil, 0
	end
	local orderedKeys = barTypeDef:GetOrderedNodeKeys(colorSettings)
	-- Index the definitions by key so we can look up enabled/count per ordered key.
	local defByKey = {}
	for _, nodeConfig in ipairs(barTypeDef.nodeColors) do
		defByKey[nodeConfig.key] = nodeConfig
	end
	local index = 1
	for _, key in ipairs(orderedKeys) do
		local nodeConfig = defByKey[key]
		if nodeConfig ~= nil then
			local count = GetNodeCountForKey(barTypeDef, nodeConfig, colorSettings)
			if key == nodeKey then
				if count <= 0 then
					return nil, 0
				end
				return index, count
			end
			index = index + count
		end
	end
	return nil, 0
end

---Resolves the per-target custom-threshold slider overrides (min/max/decimals) declared on the
---bar-type definition, or for amalgamation bars on the specific node entry. Returns nil for any
---value the definition does not override so callers apply their own defaults. The barTarget may
---be a plain bar key ("primary") or an amalgamation sub-target ("defensives:shieldBlock").
---@param barTarget string
---@return number? minOverride
---@return number? maxOverride
---@return integer? decimalsOverride
local function GetCustomThresholdScaleConfig(barTarget)
	if type(barTarget) ~= "string" then
		return nil, nil, nil
	end
	local baseKey, nodeKey = string.match(barTarget, "^([^:]+):(.+)$")
	baseKey = baseKey or barTarget
	local barTypeDef = GetBarTypeDefinition(baseKey)
	if barTypeDef == nil then
		return nil, nil, nil
	end
	if barTypeDef.isAmalgamation and nodeKey ~= nil and barTypeDef.nodeColors ~= nil then
		for _, nodeConfig in ipairs(barTypeDef.nodeColors) do
			if nodeConfig.key == nodeKey then
				return nodeConfig.thresholdMin, nodeConfig.thresholdMax, nodeConfig.thresholdDecimals
			end
		end
		return nil, nil, nil
	end
	return barTypeDef.thresholdMin, barTypeDef.thresholdMax, barTypeDef.thresholdDecimals
end

---Returns the context sub-target descriptors declared on a bar's GetSpecConfiguration entry, or
---nil. Context sub-targets split one physical bar into several custom-threshold targets, each
---shown only while its game-state context holds (e.g. Devourer secondary: Soul Fragments vs
---Collapsing Star).
---@param classId integer?
---@param specId integer?
---@param barKey string
---@param settings table? # Spec settings, used for any subTargetsRequireFormSwitching gate
---@return table[]?
local function GetBarContextSubTargets(classId, specId, barKey, settings)
	local config = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
	local barConfig = config and config[barKey]
	if barConfig == nil or barConfig.subTargets == nil then
		return nil
	end
	-- Druid primary form sub-targets only make sense when form switching is on; with it off the
	-- bar always shows the spec's native resource, so fall back to the single plain bar target.
	if barConfig.subTargetsRequireFormSwitching == true then
		local fs = settings and settings.displayBar and settings.displayBar.enableFormSwitching
		if fs == false then
			return nil
		end
	end
	return barConfig.subTargets
end

---Finds a single context sub-target descriptor by node key.
---@param classId integer?
---@param specId integer?
---@param baseKey string
---@param nodeKey string?
---@param settings table?
---@return table?
local function FindContextSubTarget(classId, specId, baseKey, nodeKey, settings)
	if nodeKey == nil then
		return nil
	end
	local subTargets = GetBarContextSubTargets(classId, specId, baseKey, settings)
	if subTargets == nil then
		return nil
	end
	for _, sub in ipairs(subTargets) do
		if sub.key == nodeKey then
			return sub
		end
	end
	return nil
end

---Returns whether a context sub-target's required game state currently holds. A sub-target with
---no declared context is always active. The context is read from a non-secret snapshot attribute
---(contextAttribute): matched against contextValues (a set, e.g. Druid form display-spec ids),
---contextValue (a single value), or activeWhen (a boolean, e.g. Devourer Collapsing Star).
---@param sub table?
---@return boolean
local function IsContextSubTargetActive(sub)
	if sub == nil or sub.contextAttribute == nil then
		return true
	end
	local attributes = TRB.Data.snapshotData and TRB.Data.snapshotData.attributes
	local live = attributes and attributes[sub.contextAttribute]
	if sub.contextValues ~= nil then
		for _, v in ipairs(sub.contextValues) do
			if live == v then
				return true
			end
		end
		return false
	end
	if sub.contextValue ~= nil then
		return live == sub.contextValue
	end
	return (live == true) == (sub.activeWhen == true)
end

---Returns the per-target decimal precision allowed on the Threshold Value slider. Most bars
---use whole numbers; bars whose underlying resource has finer granularity than its visible
---node count (e.g. Destruction Warlock Soul Shards, tracked in fragments) allow 1 decimal, as
---do bar definitions that declare thresholdDecimals (e.g. Warrior Shield Block remaining time).
---@param classId integer?
---@param specId integer?
---@param barKey string
---@return integer
local function GetCustomThresholdTargetDecimals(classId, specId, barKey)
	-- Destruction Warlock Soul Shards (secondary bar) fill in tenths of a shard, so allow a
	-- single decimal place to target partial-shard positions (e.g. 3.5 shards).
	if classId == 9 and specId == 3 and barKey == "secondary" then
		return 1
	end
	local _, _, decimals = GetCustomThresholdScaleConfig(barKey)
	return decimals or 0
end

---Splits a stored barTarget into its base bar key and optional amalgamation sub-type key.
---@param barTarget string?
---@return string baseKey
---@return string? nodeKey
local function ParseBarTarget(barTarget)
	if type(barTarget) ~= "string" then
		return "primary", nil
	end
	local baseKey, nodeKey = string.match(barTarget, "^([^:]+):(.+)$")
	if baseKey ~= nil then
		return baseKey, nodeKey
	end
	return barTarget, nil
end

---Returns true when a bar target's live value is a SECRET cast/charge count (Vengeance DH Soul
---Fragments, Blood DK Bone Shield, Fire Mage Fire Blast Charges) that Lua cannot compare or
---curve-evaluate. Such targets are restricted to the static color mode and have no over/under
---trigger. The flag is declared either on the registry BarTypeDefinition (custom bars like Bone
---Shield) or on the spec's GetSpecConfiguration block (secondary bars like Soul Fragments / Fire
---Blast). A target key may be a sub-target like "secondary:soulFragments"; the flag lives on the
---base bar.
---@param barTarget string
---@param classId integer?
---@param specId integer?
---@return boolean
function TRB.Functions.Threshold:BarTargetUsesSecretValue(barTarget, classId, specId)
	if barTarget == nil then
		return false
	end
	local baseKey = ParseBarTarget(barTarget)
	local barTypeDef = GetBarTypeDefinition(baseKey)
	if barTypeDef ~= nil and barTypeDef.usesSecretValue == true then
		return true
	end
	local config = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
	if config ~= nil and config[baseKey] ~= nil and config[baseKey].usesSecretValue == true then
		return true
	end
	return false
end

---Resolves the display name for a custom-threshold bound-bar target. Unlike the generic
---bar anchoring UI (which intentionally says "Primary Resource Bar"), custom thresholds show
---the actual resource (e.g. "Insanity", "Soul Shards", "Health"). Registry bars already carry
---a meaningful displayName, so only primary/secondary/health are special-cased.
---@param classId integer?
---@param specId integer?
---@param barKey string
---@return string
local function GetCustomThresholdBarTargetName(classId, specId, barKey)
	local Character = TRB.Functions.Character
	-- Prefer the bar group's declared resourceType (primary/secondary/health/utility/custom
	-- all declare it in GetSpecConfiguration). This gives the resource-accurate name, e.g.
	-- Priest's "utility" bar resolves to "Angelic Feather" rather than the generic registry
	-- display name "Utility".
	local config = Character:GetSpecBarGroupConfig(classId, specId)
	local barConfig = config and config[barKey]
	local name = barConfig and Character:GetResourceTypeName(barConfig.resourceType)
	if name ~= nil then
		return name
	end

	if TRB.Functions.Bar and TRB.Functions.Bar.GetBarDisplayName then
		return TRB.Functions.Bar:GetBarDisplayName(barKey)
	end
	return barKey
end

---Returns whether a bar target's threshold value is a percentage (0-100%-style fill) rather than
---an absolute/discrete unit. Percentage scales: Health, Mana (primary, dedicated mana bar, and
---percent sub-targets), and Stagger (minMaxMode "percentage"). Raw power resources (Insanity,
---Energy, Rage, Astral Power, etc.) and node counts (combo points, charges) are NOT percentages.
---@param classId integer?
---@param specId integer?
---@param barKey string
---@param barTypeDef table?
---@return boolean
local function IsPercentScaleTarget(classId, specId, barKey, barTypeDef)
	if barKey == "health" then
		return true
	end
	if barTypeDef ~= nil and (barTypeDef.minMaxMode == "percentage" or barTypeDef.minMaxMode == "mana") then
		return true
	end
	if barKey == "primary" then
		local config = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
		if config and config.primary and config.primary.resourceType == "Mana" then
			return true
		end
	end
	return false
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param classId integer?
---@param specId integer?
---@return table[]
function TRB.Functions.Threshold:GetCustomThresholdBarTargets(settings, classId, specId)
	local targets = {}
	if settings == nil then
		return targets
	end

	-- Default to the active character's class/spec when not supplied (runtime callers).
	if classId == nil and TRB.Data.character ~= nil then
		classId = TRB.Data.character.classId
	end
	if specId == nil and TRB.Data.character ~= nil then
		specId = TRB.Data.character.specId
	end

	local keys = {}
	if TRB.Functions.Bar and TRB.Functions.Bar.GetAllBarKeysFromSettings then
		keys = TRB.Functions.Bar:GetAllBarKeysFromSettings(settings)
	else
		keys = { "primary", "secondary", "health" }
	end

	-- Bars folded into another bar's context sub-target (via altBarKey) are not listed on their
	-- own. Example: Balance's dedicated mana bar is subsumed by the unified primary "Mana" target,
	-- which renders on the mana bar in Moonkin and on the primary bar in Humanoid/Travel.
	local suppressed = {}
	for _, barKey in ipairs(keys) do
		local subs = GetBarContextSubTargets(classId, specId, barKey, settings)
		if subs ~= nil then
			for _, sub in ipairs(subs) do
				if sub.altBarKey ~= nil then
					suppressed[sub.altBarKey] = true
				end
			end
		end
	end

	for _, barKey in ipairs(keys) do
		if barKey ~= "screen" and not suppressed[barKey] then
			local barTypeDef = GetBarTypeDefinition(barKey)
			if barTypeDef ~= nil and barTypeDef.isAmalgamation and barTypeDef.nodeColors ~= nil then
				-- Amalgamation bars (Holy Words, Defensives) expose one sub-target per node
				-- type (e.g. "Holy Word: Serenity") instead of a single bar-wide target.
				local colorSettings = barTypeDef:GetColors(settings)
				local orderedKeys = barTypeDef:GetOrderedNodeKeys(colorSettings)
				local defByKey = {}
				for _, nodeConfig in ipairs(barTypeDef.nodeColors) do
					defByKey[nodeConfig.key] = nodeConfig
				end
				for _, nodeKey in ipairs(orderedKeys) do
					local nodeConfig = defByKey[nodeKey]
					if nodeConfig ~= nil then
						table.insert(targets, {
							key = barKey .. ":" .. nodeKey,
							label = nodeConfig.colorLabel or nodeConfig.displayName or nodeKey,
							decimals = nodeConfig.thresholdDecimals or 0,
						})
					end
				end
			else
				local subTargets = GetBarContextSubTargets(classId, specId, barKey, settings)
				if subTargets ~= nil then
					-- Context-switched bars (e.g. Devourer secondary) expose one sub-target per context.
					for _, sub in ipairs(subTargets) do
						table.insert(targets, {
							key = barKey .. ":" .. sub.key,
							label = (sub.resourceType and TRB.Functions.Character:GetResourceTypeName(sub.resourceType)) or sub.label or sub.key,
							decimals = sub.decimals or 0,
							isPercent = sub.scale == "percent",
						})
					end
				else
					table.insert(targets, {
						key = barKey,
						label = GetCustomThresholdBarTargetName(classId, specId, barKey),
						decimals = GetCustomThresholdTargetDecimals(classId, specId, barKey),
						isPercent = IsPercentScaleTarget(classId, specId, barKey, barTypeDef),
					})
				end
			end
		end
	end

	return targets
end

---@param barGroups table<string, TRB.Classes.BarGroup>?
---@param barKey string
---@return TRB.Classes.BarGroup?
local function GetBarGroup(barGroups, barKey)
	if barGroups == nil then
		return nil
	end
	return barGroups[barKey]
end

---@param group TRB.Classes.BarGroup?
---@return StatusBar?
local function GetFirstNodeFrame(group)
	if group == nil or type(group.GetNode) ~= "function" then
		return nil
	end

	local node = group:GetNode(1)
	if node ~= nil and type(node.GetFrame) == "function" then
		return node:GetFrame()
	end

	return nil
end

---@param group TRB.Classes.BarGroup?
---@param index integer
---@return Frame?
local function GetNodeFrame(group, index)
	if group == nil or type(group.GetNode) ~= "function" then
		return nil
	end
	local node = group:GetNode(index)
	if node ~= nil and type(node.GetFrame) == "function" then
		return node:GetFrame()
	end
	return nil
end

---Returns the number of visible nodes in a bar group (live node count, falling back to the
---group's configured maximum).
---@param group TRB.Classes.BarGroup?
---@return integer
local function GetGroupNodeCount(group)
	if group == nil then
		return 0
	end
	return GetPositivePlainNumber(group.nodeCount, GetPositivePlainNumber(group.maxNodes, 1))
end

---Sums the live fill of a contiguous run of bar-group nodes as a count in node-count units.
---Each node's fill is normalized against its OWN min/max range (0..1 per node), so this works
---for both node fill models: "1 per filled node" bars (Angelic Feather, Holy Words: range 0..1)
---and segmented bars that set every node to the absolute count over a per-node range (Fire Blast
---Charges: node x ranges x-1..x, value = charges). Summing the raw values would over-count the
---latter. Returns the total and whether any node value/range was secret; when secret, the total
---is unreliable and callers should not use it for comparisons.
---@param group TRB.Classes.BarGroup?
---@param fromIndex integer
---@param count integer
---@return number total
---@return boolean sawSecret
---@return boolean sawPlain
local function SumNodeValues(group, fromIndex, count)
	local total = 0
	local sawSecret = false
	local sawPlain = false
	for i = fromIndex, fromIndex + count - 1 do
		local nodeFrame = GetNodeFrame(group, i)
		if nodeFrame ~= nil and type(nodeFrame.GetValue) == "function" then
			local v = nodeFrame:GetValue()
			if IsSecretValue(v) or type(v) ~= "number" then
				sawSecret = true
			else
				-- Normalize the raw value into this node's own 0..1 fill fraction.
				local nodeMin, nodeMax = 0, 1
				if type(nodeFrame.GetMinMaxValues) == "function" then
					local lo, hi = nodeFrame:GetMinMaxValues()
					if IsSecretValue(lo) or IsSecretValue(hi) then
						sawSecret = true
					else
						nodeMin = GetPlainNumber(lo, 0)
						nodeMax = GetPlainNumber(hi, 1)
					end
				end
				local span = nodeMax - nodeMin
				local fraction = v
				if span > 0 then
					fraction = (v - nodeMin) / span
				end
				if fraction < 0 then
					fraction = 0
				elseif fraction > 1 then
					fraction = 1
				end
				total = total + fraction
				sawPlain = true
			end
		end
	end
	return total, sawSecret, sawPlain
end

---@param group TRB.Classes.BarGroup?
---@return Frame?
local function GetGroupContainer(group)
	if group == nil or type(group.GetContainerFrame) ~= "function" then
		return nil
	end

	return group:GetContainerFrame()
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>?
---@param barTarget string
---@param classId integer?
---@param specId integer?
---@return table?
function TRB.Functions.Threshold:GetCustomThresholdTargetInfo(settings, barGroups, barTarget, classId, specId)
	if settings == nil or barGroups == nil or barTarget == nil then
		return nil
	end

	if classId == nil and TRB.Data.character ~= nil then
		classId = TRB.Data.character.classId
	end
	if specId == nil and TRB.Data.character ~= nil then
		specId = TRB.Data.character.specId
	end

	local baseKey, nodeKey = ParseBarTarget(barTarget)
	local snapshotData = TRB.Data.snapshotData or {}
	local attributes = snapshotData.attributes or {}
	local group = GetBarGroup(barGroups, baseKey)
	if group == nil then
		return nil
	end

	local parentFrame = GetGroupContainer(group)
	local valueFrame = GetFirstNodeFrame(group)
	if parentFrame == nil or valueFrame == nil then
		return nil
	end

	local currentValue, maxValue = GetStatusBarValues(valueFrame)
	local fillDirection = group.growthDirection or "leftRight"
	local border = 0
	local resourceType = nil
	local minValue = 0
	local isNodeMapped = false
	local nodes = nil
	local nodeCount = 0
	local nodeStartIndex = 1
	-- True only for bars whose live value is a non-secret Lua number summed from node fills
	-- (charge/stack custom bars). Those have no secret-safe percent API, so their over/under
	-- coloring is decided by a direct numeric comparison instead of a ColorCurve.
	local supportsValueComparison = false
	-- nil for normal targets; true/false for a context sub-target whose game-state context is
	-- (in)active. UpdateCustomThresholdLines hides the line when this is false.
	local contextActive = nil
	-- Enhancement compressed Maelstrom Weapon: 5 nodes show 10 stacks (6-10 overlap 1-5).
	local compressedOverlap = false
	local compressedSplit = 0
	local compressedActive = false

	if baseKey == "primary" and FindContextSubTarget(classId, specId, "primary", nodeKey, settings) ~= nil then
		-- Druid form sub-target (e.g. "primary:energy"): the primary bar shows a different
		-- resource per shapeshift form. Each form's resource is a real power type, so coloring
		-- uses the secret-safe ColorCurve path (no comparison needed). The unified Mana target
		-- renders on the dedicated mana bar in Moonkin (altBarKey) and the primary bar otherwise.
		local sub = FindContextSubTarget(classId, specId, "primary", nodeKey, settings)
		contextActive = IsContextSubTargetActive(sub)

		local resolvedKey = "primary"
		if sub.altBarKey ~= nil and sub.contextAttribute ~= nil
			and attributes[sub.contextAttribute] == sub.altWhenContextValue then
			resolvedKey = sub.altBarKey
		end
		local resolvedGroup = GetBarGroup(barGroups, resolvedKey) or group
		local resolvedNodeFrame = GetFirstNodeFrame(resolvedGroup)
		if resolvedNodeFrame ~= nil then
			group = resolvedGroup
			valueFrame = resolvedNodeFrame
		end
		parentFrame = valueFrame
		resourceType = sub.powerType

		if sub.scale == "percent" then
			maxValue = GetPositivePlainNumber(sub.max, 100)
		else
			-- Raw units shown to the player are the unmodified max divided by the resource's
			-- display factor (e.g. Rage max 1000 / 10 = 100). The ColorCurve evaluates against
			-- the resource's true fill fraction, so value/maxValue must be that same fraction.
			local factor = sub.factor or 1
			local liveMax = sub.maxField and TRB.Data.character and TRB.Data.character[sub.maxField]
			if type(liveMax) == "number" and liveMax > 0 and factor > 0 then
				maxValue = liveMax / factor
			else
				maxValue = GetPositivePlainNumber(sub.max, 100)
			end
		end
		-- Over/under comes from the power-type ColorCurve; no Lua-side comparison value needed.
		currentValue = 0

		if resolvedKey == "primary" then
			fillDirection = settings.bar and settings.bar.fillDirection or fillDirection
			border = settings.bar and settings.bar.border or 0
		else
			local bs = settings.bars and settings.bars[resolvedKey]
			fillDirection = (bs and bs.fillDirection) or (resolvedGroup and resolvedGroup.growthDirection) or fillDirection
			border = (bs and bs.border) or 0
		end
	elseif baseKey == "primary" then
		parentFrame = valueFrame
		-- Mirror the regular threshold path: positions/comparisons use the spec's
		-- display-unit resource value (UnitPower unmodified=false, stored as
		-- attributes.resourceModified) against the current max resource.
		local rawCurrentValue = attributes.resourceModified
		if rawCurrentValue == nil or IsSecretValue(rawCurrentValue) or type(rawCurrentValue) ~= "number" then
			-- resourceModified (display units) was unavailable/secret. Derive a
			-- display-unit value from the raw resource by dividing out the spec's
			-- resourceFactor so currentValue stays on the SAME scale as maxValue.
			-- Falling back to the raw value directly (e.g. 5000 vs a display max of
			-- 100) made currentValue >= value always true, so the threshold rendered
			-- as "over" regardless of the actual resource.
			local rawResource = attributes.resource
			local resourceFactor = TRB.Data.resourceFactor or 1
			if rawResource ~= nil and not IsSecretValue(rawResource) and type(rawResource) == "number" and resourceFactor > 0 then
				rawCurrentValue = rawResource / resourceFactor
			else
				rawCurrentValue = nil
			end
		end
		if rawCurrentValue ~= nil and not IsSecretValue(rawCurrentValue) and type(rawCurrentValue) == "number" then
			currentValue = rawCurrentValue
		else
			currentValue = GetPlainNumber(currentValue, 0)
		end
		maxValue = GetPrimaryBarMaxValue(settings, maxValue)
		fillDirection = settings.bar and settings.bar.fillDirection or fillDirection
		border = settings.bar and settings.bar.border or 0
		resourceType = TRB.Data.resource
		-- Mana primary (healer specs) is percent-based: the absolute mana max is huge and useless
		-- as a slider scale. Use resourcePercent on a 0-100 scale; over/under still uses the
		-- secret-safe Mana ColorCurve (resourceType stays a real PowerType).
		if resourceType == Enum.PowerType.Mana then
			maxValue = 100
			currentValue = GetPlainNumber(attributes.resourcePercent, 0)
		end
	elseif baseKey == "secondary" then
		local sub = FindContextSubTarget(classId, specId, "secondary", nodeKey, settings)
		if sub ~= nil then
			-- Context sub-target (e.g. Devourer Soul Fragments / Collapsing Star): single-node
			-- percentage bar positioned across the whole node on the sub-target's own scale.
			-- resource2 carries the active context's value, so currentValue is only meaningful
			-- while this sub-target's context is live (gated by contextActive).
			contextActive = IsContextSubTargetActive(sub)
			local liveMax = GetPositivePlainNumber(attributes.maxResource2, 0)
			if contextActive and liveMax > 0 then
				maxValue = liveMax
			else
				maxValue = GetPositivePlainNumber(sub.max, 100)
			end
			-- These custom resources have no power-type curve API (resource2 == "CUSTOM"), so
			-- decide over/under with a direct comparison when the live count is a usable non-secret
			-- number (e.g. Collapsing Star stacks). Secret values (e.g. Soul Fragments) can't be
			-- compared in Lua and fall back to the static under color.
			local liveResource2 = attributes.resource2
			if liveResource2 ~= nil and not IsSecretValue(liveResource2) and type(liveResource2) == "number" then
				currentValue = liveResource2
				supportsValueComparison = true
			else
				currentValue = GetPlainNumber(liveResource2, 0)
			end
			fillDirection = settings.comboPoints and settings.comboPoints.fillDirection or fillDirection
			border = settings.comboPoints and settings.comboPoints.border or 0
			resourceType = TRB.Data.resource2
		else
			-- Multi-node secondary bars (combo points, soul shards, etc.) are mapped node-by-node:
			-- the value scale is the visible node count, NOT the raw resource max. This keeps the
			-- displayed position node-accurate even when the underlying resource has finer
			-- granularity than the node count (e.g. Destruction Warlock Soul Shards track 50
			-- fragments across 5 nodes, so a value of 3.5 lands halfway through node 4).
			nodeCount = GetGroupNodeCount(group)
			maxValue = GetPositivePlainNumber(nodeCount, GetPositivePlainNumber(group.maxNodes, maxValue))
			local liveMax = GetPositivePlainNumber(TRB.Data.character and TRB.Data.character.maxResource2, maxValue)
			local rawResource2 = GetPlainNumber(attributes.resource2, 0)
			if liveMax > 0 then
				currentValue = rawResource2 * maxValue / liveMax
			else
				currentValue = rawResource2
			end
			local isRunes = TRB.Data.resource2 == Enum.PowerType.Runes
			local compressedView = specId == 2 and settings.colors and settings.colors.comboPoints
				and settings.colors.comboPoints.compressedView == true
			if isRunes then
				-- Death Knight Runes recharge per-node (fractional fills) and Runes is a real PowerType, so
				-- UnitPowerPercent only sees the ready count and the curve never matches the bar. Compare
				-- the complete (ready) rune count directly instead, like a summed combo-point bar.
				currentValue = GetPlainNumber(attributes.runesReadyCount, 0)
				supportsValueComparison = true
			elseif compressedView and liveMax > nodeCount then
				-- Enhancement compressed Maelstrom Weapon: 5 physical nodes show 10 stacks (6-10 overlap
				-- 1-5). Keep the full 0-10 stack scale so 6-10 thresholds stay in range, and use the plain
				-- stack count for over/under (the render remap folds 6-10 onto the overlap nodes and the
				-- visibility gate hides the inactive layer). Stacks come from the snapshot (resource2 is
				-- nil for Enhancement); node fills cap at the visible 5 in compressed view.
				local stacks = GetPlainNumber(attributes.maelstromWeaponStacks, rawResource2)
				maxValue = liveMax
				currentValue = stacks
				supportsValueComparison = true
				compressedOverlap = true
				compressedSplit = nodeCount
				compressedActive = stacks >= (nodeCount + 1)
			else
				-- Secondary bars whose live count is stored as non-secret node fills (e.g. Fury Warrior
				-- Whirlwind stacks, 1 per filled node) have no real power-type resource (resource2 is
				-- nil), so the ColorCurve path can't decide over/under. Derive it from the node sum like
				-- the registered multi-node bars. Power-type secondary bars (combo points, soul shards)
				-- report secret node values, so they keep using the ColorCurve path instead.
				local nodeSum, sawSecret, sawPlain = SumNodeValues(group, 1, nodeCount)
				local hasPowerCurve = type(TRB.Data.resource2) == "number"
				if not sawSecret then
					currentValue = nodeSum
					supportsValueComparison = true
				elseif not hasPowerCurve and sawPlain then
					-- Charge bars without a secret-safe power-type curve (e.g. Fire Blast Charges, Icicles)
					-- have a timer-driven recharging node whose value is secret. That node is always < 1
					-- charge, so the plain completed-charge count alone decides integer over/under; use it
					-- instead of falling back to the static under color.
					currentValue = nodeSum
					supportsValueComparison = true
				end
			end
			fillDirection = settings.comboPoints and settings.comboPoints.fillDirection or fillDirection
			border = settings.comboPoints and settings.comboPoints.border or 0
			resourceType = TRB.Data.resource2
			-- Skip the power curve for Runes so the ready-count comparison above decides over/under.
			if isRunes then
				resourceType = nil
			end
			if nodeCount > 1 then
				isNodeMapped = true
				nodes = {}
				for i = 1, nodeCount do
					nodes[i] = GetNodeFrame(group, i)
				end
			end
		end
	elseif baseKey == "health" then
		parentFrame = valueFrame
		-- Health custom thresholds are percent-based (0-100): positioning uses the percent value,
		-- and over/under coloring uses UnitHealthPercent (secret-safe). The bar fills 0-healthMax,
		-- so a percent threshold lines up with the matching fill fraction.
		currentValue = GetPlainNumber(attributes.healthPercent, 0)
		maxValue = 100
		fillDirection = settings.healthBar and settings.healthBar.fillDirection or fillDirection
		border = settings.healthBar and settings.healthBar.border or 0
	else
		local barSettings = settings.bars and settings.bars[baseKey]
		fillDirection = (barSettings and barSettings.fillDirection) or fillDirection
		border = (barSettings and barSettings.border) or 0

		local barTypeDef = GetBarTypeDefinition(baseKey)
		if barTypeDef ~= nil then
			if barTypeDef.isAmalgamation and nodeKey ~= nil then
				-- Amalgamation sub-target (e.g. "holyWords:holyWordSerenity"): position the line
				-- onto the contiguous node run that this type occupies. Live count is the node sum
				-- (non-secret), so over/under coloring uses a direct comparison via supportsValueComparison.
				local colorSettings = barTypeDef:GetColors(settings)
				local startIndex, runCount = GetAmalgamationNodeRun(barTypeDef, colorSettings, nodeKey)
				if startIndex == nil or runCount <= 0 then
					return nil
				end
				nodeStartIndex = startIndex
				nodeCount = runCount
				maxValue = runCount
				-- This type's live count is the sum of its node fill values (non-secret), in the
				-- same node-count units as maxValue, used for the over/under comparison.
				local nodeSum, sawSecret, sawPlain = SumNodeValues(group, startIndex, runCount)
				-- No power-type curve here, so a timer-driven (secret) recharging node must not disable
				-- the comparison: it is always < 1, so the plain completed count decides over/under.
				if not sawSecret or sawPlain then
					currentValue = nodeSum
					supportsValueComparison = true
				end
				isNodeMapped = true
				nodes = {}
				for i = 1, runCount do
					nodes[i] = GetNodeFrame(group, startIndex + i - 1)
				end
			elseif barTypeDef.isMultiNode then
				nodeCount = GetGroupNodeCount(group)
				maxValue = GetPositivePlainNumber(nodeCount, GetPositivePlainNumber(barTypeDef.maxNodes, maxValue))
				-- These bars track charge/stack counts as non-secret node fill values (e.g.
				-- Angelic Feather charges). Sum them so the over/under comparison has the live
				-- count in node-count units. (Power-type bars never reach here.)
				local nodeSum, sawSecret, sawPlain = SumNodeValues(group, 1, nodeCount)
				-- No power-type curve here, so a timer-driven (secret) recharging node must not disable
				-- the comparison: it is always < 1, so the plain completed count decides over/under.
				if not sawSecret or sawPlain then
					currentValue = nodeSum
					supportsValueComparison = true
				end
				if nodeCount > 1 then
					isNodeMapped = true
					nodes = {}
					for i = 1, nodeCount do
						nodes[i] = GetNodeFrame(group, i)
					end
				end
			elseif barTypeDef.minMaxMode == "percentage" then
				maxValue = GetPositivePlainNumber(barTypeDef.maxThresholdPercent, 100)
				-- Percentage bars with a maxScale (e.g. Brewmaster Stagger displays 0..maxScale*100%)
				-- position thresholds against the LIVE visible scale, not the slider's absolute max.
				local scale = barSettings and barSettings.maxScale
				if scale ~= nil and scale > 0 then
					maxValue = scale * 100
				end
			elseif barTypeDef.minMaxMode == "mana" then
				-- Dedicated mana bar (Shadow/Balance/Elemental): percent-based, 0-100. The bar fills
				-- 0-manaMax, so a percent threshold lines up with the matching fill fraction.
				resourceType = Enum.PowerType.Mana
				maxValue = 100
			end

			-- Explicit per-definition value scale (e.g. Shield Block 0-8s) overrides the node-count max.
			local minOverride, maxOverride = GetCustomThresholdScaleConfig(barTarget)
			if maxOverride ~= nil then
				minValue = minOverride or 0
				-- thresholdScaleFromLiveMax bars (e.g. Ebon Might) keep the live frame max for
				-- positioning/over-under so the line tracks the bar's current scaling (the last-known
				-- buff duration). Only the value SLIDER uses thresholdMax (via GetCustomThresholdScaleConfig
				-- in GetCustomThresholdTargetRange); the runtime scale stays the live bar max.
				if not barTypeDef.thresholdScaleFromLiveMax then
					maxValue = maxOverride
				end
			end

			-- Gate this bar's custom thresholds on a live "is this mechanic active?" snapshot
			-- attribute (e.g. hide Ebon Might's lines while the buff is down). contextActive == false
			-- makes UpdateCustomThresholdLines hide the line until the attribute is truthy again.
			if barTypeDef.thresholdActiveAttribute ~= nil then
				contextActive = attributes[barTypeDef.thresholdActiveAttribute] == true
			end
		end
	end

	currentValue = GetPlainNumber(currentValue, 0)
	maxValue = GetPositivePlainNumber(maxValue, 100)
	if maxValue < minValue then
		maxValue = minValue
	end

	-- General over/under fallback for single-node bars with no power-type curve API (resourceType
	-- not a real PowerType enum) that haven't already resolved a comparison above (e.g. Ebon Might,
	-- Stagger, and other custom/percentage bars). Compare the live fill FRACTION against the
	-- threshold fraction so it stays correct regardless of how maxValue was rescaled. Only applies
	-- when the bar's live value is a non-secret number; secret-valued bars keep the static under
	-- color, and multi-node/health/power-type bars are handled by their own paths above.
	if not supportsValueComparison and not isNodeMapped and baseKey ~= "health"
		and type(resourceType) ~= "number" and valueFrame ~= nil and type(valueFrame.GetValue) == "function" then
		local rawValue = valueFrame:GetValue()
		if rawValue ~= nil and not IsSecretValue(rawValue) and type(rawValue) == "number" then
			local rawMax = nil
			if type(valueFrame.GetMinMaxValues) == "function" then
				local _, fm = valueFrame:GetMinMaxValues()
				if fm ~= nil and not IsSecretValue(fm) and type(fm) == "number" and fm > 0 then
					rawMax = fm
				end
			end
			if rawMax ~= nil then
				currentValue = (rawValue / rawMax) * maxValue
				supportsValueComparison = true
			end
		end
	end

	return {
		key = barTarget,
		baseKey = baseKey,
		nodeKey = nodeKey,
		group = group,
		parentFrame = parentFrame,
		valueFrame = valueFrame,
		currentValue = currentValue or 0,
		minValue = minValue,
		maxValue = maxValue,
		fillDirection = fillDirection,
		border = border,
		resourceType = resourceType,
		isNodeMapped = isNodeMapped,
		nodes = nodes,
		nodeCount = nodeCount,
		nodeStartIndex = nodeStartIndex,
		supportsValueComparison = supportsValueComparison,
		usesSecretValue = TRB.Functions.Threshold:BarTargetUsesSecretValue(barTarget, classId, specId),
		contextActive = contextActive,
		compressedOverlap = compressedOverlap,
		compressedSplit = compressedSplit,
		compressedActive = compressedActive,
	}
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barTarget string
---@param barGroups table<string, TRB.Classes.BarGroup>?
---@param classId integer?
---@param specId integer?
---@return number minValue
---@return number maxValue
function TRB.Functions.Threshold:GetCustomThresholdTargetRange(settings, barTarget, barGroups, classId, specId)
	if settings == nil or barTarget == nil then
		return 0, 100
	end

	if classId == nil and TRB.Data.character ~= nil then
		classId = TRB.Data.character.classId
	end
	if specId == nil and TRB.Data.character ~= nil then
		specId = TRB.Data.character.specId
	end

	if barGroups ~= nil then
		local targetInfo = TRB.Functions.Threshold:GetCustomThresholdTargetInfo(settings, barGroups, barTarget, classId, specId)
		if targetInfo ~= nil then
			return targetInfo.minValue or 0, targetInfo.maxValue or 100
		end
	end

	local baseKey, nodeKey = ParseBarTarget(barTarget)
	if baseKey == "primary" then
		-- Druid form sub-target: each resource has a fixed display scale (raw 0-max, or 0-100% for Mana).
		local sub = FindContextSubTarget(classId, specId, "primary", nodeKey, settings)
		if sub ~= nil then
			return 0, GetPositivePlainNumber(sub.max, 100)
		end
		-- Mana primary (healer specs) is percent-based, matching the live 0-100 scale.
		if IsPercentScaleTarget(classId, specId, "primary", nil) then
			return 0, 100
		end
		-- Options-panel fallback (no live barGroups): use the spec's DEFINED maximum
		-- resource constant (settings.maxResource.value, e.g. SHADOW_MAX_INSANITY = 150)
		-- so a threshold can be configured up to the spec's maximum possible resource,
		-- independent of the current character's live max. Runtime positioning still
		-- uses the live current max via GetCustomThresholdTargetInfo.
		local definedMax = settings.maxResource and GetPlainNumber(settings.maxResource.value, 0) or 0
		if definedMax <= 0 then
			definedMax = GetPrimaryBarMaxValue(settings, 100)
		end
		return 0, GetPositivePlainNumber(definedMax, 100)
	elseif baseKey == "secondary" then
		local sub = FindContextSubTarget(classId, specId, "secondary", nodeKey, settings)
		if sub ~= nil then
			return 0, GetPositivePlainNumber(sub.max, 100)
		end
		-- Use the VISIBLE node count (one per displayed shard/point), not the raw resource
		-- max which can be fragment-scaled (e.g. Destruction Warlock = 50 fragments / 5 nodes).
		local config = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
		local nodes = config and config.secondary and config.secondary.maxNodes
		if nodes ~= nil then
			return 0, GetPositivePlainNumber(nodes, 5)
		end
		return 0, GetPositivePlainNumber(TRB.Data.character and TRB.Data.character.maxResource2, 5)
	elseif baseKey == "health" then
		return 0, 100
	elseif settings.bars and settings.bars[baseKey] then
		local barTypeDef = GetBarTypeDefinition(baseKey)
		if barTypeDef ~= nil then
			-- Explicit per-definition slider scale (e.g. Shield Block 0-8s) overrides the node-count range.
			local minOverride, maxOverride = GetCustomThresholdScaleConfig(barTarget)
			if maxOverride ~= nil then
				return minOverride or 0, GetPositivePlainNumber(maxOverride, 100)
			end
			if barTypeDef.isAmalgamation and nodeKey ~= nil then
				local colorSettings = barTypeDef:GetColors(settings)
				local _, runCount = GetAmalgamationNodeRun(barTypeDef, colorSettings, nodeKey)
				return 0, GetPositivePlainNumber(runCount, 1)
			elseif barTypeDef.isMultiNode then
				return 0, GetPositivePlainNumber(barTypeDef.maxNodes, 1)
			elseif barTypeDef.minMaxMode == "percentage" then
				return 0, GetPositivePlainNumber(barTypeDef.maxThresholdPercent, 100)
			end
		end
	end

	return 0, 100
end

---Resolves a custom threshold's stored value to an absolute resource value, honoring valueMode.
---In "offset" mode the stored value is an offset from the bar's maximum (e.g. -10 => max - 10).
---Returns the raw resolved value WITHOUT clamping so callers keep their own range checks.
---@param customThreshold TRB.Classes.Settings.CustomThresholdLine
---@param maxValue number
---@return number
function TRB.Functions.Threshold:GetEffectiveCustomThresholdValue(customThreshold, maxValue)
	local v = customThreshold.value or 0
	if (customThreshold.valueMode or "absolute") == "offset" then
		v = maxValue + v
	end
	return v
end

---@param threshold Frame
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param targetInfo table
function TRB.Functions.Threshold:ResetCustomThresholdLine(threshold, settings, targetInfo)
	if threshold == nil or settings == nil or targetInfo == nil then
		return
	end

	local effectiveWidth = targetInfo.parentFrame:GetWidth()
	local effectiveHeight = targetInfo.parentFrame:GetHeight()
	local borderSubtraction = 0
	if not settings.thresholds.properties.overlapBorder then
		borderSubtraction = (targetInfo.border or 0) * 2
	end

	SetThresholdLineDimensions(threshold, targetInfo.fillDirection, effectiveWidth, effectiveHeight, settings.thresholds.properties.width, borderSubtraction)
---@diagnostic disable-next-line: inject-field
	threshold.lineThickness = settings.thresholds.properties.width
---@diagnostic disable-next-line: inject-field
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase - TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:SetFrameStrata(TRB.Data.settings.core.strata.level)
	threshold:Hide()
---@diagnostic disable-next-line: inject-field
	threshold.hasIcon = true

---@diagnostic disable-next-line: inject-field
	threshold.icon = threshold.icon or CreateFrame("Frame", nil, threshold, "BackdropTemplate")
	threshold.icon:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase - TRB.Data.constants.frameLevels.thresholdOffsetIcon)
	threshold.icon:SetFrameStrata(TRB.Data.settings.core.strata.level)
---@diagnostic disable-next-line: inject-field
	threshold.icon.texture = threshold.icon.texture or threshold.icon:CreateTexture(nil, "BACKGROUND")
	threshold.icon.texture:SetAllPoints(threshold.icon)
---@diagnostic disable-next-line: inject-field
	threshold.icon.cooldown = threshold.icon.cooldown or CreateFrame("Cooldown", nil, threshold.icon, "CooldownFrameTemplate")
	threshold.icon.cooldown:SetAllPoints(threshold.icon)
	threshold.icon.cooldown:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase - TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
	threshold.icon.cooldown:SetFrameStrata(TRB.Data.settings.core.strata.level)
	threshold.icon.cooldown:SetCooldown(0, 0)

	SetThresholdIconSizeAndPosition(settings, threshold, targetInfo.fillDirection)
	TRB.Functions.Color:SetThresholdColor(threshold, settings.colors.threshold.over.color, true)
end

---@param customThreshold TRB.Classes.Settings.CustomThresholdLine
---@return string|number?
function TRB.Functions.Threshold:GetCustomThresholdIconTexture(customThreshold)
	if customThreshold == nil then
		return nil
	end

	-- "none" means the threshold has no icon at all; never resolve a texture.
	if customThreshold.iconSourceType == "none" then
		return nil
	end

	if customThreshold.iconTexture ~= nil then
		return customThreshold.iconTexture
	end

	local sourceId = tonumber(customThreshold.iconSourceId) or 0
	if sourceId <= 0 then
		-- A non-"none" source type with an unset/zero ID still wants an icon shown: fall back to
		-- the "missing icon" question mark rather than hiding it. Only "none" (handled above)
		-- suppresses the icon entirely.
		return 134400 -- inv-misc-questionmark
	end

	local texture = nil
	if customThreshold.iconSourceType == "item" then
		if C_Item and C_Item.GetItemIconByID then
			texture = C_Item.GetItemIconByID(sourceId)
		elseif C_Item and C_Item.GetItemInfoInstant then
			local _, _, _, _, icon = C_Item.GetItemInfoInstant(sourceId)
			texture = icon
		end
	elseif customThreshold.iconSourceType == "icon" then
		-- "icon" uses the ID directly as a texture/file ID.
		texture = sourceId
	else
		if C_Spell and C_Spell.GetSpellTexture then
			texture = C_Spell.GetSpellTexture(sourceId)
		elseif GetSpellTexture then
			texture = GetSpellTexture(sourceId)
		end
	end

	-- A source ID was provided but no texture resolved (e.g. the spell or item matching that
	-- ID doesn't exist). Fall back to the "missing icon" question mark so the user still sees
	-- an icon for an enabled threshold instead of an empty box.
	if texture == nil then
		texture = 134400 -- inv-misc-questionmark
	end

	return texture
end

---Evaluates a custom threshold's value-based ColorCurve against the SECRET resource
---for its target bar and applies the result to the line color and the icon
---desaturation vertex color, using the SAME canonical curve setters that spell
---thresholds use (`SetThresholdColorFromCurve` / `SetIconVertexColorFromCurve`).
---
---This is how the tried-and-true "no easy usable check" thresholds (e.g. Warrior
---`Execute (maximum)`) avoid the secret-value problem: the under/over decision is made
---INSIDE WoW's percent API (`UnitPowerPercent` / `UnitHealthPercent`) against the secret
---resource and baked into the returned color object — Lua never compares the secret, so
---the line color and the icon saturation always agree.
---@param threshold table # The custom threshold frame
---@param targetInfo table # Target info (resourceType / key drive which percent API to use)
---@param thresholdCurve table # The line ColorCurve from BuildThresholdValueCurve (under->over)
---@param iconCurve table? # The icon ColorCurve from BuildThresholdValueCurve (gray->white)
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param thresholdOverrides table? # Per-threshold overrides (for per-threshold desaturated flag)
---@return boolean applied # True if a curve color was applied; false to fall back to static color
function TRB.Functions.Threshold:ApplyCustomThresholdCurveColor(threshold, targetInfo, thresholdCurve, iconCurve, settings, thresholdOverrides)
	if threshold == nil or thresholdCurve == nil or targetInfo == nil then
		return false
	end

	-- Pick the secret-safe percent API for this bar target. UnitPowerPercent handles
	-- every power-type resource (primary, secondary, mana custom bar); UnitHealthPercent
	-- handles the health bar. Both evaluate the curve against the secret value natively.
	local function EvaluateCurve(curve)
		if curve == nil then
			return nil
		end
		if targetInfo.key == "health" then
			return UnitHealthPercent("player", true, curve)
		elseif type(targetInfo.resourceType) == "number" then
			-- Only real PowerType enums (numbers) can be evaluated by UnitPowerPercent. String
			-- sentinels like "CUSTOM" (Devourer Soul Fragments/Collapsing Star) have no power API,
			-- so return nil and let the caller fall back to the static under color.
			return UnitPowerPercent("player", targetInfo.resourceType, true, curve)
		end
		return nil
	end

	local colorResult = EvaluateCurve(thresholdCurve)
	if colorResult == nil then
		return false
	end

	TRB.Functions.Color:SetThresholdColorFromCurve(threshold, colorResult)

	-- Icon desaturation mimic: the icon vertex color follows a gray->white curve so the
	-- icon "lights up" at exactly the same point the line flips to the over color.
	if threshold.icon ~= nil and threshold.icon.texture ~= nil then
		local effectiveDesaturated = settings.thresholds.icons.desaturated
		if thresholdOverrides and thresholdOverrides.icon and thresholdOverrides.icon.enabled and thresholdOverrides.icon.desaturated ~= nil then
			effectiveDesaturated = thresholdOverrides.icon.desaturated
		end

		-- Never use SetDesaturated for curve-driven thresholds; it can't read secret values.
		threshold.icon.texture:SetDesaturated(false)
		if effectiveDesaturated == true and iconCurve ~= nil then
			local iconColorResult = EvaluateCurve(iconCurve)
			if iconColorResult ~= nil then
				TRB.Functions.Color:SetIconVertexColorFromCurve(threshold, iconColorResult)
			else
				threshold.icon.texture:SetVertexColor(1, 1, 1, 1)
			end
		else
			threshold.icon.texture:SetVertexColor(1, 1, 1, 1)
		end
	end

	return true
end

---Builds a lightweight spell-like shim so custom threshold lines can be rendered
---through the SAME canonical threshold functions (`AdjustThresholdDisplay` /
---`SetThresholdIcon` / `ResolveThresholdCurveColors`) that spell thresholds use. This
---guarantees identical over/under color, icon, desaturation, and frame-level behavior
---with zero parallel logic.
---@param customThreshold TRB.Classes.Settings.CustomThresholdLine
---@param settingKey string Dictionary key (e.g. "custom:<guid>") used for override lookup
---@return table
local function BuildCustomThresholdSpellShim(customThreshold, settingKey)
	return {
		settingKey = settingKey,
		texture = TRB.Functions.Threshold:GetCustomThresholdIconTexture(customThreshold),
		hasCooldown = false,
		isSnowflake = false,
		GetIsSpellInRange = function() return true end,
	}
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param targetInfo table
---@param guid string
---@return Frame
function TRB.Functions.Threshold:GetOrCreateCustomThresholdFrame(settings, targetInfo, guid)
	TRB.Frames.customThresholds = TRB.Frames.customThresholds or {}
	local frameKey = targetInfo.key .. "_" .. guid
	local threshold = TRB.Frames.customThresholds[frameKey]
	-- Only reset the line when the frame is first created or re-parented (target bar
	-- changed). Resetting every frame is wrong: ResetCustomThresholdLine forces the icon
	-- back to GLOBAL size/position/border via SetThresholdIconSizeAndPosition without
	-- touching the cache, so the cache-driven SetThresholdIcon then skips re-applying the
	-- per-threshold icon overrides (cache already equals the override) and the icon is left
	-- stuck at the global values. The canonical threshold path likewise only resets lines
	-- during RedrawThresholdLines, never on per-frame updates.
	local needsReset = false
	if threshold == nil then
		threshold = CreateFrame("Frame", nil, targetInfo.parentFrame, "BackdropTemplate")
		TRB.Frames.customThresholds[frameKey] = threshold
		needsReset = true
	elseif threshold:GetParent() ~= targetInfo.parentFrame then
		threshold:SetParent(targetInfo.parentFrame)
		threshold:ClearAllPoints()
		needsReset = true
		-- The reposition cache compares value/maxResource/effectiveSize/fillDirection to skip
		-- redundant SetPoint calls. When the line moves to a different node frame (e.g. a
		-- node-mapped value crossing a node boundary) those numbers can match the previous
		-- node, leaving the freshly re-parented line unanchored. Drop the cache entry so the
		-- next RepositionThresholdCustomBar re-anchors against the new parent.
		if TRB.Data.cache and TRB.Data.cache.values and TRB.Data.cache.values.threshold then
			TRB.Data.cache.values.threshold[frameKey] = nil
		end
	end

	if needsReset then
		TRB.Functions.Threshold:ResetCustomThresholdLine(threshold, settings, targetInfo)
	end
	return threshold
end

---@param activeFrameKeys table<string, boolean>
function TRB.Functions.Threshold:HideInactiveCustomThresholdFrames(activeFrameKeys)
	if TRB.Frames.customThresholds == nil then
		return
	end

	for frameKey, threshold in pairs(TRB.Frames.customThresholds) do
		if not activeFrameKeys[frameKey] and threshold ~= nil then
			threshold:Hide()
			if threshold.icon then
				threshold.icon:Hide()
				-- Keep the icon-shown cache in sync with the manual Hide above. Without this,
				-- SetThresholdIcon sees a stale `iconShown == true` when the threshold is
				-- re-enabled and skips re-showing the icon until the cache is invalidated by a
				-- manual icon toggle.
				local cache = TRB.Data.cache.values.threshold[frameKey]
				if cache ~= nil then
					cache.iconShown = false
				end
			end
		end
	end
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>?
function TRB.Functions.Threshold:UpdateCustomThresholdLines(settings, barGroups)
	local activeFrameKeys = {}
	if settings == nil or settings.thresholds == nil or settings.thresholds.customThresholds == nil or barGroups == nil then
		TRB.Functions.Threshold:HideInactiveCustomThresholdFrames(activeFrameKeys)
		return
	end

	for guid, customThreshold in pairs(settings.thresholds.customThresholds) do
		local customThresholdKey = TRB.Functions.Settings:GetCustomThresholdDictionaryKey(customThreshold.guid or guid)
		local thresholdOverrides = settings.thresholds.thresholdDictionary and settings.thresholds.thresholdDictionary[customThresholdKey]
		if thresholdOverrides ~= nil and thresholdOverrides.enabled == true then
			local targetInfo = TRB.Functions.Threshold:GetCustomThresholdTargetInfo(settings, barGroups, customThreshold.barTarget or "primary")
			-- contextActive == false: a context sub-target whose game-state context isn't live
			-- right now (e.g. Soul Fragments threshold while Collapsing Star is active). Skip it so
			-- HideInactiveCustomThresholdFrames hides the line until its context returns.
			if targetInfo ~= nil and targetInfo.parentFrame ~= nil and targetInfo.contextActive ~= false then
				local frameKey = targetInfo.key .. "_" .. customThresholdKey
				local configuredValue = customThreshold.value
				local minValue = targetInfo.minValue or 0
				local maxValue = targetInfo.maxValue or 100
				-- Offset-mode lines store an offset from max; resolve to an absolute value before positioning.
				local effectiveValue = TRB.Functions.Threshold:GetEffectiveCustomThresholdValue(customThreshold, maxValue)
				local thresholdValue = math.max(minValue, effectiveValue)
				local inRange = thresholdValue <= maxValue
				-- Compressed Maelstrom Weapon: base (1-5) and overflow (6-10) lines share the same nodes,
				-- so only the active layer is shown - base below 6 stacks, overflow at 6+.
				if targetInfo.compressedOverlap then
					local isOverflowLine = thresholdValue > targetInfo.compressedSplit
					if isOverflowLine ~= targetInfo.compressedActive then
						inRange = false
					end
				end
				customThreshold.value = thresholdValue

				-- Position value/frame default to the bar-wide value across the whole target
				-- frame. For node-mapped bars (combo points, soul shards, amalgamation sub-types)
				-- the line is drawn inside the specific node it falls within: an integer value
				-- fills to the END of that node, a fractional value lands partway through the
				-- NEXT node (e.g. 3.5 -> halfway through node 4). The over/under coloring still
				-- uses the bar-wide value/max via the ColorCurve below, so only positioning is
				-- remapped here.
				local positionValue = thresholdValue
				local positionMax = maxValue
				if targetInfo.isNodeMapped and targetInfo.nodes ~= nil and targetInfo.nodeCount > 0 then
					local n = targetInfo.nodeCount
					-- Map the value onto node-run units (0..n). For node-count bars maxValue == n,
					-- so this is the identity; for scaled bars it converts to the node fill fraction.
					local mappedValue = thresholdValue
					if targetInfo.compressedOverlap then
						-- Compressed Maelstrom Weapon: fold the 6-10 overflow layer back onto the 1-5
						-- strip (split == n nodes), so value 6 -> node 1 ... value 10 -> node 5.
						mappedValue = thresholdValue > targetInfo.compressedSplit
							and (thresholdValue - targetInfo.compressedSplit) or thresholdValue
					elseif maxValue > 0 then
						mappedValue = (thresholdValue / maxValue) * n
					end
					local floorV = math.floor(mappedValue)
					local nodeIndex, fraction
					if mappedValue <= 0 then
						nodeIndex, fraction = 1, 0
					elseif mappedValue >= n then
						nodeIndex, fraction = n, 1
					elseif mappedValue == floorV then
						nodeIndex, fraction = floorV, 1
					else
						nodeIndex, fraction = floorV + 1, mappedValue - floorV
					end
					local nodeFrame = targetInfo.nodes[nodeIndex]
					if nodeFrame ~= nil then
						targetInfo.parentFrame = nodeFrame
						positionValue = fraction
						positionMax = 1
					end
				end

				if inRange then
					activeFrameKeys[frameKey] = true
				end
				local threshold = TRB.Functions.Threshold:GetOrCreateCustomThresholdFrame(settings, targetInfo, customThresholdKey)

				local lineThickness = settings.thresholds.properties.width
				local overlapBorder = settings.thresholds.properties.overlapBorder
				if thresholdOverrides.line and thresholdOverrides.line.enabled then
					lineThickness = thresholdOverrides.line.width or lineThickness
					if thresholdOverrides.line.overlapBorder ~= nil then
						overlapBorder = thresholdOverrides.line.overlapBorder
					end
				end

				-- Render the line through the SAME canonical threshold functions used by
				-- spell thresholds. The over/under coloring uses the ColorCurve mechanism,
				-- identical to thresholds that lack an easy usable check (e.g. Warrior
				-- "Execute (maximum)"): a Step ColorCurve is built at the threshold's value
				-- percentage, and the under/over decision is made INSIDE UnitPowerPercent /
				-- UnitHealthPercent against the SECRET resource. Lua never compares the
				-- secret, so the line color and the icon desaturation always agree.
				local spellShim = BuildCustomThresholdSpellShim(customThreshold, customThresholdKey)

				-- Resolve the effective under/over colors (bakes in per-threshold overrides),
				-- then build the value-based line curve (under->over) and the icon
				-- desaturation curve (gray->white) on the same value/max range.
				local underColor, overColor = TRB.Functions.Threshold:ResolveThresholdCurveColors(spellShim, settings)
				local thresholdCurve = TRB.Functions.Color:BuildThresholdValueCurve(thresholdValue, maxValue, underColor, overColor)
				local iconCurve = TRB.Functions.Color:BuildThresholdValueCurve(thresholdValue, maxValue, "FF808080", "FFFFFFFF")

				local curveApplied = TRB.Functions.Threshold:ApplyCustomThresholdCurveColor(
					threshold, targetInfo, thresholdCurve, iconCurve, settings, thresholdOverrides
				)

				-- When the curve applied (health/power-type bars), pass thresholdColor=nil so
				-- AdjustThresholdDisplay leaves the curve-driven line color and icon desaturation
				-- untouched. Otherwise this bar has no secret-safe percent API: when its live count
				-- is a plain Lua number (charge/stack custom bars such as Angelic Feather), decide
				-- over/under with a direct comparison and let AdjustThresholdDisplay apply the
				-- base/override colors and icon desaturation via the frame level, exactly like a
				-- normal spell threshold. Without this the line was stuck on the "under" color.
				-- Bars with no comparable value at all still fall back to the static under color.
				local thresholdColor = nil
				local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
				if not curveApplied then
					if targetInfo.usesSecretValue then
						-- Forced-static secret bars (Soul Fragments, Bone Shield, Fire Blast Charges)
						-- have no over/under trigger: the count is secret in combat but plain out of
						-- combat, which would otherwise flip the icon to desaturated "under" on load.
						-- Always render as "over" (frameLevel stays thresholdOver) so the icon is never
						-- desaturated; the static color is applied via colorMode in AdjustThresholdDisplay.
						thresholdColor = settings.colors.threshold.over.color
					elseif targetInfo.supportsValueComparison then
						local liveValue = GetPlainNumber(targetInfo.currentValue, 0)
						local isOver = liveValue >= thresholdValue
						frameLevel = isOver and TRB.Data.constants.frameLevels.thresholdOver
							or TRB.Data.constants.frameLevels.thresholdUnder
						thresholdColor = isOver and settings.colors.threshold.over.color
							or settings.colors.threshold.under.color
					else
						thresholdColor = underColor
					end
				end

				-- hasCooldown=false short-circuits all snapshot.cooldown access in
				-- AdjustThresholdDisplay, so an empty snapshot is safe here.
---@diagnostic disable-next-line: missing-fields
				local emptySnapshot = {} --[[@as TRB.Classes.Snapshot]]
				local showThreshold = TRB.Functions.Threshold:AdjustThresholdDisplay(
					spellShim,
					frameKey,
					threshold,
					inRange,
					frameLevel,
					0,
					thresholdColor,
					emptySnapshot,
					settings,
					thresholdOverrides
				)
				TRB.Functions.Threshold:RepositionThresholdCustomBar(
					frameKey,
					threshold,
					showThreshold,
					targetInfo.parentFrame,
					positionValue,
					positionMax,
					targetInfo.parentFrame:GetWidth(),
					targetInfo.border,
					true,
					targetInfo.fillDirection,
					lineThickness,
					overlapBorder
				)
				customThreshold.value = configuredValue
			end
		end
	end

	TRB.Functions.Threshold:HideInactiveCustomThresholdFrames(activeFrameKeys)
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
	TRB.Functions.Threshold:UpdateCustomThresholdLines(settings, barGroups)

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
