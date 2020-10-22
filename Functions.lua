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

local function RoundTo(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
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

-- Addon Maintenance Functions

local function UpdateSanityCheckValues(settings)
    if settings ~= nil and settings.bar ~= nil then
        TRB.Data.sanityCheckValues.barMaxWidth = math.floor(GetScreenWidth())
        TRB.Data.sanityCheckValues.barMinWidth = math.max(math.ceil(settings.bar.border * 8), 120)	
        TRB.Data.sanityCheckValues.barMaxHeight = math.floor(GetScreenHeight())
        TRB.Data.sanityCheckValues.barMinHeight = math.max(math.ceil(settings.bar.border * 8), 1)
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

local function FillSpellData()
	local toc = select(4, GetBuildInfo())

	for k, v in pairs(TRB.Data.spells) do
		if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and (TRB.Data.spells[k]["tocMinVersion"] == nil or toc >= TRB.Data.spells[k]["tocMinVersion"]) then
			local _, name, icon
			name, _, icon = GetSpellInfo(TRB.Data.spells[k]["id"])			
			TRB.Data.spells[k]["icon"] = string.format("|T%s:0|t", icon)
			TRB.Data.spells[k]["name"] = name
		end
	end
end
TRB.Functions.FillSpellData = FillSpellData

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

-- Bar Manipulation Functions

local function RepositionThreshold(settings, thresholdLine, parentFrame, thresholdWidth, resourceThreshold, resourceMax)
    if resourceMax == nil or resourceMax == 0 then
        resourceMax = 100
    end
	
	if settings ~= nil and settings.bar ~= nil then
		thresholdLine:SetPoint("CENTER",
                            parentFrame,
                            "LEFT",
                            math.ceil((settings.bar.width - (settings.bar.border * 2)) * (resourceThreshold / resourceMax) + math.ceil(thresholdWidth / 2)), 0)
    end
end
TRB.Functions.RepositionThreshold = RepositionThreshold

local function ShowResourceBar()
	if TRB.Details.addonData.registered == false then
		EventRegistration()
	end

	TRB.Frames.barContainerFrame:Show()
end
TRB.Functions.ShowResourceBar = ShowResourceBar

local function HideResourceBar()
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


		interfaceSettingsFrame.controls.horizontal:SetValue(xOfs)
		interfaceSettingsFrame.controls.horizontal.EditBox:SetText(RoundTo(xOfs, 0))
		interfaceSettingsFrame.controls.vertical:SetValue(yOfs)
		interfaceSettingsFrame.controls.vertical.EditBox:SetText(RoundTo(yOfs, 0))	
	end
end
TRB.Functions.UpdateBarPosition = UpdateBarPosition

local function CaptureBarPosition()
	local point, relativeTo, relativePoint, xOfs, yOfs = barContainerFrame:GetPoint()

	if relativePoint == "CENTER" then
		--No action needed.
	elseif relativePoint == "TOP" then
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight/2) + yOfs - (TRB.Data.settings.bar.height/2))
	elseif relativePoint == "TOPRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth/2) + xOfs - (TRB.Data.settings.bar.width/2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight/2) + yOfs - (TRB.Data.settings.bar.height/2))
	elseif relativePoint == "RIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth/2) + xOfs - (TRB.Data.settings.bar.width/2))
	elseif relativePoint == "BOTTOMRIGHT" then
		xOfs = ((TRB.Data.sanityCheckValues.barMaxWidth/2) + xOfs - (TRB.Data.settings.bar.width/2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight/2) - yOfs - (TRB.Data.settings.bar.height/2))
	elseif relativePoint == "BOTTOM" then
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight/2) - yOfs - (TRB.Data.settings.bar.height/2))
	elseif relativePoint == "BOTTOMLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth/2) - xOfs - (TRB.Data.settings.bar.width/2))
		yOfs = -((TRB.Data.sanityCheckValues.barMaxHeight/2) - yOfs - (TRB.Data.settings.bar.height/2))
	elseif relativePoint == "LEFT" then				
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth/2) - xOfs - (TRB.Data.settings.bar.width/2))
	elseif relativePoint == "TOPLEFT" then
		xOfs = -((TRB.Data.sanityCheckValues.barMaxWidth/2) - xOfs - (TRB.Data.settings.bar.width/2))
		yOfs = ((TRB.Data.sanityCheckValues.barMaxHeight/2) + yOfs - (TRB.Data.settings.bar.height/2))
	end

	TRB.Functions.UpdateBarPosition(xOfs, yOfs)
end
TRB.Functions.CaptureBarPosition = CaptureBarPosition

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
                CaptureBarPosition()
                self.isMoving = false
            end
        end)
        
        barContainerFrame:SetMovable(settings.bar.dragAndDrop)
        barContainerFrame:EnableMouse(settings.bar.dragAndDrop)

        barContainerFrame:SetScript("OnHide", function(self)
            if self.isMoving then
                self:StopMovingOrSizing()
                CaptureBarPosition()
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
        resourceFrame:SetMinMaxValues(0, 100)
        resourceFrame:SetHeight(settings.bar.height)	
        resourceFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        resourceFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        resourceFrame:SetStatusBarTexture(settings.textures.resourceBar)
        resourceFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base))
        resourceFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        resourceFrame:SetFrameLevel(125)
        
        castingFrame:Show()
        castingFrame:SetMinMaxValues(0, 100)
        castingFrame:SetHeight(settings.bar.height)
        castingFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        castingFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        castingFrame:SetStatusBarTexture(settings.textures.castingBar)
        castingFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.casting))
        castingFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        castingFrame:SetFrameLevel(90)
        
        passiveFrame:Show()
        passiveFrame:SetMinMaxValues(0, 100)
        passiveFrame:SetHeight(settings.bar.height)
        passiveFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        passiveFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        passiveFrame:SetStatusBarTexture(settings.textures.passiveBar)
        passiveFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.passive))
        passiveFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        passiveFrame:SetFrameLevel(80)
        
        passiveFrame.threshold:SetWidth(settings.thresholdWidth)
        passiveFrame.threshold:SetHeight(settings.bar.height)
        passiveFrame.threshold.texture = passiveFrame.threshold:CreateTexture(nil, TRB.Data.settings.core.strata.level)
        passiveFrame.threshold.texture:SetAllPoints(passiveFrame.threshold)
        passiveFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.mindbender, true))
        passiveFrame.threshold:SetFrameStrata(TRB.Data.settings.core.strata.level)
        passiveFrame.threshold:SetFrameLevel(127)
        passiveFrame.threshold:Show()
        
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
		local a, b, c, a1, b1, c1
		local match = false
		a, a1 = string.find(input, "#", p)
		b, b1 = string.find(input, "%$", p)
		c, c1 = string.find(input, "|", p)
		d, d1 = string.find(input, "%%", p)
		if a ~= nil and (b == nil or a < b) and (c == nil or a < c) and (d == nil or a < d) then
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
			returnText = returnText .. string.sub(input, p+1, p+1)
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
        inputText.text = string.format(cache.stringFormat, unpack(mapping))
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

local function UpdateResourceBar(settings)    
    if settings ~= nil and settings.bar ~= nil then
        local leftTextFrame = TRB.Frames.leftTextFrame
        local middleTextFrame = TRB.Frames.middleTextFrame
        local rightTextFrame = TRB.Frames.rightTextFrame
        
        local leftText, middleText, rightText = TRB.Data.BarText()
        
        if not pcall(TRB.Functions.TryUpdateText, leftTextFrame, leftText) then
            TRB.Frames.leftTextFrame.font:SetFont("Fonts\\FRIZQT__.TTF", settings.displayText.left.fontSize, "OUTLINE")
        end

        if not pcall(TRB.Functions.TryUpdateText, middleTextFrame, middleText) then
            TRB.Frames.middleTextFrame.font:SetFont("Fonts\\FRIZQT__.TTF", settings.displayText.middle.fontSize, "OUTLINE")
        end

        if not pcall(TRB.Functions.TryUpdateText, rightTextFrame, rightText) then
            TRB.Frames.rightTextFrame.font:SetFont("Fonts\\FRIZQT__.TTF", settings.displayText.right.fontSize, "OUTLINE")
        end
    end
end
TRB.Functions.UpdateResourceBar = UpdateResourceBar

local function RemoveInvalidVariablesFromBarText(input)
    --1         11                       36     43
    --v         v                        v      v
    --a         b                        c      d
    --{$liStacks}[$liStacks - $liTime sec][No LI]
    local returnText = ""
    local p = 0
    while p < string.len(input) do
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
	for i = 1, 40 do
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
	for i = 1, 40 do
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
	for i = 1, 40 do
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

	for i = 1, 40 do
		local unitSpellId = select(10, UnitDebuff(onWhom, i))
		if not unitSpellId then
			return
		elseif spellId == unitSpellId then
			return UnitDebuff(onWhom, i)
		end
	end
end
TRB.Functions.FindDebuffById = FindDebuffById

local function CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
    TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Functions.FillSpellData()
	TRB.Frames.resourceFrame:SetMinMaxValues(0, TRB.Data.character.maxResource)
	TRB.Frames.castingFrame:SetMinMaxValues(0, TRB.Data.character.maxResource)	
	TRB.Frames.passiveFrame:SetMinMaxValues(0, TRB.Data.character.maxResource)	
end
TRB.Functions.CheckCharacter = CheckCharacter

local function UpdateSnapshot()	    
	TRB.Data.snapshotData.resource = UnitPower("player", TRB.Data.resource)
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