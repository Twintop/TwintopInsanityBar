local _, TRB = ...
TRB.Functions = {}


-- Table Functions

local function TableLength(T)
	local count = 0
	if T ~= nil then
		local _
		for _ in pairs(T) do
			count = count + 1
		end
	end
	return count
end
TRB.Functions.TableLength = TableLength


-- Generic Frame Functions

local function TryUpdateText(frame, text)
	frame.font:SetText(text)
end
TRB.Functions.TryUpdateText = TryUpdateText


-- Number Functions

local function IsNumeric(data)
    if type(data) == "number" then
        return true
    elseif type(data) ~= "string" then
        return false
    end
    data = strtrim(data)
    local x, y = string.find(data, "[%d+][%.?][%d*]")
    if x and x == 1 and y == strlen(data) then
        return true
    end
    return false
end
TRB.Functions.IsNumeric = IsNumeric

local function RoundTo(num, numDecimalPlaces, mode)
	numDecimalPlaces = math.max(numDecimalPlaces or 0, 0)
	local newNum = tonumber(num)
	if mode == "floor" then
		local whole, decimal = strsplit(".", newNum, 2)

		if numDecimalPlaces == 0 then
			newNum = whole
		elseif decimal == nil or strlen(decimal) == 0 then
			newNum = string.format("%s.%0" .. numDecimalPlaces .. "d", whole, 0)
		else
			local chopped = string.sub(decimal, 1, numDecimalPlaces)
			if strlen(chopped) < numDecimalPlaces then
				chopped = string.format("%s%0" .. (numDecimalPlaces - strlen(chopped)) .. "d", chopped, 0)
			end
			newNum = string.format("%s.%s", whole, chopped)
		end

		return newNum
	elseif mode == "ceil" then
		local whole, decimal = strsplit(".", newNum, 2)

		if numDecimalPlaces == 0 then
			if (tonumber(whole) or 0) < num then
				whole = (tonumber(whole) or 0) + 1
			end

			newNum = whole
		elseif decimal == nil or strlen(decimal) == 0 then
			newNum = string.format("%s.%0" .. numDecimalPlaces .. "d", whole, 0)
		else
			local chopped = string.sub(decimal, 1, numDecimalPlaces)
			if tonumber(string.format("0.%s", chopped)) < tonumber(string.format("0.%s", decimal)) then
				chopped = chopped + 1
			end

			if strlen(chopped) < numDecimalPlaces then
				chopped = string.format("%s%0" .. (numDecimalPlaces - strlen(chopped)) .. "d", chopped, 0)
			end
			newNum = string.format("%s.%s", whole, chopped)
		end

		return newNum
	end

	return tonumber(string.format("%." .. numDecimalPlaces .. "f", newNum))
end
TRB.Functions.RoundTo = RoundTo


-- Color Functions

local function GetRGBAFromString(s, normalize)
    local _a = 1
    local _r = 0
    local _g = 1
    local _b = 0

    if not (s == nil) then        
        _a = min(255, tonumber(string.sub(s, 1, 2), 16))
        _r = min(255, tonumber(string.sub(s, 3, 4), 16))
        _g = min(255, tonumber(string.sub(s, 5, 6), 16))
        _b = min(255, tonumber(string.sub(s, 7, 8), 16))
    end
	if normalize then
		return _r/255, _g/255, _b/255, _a/255
	else
		return _r, _g, _b, _a
	end
end
TRB.Functions.GetRGBAFromString = GetRGBAFromString

local function ConvertColorDecimalToHex(r, g, b, a)
	local _r, _g, _b, _a

	if r == 0 or r == nil then
		_r = "00"
	else
		_r = string.format("%x", math.ceil(r * 255))
		if string.len(_r) == 1 then
			_r = "0" .. _r
		end
	end

	if g == 0 or g == nil then
		_g = "00"
	else
		_g = string.format("%x", math.ceil(g * 255))
		if string.len(_g) == 1 then
			_g = "0" .. _g
		end
	end

	if b == 0 or b == nil then
		_b = "00"
	else
		_b = string.format("%x", math.ceil(b * 255))
		if string.len(_b) == 1 then
			_b = "0" .. _b
		end
	end

	if a == 0 or a == nil then
		_a = "00"
	else
		_a = string.format("%x", math.ceil(a * 255))
		if string.len(_a) == 1 then
			_a = "0" .. _a
		end
	end

	return _a .. _r .. _g .. _b
end
TRB.Functions.ConvertColorDecimalToHex = ConvertColorDecimalToHex

local function PulseFrame(frame, alphaOffset, flashPeriod)
	frame:SetAlpha(((1.0 - alphaOffset) * math.abs(math.sin(2 * (GetTime()/flashPeriod)))) + alphaOffset)
end
TRB.Functions.PulseFrame = PulseFrame


-- Casting, Time, and GCD Functions

local function GetCurrentGCDLockRemaining()
	local startTime, duration, enabled = GetSpellCooldown(61304);
	return (startTime + duration - GetTime())
end
TRB.Functions.GetCurrentGCDLockRemaining = GetCurrentGCDLockRemaining

local function GetCurrentGCDTime(floor)
	if floor == nil then
		floor = false
	end

	local haste = UnitSpellHaste("player") / 100

	local gcd = 1.5 / (1 + haste)

	if not floor and gcd < 0.75 then
		gcd = 0.75
	end

	return gcd
end
TRB.Functions.GetCurrentGCDTime = GetCurrentGCDTime

local function ResetCastingSnapshotData()
	TRB.Data.snapshotData.casting.spellId = nil
	TRB.Data.snapshotData.casting.startTime = nil
	TRB.Data.snapshotData.casting.endTime = nil
	TRB.Data.snapshotData.casting.resourceRaw = 0
	TRB.Data.snapshotData.casting.resourceFinal = 0
	TRB.Data.snapshotData.casting.icon = ""
end
TRB.Functions.ResetCastingSnapshotData = ResetCastingSnapshotData

local function GetLatency()
	local down, up, lagHome, lagWorld = GetNetStats()
	local latency = lagWorld / 1000
	return latency
end
TRB.Functions.GetLatency = GetLatency

-- Addon Maintenance Functions

local function GetSanityCheckValues(settings)
	local sc = {}
    if settings ~= nil and settings.bar ~= nil then
        sc.barMaxWidth = math.floor(GetScreenWidth())
        sc.barMinWidth = math.max(math.ceil(settings.bar.border * 2), 120)
        sc.barMaxHeight = math.floor(GetScreenHeight())
        sc.barMinHeight = math.max(math.ceil(settings.bar.border * 2), 1)
	end
	return sc
end
TRB.Functions.GetSanityCheckValues = GetSanityCheckValues

local function UpdateSanityCheckValues(settings)
	local sc = TRB.Functions.GetSanityCheckValues(settings)
    if settings ~= nil and settings.bar ~= nil then
        TRB.Data.sanityCheckValues.barMaxWidth = sc.barMaxWidth
        TRB.Data.sanityCheckValues.barMinWidth = sc.barMinWidth
        TRB.Data.sanityCheckValues.barMaxHeight = sc.barMaxHeight
        TRB.Data.sanityCheckValues.barMinHeight = sc.barMinHeight
    end
end
TRB.Functions.UpdateSanityCheckValues = UpdateSanityCheckValues

local function MergeSettings(settings, user)
	for k, v in pairs(user) do
        if (type(v) == "table") and (type(settings[k] or false) == "table") then
            TRB.Functions.MergeSettings(settings[k], user[k])
        else
            settings[k] = v
        end
    end
    return settings
end
TRB.Functions.MergeSettings = MergeSettings

local function FillSpellData(spells)
	if spells == nil then
		spells = TRB.Data.spells
	end

	local toc = select(4, GetBuildInfo())

	for k, v in pairs(spells) do
		if spells[k] ~= nil and spells[k]["id"] ~= nil and (spells[k]["tocMinVersion"] == nil or toc >= spells[k]["tocMinVersion"]) then
			local _, name, icon
			name, _, icon = GetSpellInfo(spells[k]["id"])
			spells[k]["icon"] = string.format("|T%s:0|t", icon)
			spells[k]["name"] = name
		end
	end

	return spells
end
TRB.Functions.FillSpellData = FillSpellData

local function ResetSnapshotData()
	TRB.Data.snapshotData = {
		resource = 0,
		haste = 0,
		crit = 0,
		mastery = 0,
		isTracking = false,
		casting = {
			spellId = nil,
			startTime = nil,
			endTime = nil,
			resourceRaw = 0,
			resourceFinal = 0,
			icon = ""
		},
		targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {}
		},
		audio = {}
	}
end
TRB.Functions.ResetSnapshotData = ResetSnapshotData

local function LoadFromSpecCache(cache)
	Global_TwintopResourceBar = cache.Global_TwintopResourceBar

	TRB.Data.character = cache.character
	TRB.Data.spells = cache.spells
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values

	TRB.Functions.ResetSnapshotData()
	TRB.Data.snapshotData = TRB.Functions.MergeSettings(TRB.Data.snapshotData, cache.snapshotData)

	TRB.Data.character.specGroup = GetActiveSpecGroup()
end
TRB.Functions.LoadFromSpecCache = LoadFromSpecCache

-- Target Functions

local function CheckTargetExists(guid)
	if guid == nil or (not TRB.Data.snapshotData.targetData.targets[guid] or TRB.Data.snapshotData.targetData.targets[guid] == nil) then
		return false
	end
	return true
end
TRB.Functions.CheckTargetExists = CheckTargetExists

local function RemoveTarget(guid)
	if guid ~= nil and TRB.Functions.CheckTargetExists(guid) then
		TRB.Data.snapshotData.targetData.targets[guid] = nil
	end
end
TRB.Functions.RemoveTarget = RemoveTarget

local function InitializeTarget(guid)
	if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
		TRB.Data.snapshotData.targetData.targets[guid] = {}
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = 0
		TRB.Data.snapshotData.targetData.targets[guid].snapshot = {}
		TRB.Data.snapshotData.targetData.targets[guid].ttd = 0
	end
end
TRB.Functions.InitializeTarget = InitializeTarget

local function TargetsCleanup(clearAll)
	if clearAll == true then
		TRB.Data.snapshotData.targetData.targets = {}
	else
		local currentTime = GetTime()
		for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 20 then
				TRB.Functions.RemoveTarget(tguid)
			end
		end
	end
end
TRB.Functions.TargetsCleanup = TargetsCleanup

local function GetUnitHealthPercent(unit)
	if GetUnitName(unit) then
		local health = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		return health / maxHealth
	else
		return nil
	end
end
TRB.Functions.GetUnitHealthPercent = GetUnitHealthPercent

-- Bar Manipulation Functions

local function RepositionThreshold(settings, thresholdLine, parentFrame, thresholdWidth, resourceThreshold, resourceMax)
	if resourceMax == nil or resourceMax == 0 then
        resourceMax = TRB.Data.character.maxResource or 100
    end

	local min, max = parentFrame:GetMinMaxValues()
	local factor = (max - (settings.bar.border * 2)) / resourceMax

	if settings ~= nil and settings.bar ~= nil then
		thresholdLine:SetPoint("LEFT",
								parentFrame,
								"LEFT",
								(resourceThreshold * factor),
								0)
	end
end
TRB.Functions.RepositionThreshold = RepositionThreshold

local function ShowResourceBar()
	if TRB.Details.addonData.registered == false then
		EventRegistration()
	end

	TRB.Data.snapshotData.isTracking = true
	TRB.Frames.barContainerFrame:Show()
end
TRB.Functions.ShowResourceBar = ShowResourceBar

local function HideResourceBar()
	TRB.Data.snapshotData.isTracking = false
	--This is a placeholder for an implementation per class/spec
end
TRB.Functions.HideResourceBar = HideResourceBar

local function UpdateBarPosition(xOfs, yOfs)
	if IsNumeric(xOfs) and IsNumeric(yOfs) then
		if xOfs < math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth/2) then
			xOfs = math.ceil(-TRB.Data.sanityCheckValues.barMaxWidth/2)
		elseif xOfs > math.floor(TRB.Data.sanityCheckValues.barMaxWidth/2) then
			xOfs = math.floor(TRB.Data.sanityCheckValues.barMaxWidth/2)
		end

		if yOfs < math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight/2) then
			yOfs = math.ceil(-TRB.Data.sanityCheckValues.barMaxHeight/2)
		elseif yOfs > math.floor(TRB.Data.sanityCheckValues.barMaxHeight/2) then
			yOfs = math.floor(TRB.Data.sanityCheckValues.barMaxHeight/2)
		end

		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal:SetValue(xOfs)
		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal.EditBox:SetText(RoundTo(xOfs, 0))
		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical:SetValue(yOfs)
		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical.EditBox:SetText(RoundTo(yOfs, 0))
	end
end
TRB.Functions.UpdateBarPosition = UpdateBarPosition

local function CaptureBarPosition(settings)
	local point, relativeTo, relativePoint, xOfs, yOfs = TRB.Frames.barContainerFrame:GetPoint()

	if relativePoint == "CENTER" then
		--No action needed.
	elseif relativePoint == "TOP" then
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight/2) + yOfs - (settings.bar.height/2))
	elseif relativePoint == "TOPRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth/2) + xOfs - (settings.bar.width/2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight/2) + yOfs - (settings.bar.height/2))
	elseif relativePoint == "RIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth/2) + xOfs - (settings.bar.width/2))
	elseif relativePoint == "BOTTOMRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth/2) + xOfs - (settings.bar.width/2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight/2) - yOfs - (settings.bar.height/2))
	elseif relativePoint == "BOTTOM" then
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight/2) - yOfs - (settings.bar.height/2))
	elseif relativePoint == "BOTTOMLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth/2) - xOfs - (settings.bar.width/2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight/2) - yOfs - (settings.bar.height/2))
	elseif relativePoint == "LEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth/2) - xOfs - (settings.bar.width/2))
	elseif relativePoint == "TOPLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth/2) - xOfs - (settings.bar.width/2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight/2) + yOfs - (settings.bar.height/2))
	end

	TRB.Functions.UpdateBarPosition(xOfs, yOfs)
end
TRB.Functions.CaptureBarPosition = CaptureBarPosition

local function SetBarCurrentValue(settings, bar, value)
	value = value or 0
	if settings ~= nil and settings.bar ~= nil and bar ~= nil then
		local min, max = bar:GetMinMaxValues()
		local factor = max / TRB.Data.character.maxResource
		bar:SetValue(value * factor)
	end
end
TRB.Functions.SetBarCurrentValue = SetBarCurrentValue

local function SetBarMinMaxValues(settings)
	if settings ~= nil and settings.bar ~= nil then
		TRB.Frames.resourceFrame:SetMinMaxValues(0, settings.bar.width)
		TRB.Frames.castingFrame:SetMinMaxValues(0, settings.bar.width)
		TRB.Frames.passiveFrame:SetMinMaxValues(0, settings.bar.width)
	end
end
TRB.Functions.SetBarMinMaxValues = SetBarMinMaxValues

local function RedrawThresholdLines(settings)
	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local borderSubtraction = 0

	if not settings.bar.thresholdOverlapBorder then
		borderSubtraction = settings.bar.border * 2
	end

	local entries = TRB.Functions.TableLength(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			resourceFrame.thresholds[x]:SetWidth(settings.thresholdWidth)
			resourceFrame.thresholds[x]:SetHeight(settings.bar.height - borderSubtraction)
			resourceFrame.thresholds[x].texture = resourceFrame.thresholds[x]:CreateTexture(nil, TRB.Data.settings.core.strata.level)
			resourceFrame.thresholds[x].texture:SetAllPoints(resourceFrame.thresholds[x])
			resourceFrame.thresholds[x].texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.under, true))
			resourceFrame.thresholds[x]:SetFrameStrata(TRB.Data.settings.core.strata.level)
			resourceFrame.thresholds[x]:SetFrameLevel(127)
			resourceFrame.thresholds[x]:Hide()
		end
	end

	entries = TRB.Functions.TableLength(passiveFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			passiveFrame.thresholds[x]:SetWidth(settings.thresholdWidth)
			passiveFrame.thresholds[x]:SetHeight(settings.bar.height - borderSubtraction)
			passiveFrame.thresholds[x].texture = passiveFrame.thresholds[x]:CreateTexture(nil, TRB.Data.settings.core.strata.level)
			passiveFrame.thresholds[x].texture:SetAllPoints(passiveFrame.thresholds[x])
			passiveFrame.thresholds[x].texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.mindbender, true))
			passiveFrame.thresholds[x]:SetFrameStrata(TRB.Data.settings.core.strata.level)
			passiveFrame.thresholds[x]:SetFrameLevel(127)
			passiveFrame.thresholds[x]:Show()
		end
	end

	return thresholds
end
TRB.Functions.RedrawThresholdLines = RedrawThresholdLines

local function ConstructResourceBar(settings)    
    if settings ~= nil and settings.bar ~= nil then
        local barContainerFrame = TRB.Frames.barContainerFrame
        local resourceFrame = TRB.Frames.resourceFrame
        local castingFrame = TRB.Frames.castingFrame
        local passiveFrame = TRB.Frames.passiveFrame
        local barBorderFrame = TRB.Frames.barBorderFrame
        local leftTextFrame = TRB.Frames.leftTextFrame
        local middleTextFrame = TRB.Frames.middleTextFrame
        local rightTextFrame = TRB.Frames.rightTextFrame

        barContainerFrame:Show()
        barContainerFrame:SetBackdrop({
            bgFile = settings.textures.background,
            tile = true,
            tileSize = settings.bar.width,
            edgeSize = 1,
            insets = {0, 0, 0, 0}
        })
        barContainerFrame:ClearAllPoints()
        barContainerFrame:SetPoint("CENTER", UIParent)
        barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
        barContainerFrame:SetBackdropColor(GetRGBAFromString(settings.colors.bar.background, true))
        barContainerFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
        barContainerFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        barContainerFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        barContainerFrame:SetFrameLevel(0)

        barContainerFrame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" and not self.isMoving and settings.bar.dragAndDrop then
                self:StartMoving()
                self.isMoving = true
            end
        end)

        barContainerFrame:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" and self.isMoving and settings.bar.dragAndDrop then
                self:StopMovingOrSizing()
                CaptureBarPosition(settings)
                self.isMoving = false
            end
        end)
        
        barContainerFrame:SetMovable(settings.bar.dragAndDrop)
        barContainerFrame:EnableMouse(settings.bar.dragAndDrop)

        barContainerFrame:SetScript("OnHide", function(self)
            if self.isMoving then
                self:StopMovingOrSizing()
                CaptureBarPosition(settings)
                self.isMoving = false
            end
        end)

        if settings.bar.border < 1 then
            barBorderFrame:Show()
            barBorderFrame.backdropInfo = {
                edgeFile = settings.textures.border,
                tile = true,
                tileSize=4,
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
        barBorderFrame:SetBackdropBorderColor(GetRGBAFromString(settings.colors.bar.border, true))
        barBorderFrame:SetWidth(settings.bar.width)
        barBorderFrame:SetHeight(settings.bar.height)
        barBorderFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        barBorderFrame:SetFrameLevel(126)

        resourceFrame:Show()
        resourceFrame:SetMinMaxValues(0, settings.bar.width)
        resourceFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        resourceFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        resourceFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        resourceFrame:SetStatusBarTexture(settings.textures.resourceBar)
        resourceFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base))
        resourceFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		resourceFrame:SetFrameLevel(125)
		        
        castingFrame:Show()
        castingFrame:SetMinMaxValues(0, settings.bar.width)
        castingFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        castingFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        castingFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        castingFrame:SetStatusBarTexture(settings.textures.castingBar)
        castingFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.casting, true))
        castingFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        castingFrame:SetFrameLevel(90)
        
        passiveFrame:Show()
        passiveFrame:SetMinMaxValues(0, settings.bar.width)
        passiveFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        passiveFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        passiveFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        passiveFrame:SetStatusBarTexture(settings.textures.passiveBar)
        passiveFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.passive, true))
        passiveFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		passiveFrame:SetFrameLevel(80)


		TRB.Functions.RedrawThresholdLines(settings)

		SetBarMinMaxValues(settings)

        leftTextFrame:Show()
        leftTextFrame:SetWidth(settings.bar.width)
        leftTextFrame:SetHeight(settings.bar.height * 3.5)
        leftTextFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 2, 0)
        leftTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        leftTextFrame:SetFrameLevel(129)
        leftTextFrame.font:SetPoint("LEFT", 0, 0)
        leftTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
        leftTextFrame.font:SetJustifyH("LEFT")
        leftTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.left.fontSize, "OUTLINE")
        leftTextFrame.font:Show()
        
        middleTextFrame:Show()
        middleTextFrame:SetWidth(settings.bar.width)
        middleTextFrame:SetHeight(settings.bar.height * 3.5)
        middleTextFrame:SetPoint("CENTER", barContainerFrame, "CENTER", 0, 0)
        middleTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        middleTextFrame:SetFrameLevel(129)
        middleTextFrame.font:SetPoint("CENTER", 0, 0)
        middleTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
        middleTextFrame.font:SetJustifyH("CENTER")
        middleTextFrame.font:SetFont(settings.displayText.middle.fontFace, settings.displayText.middle.fontSize, "OUTLINE")
        middleTextFrame.font:Show()
        
        rightTextFrame:Show()
        rightTextFrame:SetWidth(settings.bar.width)
        rightTextFrame:SetHeight(settings.bar.height * 3.5)
        rightTextFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        rightTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        rightTextFrame:SetFrameLevel(129)
        rightTextFrame.font:SetPoint("RIGHT", 0, 0)
        rightTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
        rightTextFrame.font:SetJustifyH("RIGHT")
        rightTextFrame.font:SetFont(settings.displayText.right.fontFace, settings.displayText.right.fontSize, "OUTLINE")
        rightTextFrame.font:Show()
    end
end
TRB.Functions.ConstructResourceBar = ConstructResourceBar


-- Bar Text Functions

local function AddToBarTextCache(input)
    local barTextVariables = TRB.Data.barTextVariables
	local iconEntries = TableLength(barTextVariables.icons)
	local valueEntries = TableLength(barTextVariables.values)
	local pipeEntries = TableLength(barTextVariables.pipe)
	local percentEntries = TableLength(barTextVariables.percent)
	local returnText = ""
	local returnVariables = {}
	local p = 0
	local infinity = 0
	local barTextValuesVars = barTextVariables.values
	table.sort(barTextValuesVars,
		function(a, b)
			return string.len(a.variable) > string.len(b.variable)
		end)
	while p <= string.len(input) and infinity < 20 do
		infinity = infinity + 1
		local a, b, c, d, z, a1, b1, c1, d1, z1
		local match = false
		a, a1 = string.find(input, "#", p)
		b, b1 = string.find(input, "%$", p)
		c, c1 = string.find(input, "|", p)
		d, d1 = string.find(input, "%%", p)
		if a ~= nil and (b == nil or a < b) and (c == nil or a < c) and (d == nil or a < d) then
			if string.sub(input, a+1, a+6) == "spell_" then
				z, z1 = string.find(input, "_", a+7)
				if z ~= nil then
					local iconName = string.sub(input, a, z)
					local spellId = string.sub(input, a+7, z-1)
					local _, name, icon
					name, _, icon = GetSpellInfo(spellId)

					if icon ~= nil then
						match = true
						if p ~= a then
							returnText = returnText .. string.sub(input, p, a-1)
						end

						returnText = returnText .. "%s"
						TRB.Data.lookup[iconName] = string.format("|T%s:0|t", icon)
						table.insert(returnVariables, iconName)
						p = z1 + 1
					end
				end
			else
				for x = 1, iconEntries do
					local len = string.len(barTextVariables.icons[x].variable)
					z, z1 = string.find(input, barTextVariables.icons[x].variable, a-1)
					if z ~= nil and z == a then
						match = true
						if p ~= a then
							returnText = returnText .. string.sub(input, p, a-1)
						end

						returnText = returnText .. "%s"
						table.insert(returnVariables, barTextVariables.icons[x].variable)

						p = z1 + 1
						break
					end
				end
			end
		elseif b ~= nil and (c == nil or b < c) and (d == nil or b < d) then
			for x = 1, valueEntries do
				local len = string.len(barTextValuesVars[x].variable)
				z, z1 = string.find(input, barTextValuesVars[x].variable, b-1)
				if z ~= nil and z == b then
					match = true
					if p ~= b then
						returnText = returnText .. string.sub(input, p, b-1)
					end

					returnText = returnText .. "%s"
					table.insert(returnVariables, barTextValuesVars[x].variable)

					if barTextValuesVars[x].color == true then
						returnText = returnText .. "%s"
						table.insert(returnVariables, "color")
					end

					p = z1 + 1
					break
				end
			end
		elseif c ~= nil and (d == nil or c < d) then
			for x = 1, pipeEntries do
				local len = string.len(barTextVariables.pipe[x].variable)
				z, z1 = string.find(input, barTextVariables.pipe[x].variable, c-1)
				if z ~= nil and z == c then
					match = true
					if p ~= c then
						returnText = returnText .. string.sub(input, p, c-1)
					end

					returnText = returnText .. "%s"
					table.insert(returnVariables, barTextVariables.pipe[x].variable)
					p = z1 + 1
				end
			end
		elseif d ~= nil then
			for x = 1, percentEntries do
				local len = string.len(barTextVariables.percent[x].variable)
				z, z1 = string.find(input, barTextVariables.percent[x].variable, d-1)
				if z ~= nil and z == d then
					match = true
					if p ~= d then
						returnText = returnText .. string.sub(input, p, d-1)
					end

					returnText = returnText .. "%s"
					table.insert(returnVariables, barTextVariables.percent[x].variable)

					p = z1 + 1
					break
				end
			end
		else
			returnText = returnText .. string.sub(input, p, -1)
			p = string.len(input) + 1
			match = true
		end

		if match == false then
			returnText = returnText .. string.sub(input, p, p)
			p = p + 1
		end
	end

	local barTextCacheEntry = {}
	barTextCacheEntry.cleanedText = input
	barTextCacheEntry.stringFormat = returnText
	barTextCacheEntry.variables = returnVariables

	table.insert(TRB.Data.barTextCache, barTextCacheEntry)
	return barTextCacheEntry
end
TRB.Functions.AddToBarTextCache = AddToBarTextCache

local function GetFromBarTextCache(barText)
	local entries = TableLength(TRB.Data.barTextCache)

	if entries > 0 then
		for x = 1, entries do
			if TRB.Data.barTextCache[x].cleanedText == barText then
				return TRB.Data.barTextCache[x]
			end
		end
	end

	return AddToBarTextCache(barText)
end
TRB.Functions.GetFromBarTextCache = GetFromBarTextCache

local function GetReturnText(inputText)
    local lookup = TRB.Data.lookup
    lookup["color"] = inputText.color
    inputText.text = TRB.Functions.RemoveInvalidVariablesFromBarText(inputText.text)
    
    local cache = TRB.Functions.GetFromBarTextCache(inputText.text)
    local mapping = {}
    local cachedTextVariableLength = TRB.Functions.TableLength(cache.variables)
    
    if cachedTextVariableLength > 0 then
        for y = 1, cachedTextVariableLength do
            table.insert(mapping, lookup[cache.variables[y]])
        end
    end

    if TRB.Functions.TableLength(mapping) > 0 then
		local result
		result, inputText.text = pcall(string.format, cache.stringFormat, unpack(mapping))
    elseif string.len(cache.stringFormat) > 0 then
        inputText.text = cache.stringFormat
    else
        inputText.text = ""
    end
    
    return string.format("%s%s", inputText.color, inputText.text)
end
TRB.Functions.GetReturnText = GetReturnText

local function IsTtdActive()
    --To be implemented in each class/spec module
end
TRB.Functions.IsTtdActive = IsTtdActive

local function BarText(settings)
	if settings ~= nil and settings.colors ~= nil and settings.colors.text ~= nil and settings.displayText ~= nil and
		settings.displayText.left ~= nil and settings.displayText.middle ~= nil and settings.displayText.right ~= nil then
		local returnText = {}
		returnText[0] = {}
		returnText[1] = {}
		returnText[2] = {}
		returnText[0].text = settings.displayText.left.text
		returnText[1].text = settings.displayText.middle.text
		returnText[2].text = settings.displayText.right.text

		returnText[0].color = string.format("|c%s", settings.colors.text.left)
		returnText[1].color = string.format("|c%s", settings.colors.text.middle)
		returnText[2].color = string.format("|c%s", settings.colors.text.right)

		return TRB.Functions.GetReturnText(returnText[0]), TRB.Functions.GetReturnText(returnText[1]), TRB.Functions.GetReturnText(returnText[2])
	else
		return "", "", ""
	end
end
TRB.Functions.BarText = BarText

local function RefreshLookupDataBase(settings)
	--Spec specific implementations also needed. This is general/cross-spec data

	--$crit
	local critPercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.crit, settings.hastePrecision))

	--$mastery
	local masteryPercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.mastery, settings.hastePrecision))

	--$haste

	--$gcd
	local _gcd = 1.5 / (1 + (TRB.Data.snapshotData.haste/100))
	if _gcd > 1.5 then
		_gcd = 1.5
	elseif _gcd < 0.75 then
		_gcd = 0.75
	end
	local gcd = string.format("%.2f", _gcd)

	local hastePercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.haste, settings.hastePrecision))

	--$ttd
	local _ttd = ""
	local ttd = ""
	local ttdTotalSeconds = ""

	if TRB.Data.snapshotData.targetData.ttdIsActive and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd ~= 0 then
		local target = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid]
		local ttdMinutes = math.floor(target.ttd / 60)
		local ttdSeconds = target.ttd % 60
		ttdTotalSeconds = string.format("%s", TRB.Functions.RoundTo(target.ttd, TRB.Data.settings.core.ttd.precision or 1, "floor"))
		ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)
	else
		ttd = "--"
		ttdTotalSeconds = TRB.Functions.RoundTo(0, TRB.Data.settings.core.ttd.precision or 1, "floor")
	end

	--#castingIcon
	local castingIcon = TRB.Data.snapshotData.casting.icon or ""

	local lookup = TRB.Data.lookup or {}
	lookup["#casting"] = castingIcon
	lookup["$haste"] = hastePercent
	lookup["$crit"] = critPercent
	lookup["$mastery"] = masteryPercent
	lookup["$gcd"] = gcd
	lookup["$ttd"] = ttd
	lookup["$ttdSeconds"] = ttdTotalSeconds
	lookup["||n"] = string.format("\n")
	lookup["||c"] = string.format("%s", "|c")
	lookup["||r"] = string.format("%s", "|r")
	lookup["%%"] = "%"


	TRB.Data.lookup = lookup

	Global_TwintopResourceBar = {
		ttd = {
			ttd = ttd or "--",
			seconds = ttdTotalSeconds or 0
		},
		resource = {
			resource = TRB.Data.snapshotData.resource or 0,
			casting = TRB.Data.snapshotData.casting.resourceFinal or 0
		}
	}
end
TRB.Functions.RefreshLookupDataBase = RefreshLookupDataBase

local function UpdateResourceBar(settings, refreshText)
	TRB.Functions.RefreshLookupDataBase(settings)
	TRB.Functions.RefreshLookupData()

	if refreshText then
		local leftText, middleText, rightText = TRB.Functions.BarText(settings)
		TRB.Functions.UpdateResourceBarText(settings, leftText, middleText, rightText)
	end
end
TRB.Functions.UpdateResourceBar = UpdateResourceBar

local function UpdateResourceBarText(settings, leftText, middleText, rightText)
	if settings ~= nil and settings.bar ~= nil then
		local leftTextFrame = TRB.Frames.leftTextFrame
		local middleTextFrame = TRB.Frames.middleTextFrame
		local rightTextFrame = TRB.Frames.rightTextFrame

		if not pcall(TRB.Functions.TryUpdateText, leftTextFrame, leftText) then
			leftTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.left.fontSize, "OUTLINE")
		end

		if not pcall(TRB.Functions.TryUpdateText, middleTextFrame, middleText) then
			middleTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.middle.fontSize, "OUTLINE")
		end

		if not pcall(TRB.Functions.TryUpdateText, rightTextFrame, rightText) then
			rightTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.right.fontSize, "OUTLINE")
		end
	end
end
TRB.Functions.UpdateResourceBarText = UpdateResourceBarText

local function IsValidVariableBase(var)
	local valid = false
	if var == "$crit" then
		valid = true
	elseif var == "$mastery" then
		valid = true
	elseif var == "$haste" then
		valid = true
	elseif var == "$gcd" then
		valid = true
	elseif var == "$ttd" or var == "$ttdSeconds" then
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and UnitGUID("target") ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd > 0 then
			valid = true
		end
	end

	return valid
end
TRB.Functions.IsValidVariableBase = IsValidVariableBase

local function RemoveInvalidVariablesFromBarText(input)
    --1         11                       36     43
    --v         v                        v      v
    --a         b                        c      d
    --{$liStacks}[$liStacks - $liTime sec][No LI]
    local returnText = ""
    local p = 0
    while p <= string.len(input) do
        local a, b, c, d, a1, b1, c1, d1
        a, a1 = string.find(input, "{", p)
        if a ~= nil then
            b, b1 = string.find(input, "}", a)

            if b ~= nil and string.sub(input, b+1, b+1) == "[" then
                c, c1 = string.find(input, "]", b+1)

                if c ~= nil then
                    local hasOr = false
                    if string.sub(input, c+1, c+1) == "[" then
                        d, d1 = string.find(input, "]", c+1)
                        if d ~= nil then
                            hasOr = true
                        end
                    end

                    if p ~= a then
                        returnText = returnText .. string.sub(input, p, a-1)
                    end
                    
                    local valid = false
                    local useNot = false
                    local var = string.sub(input, a+1, b-1)
                    local notVar = string.sub(var, 1, 1)

                    if notVar == "!" then
                        useNot = true
                        var = string.sub(var, 2)
                    end
                    
                    valid = TRB.Data.IsValidVariableForSpec(var)

                    if useNot == true then
                        valid = not valid
                    end

                    if valid == true then
                        returnText = returnText .. string.sub(input, b+2, c-1)
                    elseif hasOr == true then
                        returnText = returnText .. string.sub(input, c+2, d-1)
                    end
                    
                    if hasOr == true then
                        p = d+1
                    else
                        p = c+1
                    end
                else
                    returnText = returnText .. string.sub(input, p)
                    p = string.len(input)
                end
            else
                if b ~= nil then
                    p = b + 1
                else
                    returnText = returnText .. string.sub(input, p)
                    p = string.len(input)
                end
            end
        else
            returnText = returnText .. string.sub(input, p)
			p = string.len(input)
			break
        end
    end
    return returnText
end
TRB.Functions.RemoveInvalidVariablesFromBarText = RemoveInvalidVariablesFromBarText


-- Character Functions

local function FindBuffByName(spellName, onWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName = UnitBuff(onWhom, i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName then
			return UnitBuff(onWhom, i)
		end
	end
end
TRB.Functions.FindBuffByName = FindBuffByName

local function FindBuffById(spellId, onWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellId = select(10, UnitBuff(onWhom, i))
		if not unitSpellId then
			return
		elseif spellId == unitSpellId then
			return UnitBuff(onWhom, i)
		end
	end
end
TRB.Functions.FindBuffById = FindBuffById

local function FindDebuffByName(spellName, onWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName = UnitDebuff(onWhom, i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName then
			return UnitDebuff(onWhom, i)
		end
	end
end
TRB.Functions.FindDebuffByName = FindDebuffByName

local function FindDebuffById(spellId, onWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local unitSpellId = select(10, UnitDebuff(onWhom, i))
		if not unitSpellId then
			return
		elseif spellId == unitSpellId then
			return UnitDebuff(onWhom, i)
		end
	end
end
TRB.Functions.FindDebuffById = FindDebuffById
    
local function FindAuraByName(spellName, onWhom, filter)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName = UnitAura(onWhom, i, filter)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName then
			return UnitAura(onWhom, i, filter)
		end
	end
end
TRB.Functions.FindAuraByName = FindAuraByName
    
local function FindAuraById(spellId, onWhom, filter)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local unitSpellId = select(10, UnitAura(onWhom, i, filter))
		if not unitSpellId then
			return
		elseif spellId == unitSpellId then
			return UnitAura(onWhom, i, filter)
		end
	end
end
TRB.Functions.FindAuraById = FindAuraById

local function CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
    TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Functions.FillSpellData()
end
TRB.Functions.CheckCharacter = CheckCharacter

local function UpdateSnapshot()
	TRB.Data.snapshotData.resource = UnitPower("player", TRB.Data.resource, true)
	TRB.Data.snapshotData.haste = UnitSpellHaste("player")
	TRB.Data.snapshotData.crit = GetCritChance("player")
	TRB.Data.snapshotData.mastery = GetMasteryEffect("player")
end
TRB.Functions.UpdateSnapshot = UpdateSnapshot

local function DoesItemLinkMatchMatchIdAndHaveBonus(itemLink, id, bonusId)
	local parts = { strsplit(":", itemLink) }
	-- Note for Future Twintop:
	--  1  = Item Name
	--  2  = Item Id
	-- 14  = # of Bonuses
	-- 15+ = Bonuses
	if tonumber(parts[2]) == id and tonumber(parts[14]) > 0 then
		for x = 1, tonumber(parts[14]) do
			if tonumber(parts[14+x]) == bonusId then
				return true
			end
		end
	end
	return false
end
TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus = DoesItemLinkMatchMatchIdAndHaveBonus

local function IsSoulbindActive(id)
	local soulbindId = C_Soulbinds.GetActiveSoulbindID()
    local soulbindData = C_Soulbinds.GetSoulbindData(soulbindId)
    local length = TableLength(soulbindData.tree.nodes)
    
	for x = 1, length do
		if soulbindData.tree.nodes[x].conduitID == id then
			return true
		end        
	end

	return false
end
TRB.Functions.IsSoulbindActive = IsSoulbindActive

local function GetSoulbindItemLevel(id)
	local conduit = C_Soulbinds.GetConduitCollectionData(id)

	if conduit ~= nil then
		return conduit.conduitItemLevel
	end
	return 0
end
TRB.Functions.IsSoulbindActive = GetSoulbindItemLevel

local function GetSoulbindRank(id)
	local conduit = C_Soulbinds.GetConduitCollectionData(id)

	if conduit ~= nil then
		return conduit.conduitRank
	end
	return 0
end
TRB.Functions.GetSoulbindRank = GetSoulbindRank

-- Misc Functions

local function ParseCmdString(msg)
	if msg then
		while (strfind(msg,"  ") ~= nil) do
			msg = string.gsub(msg,"  "," ")
		end
		local a,b,c=strfind(msg,"(%S+)")
		if a then
			return c,strsub(msg,b+2)
		else
			return "";
		end
	end
end
TRB.Functions.ParseCmdString = ParseCmdString