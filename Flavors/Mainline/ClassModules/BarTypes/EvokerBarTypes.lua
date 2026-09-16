local _, TRB = ...
local L = TRB.Localization

-- Evoker bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Evoker options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Ebon Might bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultEbonMightBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.relativeTo = "BOTTOM"
	dims.relativeToName = L["PositionBelowMiddle"]
	dims.anchor.barKey = "health"
	dims.anchor.anchorPoint = "BOTTOM"
	dims.anchor.attachPoint = "TOP"
	return dims
end

---Gets default Ebon Might bar colors (orange bar, dark orange border)
---@return table
function TRB.Functions.Settings:DefaultEbonMightBarColors()
	local colors = self:DefaultCustomBarColors("FFFF9900", "FFCC7700", "66000000")
	colors.endingSoon = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled", enabled = true }
	colors.wontExtend = { color = "FF550000", color2 = "FF550000", gradientDirection = "disabled", enabled = true }
	return colors
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Ebon Might bar (Augmentation Evoker)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "ebonMight",
		displayName = L["ResourceEvokerEbonMight"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		minMaxMode = "custom",
		hasSpacing = false,
		hasThresholds = false,
		-- Duration and remaining both come from the Cooldown Manager as secrets, so there is no
		-- plain max to scale a threshold line against.
		hasCustomThresholds = false,
		colorCurveType = nil, -- Simple bar color
		visibilityKey = "ebonMight",
		-- Fed entirely by the Cooldown Manager's item for Ebon Might.
		cdm = TRB.Data.constants.cdmDependency.REQUIRED,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultEbonMightBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultEbonMightBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
