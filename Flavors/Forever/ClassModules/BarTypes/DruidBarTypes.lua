local _, TRB = ...
local L = TRB.Localization

-- Druid bar types (World of Warcraft: Forever): the Rage and Energy bars the shapeshift forms show. Loads after
-- Core (TRB.Functions.Settings must exist) and before the class runtime and options modules.

---Default dimensions of a form resource bar: full width above the Mana bar, where the form's resource replaces it,
---at the primary bar's height and border since it stands in for that bar.
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultDruidFormBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	local primary = self:DefaultBarDimensions(classic)
	dims.height = primary.height
	dims.border = primary.border
	dims.anchor.barKey = "primary"
	return dims
end

---Default Rage bar colors.
---@return table
function TRB.Functions.Settings:DefaultDruidRageBarColors()
	return self:DefaultCustomBarColors("FFFF0000", "FF990000", "66000000")
end

---Default Energy bar colors.
---@return table
function TRB.Functions.Settings:DefaultDruidEnergyBarColors()
	return self:DefaultCustomBarColors("FFFFFF00", "FFFFD300", "66000000")
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	for _, form in ipairs({
		{ key = "rage", nameKey = "ResourceRage", powerType = Enum.PowerType.Rage, colorsFunc = "DefaultDruidRageBarColors" },
		{ key = "energy", nameKey = "ResourceEnergy", powerType = Enum.PowerType.Energy, colorsFunc = "DefaultDruidEnergyBarColors" },
	}) do
		registry:Register(TRB.Classes.BarTypeDefinition:New({
			key = form.key,
			displayName = L[form.nameKey],
			isMultiNode = false,
			maxNodes = 1,
			hasSameColor = false,
			-- The runtime ranges the node 0..UnitPowerMax and writes the (secret) live power into it.
			minMaxMode = "custom",
			hasSpacing = false,
			hasThresholds = true,
			powerType = form.powerType,
			colorCurveType = nil,
			visibilityKey = form.key,
			thresholdMax = 100,
			thresholdDecimals = 0,
			defaultDimensionsFunc = function(classic)
				return TRB.Functions.Settings:DefaultDruidFormBarDimensions(classic)
			end,
			defaultColorsFunc = function()
				return TRB.Functions.Settings[form.colorsFunc](TRB.Functions.Settings)
			end,
			defaultTexturesFunc = function()
				return TRB.Functions.Settings:DefaultCustomBarTextures()
			end
		}))
	end
end
