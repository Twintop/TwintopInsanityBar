---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.PetBars = TRB.Functions.OptionsUi.PetBars or {}

--[[
	Pet Bars options panel. One builder, parameterized by barKey ("petPower" / "petHealth"), editing the
	given spec's settings or core when classId/specId are nil. Dimensions come from the shared custom-bar
	generator; colors route through the same one the Stagger bar uses, which gives Pet Health its threshold
	curve and Pet Resource its flat fill. Per-section "Use Global" toggles mirror the cast bars.
]]

---Constructs the appearance options for one Pet bar.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param barKey string # "petPower" or "petHealth"
function TRB.Functions.OptionsUi.PetBars:ConstructPanel(parent, classId, specId, barKey)
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
	controls.checkBoxes = controls.checkBoxes or {}
	controls.colors = controls.colors or {}

	local yCoord = 5

	-- Pet Resource is a screen-anchored root by default and Pet Health chains below it, but both are
	-- freely re-anchorable here.
	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, barDef.displayName, barKey .. "Dimensions")
	yCoord = yCoord - 60

	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, barDef, nil, barKey .. "Colors")
	yCoord = yCoord - 30

	return yCoord
end
