local _, TRB = ...
TRB.Functions = TRB.Functions or {}
local EXPORT_STRING_PREFIX = "!TRB!"

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

local function TablePrint(T, indent)
	if not indent then
		indent = 0
	end

	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(T) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "
		end

		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. TablePrint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end

	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end
TRB.Functions.TablePrint = TablePrint

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

local function ConvertToShortNumberNotation(num, numDecimalPlaces, mode)
	numDecimalPlaces = math.max(numDecimalPlaces or 0, 0)
	local negative = ""

	if num < 0 then
		negative = "-"
		num = -num
	end

	if num >= 10^9 then
		return string.format(negative .. "%." .. numDecimalPlaces .. "fb", TRB.Functions.RoundTo(num / 10^9, numDecimalPlaces, mode))
	elseif num >= 10^6 then
        return string.format(negative .. "%." .. numDecimalPlaces .. "fm", TRB.Functions.RoundTo(num / 10^6, numDecimalPlaces, mode))
    elseif num >= 10^3 then
        return string.format(negative .. "%." .. numDecimalPlaces .. "fk", TRB.Functions.RoundTo(num / 10^3, numDecimalPlaces, mode))
    else
        return string.format(negative .. "%." .. numDecimalPlaces .. "f", TRB.Functions.RoundTo(num, 0, mode))
    end
end
TRB.Functions.ConvertToShortNumberNotation = ConvertToShortNumberNotation

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
	TRB.Data.snapshotData.casting.spellKey = nil
end
TRB.Functions.ResetCastingSnapshotData = ResetCastingSnapshotData

local function GetLatency()
	--local down, up, lagHome, lagWorld = GetNetStats()
	local _, _, _, lagWorld = GetNetStats()
	local latency = lagWorld / 1000
	return latency
end
TRB.Functions.GetLatency = GetLatency

-- Addon Maintenance Functions

local function EventRegistration()
	-- To be implemented by the class module
end
TRB.Functions.EventRegistration = EventRegistration

local function GetSanityCheckValues(settings)
	local sc = {}
    if settings ~= nil then
		if settings.bar ~= nil then
        	sc.barMaxWidth = math.floor(GetScreenWidth())
        	sc.barMinWidth = math.max(math.ceil(settings.bar.border * 2), 120)
    	    sc.barMaxHeight = math.floor(GetScreenHeight())
	        sc.barMinHeight = math.max(math.ceil(settings.bar.border * 2), 1)
		end

		if settings.comboPoints ~= nil then
        	sc.comboPointsMaxWidth = math.floor(GetScreenWidth() / 6)
        	sc.comboPointsMinWidth = math.max(math.ceil(settings.comboPoints.border * 2), 1)
    	    sc.comboPointsMaxHeight = math.floor(GetScreenHeight())
	        sc.comboPointsMinHeight = math.max(math.ceil(settings.comboPoints.border * 2), 1)
		end
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
	if settings == nil and user == nil then
		return {}
	elseif settings == nil then
		return user
	elseif user == nil then
		return settings
	end

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
		if spells[k] ~= nil and (spells[k]["tocMinVersion"] == nil or toc >= spells[k]["tocMinVersion"]) then
			if spells[k]["itemId"] ~= nil then
				local _, name, icon
				name, _, _, _, _, _, _, _, _, icon = GetItemInfo(spells[k]["itemId"])
				if name ~= nil and icon ~= nil then
					spells[k]["icon"] = string.format("|T%s:0|t", icon)
					spells[k]["name"] = name
					spells[k]["texture"] = icon
				end
			elseif spells[k]["id"] ~= nil then
				local _, name, icon
				name, _, icon = GetSpellInfo(spells[k]["id"])
				spells[k]["icon"] = string.format("|T%s:0|t", icon)
				spells[k]["name"] = name

				if spells[k]["thresholdId"] ~= nil then
					local texture, _ = GetSpellTexture(spells[k]["id"])
					spells[k]["texture"] = texture
				end
			end
		end
	end

	spells = TRB.Functions.FillSpellDataManaCost(spells)

	return spells
end
TRB.Functions.FillSpellData = FillSpellData

local function GetSpellManaCost(spellId)
	local spc = GetSpellPowerCost(spellId)
	local length = TRB.Functions.TableLength(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["cost"] > 0 then
			return spc[x]["cost"]
		end
	end
	return 0
end
TRB.Functions.GetSpellManaCost = GetSpellManaCost

local function FillSpellDataManaCost(spells)
	if spells == nil then
		spells = TRB.Data.spells
	end

	local toc = select(4, GetBuildInfo())

	for k, v in pairs(spells) do
		if spells[k] ~= nil and spells[k]["id"] ~= nil and (spells[k]["tocMinVersion"] == nil or toc >= spells[k]["tocMinVersion"]) and spells[k]["usesMana"] then
			spells[k]["mana"] = -TRB.Functions.GetSpellManaCost(spells[k]["id"])
		end
	end

	return spells
end
TRB.Functions.FillSpellDataManaCost = FillSpellDataManaCost


local function ResetSnapshotData()
	TRB.Data.snapshotData = {
		resource = 0,
		haste = 0,
		crit = 0,
		mastery = 0,
		versatilityOffensive = 0,
		versatilityDefensive = 0,
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

local function GetSpellRemainingTime(snapshotSpell)
	-- For snapshotData objects that contain .isActive or .endTime
	local currentTime = GetTime()
	local remainingTime = 0

	if snapshotSpell.endTime ~= nil and (snapshotSpell.isActive or snapshotSpell.endTime > currentTime) then
		remainingTime = snapshotSpell.endTime - currentTime
	end

	return remainingTime
end
TRB.Functions.GetSpellRemainingTime = GetSpellRemainingTime

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
	if guid ~= nil then
		if not TRB.Functions.CheckTargetExists(guid) then
			TRB.Data.snapshotData.targetData.targets[guid] = {}
			TRB.Data.snapshotData.targetData.targets[guid].snapshot = {}
			TRB.Data.snapshotData.targetData.targets[guid].ttd = 0
		end
	end
end
TRB.Functions.InitializeTarget = InitializeTarget

local function InitializeTarget_Class(guid)
	--To be implemented in each class/spec module
end
TRB.Functions.InitializeTarget_Class = InitializeTarget_Class

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
	if thresholdLine == nil then
		print("|cFFFFFF00TRB Warning: |r RepositionThreshold() called without a valid thresholdLine!")
		return
	end

	if resourceMax == nil or resourceMax == 0 then
        resourceMax = TRB.Data.character.maxResource		
		if resourceMax == 0 then
			resourceMax = 100
		end
    end

	local min, max = parentFrame:GetMinMaxValues()
	local factor = (max - (settings.bar.border * 2)) / resourceMax

	if settings ~= nil and settings.bar ~= nil then
		thresholdLine:SetPoint("LEFT", parentFrame,	"LEFT",	(resourceThreshold * factor), 0)
	
		if thresholdLine.icon ~= nil then
			local setPoint = "TOP"
			local setPointRelativeTo = "BOTTOM"
			
			if settings.thresholds.icons.relativeTo == "TOP" then
				setPoint = "BOTTOM"
				setPointRelativeTo = "TOP"
			elseif settings.thresholds.icons.relativeTo == "CENTER" then
				setPoint = "CENTER"
				setPointRelativeTo = "CENTER"
			elseif settings.thresholds.icons.relativeTo == "BOTTOM" then
				setPoint = "TOP"
				setPointRelativeTo = "BOTTOM"
			end
		
			thresholdLine.icon:ClearAllPoints()
			thresholdLine.icon:SetPoint(setPoint, thresholdLine, setPointRelativeTo, settings.thresholds.icons.xPos, settings.thresholds.icons.yPos)
			thresholdLine.icon:SetSize(settings.thresholds.icons.width, settings.thresholds.icons.height)
		end
	end
end
TRB.Functions.RepositionThreshold = RepositionThreshold

local function ShowResourceBar()
	if TRB.Details.addonData.registered == false then
		TRB.Functions.EventRegistration()
	end

	TRB.Data.snapshotData.isTracking = true
	TRB.Functions.HideResourceBar()
end
TRB.Functions.ShowResourceBar = ShowResourceBar

local function HideResourceBar()
	TRB.Data.snapshotData.isTracking = false
	--This is a placeholder for an implementation per class/spec
end
TRB.Functions.HideResourceBar = HideResourceBar

local function UpdateBarHeight(settings)
	local value = settings.bar.height

	TRB.Frames.barContainerFrame:SetHeight(value-(settings.bar.border*2))
	TRB.Frames.barBorderFrame:SetHeight(settings.bar.height)
	TRB.Frames.resourceFrame:SetHeight(value-(settings.bar.border*2))
	TRB.Frames.castingFrame:SetHeight(value-(settings.bar.border*2))
	TRB.Frames.passiveFrame:SetHeight(value-(settings.bar.border*2))
	TRB.Frames.leftTextFrame:SetHeight(settings.bar.height * 3.5)
	TRB.Frames.middleTextFrame:SetHeight(settings.bar.height * 3.5)
	TRB.Frames.rightTextFrame:SetHeight(settings.bar.height * 3.5)
	TRB.Functions.RedrawThresholdLines(settings)
end
TRB.Functions.UpdateBarHeight = UpdateBarHeight

local function UpdateBarWidth(settings)
	local value = settings.bar.width

	TRB.Frames.barContainerFrame:SetWidth(value-(settings.bar.border*2))
	TRB.Frames.barBorderFrame:SetWidth(settings.bar.width)
	TRB.Frames.resourceFrame:SetWidth(value-(settings.bar.border*2))
	TRB.Frames.castingFrame:SetWidth(value-(settings.bar.border*2))
	TRB.Frames.passiveFrame:SetWidth(value-(settings.bar.border*2))
	TRB.Functions.SetBarMinMaxValues(settings)
end
TRB.Functions.UpdateBarWidth = UpdateBarWidth

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

local function SetBarCurrentValue(settings, bar, value, maxResource)
	maxResource = maxResource or TRB.Data.character.maxResource
	value = value or 0
	if settings ~= nil and settings.bar ~= nil and bar ~= nil and TRB.Data.character.maxResource ~= nil and TRB.Data.character.maxResource > 0 then
		local min, max = bar:GetMinMaxValues()
		local factor = max / maxResource
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

local function SetThresholdIcon(threshold, settingKey, settings)
	if threshold.icon == nil then
		return
	end

	threshold.icon.texture:SetTexture(TRB.Data.spells[settingKey].texture)
	
	if settings.thresholds.icons.enabled then
		threshold.icon:Show()
	else
		threshold.icon:Hide()
	end
end
TRB.Functions.SetThresholdIcon = SetThresholdIcon

local function ResetThresholdLine(threshold, settings, hasIcon)
	local borderSubtraction = 0

	if not settings.thresholds.overlapBorder then
		borderSubtraction = settings.bar.border * 2
	end

	threshold:SetWidth(settings.thresholds.width)
	threshold:SetHeight(settings.bar.height - borderSubtraction)
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, TRB.Data.settings.core.strata.level)
	threshold.texture:SetAllPoints(threshold)
	threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.under, true))
	threshold:SetFrameLevel(127)
	threshold:Hide()
	
	if hasIcon == true then
		threshold.icon = threshold.icon or CreateFrame("Frame", nil, threshold, "BackdropTemplate")
		--threshold.icon:SetPoint("TOP", threshold, "BOTTOM", 0, -10)
		--threshold.icon:SetSize(20, 20)
		threshold.icon:SetFrameLevel(130)
		threshold.icon:SetFrameStrata(TRB.Data.settings.core.strata.level)
		threshold.icon.texture = threshold.icon.texture or threshold.icon:CreateTexture(nil, TRB.Data.settings.core.strata.level)
		threshold.icon.texture:SetAllPoints(threshold.icon)
		--threshold.icon.texture:SetTexture("Interface\\Icons\\Ability_Druid_TreeofLife")
		--threshold.icon.cooldown = threshold.icon.cooldown or CreateFrame("Cooldown", nil, threshold.icon, "CooldownFrameTemplate")
		--threshold.icon.cooldown:SetAllPoints(threshold.icon)
		--threshold.icon.cooldown:SetFrameStrata(TRB.Data.settings.core.strata.level)
		if settings.thresholds.icons.border < 1 then
			threshold.icon:SetBackdrop({
				insets = {0, 0, 0, 0}
			})
		else
			threshold.icon:SetBackdrop({
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				tile = true,
				tileSize = 4,
				edgeSize = settings.thresholds.icons.border,
				insets = {0, 0, 0, 0}
			})			
		end
		threshold.icon:SetBackdropColor(0, 0, 0, 0)
		threshold.icon:SetBackdropBorderColor(0, 0, 0, 1)

		if settings.thresholds.icons.enabled then
			threshold.icon:Show()
		else
			threshold.icon:Hide()
		end
	end
end
TRB.Functions.ResetThresholdLine = ResetThresholdLine

local function RedrawThresholdLines(settings)
	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame

	local entries = TRB.Functions.TableLength(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			TRB.Functions.ResetThresholdLine(resourceFrame.thresholds[x], settings, true)
		end
	end

	entries = TRB.Functions.TableLength(passiveFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			TRB.Functions.ResetThresholdLine(passiveFrame.thresholds[x], settings, false)
			passiveFrame.thresholds[x].texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.mindbender, true))
		end
	end

	TRB.Frames.resourceFrame = resourceFrame
	TRB.Frames.passiveFrame = passiveFrame
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
        barBorderFrame:SetFrameLevel(101)

        resourceFrame:Show()
        resourceFrame:SetMinMaxValues(0, settings.bar.width)
        resourceFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        resourceFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        resourceFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        resourceFrame:SetStatusBarTexture(settings.textures.resourceBar)
        resourceFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base))
        resourceFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		resourceFrame:SetFrameLevel(100)

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

		if TRB.Frames.resource2Frames ~= nil and settings.comboPoints ~= nil then
			local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
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
				
				container:SetBackdropColor(GetRGBAFromString(settings.colors.comboPoints.background, true))
				--container:SetWidth(nodeWidth-(settings.comboPoints.border*2))
				container:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
				container:SetFrameStrata(TRB.Data.settings.core.strata.level)
				container:SetFrameLevel(0)

				--[[
				if settings.comboPoints.border < 1 then
					border:Show()
					border.backdropInfo = {
						edgeFile = settings.textures.comboPointsBorder,
						tile = true,
						tileSize=4,
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
				]]
		
				border:ClearAllPoints()
				border:SetPoint("CENTER", container)
				border:SetPoint("CENTER", 0, 0)
				border:SetBackdropColor(0, 0, 0, 0)
				border:SetBackdropBorderColor(GetRGBAFromString(settings.colors.comboPoints.border, true))
				--border:SetWidth(nodeWidth)
				--border:SetHeight(settings.comboPoints.height)
				border:SetFrameStrata(TRB.Data.settings.core.strata.level)
				border:SetFrameLevel(111)
		
				resource:Show()
				resource:SetMinMaxValues(0, 1)
				--resource:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
				resource:SetPoint("LEFT", container, "LEFT", 0, 0)
				resource:SetPoint("RIGHT", container, "RIGHT", 0, 0)
				resource:SetStatusBarTexture(settings.textures.comboPointsBar)
				resource:SetStatusBarColor(GetRGBAFromString(settings.colors.comboPoints.base))
				resource:SetFrameStrata(TRB.Data.settings.core.strata.level)
				resource:SetFrameLevel(110)
			end
		end

        TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
		TRB.Functions.RedrawThresholdLines(settings)

		SetBarMinMaxValues(settings)

        leftTextFrame:Show()
        leftTextFrame:SetWidth(settings.bar.width)
        leftTextFrame:SetHeight(settings.bar.height * 3.5)
        leftTextFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 2, 0)
        leftTextFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        leftTextFrame:SetFrameLevel(200)
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
        middleTextFrame:SetFrameLevel(200)
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
        rightTextFrame:SetFrameLevel(200)
        rightTextFrame.font:SetPoint("RIGHT", 0, 0)
        rightTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
        rightTextFrame.font:SetJustifyH("RIGHT")
        rightTextFrame.font:SetFont(settings.displayText.right.fontFace, settings.displayText.right.fontSize, "OUTLINE")
        rightTextFrame.font:Show()
    end
end
TRB.Functions.ConstructResourceBar = ConstructResourceBar

local function RepositionBarForPRD(settings, containerFrame)
	if settings.bar.pinToPersonalResourceDisplay then
		containerFrame:ClearAllPoints()
		containerFrame:SetPoint("CENTER", C_NamePlate.GetNamePlateForUnit("player"), "CENTER", settings.bar.xPos, settings.bar.yPos)
	end
end
TRB.Functions.RepositionBarForPRD = RepositionBarForPRD

local function RepositionBar(settings, containerFrame)
	if settings.bar.pinToPersonalResourceDisplay then
		TRB.Functions.RepositionBarForPRD(settings, containerFrame)
	else
		containerFrame:ClearAllPoints()
		containerFrame:SetPoint("CENTER", UIParent)
		containerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	end

	if TRB.Frames.resource2Frames ~= nil and settings.comboPoints ~= nil then
		local containerFrame2 = TRB.Frames.resource2ContainerFrame
		local length = TRB.Functions.TableLength(TRB.Frames.resource2Frames)
		local nodes = TRB.Data.character.maxResource2

		if nodes == nil or nodes == 0 then
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
			nodeWidth = ((settings.bar.width - ((nodes - 1) * (nodeSpacing - settings.comboPoints.border * 2))) / nodes)

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
        containerFrame2:SetFrameLevel(0)
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
						tileSize=4,
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
				border:SetBackdropBorderColor(GetRGBAFromString(settings.colors.comboPoints.border, true))

				border:SetWidth(nodeWidth)
				border:SetHeight(settings.comboPoints.height)
				
				resource:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
			else
				container:Hide()
			end
		end
	end
end
TRB.Functions.RepositionBar = RepositionBar

local function TriggerResourceBarUpdates()
	--To be implemented in each class/spec module
end
TRB.Functions.TriggerResourceBarUpdates = TriggerResourceBarUpdates

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
					local _, icon
					_, _, icon = GetSpellInfo(spellId)

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
			elseif string.sub(input, a+1, a+5) == "item_" then
				z, z1 = string.find(input, "_", a+6)
				if z ~= nil then
					local iconName = string.sub(input, a, z)
					local itemId = string.sub(input, a+6, z-1)
					local _, icon
					_, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemId)

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

					if p == 0 then --Prevent weird newline issues
						returnText = " "
					end

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

-- Implemented separately in older 1-spec modules like Balance Druid and Elemental Shaman
local function IsTtdActive(settings)
	if settings ~= nil and settings.displayText ~= nil then
		if string.find(settings.displayText.left.text, "$ttd") or
			string.find(settings.displayText.middle.text, "$ttd") or
			string.find(settings.displayText.right.text, "$ttd") then
			TRB.Data.snapshotData.targetData.ttdIsActive = true
		else
			TRB.Data.snapshotData.targetData.ttdIsActive = false
		end
	else
		TRB.Data.snapshotData.targetData.ttdIsActive = false
	end
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

	--$gcd
	local _gcd = 1.5 / (1 + (TRB.Data.snapshotData.haste/100))
	if _gcd > 1.5 then
		_gcd = 1.5
	elseif _gcd < 0.75 then
		_gcd = 0.75
	end
	local gcd = string.format("%.2f", _gcd)

	--$haste
	local hastePercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.haste, settings.hastePrecision))

	--$vers
	local versOff = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.versatilityOffensive, settings.hastePrecision))
	local versDef = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.versatilityDefensive, settings.hastePrecision))

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
	lookup["$vers"] = versOff
	lookup["$versatility"] = versOff
	lookup["$oVers"] = versOff
	lookup["$dVers"] = versDef
	lookup["$isKyrian"] = tostring(TRB.Functions.IsValidVariableBase("$isKyrian"))
	lookup["$isVenthyr"] = tostring(TRB.Functions.IsValidVariableBase("$isVenthyr"))
	lookup["$isNightFae"] = tostring(TRB.Functions.IsValidVariableBase("$isNightFae"))
	lookup["$isNecrolord"] = tostring(TRB.Functions.IsValidVariableBase("$isNecrolord"))
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
	elseif var == "$vers" or var == "$versatility" or var == "$oVers" then
		valid = true
	elseif var == "$dVers" then
		valid = true
	elseif var == "$ttd" or var == "$ttdSeconds" then
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and UnitGUID("target") ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd > 0 then
			valid = true
		end
	elseif var == "$isKyrian" then
		if TRB.Data.character.covenantId == 1 then
			valid = true
		end
	elseif var == "$isVentyr" then
		if TRB.Data.character.covenantId == 2 then
			valid = true
		end
	elseif var == "$isNightFae" then
		if TRB.Data.character.covenantId == 3 then
			valid = true
		end
	elseif var == "$isNecrolord" then
		if TRB.Data.character.covenantId == 4 then
			valid = true
		end
	end

	return valid
end
TRB.Functions.IsValidVariableBase = IsValidVariableBase

local function ScanForLogicSymbols(input)
	local returnTable = {
		all = {}
	}

	if input == nil or string.len(input) == 0 then
		return returnTable
	end

	local a, b, c, d, e, e_1, e_2, e_3, f, g, h, i, j
	local _
	local currentLevel = 0
	local min
	local index = 0

	local all = {}

	local endLength = (string.len(input) + 1)

	local currentPosition = 0
    while currentPosition <= string.len(input) do
        a, _ = string.find(input, "{", currentPosition)
        b, _ = string.find(input, "}", currentPosition)
        c, _ = string.find(input, "%[", currentPosition)
        d, _ = string.find(input, "]", currentPosition)
		e, _ = string.find(input, "||", currentPosition)
		e_1, _ = string.find(input, "|n", currentPosition)
		e_2, _ = string.find(input, "|c", currentPosition)
		e_3, _ = string.find(input, "|r", currentPosition)
		f, _ = string.find(input, "&", currentPosition)
		g, _ = string.find(input, "!", currentPosition)
		h, _ = string.find(input, "%$", currentPosition)
		i, _ = string.find(input, "%(", currentPosition)
		j, _ = string.find(input, ")", currentPosition)


		a = a or endLength
		b = b or endLength
		c = c or endLength
		d = d or endLength
		e = e or endLength
		e_1 = e_1 or endLength
		e_2 = e_2 or endLength
		e_3 = e_3 or endLength
		f = f or endLength
		g = g or endLength
		h = h or endLength
		i = i or endLength
		j = j or endLength

		if e == e_1 or e == e_2 or e == e_3 then
			e = endLength
		end

		min = math.min(a, b, c, d, e, f, g, h, i, j)
		index = index + 1

		if min <= string.len(input) then
			local ins = {
				position = min,
				level = currentLevel,
				index = index
			}

			if min == a then
				currentLevel = currentLevel + 1
				ins.level = currentLevel
				ins.symbol = "{"
				currentPosition = a + 1
			elseif min == b then
				currentLevel = currentLevel - 1
				ins.symbol = "}"
				currentPosition = b + 1
			elseif min == c then
				currentLevel = currentLevel + 1
				ins.level = currentLevel
				ins.symbol = "["
				currentPosition = c + 1
			elseif min == d then
				currentLevel = currentLevel - 1
				ins.symbol = "]"
				currentPosition = d + 1
			elseif min == e then
				ins.symbol = "|"
				currentPosition = e + 1
			elseif min == f then
				ins.symbol = "&"
				currentPosition = f + 1
			elseif min == g then
				ins.symbol = "!"
				currentPosition = g + 1
			elseif min == h then
				ins.symbol = "$"
				currentPosition = h + 1
			elseif min == i then
				currentLevel = currentLevel + 1
				ins.level = currentLevel
				ins.symbol = "("
				currentPosition = i + 1
			elseif min == j then
				ins.symbol = ")"
				currentLevel = currentLevel - 1
				currentPosition = j + 1
			else -- Something went wrong. Break for safety
				currentPosition = string.len(input) + 1
				break
			end

			table.insert(all, ins)
		else
			currentPosition = string.len(input) + 1
			break
		end
	end
	returnTable.all = all

	return returnTable
end
TRB.Functions.ScanForLogicSymbols = ScanForLogicSymbols

local function FindNextSymbolIndex(t, symbol, notSymbol, minIndex, maxIndex, minPosition, maxPosition)
	if t == nil or symbol == nil then
		return nil
	end

	local len = TRB.Functions.TableLength(t)
	if len == 0 then
		return nil
	end

	if minIndex == nil then
		minIndex = 0
	end

	if minPosition == nil then
		minPosition = 0
	end

	if notSymbol == nil then
		notSymbol = false
	end

	if maxIndex == nil then
		maxIndex = t[len].index
	end

	if maxPosition == nil then
		maxPosition = t[len].position
	end

	for k, v in ipairs(t) do
		if t[k] ~= nil and
			((t[k].symbol == symbol and not notSymbol) or (t[k].symbol ~= symbol and notSymbol)) and
			t[k].index >= minIndex and
			t[k].index <= maxIndex and
			t[k].position >= minPosition and
			t[k].position <= maxPosition then
			return t[k]
		end
	end
	return nil
end
TRB.Functions.FindNextSymbolIndex = FindNextSymbolIndex

local function FindNextSymbolLevel(t, symbol, minIndex, level)
	if t == nil or symbol == nil or level == nil or level < 0 then
		return nil
	end

	if minIndex == nil then
		minIndex = 0
	end

	local len = TRB.Functions.TableLength(t)

	if len > 0 then
		for k, v in ipairs(t) do
			if t[k] ~= nil and t[k].level ~= nil and t[k].index >= minIndex and t[k].symbol == symbol and t[k].level == level then
				return t[k]
			end
		end
	end
	return nil
end
TRB.Functions.FindNextSymbolLevel = FindNextSymbolLevel

local function RemoveInvalidVariablesFromBarText(inputString)
	local scan = TRB.Functions.ScanForLogicSymbols(inputString)

    local function RemoveInvalidVariablesFromBarText_Inner(input, indexOffset, maxIndex, positionOffset, maxPosition)
		local returnText = ""

---@diagnostic disable-next-line: undefined-field
		if string.trim(string.len(input)) == 0 then
			return returnText
		end

		local p = 0

		if indexOffset == nil then
			indexOffset = 0
		end

		if positionOffset == nil then
			positionOffset = 0
		end

		local lastIndex = indexOffset
		while p <= string.len(input) do
			local nextOpenIf = TRB.Functions.FindNextSymbolIndex(scan.all, '{', nil, lastIndex, maxIndex)
			if nextOpenIf ~= nil then
				local matchedCloseIf = TRB.Functions.FindNextSymbolLevel(scan.all, '}', nextOpenIf.index+1, nextOpenIf.level)

				if nextOpenIf.position - positionOffset > p then
					returnText = returnText .. string.sub(input, p, nextOpenIf.position - positionOffset - 1)
					p = nextOpenIf.position - positionOffset
				end
				
				if matchedCloseIf ~= nil and matchedCloseIf.symbol == '}' and matchedCloseIf.level == nextOpenIf.level then -- no weird nesting of if logic, which is unsupported
					local nextOpenResult = TRB.Functions.FindNextSymbolLevel(scan.all, '[', matchedCloseIf.index+1, nextOpenIf.level)

					if nextOpenResult ~= nil and nextOpenResult.symbol == '[' and matchedCloseIf.position - positionOffset + 1 == nextOpenResult.position - positionOffset then -- no weird spacing/nesting
						local nextCloseResult = TRB.Functions.FindNextSymbolLevel(scan.all, ']', nextOpenResult.index, nextOpenResult.level)
						if nextCloseResult ~= nil then
							local hasElse = false
							local elseOpenResult = TRB.Functions.FindNextSymbolLevel(scan.all, '[', nextCloseResult.index, nextOpenResult.level)
							local elseCloseResult

							if elseOpenResult ~= nil and elseOpenResult.position - positionOffset == nextCloseResult.position - positionOffset + 1 then
								elseCloseResult = TRB.Functions.FindNextSymbolLevel(scan.all, ']', elseOpenResult.index, nextOpenResult.level)

								if elseCloseResult ~= nil then
									-- We have if/else
									hasElse = true
								end
							end

---@diagnostic disable-next-line: undefined-field
							local logicString = string.trim(string.sub(input, nextOpenIf.position - positionOffset + 1, matchedCloseIf.position - positionOffset - 1))
							local s = nextOpenIf.position - positionOffset + 1
							local outputString = ""
							local lastLogicIndex = nextOpenIf.index+1
							while s-p-1 <= string.len(logicString) do
								local nextVariable = TRB.Functions.FindNextSymbolIndex(scan.all, '$', nil, lastLogicIndex, nil, nil, matchedCloseIf.position + 1)
								
								if nextVariable ~= nil then
									local nextSymbol = TRB.Functions.FindNextSymbolIndex(scan.all, '$', true, nextVariable.index, nil, nil, matchedCloseIf.position + 1)
									local variableEnd = string.len(logicString)

									if nextSymbol ~= nil then
										variableEnd = nextSymbol.position - positionOffset - p - 1
									end

---@diagnostic disable-next-line: undefined-field
									local var = string.trim(string.sub(logicString, nextVariable.position - positionOffset - p, variableEnd))
									local valid = TRB.Data.IsValidVariableForSpec(var)
---@diagnostic disable-next-line: undefined-field
									local beforeVar = string.trim(string.sub(logicString, s-p, nextVariable.position - positionOffset - p - 1))

									if string.sub(beforeVar, string.len(beforeVar)) == "!" then
										outputString = outputString .. " " .. string.sub(beforeVar, 0, string.len(beforeVar)-1) .. " (not " .. tostring(valid) .. ") "
									else
										outputString = outputString .. " " .. beforeVar .. " " .. tostring(valid)
									end

									s = p + variableEnd + 1
									lastLogicIndex = nextVariable.index + 1
								else
---@diagnostic disable-next-line: undefined-field
									local remainder = string.trim(string.sub(logicString, s-p))
									outputString = outputString .. " " .. remainder
									s = p + string.len(logicString) + 2
								end
							end

							outputString = string.lower(outputString)
							outputString = string.gsub(outputString, "!", " not ")
							outputString = string.gsub(outputString, "&", " and ")
							outputString = string.gsub(outputString, "||", " or ")

							local resultCode, resultFunc = pcall(assert, loadstring("return (" .. outputString .. ")"))
							
							if resultCode then
								local _, result = pcall(resultFunc)
								if result == true then
									-- Recursive call for "IF", once we find the matched ]
									local trueText = string.sub(input, nextOpenResult.position - positionOffset + 1, nextCloseResult.position - positionOffset - 1)
									returnText = returnText .. RemoveInvalidVariablesFromBarText_Inner(trueText, nextOpenResult.index, nextCloseResult.index - 1, nextOpenResult.position, nextCloseResult.position - 1)
								elseif result == false and hasElse == true then
									-- Recursive call for "ELSE", once we find the matched ]
									local falseText = string.sub(input, elseOpenResult.position - positionOffset + 1, elseCloseResult.position - positionOffset - 1)
									returnText = returnText .. RemoveInvalidVariablesFromBarText_Inner(falseText, elseOpenResult.index, elseCloseResult.index - 1, elseOpenResult.position, elseCloseResult.position - 1)
								end
							else -- Something went wrong, show the error text instead
								returnText = returnText .. "{INVALID IF/ELSE LOGIC}"
							end

							if hasElse == true then
								p = elseCloseResult.position - positionOffset + 1
								lastIndex = elseCloseResult.index
							else
								p = nextCloseResult.position - positionOffset + 1
								lastIndex = nextCloseResult.index
							end
						else -- TRUE result block doesn't close, no matching ]
							returnText = returnText .. string.sub(input, p, nextOpenResult.position - positionOffset)
							p = nextOpenResult.position - positionOffset + 1
							lastIndex = nextOpenResult.index
						end
					else -- Dump all of the previous "if" stuff verbatim
						returnText = returnText .. string.sub(input, p, matchedCloseIf.position - positionOffset)
						p = matchedCloseIf.position - positionOffset + 1
						lastIndex = matchedCloseIf.index
					end
				elseif matchedCloseIf ~= nil then --nextCloseIf.position+1 is not [
					returnText = returnText .. string.sub(input, p, matchedCloseIf.position - positionOffset)
					p = matchedCloseIf.position - positionOffset + 1
					lastIndex = matchedCloseIf.index
				else -- End of string
					returnText = returnText .. string.sub(input, p)
					p = string.len(input) + 1
				end
			else
				returnText = returnText .. string.sub(input, p)
				p = string.len(input)
				break
			end
		end
		return returnText
	end

	return RemoveInvalidVariablesFromBarText_Inner(inputString)
end
TRB.Functions.RemoveInvalidVariablesFromBarText = RemoveInvalidVariablesFromBarText


-- Character Functions

local function FindBuffByName(spellName, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName, _, _, _, _, _, castBy = UnitBuff(onWhom, i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName and (byWhom == nil or byWhom == castBy) then
			return UnitBuff(onWhom, i)
		end
	end
end
TRB.Functions.FindBuffByName = FindBuffByName

local function FindBuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local _, _, _, _, _, _, castBy, _, _, unitSpellId = UnitBuff(onWhom, i)
		if not unitSpellId then
			return
		elseif spellId == unitSpellId and (byWhom == nil or byWhom == castBy) then
			return UnitBuff(onWhom, i)
		end
	end
end
TRB.Functions.FindBuffById = FindBuffById

local function FindDebuffByName(spellName, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local unitSpellName, _, _, _, _, _, castBy = UnitDebuff(onWhom, i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName and (byWhom == nil or byWhom == castBy) then
			return UnitDebuff(onWhom, i)
		end
	end
end
TRB.Functions.FindDebuffByName = FindDebuffByName

local function FindDebuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local _, _, _, _, _, _, castBy, _, _, unitSpellId = UnitDebuff(onWhom, i)
		if not unitSpellId then
			return
		elseif spellId == unitSpellId and (byWhom == nil or byWhom == castBy) then
			return UnitDebuff(onWhom, i)
		end
	end
end
TRB.Functions.FindDebuffById = FindDebuffById

local function FindAuraByName(spellName, onWhom, filter, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end
	for i = 1, 1000 do
		local unitSpellName, _, _, _, _, _, castBy = UnitAura(onWhom, i, filter)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName and (byWhom == nil or byWhom == castBy) then
			return UnitAura(onWhom, i, filter)
		end
	end
end
TRB.Functions.FindAuraByName = FindAuraByName

local function FindAuraById(spellId, onWhom, filter, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	for i = 1, 1000 do
		local _, _, _, _, _, _, castBy, _, _, unitSpellId = UnitAura(onWhom, i, filter)
		if not unitSpellId then
			return
		elseif spellId == unitSpellId and (byWhom == nil or byWhom == castBy) then
			return UnitAura(onWhom, i, filter)
		end
	end
end
TRB.Functions.FindAuraById = FindAuraById

local function CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
    TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Data.character.covenantId = C_Covenants.GetActiveCovenantID()

	-- Sanctum of Domination
	if C_Map.GetBestMapForUnit("player") == TRB.Data.constants.sanctumOfDominationZoneId and TRB.Functions.FindAuraById(TRB.Data.constants.overgrowthSeedling.id, "player", "MAW") then
		TRB.Data.character.effects.overgrowthSeedlingModifier = 
		TRB.Data.constants.overgrowthSeedling.resourceModifier
	else
		TRB.Data.character.effects.overgrowthSeedlingModifier = 1
	end
	TRB.Data.barTextCache = {}
	TRB.Functions.FillSpellData()
end
TRB.Functions.CheckCharacter = CheckCharacter

local function CheckCharacter_Class()
	--To be implemented in each class/spec module
end
TRB.Functions.CheckCharacter_Class = CheckCharacter_Class

local function UpdateSnapshot()
	TRB.Data.snapshotData.resource = UnitPower("player", TRB.Data.resource, true)

	if TRB.Data.resource2 ~= nil then
		TRB.Data.snapshotData.resource2 = UnitPower("player", TRB.Data.resource2, true)
	end

	TRB.Data.snapshotData.haste = UnitSpellHaste("player")
	TRB.Data.snapshotData.crit = GetCritChance("player")
	TRB.Data.snapshotData.mastery = GetMasteryEffect("player")
	TRB.Data.snapshotData.versatilityOffensive = GetCombatRatingBonus(29)
	TRB.Data.snapshotData.versatilityDefensive = GetCombatRatingBonus(31)

	if IsInJailersTower() then
		TRB.Data.character.torghast.rampaging.spellCostModifier, TRB.Data.character.torghast.rampaging.coolDownReduction = TRB.Functions.GetRampagingBuff()
	else
		TRB.Data.character.torghast.rampaging.spellCostModifier = 1
		TRB.Data.character.torghast.rampaging.coolDownReduction = 1
	end
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

local function DoesItemLinkMatchId(itemLink, id)
	local parts = { strsplit(":", itemLink) }
	-- Note for Future Twintop:
	--  1  = Item Name
	--  2  = Item Id
	if tonumber(parts[2]) == id then
		return true
	end
	return false
end
TRB.Functions.DoesItemLinkMatchId = DoesItemLinkMatchId

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

-- Source: https://www.wowinterface.com/forums/showpost.php?p=338665&postcount=5
local function ArePvpTalentsActive()
    local inInstance, instanceType = IsInInstance()
    if inInstance and (instanceType == "pvp" or instanceType == "arena") then
        return true
    elseif inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
        return false
    else
        local talents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        for _, pvptalent in pairs(talents) do
            local spellID = select(6, GetPvpTalentInfoByID(pvptalent))
            if IsPlayerSpell(spellID) then
                return true
            end
        end
    end
end
TRB.Functions.ArePvpTalentsActive = ArePvpTalentsActive

-- Torghast specific

local function GetRampagingBuff()
	local name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, manaCost, cdr = TRB.Functions.FindBuffById(TRB.Data.constants.rampagingId)

	if name == nil then
		return 1, 1
	else
		return 1 + (manaCost/100), 1 / (1 + (cdr/100))
	end
end
TRB.Functions.GetRampagingBuff = GetRampagingBuff

-- LibSharedMedia Support Functions

local function ValidateLsmValues(specName, settings)
	-- Text
	if not TRB.Details.addonData.libs.SharedMedia:IsValid("font", settings.displayText.left.fontFaceName) then
		print("TRB: |cFFFF5555Invalid font (" .. specName .. " left bar text): '|r" .. settings.displayText.left.fontFaceName .. "|cFFFF5555'. Resetting to a default font.|r")
		settings.displayText.left.fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace
		settings.displayText.left.fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName
	end
	
	if not TRB.Details.addonData.libs.SharedMedia:IsValid("font", settings.displayText.middle.fontFaceName) then
		print("TRB: |cFFFF5555Invalid font (" .. specName .. " middle bar text): '|r" .. settings.displayText.middle.fontFaceName .. "|cFFFF5555'. Resetting to a default font.|r")
		settings.displayText.middle.fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace
		settings.displayText.middle.fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName
	end
	
	if not TRB.Details.addonData.libs.SharedMedia:IsValid("font", settings.displayText.right.fontFaceName) then
		print("TRB: |cFFFF5555Invalid font (" .. specName .. " right bar text): '|r" .. settings.displayText.right.fontFaceName .. "|cFFFF5555'. Resetting to a default font.|r")
		settings.displayText.right.fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace
		settings.displayText.right.fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName
	end

	-- Textures
	if not TRB.Details.addonData.libs.SharedMedia:IsValid("background", settings.textures.backgroundName) then
		print("TRB: |cFFFF5555Invalid texture (" .. specName .. " bar background): '|r" .. settings.textures.backgroundName .. "|cFFFF5555'. Resetting to a default texture.|r")
		settings.textures.background = TRB.Data.constants.defaultSettings.textures.background
		settings.textures.backgroundName = TRB.Data.constants.defaultSettings.textures.backgroundName
	end

	if not TRB.Details.addonData.libs.SharedMedia:IsValid("border", settings.textures.borderName) then
		print("TRB: |cFFFF5555Invalid texture (" .. specName .. " bar border): '|r" .. settings.textures.borderName .. "|cFFFF5555'. Resetting to a default texture.|r")
		settings.textures.border = TRB.Data.constants.defaultSettings.textures.border
		settings.textures.borderName = TRB.Data.constants.defaultSettings.textures.borderName
	end

	if not TRB.Details.addonData.libs.SharedMedia:IsValid("statusbar", settings.textures.resourceBarName) then
		print("TRB: |cFFFF5555Invalid texture (" .. specName .. " resource bar): '|r" .. settings.textures.resourceBarName .. "|cFFFF5555'. Resetting to a default texture.|r")
		settings.textures.resourceBar = TRB.Data.constants.defaultSettings.textures.resourceBar
		settings.textures.resourceBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
	end

	if not TRB.Details.addonData.libs.SharedMedia:IsValid("statusbar", settings.textures.passiveBarName) then
		print("TRB: |cFFFF5555Invalid texture (" .. specName .. " passive bar): '|r" .. settings.textures.passiveBarName .. "|cFFFF5555'. Resetting to a default texture.|r")
		settings.textures.passiveBar = TRB.Data.constants.defaultSettings.textures.resourceBar
		settings.textures.passiveBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
	end

	if not TRB.Details.addonData.libs.SharedMedia:IsValid("statusbar", settings.textures.castingBarName) then
		print("TRB: |cFFFF5555Invalid texture (" .. specName .. " casting bar): '|r" .. settings.textures.castingBarName .. "|cFFFF5555'. Resetting to a default texture.|r")
		settings.textures.castingBar = TRB.Data.constants.defaultSettings.textures.resourceBar
		settings.textures.castingBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
	end

	for k, v in pairs(settings.audio) do
		if v.soundName == nil or not TRB.Details.addonData.libs.SharedMedia:IsValid("sound", v.soundName) then
			if v.name ~= nil and v.soundName ~= nil then
				print("TRB: |cFFFF5555Invalid sound (" .. specName .. " '" .. v.name .. "'): '|r" .. v.soundName .. "|cFFFF5555'. Resetting to a default sound.|r")
			elseif v.soundName ~= nil then
				print("TRB: |cFFFF5555Invalid sound (" .. specName .. "): '|r" .. v.soundName .. "|cFFFF5555'. Resetting to a default sound.|r")
			elseif v.name ~= nil then
				print("TRB: |cFFFF5555Invalid sound (" .. specName .. " '" .. v.name .. "'). Resetting to a default sound.|r")
			else
				print("TRB: |cFFFF5555Invalid sound (" .. specName .. "). Resetting to a default sound.|r")
			end
			settings.audio[k].sound = TRB.Data.constants.defaultSettings.sounds.sound
			settings.audio[k].soundName = TRB.Data.constants.defaultSettings.sounds.soundName
		end
	end
	return settings
end
TRB.Functions.ValidateLsmValues = ValidateLsmValues

-- Import/Export Functions

local function Import(input)
	local json = TRB.Functions.GetJsonLibrary()
	local base64 = TRB.Functions.GetBase64Library()

	local prefix = string.sub(input, 1, 5)

	if prefix == EXPORT_STRING_PREFIX then
		input = string.sub(input, 6)
	end

	local decoded, configuration, mergedSettings, result

	result, decoded = pcall(base64.decode, input)

	if not result then
		return -1
	end

	result, configuration = pcall(json.decode, decoded)

	if not result then
		return -2
	end

	if not (configuration.core ~= nil or
		(configuration.warrior ~= nil and configuration.warrior.arms ~= nil) or
		(configuration.rogue ~= nil and configuration.rogue.assassination ~= nil) or
		(configuration.hunter ~= nil and (configuration.hunter.beastMastery ~= nil or configuration.hunter.marksmanship ~= nil or configuration.hunter.survival ~= nil)) or
		(configuration.priest ~= nil and (configuration.priest.holy ~= nil or configuration.priest.shadow ~= nil)) or
		(configuration.shaman ~= nil and configuration.shaman.elemental ~= nil) or
		(configuration.druid ~= nil and configuration.druid.balance ~= nil)) then
		return -3
	end

	local existingSettings = TRB.Data.settings
	result, mergedSettings = pcall(TRB.Functions.MergeSettings, existingSettings, configuration)

	if not result then
		return -4
	end

	TRB.Data.settings = mergedSettings
	return 1
end
TRB.Functions.Import = Import

local function ExportConfigurationSections(classId, specId, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
	local configuration = {
		colors = {},
		displayText = {}
	}

	if includeBarDisplay then
		configuration.bar = settings.bar
		configuration.displayBar = settings.displayBar
		configuration.textures = settings.textures
		configuration.thresholds = settings.thresholds
		configuration.colors.bar = settings.colors.bar
		configuration.colors.threshold = settings.colors.threshold
		configuration.overcapThreshold = settings.overcapThreshold

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
			elseif specId == 2 then -- Fury
				configuration.endOfEnrage = settings.endOfEnrage
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
				configuration.endOfTrueshot = settings.endOfTrueshot
				configuration.steadyFocus = settings.steadyFocus
			elseif specId == 3 then -- Survival
				configuration.endOfCoordinatedAssault = settings.endOfCoordinatedAssault
			end
		elseif classId == 4 and specId == 1 then -- Assassination Rogue
			configuration.colors.comboPoints = settings.colors.comboPoints
			configuration.comboPoints = settings.comboPoints
		elseif classId == 5 then -- Priests
			if specId == 2 then -- Holy
				configuration.endOfApotheosis = settings.endOfApotheosis
				configuration.flashConcentration = settings.flashConcentration
			elseif specId == 3 then -- Shadow
				configuration.endOfVoidform = settings.endOfVoidform
			end
		elseif classId == 7 and specId == 1 then -- Elemental Shaman
		elseif classId == 11 and specId == 1 then -- Balance Druid
			configuration.endOfEclipse = settings.endOfEclipse
		elseif classId == 12 and specId == 1 then -- Havoc Demon Hunter
			configuration.endOfMetamorphosis = settings.endOfMetamorphosis
		end
	end

	if includeFontAndText then
		configuration.colors.text = settings.colors.text
		configuration.hastePrecision = settings.hastePrecision
		configuration.displayText.fontSizeLock = settings.displayText.fontSizeLock
		configuration.displayText.fontFaceLock = settings.displayText.fontFaceLock
		configuration.displayText.left = {
			fontFace = settings.displayText.left.fontFace,
			fontFaceName = settings.displayText.left.fontFaceName,
			fontSize = settings.displayText.left.fontSize
		}
		configuration.displayText.middle = {
			fontFace = settings.displayText.middle.fontFace,
			fontFaceName = settings.displayText.middle.fontFaceName,
			fontSize = settings.displayText.middle.fontSize
		}
		configuration.displayText.right = {
			fontFace = settings.displayText.right.fontFace,
			fontFaceName = settings.displayText.right.fontFaceName,
			fontSize = settings.displayText.right.fontSize
		}

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
				configuration.ragePrecision = settings.ragePrecision
			elseif specId == 2 then -- Fury
				configuration.ragePrecision = settings.ragePrecision
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 and specId == 1 then -- Assassination Rogue
		elseif classId == 5 then -- Priests
			if specId == 2 then -- Holy
			elseif specId == 3 then -- Shadow
				configuration.hasteApproachingThreshold = settings.hasteApproachingThreshold
				configuration.hasteThreshold = settings.hasteThreshold
				configuration.s2mApproachingThreshold = settings.s2mApproachingThreshold
				configuration.s2mThreshold = settings.s2mThreshold
				configuration.insanityPrecision = settings.insanityPrecision
			end
		elseif classId == 7 and specId == 1 then -- Elemental Shaman
		elseif classId == 11 and specId == 1 then -- Balance Druid
			configuration.astralPowerPrecision = settings.astralPowerPrecision
		elseif classId == 12 and specId == 1 then -- Havoc Demon Hunter
		end
	end

	if includeAudioAndTracking then
		configuration.audio = settings.audio

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
				configuration.ragePrecision = settings.ragePrecision
			elseif specId == 2 then -- Fury
				configuration.ragePrecision = settings.ragePrecision
			end
		elseif classId == 3 then -- Hunters
			configuration.generation = settings.generation
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 and specId == 1 then -- Assassination Rogue
			configuration.generation = settings.generation
		elseif classId == 5 then -- Priests
			if specId == 2 then -- Holy
				configuration.wrathfulFaerie = settings.wrathfulFaerie
				configuration.passiveGeneration = settings.passiveGeneration
			elseif specId == 3 then -- Shadow
				configuration.mindbender = settings.mindbender
				configuration.wrathfulFaerie = settings.wrathfulFaerie
				configuration.auspiciousSpiritsTracker = settings.auspiciousSpiritsTracker
				configuration.voidTendrilTracker = settings.voidTendrilTracker
			end
		elseif classId == 7 and specId == 1 then -- Elemental Shaman
		elseif classId == 11 and specId == 1 then -- Balance Druid
		elseif classId == 12 and specId == 1 then -- Havoc Demon Hunter
		end
	end

	if includeBarText then
		configuration.displayText.left = configuration.displayText.left or {}
		configuration.displayText.left.text = settings.displayText.left.text
		configuration.displayText.middle = configuration.displayText.middle or {}
		configuration.displayText.middle.text = settings.displayText.middle.text
		configuration.displayText.right = configuration.displayText.right or {}
		configuration.displayText.right.text = settings.displayText.right.text
	end

	return configuration
end
TRB.Functions.ExportConfigurationSections = ExportConfigurationSections

local function ExportGetConfiguration(classId, specId, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local settings = TRB.Data.settings
	if includeBarDisplay == nil then
		includeBarDisplay = true
	end

	if includeFontAndText == nil then
		includeFontAndText = true
	end

	if includeAudioAndTracking == nil then
		includeAudioAndTracking = true
	end

	if includeBarText == nil then
		includeBarText = true
	end

	if includeCore == nil then
		includeCore = false -- Don't include unless explicity stated
	end

	local configuration = {}

	if classId ~= nil then -- One class
		if classId == 1 and settings.warrior ~= nil then -- Warrior
			configuration.warrior = {}

			if (specId == 1 or specId == nil) and TRB.Functions.TableLength(settings.warrior.arms) > 0 then -- Arms
				configuration.warrior.arms = TRB.Functions.ExportConfigurationSections(1, 1, settings.warrior.arms, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.TableLength(settings.warrior.fury) > 0 then -- Fury
				configuration.warrior.fury = TRB.Functions.ExportConfigurationSections(1, 2, settings.warrior.fury, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 3 and settings.hunter ~= nil then -- Hunter
			configuration.hunter = {}

			if (specId == 1 or specId == nil) and TRB.Functions.TableLength(settings.hunter.beastMastery) > 0 then -- Beast Mastery
				configuration.hunter.beastMastery = TRB.Functions.ExportConfigurationSections(3, 1, settings.hunter.beastMastery, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.TableLength(settings.hunter.marksmanship) > 0 then -- Marksmanship
				configuration.hunter.marksmanship = TRB.Functions.ExportConfigurationSections(3, 2, settings.hunter.marksmanship, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.TableLength(settings.hunter.survival) > 0 then -- Survival
				configuration.hunter.survival = TRB.Functions.ExportConfigurationSections(3, 3, settings.hunter.survival, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 4 and settings.rogue ~= nil then -- Rogue
			configuration.rogue = {}

			if (specId == 1 or specId == nil) and TRB.Functions.TableLength(settings.rogue.assassination) > 0 then -- Assassination
				configuration.rogue.assassination = TRB.Functions.ExportConfigurationSections(4, 1, settings.rogue.assassination, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 5 and settings.priest ~= nil then -- Priest
			configuration.priest = {}

			if (specId == 2 or specId == nil) and TRB.Functions.TableLength(settings.priest.holy) > 0 then -- Holy
				configuration.priest.holy = TRB.Functions.ExportConfigurationSections(5, 2, settings.priest.holy, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.TableLength(settings.priest.shadow) > 0 then -- Shadow
				configuration.priest.shadow = TRB.Functions.ExportConfigurationSections(5, 3, settings.priest.shadow, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 7 and settings.shaman ~= nil then -- Shaman
			configuration.shaman = {}

			if (specId == 1 or specId == nil) and TRB.Functions.TableLength(settings.shaman.elemental) > 0 then -- Elemental
				configuration.shaman.elemental = TRB.Functions.ExportConfigurationSections(7, 1, settings.shaman.elemental, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 11 and settings.druid ~= nil then -- Druid
			configuration.druid = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.TableLength(settings.druid.balance) > 0 then -- Balance
				configuration.druid.balance = TRB.Functions.ExportConfigurationSections(11, 1, settings.druid.balance, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 12 and settings.demonhunter ~= nil then -- Demon Hunter
			configuration.demonhunter = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.TableLength(settings.demonhunter.havoc) > 0 then -- Havoc
				configuration.demonhunter.havoc = TRB.Functions.ExportConfigurationSections(12, 1, settings.demonhunter.havoc, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		end
	elseif classId == nil and specId == nil then -- Everything
		-- Instead of just dumping the whole table, let's clean it up

		-- Warriors
		-- Arms
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(1, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))
		-- Fury
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(1, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))

		-- Hunters
		-- Beast Mastery
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(3, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))
		-- Marksmanship
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(3, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))
		-- Survival
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(3, 3, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))

		-- Priests
		-- Holy
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(5, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))
		-- Shadow
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(5, 3, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))

		-- Assassination Rogue
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(3, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))

		-- Elemental Shaman
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(7, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))

		-- Balance Druid
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(11, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))
		
		-- Havoc Demon Hunter
		configuration = TRB.Functions.MergeSettings(configuration, TRB.Functions.ExportGetConfiguration(12, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, false))
	end

	if includeCore then
		configuration.core = settings.core
	end

	return configuration
end
TRB.Functions.ExportGetConfiguration = ExportGetConfiguration

local function ExportPopup(exportMessage, classId, specId, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	StaticPopupDialogs["TwintopResourceBar_Export"].text = exportMessage
	StaticPopupDialogs["TwintopResourceBar_Export"].OnShow = function(self)
		local configuration = TRB.Functions.ExportGetConfiguration(classId, specId, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
		local output = TRB.Functions.Export(configuration)
---@diagnostic disable-next-line: undefined-field
		self.editBox:SetText(output)
	end
	StaticPopup_Show("TwintopResourceBar_Export")
end
TRB.Functions.ExportPopup = ExportPopup

local function Export(configuration)
	local json = TRB.Functions.GetJsonLibrary()
	local base64 = TRB.Functions.GetBase64Library()

	local encoded = json.encode(configuration)
	local output = base64.encode(encoded)

	return EXPORT_STRING_PREFIX .. output
end
TRB.Functions.Export = Export

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