local _, TRB = ...
local L = TRB.Localization

TRB.Functions.Settings = {}

local VISIBILITY_MANA_MAX = 275625 -- 250k base, enchant or Gnome * 1.05, both is another * 1.05

---Creates spec-level threshold definitions for secondary Mana Bar visibility options.
---@return table<string, table>
function TRB.Functions.Settings:LoadDefaultManaBarVisibilityThresholds()
	return {
		manaPercent = {
			valueType = "percent",
			powerType = Enum.PowerType.Mana,
		},
		manaValue = {
			valueType = "value",
			powerType = Enum.PowerType.Mana,
			maxValue = VISIBILITY_MANA_MAX,
		},
	}
end

---Creates a new independent copy of the default hard-hide visibility conditions.
---@return trbBarVisibilityHideConditions
function TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()
	return {
		isMountedAny = false,
		isMountedGround = false,
		isMountedFlying = false,
		isSteadyFlightFlying = false,
		isSkyriding = false,
		isSkyridingFlying = false,
		isDruidHumanoidForm = false,
		isDruidTravelFormAny = false,
		isDruidStagForm = false,
		isDruidFlightForm = false,
		isDruidSwiftFlightForm = false,
		isDruidAquaticForm = false,
		isDruidCatForm = false,
		isDruidBearForm = false,
		isDruidMoonkinForm = false,
		inVehicle = false,
		inPetBattle = true,
		onTaxi = true,
		isDead = false,
	}
end

---Creates a new independent copy of NewSpecGlobalDefaults()
---@return TRB.Classes.Settings.SpecializationGlobalEnabled
local function NewSpecGlobalDefaults()
	-- Every toggle but the Font & Text tab's ships on: Global Options drives a fresh install until the user opts a spec out.
    return {
		--specEnable = false,
		bar = true,
		comboPoints = true,
		healthBar = true,
		thresholdIcons = true,
		displayBar = true,
		displayText = false,
		globalBarText = true,
		textColors = false,
		thresholdColors = true,
		healthBarColors = true,
		precision = false,
		textures = true,
		castbarDimensions = true,
		castbarColors = true,
		castbarOverlays = true,
		castbarEmpower = true,
		castbarText = true,
		castbarShield = true,
		targetCastbarDimensions = true,
		targetCastbarColors = true,
		targetCastbarEmpower = true,
		targetCastbarText = true,
		targetCastbarShield = true,
		focusCastbarDimensions = true,
		focusCastbarColors = true,
		focusCastbarEmpower = true,
		focusCastbarText = true,
		focusCastbarShield = true,
		gcdDimensions = true,
		gcdColors = true,
		fatigueDimensions = true,
		fatigueColors = true,
		breathDimensions = true,
		breathColors = true
	}
end

---Loads the default settings structure
---@param classic boolean?
---@return table
function TRB.Functions.Settings:LoadDefaultSettings(classic)
	local settings = {
		-- One-shot per-class manual migration flags; only flavors with a migration history seed any.
		manualUpdateChecks = TRB.Flavor.DefaultManualUpdateChecks ~= nil and TRB.Flavor.DefaultManualUpdateChecks() or {},
		core = {
			dataRefreshRate = 5.0,
			reactionTime = 0.1,
			cooldownManagerGracePeriod = 10.0,
			news = {
				enabled = true,
				lastUpdate = ""
			},
			numberAbbreviation = true,
			-- What a Cooldown Manager fed bar text variable renders when the CDM has no value for it (the
			-- ability is not in a viewer, or its group is hidden): "questionMarks", "zero" or "nothing".
			cdmUnknownDisplay = "nothing",
			minimap = {
				hide = false,
			},
			audio = {
				channel = {
					name = L["AudioChannelMaster"],
					channel = "Master"
				}
			},
			strata = {
				level = "BACKGROUND",
				name = L["StrataBackground"]
			},
			timers = {
				precisionLow = 1,
				precisionHigh = 0,
				precisionThreshold = 5
			},
			-- User-defined Border Glow appearances, keyed by guid. Color Indicators on any spec point at
			-- these by id, so they live in core rather than per spec.
			glows = {},
			thresholds = {
				properties = {
					width = 2,
					overlapBorder=true
				},
				icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			},
			displayBar = {
				primary = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				secondary = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = false,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				health = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				utility = {
					neverShow = true,
					alwaysShow = false,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				castbar = TRB.Functions.Settings:DefaultCastbarVisibility(),
			},
			overcap = {
				mode = "relative",
				relative = 0,
				fixed = 100
			},
			bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
			comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
			healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
			bars = {
				castbar = TRB.Functions.Settings:DefaultCastbarBarSettings(classic),
			},
			precision = {
				health = 1,
				secondary = 2,
				resource = 0,
				mana = 1
			},
			colors = {
				text = {
					current = {
						color = "FFC2A3E0",
						enabled = true
					},
					casting = {
						color = "FFFFFFFF",
						enabled = true
					},
					spending = {
						color = "FF555555",
						enabled = true
					},
					passive = {
						color = "FFDF00FF",
						enabled = true
					},
					overThreshold = {
						color = "FF00FF00",
						enabled = false
					},
					overcap = {
						color = "FFFF0000",
						enabled = true
					},
				},
				healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
				bars = {
					castbar = TRB.Functions.Settings:DefaultCastbarBarColors(),
				},
				threshold = {
					under = {
						color = "FFFFFFFF"
					},
					over = {
						color = "FF00FF00"
					},
					unusable = {
						color = "FFFF0000"
					},
					special = {
						color = "FFFF00FF",
						enabled = true
					},
					outOfRange = {
						color = "FF440000",
						enabled = true,
						show = true
					},
				}
			},
			textures = TRB.Functions.Settings:DefaultTextures(true),
			displayText={
				default = {
					fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
					fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
					fontJustifyHorizontal = "LEFT",
					fontJustifyHorizontalName = L["PositionLeft"],
					fontSize = 18,
					color = {
						color = "FFFFFFFF"
					},
					fontOutline = "OUTLINE",
					fontShadow = {
						enabled = false,
						color = "FF000000",
						xOffset = 1,
						yOffset = -1,
					},
				},
				barText = TRB.Functions.Settings:LoadDefaultGlobalBarTextSettings(classic),
				migrations = {
					healthBarText = true,
					castBarText = true,
					-- These sets are already in the defaults above (Target and Focus Cast Bars, Other Bars) and
					-- in the Hunter specs' own bar text (Feign Death), so a fresh install must start with them
					-- marked done or PortForwardSettings would add a second copy on the next login.
					targetCastBarText = true,
					focusCastBarText = true,
					otherBarsText = true,
					hunterFeignDeathBarText = true
				}
			},
			-- Per-class/spec "use global" toggles; populated from the class/spec registry below.
			global = {
				globalEnable = false
			},
			-- Per-class/spec enable flags; populated from the class/spec registry below.
			enabled = {},
			experimental = {
			},
			editMode = {
				layouts = {}
			}
		},
	}

	-- The class/spec skeleton comes from the flavor registry: settings.core.global[class][spec] carries the
	-- "use global" toggles, settings.core.enabled[class][spec] the enable flags, and settings[class][spec]
	-- the per-spec settings the class options modules fill in.
	for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		local globalClass, enabledClass, specClass = {}, {}, {}
		for _, specEntry in ipairs(classEntry.specs) do
			globalClass[specEntry.specName] = NewSpecGlobalDefaults()
			enabledClass[specEntry.specName] = true
			specClass[specEntry.specName] = {}
		end
		settings.core.global[classEntry.className] = globalClass
		settings.core.enabled[classEntry.className] = enabledClass
		settings[classEntry.className] = specClass
	end

	-- Target/Focus cast bars are all-spec standalone bars; core is the global-defaults source for the
	-- per-spec "Use Global" toggle, so seed its bars/colors/displayBar/textures the same way specs do.
	-- Table:Merge(defaults, saved) then backfills these into existing saved core settings.
	self:InjectTargetCastbarDefaults(settings.core, classic)

	-- Other Bars follow the same rule. Core is the global scope, which excludes the Hunter-only Feign
	-- Death bar -- Hunter specs own that one outright.
	self:InjectOtherBarsDefaults(settings.core, nil, classic)

	return settings
end

---Per-profile port-forward hook. Calls PortForwardSettings against the given
---profile subtable, then brings its audio cues up to the current shape. Use for
---migrating individual profiles in the profiles.list structure, including ones
---that just arrived from an import. The `profile` parameter should be shaped
---like a top-level settings table (i.e. has optional `core` and class/spec
---keys), which is exactly how profiles are stored.
---@param profile table?
function TRB.Functions.Settings:PortForwardProfile(profile)
	if profile == nil then
		return
	end
	self:PortForwardSettings(profile)
	-- CleanupSettings only ever sees the live settings table, so a profile that is not seeded and
	-- normalized here keeps whatever cue shape it was saved or exported with.
	self:SeedAllAudioCues(profile)
	self:NormalizeAllAudioCues(profile)
	-- Same for the indicator order lists: ApplyToRuntime overlays them by index, so a profile whose
	-- list is shorter than the live one would leave a duplicate of the live tail behind.
	self:ReconcileAllSharedIndicators(profile)
end

---Runs the flavor's saved-variable migrations against a settings-shaped table (defaults to the live
---saved variables). Flavors with no migration history leave TRB.Flavor.PortForwardSettings undefined.
---@param settings table?
function TRB.Functions.Settings:PortForwardSettings(settings)
	if TRB.Flavor.PortForwardSettings ~= nil then
		TRB.Flavor.PortForwardSettings(settings)
	end
end

---@param oldSettings table? # The raw saved-variables table to clean
---@return table # A new table containing only recognized top-level keys
function TRB.Functions.Settings:CleanupSettings(oldSettings)
	local newSettings = {}
	if oldSettings ~= nil then
		for k, v in pairs(oldSettings) do
			if k == "manualUpdateChecks" or
				k == "profiles" or
				k == "core" or
				TRB.Data.classRegistry[k] ~= nil
			then
				newSettings[k] = v
			end
		end
	end

	local function NormalizeOverlayFullHeight(settings)
		if type(settings) ~= "table" or type(settings.colors) ~= "table" then
			return
		end

		if type(settings.colors.bar) == "table" and type(settings.colors.bar.casting) == "table" and settings.colors.bar.casting.fullHeight == nil then
			settings.colors.bar.casting.fullHeight = false
		end
		if type(settings.colors.bar) == "table" and type(settings.colors.bar.spending) == "table" and settings.colors.bar.spending.fullHeight == nil then
			settings.colors.bar.spending.fullHeight = false
		end
		if type(settings.colors.comboPoints) == "table" and type(settings.colors.comboPoints.casting) == "table" and settings.colors.comboPoints.casting.fullHeight == nil then
			settings.colors.comboPoints.casting.fullHeight = false
		end
		if type(settings.colors.comboPoints) == "table" and type(settings.colors.comboPoints.spending) == "table" and settings.colors.comboPoints.spending.fullHeight == nil then
			settings.colors.comboPoints.spending.fullHeight = false
		end

		if type(settings.colors.healthBar) == "table" then
			if type(settings.colors.healthBar.absorb) == "table" and settings.colors.healthBar.absorb.fullHeight == nil then
				settings.colors.healthBar.absorb.fullHeight = false
			end
			if type(settings.colors.healthBar.incomingHeal) == "table" and settings.colors.healthBar.incomingHeal.fullHeight == nil then
				settings.colors.healthBar.incomingHeal.fullHeight = false
			end
			if type(settings.colors.healthBar.healAbsorb) == "table" and settings.colors.healthBar.healAbsorb.fullHeight == nil then
				settings.colors.healthBar.healAbsorb.fullHeight = false
			end
		end
	end

	NormalizeOverlayFullHeight(newSettings.core)
	for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		local className = classEntry.className
		if type(newSettings[className]) == "table" then
			for _, specSettings in pairs(newSettings[className]) do
				NormalizeOverlayFullHeight(specSettings)
			end
		end
	end

	-- Runs last, on the fully merged table, so saved cues, defaults, and any user-added guid cues
	-- are all present and get stamped together. Seeding goes first: it can add cues that then need
	-- the same normalization pass as everything else.
	TRB.Functions.Settings:SeedAllAudioCues(newSettings)
	TRB.Functions.Settings:NormalizeAllAudioCues(newSettings)

	-- The merge above overlays nodeOrder/gradientOrder by index, so a saved list can hide a default
	-- key appended past its end. Reconcile against the defaults.
	TRB.Functions.Settings:ReconcileAllSharedIndicators(newSettings)

	return newSettings
end

---Gets the default primary bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.PrimaryBar
function TRB.Functions.Settings:DefaultBarDimensions(classic)
	local width = 300
	local border = 2

	if classic then
		border = 4
		width = 555
	end

	return {
		width = width,
		height = 30,
		xPos = 0,
		yPos = -200,
		border = border,
		fillDirection = "leftRight",
		anchor = {
			barKey = "screen",
			anchorPoint = "CENTER",
			attachPoint = "CENTER",
			xOffset = 0,
			yOffset = -200,
			matchWidth = false,
			matchHeight = false,
		},
	}
end

---Gets the default health bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultHealthDimensions(classic)
	local width = 300
	local height = 20
	local yPos = 0
	local border = 2

	if classic then
		yPos = -4
		width = 555
		height = 13
		border = 1
	end

	return {
		width = width,
		height = height,
		xPos = 0,
		yPos = yPos,
		border = border,
		spacing = 0,
		fillDirection = "leftRight",
		relativeTo = "BOTTOM",
		relativeToName = L["PositionBelowMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "primary",
			anchorPoint = "BOTTOM",
			attachPoint = "TOP",
			xOffset = 0,
			yOffset = yPos,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets the default secondary (comboPoints) dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultComboPointsDimensions(classic)
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
		width = 60,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		fillDirection = "leftRight",
		growthDirection = "leftRight",
		relativeTo ="TOP",
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

---Gets the default secondary partial-fill color configuration.
---@param enabled boolean?
---@return table
function TRB.Functions.Settings:DefaultSecondaryPartialFillColor(enabled)
	if enabled == nil then
		enabled = false
	end

	return {
		color = "FFFF4500",
		color2 = "FFFF4500",
		gradientDirection = "disabled",
		enabled = enabled
	}
end

---Gets the default secondary casting overlay color configuration.
---@param enabled boolean?
---@return table
function TRB.Functions.Settings:DefaultSecondaryCastingOverlayColor(enabled)
	if enabled == nil then
		enabled = true
	end

	return {
		color = "FFFFFFFF",
		color2 = "FFFFFFFF",
		gradientDirection = "disabled",
		enabled = enabled,
		fullHeight = false
	}
end

---Gets the default secondary spending overlay color configuration.
---@param enabled boolean?
---@return table
function TRB.Functions.Settings:DefaultSecondarySpendingOverlayColor(enabled)
	if enabled == nil then
		enabled = true
	end

	return {
		color = "FF555555",
		color2 = "FF555555",
		gradientDirection = "disabled",
		enabled = enabled,
		fullHeight = false
	}
end

---Gets the default end cap settings entry for a bar
---@return TRB.Classes.Settings.EndCapColorEntry
function TRB.Functions.Settings:DefaultEndCapColorEntry()
	return {
		color = "FFFFFFFF",
		enabled = false,
		width = 2,
		useBorderColor = false,
		useBorderColorExceptDefault = false
	}
end

--- Gets the default health bar color configuration including border, background, absorb, incoming heal, and step-based thresholds.
---@return table # Health bar color settings with low/medium/high color steps and overlay defaults
function TRB.Functions.Settings:DefaultHealthBarColors()
	return {
		border = { color = "FF008800" },
		background = { color = "66000000" },
		absorb = { color = "CCFFFFB9", enabled = true, mode = "appended", fullHeight = false },
		incomingHeal = { color = "CC80b980", enabled = true, mode = "appended", fullHeight = false },
		healAbsorb = { color = "CCCC4444", enabled = true, mode = "inset", fullHeight = false },
		endCap = self:DefaultEndCapColorEntry(),
		type = "step",
		low = { color = "FFFF0000", threshold = 0.0 },
		medium = { color = "FFFFFF00", threshold = 0.30 },
		high = { color = "FF00FF00", threshold = 0.70 }
	}
end

---Gets the default mana bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultManaBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
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

---Gets the default mana bar colors
---@return TRB.Classes.Settings.GenericBarColorsBase
function TRB.Functions.Settings:DefaultManaBarColors()
	return {
		bar = { color = "FF0000FF", color2 = "FF0000FF", gradientDirection = "disabled" },
		border = { color = "FF0000AA" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry()
	}
end

--[[
	Custom Bar Default Settings
	These functions provide defaults for bars stored under settings.bars.<key>,
	settings.colors.bars.<key>, and settings.textures.bars.<key>.
]]

---Gets the default dimensions for a custom bar (single node, fullWidth)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultCustomBarDimensions(classic)
	if classic then
		return {
			width = 555,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
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
				yOffset = 4,
				matchWidth = true,
				matchHeight = false,
			},
		}
	end

	return {
		width = 300,
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

---Gets the default colors for a simple custom bar (no thresholds)
---@param barColor string? # ARGB hex color for bar (default: blue)
---@param borderColor string? # ARGB hex color for border (default: dark blue)
---@param backgroundColor string? # ARGB hex color for background (default: transparent black)
---@return table
function TRB.Functions.Settings:DefaultCustomBarColors(barColor, borderColor, backgroundColor)
	return {
		bar = { color = barColor or "FF0000FF", color2 = barColor or "FF0000FF", gradientDirection = "disabled" },
		border = { color = borderColor or "FF0000AA" },
		background = { color = backgroundColor or "66000000" },
		endCap = self:DefaultEndCapColorEntry()
	}
end

---Gets the default colors for a threshold-based custom bar (like Stagger or Health)
---@param lowColor string? # ARGB hex color for low state
---@param mediumColor string? # ARGB hex color for medium state
---@param highColor string? # ARGB hex color for high state
---@param mediumThreshold number? # Threshold for medium state (0-1)
---@param highThreshold number? # Threshold for high state (0-1)
---@param colorType string? # "step", "linear", or "none"
---@return table
function TRB.Functions.Settings:DefaultCustomBarThresholdColors(lowColor, mediumColor, highColor, mediumThreshold, highThreshold, colorType)
	return {
		border = { color = "FF000066" },
		background = { color = "66000000" },
		type = colorType or "step",
		low = { color = lowColor or "FF00FF00", color2 = lowColor or "FF00FF00", gradientDirection = "disabled", threshold = 0.0 },
		medium = { color = mediumColor or "FFFFFF00", color2 = mediumColor or "FFFFFF00", gradientDirection = "disabled", threshold = mediumThreshold or 0.30 },
		high = { color = highColor or "FFFF0000", color2 = highColor or "FFFF0000", gradientDirection = "disabled", threshold = highThreshold or 0.70 }
	}
end

---Gets the default textures for a custom bar (nested structure)
---@return table
function TRB.Functions.Settings:DefaultCustomBarTextures()
	return {
		bar = "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		barName = L["LSMStatusBarSmoother"],
		border = "Interface\\Buttons\\WHITE8X8",
		borderName = "1 Pixel",
		background = "Interface\\Tooltips\\UI-Tooltip-Background",
		backgroundName = "Blizzard Tooltip"
	}
end

---Gets default Castbar bar dimensions (single node, full width; wider/taller default than a generic bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultCastbarBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	-- Castbars sit below the health bar by default so they never overlap the primary resource bar.
	dims.relativeTo = "BOTTOM"
	dims.relativeToName = L["PositionBelowMiddle"]
	dims.anchor.barKey = "health"
	dims.anchor.anchorPoint = "BOTTOM"
	dims.anchor.attachPoint = "TOP"
	return dims
end

---Gets built-in channel tick profiles that apply to every spec/class (abilities castable regardless of
---spec, e.g. Recuperate). Returns a fresh table each call. This is static CODE data, not persisted into
---settings -- TRB.Functions.Castbar:GetTickProfile resolves it (overlaid with the active spec's registered
---set from TRB.Data.castbarTickProfilesRegistry) at render time, so edits here take effect on reload.
---Each profile drives tick placement:
---  mode "fixedCount": tick count stays constant, channel duration scales with haste (e.g. Mind Flay).
---  mode "fixedRate": channel duration is fixed, tick rate scales with haste, final partial tick (e.g. Void Torrent).
---baseDuration and baseTickRate are UNHASTED seconds; the render scales them by GCD-inferred haste.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Functions.Settings:DefaultGlobalCastbarTickProfiles()
	return {
		-- Cannibalize
		[20578] = { mode = "fixedCount", baseDuration = 10, tickCount = 5, firstTickAtStart = false },
		-- Recuperate: one tick per second for 10 seconds
		[1231418] = { mode = "fixedCount", baseDuration = 10, tickCount = 10, firstTickAtStart = false },
	}
end

---Gets the default Castbar visibility entry (displayBar.castbar). Uses castbar-specific show conditions
---(casting/channeling/empowered) instead of the standard environment conditions; alwaysShow keeps the
---empty bar frame on screen while idle, neverShow fully disables castbar processing.
---@return trbBarVisibilitySetting
function TRB.Functions.Settings:DefaultCastbarVisibility()
	return {
		neverShow = false,
		alwaysShow = false,
		conditions = {
			casting = true,
			channeling = true,
			empowered = true
		},
		hideConditions = {
			inVehicle = false
		},
		activeAlpha = 100,
		inactiveAlpha = 0,
		fadeDuration = 0.5,
		fadeDelay = 0,
		resourceConditionType = "none",
		resourceConditionOperator = ">=",
		resourceConditionValue = 0
	}
end

---Gets the default Castbar bar settings (dimensions + behavior flags). Built-in tick profiles are NOT
---stored here -- they are static code data resolved at render time by TRB.Functions.Castbar:GetTickProfile.
---tickProfiles stays an empty table, reserved for future user-authored per-spell overrides.
---@param classic boolean?
---@param className string? # Accepted for signature compatibility; no longer used (tick profiles are code data)
---@param specName string? # Accepted for signature compatibility; no longer used (tick profiles are code data)
---@return TRB.Classes.Settings.CastbarBar
function TRB.Functions.Settings:DefaultCastbarBarSettings(classic, className, specName)
	local settings = self:DefaultCastbarBarDimensions(classic) --[[@as TRB.Classes.Settings.CastbarBar]]
	settings.showTicks = true
	settings.tickWidth = 1
	settings.tickLatencyWidth = true
	settings.showLatency = true
	settings.showPushback = true
	settings.showEmpowerStages = true
	settings.empowerSegmentedFill = false
	settings.castTimePrecision = 1
	settings.durationPrecision = 1
	settings.latencyPrecision = 1
	settings.disableBlizzardCastbar = true
	settings.mergeTradeskill = true
	settings.targetClassColor = false
	settings.targetClassColorPvpOnly = false
	settings.targetClassColorFriendly = false
	settings.tickProfiles = {}
	settings.icon = self:DefaultBarIconSettings()
	settings.uninterruptibleShield = self:DefaultCastbarShieldSettings()
	settings.height = 30
	return settings
end

---Gets the default side ability icon settings for a bar. Generic: any bar type that renders a side icon
---uses this same block, so the layout and options code stays bar-agnostic. The border is not configured
---here -- it follows the bar's own border thickness and color.
---@return TRB.Classes.Settings.BarIcon
function TRB.Functions.Settings:DefaultBarIconSettings()
	return {
		enabled = true,
		side = "left",
		spacing = 2,
		collapseBorderWidth = false,
		zoom = 10,
		showTooltip = false
	}
end

---Gets the default uninterruptible shield settings for a cast bar. Its own bar-level block (a sibling of
---`icon`, not nested inside it) so it is globally toggleable as its own section and shows independent of the
---icon. Defaults: drawn behind the target at 175% (peeking out), fully opaque, centered, untinted.
---@return TRB.Classes.Settings.CastBarIconShield
function TRB.Functions.Settings:DefaultCastbarShieldSettings()
	return {
		mode = "behind",
		target = "icon",
		sizePercent = 175,
		opacity = 100,
		anchor = "CENTER",
		colorSource = "default",
		customColor = "FFFFFFFF"
	}
end

---Gets the default Castbar colors. `bar` is the standard-cast fill; `channel` and `uninterruptible`
---recolor the fill per state, and `uninterruptibleBorder` recolors the border for that same state, so an
---uninterruptible cast still reads as one when an indicator has claimed the fill (and vice versa).
---Overlay colors (latency/pushback) and tick lines are separate. Empower fill uses absolute per-level
---colors: `base` while charging toward Level I, then `level1`..`level4` as each empower level is reached
---(mapped from GetCurrentEmpowerStage at render time; game max is 4).
---@return table
function TRB.Functions.Settings:DefaultCastbarBarColors()
	return {
		bar = { color = "FFFFCC00", color2 = "FFFFCC00", gradientDirection = "disabled" },
		channel = { color = "FF00CCFF", color2 = "FF00CCFF", gradientDirection = "disabled" },
		uninterruptible = { color = "ff555555", color2 = "ff555555", gradientDirection = "disabled" },
		uninterruptibleBorder = { color = "FF222222" },
		border = { color = "FF000000" },
		background = { color = "66000000" },
		latency = { color = "80FF0000", enabled = true },
		pushback = { color = "80FF00FF", enabled = true },
		tick = { color = "FFFFFFFF", enabled = true },
		endCap = self:DefaultEndCapColorEntry(),
		empowerStages = {
			base = { color = "FFC8B0FF" },
			level1 = { color = "FFFFCC00" },
			level2 = { color = "FFFFAA00" },
			level3 = { color = "FFFF6600" },
			level4 = { color = "FFFF3000" }
		}
	}
end

---Central injector: adds castbar defaults (bars/colors/textures/displayBar) to a spec's default settings
---table so the standard defaults->saved Table:Merge carries them into every spec of every class. Idempotent.
---@param specDefaults table # A single spec's default settings table (from a class's LoadDefaultSettings)
---@param className string? # Lowercase class name, for the per-spec tick profile lookup
---@param specName string? # Lowercase spec name, for the per-spec tick profile lookup
---@param classic boolean?
function TRB.Functions.Settings:InjectCastbarDefaults(specDefaults, className, specName, classic)
	if type(specDefaults) ~= "table" then
		return
	end

	-- Dimensions + behavior under bars.castbar
	specDefaults.bars = specDefaults.bars or {}
	if specDefaults.bars.castbar == nil then
		specDefaults.bars.castbar = self:DefaultCastbarBarSettings(classic, className, specName)
	end

	-- Colors under colors.bars.castbar
	specDefaults.colors = specDefaults.colors or {}
	specDefaults.colors.bars = specDefaults.colors.bars or {}
	if specDefaults.colors.bars.castbar == nil then
		specDefaults.colors.bars.castbar = self:DefaultCastbarBarColors()
	end

	-- Visibility under displayBar.castbar (BarVisibility-style entry with castbar-specific conditions)
	specDefaults.displayBar = specDefaults.displayBar or {}
	if specDefaults.displayBar.castbar == nil then
		specDefaults.displayBar.castbar = self:DefaultCastbarVisibility()
	end

	-- Flat texture keys castbarBar / castbarBorder / castbarBackground
	specDefaults.textures = specDefaults.textures or {}
	if specDefaults.textures.castbarBar == nil then
		local tex = self:DefaultCustomBarTextures()
		specDefaults.textures.castbarBar = tex.bar
		specDefaults.textures.castbarBarName = tex.barName
		specDefaults.textures.castbarBorder = tex.border
		specDefaults.textures.castbarBorderName = tex.borderName
		specDefaults.textures.castbarBackground = tex.background
		specDefaults.textures.castbarBackgroundName = tex.backgroundName
	end
end

---Gets default Target/Focus Cast Bar dimensions: a standalone bar anchored to the SCREEN (its own
---EditMode root), NOT part of the main anchor stack. Fixed width, center-upper by default.
---@param classic boolean?
---@return table
function TRB.Functions.Settings:DefaultTargetCastbarBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.fullWidth = false
	dims.width = 300
	dims.relativeTo = "SCREEN"
	dims.relativeToName = L["PositionScreen"]
	dims.anchor.barKey = "screen"
	dims.anchor.anchorPoint = "CENTER"
	dims.anchor.attachPoint = "CENTER"
	dims.anchor.xOffset = 0
	dims.anchor.yOffset = 0
	dims.anchor.matchWidth = false
	dims.anchor.matchHeight = false
	return dims
end

---Gets the default Target/Focus Cast Bar behavior settings (dimensions + flags). Secret-safe render, so
---no tick/latency/pushback/empower overlay flags -- only the elements the secret-safe path supports.
---@param classic boolean?
---@param unitKey string? # "targetCastbar" or "focusCastbar"; Target ships larger and above center
---@return table
function TRB.Functions.Settings:DefaultTargetCastbarBarSettings(classic, unitKey)
	local settings = self:DefaultTargetCastbarBarDimensions(classic)
	settings.height = 24
	settings.castTimePrecision = 1
	settings.durationPrecision = 1
	settings.interruptColor = true
	settings.interruptHostileOnly = true
	settings.showEmpowerStages = true
	settings.empowerStageLineWidth = 1
	settings.classColor = false
	settings.classColorPvpOnly = false
	settings.classColorFriendly = false
	settings.icon = self:DefaultBarIconSettings()
	settings.uninterruptibleShield = self:DefaultCastbarShieldSettings()

	if unitKey == "targetCastbar" then
		settings.width = 500
		settings.height = 40
		settings.anchor.yOffset = 300
	end

	return settings
end

---Gets the default bar text entries for a Target/Focus Cast Bar: spell name (left) and remaining time
---(right), anchored to the given bar frame. Mirrors LoadDefaultCastBarTextSettings. Timing is secret, so
---the display value can't be compared with {$var>0}; instead the variables resolve to a boolean ("is the
---unit casting?") in logic context (see IsValidVariableBase), so a bare {$var}[...] conditional gates it.
---@param relativeToFrame string # "TargetCastBar" or "FocusCastBar"
---@param relativeToFrameName string # Localized display name for the anchor frame
---@param spellNameVar string # e.g. "$targetCastingSpellName"
---@param remainingVar string # e.g. "$targetCastTimeRemaining"
---@param castTimeVar string # e.g. "$targetCastTime"
---@param leftFontSize number # Font size for the left (spell name) entry
---@param rightFontSize number # Font size for the right (remaining / cast time) entry
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultTargetFocusCastBarTextSettings(relativeToFrame, relativeToFrameName, spellNameVar, remainingVar, castTimeVar, leftFontSize, rightFontSize)
	return {
		{
			useDefaultFontColor = true,
			useDefaultFontFace = true,
			useDefaultFontSize = false,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = true,
			maxWidthPercent = 75,
			text = "{" .. spellNameVar .. "}[" .. spellNameVar .. "]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize = leftFontSize,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 6,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = relativeToFrame,
				relativeToFrameName = relativeToFrameName
			}
		},
		{
			useDefaultFontColor = true,
			useDefaultFontFace = true,
			useDefaultFontSize = false,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{" .. remainingVar .. "}[" .. remainingVar .. " / " .. castTimeVar .. "]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize = rightFontSize,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = relativeToFrame,
				relativeToFrameName = relativeToFrameName
			}
		}
	}
end

---Default Target Cast Bar text; the fresh-install defaults and the targetCastBarText migration share it.
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultTargetCastBarTextSettings()
	return self:LoadDefaultTargetFocusCastBarTextSettings("TargetCastBar", L["ResourceTargetCastbar"], "$targetCastingSpellName", "$targetCastTimeRemaining", "$targetCastTime", 20, 20)
end

---Default Focus Cast Bar text; the fresh-install defaults and the focusCastBarText migration share it.
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultFocusCastBarTextSettings()
	return self:LoadDefaultTargetFocusCastBarTextSettings("FocusCastBar", L["ResourceFocusCastbar"], "$focusCastingSpellName", "$focusCastTimeRemaining", "$focusCastTime", 14, 12)
end

---Gets the default bar text entry for one of the Other Bars: its remaining time, sitting on the bar
---itself. One entry per bar -- these show a single number, unlike the cast bars' name/timing pair. The
---remaining value is display-only (the GCD's is secret), so the text is gated by a bare {$var} check,
---which resolves to "is this timer running?" in logic context, rather than by a comparison.
---@param relativeToFrame string # "GcdBar", "FatigueBar", "BreathBar" or "FeignDeathBar"
---@param relativeToFrameName string # Localized display name for the anchor frame, also the entry's name
---@param remainingVar string # e.g. "$fatigueDurationRemaining"
---@param anchorPoint string # "CENTER" or "RIGHT"
---@param fontSize number
---@param enabled boolean? # Whether the entry is enabled by default (default: true)
---@return TRB.Classes.Settings.DisplayTextEntry
function TRB.Functions.Settings:LoadDefaultOtherBarTextSettings(relativeToFrame, relativeToFrameName, remainingVar, anchorPoint, fontSize, enabled)
	local anchorName = L["PositionCenter"]
	local xPos = 0
	if anchorPoint == "RIGHT" then
		anchorName = L["PositionRight"]
		xPos = -2
	end

	return {
		useDefaultFontColor = true,
		useDefaultFontFace = true,
		useDefaultFontSize = false,
		useDefaultFontOutline = true,
		useDefaultFontShadow = true,
		enabled = enabled ~= false,
		name = relativeToFrameName,
		guid = TRB.Functions.String:Guid(),
		constrainToParent = false,
		maxWidthPercent = 100,
		text = "{" .. remainingVar .. "}[" .. remainingVar .. "]",
		fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
		fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
		fontJustifyHorizontal = anchorPoint,
		fontJustifyHorizontalName = anchorName,
		fontSize = fontSize,
		fontOutline = "OUTLINE",
		fontOutlineName = L["FontOutlineOutline"],
		fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		color = { color = "FFFFFFFF" },
		position = {
			xPos = xPos,
			yPos = 0,
			relativeTo = anchorPoint,
			relativeToName = anchorName,
			relativeToFrame = relativeToFrame,
			relativeToFrameName = relativeToFrameName
		}
	}
end

---Gets the default Target/Focus Cast Bar colors. `bar` is the standard-cast fill, `channel` recolors a
---channel, `empower` recolors an empowered cast (differentiated by event), `uninterruptible` /
---`uninterruptibleBorder` recolor the fill / border when a hostile cast can't be interrupted (via the
---native secret-boolean evaluator), and `empowerStageLine` colors the empower stage boundary lines.
---@return table
function TRB.Functions.Settings:DefaultTargetCastbarBarColors()
	return {
		bar = { color = "FFFFCC00", color2 = "FFFFCC00", gradientDirection = "disabled" },
		channel = { color = "FF00CCFF", color2 = "FF00CCFF", gradientDirection = "disabled" },
		empower = { color = "FFFF8000", color2 = "FFFF8000", gradientDirection = "disabled" },
		uninterruptible = { color = "ff555555", color2 = "ff555555", gradientDirection = "disabled" },
		uninterruptibleBorder = { color = "FF222222" },
		empowerStageLine = { color = "FFFFFFFF" },
		border = { color = "FF000000" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry()
	}
end

---Gets the default Target/Focus Cast Bar visibility entry: castbar-style show conditions (casting/
---channeling/empowered), runtime-driven like the player castbar.
---@return table
function TRB.Functions.Settings:DefaultTargetCastbarVisibility()
	return {
		neverShow = true,
		alwaysShow = false,
		conditions = { casting = true, channeling = true, empowered = true },
		hideConditions = { inVehicle = false },
		activeAlpha = 100,
		inactiveAlpha = 0,
		fadeDuration = 0.5,
		fadeDelay = 0,
		resourceConditionType = "none",
		resourceConditionOperator = ">=",
		resourceConditionValue = 0
	}
end

---Central injector: adds the Target and Focus Cast Bar defaults (bars/colors/displayBar/textures) to a
---spec's default settings table for both unit bars, so the standard defaults->saved Table:Merge carries
---them into every spec of every class. Idempotent. Mirrors InjectCastbarDefaults.
---@param specDefaults table
---@param classic boolean?
function TRB.Functions.Settings:InjectTargetCastbarDefaults(specDefaults, classic)
	if type(specDefaults) ~= "table" then
		return
	end
	specDefaults.bars = specDefaults.bars or {}
	specDefaults.colors = specDefaults.colors or {}
	specDefaults.colors.bars = specDefaults.colors.bars or {}
	specDefaults.displayBar = specDefaults.displayBar or {}
	specDefaults.textures = specDefaults.textures or {}

	-- Both bars share the same default shape; Focus starts slightly below Target (positions are then
	-- independently movable via EditMode).
	for _, key in ipairs({ "targetCastbar", "focusCastbar" }) do
		if specDefaults.bars[key] == nil then
			specDefaults.bars[key] = self:DefaultTargetCastbarBarSettings(classic, key)
		end
		if specDefaults.colors.bars[key] == nil then
			specDefaults.colors.bars[key] = self:DefaultTargetCastbarBarColors()
		end
		if specDefaults.displayBar[key] == nil then
			specDefaults.displayBar[key] = self:DefaultTargetCastbarVisibility()
		end
		local barTex = key .. "Bar"
		if specDefaults.textures[barTex] == nil then
			local tex = self:DefaultCustomBarTextures()
			specDefaults.textures[barTex] = tex.bar
			specDefaults.textures[key .. "BarName"] = tex.barName
			specDefaults.textures[key .. "Border"] = tex.border
			specDefaults.textures[key .. "BorderName"] = tex.borderName
			specDefaults.textures[key .. "Background"] = tex.background
			specDefaults.textures[key .. "BackgroundName"] = tex.backgroundName
		end
	end
end

---Gets default Other Bars dimensions: a standalone bar anchored to the SCREEN (its own EditMode root),
---NOT part of the main anchor stack. Mirrors DefaultTargetCastbarBarDimensions.
---@param classic boolean?
---@return table
function TRB.Functions.Settings:DefaultOtherBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.fullWidth = false
	dims.width = 300
	dims.relativeTo = "SCREEN"
	dims.relativeToName = L["PositionScreen"]
	dims.anchor.barKey = "screen"
	dims.anchor.anchorPoint = "CENTER"
	dims.anchor.attachPoint = "CENTER"
	dims.anchor.xOffset = 0
	dims.anchor.yOffset = 0
	dims.anchor.matchWidth = false
	dims.anchor.matchHeight = false
	return dims
end

---Gets the default visibility entry for an Other Bar. These bars have one show state, `whenActive`,
---meaning their timer is running; Always Show additionally keeps the empty frame on screen while idle.
---Ships disabled: an all-spec bar nobody asked for should not appear (nor displace Blizzard's) until it
---is turned on, but it ships with whenActive already ticked so enabling it does something immediately.
---@param barKey string? # The bar this entry is for; the GCD takes a shorter tail than the mirror timers
---@return trbBarVisibilitySetting
function TRB.Functions.Settings:DefaultOtherBarVisibility(barKey)
	-- The GCD recycles every ~1.5s, so any fade tail leaves it on screen most of the time and reads as a
	-- bar that never goes away. The mirror timers fire once in a while and fade out normally.
	local fadeDuration = 0.5
	if barKey == "gcd" then
		fadeDuration = 0
	end

	return {
		neverShow = true,
		alwaysShow = false,
		conditions = { whenActive = true },
		-- Full standard hide-condition set, not the cast bars' pared-back pair: these timers run in
		-- exactly the situations people suppress bars for (mounted, flying, on a taxi), so all of them
		-- need to be reachable. Existing saved entries get the new keys through the defaults merge.
		hideConditions = self:LoadDefaultBarVisibilityHideConditions(),
		activeAlpha = 100,
		inactiveAlpha = 0,
		fadeDuration = fadeDuration,
		fadeDelay = 0,
		resourceConditionType = "none",
		resourceConditionOperator = ">=",
		resourceConditionValue = 0
	}
end

---Gets the default Global Cooldown bar settings. `timerDirection` picks how the fill runs: "deplete"
---(default) drains a full bar as the GCD runs down, "fill" grows an empty one. It maps straight onto
---Enum.StatusBarTimerDirection at render time.
---@param classic boolean?
---@return TRB.Classes.Settings.OtherBar
function TRB.Functions.Settings:DefaultGcdBarSettings(classic)
	local settings = self:DefaultOtherBarDimensions(classic) --[[@as TRB.Classes.Settings.OtherBar]]
	settings.height = 10
	settings.timerDirection = "deplete"
	settings.durationPrecision = 1

	-- Sits flush under the Cast Bar, its natural companion: both count the same cast down. Specs whose
	-- cast bar group is absent fall back automatically -- BuildAnchorForest walks up to the nearest
	-- existing ancestor rather than orphaning the bar.
	settings.relativeTo = "BOTTOM"
	settings.relativeToName = L["PositionBelowMiddle"]
	settings.anchor.barKey = "castbar"
	settings.anchor.anchorPoint = "BOTTOM"
	settings.anchor.attachPoint = "TOP"
	settings.anchor.xOffset = 0
	settings.anchor.yOffset = -2
	settings.anchor.matchWidth = true
	return settings
end

---Gets the default Global Cooldown bar colors.
---@return table
function TRB.Functions.Settings:DefaultGcdBarColors()
	return {
		bar = { color = "FFFFFFFF", color2 = "FFFFFFFF", gradientDirection = "disabled" },
		border = { color = "FF000000" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry()
	}
end

---The mirror timer bars form a single anchored stack: Fatigue is the tree root (screen-anchored, its own
---EditMode wrapper) and each of the others hangs off the one before it, so moving Fatigue moves the whole
---group. Maps bar key -> the key it anchors to; absent means "root".
local mirrorTimerAnchorParent = {
	breath = "fatigue",
	feignDeath = "breath",
}

---Gets the default settings for one of the mirror timer bars (Fatigue / Breath / Feign Death).
---`disableBlizzardBar` suppresses only this timer's frame inside Blizzard's "Duration Bars" Edit Mode
---system, mirroring the cast bar's disableBlizzardCastbar.
---@param classic boolean?
---@param barKey string # "fatigue", "breath" or "feignDeath"
---@return TRB.Classes.Settings.OtherBar
function TRB.Functions.Settings:DefaultMirrorTimerBarSettings(classic, barKey)
	local settings = self:DefaultOtherBarDimensions(classic) --[[@as TRB.Classes.Settings.OtherBar]]
	settings.height = 18
	settings.disableBlizzardBar = true
	-- No durationPrecision: these read as mm:ss, so there are no decimals to configure. Only the GCD,
	-- which runs under two seconds, has one.

	local parentKey = mirrorTimerAnchorParent[barKey]
	if parentKey == nil then
		-- Root of the stack: sits well above screen center, clear of the action bars and the middle of
		-- the screen. Moving it moves the whole group.
		settings.anchor.yOffset = 300
	else
		-- Sits below its parent: this bar's TOP against the parent's BOTTOM, matching its width so the
		-- stack reads as one block.
		settings.relativeTo = "BOTTOM"
		settings.relativeToName = L["PositionBelowMiddle"]
		settings.anchor.barKey = parentKey
		settings.anchor.anchorPoint = "BOTTOM"
		settings.anchor.attachPoint = "TOP"
		settings.anchor.yOffset = -4
		settings.anchor.matchWidth = true
	end

	return settings
end

---Gets the default colors for one of the mirror timer bars. Each takes a fill that reads as its hazard:
---Fatigue amber, Breath blue, Feign Death grey-violet.
---@param barKey string # "fatigue", "breath" or "feignDeath"
---@return table
function TRB.Functions.Settings:DefaultMirrorTimerBarColors(barKey)
	local fill = "FFB0A0D0"
	if barKey == "fatigue" then
		fill = "FFFFAA00"
	elseif barKey == "breath" then
		fill = "FF00AAFF"
	end

	return {
		bar = { color = fill, color2 = fill, gradientDirection = "disabled" },
		border = { color = "FF000000" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry()
	}
end

---Central injector: adds the Other Bars defaults (bars/colors/displayBar/textures) to a spec's default
---settings table, so the standard defaults->saved Table:Merge carries them into every spec of every
---class. Idempotent. Mirrors InjectTargetCastbarDefaults. Feign Death only ever fires for Hunters, so
---only Hunter specs get it -- not even the global scope.
---@param specDefaults table
---@param classId integer? # nil for the global (core) scope, which gets every bar
---@param classic boolean?
function TRB.Functions.Settings:InjectOtherBarsDefaults(specDefaults, classId, classic)
	if type(specDefaults) ~= "table" then
		return
	end
	specDefaults.bars = specDefaults.bars or {}
	specDefaults.colors = specDefaults.colors or {}
	specDefaults.colors.bars = specDefaults.colors.bars or {}
	specDefaults.displayBar = specDefaults.displayBar or {}
	specDefaults.textures = specDefaults.textures or {}

	for _, key in ipairs(TRB.Classes.BarTypeRegistry:GetOtherBarKeys(classId)) do
		if specDefaults.bars[key] == nil then
			if key == "gcd" then
				specDefaults.bars[key] = self:DefaultGcdBarSettings(classic)
			else
				specDefaults.bars[key] = self:DefaultMirrorTimerBarSettings(classic, key)
			end
		end
		if specDefaults.colors.bars[key] == nil then
			if key == "gcd" then
				specDefaults.colors.bars[key] = self:DefaultGcdBarColors()
			else
				specDefaults.colors.bars[key] = self:DefaultMirrorTimerBarColors(key)
			end
		end
		if specDefaults.displayBar[key] == nil then
			specDefaults.displayBar[key] = self:DefaultOtherBarVisibility(key)
		end
		local barTex = key .. "Bar"
		if specDefaults.textures[barTex] == nil then
			local tex = self:DefaultCustomBarTextures()
			specDefaults.textures[barTex] = tex.bar
			specDefaults.textures[key .. "BarName"] = tex.barName
			specDefaults.textures[key .. "Border"] = tex.border
			specDefaults.textures[key .. "BorderName"] = tex.borderName
			specDefaults.textures[key .. "Background"] = tex.background
			specDefaults.textures[key .. "BackgroundName"] = tex.backgroundName
		end
	end
end

---Central injector: adds end cap defaults to a spec's primary bar and combo point color tables so the
---standard defaults->saved Table:Merge carries them into every spec of every class. Idempotent.
---Custom bars get theirs from their Default*BarColors functions instead.
---@param specDefaults table # A single spec's default settings table (from a class's LoadDefaultSettings)
function TRB.Functions.Settings:InjectEndCapDefaults(specDefaults)
	if type(specDefaults) ~= "table" or type(specDefaults.colors) ~= "table" then
		return
	end

	if type(specDefaults.colors.bar) == "table" and specDefaults.colors.bar.endCap == nil then
		specDefaults.colors.bar.endCap = self:DefaultEndCapColorEntry()
	end
	if type(specDefaults.colors.comboPoints) == "table" and specDefaults.colors.comboPoints.endCap == nil then
		specDefaults.colors.comboPoints.endCap = self:DefaultEndCapColorEntry()
	end
end

---Gets default Utility bar dimensions (anchored below health bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultUtilityBarDimensions(classic)
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
			relativeTo = "BOTTOM",
			relativeToName = L["PositionBelowMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "health",
				anchorPoint = "BOTTOM",
				attachPoint = "TOP",
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
		relativeTo = "BOTTOM",
		relativeToName = L["PositionBelowMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "health",
			anchorPoint = "BOTTOM",
			attachPoint = "TOP",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Utility bar colors (generic; class modules should override via BarTypeRegistry)
---@return table
function TRB.Functions.Settings:DefaultUtilityBarColors()
	return {
		border = { color = "FF888888" },
		background = { color = "66000000" },
		endCap = self:DefaultEndCapColorEntry(),
		nodeColors = {
			charge1 = { color = "FFAAAAAA", color2 = "FFAAAAAA", gradientDirection = "disabled", enabled = true },
			charge2 = { color = "FFAAAAAA", color2 = "FFAAAAAA", gradientDirection = "disabled", enabled = true },
			charge3 = { color = "FFAAAAAA", color2 = "FFAAAAAA", gradientDirection = "disabled", enabled = true }
		}
	}
end




---Migrates anchor blocks for all bar settings in the provided settings table.
---Synthesizes anchor blocks from legacy relativeTo/xPos/yPos/fullWidth fields.
---@param settingsTable table # The top-level settings table (e.g., TRB.Data.settings)
---@param forceResync boolean? # If true, re-synthesize all anchor blocks even if they already exist
function TRB.Functions.Settings:MigrateBarAnchors(settingsTable, forceResync)
	if not settingsTable then
		return
	end

	local anchorMap = TRB.Data.constants.relativeToAnchorMap

	local function MigrateOne(barSettings)
		if barSettings == nil then return end
		if barSettings.anchor ~= nil and not forceResync then return end
		-- When forceResync is true but the anchor block already has a valid barKey,
		-- trust it over stale legacy fields (fixes export/import losing screen anchors).
		if barSettings.anchor ~= nil and barSettings.anchor.barKey ~= nil then return end
		if barSettings.relativeTo then
			local mapping = anchorMap[barSettings.relativeTo]
			if mapping then
				barSettings.anchor = {
					barKey = "primary",
					anchorPoint = mapping.anchorPoint,
					attachPoint = mapping.attachPoint,
					xOffset = barSettings.xPos or 0,
					yOffset = barSettings.yPos or 0,
					matchWidth = barSettings.fullWidth or false,
					matchHeight = false,
				}
			end
		elseif barSettings.xPos ~= nil and barSettings.yPos ~= nil and barSettings.relativeTo == nil then
			-- Primary bar (has xPos/yPos but no relativeTo) → screen anchor
			barSettings.anchor = {
				barKey = "screen",
				anchorPoint = "CENTER",
				attachPoint = "CENTER",
				xOffset = barSettings.xPos or 0,
				yOffset = barSettings.yPos or -200,
				matchWidth = false,
				matchHeight = false,
			}
		end
	end

	for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
		local className = classEntry.className
		if settingsTable[className] then
			for specName, specSettings in pairs(settingsTable[className]) do
				if type(specSettings) == "table" then
					MigrateOne(specSettings.bar)
					MigrateOne(specSettings.comboPoints)
					MigrateOne(specSettings.healthBar)
					if specSettings.bars then
						for _, barDimSettings in pairs(specSettings.bars) do
							if type(barDimSettings) == "table" then
								MigrateOne(barDimSettings)
							end
						end
					end
				end
			end
		end
	end
end

---Gets the default textures for bars
---@param includeComboPoints boolean?
---@param includeManaBar boolean?
---@param customBars TRB.Classes.BarTypeDefinition[]?
---@return table
function TRB.Functions.Settings:DefaultTextures(includeComboPoints, includeManaBar, customBars)
	local textures = {
		background="Interface\\Tooltips\\UI-Tooltip-Background",
		backgroundName="Blizzard Tooltip",
		border="Interface\\Buttons\\WHITE8X8",
		borderName="1 Pixel",
		resourceBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		resourceBarName=L["LSMStatusBarSmoother"],
		textureLock=true,
		healthBackground="Interface\\Tooltips\\UI-Tooltip-Background",
		healthBackgroundName="Blizzard Tooltip",
		healthBorder="Interface\\Buttons\\WHITE8X8",
		healthBorderName="1 Pixel",
		healthBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		healthBarName=L["LSMStatusBarSmoother"],
		absorbBar="Interface\\Buttons\\WHITE8X8",
		absorbBarName="Solid",
		incomingHealBar="Interface\\Buttons\\WHITE8X8",
		incomingHealBarName="Solid",
		healAbsorbBar="Interface\\Buttons\\WHITE8X8",
		healAbsorbBarName="Solid",
		castingBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		castingBarName=L["LSMStatusBarSmoother"],
	}
	if includeComboPoints then
		textures.comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background"
		textures.comboPointsBackgroundName="Blizzard Tooltip"
		textures.comboPointsBorder="Interface\\Buttons\\WHITE8X8"
		textures.comboPointsBorderName="1 Pixel"
		textures.comboPointsBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
		textures.comboPointsBarName=L["LSMStatusBarSmoother"]
	end
	if includeManaBar then
		textures.manaBarBackground="Interface\\Tooltips\\UI-Tooltip-Background"
		textures.manaBarBackgroundName="Blizzard Tooltip"
		textures.manaBarBorder="Interface\\Buttons\\WHITE8X8"
		textures.manaBarBorderName="1 Pixel"
		textures.manaBarBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
		textures.manaBarBarName=L["LSMStatusBarSmoother"]
	end
	if customBars then
		for _, barTypeDef in ipairs(customBars) do
			local defaults = barTypeDef:GetDefaultTextures()
			local key = barTypeDef.key
			textures[key .. "Bar"] = defaults.bar
			textures[key .. "BarName"] = defaults.barName
			textures[key .. "Border"] = defaults.border
			textures[key .. "BorderName"] = defaults.borderName
			textures[key .. "Background"] = defaults.background
			textures[key .. "BackgroundName"] = defaults.backgroundName
		end
	end
	return textures
end

---Gets default settings for "End Of" buff tracking configuration
---@param mode "gcd"|"time" # Whether to use GCD count or time for the threshold
---@param gcdsMax number # Number of GCDs for the threshold (when mode is "gcd")
---@param timeMax number # Seconds for the threshold (when mode is "time")
---@param extraOptions table? # Optional table of additional options to merge into the result
---@return TRB.Classes.Settings.GenericTrackingOverX
function TRB.Functions.Settings:DefaultEndOfSettings(mode, gcdsMax, timeMax, extraOptions)
	local settings = {
		enabled = true,
		mode = mode or "gcd",
		gcdsMax = gcdsMax or 2,
		timeMax = timeMax or 3.0
	}

	if extraOptions then
		for k, v in pairs(extraOptions) do
			settings[k] = v
		end
	end

	return settings
end

---Marks a bar text entry to inherit all shared font settings by default.
---@param entry TRB.Classes.Settings.DisplayTextEntry
---@return TRB.Classes.Settings.DisplayTextEntry
function TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntry(entry)
	if entry ~= nil then
		entry.useDefaultFontColor = true
		entry.useDefaultFontFace = true
		entry.useDefaultFontSize = true
		entry.useDefaultFontOutline = true
		entry.useDefaultFontShadow = true
	end
	return entry
end

---Marks all bar text entries in a list to inherit shared font settings by default.
---@param textSettings TRB.Classes.Settings.DisplayTextEntry[]
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
	if textSettings ~= nil then
		for _, entry in ipairs(textSettings) do
			TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntry(entry)
		end
	end
	return textSettings
end

---Creates a default bar text entry for buff time display with icon
---@param variable string # The bar text variable name without $ (e.g., "bestialWrathTime")
---@param icon string # The icon reference without # (e.g., "bestialWrath")
---@param classic boolean # Whether to use classic layout
---@param classicPosition "LEFT"|"CENTER"|"RIGHT"? # Position for classic layout (default: CENTER)
---@param regularPosition "LEFT"|"CENTER"|"RIGHT"? # Position for regular layout (default: RIGHT)
---@return TRB.Classes.Settings.DisplayTextEntry
function TRB.Functions.Settings:DefaultBuffTimeBarTextEntry(variable, icon, classic, classicPosition, regularPosition)
	classicPosition = classicPosition or "CENTER"
	regularPosition = regularPosition or "RIGHT"

	---@param position "LEFT"|"CENTER"|"RIGHT"
	---@return TRB.Classes.Settings.DisplayTextEntry
	local function BuildEntry(position)
		local xPos = 0
		local name = L["PositionMiddle"]
		local fontJustifyHorizontalName = L["PositionCenter"]

		if position == "LEFT" then
			xPos = 2
			name = L["PositionLeft"]
			fontJustifyHorizontalName = L["PositionLeft"]
		elseif position == "RIGHT" then
			xPos = -2
			name = L["PositionRight"]
			fontJustifyHorizontalName = L["PositionRight"]
		end

		return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntry({
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = name,
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$" .. variable .. "}[#" .. icon .. "$" .. variable .. "]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = position,
			fontJustifyHorizontalName = fontJustifyHorizontalName,
			fontSize = 14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = xPos,
				yPos = 0,
				relativeTo = position,
				relativeToName = fontJustifyHorizontalName,
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		})
	end

	if classic then
		return BuildEntry(classicPosition)
	else
		return BuildEntry(regularPosition)
	end
end

---Get the locale-specific default font constants
---@return {fontFace: string, fontFaceName: string}
function TRB.Functions.Settings:DefaultFontConstants()
	local locale = GetLocale()
	if locale == "ruRU" then
		return {
			fontFace = "Fonts\\FRIZQT___CYR.TTF",
			fontFaceName = "Friz Quadrata TT",
		}
	elseif locale == "koKR" then
		return {
			fontFace = "Fonts\\2002.TTF",
			fontFaceName = "기본 글꼴",
		}
	elseif locale == "zhCN" then
		return {
			fontFace = "Fonts\\ARKai_T.ttf",
			fontFaceName = "默认",
		}
	elseif locale == "zhTW" then
		return {
			fontFace = "Fonts\\bLEI00D.TTF",
			fontFaceName = "預設",
		}
	else
		return {
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT"
		}
	end
end

TRB.Data.constants.defaultSettings.fonts = TRB.Functions.Settings:DefaultFontConstants()

---Gets the default settings for threshold icons
---@return table
function TRB.Functions.Settings:DefaultThresholdIconSettings()
	return {
		showCooldown = true,
		border = 2,
		relativeTo = "BOTTOM",
		relativeToName = L["ThresholdIconPositionBelowRight"],
		enabled = true,
		desaturated = true,
		xPos = 0,
		yPos = 12,
		width = 24,
		height = 24
	}
end

---Creates default per-threshold settings for a threshold dictionary entry.
---When `enabled` is false on a sub-entry (audio, individual color, icon, line),
---the global setting is used instead.
---@param isEnabled boolean # Whether the threshold is enabled by default
---@return TRB.Classes.Settings.ThresholdDictionaryEntry
function TRB.Functions.Settings:DefaultThresholdDictionaryEntry(isEnabled)
	return {
		enabled = isEnabled,
		audio = {
			enabled = false,
			sound = "",
			soundName = "",
		},
		colors = {
			under = {
				color = "FFFFFFFF",
				mode = "shared",
			},
			over = {
				color = "FF00FF00",
				mode = "shared",
			},
			unusable = {
				color = "FFFF0000",
				mode = "shared",
			},
			outOfRange = {
				color = "FF440000",
				mode = "shared",
			},
		},
		icon = {
			enabled = false,
			show = true,
			width = 24,
			height = 24,
			xPos = 0,
			yPos = 12,
			relativeTo = "BOTTOM",
			desaturated = true,
			border = 2,
		},
		line = {
			enabled = false,
			width = 2,
			overlapBorder = true,
		},
	}
end

---Creates default threshold line colors.
---@return TRB.Classes.Settings.ThresholdColors
function TRB.Functions.Settings:DefaultThresholdColors()
	return {
		under = {
			color = "FFFFFFFF"
		},
		over = {
			color = "FF00FF00"
		},
		unusable = {
			color = "FFFF0000",
			enabled = true,
			show = true
		},
		special = {
			color = "FFFF00FF",
			enabled = true
		},
		outOfRange = {
			color = "FF440000",
			enabled = true,
			show = true
		},
	}
end

---Creates default specialization threshold settings.
---@return TRB.Classes.Settings.Thresholds
function TRB.Functions.Settings:DefaultThresholdSettings()
	return {
		properties = {
			width = 2,
			overlapBorder = true,
		},
		icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
		specProperties = {},
		thresholdDictionary = {},
		customThresholds = {},
	}
end

---@param entry TRB.Classes.Settings.ThresholdDictionaryEntry?
---@param isEnabled boolean?
---@return TRB.Classes.Settings.ThresholdDictionaryEntry
function TRB.Functions.Settings:NormalizeThresholdDictionaryEntry(entry, isEnabled)
	local defaultEntry = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(isEnabled == true)
	if type(entry) ~= "table" then
		return defaultEntry
	end

	-- Backfill defaults into the EXISTING entry while preserving its table identity
	-- (and the identity of every nested table). The options color pickers capture
	-- references to entry.colors.under/over/staticColor; replacing the entry with a
	-- fresh DeepMergeCopy table would orphan those references, so live edits would
	-- neither apply in real time nor persist to disk. DeepMergeInto mutates in place.
	local merged = TRB.Functions.Table:DeepMergeCopy(defaultEntry, entry)
	TRB.Functions.Table:DeepMergeInto(entry, merged)
	return entry
end

---Custom thresholds use the shared thresholdDictionary entry shape, but a namespaced key
---keeps them from colliding with predefined spell threshold setting keys.
---@param guid string?
---@return string?
function TRB.Functions.Settings:GetCustomThresholdDictionaryKey(guid)
	if guid == nil then
		return nil
	end

	local key = tostring(guid)
	local prefix = "custom:"
	if string.sub(key, 1, string.len(prefix)) == prefix then
		return key
	end

	return prefix .. key
end

---@param customThreshold table?
---@param guid string?
---@return TRB.Classes.Settings.CustomThresholdLine
function TRB.Functions.Settings:NormalizeCustomThresholdLine(customThreshold, guid)
	local line = customThreshold
	if type(line) ~= "table" then
		line = {}
	end

	local resolvedGuid = line.guid or guid or TRB.Functions.String:Guid()
	line.guid = resolvedGuid
	line.name = line.name or L["CustomThresholdDefaultName"]
	line.barTarget = line.barTarget or "primary"
	line.value = tonumber(line.value) or 0
	line.valueMode = (line.valueMode == "offset") and "offset" or "absolute"
	line.iconSourceType = line.iconSourceType or "none"
	if line.iconSourceType ~= "spell" and line.iconSourceType ~= "item" and line.iconSourceType ~= "icon" and line.iconSourceType ~= "none" then
		line.iconSourceType = "none"
	end
	line.iconSourceId = tonumber(line.iconSourceId) or 0

	return line --[[@as TRB.Classes.Settings.CustomThresholdLine]]
end

---Seeds the counter cues the addon ships for a spec, once per counter source, then never again.
---
---Shipped cues cannot live in the defaults factories. `Table:Merge(defaults, saved)` only iterates
---`saved`, so a key present in `defaults` and absent from `saved` is never visited and simply
---survives -- meaning a cue the user deleted would come back on the next load. Seeding instead
---makes the cues user-owned from the moment they first appear, so deletion is permanent.
---
---The marker lives on the spec settings table. That is deliberate: it rides through the merge
---(saved wins), but Reset Defaults replaces the whole spec table with a fresh one that has no
---marker, so resetting restores the shipped set.
---@param spec table? # A single spec's settings table
---@param compositeKey string? # "className_specName"
function TRB.Functions.Settings:SeedAudioCues(spec, compositeKey)
	if spec == nil then
		return
	end

	local definition = TRB.Functions.AudioCues:GetDefinition(compositeKey)
	if definition == nil then
		return
	end

	spec.audio = spec.audio or {}
	spec.audioSeeded = spec.audioSeeded or {}

	for _, source in ipairs(definition.counters) do
		if not spec.audioSeeded[source.id] then
			spec.audioSeeded[source.id] = true
			for _, seed in ipairs(source.defaultCues or {}) do
				-- Existing users already hold these under the same ids, so this adds nothing for
				-- them; it only populates a spec seeing the source for the first time.
				if spec.audio[seed.id] == nil then
					spec.audio[seed.id] = {
						id = seed.id,
						kind = "counter",
						source = source.id,
						name = seed.name,
						enabled = seed.enabled,
						sound = seed.sound,
						soundName = seed.soundName,
						configuration = {
							thresholdValue = seed.thresholdValue,
						},
					}
				end
			end
		end
	end
end

---Runs SeedAudioCues across every spec in a settings table.
---@param settings table? # The full addon settings table
function TRB.Functions.Settings:SeedAllAudioCues(settings)
	if settings == nil then
		return
	end

	for compositeKey, entry in pairs(TRB.Data.specRegistry) do
		local class = settings[entry.className]
		if class ~= nil then
			TRB.Functions.Settings:SeedAudioCues(class[entry.specName], compositeKey)
		end
	end
end

---Brings a spec's `audio` table up to the current cue shape: stamps `id`/`kind`/`source` on every
---entry, maps pre-refactor counter keys onto their registered source, and drops entries the spec's
---cue registry no longer recognizes.
---
---Runs both on load (for saved settings) and after an import merge, so an export string produced
---before the refactor self-heals into the current shape.
---@param spec table? # A single spec's settings table
---@param compositeKey string? # "className_specName"
function TRB.Functions.Settings:NormalizeAudioCues(spec, compositeKey)
	if spec == nil or type(spec.audio) ~= "table" then
		return
	end

	local definition = TRB.Functions.AudioCues:GetDefinition(compositeKey)
	if definition == nil then
		return
	end

	local builtInIds = {}
	for _, builtIn in ipairs(definition.builtIns) do
		builtInIds[builtIn.id] = true
	end

	-- Pre-refactor counter keys (chiThreshold1, holyPowerThreshold2, ...) declared by each source.
	local legacyCounterSources = {}
	for _, source in ipairs(definition.counters) do
		for _, legacyId in ipairs(source.legacyIds or {}) do
			legacyCounterSources[legacyId] = source
		end
	end

	local knownSources = {}
	for _, source in ipairs(definition.counters) do
		knownSources[source.id] = true
	end

	for id, cue in pairs(spec.audio) do
		if type(cue) ~= "table" then
			spec.audio[id] = nil
		elseif builtInIds[id] then
			cue.id = id
			cue.kind = "builtin"
			cue.source = nil
		elseif legacyCounterSources[id] ~= nil then
			cue.id = id
			cue.kind = "counter"
			cue.source = legacyCounterSources[id].id
		elseif cue.kind == "counter" and knownSources[cue.source] then
			-- User-added cue from a current-shape save or import.
			cue.id = cue.id or id
		else
			-- Belongs to a spec that no longer declares it, or was never a real cue.
			spec.audio[id] = nil
		end
	end

	-- Counter cues need a threshold to compare against; built-ins get whatever config their registry
	-- entry declares, so consuming code can read cue.configuration.<key> without nil guards.
	for _, cue in pairs(spec.audio) do
		if cue.kind == "counter" then
			cue.configuration = cue.configuration or {}
			local source = TRB.Functions.AudioCues:GetCounterSource(compositeKey, cue.source)
			if cue.configuration.thresholdValue == nil and source ~= nil then
				cue.configuration.thresholdValue = source.min
			end
			if TRB.Functions.AudioCues:SourceSupportsPlayOnDrop(source) then
				if cue.configuration.playOnDrop == nil then
					cue.configuration.playOnDrop = false
				end
			else
				cue.configuration.playOnDrop = nil
			end
			cue.name = cue.name or (source and source.defaultName)
		else
			local builtIn = TRB.Functions.AudioCues:GetBuiltIn(compositeKey, cue.id)
			if builtIn ~= nil and builtIn.config ~= nil then
				cue.configuration = cue.configuration or {}
				for _, descriptor in ipairs(builtIn.config) do
					if cue.configuration[descriptor.key] == nil then
						cue.configuration[descriptor.key] = descriptor.default
					end
				end
			end
		end
	end

	TRB.Functions.AudioCues:InvalidateCache(spec)
end

---Runs NormalizeAudioCues across every spec in a settings table.
---@param settings table? # The full addon settings table
function TRB.Functions.Settings:NormalizeAllAudioCues(settings)
	if settings == nil then
		return
	end

	for compositeKey, entry in pairs(TRB.Data.specRegistry) do
		local class = settings[entry.className]
		if class ~= nil then
			TRB.Functions.Settings:NormalizeAudioCues(class[entry.specName], compositeKey)
		end
	end
end

---Brings a spec's `colors.shared` order lists in line with the indicators the spec defines today.
---
---`Table:Merge(defaults, saved)` and the profile overlays merge `nodeOrder`/`gradientOrder` by array
---index, so a saved list only ever picks up a new default by accident: a key appended at index N
---survives when the save has fewer than N entries and is overwritten otherwise. A key removed from the
---code but still in saves (Shadow's `shadowWordMadnessUsableCasting`) holds a slot, which is exactly
---how Resonant Energy went missing from lists that predate it.
---
---Every saved key lands in whichever list the defaults put it in (a gradient key stranded in `nodeOrder`
---moves over), duplicates collapse, and any default key the save lacks is appended -- lowest priority,
---with its default `indicatorColors` entry when the save has none. Keys the defaults no longer define
---stay where they are: the options panel hides them, the runtime has no condition for them, and a
---feature that comes back picks its saved priority and colors up again. Surviving keys keep their
---relative order, both lists keep their table identity, and nothing else in `indicatorColors` is touched.
---@param spec table? # A single spec's settings table
---@param defaultShared table? # That spec's default `colors.shared` (nodeOrder, gradientOrder, indicatorColors)
function TRB.Functions.Settings:ReconcileSharedIndicators(spec, defaultShared)
	if spec == nil or type(spec.colors) ~= "table" or type(spec.colors.shared) ~= "table" then
		return
	end
	if defaultShared == nil or type(defaultShared.nodeOrder) ~= "table" then
		return
	end

	local shared = spec.colors.shared
	local defaultGradientOrder = defaultShared.gradientOrder or {}
	local defaultIndicatorColors = defaultShared.indicatorColors or {}

	-- Which list the defaults keep each key in
	local listFor = {} ---@type table<string, string>
	for _, key in ipairs(defaultShared.nodeOrder) do
		listFor[key] = "nodeOrder"
	end
	for _, key in ipairs(defaultGradientOrder) do
		listFor[key] = "gradientOrder"
	end

	local seen = {} ---@type table<string, boolean>
	local result = { nodeOrder = {}, gradientOrder = {} } ---@type table<string, string[]>

	---Copies a saved list's not-yet-seen keys into the list the defaults assign them to; a key the
	---defaults don't know stays in the list it was saved in.
	---@param listName string
	local function Take(listName)
		if type(shared[listName]) ~= "table" then
			return
		end
		for _, key in ipairs(shared[listName]) do
			if not seen[key] then
				seen[key] = true
				table.insert(result[listFor[key] or listName], key)
			end
		end
	end

	Take("nodeOrder")
	Take("gradientOrder")

	shared.indicatorColors = shared.indicatorColors or {}

	---Appends the default keys the save never had, seeding their colors from the defaults.
	---@param defaultList string[]
	---@param target string
	local function Append(defaultList, target)
		for _, key in ipairs(defaultList) do
			if not seen[key] then
				seen[key] = true
				table.insert(result[target], key)
				if shared.indicatorColors[key] == nil and defaultIndicatorColors[key] ~= nil then
					shared.indicatorColors[key] = TRB.Functions.Table:DeepCopy(defaultIndicatorColors[key])
				end
			end
		end
	end

	Append(defaultShared.nodeOrder, "nodeOrder")
	Append(defaultGradientOrder, "gradientOrder")

	-- Refill in place: the options panel and spec caches hold on to these tables.
	for listName, keys in pairs(result) do
		if type(shared[listName]) == "table" then
			wipe(shared[listName])
		else
			shared[listName] = {}
		end
		for i, key in ipairs(keys) do
			shared[listName][i] = key
		end
	end
end

-- Default `colors.shared` per spec, keyed by compositeKey and kept for the session: the reconcile runs
-- once per stored profile plus twice on the live table at every login, and each class's defaults
-- factory builds the whole class. `false` marks a spec whose defaults define no shared indicators.
local sharedIndicatorDefaults = {} ---@type table<string, table|false>

---Returns a spec's default `colors.shared`, building and caching its whole class on first use.
---@param entry TRB.Data.SpecRegistryEntry
---@return table?
local function GetSharedIndicatorDefaults(entry)
	local cached = sharedIndicatorDefaults[entry.compositeKey]
	if cached ~= nil then
		return cached or nil
	end

	local options = TRB.Options and TRB.Options[entry.classModuleName]
	local classDefaults = nil
	if options ~= nil and type(options.LoadDefaultSettings) == "function" then
		local loaded = options.LoadDefaultSettings(false)
		classDefaults = loaded and loaded[entry.className] or nil
	end

	for _, specEntry in ipairs(TRB.Data.classRegistry[entry.className].specs) do
		local specDefaults = classDefaults and classDefaults[specEntry.specName] or nil
		local shared = nil
		if type(specDefaults) == "table" and type(specDefaults.colors) == "table" then
			shared = specDefaults.colors.shared
		end
		sharedIndicatorDefaults[specEntry.compositeKey] = shared or false
	end

	return sharedIndicatorDefaults[entry.compositeKey] or nil
end

---Runs ReconcileSharedIndicators across every spec in a settings table.
---@param settings table? # The full addon settings table, or a profile shaped like one
function TRB.Functions.Settings:ReconcileAllSharedIndicators(settings)
	if settings == nil then
		return
	end

	for _, entry in pairs(TRB.Data.specRegistry) do
		local class = settings[entry.className]
		local spec = class ~= nil and class[entry.specName] or nil
		if type(spec) == "table" then
			TRB.Functions.Settings:ReconcileSharedIndicators(spec, GetSharedIndicatorDefaults(entry))
		end
	end
end

---Returns default bar text for the health bar
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	if classic then
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$health/$healthMax $healthPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "HealthBar",
				relativeToFrameName = L["HealthBar"]
			}
		})
	else
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$healthPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "HealthBar",
				relativeToFrameName = L["HealthBar"]
			}
		})
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$health",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "HealthBar",
				relativeToFrameName = L["HealthBar"]
			}
		})
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end


---Returns default global bar text
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultGlobalBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			fontJustifyHorizontalName = "Center",
			text = "{$inCombatTime}[$inCombatTime]",
			useDefaultFontColor = false,
			fontFaceName = "Friz Quadrata TT",
			name = "Combat Time",
			position = {
				relativeToName = "Center",
				relativeTo = "CENTER",
				xPos = -400,
				relativeToFrameName = "Screen",
				yPos = -200,
				relativeToFrame = "UIParent",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			color = {
				color = "fffe7878",
			},
			fontSize = 48,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
	}

	local extraTextSettings = TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end

	-- Other Bars timers, one readout each. Feign Death is Hunter-only and lives in those specs' own bar
	-- text instead, so it is absent here. Existing users get these through the otherBarsText migration --
	-- keep the two lists in step, or they will be seeded twice. The GCD's ships disabled: its bar is thin
	-- and recycles every ~1.5s, so the readout is seeded ready to turn on rather than on by default.
	table.insert(textSettings, TRB.Functions.Settings:LoadDefaultOtherBarTextSettings("GcdBar", L["ResourceGcd"], "$gcdDurationRemaining", "RIGHT", 10, false))
	table.insert(textSettings, TRB.Functions.Settings:LoadDefaultOtherBarTextSettings("FatigueBar", L["ResourceFatigue"], "$fatigueDurationRemaining", "CENTER", 12))
	table.insert(textSettings, TRB.Functions.Settings:LoadDefaultOtherBarTextSettings("BreathBar", L["ResourceBreath"], "$breathDurationRemaining", "CENTER", 12))

	textSettings = TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)

	-- We don't want to apply shared font defaults to cast bar text settings because they have their own defaults that are different from the global defaults
	local castBarTextSettings = TRB.Functions.Settings:LoadDefaultCastBarTextSettings()

	for x = 1, #castBarTextSettings do
		table.insert(textSettings, castBarTextSettings[x])
	end

	-- Target and Focus Cast Bar text carries its own font sizes too. Existing users get it through the
	-- targetCastBarText and focusCastBarText migrations.
	for _, entry in ipairs(TRB.Functions.Settings:LoadDefaultTargetCastBarTextSettings()) do
		table.insert(textSettings, entry)
	end
	for _, entry in ipairs(TRB.Functions.Settings:LoadDefaultFocusCastBarTextSettings()) do
		table.insert(textSettings, entry)
	end
	return textSettings
end

---Returns default bar text for the Cast Bar
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultCastBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = true,
			useDefaultFontFace = true,
			useDefaultFontSize = false,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = true,
			maxWidthPercent = 75,
			text = "$castSpellName",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize = 18,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 6,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "CastBar",
				relativeToFrameName = L["CastBar"]
			}
		},
		{
			useDefaultFontColor = true,
			useDefaultFontFace = true,
			useDefaultFontSize = true,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$castTime>0}[{$castPushback>0}[||cFFFF00FF$castPushback||r + ] $castTimeRemaining / $castTime]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize = 14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "CastBar",
				relativeToFrameName = L["CastBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = true,
			useDefaultFontSize = false,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			enabled = true,
			name = L["PositionBottomRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "$castLatencyMs",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize = 10,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFF0000" },
			position = {
				xPos = -2,
				yPos = 2,
				relativeTo = "BOTTOMRIGHT",
				relativeToName = L["PositionBottomRight"],
				relativeToFrame = "CastBar",
				relativeToFrameName = L["CastBar"]
			}
		}
	}

	return textSettings
end

---Returns default bar text for a secondary mana bar (used by DPS casters like Shadow Priest, Balance Druid, Elemental Shaman)
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultManaBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}

	if classic then
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$mana/$manaMax $manaPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "ManaBar",
				relativeToFrameName = L["ManaBar"]
			}
		})
	else
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$manaPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "ManaBar",
				relativeToFrameName = L["ManaBar"]
			}
		})
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text="$mana",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "ManaBar",
				relativeToFrameName = L["ManaBar"]
			}
		})
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end


---@alias trbIncludeResourceType
---| '"resource"' # Generic $resource centered
---| '"mana"' # $mana% left, $mana / $manaMax right on Resource Bar
---| '"manaBar"' # $mana% left, $mana right on Mana Bar

---Adds default bar text that is used globally
---@param includeResourceType trbIncludeResourceType?
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings(includeResourceType, classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}

	local relativeToFrame = "Resource"
	local relativeToFrameName = L["MainResourceBar"]
	if includeResourceType == "manaBar" then
		relativeToFrame = "ManaBar"
		relativeToFrameName = L["ManaBar"]
	end

	if includeResourceType == "resource" then
		if classic then
			table.insert(textSettings, {
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				constrainToParent = false,
				maxWidthPercent = 100,
				text="{$casting}[#casting$casting+]$resource",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=20,
				fontOutline = "OUTLINE",
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
				color = { color = "FFFFFFFF" },
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = L["PositionRight"],
					relativeToFrame = "Resource",
					relativeToFrameName = L["MainResourceBar"]
				}
			})
		else
			table.insert(textSettings,
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionMiddle"],
				guid = TRB.Functions.String:Guid(),
				constrainToParent = false,
				maxWidthPercent = 100,
				text="$resource",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = L["PositionCenter"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
				color = { color = "FFFFFFFF" },
				position = {
					xPos = 0,
					yPos = 0,
					relativeTo = "CENTER",
					relativeToName = L["PositionCenter"],
					relativeToFrame = "Resource",
					relativeToFrameName = L["MainResourceBar"]
				}
			})
		end
	elseif includeResourceType == "mana" or includeResourceType == "manaBar" then
		if classic then
			table.insert(textSettings, {
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				constrainToParent = false,
				maxWidthPercent = 100,
				text="{$casting}[#casting$casting+]$mana/$manaMax $manaPercent%",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
				color = { color = "FFFFFFFF" },
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = L["PositionRight"],
					relativeToFrame = relativeToFrame,
					relativeToFrameName = relativeToFrameName
				}
			})
		else
			table.insert(textSettings,
			{
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionLeft"],
				guid = TRB.Functions.String:Guid(),
				constrainToParent = false,
				maxWidthPercent = 100,
				text="$manaPercent%",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
				color = { color = "FFFFFFFF" },
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = L["PositionLeft"],
					relativeToFrame = relativeToFrame,
					relativeToFrameName = relativeToFrameName
				}
			})
			table.insert(textSettings, {
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				constrainToParent = false,
				maxWidthPercent = 100,
				text="$mana",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
				color = { color = "FFFFFFFF" },
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = L["PositionRight"],
					relativeToFrame = relativeToFrame,
					relativeToFrameName = relativeToFrameName
				}
			})
		end
	end

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
