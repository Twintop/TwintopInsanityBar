---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Bar = {}

---Computes the width of each Combo Point node
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return number
local function GetComboPointNodeWidth(settings)
	if settings.comboPoints ~= nil and TRB.Data.character.maxResource2 ~= nil and TRB.Data.character.maxResource2 > 0 then
		if settings.comboPoints.fullWidth then
			local nodes = TRB.Data.character.maxResource2
			local nodeSpacing = settings.comboPoints.spacing + settings.comboPoints.border * 2
			local width = ((settings.bar.width - ((nodes - 1) * (nodeSpacing - settings.comboPoints.border * 2))) / nodes)
			return width
		else
			return settings.comboPoints.width
		end
	end
	return 0
end

---Computes the absolute min/max values for the bar
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@return table
function TRB.Functions.Bar:GetSanityCheckValues(settings)
	local sc = {}
	if settings ~= nil then
		if settings.bar ~= nil then
			sc.barMaxWidth = math.floor(GetScreenWidth())
			sc.barMinWidth = math.max(math.ceil(settings.bar.border * 2), 120)
			sc.barMaxHeight = math.floor(GetScreenHeight())
			sc.barMinHeight = math.max(math.ceil(settings.bar.border * 2), 1)
		end

		if settings.comboPoints ~= nil then
			sc.comboPointsMaxWidth = math.floor(GetScreenWidth() / 10) -- This should really be based on the maximum Combo Points for a specialization. Enhancement Shaman would be max (10), Devourer Demon Hunter would be min (1)
			sc.comboPointsMinWidth = math.max(math.ceil(settings.comboPoints.border * 2), 1)
			sc.comboPointsMaxHeight = math.floor(GetScreenHeight())
			sc.comboPointsMinHeight = math.max(math.ceil(settings.comboPoints.border * 2), 1)
		end
	end
	return sc
end

---Updates absolute min/max values for the bar
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.Bar:UpdateSanityCheckValues(settings)
	local sc = TRB.Functions.Bar:GetSanityCheckValues(settings)
	if settings ~= nil and settings.bar ~= nil then
		TRB.Data.sanityCheckValues.barMaxWidth = sc.barMaxWidth
		TRB.Data.sanityCheckValues.barMinWidth = sc.barMinWidth
		TRB.Data.sanityCheckValues.barMaxHeight = sc.barMaxHeight
		TRB.Data.sanityCheckValues.barMinHeight = sc.barMinHeight
	end
end

function TRB.Functions.Bar:ShowResourceBar()
	if TRB.Details.addonData.registered == false then
		TRB.Functions.Class:EventRegistration()
	end

	TRB.Data.snapshotData.attributes.isTracking = true
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Bar:HideResourceBar(force)
	force = force or false
	
	if TRB.Data.character.inPetBattle or TRB.Data.character.onTaxi then
		force = true
	end

	TRB.Functions.Class:HideResourceBar(force)
end

---Shows or hides the resource bar based on general/generic logic.
---Most classes will use this, the exception being Druids because of Balance with Nature's Balance.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param force boolean
---@param notZeroShowValue number
---@param includeComboPoints boolean?
---@param notZeroShowValueComboPoints number?
function TRB.Functions.Bar:HideResourceBarGeneric(settings, force, notZeroShowValue, includeComboPoints, notZeroShowValueComboPoints)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	if settings ~= nil then
		local affectingCombat = TRB.Data.character.inCombat
		if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not settings.displayBar.dragonriding) or
			((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not settings.displayBar.alwaysShow)) and (
					(not settings.displayBar.notZeroShow) --[[or
					(settings.displayBar.notZeroShow and (snapshotData.attributes.resource / TRB.Data.resourceFactor) == notZeroShowValue and
						(includeComboPoints ~= true or (includeComboPoints and (snapshotData.attributes.resource2 / TRB.Data.resource2Factor) == notZeroShowValueComboPoints))
					)
				)]]
			)) then
			TRB.Frames.barContainerFrame:Hide()
			TRB.Functions.BarText:Hide(settings)
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if settings.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Functions.BarText:Hide(settings)
			else
				TRB.Frames.barContainerFrame:Show()
				TRB.Functions.BarText:Show(settings)
			end
		end
	else
		TRB.Frames.barContainerFrame:Hide()
		TRB.Functions.BarText:Hide(settings)
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Bar:PulseFrame(frame, alphaOffset, flashPeriod)
	if alphaOffset > 1.0 then
		alphaOffset = 1.0
	elseif alphaOffset < 0 then
		alphaOffset = 0
	end

	if flashPeriod <= 0 then
		flashPeriod = 0.5
	end
	
	frame:SetAlpha(((1.0 - alphaOffset) * math.abs(math.sin(2 * (GetTime() / flashPeriod)))) + alphaOffset)
end

function TRB.Functions.Bar:SetHeight(settings)
	local value = settings.bar.height

	TRB.Frames.barContainerFrame:SetHeight(value - (settings.bar.border * 2))
	TRB.Frames.barBorderFrame:SetHeight(settings.bar.height)
	TRB.Frames.resourceFrame:SetHeight(value - (settings.bar.border * 2))
	TRB.Functions.Threshold:RedrawThresholdLines()
end

function TRB.Functions.Bar:SetWidth(settings)
	local value = settings.bar.width

	TRB.Frames.barContainerFrame:SetWidth(value - (settings.bar.border * 2))
	TRB.Frames.barBorderFrame:SetWidth(settings.bar.width)
	TRB.Frames.resourceFrame:SetWidth(value - (settings.bar.border * 2))
	TRB.Functions.Bar:SetMinMax(settings)
end

function TRB.Functions.Bar:SetPositionXY(xOfs, yOfs)
	if TRB.Functions.Number:IsNumeric(xOfs) and TRB.Functions.Number:IsNumeric(yOfs) then
		if xOfs < math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth / 2) then
			xOfs = math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth / 2)
		elseif xOfs > math.floor(TRB.Data.sanityCheckValues.barMaxWidth / 2) then
			xOfs = math.floor(TRB.Data.sanityCheckValues.barMaxWidth / 2)
		end

		if yOfs < math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight / 2) then
			yOfs = math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight / 2)
		elseif yOfs > math.floor(TRB.Data.sanityCheckValues.barMaxHeight / 2) then
			yOfs = math.floor(TRB.Data.sanityCheckValues.barMaxHeight / 2)
		end

		if TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar then
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].horizontal:SetValue(xOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0, nil, true))
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].vertical:SetValue(yOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls["global"].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0, nil, true))
		else
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal:SetValue(xOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0, nil, true))
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical:SetValue(yOfs)
			TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0, nil, true))
		end
	end
end

function TRB.Functions.Bar:GetPosition(settings)
	local _, _, relativePoint, xOfs, yOfs = TRB.Frames.barContainerFrame:GetPoint()

	if relativePoint == "CENTER" then
		--No action needed.
	elseif relativePoint == "TOP" then
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight / 2) + yOfs - (settings.bar.height / 2))
	elseif relativePoint == "TOPRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth / 2) + xOfs - (settings.bar.width / 2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight / 2) + yOfs - (settings.bar.height / 2))
	elseif relativePoint == "RIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth / 2) + xOfs - (settings.bar.width / 2))
	elseif relativePoint == "BOTTOMRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth / 2) + xOfs - (settings.bar.width / 2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight / 2) - yOfs - (settings.bar.height / 2))
	elseif relativePoint == "BOTTOM" then
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight / 2) - yOfs - (settings.bar.height / 2))
	elseif relativePoint == "BOTTOMLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth / 2) - xOfs - (settings.bar.width / 2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight / 2) - yOfs - (settings.bar.height / 2))
	elseif relativePoint == "LEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth / 2) - xOfs - (settings.bar.width / 2))
	elseif relativePoint == "TOPLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth / 2) - xOfs - (settings.bar.width / 2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight / 2) + yOfs - (settings.bar.height / 2))
	end

	TRB.Functions.Bar:SetPositionXY(xOfs, yOfs)
end

---Sets the values for a resource bar
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param bar frame
---@param value number
---@param maxResource number
function TRB.Functions.Bar:SetValue(settings, key, bar, value, maxResource)
	TRB.Data.cache.values.bar[key] = TRB.Data.cache.values.bar[key] or {}
	local valueIsSecret = issecretvalue(value)
	local maxResourceIsSecret = issecretvalue(maxResource)
	if not valueIsSecret and not maxResourceIsSecret and TRB.Data.cache.values.bar[key].value == value and TRB.Data.cache.values.bar[key].maxResource == maxResource then
		return
	end
	
	if settings ~= nil and settings.bar ~= nil and bar ~= nil then
		local _, max = bar:GetMinMaxValues()
		local barMaxValueIsSecret = issecretvalue(max)

		if barMaxValueIsSecret or valueIsSecret or maxResourceIsSecret then
			if TRB.Data.settings.core.smoothBarValueUpdates then
				bar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut)
			else
				bar:SetValue(value, Enum.StatusBarInterpolation.Immediate)
			end
		else
			maxResource = maxResource or 1
			value = value or 0

			local factor = max / maxResource

			if maxResource == 0 then
				factor = max / 1
			end

			local scaledValue = value * factor
			if factor ~= math.huge and max ~= math.huge then
				if TRB.Data.settings.core.smoothBarValueUpdates then
					bar:SetValue(math.min(scaledValue, max), Enum.StatusBarInterpolation.ExponentialEaseOut)
				else
					bar:SetValue(math.min(scaledValue, max), Enum.StatusBarInterpolation.Immediate)
				end
			end
		end

		TRB.Data.cache.values.bar[key].value = value
		TRB.Data.cache.values.bar[key].maxResource = maxResource
	end
end

---Sets the value for a primary resource bar
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param bar frame
---@param value number
function TRB.Functions.Bar:SetPrimaryValue(settings, key, bar, value)
	if TRB.Data.character.maxResource ~= nil and TRB.Data.character.maxResource > 0 then
		if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
			TRB.Functions.Bar:SetValue(settings, key, bar, value, math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource))
		else
			TRB.Functions.Bar:SetValue(settings, key, bar, value, TRB.Data.character.maxResource)
		end
	end
end

---Sets the minimum and maximum values for all bars
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.Bar:SetMinMax(settings)
	if settings ~= nil and settings.bar ~= nil then
		local max = TRB.Data.character.maxResource

		if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
			max = math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource)
		end

		TRB.Frames.resourceFrame:SetMinMaxValues(0, max)-- settings.bar.width)
		if TRB.Frames.resource2Frames ~= nil and TRB.Data.resource2 ~= "CUSTOM" then
			if TRB.Data.character.classId ~= 7 or (TRB.Data.character.classId == 7 and TRB.Details.addonData.build ~= "64914") then -- Enhancement Shaman
				local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
				local nodes = TRB.Data.character.maxResource2
				local nodeWidth = GetComboPointNodeWidth(settings)

				if nodes == nil or nodes == 0 then
					nodes = length
				end

				for x = 1, math.min(nodes, 10) do
					TRB.Frames.resource2Frames[x].resourceFrame:SetMinMaxValues(0, nodeWidth)
				end
			end
		end
	end
end

---Sets the positioning of the `containerFrame` with respect to the Personal Resource Display
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param containerFrame frame
function TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(settings, containerFrame)
	--[[if settings.bar.pinToPersonalResourceDisplay then
		containerFrame:ClearAllPoints()
		containerFrame:SetPoint("CENTER", C_NamePlate.GetNamePlateForUnit("player"), "CENTER", settings.bar.xPos, settings.bar.yPos)
	end]]
end

---Sets the position of the `containerFrame`
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param containerFrame frame
function TRB.Functions.Bar:SetPosition(settings, containerFrame)
	if settings == nil then
		return
	end

	--[[if settings.bar.pinToPersonalResourceDisplay then
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(settings, containerFrame)
	else]]
		containerFrame:ClearAllPoints()
		containerFrame:SetPoint("CENTER", UIParent)
		containerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	--end

	if TRB.Frames.resource2Frames ~= nil and settings.comboPoints ~= nil and TRB.Functions.Character:IsComboPointUser() then
		local containerFrame2 = TRB.Frames.resource2ContainerFrame
		local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
		local nodes = TRB.Data.character.maxResource2 or 1

		if nodes == nil then
			nodes = length
		end
	
		local nodeWidth = settings.comboPoints.width
		local nodeSpacing = settings.comboPoints.spacing + settings.comboPoints.border * 2
		local xPos
		local yPos
		local totalWidth = nodes * settings.comboPoints.width + (nodes-1) * settings.comboPoints.spacing
		local setPoint = "BOTTOM"
		local setPointRelativeTo = "TOP"
		local topBottom = "TOP"
		local leftCenterRight = "CENTER"
		
		if settings.comboPoints.relativeTo == "TOPLEFT" then
			setPoint = "BOTTOMLEFT"
			setPointRelativeTo = "TOPLEFT"
			leftCenterRight = "LEFT"
		elseif settings.comboPoints.relativeTo == "TOP" then
			setPoint = "BOTTOM"
			setPointRelativeTo = "TOP"
		elseif settings.comboPoints.relativeTo == "TOPRIGHT" then
			setPoint = "BOTTOMRIGHT"
			setPointRelativeTo = "TOPRIGHT"
			leftCenterRight = "RIGHT"
		elseif settings.comboPoints.relativeTo == "BOTTOMLEFT" then
			setPoint = "TOPLEFT"
			setPointRelativeTo = "BOTTOMLEFT"
			topBottom = "BOTTOM"
			leftCenterRight = "LEFT"
		elseif settings.comboPoints.relativeTo == "BOTTOM" then
			setPoint = "TOP"
			setPointRelativeTo = "BOTTOM"
			topBottom = "BOTTOM"
		elseif settings.comboPoints.relativeTo == "BOTTOMRIGHT" then
			setPoint = "TOPRIGHT"
			setPointRelativeTo = "BOTTOMRIGHT"
			topBottom = "BOTTOM"
			leftCenterRight = "RIGHT"
		end

		if settings.comboPoints.fullWidth then
			nodeWidth = GetComboPointNodeWidth(settings)

			xPos = 0
			totalWidth = settings.bar.width

			if topBottom == "BOTTOM" then
				setPoint = "TOP"
				setPointRelativeTo = "BOTTOM"
			else
				setPoint = "BOTTOM"
				setPointRelativeTo = "TOP"
			end
			leftCenterRight = "CENTER"
		else
			if leftCenterRight == "LEFT" then
				xPos = -settings.bar.border + settings.comboPoints.xPos
			elseif leftCenterRight == "RIGHT" then
				xPos = settings.bar.border + settings.comboPoints.xPos
			else
				xPos = settings.comboPoints.xPos
			end
		end

		if topBottom == "BOTTOM" then
			yPos = -settings.bar.border + settings.comboPoints.yPos - settings.comboPoints.border
		else
			yPos = settings.bar.border + settings.comboPoints.yPos - settings.comboPoints.border
		end

		containerFrame2:Show()
		containerFrame2:SetWidth(totalWidth)
		containerFrame2:SetHeight(settings.comboPoints.height)
		containerFrame2:SetFrameStrata(TRB.Data.settings.core.strata.level)
		containerFrame2:SetFrameLevel(TRB.Data.constants.frameLevels.cpContainer)
		containerFrame2:ClearAllPoints()
		containerFrame2:SetPoint(setPoint, containerFrame, setPointRelativeTo, xPos, yPos)

		for x = 1, length do
			local container = TRB.Frames.resource2Frames[x].containerFrame
			local border = TRB.Frames.resource2Frames[x].borderFrame
			local resource = TRB.Frames.resource2Frames[x].resourceFrame

			if x <= nodes then
				container:Show()
				container:SetWidth(nodeWidth-(settings.comboPoints.border*2))
				container:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
				container:ClearAllPoints()
				
				if x == 1 then
					container:SetPoint("TOPLEFT", containerFrame2, "TOPLEFT", settings.comboPoints.border, 0)
				else
					container:SetPoint("LEFT", TRB.Frames.resource2Frames[x-1].containerFrame, "RIGHT", nodeSpacing, 0)
				end
			
				if settings.comboPoints.border < 1 then
					border:Show()
					border.backdropInfo = {
						edgeFile = settings.textures.comboPointsBorder,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					}
					border:ApplyBackdrop()
					border:Hide()
				else
					border:Show()
					border.backdropInfo = {
						edgeFile = settings.textures.comboPointsBorder,
						tile = true,
						tileSize = 4,
						edgeSize = settings.comboPoints.border,
						insets = {0, 0, 0, 0}
					}
					border:ApplyBackdrop()
				end
				border:SetBackdropColor(0, 0, 0, 0)
				border:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.comboPoints.border, true))

				border:SetWidth(nodeWidth)
				border:SetHeight(settings.comboPoints.height)
				
				resource:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
						
				container:SetFrameLevel(TRB.Data.constants.frameLevels.cpContainer)
				border:SetFrameLevel(TRB.Data.constants.frameLevels.cpBorder)
				resource:SetFrameLevel(TRB.Data.constants.frameLevels.cpResource)
			else
				container:Hide()
			end
		end
	end

	TRB.Functions.Threshold:RedrawThresholdLines()
	TRB.Functions.Bar:SetMinMax(settings)
end

---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.Bar:UpdateSmoothBar(settings)
	if settings == nil and TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
		settings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if TRB.Data.settings.core.smoothBarValueUpdates then --and not settings.bar.pinToPersonalResourceDisplay then
		if TRB.Frames.resourceFrame.thresholds ~= nil and #TRB.Frames.resourceFrame.thresholds > 0 then
			for x = 1, #TRB.Frames.resourceFrame.thresholds do
				TRB.Details.addonData.libs.LibSmoothMove:SmoothMove(TRB.Frames.resourceFrame.thresholds[x], 3, 0.2)
			end
		end
	else
		if TRB.Frames.resourceFrame.thresholds ~= nil and #TRB.Frames.resourceFrame.thresholds > 0 then
			for x = 1, #TRB.Frames.resourceFrame.thresholds do
				TRB.Details.addonData.libs.LibSmoothMove:Reset(TRB.Frames.resourceFrame.thresholds[x])
			end
		end
	end
end

function TRB.Functions.Bar:Construct(settings)
	if settings == nil and TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
		settings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if settings ~= nil and settings.bar ~= nil then
		local barContainerFrame = TRB.Frames.barContainerFrame
		local resourceFrame = TRB.Frames.resourceFrame
		local barBorderFrame = TRB.Frames.barBorderFrame

		barContainerFrame:Show()
		barContainerFrame:SetBackdrop({
			bgFile = settings.textures.background,
			tile = true,
			tileSize = settings.bar.width,
			edgeSize = 1,
			insets = {0, 0, 0, 0}
		})
		barContainerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.bar.background, true))
		barContainerFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
		barContainerFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
		barContainerFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		barContainerFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barContainer)

		barContainerFrame:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" and not self.isMoving and settings.bar.dragAndDrop then
				self:StartMoving()
				self.isMoving = true
			end
		end)

		barContainerFrame:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" and self.isMoving and settings.bar.dragAndDrop then
				self:StopMovingOrSizing()
				TRB.Functions.Bar:GetPosition(settings)
				self.isMoving = false
			end
		end)

		barContainerFrame:SetMovable(settings.bar.dragAndDrop)
		barContainerFrame:EnableMouse(settings.bar.dragAndDrop)

		barContainerFrame:SetScript("OnHide", function(self)
			if self.isMoving then
				self:StopMovingOrSizing()
				TRB.Functions.Bar:GetPosition(settings)
				self.isMoving = false
			end
		end)

		if settings.bar.border < 1 then
			barBorderFrame:Show()
			barBorderFrame.backdropInfo = {
				edgeFile = settings.textures.border,
				tile = true,
				tileSize = 4,
				edgeSize = 1,
				insets = {0, 0, 0, 0}
			}
			barBorderFrame:ApplyBackdrop()
			barBorderFrame:Hide()
		else
			barBorderFrame:Show()
			barBorderFrame.backdropInfo = {
				edgeFile = settings.textures.border,
				tile = true,
				tileSize = 4,
				edgeSize = settings.bar.border,
				insets = {0, 0, 0, 0}
			}
			barBorderFrame:ApplyBackdrop()
		end

		barBorderFrame:ClearAllPoints()
		barBorderFrame:SetPoint("CENTER", barContainerFrame)
		barBorderFrame:SetPoint("CENTER", 0, 0)
		barBorderFrame:SetBackdropColor(0, 0, 0, 0)
		barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.bar.border, true))
		barBorderFrame:SetWidth(settings.bar.width)
		barBorderFrame:SetHeight(settings.bar.height)
		barBorderFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		barBorderFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barBorder)

		resourceFrame:Show()
		resourceFrame:SetMinMaxValues(0, settings.bar.width)
		resourceFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
		resourceFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
		resourceFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
		resourceFrame:SetStatusBarTexture(settings.textures.resourceBar)
		resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.bar.base, true))
		resourceFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		resourceFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barResource)

		if TRB.Frames.resource2Frames ~= nil and settings.comboPoints ~= nil and TRB.Functions.Character:IsComboPointUser() then
			local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
			local nodes = TRB.Data.character.maxResource2

			if nodes == nil or nodes == 0 then
				nodes = length
			end

			local nodeWidth = settings.comboPoints.width

			for x = 1, length do
				local container = TRB.Frames.resource2Frames[x].containerFrame
				local border = TRB.Frames.resource2Frames[x].borderFrame
				local resource = TRB.Frames.resource2Frames[x].resourceFrame

				container:Show()
				container:SetBackdrop({
					bgFile = settings.textures.comboPointsBackground,
					tile = true,
					tileSize = nodeWidth,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				
				container:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
				container:SetFrameStrata(TRB.Data.settings.core.strata.level)
				container:SetFrameLevel(TRB.Data.constants.frameLevels.cpContainer)
		
				border:ClearAllPoints()
				border:SetPoint("CENTER", container)
				border:SetPoint("CENTER", 0, 0)
				border:SetBackdropColor(0, 0, 0, 0)
				border:SetFrameStrata(TRB.Data.settings.core.strata.level)
				border:SetFrameLevel(TRB.Data.constants.frameLevels.cpBorder)
		
				resource:Show()
				resource:SetMinMaxValues(0, 1)
				resource:SetPoint("LEFT", container, "LEFT", 0, 0)
				resource:SetPoint("RIGHT", container, "RIGHT", 0, 0)
				resource:SetStatusBarTexture(settings.textures.comboPointsBar)
				resource:SetFrameStrata(TRB.Data.settings.core.strata.level)
				resource:SetFrameLevel(TRB.Data.constants.frameLevels.cpResource)

				if x > nodes then
					container:Hide()
				else
					container:Show()
				end
			end
		else
			if TRB.Frames.resource2ContainerFrame ~= nil then
				TRB.Frames.resource2ContainerFrame:Hide()
			end
		end

		TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)

		TRB.Functions.Bar:SetMinMax(settings)

		TRB.Functions.Bar:UpdateSmoothBar(settings)

		TRB.Functions.BarText:CreateBarTextFrames()
		TRB.Functions.BarText:Hide(settings)
		TRB.Functions.Class:HideResourceBar()
	end
end


--[[
	New OOP-based Bar System
	These functions work with TRB.Classes.BarGroup and TRB.Classes.BarNode
	to provide a parallel, object-oriented bar construction system.
]]

-- Initialize parallel storage for new bar system
TRB.Frames.barGroups = TRB.Frames.barGroups or {}

---Destroys existing bar groups before creating new ones
---Call this when switching specs to prevent orphaned frames
function TRB.Functions.Bar:DestroyBarGroups()
	if TRB.Frames.barGroups then
		for key, group in pairs(TRB.Frames.barGroups) do
			if group and group.Destroy then
				group:Destroy()
			end
		end
		TRB.Frames.barGroups = nil
	end
end

---Constructs bar groups using the new OOP system
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	-- Clear color caches to ensure fresh application on bar construction
	TRB.Data.cache.colors.border = {}
	TRB.Data.cache.colors.backdrop = {}

	self:ApplyBarGroupsLayout(settings, barGroups)
	self:ApplyBarGroupsAppearance(settings, barGroups)

	-- Create bar text frames (essential for bar text display)
	TRB.Functions.BarText:CreateBarTextFrames()
	TRB.Functions.BarText:Hide(settings)
	TRB.Functions.Class:HideResourceBar()
end

---Applies size/position/layout updates to existing bar groups (OOP system only).
---This is safe to call from Options UI sliders for live updates.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyBarGroupsLayout(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels

	-- Configure the primary bar group
	if barGroups.primary then
		local primary = barGroups.primary
		local primaryNode = primary:GetNode(1)

		-- First, position and size the group container (parent of nodes)
		-- This must be done BEFORE positioning child nodes
		primary.containerFrame:ClearAllPoints()
		primary.containerFrame:SetPoint("CENTER", UIParent, "CENTER", settings.bar.xPos, settings.bar.yPos)
		primary.containerFrame:SetWidth(settings.bar.width - (settings.bar.border * 2))
		primary.containerFrame:SetHeight(settings.bar.height - (settings.bar.border * 2))

		if primaryNode then
			-- Set frame strata
			primary:SetFrameStrata(strata)

			-- Set dimensions (stores values and sizes border/resource frames)
			primaryNode:SetDimensions(settings.bar.width, settings.bar.height, settings.bar.border)

			-- Set frame levels
			primaryNode:SetFrameLevels(
				frameLevels.barContainer,
				frameLevels.barBorder,
				frameLevels.barResource
			)

			-- Primary node should fill the primary group container
			local primaryNodeContainer = primaryNode:GetContainerFrame()
			if primaryNodeContainer then
				primaryNodeContainer:ClearAllPoints()
				primaryNodeContainer:SetAllPoints(primary.containerFrame)
			end

			-- Position the resource/border frames within the node container
			primaryNode:PositionResourceFrame()

			-- Set min/max values
			local max = TRB.Data.character.maxResource or settings.bar.width
			if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
				max = math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource or max)
			end
			primaryNode:SetMinMax(0, max)

			-- Enable drag and drop
			primary:SetDragAndDrop(settings.bar.dragAndDrop, settings)

			-- Show the primary bar (now parented directly to UIParent)
			primary:Show()
			primaryNode:Show()
		end
	end

	-- Configure secondary bar groups (combo points, arcane charges, runes, etc.)
	if barGroups.secondary and settings.comboPoints then
		self:ConstructSecondaryBarGroup(settings, barGroups.primary, barGroups.secondary, false)
		-- Demon Hunter Devourer: secondary is a true 0..50 bar, and values may be "secret".
		-- Keep the node min/max in that range so SetValue() works without scaling/clamping.
		if TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 3 then
			local sfNode = barGroups.secondary:GetNode(1)
			if sfNode then
				sfNode:SetMinMax(0, TRB.Data.character.maxResource2Value or 50)
			end
		end
	end
end

---Applies textures/colors to existing bar groups (OOP system only).
---This is intentionally separate from layout so moving/resizing doesn't inadvertently reset bar colors.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, barGroups)
	if settings == nil or settings.bar == nil or barGroups == nil then
		return
	end

	local frameLevels = TRB.Data.constants.frameLevels

	if barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:SetTextures(
				settings.textures.resourceBar,
				settings.textures.border,
				settings.textures.background
			)
			primaryNode:SetColor(settings.colors.bar.base)
			primaryNode:SetBorderColor(settings.colors.bar.border)
			primaryNode:SetBackgroundColorFromString(settings.colors.bar.background)
			primaryNode:SetFrameLevels(
				frameLevels.barContainer,
				frameLevels.barBorder,
				frameLevels.barResource
			)
		end
	end

	if barGroups.secondary and settings.comboPoints then
		local isDevourer = TRB.Data.character.className == "demonhunter" and TRB.Data.character.specId == 3
		for i = 1, barGroups.secondary.maxNodes do
			local node = barGroups.secondary:GetNode(i)
			if node then
				node:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)

				-- Secondary node min/max belongs with appearance (initial construct / appearance updates),
				-- not with layout (move/resize), to avoid clamping current values.
				if isDevourer and i == 1 then
					node:SetMinMax(0, TRB.Data.character.maxResource2Value or 50)
				else
					node:SetMinMax(0, 1)
				end
				node:SetBorderColor(settings.colors.comboPoints.border)
				node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
				node:SetColor(settings.colors.comboPoints.base)
				node:SetFrameLevels(
					frameLevels.cpContainer,
					frameLevels.cpBorder,
					frameLevels.cpResource
				)
			end
		end
	end
end

---Constructs a secondary bar group (combo points, arcane charges, etc.)
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param primaryGroup TRB.Classes.BarGroup
---@param secondaryGroup TRB.Classes.BarGroup
---@param applyAppearance boolean?
function TRB.Functions.Bar:ConstructSecondaryBarGroup(settings, primaryGroup, secondaryGroup, applyAppearance)
	if settings.comboPoints == nil then
		return
	end

	if applyAppearance == nil then
		applyAppearance = true
	end

	-- Verify the secondary group has valid nodes (not destroyed)
	if secondaryGroup.nodes == nil or secondaryGroup:GetNode(1) == nil then
		return
	end

	local strata = TRB.Data.settings.core.strata.level
	local frameLevels = TRB.Data.constants.frameLevels
	local nodes = TRB.Data.character.maxResource2
	if nodes == nil or nodes == 0 then
		nodes = secondaryGroup.maxNodes or 1
	end
	nodes = math.min(nodes, secondaryGroup.maxNodes or nodes)

	-- Set node count based on max resource
	secondaryGroup:SetNodeCount(nodes)

	-- Set layout parameters
	secondaryGroup:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")

	-- Set frame strata
	secondaryGroup:SetFrameStrata(strata)

	-- Calculate positioning
	local primaryContainer = primaryGroup:GetContainerFrame()
	local setPoint = "BOTTOM"
	local setPointRelativeTo = "TOP"
	local topBottom = "TOP"
	local leftCenterRight = "CENTER"

	if settings.comboPoints.relativeTo == "TOPLEFT" then
		setPoint = "BOTTOMLEFT"
		setPointRelativeTo = "TOPLEFT"
		leftCenterRight = "LEFT"
	elseif settings.comboPoints.relativeTo == "TOP" then
		setPoint = "BOTTOM"
		setPointRelativeTo = "TOP"
	elseif settings.comboPoints.relativeTo == "TOPRIGHT" then
		setPoint = "BOTTOMRIGHT"
		setPointRelativeTo = "TOPRIGHT"
		leftCenterRight = "RIGHT"
	elseif settings.comboPoints.relativeTo == "BOTTOMLEFT" then
		setPoint = "TOPLEFT"
		setPointRelativeTo = "BOTTOMLEFT"
		topBottom = "BOTTOM"
		leftCenterRight = "LEFT"
	elseif settings.comboPoints.relativeTo == "BOTTOM" then
		setPoint = "TOP"
		setPointRelativeTo = "BOTTOM"
		topBottom = "BOTTOM"
	elseif settings.comboPoints.relativeTo == "BOTTOMRIGHT" then
		setPoint = "TOPRIGHT"
		setPointRelativeTo = "BOTTOMRIGHT"
		topBottom = "BOTTOM"
		leftCenterRight = "RIGHT"
	end

	local xPos, yPos

	if settings.comboPoints.fullWidth then
		xPos = 0
		if topBottom == "BOTTOM" then
			setPoint = "TOP"
			setPointRelativeTo = "BOTTOM"
		else
			setPoint = "BOTTOM"
			setPointRelativeTo = "TOP"
		end
		leftCenterRight = "CENTER"
	else
		if leftCenterRight == "LEFT" then
			xPos = -settings.bar.border + settings.comboPoints.xPos
		elseif leftCenterRight == "RIGHT" then
			xPos = settings.bar.border + settings.comboPoints.xPos
		else
			xPos = settings.comboPoints.xPos
		end
	end

	if topBottom == "BOTTOM" then
		yPos = -settings.bar.border + settings.comboPoints.yPos - settings.comboPoints.border
	else
		yPos = settings.bar.border + settings.comboPoints.yPos - settings.comboPoints.border
	end

	-- Position the secondary container
	secondaryGroup.containerFrame:ClearAllPoints()
	secondaryGroup.containerFrame:SetPoint(setPoint, primaryContainer, setPointRelativeTo, xPos, yPos)
	secondaryGroup.containerFrame:SetFrameLevel(frameLevels.cpContainer)

	-- Apply layout to nodes
	secondaryGroup:ApplyLayout(
		settings.bar.width,
		settings.comboPoints.width,
		settings.comboPoints.height,
		settings.comboPoints.border
	)

	-- Apply appearance only when requested
	if applyAppearance then
		for i = 1, secondaryGroup.maxNodes do
			local node = secondaryGroup:GetNode(i)
			if node then
				node:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)

				-- Default secondary nodes are 0..1 for point-style resources.
				-- (Devourer overrides to 0..50 elsewhere.)
				node:SetMinMax(0, 1)
				node:SetFrameLevels(
					frameLevels.cpContainer,
					frameLevels.cpBorder,
					frameLevels.cpResource
				)
				node:SetBorderColor(settings.colors.comboPoints.border)
				node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
				node:SetColor(settings.colors.comboPoints.base)
			end
		end
	end

	-- Show the group and active nodes
	secondaryGroup:Show()
	secondaryGroup:ShowNodes(nodes)
end

---Updates the value on a BarNode using the standard caching mechanism
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param node TRB.Classes.BarNode
---@param value number
---@param maxResource number?
function TRB.Functions.Bar:SetBarNodeValue(settings, key, node, value, maxResource)
	TRB.Data.cache.values.bar[key] = TRB.Data.cache.values.bar[key] or {}
	local valueIsSecret = issecretvalue(value)
	local maxResourceIsSecret = maxResource and issecretvalue(maxResource) or false

	if not valueIsSecret and not maxResourceIsSecret and 
	   TRB.Data.cache.values.bar[key].value == value and 
	   TRB.Data.cache.values.bar[key].maxResource == maxResource then
		return
	end

	if settings ~= nil and settings.bar ~= nil and node ~= nil then
		local _, max = node:GetMinMax()
		local barMaxValueIsSecret = issecretvalue(max)

		if barMaxValueIsSecret or valueIsSecret or maxResourceIsSecret then
			node:SetValue(value)
		else
			maxResource = maxResource or 1
			value = value or 0

			local factor = max / maxResource

			if maxResource == 0 then
				factor = max / 1
			end

			local scaledValue = value * factor
			if factor ~= math.huge and max ~= math.huge then
				node:SetValue(math.min(scaledValue, max))
			end
		end

		TRB.Data.cache.values.bar[key].value = value
		TRB.Data.cache.values.bar[key].maxResource = maxResource
	end
end

---Sets the primary value on a BarNode
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param key string
---@param node TRB.Classes.BarNode
---@param value number
function TRB.Functions.Bar:SetBarNodePrimaryValue(settings, key, node, value)
	if TRB.Data.character.maxResource ~= nil and TRB.Data.character.maxResource > 0 then
		if settings.maxResource ~= nil and settings.maxResource.enabled == true and settings.maxResource.value > 0 then
			TRB.Functions.Bar:SetBarNodeValue(settings, key, node, value, math.min(settings.maxResource.value * TRB.Data.resourceFactor, TRB.Data.character.maxResource))
		else
			TRB.Functions.Bar:SetBarNodeValue(settings, key, node, value, TRB.Data.character.maxResource)
		end
	end
end

