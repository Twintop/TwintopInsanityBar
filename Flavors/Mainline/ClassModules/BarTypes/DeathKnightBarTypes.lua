local _, TRB = ...
local L = TRB.Localization

-- DeathKnight bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the DeathKnight options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Bone Shield bar dimensions (Blood Death Knight, anchored above runes)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultBoneShieldBarDimensions(classic)
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
				barKey = "secondary",
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
			barKey = "secondary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Bone Shield bar colors (Blood Death Knight)
---@return table
function TRB.Functions.Settings:DefaultBoneShieldBarColors()
	return {
		bar = { color = "FF8DD48D", color2 = "FF8DD48D", gradientDirection = "disabled" },
		ossuary = { color = "FFB8FFB8", color2 = "FFB8FFB8", gradientDirection = "disabled", enabled = true },
		ossuaryThreshold = { color = "FF404040", color2 = "FF404040", gradientDirection = "disabled", enabled = true },
		border = { color = "FF205E20" },
		background = { color = "66000000" }
	}
end

---Gets default Coagulating Blood bar dimensions (Blood Death Knight, anchored above the Bone Shield bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultCoagulatingBloodBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.anchor.barKey = "boneShield"
	dims.anchor.anchorPoint = "TOP"
	dims.anchor.attachPoint = "BOTTOM"
	dims.maxResource = {
		enabled = false,
		value = TRB.Data.maxResource.deathknight.blood.coagulatingBlood
	}
	return dims
end

---Gets default Coagulating Blood bar colors (Blood Death Knight)
---@return table
function TRB.Functions.Settings:DefaultCoagulatingBloodBarColors()
	return self:DefaultCustomBarColors("FFAA0000", "FF550000", "66000000")
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Bone Shield bar (Blood Death Knight)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "boneShield",
		displayName = L["ResourceBoneShield"],
		isMultiNode = true,
		maxNodes = 12,
		hasSameColor = false,
		minMaxMode = "stepped",
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "boneShield",
		-- Bone Shield stacks come from C_Spell.GetSpellCastCount (secret in combat), so the count
		-- cannot be compared or curve-evaluated in Lua. Custom thresholds on it are static-only.
		usesSecretValue = true,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultBoneShieldBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultBoneShieldBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	-- Coagulating Blood bar (Blood Death Knight)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "coagulatingBlood",
		displayName = L["ResourceCoagulatingBlood"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		-- One application is one percent, so the single node fills against a flat 0-100 scale.
		minMaxMode = "percentage",
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "coagulatingBlood",
		-- Stack count is secret, so custom thresholds on it are static-only.
		usesSecretValue = true,
		-- Fed entirely by the Cooldown Manager's item for Coagulating Blood.
		cdm = TRB.Data.constants.cdmDependency.REQUIRED,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultCoagulatingBloodBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultCoagulatingBloodBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
