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

---Default dimensions of the Eclipse bar: four nodes above the Mana bar, matching its width.
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultDruidEclipseBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.width = classic and 25 or 30
	return dims
end

---Default Eclipse bar colors: a darker blue per charge.
---@return table
function TRB.Functions.Settings:DefaultDruidEclipseBarColors()
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
		},
	}
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "eclipse",
		displayName = L["ResourceDruidEclipse"],
		isMultiNode = true,
		maxNodes = 4,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "eclipse",
		nodeColors = {
			{ key = "charge1", displayName = L["ForeverDruidEclipse1"], colorLabel = L["ForeverDruidEclipse1"] },
			{ key = "charge2", displayName = L["ForeverDruidEclipse2"], colorLabel = L["ForeverDruidEclipse2"] },
			{ key = "charge3", displayName = L["ForeverDruidEclipse3"], colorLabel = L["ForeverDruidEclipse3"] },
			{ key = "charge4", displayName = L["ForeverDruidEclipse4"], colorLabel = L["ForeverDruidEclipse4"] },
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultDruidEclipseBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultDruidEclipseBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

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
			-- The runtime ranges the node 0..UnitPowerMax, capped by the override, and writes the (secret) live power into it.
			minMaxMode = "custom",
			hasSpacing = false,
			hasThresholds = true,
			powerType = form.powerType,
			colorCurveType = nil,
			visibilityKey = form.key,
			-- thresholdMax only sizes the slider; lines place against the live max, capped by the bar's override.
			thresholdScaleFromLiveMax = true,
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
