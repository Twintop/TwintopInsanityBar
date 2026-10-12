---@diagnostic disable: undefined-field, undefined-global
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

-- A target menu draws a title and a divider per bar plus a checkbox per element, so specs with several
-- extra bars (Blood DK, Holy Priest) run well past a screen's worth now that the cast bars are
-- targetable. Past this many rows the menu scrolls instead of growing.
local maxMenuRowsBeforeScroll = 15
local menuRowHeight = 20

-- Every flat and gradient row leaves room for custom Remove and Edit buttons, so all the arrows line up.
local customColumnWidth = 46
local targetsDropdownWidth = 254

-- Marks TRB's own notes under a spell's tooltip in the custom indicator picker, so they read as ours.
local pickerNotePrefix = "|cFFA335EETRB:|r "
local pickerNoteR, pickerNoteG, pickerNoteB = 0.85, 0.75, 1.0

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

	if rows > maxMenuRowsBeforeScroll then
		rootDescription:SetScrollMode(maxMenuRowsBeforeScroll * menuRowHeight)
	end
end

---Builds the Border Glow submenu for one bar in a flat indicator's target menu. Any number of glows can be
---checked and all of them run at once; a glow that pins its own color is marked as such in the list.
---@param rootDescription table The bar section being populated
---@param getTargets fun(): table? Resolves the indicator's target table for this bar, live
---@param onChanged fun() Runs after a pick, to resync the row's summary and enabled state
local function CreateBorderGlowSubmenu(rootDescription, getTargets, onChanged)
	---@diagnostic disable-next-line: redundant-parameter, missing-parameter
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

	-- Custom indicators have no def in spec code; give each one so it lists and reorders with the rest.
	for _, k in ipairs(sharedSettings.nodeOrder) do
		local indicator = indicatorColors[k]
		if indicator ~= nil and indicator.custom ~= nil then
			indicatorDefByKey[k] = { key = k, custom = true, colorLabel = "" }
		end
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

	local cdm = TRB.Functions.CooldownManager
	local Primitives = TRB.Functions.OptionsUi.Primitives
	local rowsTopY = yCoord

	---Repaints live bars after a custom indicator is added, re-pointed, or removed.
	local function RefreshRuntime()
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end

	---Why Add and Edit can't be used right now (nil when they can), and the layout status behind it (nil on
	---another spec's panel, since the Cooldown Manager only holds the played spec's layout).
	---@return string? reason
	---@return TRB.CdmLayoutStatus? status
	local function GetPickerBlock()
		local character = TRB.Data.character
		if character == nil or character.classId ~= classId then
			return L["CustomIndicatorOtherClassTooltip"], nil
		elseif character.specId ~= specId then
			return L["CustomIndicatorOtherSpecTooltip"], nil
		end
		local status, reason = cdm:GetLayoutStatus()
		if status == cdm.LayoutStatus.UNAVAILABLE then
			return string.format(L["CustomIndicatorCdmUnavailableTooltip"], reason or ""), status
		elseif status == cdm.LayoutStatus.DISABLED then
			return L["CustomIndicatorCdmDisabledTooltip"], status
		elseif status == cdm.LayoutStatus.NOT_READY then
			return L["CustomIndicatorCdmNotReadyTooltip"], status
		end
		return nil, status
	end

	-- Read once per refresh pass rather than once per row.
	local blockReason, blockStatus = nil, nil
	local function UpdatePickerBlock()
		blockReason, blockStatus = GetPickerBlock()
	end

	local inactiveTooltipByState = {
		[cdm.EntryState.NOT_LEARNED] = L["CustomIndicatorNotLearnedTooltip"],
		[cdm.EntryState.NO_TRINKET_BUFF] = L["CustomIndicatorNoTrinketBuffTooltip"],
		[cdm.EntryState.UNAVAILABLE] = L["CustomIndicatorUnavailableTooltip"],
	}

	---Everything keeping an entry from driving an indicator, plus the potion caveat.
	---@param entry TRB.CdmLayoutEntry
	---@return string[]
	local function GetEntryNotes(entry)
		local notes = {}
		notes[#notes + 1] = inactiveTooltipByState[entry.state]
		if not entry.displayed then
			notes[#notes + 1] = L["CustomIndicatorNotDisplayedTooltip"]
		end
		if entry.isPotion then
			notes[#notes + 1] = L["CustomIndicatorPotionCaveat"]
		end
		return notes
	end

	---@param entry TRB.CdmLayoutEntry
	---@return string?
	local function GetEntryStatusText(entry)
		local notes = GetEntryNotes(entry)
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
				notTracked = entry.state ~= cdm.EntryState.TRACKED
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

	local pickerHeadings = {
		{ group = cdm.LayoutGroup.DISPLAYED, label = L["CustomIndicatorPickerDisplayed"] },
		{ group = cdm.LayoutGroup.INACTIVE, label = L["CustomIndicatorPickerInactive"] },
		{ group = cdm.LayoutGroup.NOT_DISPLAYED, label = L["CustomIndicatorPickerNotDisplayed"] },
		{ group = cdm.LayoutGroup.INACTIVE_NOT_DISPLAYED, label = L["CustomIndicatorPickerInactiveNotDisplayed"] },
	}

	---Opens the menu of the current spec's passive Cooldown Manager entries under their headings. Empty
	---headings are left out, and nothing is greyed: a not-tracked entry is still a valid pick.
	---@param owner Frame
	---@param currentCooldownID integer?
	---@param onPick fun(entry: TRB.CdmLayoutEntry)
	local function OpenPicker(owner, currentCooldownID, onPick)
		local entries = cdm:GetLayoutEntries()
		if entries == nil then
			return
		end

		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			local rowCount = 0
			for _, heading in ipairs(pickerHeadings) do
				local first = true
				for _, entry in ipairs(entries) do
					if entry.group == heading.group then
						if first then
							if rowCount > 0 then
								rootDescription:CreateDivider()
								rowCount = rowCount + 1
							end
							rootDescription:CreateTitle(heading.label)
							rowCount = rowCount + 1
							first = false
						end

						local text = entry.name or L["CustomIndicatorUnknownEntry"]
						if entry.icon ~= nil then
							text = "|T" .. entry.icon .. ":16:16:0:0|t " .. text
						end
						local radio = rootDescription:CreateRadio(text, function()
							return entry.cooldownID == currentCooldownID
						end, function()
							onPick(entry)
							return MenuResponse.Close
						end)
						rowCount = rowCount + 1

						radio:SetTooltip(function(tooltipFrame)
							if entry.equipSlot ~= nil and GetInventoryItemID("player", entry.equipSlot) ~= nil then
								tooltipFrame:SetInventoryItem("player", entry.equipSlot)
							elseif entry.tooltipSpellID ~= nil then
								tooltipFrame:SetSpellByID(entry.tooltipSpellID)
							else
								tooltipFrame:SetText(entry.name or L["CustomIndicatorUnknownEntry"], 1, 1, 1)
							end
							local notes = GetEntryNotes(entry)
							if #notes > 0 then
								tooltipFrame:AddLine(" ")
								for _, note in ipairs(notes) do
									tooltipFrame:AddLine(pickerNotePrefix .. note, pickerNoteR, pickerNoteG, pickerNoteB, true)
								end
							end
							tooltipFrame:Show()
						end)
					end
				end
			end

			if rowCount == 0 then
				rootDescription:CreateTitle(L["CustomIndicatorPickerEmpty"])
			elseif rowCount > maxMenuRowsBeforeScroll and rootDescription.SetScrollMode then
				rootDescription:SetScrollMode(maxMenuRowsBeforeScroll * menuRowHeight)
			end
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
			addButton:SetEnabled(blockReason == nil)
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
		local notTracked = false
		local badgeTooltip = nil
		if isCustom then
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
				row.colorPicker.Font:SetText(def.colorLabel)
				-- After the relabel: the badge is placed past the measured end of the new text.
				Primitives:AttachCdmBadgeToText(row.colorPicker.Font, def.cdm)
				Primitives:AttachCustomBadgeToText(row.colorPicker.Font, isCustom, notTracked, badgeTooltip or "")
			end
			Primitives:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
			-- Colors and targets stay editable for when the entry is tracked again; only the name says it isn't.
			if notTracked and row.colorPicker.Font then
				row.colorPicker.Font:SetFontObject(GameFontDisable)
			end
		end
		-- Update dropdown text
		if row.dropdown then
			row.dropdown:SetText(GetSummaryText(key))
		end
		row.removeBtn:SetShown(isCustom)
		row.editBtn:SetShown(isCustom)
		row.editBtn:SetEnabled(blockReason == nil)
		-- Arrow enabled state
		if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
		if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedKeys) end
	end

	local function RefreshAllRows()
		UpdatePickerBlock()
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

	-- Everything from the Add button down moves when a row is added or removed.
	local belowTopY = nil

	local RemoveCustomIndicator

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
			if currentDef == nil or not currentDef.custom then return end
			StaticPopup_Show("TwintopResourceBar_ConfirmDeleteCustomIndicator",
				string.format(L["CustomIndicatorDeleteConfirmation"], currentDef.colorLabel or currentKey), nil, {
					remove = function()
						RemoveCustomIndicator(currentKey)
					end,
				})
		end)
		row.removeBtn:SetScript("OnEnter", function(self)
			ShowRowButtonTooltip(self, L["CustomIndicatorRemoveTooltip"])
		end)
		row.removeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

		row.editBtn = Primitives:BuildEditIconButton(parent, 0, 0)
		row.editBtn:SetScript("OnClick", function(self)
			local currentKey = orderedKeys[capturedRowIdx]
			local currentIndicator = indicatorColors[currentKey]
			local conditions = currentIndicator and currentIndicator.custom and currentIndicator.custom.conditions
			local condition = conditions and conditions[1]
			if condition == nil then return end
			-- The Cooldown Manager or spec can change under an open panel; say why instead of doing nothing.
			if GetPickerBlock() ~= nil then
				RefreshAllRows()
				ShowRowButtonTooltip(self, L["CustomIndicatorEditTooltip"])
				return
			end
			OpenPicker(self, condition.cooldownID, function(entry)
				cdm:PointConditionAt(condition, entry, true)
				RefreshRow(capturedRowIdx)
				RefreshRuntime()
			end)
		end)
		row.editBtn:SetScript("OnEnter", function(self)
			-- A block can clear without any event, which would leave the button greyed with no reason.
			if not self:IsEnabled() and GetPickerBlock() == nil then
				RefreshAllRows()
			end
			ShowRowButtonTooltip(self, L["CustomIndicatorEditTooltip"])
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
		---@cast cp Button
		cp.Swatch1:SetScript("OnMouseDown", function(self, button)
			local currentKey = orderedKeys[capturedRowIdx]
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, indicatorColors, { [currentKey] = rows[capturedRowIdx].colorPicker }, currentKey, "indicatorColor_" .. currentKey)
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
		---@diagnostic disable-next-line: inject-field
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

	---@return string
	local function NextCustomKey()
		local n = 1
		while indicatorColors["custom_" .. n] ~= nil do
			n = n + 1
		end
		return "custom_" .. n
	end

	---Adds a custom indicator for an entry at the lowest priority, white and untargeted, and grows the
	---list by one row.
	---@param entry TRB.CdmLayoutEntry
	local function AddCustomIndicator(entry)
		local key = NextCustomKey()
		---@type TRB.CustomIndicatorCondition
		local condition = { source = cdm.CONDITION_SOURCE, state = cdm.ConditionState.ACTIVE, cooldownID = entry.cooldownID }
		cdm:PointConditionAt(condition, entry, true)
		indicatorColors[key] = {
			color = "FFFFFFFF",
			color2 = "FFFFFFFF",
			gradientDirection = "disabled",
			enabled = false,
			targets = {},
			custom = { conditions = { condition } },
		}
		table.insert(sharedSettings.nodeOrder, key)
		indicatorDefByKey[key] = { key = key, custom = true, colorLabel = "" }
		orderedKeys[#orderedKeys + 1] = key

		Primitives:ShiftControlsBelow(parent, belowTopY, -30)
		belowTopY = belowTopY - 30

		local rowIndex = #orderedKeys
		if rows[rowIndex] == nil then
			BuildRow(rowIndex)
		else
			PositionRow(rows[rowIndex], rowIndex)
			SetRowShown(rows[rowIndex], true)
		end
		UpdatePickerBlock()
		RefreshRow(rowIndex, true)
		if rowIndex > 1 then
			RefreshRow(rowIndex - 1, true)
		end
		RefreshAddButton()
		RefreshRuntime()
	end

	---Deletes a custom indicator and shrinks the list by one row.
	---@param key string
	RemoveCustomIndicator = function(key)
		local removeIndex = nil
		for i, k in ipairs(orderedKeys) do
			if k == key then
				removeIndex = i
				break
			end
		end
		if removeIndex == nil then return end

		table.remove(orderedKeys, removeIndex)
		for i, k in ipairs(sharedSettings.nodeOrder) do
			if k == key then
				table.remove(sharedSettings.nodeOrder, i)
				break
			end
		end
		indicatorColors[key] = nil
		indicatorDefByKey[key] = nil

		local lastRow = rows[#orderedKeys + 1]
		if lastRow ~= nil then
			SetRowShown(lastRow, false)
		end
		Primitives:ShiftControlsBelow(parent, belowTopY, 30)
		belowTopY = belowTopY + 30

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
		local reason = GetPickerBlock()
		if reason ~= nil then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(reason, 1, 1, 1, 1, true)
			GameTooltip:Show()
		elseif not self:IsEnabled() then
			RefreshAllRows()
		end
	end)
	addButton:SetScript("OnClick", function(self)
		if GetPickerBlock() ~= nil then
			RefreshAllRows()
			self:GetScript("OnEnter")(self)
			return
		end
		OpenPicker(self, nil, AddCustomIndicator)
	end)
	addButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	belowTopY = yCoord
	yCoord = yCoord - 30

	RefreshAllRows()

	-- Read a frame late, so Blizzard's own listeners for the same callback rebuild the layout first.
	parent:HookScript("OnShow", RefreshAllRows)
	if EventRegistry ~= nil then
		local refreshQueued = false
		EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged", function()
			if refreshQueued or not parent:IsVisible() then return end
			refreshQueued = true
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
		controls.gradientNote = TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["GradientColorOverridesNote"], oUi.xCoord, yCoord, oUi.maxOptionsWidth, 28)
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
					row.colorPicker.Font:SetText(def.colorLabel)
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

		for gradIdx, gradKey in ipairs(orderedGradientKeys) do
			local gradDef = indicatorDefByKey[gradKey]
			local gradIndicator = indicatorColors[gradKey]
			if gradDef and gradIndicator then
				local capturedGradIdx = gradIdx
				local gradRow = {}
				gradientRows[gradIdx] = gradRow

				local xOffset = oUi.xCoord + customColumnWidth

				-- Up arrow
				local upBtn = CreateFrame("Button", nil, parent)
				upBtn:SetSize(20, 20)
				upBtn:SetPoint("TOPLEFT", xOffset, yCoord)
				upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
				upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
				upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
				upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
				upBtn:SetEnabled(gradIdx > 1)
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
				downBtn:SetPoint("TOPLEFT", xOffset + 22, yCoord)
				downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
				downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
				downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
				downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
				downBtn:SetEnabled(gradIdx < #orderedGradientKeys)
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

				xOffset = xOffset + 46

				-- Targets dropdown
				local ddName = ddNamePrefix .. "_Gradient_" .. gradKey .. "_Targets"
				local dd = CreateFrame("DropdownButton", ddName, parent, "WowStyle1DropdownTemplate")
				dd:SetWidth(targetsDropdownWidth)
				dd:SetPoint("TOPLEFT", xOffset, yCoord)
				dd:SetScript("OnEnter", function(self)
					if gradDef.tooltip then
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(gradDef.tooltip, 1, 1, 1, 1, true)
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

				dd:SetText(GetSummaryText(gradKey))
				gradRow.dropdown = dd

				-- Color picker
				local cp = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, gradDef.colorLabel, gradIndicator.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
				---@cast cp Button
				cp:SetScript("OnMouseDown", function(self, button)
					local gk = orderedGradientKeys[capturedGradIdx]
					TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, indicatorColors, { [gk] = gradRow.colorPicker }, gk, "indicatorColor_" .. gk)
				end)
				TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(cp, gradIndicator.enabled)
				gradRow.colorPicker = cp

				controls.indicatorColors.gradientRows[gradIdx] = gradRow

				yCoord = yCoord - 30
			end
		end
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
	---@diagnostic disable-next-line: inject-field
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

