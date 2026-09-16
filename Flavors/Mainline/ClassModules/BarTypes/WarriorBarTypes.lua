local _, TRB = ...
local L = TRB.Localization

-- Warrior bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Warrior options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Enrage bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultEnrageBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.anchor.barKey = "secondary"
	return dims
end

---Gets default Enrage bar colors (light orange bar, dark orange border)
---@return table
function TRB.Functions.Settings:DefaultEnrageBarColors()
	return self:DefaultCustomBarColors("FFFFCC55", "FFAA7711", "66000000")
end

---Gets default Warrior Defensives bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultDefensivesBarDimensions(classic)
	-- Defensives is a 2-node bar (Ignore Pain + Shield Block)
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

---Gets default Warrior Defensives bar colors
---@return table
function TRB.Functions.Settings:DefaultDefensivesBarColors()
	return {
		border = { color = "FFC21807" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		nodeOrder = { "ignorePain", "ignorePainAbsorb", "shieldBlock" },
		nodeColors = {
			ignorePain = { color = "FFFFD000", color2 = "FFFFD000", gradientDirection = "disabled", enabled = true },
			ignorePainAbsorb = { color = "FFFF9800", color2 = "FFFF9800", gradientDirection = "disabled", enabled = true },
			shieldBlock = { color = "FF0099FF", color2 = "FF0099FF", gradientDirection = "disabled", enabled = true }
		}
	}
end

---Gets default Whirlwind stacks bar colors (Fury Warrior)
---@return table
function TRB.Functions.Settings:DefaultWhirlwindBarColors()
	return {
		border = { color = "FFFFD300" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		sameColor = false,
		nodeColors = {
			charge1 = { color = "FFFFFFAA", color2 = "FFFFFFAA", gradientDirection = "disabled" },
			charge2 = { color = "FFFFFF00", color2 = "FFFFFF00", gradientDirection = "disabled" },
			charge3 = { color = "FFFF9900", color2 = "FFFF9900", gradientDirection = "disabled" },
			charge4 = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled" },
		},
		zeroStackBackground = {
			color = "B3FF5E5E",
			enabled = true
		}
	}
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Defensives bar (Protection Warrior)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "defensives",
		displayName = L["ResourceWarriorDefensives"],
		isMultiNode = true,
		isAmalgamation = true, -- Distinct buff types per node; custom thresholds expose per-type sub-targets
		maxNodes = 3, -- Ignore Pain (Time) + Ignore Pain (Absorb) + Shield Block
		endCapMode = "all", -- Independent buff timers per node; every active node gets a cap
		hasSameColor = false,
		minMaxMode = "discrete", -- 0-1 per node (buff active or not)
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil, -- Simple colors per buff type
		visibilityKey = "defensives",
		hasOrdering = true,
		orderUpTooltip = L["NodeOrderMoveUpTooltip"],
		orderDownTooltip = L["NodeOrderMoveDownTooltip"],
		nodeColors = {
			{ key = "ignorePain", displayName = L["IgnorePainTimeBarEnable"], colorLabel = L["IgnorePainTime"], tooltip = L["IgnorePainTimeBarEnableTooltip"], hasEnabled = true, thresholdMax = 12, thresholdDecimals = 1 },
			-- Absorb alone: the timer node beside it is snapshot-driven.
			{ key = "ignorePainAbsorb", displayName = L["IgnorePainAbsorbBarEnable"], colorLabel = L["IgnorePainAbsorb"], tooltip = L["IgnorePainAbsorbBarEnableTooltip"], hasEnabled = true, thresholdMax = 100, thresholdDecimals = 1, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
			{ key = "shieldBlock", displayName = L["ShieldBlockBarEnable"], colorLabel = L["ShieldBlock"], tooltip = L["ShieldBlockBarEnableTooltip"], hasEnabled = true, thresholdMax = 8, thresholdDecimals = 1 }
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultDefensivesBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultDefensivesBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	-- Whirlwind stacks bar (Fury Warrior)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "whirlwind",
		displayName = L["ResourceWarriorWhirlwind"],
		isMultiNode = true,
		maxNodes = 4,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		hasSameColor = false,
		colorCurveType = nil,
		nodeColors = {
			{ key = "charge1", displayName = L["WhirlwindCharge1"], colorLabel = L["WhirlwindColorPickerBase"] },
			{ key = "charge2", displayName = L["WhirlwindCharge2"], colorLabel = L["WhirlwindColorPickerSecondary"] },
			{ key = "charge3", displayName = L["WhirlwindCharge3"], colorLabel = L["WhirlwindColorPickerPenultimate"] },
			{ key = "charge4", displayName = L["WhirlwindCharge4"], colorLabel = L["WhirlwindColorPickerFinal"] },
		},
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultWhirlwindBarColors()
		end,
	}))

	-- Enrage bar (Fury Warrior)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "enrage",
		displayName = L["ResourceWarriorEnrage"],
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
		visibilityKey = "enrage",
		-- Fed entirely by the Cooldown Manager's item for Enrage.
		cdm = TRB.Data.constants.cdmDependency.REQUIRED,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultEnrageBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultEnrageBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
