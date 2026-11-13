local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Indicators = TRB.Functions.OptionsUi.Indicators or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Indicator colors options
-- ============================================================================

local gradientDirectionCycle = { "disabled", "horizontal", "vertical" }
local gradientDirectionAbbrevLabels = {
	disabled = L["GradientDirectionDisabledAbbrev"],
	horizontal = L["GradientDirectionHorizontalAbbrev"],
	vertical = L["GradientDirectionVerticalAbbrev"],
}

-- The elements a bar target offers when it doesn't name its own set: every spec-owned resource bar.
local defaultElementDefs = {
	{ key = "bar", label = L["BarElementBar"] },
	{ key = "border", label = L["BarElementBorder"] },
	{ key = "background", label = L["BarElementBackground"] },
	{ key = "endCap", label = L["EndCap"] },
}

-- Every flat and gradient row leaves room for the Remove and Edit buttons, so all the arrows line up.
local customColumnWidth = 46
local targetsDropdownWidth = 254

---@type TRB.Classes.OptionsUi.CdmPickerWording
local pickerWording = {
	otherClass = L["CustomIndicatorOtherClassTooltip"],
	otherSpec = L["CustomIndicatorOtherSpecTooltip"],
	disabled = L["CustomIndicatorCdmDisabledTooltip"],
	notLearned = L["CustomIndicatorNotLearnedTooltip"],
	notDisplayed = L["CustomIndicatorNotDisplayedTooltip"],
}

local ThresholdState = TRB.Functions.Threshold.ConditionState

local thresholdStateLabels = {
	[ThresholdState.USABLE] = L["ThresholdIndicatorStateUsable"],
	[ThresholdState.UNUSABLE] = L["ThresholdIndicatorStateUnusable"],
	[ThresholdState.ON_COOLDOWN] = L["ThresholdIndicatorStateOnCooldown"],
	[ThresholdState.OUT_OF_RANGE] = L["ThresholdIndicatorStateOutOfRange"],
	[ThresholdState.IN_RANGE] = L["ThresholdIndicatorStateInRange"],
	[ThresholdState.STATIC] = L["ThresholdIndicatorStateStatic"],
}

local thresholdStateRowFormats = {
	[ThresholdState.USABLE] = L["ThresholdIndicatorUsableFormat"],
	[ThresholdState.UNUSABLE] = L["ThresholdIndicatorUnusableFormat"],
	[ThresholdState.ON_COOLDOWN] = L["ThresholdIndicatorOnCooldownFormat"],
	[ThresholdState.OUT_OF_RANGE] = L["ThresholdIndicatorOutOfRangeFormat"],
	[ThresholdState.IN_RANGE] = L["ThresholdIndicatorInRangeFormat"],
	[ThresholdState.STATIC] = L["ThresholdIndicatorStaticFormat"],
}

-- A square swatch tinted by the trailing RGB triplet; colored menu text can be unreadable on the dark menu.
local stateSwatchMarkup = "|TInterface\\Buttons\\WHITE8X8:12:12:0:0:8:8:0:8:0:8:%d:%d:%d|t %s"

local thresholdStateTooltips = {
	[ThresholdState.OUT_OF_RANGE] = L["ThresholdIndicatorOutOfRangeTooltip"],
	[ThresholdState.IN_RANGE] = L["ThresholdIndicatorInRangeTooltip"],
	[ThresholdState.STATIC] = L["ThresholdIndicatorStaticTooltip"],
}

-- Each state's color as the Thresholds tab names it.
local thresholdStateColorNames = {
	[ThresholdState.USABLE] = L["ThresholdDetailColorsOver"],
	[ThresholdState.UNUSABLE] = L["ThresholdDetailColorsUnder"],
	[ThresholdState.ON_COOLDOWN] = L["ThresholdDetailColorsUnusable"],
	[ThresholdState.OUT_OF_RANGE] = L["ThresholdDetailColorsOutOfRange"],
	[ThresholdState.IN_RANGE] = L["ThresholdDetailColorsOver"],
	[ThresholdState.STATIC] = L["ThresholdDetailColorModeStatic"],
}

StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteCustomIndicator"] = {
	text = "%s",
	button1 = L["CustomIndicatorDelete"],
	button2 = CANCEL,
	OnAccept = function(self, data)
		if data ~= nil and data.remove ~= nil then
			data.remove()
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

---Turns a target menu scrollable when the rows it is about to draw would overflow the screen.
---@param rootDescription table The root menu description being populated
---@param barTargetDefs TRB.Classes.OptionsUi.BarTargetDef[] The bars the menu offers
---@param isExcluded fun(barDef: table, elemKey: string): boolean Whether an element is omitted from the menu
---@param hasGlowRow boolean? Whether every bar section also draws the Border Glow submenu row
local function ApplyTargetMenuScrollMode(rootDescription, barTargetDefs, isExcluded, hasGlowRow)
	if not rootDescription.SetScrollMode then
		return
	end

	local rows = 0
	for _, barDef in ipairs(barTargetDefs) do
		local sectionRows = hasGlowRow and 1 or 0
		for _, elemDef in ipairs(barDef.elements or defaultElementDefs) do
			if not isExcluded(barDef, elemDef.key) then
				sectionRows = sectionRows + 1
			end
		end
		if sectionRows > 0 then
			-- The section's title row, and the divider drawn ahead of every section but the first.
			rows = rows + sectionRows + (rows > 0 and 2 or 1)
		end
	end

	TRB.Functions.OptionsUi.Primitives:LimitMenuRows(rootDescription, rows)
end

---Builds the Border Glow submenu for one bar in a flat indicator's target menu. Any number of glows can be
---checked and all of them run at once; a glow that pins its own color is marked as such in the list.
---@param rootDescription table The bar section being populated
---@param getTargets fun(): table? Resolves the indicator's target table for this bar, live
---@param onChanged fun() Runs after a pick, to resync the row's summary and enabled state
local function CreateBorderGlowSubmenu(rootDescription, getTargets, onChanged)
	local submenu = rootDescription:CreateButton(L["BarElementBorderGlow"])
	if type(submenu) ~= "table" or type(submenu.CreateCheckbox) ~= "function" then
		return
	end

	local glows = TRB.Functions.Glow:GetOrdered()

	-- Blizzard bakes the label in at creation; a glow toggle's Refresh re-runs this, keeping the count live.
	submenu:AddInitializer(function(button)
		local targets = getTargets()
		local count = 0
		if targets ~= nil and targets.glows ~= nil then
			for _, glow in ipairs(glows) do
				if targets.glows[glow.guid] then
					count = count + 1
				end
			end
		end
		button.fontString:SetTextToFit(L["BarElementBorderGlow"] .. " (" .. count .. ")")
	end)

	if #glows == 0 then
		submenu:CreateTitle(L["GlowIndicatorNoneDefined"])
		return
	end

	for _, glow in ipairs(glows) do
		local guid = glow.guid
		local label = glow.name or L["GlowDefaultName"]
		if glow.useCustomColor then
			label = label .. L["GlowIndicatorFixedColorSuffix"]
		end

		submenu:CreateCheckbox(label, function()
			local targets = getTargets()
			return (targets ~= nil and targets.glows ~= nil and targets.glows[guid]) or false
		end, function()
			local targets = getTargets()
			if targets == nil then
				return
			end
			targets.glows = targets.glows or {}
			-- Cleared to nil rather than false, so an empty selection is an empty table.
			targets.glows[guid] = (not targets.glows[guid]) or nil
			onChanged()
		end)
	end
end

---The bar targets every spec gets for free: the health bar and the cast bar. Appended to whatever bars the
---spec itself declares, so these don't have to be hand-wired into all 40 spec option panels.
---Neither offers a plain "Bar" element: the health bar's fill is a health-threshold curve, and the cast
---bar's is driven per cast state, so it splits into its two states instead.
---@param classId integer
---@param specId integer
---@return TRB.Classes.OptionsUi.BarTargetDef[]
local function BuildSharedBarTargetDefs(classId, specId)
	local castbarElements = {
		{ key = "bar", label = L["BarElementBarHardcast"] },
		{ key = "channel", label = L["BarElementBarChanneled"] },
		{ key = "border", label = L["BarElementBorder"] },
		{ key = "background", label = L["BarElementBackground"] },
		{ key = "endCap", label = L["EndCap"] },
		-- Every spec can channel something with ticks, like a bandage or a racial.
		{ key = "tick", label = L["BarElementChanneledTick"] },
	}

	-- Gradient indicators are a step curve over the spec's own resource, painted onto whichever bar is
	-- targeted -- the same way the overcap gradient already colors, say, the Stagger bar's border from
	-- Energy. Borders and backgrounds are plain node colors and can take that curve. The rest can't: the
	-- health bar's fill is already a health curve, the cast bar's fill is driven per cast state, and the
	-- channel ticks are drawn textures rather than a node color.
	local defs = {
		{
			key = "healthBar",
			label = L["BarVisibilityBarNameHealth"],
			elements = {
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		},
		{
			key = "castbar",
			label = L["ResourcePlayerCastbar"],
			elements = castbarElements,
			gradientExcluded = { bar = true, channel = true, tick = true }
		},
		-- Target/Focus cast bars: only border/background/endCap are targetable (the fill is secret-driven
		-- per cast state), and all three take a gradient curve, same as the health bar's elements.
		{
			key = "targetCastbar",
			label = L["BarVisibilityBarNameTargetCastbar"],
			elements = {
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		},
		{
			key = "focusCastbar",
			label = L["BarVisibilityBarNameFocusCastbar"],
			elements = {
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		},
	}

	-- Pet bars on specs with a pet. The Pet Cast Bar splits its fill by cast state like the player's, and
	-- Pet Health offers no Bar element, as on the player's own.
	if TRB.Classes.BarTypeRegistry:SpecHasPet(classId, specId) then
		defs[#defs + 1] = {
			key = "petCastbar",
			label = L["ResourcePetCastbar"],
			elements = {
				{ key = "bar", label = L["BarElementBarHardcast"] },
				{ key = "channel", label = L["BarElementBarChanneled"] },
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
				{ key = "tick", label = L["BarElementChanneledTick"] },
			},
			gradientExcluded = { bar = true, channel = true }
		}
		defs[#defs + 1] = {
			key = "petPowerBar",
			label = L["ResourcePetPower"],
			elements = {
				{ key = "bar", label = L["BarElementBar"] },
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		}
		defs[#defs + 1] = {
			key = "petHealthBar",
			label = L["ResourcePetHealth"],
			elements = {
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		}
	end

	-- The Totems bar on specs with it. Its fill is per slot (element colors and Ending), so it offers no Bar element.
	if TRB.Classes.BarTypeRegistry:SpecHasTotems(classId, specId) then
		defs[#defs + 1] = {
			key = "totemsBar",
			label = L["ResourceTotems"],
			elements = {
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		}
	end

	return defs
end

---Generates the complete Indicator Colors panel for a specialization.
---This centralizes the boilerplate UI for flat indicator rows, gradient indicator rows,
---optional EndOf configuration sections, and optional overcap configuration.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table (must contain colors.shared.indicatorColors, nodeOrder, gradientOrder)
---@param classId integer The class ID
---@param specId integer The spec ID
---@param yCoord number The current Y coordinate for layout positioning
---@param config TRB.Classes.OptionsUi.IndicatorColorsPanelConfig Configuration for the Indicator Colors panel
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, config)
	local indicatorDefs = config.indicatorDefs
	local gradientDefs = config.gradientDefs or {}
	local excludedElements = config.excludedElements or {}
	local gradientExcludedElements = config.gradientExcludedElements or {}
	local ddNamePrefix = config.ddNamePrefix

	-- The spec's own bars, then the health bar and cast bar every spec shares. Built into a new list so the
	-- caller's config table isn't mutated -- the panel is regenerated each time it's opened.
	local barTargetDefs = {}
	for _, barDef in ipairs(config.barTargetDefs) do
		barTargetDefs[#barTargetDefs + 1] = barDef
	end
	for _, barDef in ipairs(BuildSharedBarTargetDefs(classId, specId)) do
		barTargetDefs[#barTargetDefs + 1] = barDef
	end

	---The bars an indicator's target menu offers: all of them, or only the ones its def names.
	---@param def TRB.Classes.OptionsUi.IndicatorDef?
	---@return TRB.Classes.OptionsUi.BarTargetDef[]
	local function GetBarTargetDefsFor(def)
		if def == nil or def.barKeys == nil then
			return barTargetDefs
		end
		local allowed = {}
		for _, barDef in ipairs(barTargetDefs) do
			for _, barKey in ipairs(def.barKeys) do
				if barKey == barDef.key then
					allowed[#allowed + 1] = barDef
					break
				end
			end
		end
		return allowed
	end

	-- Build a quick lookup from key -> indicatorDef
	local indicatorDefByKey = {}
	for _, def in ipairs(indicatorDefs) do
		indicatorDefByKey[def.key] = def
	end
	for _, def in ipairs(gradientDefs) do
		indicatorDefByKey[def.key] = def
	end

	local sharedSettings = spec.colors.shared
	local indicatorColors = sharedSettings.indicatorColors

	-- Custom indicators have no def in spec code; give each one so it lists and reorders with the rest. A copy
	-- shares its built-in's def.
	for _, list in ipairs({ sharedSettings.nodeOrder, sharedSettings.gradientOrder or {} }) do
		for _, k in ipairs(list) do
			local indicator = indicatorColors[k]
			if indicator ~= nil and indicator.custom ~= nil then
				indicatorDefByKey[k] = { key = k, custom = true, colorLabel = "" }
			elseif indicator ~= nil and indicator.copyOf ~= nil then
				indicatorDefByKey[k] = indicatorDefByKey[indicator.copyOf]
			end
		end
	end

	---Built-in defs sorted by their row label, for the Add Built-in menus.
	---@param defs TRB.Classes.OptionsUi.IndicatorDef[]
	---@return TRB.Classes.OptionsUi.IndicatorDef[]
	local function SortDefsByLabel(defs)
		local sorted = {}
		for _, def in ipairs(defs) do
			sorted[#sorted + 1] = def
		end
		table.sort(sorted, function(a, b)
			local aLabel = (a.colorLabel or a.key):lower()
			local bLabel = (b.colorLabel or b.key):lower()
			if aLabel == bLabel then
				return a.key < b.key
			end
			return aLabel < bLabel
		end)
		return sorted
	end

	local sortedIndicatorDefs = SortDefsByLabel(indicatorDefs)
	local sortedGradientDefs = SortDefsByLabel(gradientDefs)

	local defaultShared = TRB.Functions.Settings:GetDefaultSharedIndicators(TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId))

	---A built-in's default entry, or nil when it has none.
	---@param builtInKey string
	---@return table?
	local function GetDefaultEntry(builtInKey)
		return defaultShared ~= nil and defaultShared.indicatorColors ~= nil and defaultShared.indicatorColors[builtInKey] or nil
	end

	---Targets with every element a built-in targets by default set false, so the login's merge over the defaults
	---can't turn them back on.
	---@param builtInKey string
	---@return table
	local function UntargetedBuiltIn(builtInKey)
		local targets = {}
		local defaultEntry = GetDefaultEntry(builtInKey)
		for barKey, elements in pairs(defaultEntry ~= nil and defaultEntry.targets or {}) do
			targets[barKey] = {}
			for elemKey, isTargeted in pairs(elements) do
				if type(isTargeted) == "boolean" then
					targets[barKey][elemKey] = false
				end
			end
		end
		return targets
	end

	---A built-in's default entry, untargeted and off, for a restored built-in or a copy; nil when it has none.
	---@param builtInKey string
	---@return table?
	local function NewBuiltInEntry(builtInKey)
		local source = GetDefaultEntry(builtInKey) or indicatorColors[builtInKey]
		if source == nil then
			return nil
		end
		local entry = TRB.Functions.Table:DeepCopy(source)
		entry.enabled = false
		entry.targets = UntargetedBuiltIn(builtInKey)
		entry.color2 = entry.color2 or entry.color
		entry.gradientDirection = entry.gradientDirection or "disabled"
		return entry
	end

	---The first free `<prefix><n>` key.
	---@param prefix string
	---@return string
	local function NextIndicatorKey(prefix)
		local n = 1
		while indicatorColors[prefix .. n] ~= nil do
			n = n + 1
		end
		return prefix .. n
	end

	---The key and entry for adding a built-in: its own key back when it was deleted, else a new copy.
	---@param builtInKey string
	---@return string? key
	---@return table? entry
	local function PrepareBuiltInRow(builtInKey)
		local entry = NewBuiltInEntry(builtInKey)
		if entry == nil then
			return nil, nil
		end
		local removed = sharedSettings.removed
		if removed ~= nil and removed[builtInKey] then
			removed[builtInKey] = nil
			return builtInKey, entry
		end
		entry.copyOf = builtInKey
		return NextIndicatorKey("copy_"), entry
	end

	---Takes a row out of its list: a custom indicator or copy is deleted, and a built-in is recorded as removed
	---so the settings reconcile doesn't add it back.
	---@param key string
	---@param list string[]
	local function DeleteIndicatorEntry(key, list)
		for i, k in ipairs(list) do
			if k == key then
				table.remove(list, i)
				break
			end
		end
		local indicator = indicatorColors[key]
		if indicator == nil then
			return
		end
		if indicator.custom ~= nil or indicator.copyOf ~= nil then
			indicatorColors[key] = nil
			indicatorDefByKey[key] = nil
		else
			sharedSettings.removed = sharedSettings.removed or {}
			sharedSettings.removed[key] = true
			indicator.enabled = false
			indicator.targets = UntargetedBuiltIn(key)
		end
	end

	---@param indicator table?
	---@param modifier string # A TRB.IndicatorModifiers field
	---@return boolean
	local function HasModifier(indicator, modifier)
		return indicator ~= nil and indicator.modifiers ~= nil and indicator.modifiers[modifier] == true
	end

	---Turns one of a row's modifiers on or off. Off is saved as false when the row's built-in has it on by default, so the
	---login's merge over the defaults can't turn it back on; otherwise the key goes, and an emptied modifiers table with it.
	---@param indicator table
	---@param modifier string # A TRB.IndicatorModifiers field
	---@param enabled boolean
	---@param defaultEntry table? # The row's built-in's default entry
	local function SetModifier(indicator, modifier, enabled, defaultEntry)
		if enabled then
			indicator.modifiers = indicator.modifiers or {}
			indicator.modifiers[modifier] = true
		elseif defaultEntry ~= nil and defaultEntry.modifiers ~= nil and defaultEntry.modifiers[modifier] == true then
			indicator.modifiers = indicator.modifiers or {}
			indicator.modifiers[modifier] = false
		elseif indicator.modifiers ~= nil then
			indicator.modifiers[modifier] = nil
			if next(indicator.modifiers) == nil then
				indicator.modifiers = nil
			end
		end
	end

	---A copy of a row's modifiers for an entry following another built-in: each modifier that built-in has on by default
	---and the row leaves unset is saved false, so the login's merge over the defaults can't turn it on.
	---@param modifiers TRB.IndicatorModifiers?
	---@param defaultEntry table? # The built-in's default entry
	---@return TRB.IndicatorModifiers?
	local function ModifiersOverDefault(modifiers, defaultEntry)
		local out = TRB.Functions.Table:DeepCopy(modifiers)
		for modifier, on in pairs(defaultEntry ~= nil and defaultEntry.modifiers or {}) do
			if on == true and (out == nil or out[modifier] == nil) then
				out = out or {}
				out[modifier] = false
			end
		end
		return out
	end

	---A flat row's label, marked with its modifiers.
	---@param indicator table
	---@param colorLabel string
	---@return string
	local function ModifiedRowLabel(indicator, colorLabel)
		local text = colorLabel
		if HasModifier(indicator, "notActive") then
			text = string.format(L["IndicatorNotActiveLabelFormat"], text)
		end
		if HasModifier(indicator, "onlyInCombat") then
			text = string.format(L["IndicatorOnlyInCombatLabelFormat"], text)
		end
		return text
	end

	---Fills a menu with built-ins, sorted by row label, each with its tooltip. With a current built-in they are radios.
	---@param description table
	---@param defs TRB.Classes.OptionsUi.IndicatorDef[]
	---@param currentBuiltInKey string?
	---@param onPick fun(builtInKey: string)
	local function PopulateBuiltInPicker(description, defs, currentBuiltInKey, onPick)
		for _, def in ipairs(defs) do
			local button
			if currentBuiltInKey == nil then
				button = description:CreateButton(def.colorLabel or def.key, function()
					onPick(def.key)
				end)
			else
				button = description:CreateRadio(def.colorLabel or def.key, function()
					return def.key == currentBuiltInKey
				end, function()
					onPick(def.key)
					return MenuResponse.Close
				end)
			end
			if def.tooltip ~= nil then
				button:SetTooltip(function(tooltipFrame)
					tooltipFrame:SetText(def.tooltip, 1, 1, 1, 1, true)
				end)
			end
		end
		TRB.Functions.OptionsUi.Primitives:LimitMenuRows(description, #defs)
	end

	---Opens a row's Edit menu: Change Source, then the modifiers the row offers.
	---@param owner Frame
	---@param getIndicator fun(): table?, string? # The row's entry and key, read live
	---@param source TRB.Classes.OptionsUi.IndicatorEditSource
	---@param offerNotActive boolean
	---@param offerOnlyInCombat boolean
	---@param onModifierChanged fun()?
	local function OpenEditMenu(owner, getIndicator, source, offerNotActive, offerOnlyInCombat, onModifierChanged)
		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			local sourceButton = rootDescription:CreateButton(L["IndicatorEditChangeSource"], source.click)
			local sourceTooltip = source.block or source.tooltip
			if source.block ~= nil then
				sourceButton:SetEnabled(false)
			elseif source.populate ~= nil then
				source.populate(sourceButton)
			end
			if sourceTooltip ~= nil then
				sourceButton:SetTooltip(function(tooltipFrame)
					tooltipFrame:SetText(sourceTooltip, 1, 1, 1, 1, true)
				end)
			end

			local function AddModifier(modifier, label, tooltip)
				local checkbox = rootDescription:CreateCheckbox(label, function()
					return HasModifier(getIndicator(), modifier)
				end, function()
					local indicator, key = getIndicator()
					if indicator == nil then return end
					SetModifier(indicator, modifier, not HasModifier(indicator, modifier), GetDefaultEntry(indicator.copyOf or key or ""))
					if onModifierChanged ~= nil then
						onModifierChanged()
					end
				end)
				checkbox:SetTooltip(function(tooltipFrame)
					tooltipFrame:SetText(tooltip, 1, 1, 1, 1, true)
				end)
			end
			if offerNotActive or offerOnlyInCombat then
				rootDescription:CreateDivider()
				rootDescription:CreateTitle(L["IndicatorEditModifiers"])
			end
			if offerNotActive then
				AddModifier("notActive", L["IndicatorModifierNotActive"], L["IndicatorModifierNotActiveTooltip"])
			end
			if offerOnlyInCombat then
				AddModifier("onlyInCombat", L["IndicatorModifierOnlyInCombat"], L["IndicatorModifierOnlyInCombatTooltip"])
			end
		end)
	end

	---Whether an element is off-limits to a flat indicator row, because the panel excludes it outright.
	---@param barDef table
	---@param elemKey string
	---@return boolean
	local function IsExcluded(barDef, elemKey)
		local excluded = excludedElements[barDef.key]
		return (excluded and excluded[elemKey]) or false
	end

	---An element is off-limits to a gradient row if the panel excludes it outright, the caller excludes it
	---from gradients, or the bar itself declares it can't take a color curve.
	---@param barDef table
	---@param elemKey string
	---@return boolean
	local function IsGradientExcluded(barDef, elemKey)
		local gradExcluded = gradientExcludedElements[barDef.key]
		local barExcluded = barDef.gradientExcluded
		return IsExcluded(barDef, elemKey)
			or (gradExcluded and gradExcluded[elemKey])
			or (barExcluded and barExcluded[elemKey]) or false
	end

	-- Working copy of the ordered keys (survives reordering within this panel's lifetime)
	-- Filter out any keys that have no matching indicatorDef or no indicatorColors entry
	-- to keep the row count and the up/down arrow bounds in sync.
	local orderedKeys = {}
	for _, k in ipairs(sharedSettings.nodeOrder) do
		if indicatorDefByKey[k] and indicatorColors[k] then
			orderedKeys[#orderedKeys + 1] = k
		end
	end

	-- Per-row UI element references (indexed by row position, NOT by key)
	local rows = {}

	controls.indicatorColors = controls.indicatorColors or {}
	controls.indicatorColors.rows = controls.indicatorColors.rows or {}

	-- Section header
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["IndicatorColorPriorityHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30

	---Gets a summary string of enabled targets for a given indicator
	---@param indicatorKey string
	---@return string
	local function GetSummaryText(indicatorKey)
		local indicator = indicatorColors[indicatorKey]
		if not indicator or not indicator.targets then
			return L["BarNameDisabled"]
		end
		local parts = {}
		for _, barDef in ipairs(barTargetDefs) do
			local barTargets = indicator.targets[barDef.key]
			if barTargets then
				local elements = {}
				for _, elemDef in ipairs(barDef.elements or defaultElementDefs) do
					if barTargets[elemDef.key] then
						table.insert(elements, elemDef.label)
					end
				end
				if barTargets.glows ~= nil then
					local glowNames = {}
					for _, glow in ipairs(TRB.Functions.Glow:GetOrdered()) do
						if barTargets.glows[glow.guid] then
							table.insert(glowNames, glow.name or L["GlowDefaultName"])
						end
					end
					if #glowNames > 0 then
						table.insert(elements, L["BarElementBorderGlow"] .. " (" .. table.concat(glowNames, ", ") .. ")")
					end
				end
				if #elements > 0 then
					table.insert(parts, barDef.label .. ": " .. table.concat(elements, ", "))
				end
			end
		end
		if #parts == 0 then
			return L["BarNameDisabled"]
		end
		return table.concat(parts, "; ")
	end

	---Whether any bar element is currently targeted by this indicator.
	---@param indicator table?
	---@return boolean
	local function HasAnyTarget(indicator)
		if not indicator or not indicator.targets then
			return false
		end
		for _, barDef in ipairs(barTargetDefs) do
			local barTargets = indicator.targets[barDef.key]
			if barTargets then
				if barTargets.glows ~= nil then
					for guid in pairs(barTargets.glows) do
						if TRB.Functions.Glow:Get(guid) ~= nil then
							return true
						end
					end
				end
				for _, elemDef in ipairs(barDef.elements or defaultElementDefs) do
					if barTargets[elemDef.key] then
						return true
					end
				end
			end
		end
		return false
	end

	---Syncs the enabled state for an indicator based on whether any targets are selected
	---@param indicator table?
	---@param colorPicker Button? # The row's color picker, greyed out while nothing is targeted
	local function SyncEnabled(indicator, colorPicker)
		if not indicator then return end
		local anyEnabled = HasAnyTarget(indicator)
		indicator.enabled = anyEnabled
		if colorPicker then
			TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(colorPicker, anyEnabled)
		end
	end

	---Points a built-in row at another built-in in place, keeping its colors, modifiers, and the targets the new built-in
	---offers. An original's key belongs to its built-in, so the row becomes a copy (or the picked built-in's deleted key)
	---and the original is deleted.
	---@param key string
	---@param builtInKey string
	---@param list string[] # The row's nodeOrder or gradientOrder
	---@return string key # The row's key afterward
	local function SwitchBuiltInRow(key, builtInKey, list)
		local indicator = indicatorColors[key]
		if indicator == nil or (indicator.copyOf or key) == builtInKey then
			return key
		end
		local offered = {}
		for _, barDef in ipairs(GetBarTargetDefsFor(indicatorDefByKey[builtInKey])) do
			offered[barDef.key] = true
		end

		local removed = sharedSettings.removed
		if indicator.copyOf ~= nil and not (removed ~= nil and removed[builtInKey]) then
			indicator.copyOf = builtInKey
			indicator.modifiers = ModifiersOverDefault(indicator.modifiers, GetDefaultEntry(builtInKey))
			indicatorDefByKey[key] = indicatorDefByKey[builtInKey]
			for barKey in pairs(indicator.targets or {}) do
				if not offered[barKey] then
					indicator.targets[barKey] = nil
				end
			end
			SyncEnabled(indicator)
			return key
		end

		local newKey, entry = PrepareBuiltInRow(builtInKey)
		if newKey == nil or entry == nil then
			return key
		end
		entry.color = indicator.color
		entry.color2 = indicator.color2
		entry.gradientDirection = indicator.gradientDirection
		entry.modifiers = ModifiersOverDefault(indicator.modifiers, GetDefaultEntry(builtInKey))
		-- Laid over the explicit falses, so the login's merge over the defaults can't turn the new built-in's elements on.
		for barKey, elements in pairs(indicator.targets or {}) do
			if offered[barKey] then
				entry.targets[barKey] = entry.targets[barKey] or {}
				for elemKey, value in pairs(elements) do
					entry.targets[barKey][elemKey] = TRB.Functions.Table:DeepCopy(value)
				end
			end
		end
		SyncEnabled(entry)
		indicatorColors[newKey] = entry
		indicatorDefByKey[newKey] = indicatorDefByKey[builtInKey]
		for i, k in ipairs(list) do
			if k == key then
				list[i] = newKey
				break
			end
		end
		DeleteIndicatorEntry(key, list)
		return newKey
	end

	local cdm = TRB.Functions.CooldownManager
	local Primitives = TRB.Functions.OptionsUi.Primitives
	local rowsTopY = yCoord

	---Repaints live bars after a custom indicator is added, re-pointed, or removed.
	local function RefreshRuntime()
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end

	local Threshold = TRB.Functions.Threshold
	local Aura = TRB.Functions.Aura
	local ColorPickers = TRB.Functions.OptionsUi.ColorPickers
	local settingsClassName, settingsSpecName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local thresholdLabels = config.thresholdLabels or {}

	---@param spell TRB.Classes.SpellThreshold
	---@return string
	local function GetThresholdName(spell)
		return thresholdLabels[spell.settingKey] or spell.name or spell.settingKey
	end

	-- The Thresholds tab's built-in lines, minus those a color curve colors (they're also the ones without audio cues).
	---@type TRB.Classes.SpellThreshold[]
	local thresholdSpells = {}
	do
		local compositeKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
		local specCacheEntry = compositeKey ~= nil and TRB.Data.specCache[compositeKey] or nil
		local specSpells = specCacheEntry ~= nil and specCacheEntry.spellsData ~= nil and specCacheEntry.spellsData.spells or nil
		local dictionary = spec.thresholds ~= nil and spec.thresholds.thresholdDictionary or nil
		if specSpells ~= nil and dictionary ~= nil then
			for _, v in pairs(specSpells) do
				if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v:IsValid() then
					local spell = v --[[@as TRB.Classes.SpellThreshold]]
					if spell.canHaveAudioCue ~= false and dictionary[spell.settingKey] ~= nil then
						thresholdSpells[#thresholdSpells + 1] = spell
					end
				end
			end
		end
		table.sort(thresholdSpells, function(a, b)
			local aName = GetThresholdName(a):lower()
			local bName = GetThresholdName(b):lower()
			if aName == bName then
				return a.settingKey < b.settingKey
			end
			return aName < bName
		end)
	end

	---@param settingKey string
	---@return TRB.Classes.SpellThreshold?
	local function FindThresholdSpell(settingKey)
		for _, spell in ipairs(thresholdSpells) do
			if spell.settingKey == settingKey then
				return spell
			end
		end
		return nil
	end

	---The states a line's menu offers, by the Thresholds tab's own rules; a line in Static color mode only has Static.
	---@param spell TRB.Classes.SpellThreshold
	---@return string[]
	local function GetThresholdStates(spell)
		if Threshold:IsLineStatic(spec, spell.settingKey) then
			return { ThresholdState.STATIC }
		end
		local states = { ThresholdState.USABLE, ThresholdState.UNUSABLE }
		if spell.hasCooldown == true then
			states[#states + 1] = ThresholdState.ON_COOLDOWN
		end
		if spell.rangeCheck ~= false and spell:HasRange() and spec.colors.threshold.outOfRange ~= nil then
			states[#states + 1] = ThresholdState.OUT_OF_RANGE
			states[#states + 1] = ThresholdState.IN_RANGE
		end
		return states
	end

	---@param settingKey string
	---@param state string
	---@return string
	local function GetThresholdStateColor(settingKey, state)
		return Threshold:GetConditionStateColor(settingsClassName, settingsSpecName, settingKey, state) or "FFFFFFFF"
	end

	---@param condition TRB.CustomIndicatorCondition
	---@param spell TRB.Classes.SpellThreshold
	---@param state string
	local function PointThresholdConditionAt(condition, spell, state)
		condition.settingKey = spell.settingKey
		condition.state = state
		condition.name = GetThresholdName(spell)
	end

	---Fills a menu with the spec's threshold lines, each opening its states beside swatches of the line's colors.
	---@param rootDescription table
	---@param current TRB.CustomIndicatorCondition?
	---@param onPick fun(spell: TRB.Classes.SpellThreshold, state: string)
	local function PopulateThresholdPicker(rootDescription, current, onPick)
		for _, spell in ipairs(thresholdSpells) do
			local text = GetThresholdName(spell)
			if spell.texture ~= nil then
				text = "|T" .. spell.texture .. ":16:16:0:0|t " .. text
			end
			local lineButton = rootDescription:CreateButton(text)
			for _, state in ipairs(GetThresholdStates(spell)) do
				local r, g, b = TRB.Functions.Color:GetRGBAFromString(GetThresholdStateColor(spell.settingKey, state))
				local stateText = string.format(stateSwatchMarkup, r, g, b, thresholdStateLabels[state])
				local radio = lineButton:CreateRadio(stateText, function()
					return current ~= nil and current.settingKey == spell.settingKey and current.state == state
				end, function()
					onPick(spell, state)
					return MenuResponse.Close
				end)
				local note = thresholdStateTooltips[state]
				if note ~= nil then
					radio:SetTooltip(function(tooltipFrame)
						tooltipFrame:SetText(note, 1, 1, 1, 1, true)
					end)
				end
			end
		end
		Primitives:LimitMenuRows(rootDescription, #thresholdSpells)
	end

	---Resolves a threshold row's label and tracked state; on its own spec, an unlearned line is Not Tracked.
	---@param condition TRB.CustomIndicatorCondition
	---@return string label
	---@return boolean notTracked
	---@return string badgeTooltip
	---@return string name # The line's name alone
	local function ResolveThresholdRow(condition)
		local spell = FindThresholdSpell(condition.settingKey)
		local name = (spell ~= nil and GetThresholdName(spell)) or condition.name or L["CustomIndicatorUnknownEntry"]
		local label = string.format(thresholdStateRowFormats[condition.state] or thresholdStateRowFormats[ThresholdState.USABLE], name)
		if spell == nil then
			return label, true, L["ThresholdIndicatorMissingTooltip"], name
		end
		if Threshold:IsColorModeMismatched(condition) then
			return label, true, string.format(L["ThresholdIndicatorColorModeChangedTooltip"], L["ThresholdDetailColorModePrefix"]), name
		end
		local character = TRB.Data.character
		if character ~= nil and character.classId == classId and character.specId == specId
			and TRB.Data.cache.thresholdSpellsByKey[spell.settingKey] == nil then
			return label, true, L["ThresholdIndicatorNotLearnedTooltip"], name
		end
		return label, false, L["ThresholdIndicatorBadgeTooltip"], name
	end

	---@param indicator table?
	---@return TRB.CustomIndicatorCondition?
	local function GetThresholdCondition(indicator)
		local conditions = indicator ~= nil and indicator.custom ~= nil and indicator.custom.conditions or nil
		local condition = conditions ~= nil and conditions[1] or nil
		if condition ~= nil and condition.source == Threshold.CONDITION_SOURCE then
			return condition
		end
		return nil
	end

	---@param indicator table?
	---@return TRB.CustomIndicatorCondition?
	local function GetAuraCondition(indicator)
		local conditions = indicator ~= nil and indicator.custom ~= nil and indicator.custom.conditions or nil
		local condition = conditions ~= nil and conditions[1] or nil
		if condition ~= nil and condition.source == Aura.CONDITION_SOURCE then
			return condition
		end
		return nil
	end

	---@param condition TRB.CustomIndicatorCondition
	---@param spellId integer
	local function PointAuraConditionAt(condition, spellId)
		condition.spellID = spellId
		condition.name = C_Spell.GetSpellName(spellId)
	end

	---Resolves a buff row's label and tracked state, refreshing its cached name.
	---@param condition TRB.CustomIndicatorCondition
	---@return string label
	---@return boolean notTracked
	---@return string badgeTooltip
	local function ResolveAuraRow(condition)
		local name = condition.spellID ~= nil and C_Spell.GetSpellName(condition.spellID) or nil
		if name ~= nil then
			condition.name = name
		end
		local label = string.format(L["CustomIndicatorActiveFormat"], condition.name or L["CustomIndicatorUnknownEntry"])
		if not TRB.Flavor.playerAuras then
			return label, true, L["AuraIndicatorUnavailableTooltip"]
		elseif name == nil then
			return label, true, string.format(L["AuraIndicatorUnknownSpellTooltip"], tostring(condition.spellID))
		end
		return label, false, string.format(L["AuraIndicatorBadgeTooltip"], condition.spellID)
	end

	---Refreshes range checks and tracked cooldowns after a threshold indicator is added, re-pointed, or removed.
	local function RefreshThresholdTracking()
		local character = TRB.Data.character
		if character ~= nil and character.classId == classId and character.specId == specId then
			TRB.Functions.Character:RefreshSpellRangeCheckUpdate()
		end
		-- A Druid form follows another spec's indicators, so this spec's edit can matter while playing a sibling.
		TRB.Functions.ThresholdCooldowns:Sync()
	end

	---Why Add and Edit can't be used right now (nil when they can), and the layout status behind it.
	---@return string? reason
	---@return TRB.CdmLayoutStatus? status
	local function GetPickerBlock()
		return Primitives:GetCdmPickerBlock(classId, specId, pickerWording)
	end

	-- Read once per refresh pass rather than once per row.
	local blockReason, blockStatus = nil, nil
	local function UpdatePickerBlock()
		blockReason, blockStatus = GetPickerBlock()
	end

	---@param entry TRB.CdmLayoutEntry
	---@return string?
	local function GetEntryStatusText(entry)
		local notes = Primitives:GetCdmEntryNotes(entry, pickerWording)
		return #notes > 0 and table.concat(notes, "\n\n") or nil
	end

	---Resolves a custom row's label and tracked state, refreshing its cached name and following a
	---renumbered entry, but only while its own spec's layout can be read.
	---@param key string
	---@return string label
	---@return boolean notTracked
	---@return string badgeTooltip
	local function ResolveCustomRow(key)
		local conditions = indicatorColors[key].custom.conditions
		local condition = conditions ~= nil and conditions[1] or nil
		local notTracked = false
		local badgeTooltip = L["CustomIndicatorBadgeTooltip"]

		if condition ~= nil and blockReason == nil then
			local entry = cdm:ResolveCondition(condition)
			if entry == nil then
				notTracked = true
				badgeTooltip = L["CustomIndicatorMissingTooltip"]
			else
				notTracked = not cdm:IsEntryTracked(entry)
				local status = GetEntryStatusText(entry)
				if notTracked then
					badgeTooltip = status or badgeTooltip
				elseif status ~= nil then
					badgeTooltip = badgeTooltip .. "\n\n" .. status
				end
			end
		elseif condition ~= nil and (blockStatus == cdm.LayoutStatus.DISABLED or blockStatus == cdm.LayoutStatus.UNAVAILABLE) then
			notTracked = true
			badgeTooltip = blockReason or badgeTooltip
		end

		local name = (condition ~= nil and condition.name) or L["CustomIndicatorUnknownEntry"]
		return string.format(L["CustomIndicatorActiveFormat"], name), notTracked, badgeTooltip
	end

	---Opens the menu of the played spec's passive Cooldown Manager entries.
	---@param owner Frame
	---@param currentCooldownID integer?
	---@param onPick fun(entry: TRB.CdmLayoutEntry)
	local function OpenPicker(owner, currentCooldownID, onPick)
		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			Primitives:PopulateCdmPicker(rootDescription, currentCooldownID, pickerWording, onPick)
		end)
	end

	---Shows a tooltip on a row button: the reason it's blocked, else what it does.
	---@param button Button
	---@param text string
	local function ShowRowButtonTooltip(button, text)
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
		GameTooltip:SetText(button:IsEnabled() and text or (GetPickerBlock() or text), 1, 1, 1, 1, true)
		GameTooltip:Show()
	end

	---Re-anchors a row's widgets to its slot, so a pooled row can be reused at any index.
	---@param row table
	---@param rowIndex number
	local function PositionRow(row, rowIndex)
		local rowY = rowsTopY - ((rowIndex - 1) * 30)
		local xOffset = oUi.xCoord
		row.removeBtn:ClearAllPoints()
		row.removeBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, rowY)
		row.editBtn:ClearAllPoints()
		row.editBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset + 22, rowY)
		xOffset = xOffset + customColumnWidth
		row.upBtn:ClearAllPoints()
		row.upBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, rowY)
		row.downBtn:ClearAllPoints()
		row.downBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset + 22, rowY)
		row.dropdown:ClearAllPoints()
		row.dropdown:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset + 46, rowY)
		row.colorPicker:ClearAllPoints()
		row.colorPicker:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord2, rowY)
	end

	---@param row table
	---@param shown boolean
	local function SetRowShown(row, shown)
		row.upBtn:SetShown(shown)
		row.downBtn:SetShown(shown)
		row.dropdown:SetShown(shown)
		row.colorPicker:SetShown(shown)
		if not shown then
			row.removeBtn:Hide()
			row.editBtn:Hide()
		end
	end

	local addButton = nil

	local function RefreshAddButton()
		if addButton ~= nil then
			addButton:SetEnabled(blockReason == nil or #thresholdSpells > 0 or TRB.Flavor.playerAuras)
		end
	end

	---Refreshes a single row's visual state from the current orderedKeys
	---@param rowIndex number
	---@param blockKnown boolean? # The caller just ran UpdatePickerBlock for a pass over every row
	local function RefreshRow(rowIndex, blockKnown)
		local row = rows[rowIndex]
		if not row then return end
		if not blockKnown then
			UpdatePickerBlock()
		end
		local key = orderedKeys[rowIndex]
		local def = indicatorDefByKey[key]
		local indicator = indicatorColors[key]
		if not def or not indicator then return end

		local isCustom = def.custom == true
		local thresholdCondition = isCustom and GetThresholdCondition(indicator) or nil
		local auraCondition = isCustom and GetAuraCondition(indicator) or nil
		local notTracked = false
		local badgeTooltip = nil
		local readOnlyTooltip = nil
		if thresholdCondition ~= nil then
			local name
			def.colorLabel, notTracked, badgeTooltip, name = ResolveThresholdRow(thresholdCondition)
			readOnlyTooltip = string.format(L["ThresholdIndicatorColorTooltip"], thresholdStateColorNames[thresholdCondition.state] or "", name)
		elseif auraCondition ~= nil then
			def.colorLabel, notTracked, badgeTooltip = ResolveAuraRow(auraCondition)
		elseif isCustom then
			def.colorLabel, notTracked, badgeTooltip = ResolveCustomRow(key)
		end

		-- Update color picker
		if row.colorPicker then
			indicator.color2 = indicator.color2 or indicator.color
			indicator.gradientDirection = indicator.gradientDirection or "disabled"
			row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color, true))
			if row.colorPicker.Swatch2 then
				row.colorPicker.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color2, true))
				local gradDir = indicator.gradientDirection
				if gradDir == "disabled" then
					row.colorPicker.Swatch2:SetAlpha(0.35)
					row.colorPicker.Swatch2:EnableMouse(false)
				else
					row.colorPicker.Swatch2:SetAlpha(1.0)
					row.colorPicker.Swatch2:EnableMouse(true)
				end
			end
			if row.colorPicker.DirectionButton then
				row.colorPicker.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[indicator.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
			end
			if row.colorPicker.Font then
				-- A copy shares its built-in's def, so the modifier marks go on the text, not the def.
				row.colorPicker.Font:SetText(ModifiedRowLabel(indicator, def.colorLabel))
				-- After the relabel: the badge is placed past the measured end of the new text.
				Primitives:AttachCdmBadgeToText(row.colorPicker.Font, def.cdm)
				Primitives:AttachCustomBadgeToText(row.colorPicker.Font, isCustom, notTracked, badgeTooltip or "")
			end
			Primitives:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
			ColorPickers:SetGradientColorPickerReadOnly(row.colorPicker, readOnlyTooltip)
			-- Colors and targets stay editable for when the entry is tracked again; only the name says it isn't.
			if notTracked and row.colorPicker.Font then
				row.colorPicker.Font:SetFontObject(GameFontDisable)
			end
		end
		-- Update dropdown text
		if row.dropdown then
			row.dropdown:SetText(GetSummaryText(key))
		end
		row.removeBtn:SetShown(true)
		row.editBtn:SetShown(true)
		-- Arrow enabled state
		if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
		if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedKeys) end
	end

	local function RefreshAllRows()
		UpdatePickerBlock()
		Threshold:SyncIndicatorColors(settingsClassName, settingsSpecName)
		for rowIndex = 1, #orderedKeys do
			RefreshRow(rowIndex, true)
		end
		RefreshAddButton()
	end

	---Swaps two adjacent entries and persists to settings
	---@param indexA number
	---@param indexB number
	local function SwapNodes(indexA, indexB)
		orderedKeys[indexA], orderedKeys[indexB] = orderedKeys[indexB], orderedKeys[indexA]
		-- Rebuild the persisted nodeOrder from orderedKeys so any filtered-out
		-- orphan trailing entries don't survive the write.
		wipe(sharedSettings.nodeOrder)
		for i, k in ipairs(orderedKeys) do
			sharedSettings.nodeOrder[i] = k
		end
		UpdatePickerBlock()
		RefreshRow(indexA, true)
		RefreshRow(indexB, true)
		RefreshAddButton()
	end

	-- Each list's Add button row, the top of everything that moves when its list grows or shrinks.
	local layout = { flatBelowY = 0, gradientBelowY = nil }

	---Moves every control at or below topY, and every tracked row Y with them.
	---@param topY number
	---@param deltaY number
	local function ShiftBelow(topY, deltaY)
		Primitives:ShiftControlsBelow(parent, topY, deltaY)
		for name, y in pairs(layout) do
			if y <= topY then
				layout[name] = y + deltaY
			end
		end
	end

	local RemoveIndicator

	---Builds the widgets for one row slot. They read whichever key sits at that index when used, so the
	---slot survives reordering, adding, and removing.
	---@param rowIndex number
	local function BuildRow(rowIndex)
		local capturedRowIdx = rowIndex
		local row = {}
		rows[rowIndex] = row

		row.removeBtn = Primitives:BuildDeleteIconButton(parent, 0, 0)
		row.removeBtn:SetScript("OnClick", function()
			local currentKey = orderedKeys[capturedRowIdx]
			local currentDef = indicatorDefByKey[currentKey]
			if currentDef == nil then return end
			local confirmation = currentDef.custom and L["CustomIndicatorDeleteConfirmation"] or L["BuiltInIndicatorDeleteConfirmation"]
			StaticPopup_Show("TwintopResourceBar_ConfirmDeleteCustomIndicator",
				string.format(confirmation, currentDef.colorLabel or currentKey), nil, {
					remove = function()
						RemoveIndicator(currentKey)
					end,
				})
		end)
		row.removeBtn:SetScript("OnEnter", function(self)
			local currentDef = indicatorDefByKey[orderedKeys[capturedRowIdx]]
			ShowRowButtonTooltip(self, (currentDef ~= nil and currentDef.custom) and L["CustomIndicatorRemoveTooltip"] or L["IndicatorRemoveTooltip"])
		end)
		row.removeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

		row.editBtn = Primitives:BuildEditIconButton(parent, 0, 0)
		row.editBtn:SetScript("OnClick", function(self)
			local currentKey = orderedKeys[capturedRowIdx]
			local currentIndicator = indicatorColors[currentKey]
			if currentIndicator == nil then return end
			local conditions = currentIndicator.custom and currentIndicator.custom.conditions
			local condition = conditions and conditions[1]
			local function OnEdited()
				RefreshRow(capturedRowIdx)
				RefreshRuntime()
			end

			---@type TRB.Classes.OptionsUi.IndicatorEditSource
			local source
			local offerNotActive = true
			if currentIndicator.custom == nil then
				source = {
					tooltip = L["BuiltInIndicatorChangeSourceTooltip"],
					populate = function(description)
						PopulateBuiltInPicker(description, sortedIndicatorDefs, currentIndicator.copyOf or currentKey, function(builtInKey)
							orderedKeys[capturedRowIdx] = SwitchBuiltInRow(currentKey, builtInKey, sharedSettings.nodeOrder)
							OnEdited()
						end)
					end,
				}
			elseif condition == nil then
				return
			elseif condition.source == Threshold.CONDITION_SOURCE then
				-- A Static line always holds, so its opposite never would.
				offerNotActive = condition.state ~= ThresholdState.STATIC
				source = {
					tooltip = L["ThresholdIndicatorEditTooltip"],
					populate = function(description)
						PopulateThresholdPicker(description, condition, function(spell, state)
							PointThresholdConditionAt(condition, spell, state)
							if state == ThresholdState.STATIC then
								SetModifier(currentIndicator, "notActive", false)
							end
							Threshold:SyncIndicatorColors(settingsClassName, settingsSpecName)
							RefreshThresholdTracking()
							OnEdited()
						end)
					end,
				}
			elseif condition.source == Aura.CONDITION_SOURCE then
				source = {
					tooltip = L["AuraIndicatorEditTooltip"],
					block = not TRB.Flavor.playerAuras and L["AuraIndicatorUnavailableTooltip"] or nil,
					click = function()
						Primitives:ShowAuraSpellIdPrompt(condition.spellID, function(spellId)
							PointAuraConditionAt(condition, spellId)
							Aura:RefreshConditionSpells()
							OnEdited()
						end)
					end,
				}
			else
				-- The Cooldown Manager or spec can change under an open panel, so the rows' badges may be stale too.
				local reason = GetPickerBlock()
				if reason ~= blockReason then
					RefreshAllRows()
				end
				source = {
					tooltip = L["CustomIndicatorEditTooltip"],
					block = reason,
					populate = function(description)
						Primitives:PopulateCdmPicker(description, condition.cooldownID, pickerWording, function(entry)
							cdm:PointConditionAt(condition, entry, true)
							OnEdited()
						end)
					end,
				}
			end
			OpenEditMenu(self, function()
				local key = orderedKeys[capturedRowIdx]
				return indicatorColors[key], key
			end, source, offerNotActive, true, OnEdited)
		end)
		row.editBtn:SetScript("OnEnter", function(self)
			ShowRowButtonTooltip(self, L["IndicatorEditTooltip"])
		end)
		row.editBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

		-- Up arrow
		local upBtn = CreateFrame("Button", nil, parent)
		upBtn:SetSize(20, 20)
		upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
		upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
		upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
		upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		upBtn:SetScript("OnClick", function()
			SwapNodes(capturedRowIdx - 1, capturedRowIdx)
		end)
		upBtn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["NodeOrderMoveUp"], 1, 1, 1)
			GameTooltip:Show()
		end)
		upBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
		row.upBtn = upBtn

		-- Down arrow
		local downBtn = CreateFrame("Button", nil, parent)
		downBtn:SetSize(20, 20)
		downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
		downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
		downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
		downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		downBtn:SetScript("OnClick", function()
			SwapNodes(capturedRowIdx, capturedRowIdx + 1)
		end)
		downBtn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["NodeOrderMoveDown"], 1, 1, 1)
			GameTooltip:Show()
		end)
		downBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
		row.downBtn = downBtn

		-- Targets dropdown
		local ddName = ddNamePrefix .. "_Indicator_Row" .. rowIndex .. "_Targets"
		local dd = CreateFrame("DropdownButton", ddName, parent, "WowStyle1DropdownTemplate")
		dd:SetWidth(targetsDropdownWidth)
		dd:SetScript("OnEnter", function(self)
			local currentKey = orderedKeys[capturedRowIdx]
			local currentDef = indicatorDefByKey[currentKey]
			if currentDef and currentDef.tooltip then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(currentDef.tooltip, 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end)
		dd:SetScript("OnLeave", function() GameTooltip:Hide() end)

		-- Hook SetText to always show our summary
		local originalSetText = dd.SetText
		dd.SetText = function(self, text)
			local currentKey = orderedKeys[capturedRowIdx]
			originalSetText(self, GetSummaryText(currentKey))
		end

		dd:SetupMenu(function(dropdown, rootDescription)
			local currentKey = orderedKeys[capturedRowIdx]
			local currentIndicator = indicatorColors[currentKey]
			if not currentIndicator then return end
			currentIndicator.targets = currentIndicator.targets or {}

			local rowBarTargetDefs = GetBarTargetDefsFor(indicatorDefByKey[currentKey])
			ApplyTargetMenuScrollMode(rootDescription, rowBarTargetDefs, IsExcluded, true)

			-- Every bar offers a Border Glow, so no bar section can be excluded outright here.
			local firstBar = true
			for _, barDef in ipairs(rowBarTargetDefs) do
				local barElementDefs = barDef.elements or defaultElementDefs
				if not firstBar then
					rootDescription:CreateDivider()
				end
				firstBar = false
				rootDescription:CreateTitle(barDef.label)
				currentIndicator.targets[barDef.key] = currentIndicator.targets[barDef.key] or {}

				for _, elemDef in ipairs(barElementDefs) do
					if not IsExcluded(barDef, elemDef.key) then
						rootDescription:CreateCheckbox(
							elemDef.label,
							function()
								local ck = orderedKeys[capturedRowIdx]
								local ci = indicatorColors[ck]
								return ci and ci.targets and ci.targets[barDef.key] and ci.targets[barDef.key][elemDef.key] or false
							end,
							function()
								local ck = orderedKeys[capturedRowIdx]
								local ci = indicatorColors[ck]
								if not ci then return end
								ci.targets = ci.targets or {}
								ci.targets[barDef.key] = ci.targets[barDef.key] or {}
								ci.targets[barDef.key][elemDef.key] = not ci.targets[barDef.key][elemDef.key]
								local targetRow = rows[capturedRowIdx]
								SyncEnabled(ci, targetRow and targetRow.colorPicker)
								-- Re-applies a not-tracked custom row's faded name, which SyncEnabled just reset.
								RefreshRow(capturedRowIdx)
							end
						)
					end
				end

				CreateBorderGlowSubmenu(rootDescription, function()
					local ck = orderedKeys[capturedRowIdx]
					local ci = indicatorColors[ck]
					if not ci then return nil end
					ci.targets = ci.targets or {}
					ci.targets[barDef.key] = ci.targets[barDef.key] or {}
					return ci.targets[barDef.key]
				end, function()
					local ci = indicatorColors[orderedKeys[capturedRowIdx]]
					local targetRow = rows[capturedRowIdx]
					SyncEnabled(ci, targetRow and targetRow.colorPicker)
					RefreshRow(capturedRowIdx)
				end)
			end
		end)
		row.dropdown = dd

		-- Color picker
		local cp = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, "", indicatorColors[orderedKeys[rowIndex]], oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, 0, L["GradientBarFillOnlyTooltip"])
		cp.Swatch1:SetScript("OnMouseDown", function(self, button)
			if cp.readOnlyTooltip ~= nil then return end
			local currentKey = orderedKeys[capturedRowIdx]
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, indicatorColors, { [currentKey] = rows[capturedRowIdx].colorPicker }, currentKey)
		end)
		cp.Swatch2:SetScript("OnMouseDown", function(self, button)
			local currentKey = orderedKeys[capturedRowIdx]
			TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, indicatorColors[currentKey], cp.Swatch2, classId, specId)
		end)
		cp.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
			if mouseButton == "LeftButton" then
				local currentKey = orderedKeys[capturedRowIdx]
				local currentEntry = indicatorColors[currentKey]
				if not currentEntry then return end
				currentEntry.gradientDirection = currentEntry.gradientDirection or "disabled"
				local ci = 1
				for idx, dir in ipairs(gradientDirectionCycle) do
					if dir == currentEntry.gradientDirection then ci = idx; break end
				end
				currentEntry.gradientDirection = gradientDirectionCycle[(ci % #gradientDirectionCycle) + 1]
				local gradDir = currentEntry.gradientDirection
				if gradDir == "disabled" then
					cp.Swatch2:SetAlpha(0.35); cp.Swatch2:EnableMouse(false)
				else
					cp.Swatch2:SetAlpha(1.0); cp.Swatch2:EnableMouse(true)
				end
				self.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
				TRB.Data.cache.colors.gradient = {}
				TRB.Data.cache.colors.bar = {}
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end)
		cp.UpdateSwatch2State = function()
			local currentKey = orderedKeys[capturedRowIdx]
			local currentEntry = indicatorColors[currentKey]
			if not currentEntry then return end
			currentEntry.color2 = currentEntry.color2 or currentEntry.color
			currentEntry.gradientDirection = currentEntry.gradientDirection or "disabled"
			cp.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(currentEntry.color2, true))
			if currentEntry.gradientDirection == "disabled" then
				cp.Swatch2:SetAlpha(0.35)
				cp.Swatch2:EnableMouse(false)
			else
				cp.Swatch2:SetAlpha(1.0)
				cp.Swatch2:EnableMouse(true)
			end
			cp.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[currentEntry.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
		end
		row.colorPicker = cp

		-- Store row controls for the color picker callback
		controls.indicatorColors.rows[rowIndex] = row

		PositionRow(row, rowIndex)
	end

	---Adds an indicator at the lowest priority and grows the list by one row.
	---@param key string
	---@param entry table
	---@param def table # The row's def: a built-in's, or a custom row's own
	local function InsertIndicatorRow(key, entry, def)
		indicatorColors[key] = entry
		table.insert(sharedSettings.nodeOrder, key)
		indicatorDefByKey[key] = def
		orderedKeys[#orderedKeys + 1] = key

		ShiftBelow(layout.flatBelowY, -30)

		local rowIndex = #orderedKeys
		if rows[rowIndex] == nil then
			BuildRow(rowIndex)
		else
			PositionRow(rows[rowIndex], rowIndex)
			SetRowShown(rows[rowIndex], true)
		end
		UpdatePickerBlock()
		-- A Cooldown Manager row starts white; a threshold row takes its line's color here.
		Threshold:SyncIndicatorColors(settingsClassName, settingsSpecName)
		RefreshRow(rowIndex, true)
		if rowIndex > 1 then
			RefreshRow(rowIndex - 1, true)
		end
		RefreshAddButton()
		RefreshRuntime()
	end

	---Adds a custom indicator at the lowest priority and untargeted.
	---@param condition TRB.CustomIndicatorCondition
	local function AddIndicatorRow(condition)
		local key = NextIndicatorKey("custom_")
		InsertIndicatorRow(key, {
			color = "FFFFFFFF",
			color2 = "FFFFFFFF",
			gradientDirection = "disabled",
			enabled = false,
			targets = {},
			custom = { conditions = { condition } },
		}, { key = key, custom = true, colorLabel = "" })
	end

	---Adds a built-in to the priority list: back under its own key when it was deleted, else as a copy.
	---@param builtInKey string
	local function AddBuiltInIndicator(builtInKey)
		local key, entry = PrepareBuiltInRow(builtInKey)
		if key ~= nil then
			InsertIndicatorRow(key, entry, indicatorDefByKey[builtInKey])
		end
	end

	---Opens a menu of built-in indicators, sorted by row label, each with its tooltip.
	---@param owner Frame
	---@param defs TRB.Classes.OptionsUi.IndicatorDef[]
	---@param onPick fun(builtInKey: string)
	local function OpenBuiltInMenu(owner, defs, onPick)
		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			PopulateBuiltInPicker(rootDescription, defs, nil, onPick)
		end)
	end

	---@param entry TRB.CdmLayoutEntry
	local function AddCustomIndicator(entry)
		---@type TRB.CustomIndicatorCondition
		local condition = { source = cdm.CONDITION_SOURCE, state = cdm.ConditionState.ACTIVE, cooldownID = entry.cooldownID }
		cdm:PointConditionAt(condition, entry, true)
		AddIndicatorRow(condition)
	end

	---@param spellId integer
	local function AddAuraIndicator(spellId)
		---@type TRB.CustomIndicatorCondition
		local condition = { source = Aura.CONDITION_SOURCE, state = Aura.ConditionState.ACTIVE }
		PointAuraConditionAt(condition, spellId)
		AddIndicatorRow(condition)
		Aura:RefreshConditionSpells()
	end

	---@param spell TRB.Classes.SpellThreshold
	---@param state string
	local function AddThresholdIndicator(spell, state)
		local condition = { source = Threshold.CONDITION_SOURCE }
		PointThresholdConditionAt(condition, spell, state)
		AddIndicatorRow(condition)
		RefreshThresholdTracking()
	end

	---Opens the Add menu: Cooldown Manager buffs or a buff by spell ID (whichever the client supports), or a threshold line's state.
	---@param owner Frame
	local function OpenAddMenu(owner)
		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			if TRB.Flavor.cooldownManager then
				local cdmLabel = CreateColor(Primitives:GetCdmBadgeColor()):WrapTextInColorCode(string.format("(%s)", L["CdmBadgeLabel"]))
				local buffsButton = rootDescription:CreateButton(string.format(L["CustomIndicatorSourceBuffsFormat"], cdmLabel))
				local reason = GetPickerBlock()
				if reason ~= nil then
					buffsButton:SetEnabled(false)
					buffsButton:SetTooltip(function(tooltipFrame)
						tooltipFrame:SetText(reason, 1, 1, 1, 1, true)
					end)
				else
					Primitives:PopulateCdmPicker(buffsButton, nil, pickerWording, AddCustomIndicator)
				end
			end
			if TRB.Flavor.playerAuras then
				rootDescription:CreateButton(L["CustomBarsAddGroupAuraId"], function()
					Primitives:ShowAuraSpellIdPrompt(nil, AddAuraIndicator)
				end)
			end
			if #thresholdSpells > 0 then
				PopulateThresholdPicker(rootDescription:CreateButton(L["CustomIndicatorSourceThresholds"]), nil, AddThresholdIndicator)
			end
		end)
	end

	---Deletes an indicator and shrinks the list by one row.
	---@param key string
	RemoveIndicator = function(key)
		local removeIndex = nil
		for i, k in ipairs(orderedKeys) do
			if k == key then
				removeIndex = i
				break
			end
		end
		if removeIndex == nil then return end

		table.remove(orderedKeys, removeIndex)
		local wasThreshold = GetThresholdCondition(indicatorColors[key]) ~= nil
		local wasAura = GetAuraCondition(indicatorColors[key]) ~= nil
		DeleteIndicatorEntry(key, sharedSettings.nodeOrder)
		if wasThreshold then
			RefreshThresholdTracking()
		elseif wasAura then
			Aura:RefreshConditionSpells()
		end

		local lastRow = rows[#orderedKeys + 1]
		if lastRow ~= nil then
			SetRowShown(lastRow, false)
		end
		ShiftBelow(layout.flatBelowY, 30)

		UpdatePickerBlock()
		for i = math.max(removeIndex - 1, 1), #orderedKeys do
			RefreshRow(i, true)
		end
		RefreshAddButton()
		RefreshRuntime()
	end

	-- Build flat indicator rows
	for rowIndex = 1, #orderedKeys do
		BuildRow(rowIndex)
		yCoord = yCoord - 30
	end

	addButton = Primitives:BuildButton(parent, L["CustomIndicatorAddButton"], oUi.xCoord2, yCoord, 250, 25)
	addButton:SetDisabledFontObject(GameFontDisable)
	addButton:SetMotionScriptsWhileDisabled(true)
	addButton:SetScript("OnEnter", function(self)
		-- With threshold lines or spell IDs to offer, the Add menu explains a Cooldown Manager block itself.
		local reason = #thresholdSpells == 0 and not TRB.Flavor.playerAuras and GetPickerBlock() or nil
		if reason ~= nil then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(reason, 1, 1, 1, 1, true)
			GameTooltip:Show()
		elseif not self:IsEnabled() then
			RefreshAllRows()
		end
	end)
	addButton:SetScript("OnClick", function(self)
		if #thresholdSpells > 0 or TRB.Flavor.playerAuras then
			OpenAddMenu(self)
			return
		end
		if GetPickerBlock() ~= nil then
			RefreshAllRows()
			self:GetScript("OnEnter")(self)
			return
		end
		OpenPicker(self, nil, AddCustomIndicator)
	end)
	addButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

	if #indicatorDefs > 0 then
		local addBuiltInButton = Primitives:BuildButton(parent, L["BuiltInIndicatorAddButton"], oUi.xCoord + customColumnWidth + 46, yCoord, 250, 25)
		addBuiltInButton:SetScript("OnClick", function(self)
			OpenBuiltInMenu(self, sortedIndicatorDefs, AddBuiltInIndicator)
		end)
	end
	layout.flatBelowY = yCoord
	yCoord = yCoord - 30

	RefreshAllRows()

	parent:HookScript("OnShow", RefreshAllRows)
	if EventRegistry ~= nil then
		local refreshQueued = false
		EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged", function()
			if refreshQueued or not parent:IsVisible() then return end
			refreshQueued = true
			-- Read a frame late, so Blizzard's own listeners for the same callback rebuild the layout first.
			C_Timer.After(0, function()
				refreshQueued = false
				if parent:IsVisible() then
					RefreshAllRows()
				end
			end)
		end, parent)
	end

	-- Gradient Color Overrides section
	if #gradientDefs > 0 then
		yCoord = yCoord - 10
		controls.textSectionGradient = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GradientColorOverridesHeader"], oUi.xCoord, yCoord)
		yCoord = yCoord - 30

		-- Note explaining gradient behavior
		controls.gradientNote = TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["GradientColorOverridesNote"], oUi.xCoord, yCoord, oUi.maxOptionsWidth-10, 28)
		yCoord = yCoord - 30

		-- Working copy of gradient ordered keys. Filter out phantom entries so
		-- the row count stays in sync with the up/down arrow bounds.
		local orderedGradientKeys = {}
		for _, k in ipairs(sharedSettings.gradientOrder) do
			if indicatorDefByKey[k] and indicatorColors[k] then
				orderedGradientKeys[#orderedGradientKeys + 1] = k
			end
		end

		local gradientRows = {}
		controls.indicatorColors.gradientRows = controls.indicatorColors.gradientRows or {}
		-- Gradient rows hang above their Add button, so they follow it when either list resizes.
		layout.gradientBelowY = yCoord - (#orderedGradientKeys * 30)

		local function RefreshGradientRow(rowIndex)
			local row = gradientRows[rowIndex]
			if not row then return end
			local key = orderedGradientKeys[rowIndex]
			local def = indicatorDefByKey[key]
			local indicator = indicatorColors[key]
			if not def or not indicator then return end

			if row.colorPicker then
				row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color, true))
				if row.colorPicker.Font then
					row.colorPicker.Font:SetText(ModifiedRowLabel(indicator, def.colorLabel))
				end
				TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
			end
			if row.dropdown then
				row.dropdown:SetText(GetSummaryText(key))
			end
			if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
			if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedGradientKeys) end
		end

		local function SwapGradientNodes(indexA, indexB)
			orderedGradientKeys[indexA], orderedGradientKeys[indexB] = orderedGradientKeys[indexB], orderedGradientKeys[indexA]
			wipe(sharedSettings.gradientOrder)
			for i, k in ipairs(orderedGradientKeys) do
				sharedSettings.gradientOrder[i] = k
			end
			RefreshGradientRow(indexA)
			RefreshGradientRow(indexB)
		end

		---Re-anchors a gradient row's widgets to its slot, so a pooled row can be reused at any index.
		---@param row table
		---@param rowIndex number
		local function PositionGradientRow(row, rowIndex)
			local rowY = layout.gradientBelowY + ((#orderedGradientKeys - rowIndex + 1) * 30)
			local xOffset = oUi.xCoord
			row.removeBtn:ClearAllPoints()
			row.removeBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, rowY)
			row.editBtn:ClearAllPoints()
			row.editBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset + 22, rowY)
			xOffset = xOffset + customColumnWidth
			row.upBtn:ClearAllPoints()
			row.upBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, rowY)
			row.downBtn:ClearAllPoints()
			row.downBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset + 22, rowY)
			row.dropdown:ClearAllPoints()
			row.dropdown:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset + 46, rowY)
			row.colorPicker:ClearAllPoints()
			row.colorPicker:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord2, rowY)
		end

		---@param row table
		---@param shown boolean
		local function SetGradientRowShown(row, shown)
			row.removeBtn:SetShown(shown)
			row.editBtn:SetShown(shown)
			row.upBtn:SetShown(shown)
			row.downBtn:SetShown(shown)
			row.dropdown:SetShown(shown)
			row.colorPicker:SetShown(shown)
		end

		local RemoveGradientIndicator

		---Builds the widgets for one gradient row slot, which read whichever key sits at that index when used.
		---@param gradIdx number
		local function BuildGradientRow(gradIdx)
			local capturedGradIdx = gradIdx
			local gradRow = {}
			gradientRows[gradIdx] = gradRow

			gradRow.removeBtn = Primitives:BuildDeleteIconButton(parent, 0, 0)
			gradRow.removeBtn:SetScript("OnClick", function()
				local currentKey = orderedGradientKeys[capturedGradIdx]
				local currentDef = indicatorDefByKey[currentKey]
				if currentDef == nil then return end
				StaticPopup_Show("TwintopResourceBar_ConfirmDeleteCustomIndicator",
					string.format(L["BuiltInGradientDeleteConfirmation"], currentDef.colorLabel or currentKey), nil, {
						remove = function()
							RemoveGradientIndicator(currentKey)
						end,
					})
			end)
			gradRow.removeBtn:SetScript("OnEnter", function(self)
				ShowRowButtonTooltip(self, L["IndicatorRemoveTooltip"])
			end)
			gradRow.removeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

			-- A gradient's condition only gates its curve, which does the threshold step, so Not Active would just invert the gate.
			gradRow.editBtn = Primitives:BuildEditIconButton(parent, 0, 0)
			gradRow.editBtn:SetScript("OnClick", function(self)
				local currentKey = orderedGradientKeys[capturedGradIdx]
				local currentIndicator = indicatorColors[currentKey]
				if currentIndicator == nil then return end
				OpenEditMenu(self, function()
					local key = orderedGradientKeys[capturedGradIdx]
					return indicatorColors[key], key
				end, {
					tooltip = L["BuiltInGradientChangeSourceTooltip"],
					populate = function(description)
						PopulateBuiltInPicker(description, sortedGradientDefs, currentIndicator.copyOf or currentKey, function(builtInKey)
							orderedGradientKeys[capturedGradIdx] = SwitchBuiltInRow(currentKey, builtInKey, sharedSettings.gradientOrder)
							RefreshGradientRow(capturedGradIdx)
							RefreshRuntime()
						end)
					end,
				}, false, true, function()
					RefreshGradientRow(capturedGradIdx)
					RefreshRuntime()
				end)
			end)
			gradRow.editBtn:SetScript("OnEnter", function(self)
				ShowRowButtonTooltip(self, L["IndicatorEditTooltip"])
			end)
			gradRow.editBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

			-- Up arrow
			local upBtn = CreateFrame("Button", nil, parent)
			upBtn:SetSize(20, 20)
			upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
			upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
			upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
			upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			upBtn:SetScript("OnClick", function()
				SwapGradientNodes(capturedGradIdx - 1, capturedGradIdx)
			end)
			upBtn:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(L["NodeOrderMoveUp"], 1, 1, 1)
				GameTooltip:Show()
			end)
			upBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
			gradRow.upBtn = upBtn

			-- Down arrow
			local downBtn = CreateFrame("Button", nil, parent)
			downBtn:SetSize(20, 20)
			downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
			downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
			downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
			downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			downBtn:SetScript("OnClick", function()
				SwapGradientNodes(capturedGradIdx, capturedGradIdx + 1)
			end)
			downBtn:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(L["NodeOrderMoveDown"], 1, 1, 1)
				GameTooltip:Show()
			end)
			downBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
			gradRow.downBtn = downBtn

			-- Targets dropdown
			local ddName = ddNamePrefix .. "_Gradient_Row" .. gradIdx .. "_Targets"
			local dd = CreateFrame("DropdownButton", ddName, parent, "WowStyle1DropdownTemplate")
			dd:SetWidth(targetsDropdownWidth)
			dd:SetScript("OnEnter", function(self)
				local currentDef = indicatorDefByKey[orderedGradientKeys[capturedGradIdx]]
				if currentDef and currentDef.tooltip then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText(currentDef.tooltip, 1, 1, 1, 1, true)
					GameTooltip:Show()
				end
			end)
			dd:SetScript("OnLeave", function() GameTooltip:Hide() end)

			local originalSetText = dd.SetText
			dd.SetText = function(self, text)
				originalSetText(self, GetSummaryText(orderedGradientKeys[capturedGradIdx]))
			end

			dd:SetupMenu(function(dropdown, rootDescription)
				local ck = orderedGradientKeys[capturedGradIdx]
				local ci = indicatorColors[ck]
				if not ci then return end
				ci.targets = ci.targets or {}

				local rowBarTargetDefs = GetBarTargetDefsFor(indicatorDefByKey[ck])
				ApplyTargetMenuScrollMode(rootDescription, rowBarTargetDefs, IsGradientExcluded)

				local firstBar = true
				for _, barDef in ipairs(rowBarTargetDefs) do
					local barElementDefs = barDef.elements or defaultElementDefs
					local allExcluded = true
					for _, elemDef in ipairs(barElementDefs) do
						if not IsGradientExcluded(barDef, elemDef.key) then
							allExcluded = false
							break
						end
					end
					if not allExcluded then
						if not firstBar then
							rootDescription:CreateDivider()
						end
						firstBar = false
						rootDescription:CreateTitle(barDef.label)
						ci.targets[barDef.key] = ci.targets[barDef.key] or {}

						for _, elemDef in ipairs(barElementDefs) do
							if not IsGradientExcluded(barDef, elemDef.key) then
								rootDescription:CreateCheckbox(
									elemDef.label,
									function()
										local gk = orderedGradientKeys[capturedGradIdx]
										local indicator = indicatorColors[gk]
										return indicator and indicator.targets and indicator.targets[barDef.key] and indicator.targets[barDef.key][elemDef.key] or false
									end,
									function()
										local gk = orderedGradientKeys[capturedGradIdx]
										local indicator = indicatorColors[gk]
										if not indicator then return end
										indicator.targets = indicator.targets or {}
										indicator.targets[barDef.key] = indicator.targets[barDef.key] or {}
										indicator.targets[barDef.key][elemDef.key] = not indicator.targets[barDef.key][elemDef.key]
										SyncEnabled(indicator, gradRow.colorPicker)
									end
								)
							end
						end
					end
				end
			end)

			gradRow.dropdown = dd

			-- Color picker
			local cp = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, "", indicatorColors[orderedGradientKeys[gradIdx]].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, 0)
			cp:SetScript("OnMouseDown", function(self, button)
				local gk = orderedGradientKeys[capturedGradIdx]
				TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, indicatorColors, { [gk] = gradRow.colorPicker }, gk)
			end)
			gradRow.colorPicker = cp

			controls.indicatorColors.gradientRows[gradIdx] = gradRow

			PositionGradientRow(gradRow, gradIdx)
		end

		---Adds a built-in to the gradient list at the lowest priority and grows the list by one row.
		---@param builtInKey string
		local function AddBuiltInGradient(builtInKey)
			local key, entry = PrepareBuiltInRow(builtInKey)
			if key == nil then return end
			indicatorColors[key] = entry
			table.insert(sharedSettings.gradientOrder, key)
			indicatorDefByKey[key] = indicatorDefByKey[builtInKey]
			orderedGradientKeys[#orderedGradientKeys + 1] = key

			ShiftBelow(layout.gradientBelowY, -30)
			local rowIndex = #orderedGradientKeys
			if gradientRows[rowIndex] == nil then
				BuildGradientRow(rowIndex)
			else
				PositionGradientRow(gradientRows[rowIndex], rowIndex)
				SetGradientRowShown(gradientRows[rowIndex], true)
			end
			RefreshGradientRow(rowIndex)
			if rowIndex > 1 then
				RefreshGradientRow(rowIndex - 1)
			end
			RefreshRuntime()
		end

		---Deletes a gradient row and shrinks the list by one row.
		---@param key string
		RemoveGradientIndicator = function(key)
			local removeIndex = nil
			for i, k in ipairs(orderedGradientKeys) do
				if k == key then
					removeIndex = i
					break
				end
			end
			if removeIndex == nil then return end

			table.remove(orderedGradientKeys, removeIndex)
			DeleteIndicatorEntry(key, sharedSettings.gradientOrder)
			local lastRow = gradientRows[#orderedGradientKeys + 1]
			if lastRow ~= nil then
				SetGradientRowShown(lastRow, false)
			end
			ShiftBelow(layout.gradientBelowY, 30)
			for i = math.max(removeIndex - 1, 1), #orderedGradientKeys do
				RefreshGradientRow(i)
			end
			RefreshRuntime()
		end

		for gradIdx = 1, #orderedGradientKeys do
			BuildGradientRow(gradIdx)
			RefreshGradientRow(gradIdx)
			yCoord = yCoord - 30
		end

		local addGradientButton = Primitives:BuildButton(parent, L["BuiltInGradientAddButton"], oUi.xCoord + customColumnWidth + 46, yCoord, 250, 25)
		addGradientButton:SetScript("OnClick", function(self)
			OpenBuiltInMenu(self, sortedGradientDefs, AddBuiltInGradient)
		end)
		yCoord = yCoord - 30
	end

	-- Optional EndOf configuration sections
	if config.endOfConfigs then
		for _, endOfConfig in ipairs(config.endOfConfigs) do
			yCoord = yCoord - 10
			yCoord = TRB.Functions.OptionsUi.Colors:GenerateEndOfConfigurationOptions(parent, controls, spec, classId, specId, yCoord, endOfConfig)
		end
	end

	-- Optional minimum stacks configuration sections
	if config.stacksConfigs then
		for _, stacksConfig in ipairs(config.stacksConfigs) do
			yCoord = yCoord - 40
			yCoord = TRB.Functions.OptionsUi.Colors:GenerateStacksConfigurationOptions(parent, controls, spec, yCoord, stacksConfig)
		end
	end

	-- Optional Overcap configuration
	if config.overcapConfig then
		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi.Colors:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, config.overcapConfig.primaryResourceString, config.overcapConfig.primaryResourceMax)
	end

	return yCoord
end

---Builds the nested checkbox used by overlay-capable color options for the full-height behavior.
---@param parent frame The parent frame to attach the checkbox to
---@param frameName string The global frame name to use for the checkbox
---@param parentX number The X coordinate of the parent checkbox row
---@param yCoord number The Y coordinate of the parent checkbox row
---@param isChecked boolean Whether the checkbox should start checked
---@param onClick fun(self: CheckButton) The OnClick handler for the checkbox
---@return CheckButton checkbox The created checkbox
---@return number yCoord The next available Y coordinate after the child row
function TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(parent, frameName, parentX, yCoord, isChecked, onClick)
	local checkbox = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", parentX + (oUi.xPadding * 2), yCoord - 18)
	getglobal(checkbox:GetName() .. 'Text'):SetText(L["OverlayFullHeightCheckbox"])
	checkbox.tooltip = L["OverlayFullHeightCheckboxTooltip"]
	checkbox:SetChecked(isChecked == true)
	checkbox:SetScript("OnClick", onClick)

	return checkbox, yCoord - 45
end

---Refreshes active bar appearance and values after an overlay geometry setting changes.
---@param classId integer?
---@param specId integer?
function TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
	if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
		local activeSpecCache = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey]
		if TRB.Frames.barGroups ~= nil and activeSpecCache and activeSpecCache.settings then
			TRB.Functions.Bar:ApplyBarGroupsAppearance(activeSpecCache.settings, TRB.Frames.barGroups)
		end
	end

	if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

