local _, TRB = ...
local L = TRB.Localization

-- Druid bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Druid options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Ironfur bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultIronfurBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.anchor.barKey = "primary"
	return dims
end

---Gets default Ironfur bar colors (steel bar, dark steel border) plus the per-application line color
---@return table
function TRB.Functions.Settings:DefaultIronfurBarColors()
	local colors = self:DefaultCustomBarColors("FF8899AA", "FF445566", "66000000")
	-- The newest application's line doubles as the fill's cap, so this bar offers no end cap.
	colors.endCap = nil
	colors.stackLine = { color = "FFFFFFFF" }
	return colors
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Ironfur bar (Guardian Druid)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "ironfur",
		displayName = L["ResourceDruidIronfur"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		-- Scale is the longest live application's own duration, resolved per cast by the class module.
		minMaxMode = "custom",
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "ironfur",
		-- Fill is a DurationObject the client drains, so the Smooth setting has nothing to act on.
		timerDrivenFill = true,
		-- Custom threshold lines read in seconds; 12 is the longest talented application.
		thresholdMax = 12,
		thresholdDecimals = 1,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultIronfurBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultIronfurBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
