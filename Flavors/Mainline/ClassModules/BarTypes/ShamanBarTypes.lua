local _, TRB = ...
local L = TRB.Localization

-- Shaman bar types and their default-settings factories; loads after Core and before the class modules.

---Gets default Elemental Blast Buffs bar dimensions (anchored above the Mana bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultElementalBlastBuffsBarDimensions(classic)
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
				barKey = "mana",
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
			barKey = "mana",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Elemental Blast Buffs bar colors. No end cap: the aura engine's fill cannot carry one.
---@return table
function TRB.Functions.Settings:DefaultElementalBlastBuffsBarColors()
	return {
		border = { color = "FF3B1F5C" },
		background = { color = "66000000" },
		nodeOrder = { "criticalStrike", "haste", "mastery" },
		nodeColors = {
			criticalStrike = { color = "FFFF8C1A", color2 = "FFFF8C1A", gradientDirection = "disabled", enabled = true },
			haste = { color = "FF6ED8FF", color2 = "FF6ED8FF", gradientDirection = "disabled", enabled = true },
			mastery = { color = "FFC38CFF", color2 = "FFC38CFF", gradientDirection = "disabled", enabled = true }
		}
	}
end

---Returns default bar text for the Elemental Blast Buffs bar: each buff's timer, centered on its node.
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultElementalBlastBuffsBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}
	for _, buff in ipairs({
		{ variable = "$ebCritTime", name = L["ElementalBlastCriticalStrike"], frame = "ElementalBlastCriticalStrike" },
		{ variable = "$ebHasteTime", name = L["ElementalBlastHaste"], frame = "ElementalBlastHaste" },
		{ variable = "$ebMasteryTime", name = L["ElementalBlastMastery"], frame = "ElementalBlastMastery" },
	}) do
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = buff.name,
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{" .. buff.variable .. "}[" .. buff.variable .. "]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = buff.frame,
				relativeToFrameName = buff.name,
			}
		})
	end

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Elemental Blast Buffs bar (Elemental Shaman)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "elementalBlastBuffs",
		displayName = L["ResourceShamanElementalBlastBuffs"],
		isMultiNode = true,
		maxNodes = 3, -- Critical Strike + Haste + Mastery
		hasSameColor = false,
		minMaxMode = "discrete",
		hasSpacing = true,
		hasThresholds = false,
		-- Each buff's duration comes from the Cooldown Manager as a secret, so a line has no plain max.
		hasCustomThresholds = false,
		timerDrivenFill = true,
		colorCurveType = nil,
		visibilityKey = "elementalBlastBuffs",
		hasOrdering = true,
		orderUpTooltip = L["NodeOrderMoveUpTooltip"],
		orderDownTooltip = L["NodeOrderMoveDownTooltip"],
		cdm = TRB.Data.constants.cdmDependency.REQUIRED,
		nodeColors = {
			{ key = "criticalStrike", displayName = L["ElementalBlastCriticalStrikeBarEnable"], colorLabel = L["ElementalBlastCriticalStrike"], tooltip = L["ElementalBlastCriticalStrikeBarEnableTooltip"], hasEnabled = true },
			{ key = "haste", displayName = L["ElementalBlastHasteBarEnable"], colorLabel = L["ElementalBlastHaste"], tooltip = L["ElementalBlastHasteBarEnableTooltip"], hasEnabled = true },
			{ key = "mastery", displayName = L["ElementalBlastMasteryBarEnable"], colorLabel = L["ElementalBlastMastery"], tooltip = L["ElementalBlastMasteryBarEnableTooltip"], hasEnabled = true }
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultElementalBlastBuffsBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultElementalBlastBuffsBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))
end
