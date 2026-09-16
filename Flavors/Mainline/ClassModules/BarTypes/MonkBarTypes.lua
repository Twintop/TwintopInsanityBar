local _, TRB = ...
local L = TRB.Localization

-- Monk bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Monk options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Stagger bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultStaggerBarDimensions(classic)
	return self:DefaultCustomBarDimensions(classic)
end

---Gets default Stagger bar colors (green -> yellow -> red as stagger increases)
---@return table
function TRB.Functions.Settings:DefaultStaggerBarColors()
	return {
		border = { color = "FF000066" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		type = "step",
		low = { color = "FF00FF00", threshold = 0.0 },
		medium = { color = "FFFFFF00", threshold = 0.30 },
		heavy = { color = "FFFF0000", threshold = 0.60 }
	}
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Stagger bar (Brewmaster Monk)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "stagger",
		displayName = L["ResourceStagger"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		minMaxMode = "percentage", -- 0-100% of max health
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = "step", -- Green -> Yellow -> Red based on stagger level
		visibilityKey = "stagger",
		maxThresholdPercent = 1000, -- Allow thresholds up to 1000% (matches max stagger scale)
		-- Threshold color configuration - pass resolved localized strings, NOT keys
		thresholdLevels = {
			{ key = "low", colorLabel = L["StaggerBarColorLight"] },
			{ key = "medium", colorLabel = L["StaggerBarColorMedium"], sliderLabel = L["StaggerBarThresholdMedium"], sliderTooltip = L["StaggerBarThresholdMediumTooltip"] },
			{ key = "heavy", colorLabel = L["StaggerBarColorHeavy"], sliderLabel = L["StaggerBarThresholdHeavy"], sliderTooltip = L["StaggerBarThresholdHeavyTooltip"] },
			{ key = "extreme", colorLabel = L["StaggerBarColorExtreme"], sliderLabel = L["StaggerBarThresholdExtreme"], sliderTooltip = L["StaggerBarThresholdExtremeTooltip"] }
		},
		gradientTooltipNote = L["GradientStaggerTooltip"],
		colorTypeLabel = L["StaggerBarColorType"],
		colorTypeStepLabel = L["StaggerBarColorTypeStep"],
		colorTypeLinearLabel = L["StaggerBarColorTypeLinear"],
		colorTypeNoneLabel = L["StaggerBarColorTypeNone"],
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultStaggerBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultStaggerBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
