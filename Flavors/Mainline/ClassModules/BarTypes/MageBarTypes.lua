local _, TRB = ...
local L = TRB.Localization

-- Mage bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Mage options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets default Fire Blast Charges bar colors (Fire Mage)
---@return table
function TRB.Functions.Settings:DefaultFireBlastChargesBarColors()
	return {
		border = { color = "FFFF7878" },
		background = { color = "66000000" },
		regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
		sameColor = false,
		nodeColors = {
			charge1 = { color = "FFFF8800", color2 = "FFFF8800", gradientDirection = "disabled" },
			charge2 = { color = "FFFF6600", color2 = "FFFF6600", gradientDirection = "disabled" },
			charge3 = { color = "FFFF4400", color2 = "FFFF4400", gradientDirection = "disabled" },
		},
	}
end

---Gets default Arcane Salvo bar dimensions (Arcane Mage, anchored above the Arcane Charges bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultArcaneSalvoBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.anchor.barKey = "secondary"
	dims.anchor.anchorPoint = "TOP"
	dims.anchor.attachPoint = "BOTTOM"
	return dims
end

---Gets default Arcane Salvo bar colors (Arcane Mage), including the gated range slots. Slot 1 is the
---base `bar` entry at 0; slots 2-5 recolor the whole fill from their own start value upward.
---@return table
function TRB.Functions.Settings:DefaultArcaneSalvoBarColors()
	local colors = self:DefaultCustomBarColors("FF5C4FCF", "FF2A2470", "66000000")
	colors.ranges = {
		-- 12: Arcane Barrage becomes correct with a Clearcasting proc banked behind it.
		[2] = { enabled = true, value = 12, color = "FFE8C33A", color2 = "FFE8C33A", gradientDirection = "disabled" },
		-- 25: capped, so the next Barrage is mandatory or stacks are wasted.
		[3] = { enabled = true, value = 25, color = "FFD13B3B", color2 = "FFD13B3B", gradientDirection = "disabled" },
		[4] = { enabled = false, value = 18, color = "FFE8853A", color2 = "FFE8853A", gradientDirection = "disabled" },
		[5] = { enabled = false, value = 22, color = "FFE85C3A", color2 = "FFE85C3A", gradientDirection = "disabled" },
	}
	return colors
end

---Gets default Shatter bar dimensions (Frost Mage, anchored above the Icicles bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultShatterBarDimensions(classic)
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

---Gets default Shatter bar colors (Frost Mage), including the custom indicator stacks. Each indicator
---recolors the single stack it names, gated by the hero talent tree its mode selects.
---@return table
function TRB.Functions.Settings:DefaultShatterBarColors()
	return {
		bar = { color = "FFBFE3FF", color2 = "FFBFE3FF", gradientDirection = "disabled" },
		threshold = { color = "FF000080", color2 = "FF000080", gradientDirection = "disabled", enabled = true },
		customIndicators = {
			-- 12: where Frostfire wants the Ice Lance, regardless of what the threshold marks say.
			[1] = { mode = "frostfire", value = 12, color = "FF3AE85C", color2 = "FF3AE85C", gradientDirection = "disabled" },
			[2] = { mode = "disabled", value = 6, color = "FFE8853A", color2 = "FFE8853A", gradientDirection = "disabled" },
		},
		border = { color = "FF12336B" },
		background = { color = "66000000" }
	}
end

---Returns default bar text for Fire Mage Fire Blast charge nodes.
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultFireBlastChargeBarTextSettings()
	-- Anchored to the recharging charge, which slides to whichever node is refilling. It is shown
	-- only while one is, so the text needs no condition of its own.
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = "FB",
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "[$fireBlastTime]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize = 14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "FireBlastCharge_Recharging",
				relativeToFrameName = L["MageFireFireBlastChargeRecharging"],
			}
		},
	}

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Fire Blast Charges bar (Fire Mage)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "fireBlastCharges",
		displayName = L["MageFireBlastCharges"],
		isMultiNode = true,
		maxNodes = 3,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		hasSameColor = false,
		colorCurveType = nil,
		-- Fire Blast charges come from the spell's cooldown charge count (secret in combat), so the
		-- count cannot be compared or curve-evaluated in Lua. Custom thresholds on it are static-only.
		usesSecretValue = true,
		nodeColors = {
			{ key = "charge1", displayName = L["MageFireFireBlastCharge1"], colorLabel = L["MageFireFireBlastColorPickerCharge1"] },
			{ key = "charge2", displayName = L["MageFireFireBlastCharge2"], colorLabel = L["MageFireFireBlastColorPickerCharge2"] },
			{ key = "charge3", displayName = L["MageFireFireBlastCharge3"], colorLabel = L["MageFireFireBlastColorPickerCharge3"] },
		},
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultFireBlastChargesBarColors()
		end,
	}))

	-- Shatter bar (Frost Mage)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "shatter",
		displayName = L["ResourceMageShatter"],
		isMultiNode = true,
		maxNodes = 20,
		hasSameColor = false,
		minMaxMode = "stepped",
		hasSpacing = true,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "shatter",
		-- Stack count is secret, so custom thresholds on it are static-only.
		usesSecretValue = true,
		-- Fed entirely by the Cooldown Manager's item for Shatter.
		cdm = TRB.Data.constants.cdmDependency.REQUIRED,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultShatterBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultShatterBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

	-- Arcane Salvo bar (Arcane Mage)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "arcaneSalvo",
		displayName = L["ResourceMageArcaneSalvo"],
		isMultiNode = false,
		maxNodes = 1,
		hasSameColor = false,
		-- Stacks run 0-20, or 0-25 with Spellfire Salvo; the class module owns the node's min/max.
		minMaxMode = "custom",
		hasSpacing = false,
		hasThresholds = false,
		colorCurveType = nil,
		visibilityKey = "arcaneSalvo",
		-- Stack count is Arcane Barrage's cast count, secret in combat, so custom thresholds on it are
		-- static-only and the range colors are resolved by gated overlays rather than a ColorCurve.
		usesSecretValue = true,
		rangeSlots = 5,
		-- Slider spans the talented cap; lines position against the live one, which the frame
		-- cannot report because the secret stack count taints its min/max.
		thresholdMax = 25,
		thresholdRuntimeMaxFunc = function()
			return TRB.Data.character.arcaneSalvoMaxStacks
		end,
		thresholdDecimals = 0,
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultArcaneSalvoBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultArcaneSalvoBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
