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

---Gets default Brews bar dimensions (anchored above the Stagger bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultBrewsBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.width = 50
	dims.anchor.barKey = "stagger"
	return dims
end

---Gets default Brews bar colors
---@return table
function TRB.Functions.Settings:DefaultBrewsBarColors()
	return {
		border = { color = "FF00FF98" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		nodeOrder = { "purifyingBrew", "celestialBrew", "celestialInfusion", "fortifyingBrew", "blackOxBrew" },
		nodeColors = {
			purifyingBrew = { color = "FFFFC64C", color2 = "FFFFC64C", gradientDirection = "disabled", enabled = true },
			celestialBrew = { color = "FF4FD8E0", color2 = "FF4FD8E0", gradientDirection = "disabled", enabled = true },
			celestialInfusion = { color = "FF7FE0A0", color2 = "FF7FE0A0", gradientDirection = "disabled", enabled = true },
			fortifyingBrew = { color = "FFB08D57", color2 = "FFB08D57", gradientDirection = "disabled", enabled = true },
			blackOxBrew = { color = "FF9482C9", color2 = "FF9482C9", gradientDirection = "disabled", enabled = true }
		}
	}
end

---Whether the Brews bar starts hidden: an existing install that hasn't answered the enable prompt, or answered No.
---Reads the saved variables until the settings load, since the defaults are built before then.
---@return boolean
function TRB.Functions.Settings:AreBrewsBarDeclined()
	local checks = TRB.Data.settings and TRB.Data.settings.manualUpdateChecks
	if checks == nil then
		local saved = TRB.Flavor.GetSavedVariables()
		checks = saved ~= nil and saved.manualUpdateChecks or nil
	end
	if checks == nil then
		-- A fresh install, before its first save.
		return false
	end
	local prompt = checks.brewsBarPrompt
	if type(prompt) ~= "table" then
		-- An existing save not yet marked for the prompt.
		return true
	end
	return prompt.answered ~= true or prompt.hidden == true
end

---Gets the Brews bar's default visibility, hidden while the enable prompt is unanswered or answered No.
---@return table
function TRB.Functions.Settings:DefaultBrewsBarVisibility()
	return { neverShow = self:AreBrewsBarDeclined(), alwaysShow = true, conditions = {}, hideConditions = self:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 }
end

---Gives a settings-shaped table's Brews bar a copy of the Stagger bar's visibility, preset link included, when it has
---Stagger's entry and not yet its own. The copy is hidden while the enable prompt is unanswered or answered No.
---@param settings table # The saved variables, one stored profile, or an import
function TRB.Functions.Settings:SeedBrewsBarVisibility(settings)
	local monk = type(settings) == "table" and settings.monk or nil
	local brewmaster = type(monk) == "table" and monk.brewmaster or nil
	local displayBar = type(brewmaster) == "table" and brewmaster.displayBar or nil
	if type(displayBar) ~= "table" or type(displayBar.stagger) ~= "table" or displayBar.brews ~= nil then
		return
	end
	local brews = TRB.Functions.Table:DeepCopy(displayBar.stagger)
	brews.neverShow = brews.neverShow == true or self:AreBrewsBarDeclined()
	-- The Brews bar has no Smooth option.
	brews.smooth = false
	displayBar.brews = brews
end

---Sets the Brews bar to Never Show, or shown, in the live settings and every profile, seeding a missing entry from the
---Stagger bar first.
---@param settings table # Shaped like the saved variables
---@param hidden boolean
function TRB.Functions.Settings:SetBrewsBarHidden(settings, hidden)
	local function SetIn(piece)
		local monk = type(piece) == "table" and piece.monk or nil
		local brewmaster = type(monk) == "table" and monk.brewmaster or nil
		local displayBar = type(brewmaster) == "table" and brewmaster.displayBar or nil
		if type(displayBar) ~= "table" then
			return
		end
		self:SeedBrewsBarVisibility(piece)
		displayBar.brews = displayBar.brews or self:DefaultBrewsBarVisibility()
		displayBar.brews.neverShow = hidden
	end

	SetIn(settings)
	if type(settings.profiles) == "table" and type(settings.profiles.list) == "table" then
		for _, profile in pairs(settings.profiles.list) do
			SetIn(profile)
		end
	end
end

---Returns default bar text for the Brews bar: each brew's cooldown, centered on the node that is recharging.
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultBrewsBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}
	for _, brew in ipairs({
		{ text = "{$purifyingBrewTime&$purifyingBrewCharges=0}[$purifyingBrewTime]", name = L["PurifyingBrewCharge1"], frame = "PurifyingBrew_1" },
		{ text = "{$purifyingBrewTime&$purifyingBrewCharges=1}[$purifyingBrewTime]", name = L["PurifyingBrewCharge2"], frame = "PurifyingBrew_2" },
		{ text = "{$celestialBrewTime&$celestialBrewCharges=0}[$celestialBrewTime]", name = L["CelestialBrewCharge1"], frame = "CelestialBrew_1" },
		{ text = "{$celestialBrewTime&$celestialBrewCharges=1}[$celestialBrewTime]", name = L["CelestialBrewCharge2"], frame = "CelestialBrew_2" },
		{ text = "{$celestialInfusionTime&$celestialInfusionCharges=0}[$celestialInfusionTime]", name = L["CelestialInfusionCharge1"], frame = "CelestialInfusion_1" },
		{ text = "{$celestialInfusionTime&$celestialInfusionCharges=1}[$celestialInfusionTime]", name = L["CelestialInfusionCharge2"], frame = "CelestialInfusion_2" },
		{ text = "{$fortifyingBrewTime}[$fortifyingBrewTime]", name = L["FortifyingBrew"], frame = "FortifyingBrew" },
		{ text = "{$blackOxBrewTime}[$blackOxBrewTime]", name = L["BlackOxBrew"], frame = "BlackOxBrew" },
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
			name = brew.name,
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = brew.text,
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
				relativeToFrame = brew.frame,
				relativeToFrameName = brew.name,
			}
		})
	end

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

do
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	-- Brews bar (Brewmaster Monk)
	registry:Register(TRB.Classes.BarTypeDefinition:New({
		key = "brews",
		displayName = L["ResourceMonkBrews"],
		isMultiNode = true,
		maxNodes = 6, -- Purifying Brew x2 + Celestial Brew or Infusion x2 + Fortifying Brew + Black Ox Brew
		endCapMode = "all", -- Monk.lua shows one End Cap per brew
		hasSameColor = false,
		minMaxMode = "discrete", -- 0-1 per node (cooldown progress)
		hasSpacing = true,
		hasThresholds = false,
		-- Cooldown times are secret in combat, so a line has no plain max.
		hasCustomThresholds = false,
		timerDrivenFill = true,
		colorCurveType = nil, -- Simple colors per brew
		visibilityKey = "brews",
		hasOrdering = true,
		orderUpTooltip = L["NodeOrderMoveUpTooltip"],
		orderDownTooltip = L["NodeOrderMoveDownTooltip"],
		nodeColors = {
			{ key = "purifyingBrew", displayName = L["PurifyingBrewBarEnable"], colorLabel = L["PurifyingBrew"], tooltip = L["PurifyingBrewBarEnableTooltip"], hasEnabled = true },
			{ key = "celestialBrew", displayName = L["CelestialBrewBarEnable"], colorLabel = L["CelestialBrew"], tooltip = L["CelestialBrewBarEnableTooltip"], hasEnabled = true },
			{ key = "celestialInfusion", displayName = L["CelestialInfusionBarEnable"], colorLabel = L["CelestialInfusion"], tooltip = L["CelestialInfusionBarEnableTooltip"], hasEnabled = true },
			{ key = "fortifyingBrew", displayName = L["FortifyingBrewBarEnable"], colorLabel = L["FortifyingBrew"], tooltip = L["FortifyingBrewBarEnableTooltip"], hasEnabled = true },
			{ key = "blackOxBrew", displayName = L["BlackOxBrewBarEnable"], colorLabel = L["BlackOxBrew"], tooltip = L["BlackOxBrewBarEnableTooltip"], hasEnabled = true }
		},
		defaultDimensionsFunc = function(classic)
			return TRB.Functions.Settings:DefaultBrewsBarDimensions(classic)
		end,
		defaultColorsFunc = function()
			return TRB.Functions.Settings:DefaultBrewsBarColors()
		end,
		defaultTexturesFunc = function()
			return TRB.Functions.Settings:DefaultCustomBarTextures()
		end
	}))

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
