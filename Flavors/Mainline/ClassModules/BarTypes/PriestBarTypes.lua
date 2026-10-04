local _, TRB = ...
local L = TRB.Localization

-- Priest bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Priest options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Holy Words bar dimensions (anchored above primary bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultHolyWordsBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			collapseBorderWidth = false,
			fillDirection = "leftRight",
			growthDirection = "leftRight",
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "primary",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
				matchHeight = false,
			},
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		fillDirection = "leftRight",
		growthDirection = "leftRight",
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "primary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Holy Words bar colors
---@return table
function TRB.Functions.Settings:DefaultHolyWordsBarColors()
	return {
		border = { color = "FF000099" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		nodeOrder = { "holyWordSerenity", "holyWordSanctify", "holyWordChastise" },
		nodeColors = {
			holyWordSerenity = { color = "FF00DDDD", color2 = "FF00DDDD", gradientDirection = "disabled", enabled = true },
			holyWordSanctify = { color = "FFFFDD22", color2 = "FFFFDD22", gradientDirection = "disabled", enabled = true },
			holyWordChastise = { color = "FFFF8080", color2 = "FFFF8080", gradientDirection = "disabled", enabled = true }
		},
	}
end

---Gets default Lightweaver bar dimensions (anchored above Holy Words bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultLightweaverBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			collapseBorderWidth = false,
			fillDirection = "leftRight",
			growthDirection = "leftRight",
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "holyWords",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
				matchHeight = false,
			},
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		fillDirection = "leftRight",
		growthDirection = "leftRight",
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "holyWords",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Lightweaver bar colors (progressively darker blue per stack)
---@return table
function TRB.Functions.Settings:DefaultLightweaverBarColors()
	return {
		border = { color = "FF4466CC" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		sameColor = false,
		nodeColors = {
			charge1 = { color = "FF88CCFF", color2 = "FF88CCFF", gradientDirection = "disabled" },
			charge2 = { color = "FF55AAFF", color2 = "FF55AAFF", gradientDirection = "disabled" },
			charge3 = { color = "FF3388EE", color2 = "FF3388EE", gradientDirection = "disabled" },
			charge4 = { color = "FF1166CC", color2 = "FF1166CC", gradientDirection = "disabled" },
		}
	}
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Holy Words bar (Holy Priest)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "holyWords",
		displayName = L["ResourcePriestHolyWords"],
		isMultiNode = true,
		isAmalgamation = true, -- Distinct Holy Word types per node; custom thresholds expose per-type sub-targets
		maxNodes = 5, -- Serenity x2 + Sanctify x2 + Chastise x1
		hasSameColor = false,
		minMaxMode = "discrete", -- 0-1 per node (cooldown progress)
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil, -- Simple colors per Holy Word
		visibilityKey = "holyWords",
		hasOrdering = true,
		orderUpTooltip = L["NodeOrderMoveUpTooltip"],
		orderDownTooltip = L["NodeOrderMoveDownTooltip"],
		nodeColors = {
			{ key = "holyWordSerenity", displayName = L["HolyWordSerenityBarEnable"], colorLabel = L["HolyWordSerenityBarColor"], tooltip = L["HolyWordSerenityBarEnableTooltip"], hasEnabled = true, thresholdMax = 60, thresholdDecimals = 1 },
			{ key = "holyWordSanctify", displayName = L["HolyWordSanctifyBarEnable"], colorLabel = L["HolyWordSanctifyBarColor"], tooltip = L["HolyWordSanctifyBarEnableTooltip"], hasEnabled = true, thresholdMax = 60, thresholdDecimals = 1 },
			{ key = "holyWordChastise", displayName = L["HolyWordChastiseBarEnable"], colorLabel = L["HolyWordChastiseBarColor"], tooltip = L["HolyWordChastiseBarEnableTooltip"], hasEnabled = true, thresholdMax = 60, thresholdDecimals = 1 }
		},
		onChangeCallback = function()
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
		end,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultHolyWordsBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultHolyWordsBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "lightweaver",
		displayName = L["ResourcePriestLightweaver"],
		isMultiNode = true,
		maxNodes = 4,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		hasSameColor = false,
		colorCurveType = nil,
		visibilityKey = "lightweaver",
		nodeColors = {
			{ key = "charge1", displayName = L["LightweaverCharge1"], colorLabel = L["LightweaverCharge1"] },
			{ key = "charge2", displayName = L["LightweaverCharge2"], colorLabel = L["LightweaverCharge2"] },
			{ key = "charge3", displayName = L["LightweaverCharge3"], colorLabel = L["LightweaverCharge3"] },
			{ key = "charge4", displayName = L["LightweaverCharge4"], colorLabel = L["LightweaverCharge4"] },
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultLightweaverBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultLightweaverBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
