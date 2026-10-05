---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.OtherBars = TRB.Functions.OptionsUi.OtherBars or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

--[[
	Other Bars options panel. One builder, parameterized by barKey ("gcd" / "fatigue" / "breath" /
	"feignDeath", plus the swing bars where the flavor has them). Edits the given spec's per-spec settings,
	or core when classId/specId are nil.
	Per-section "Use Global" toggles mirror the cast bars: Dimensions and Colors each copy their
	slice from core independently.

	These bars have no icon, no overlays and no cast states -- a timer runs or it doesn't -- so the panel
	is just dimensions, colors, and each kind's behavior options.
]]

---Reapplies layout + appearance so option changes show immediately. Recomposes the active spec's cache
---first, for the same reason the cast bar panels do: the render reads the composed cache, which is
---rebuilt fresh whenever a Use Global category is on, so a raw edit only lands after a re-fill.
local function ReapplyBars()
	local char = TRB.Data.character
	if char ~= nil and char.className ~= nil and char.specName ~= nil
		and char.compositeKey ~= nil and TRB.Data.specCache[char.compositeKey] ~= nil then
		TRB.Functions.Character:FillSpecializationCacheSettings(char.className, char.specName)
		if TRB.Frames.barGroups ~= nil then
			local settings = TRB.Data.specCache[char.compositeKey].settings
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		end
	end
	TRB.Data.lookupDirty = true
	TRB.Functions.BarText:InvalidateOtherBarsLookup()
	TRB.Functions.OtherBars:RefreshVisibility()
end

---@param barKey string
---@return boolean
local function IsSwingBar(barKey)
	for _, key in ipairs(TRB.Classes.BarTypeRegistry.swingBarKeys) do
		if key == barKey then
			return true
		end
	end
	return false
end

---Constructs the appearance options for one Other Bar within a spec.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param barKey string # "gcd", "fatigue", "breath", "feignDeath", "mainHandSwing", "offHandSwing" or "rangedSwing"
function TRB.Functions.OptionsUi.OtherBars:ConstructPanel(parent, classId, specId, barKey)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec
	if classId == nil then
		spec = TRB.Data.settings.core
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
	end
	if spec == nil then
		return
	end

	local barDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(barKey)
	local barSettings = spec.bars and spec.bars[barKey]
	local colors = spec.colors and spec.colors.bars and spec.colors.bars[barKey]
	if barDef == nil or barSettings == nil or colors == nil then
		return
	end

	local controlsKey = (classId == nil) and "core" or (classNameLower .. "_" .. specName)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[controlsKey] = interfaceSettingsFrame.controls[controlsKey] or {}
	local controls = interfaceSettingsFrame.controls[controlsKey]
	controls[barKey] = controls[barKey] or {}
	local cc = controls[barKey]
	cc.fill = {}

	local namePrefix = "TwintopResourceBar_" .. controlsKey .. "_" .. barKey
	local yCoord = 5

	-- A class-scoped bar (Feign Death) has no global counterpart, so it gets no Use Global rows -- its
	-- specs own it outright. Every other Other Bar has the usual Dimensions / Colors global sections.
	local hasGlobalScope = TRB.Classes.BarTypeRegistry:IsGlobalScopeBar(barKey)

	-- Dimensions / anchoring. Fatigue is a screen-anchored root by default and the other mirror timers
	-- chain below it, but every one of them is freely re-anchorable here.
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, barDef.displayName, hasGlobalScope and (barKey .. "Dimensions") or nil)
	yCoord = yCoord - 60

	-- Colors: fill / border / background / end cap.
	controls[barKey .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OtherBarsColorsHeader"], oUi.xCoord, yCoord)
	local colorsCheckbox = nil
	if hasGlobalScope then
		yCoord, colorsCheckbox = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalSectionRow(parent, controls, classId, specId, barKey .. "Colors", yCoord, { tooltip = L["CheckboxUseGlobalTooltipOtherBars"] })
	end
	yCoord = yCoord - 30
	-- The fill takes a gradient; border and background are single-color, as everywhere else.
	TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorRow(parent, cc.fill, colors, "bar", L["OtherBarsColorFill"], yCoord, classId, specId, ReapplyBars)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "border", L["ColorPickerBorder"], yCoord, classId, specId)
	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(parent, cc.fill, colors, "background", L["ColorPickerUnfilledBarBackground"], yCoord, classId, specId)
	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colors, controlsKey .. "_" .. barKey, "endCap_" .. barKey, L["EndCap"], classId, specId)
	yCoord = yCoord - 40
	TRB.Functions.OptionsUi.GlobalSettings:AttachUseGlobalCover(colorsCheckbox, controls[barKey .. "ColorSection"], yCoord)

	-- Behaviour: the GCD and swing bars pick their fill direction; a mirror timer can take Blizzard's bar off screen.
	local isSwing = IsSwingBar(barKey)
	controls[barKey .. "BehaviorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["OtherBarsBehaviorHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	if isSwing then
		local note = barKey == "mainHandSwing" and L["SwingTimerMainHandNote"] or L["SwingTimerWeaponNote"]
		TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, note, oUi.xCoord, yCoord, 700, 20, GameFontHighlight)
		yCoord = yCoord - 30
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_timerDirection", L["GcdBarGrowInstead"], L["SwingTimerGrowInsteadTooltip"], yCoord,
			function() return barSettings.timerDirection == "fill" end,
			function(v)
				barSettings.timerDirection = v and "fill" or "deplete"
				ReapplyBars()
			end)
	elseif barKey == "gcd" then
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_timerDirection", L["GcdBarGrowInstead"], L["GcdBarGrowInsteadTooltip"], yCoord,
			function() return barSettings.timerDirection == "fill" end,
			function(v)
				barSettings.timerDirection = v and "fill" or "deplete"
				ReapplyBars()
			end)
	else
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_disableBlizzardBar", L["MirrorTimerDisableBlizzard"], L["MirrorTimerDisableBlizzardTooltip"], yCoord,
			function() return barSettings.disableBlizzardBar end,
			function(v)
				barSettings.disableBlizzardBar = v
				ReapplyBars()
				TRB.Functions.OtherBars:UpdateBlizzardMirrorTimerVisibility()
			end)
	end
	yCoord = yCoord - 40

	-- Decimal places for the GCD's and swing bars' duration bar text variables. The mirror timers run for
	-- minutes and render as mm:ss, so they have no decimals to configure.
	if barKey == "gcd" or isSwing then
		cc.durationPrecision = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["OtherBarsDurationPrecision"], 0, 3, barSettings.durationPrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		cc.durationPrecision:SetScript("OnValueChanged", function(sliderFrame, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			sliderFrame.EditBox:SetText(value)
			barSettings.durationPrecision = value
			ReapplyBars()
		end)
		yCoord = yCoord - 60
	end

	-- The Colors section's box also carries this section's settings.
	TRB.Functions.OptionsUi.GlobalSettings:AttachLinkedUseGlobalCover(colorsCheckbox, controls[barKey .. "ColorSection"], controls[barKey .. "BehaviorSection"], yCoord)

	-- One Hide Blizzard switch for all three swing bars, stored on Main Hand and following Main Hand's Colors box.
	if isSwing then
		controls[barKey .. "BlizzardSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["SwingTimerBlizzardHeader"], oUi.xCoord, yCoord)
		yCoord = yCoord - 30
		cc.disableBlizzardBar = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_disableBlizzardBar", L["MirrorTimerDisableBlizzard"], L["SwingTimerDisableBlizzardTooltip"], yCoord,
			function() return spec.bars.mainHandSwing.disableBlizzardBar end,
			function(v)
				spec.bars.mainHandSwing.disableBlizzardBar = v
				for _, swingKey in ipairs(TRB.Classes.BarTypeRegistry.swingBarKeys) do
					local siblingCheckbox = controls[swingKey] and controls[swingKey].disableBlizzardBar
					if siblingCheckbox ~= nil then
						siblingCheckbox:SetChecked(v)
					end
				end
				ReapplyBars()
			end)
		yCoord = yCoord - 40
		-- Main Hand is the first Other Bars tab and built eagerly, so its box exists before the lazy tabs build.
		local mainHandColorsCheckbox = controls.checkBoxes and controls.checkBoxes.useGlobalMainHandSwingColors
		local governingHeader = barKey == "mainHandSwing" and controls[barKey .. "ColorSection"] or L["CopyMenuSection_mainHandSwingColors"]
		TRB.Functions.OptionsUi.GlobalSettings:AttachLinkedUseGlobalCover(mainHandColorsCheckbox, governingHeader, controls[barKey .. "BlizzardSection"], yCoord)
	end

	return yCoord
end
