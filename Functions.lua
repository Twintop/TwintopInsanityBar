local _, TRB = ...
TRB.Functions = TRB.Functions or {}

-- Generic Frame Functions

local function TryUpdateText(frame, text)
	frame.font:SetText(text)
end
TRB.Functions.TryUpdateText = TryUpdateText

local function PulseFrame(frame, alphaOffset, flashPeriod)
	frame:SetAlpha(((1.0 - alphaOffset) * math.abs(math.sin(2 * (GetTime()/flashPeriod)))) + alphaOffset)
end
TRB.Functions.PulseFrame = PulseFrame

-- Color Functions


-- Casting, Time, and GCD Functions

local function GetCurrentGCDLockRemaining()
---@diagnostic disable-next-line: redundant-parameter
	local startTime, duration, _ = GetSpellCooldown(61304);
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



local function FillSpellData(spells)
	if spells == nil then
		spells = TRB.Data.spells
	end

	local toc = select(4, GetBuildInfo())

	for k, v in pairs(spells) do
		if spells[k] ~= nil and (spells[k]["tocMinVersion"] == nil or toc >= spells[k]["tocMinVersion"]) then
			if spells[k]["itemId"] ~= nil and spells[k]["useSpellIcon"] ~= true then
				local _, name, icon
				name, _, _, _, _, _, _, _, _, icon = GetItemInfo(spells[k]["itemId"])
				if name ~= nil then
					spells[k]["name"] = name
				end

				if spells[k]["iconName"] ~= nil then
					icon = "Interface\\Icons\\" .. spells[k]["iconName"]
				end
				
				if icon ~= nil then
					spells[k]["icon"] = string.format("|T%s:0|t", icon)
					spells[k]["texture"] = icon
				end
			elseif spells[k]["id"] ~= nil or (spells[k]["spellId"] ~= nil and spells[k]["useSpellIcon"] == true) then
				local _, name, icon
				if spells[k]["spellId"] ~= nil and spells[k]["useSpellIcon"] == true then
					name, _, icon = GetSpellInfo(spells[k]["spellId"])
				else
					name, _, icon = GetSpellInfo(spells[k]["id"])
				end
				
				if spells[k]["iconName"] ~= nil then
					icon = "Interface\\Icons\\" .. spells[k]["iconName"]
				end

				spells[k]["icon"] = string.format("|T%s:0|t", icon)
				spells[k]["name"] = name

				if spells[k]["thresholdId"] ~= nil then
					spells[k]["texture"] = icon
				end
			end
		end
	end

	spells = TRB.Functions.FillSpellDataManaCost(spells)

	return spells
end
TRB.Functions.FillSpellData = FillSpellData

local function GetSpellManaCost(spellId)
---@diagnostic disable-next-line: redundant-parameter
	local spc = GetSpellPowerCost(spellId)
	local length = TRB.Functions.Table:Length(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["cost"] > 0 then
			return spc[x]["cost"]
		end
	end
	return 0
end
TRB.Functions.GetSpellManaCost = GetSpellManaCost

local function GetSpellManaCostPerSecond(spellId)
---@diagnostic disable-next-line: redundant-parameter
	local spc = GetSpellPowerCost(spellId)
	local length = TRB.Functions.Table:Length(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["costPerSec"] > 0 then
			return spc[x]["costPerSec"]
		end
	end
	return 0
end
TRB.Functions.GetSpellManaCostPerSecond = GetSpellManaCostPerSecond

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
		hasteRating = 0,
		critRating = 0,
		masteryRating = 0,
		versatilityRating = 0,
		intellect = 0,
		strength = 0,
		agility = 0,
		stamina = 0,
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
	TRB.Data.talents = cache.talents
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values

	TRB.Functions.ResetSnapshotData()
	TRB.Data.snapshotData = TRB.Functions.Table:Merge(TRB.Data.snapshotData, cache.snapshotData)

---@diagnostic disable-next-line: missing-parameter
	TRB.Data.character.specGroup = GetActiveSpecGroup()
end
TRB.Functions.LoadFromSpecCache = LoadFromSpecCache

local function FillSpecCacheSettings(settings, cache, className, specName)
	local specCache = cache[specName]
	local core = settings.core
	local s = core.globalSettings[className][specName]
	local enabled = (core.globalSettings.globalEnable or s.specEnable) and specCache.settings ~= nil
	local spec = settings[className][specName]

	if enabled and s.bar then
		specCache.settings.bar = core.bar
		--print("bar!")
	else
		--print("no bar :(")
		specCache.settings.bar = spec.bar
	end

	if enabled and s.comboPoints then
		specCache.settings.comboPoints = core.comboPoints
	else
		specCache.settings.comboPoints = spec.comboPoints
	end

	if enabled and s.displayBar then
		specCache.settings.displayBar = core.displayBar
	else
		specCache.settings.displayBar = spec.displayBar
	end

	if enabled and s.font then
		specCache.settings.displayText = core.font
	else
		specCache.settings.displayText = spec.displayText
	end

	if enabled and s.textures then
		specCache.settings.textures = core.textures
	else
		specCache.settings.textures = spec.textures
	end

	if enabled and s.thresholds then
		specCache.settings.thresholds = core.thresholds
	else
		specCache.settings.thresholds = spec.thresholds
	end

	specCache.settings.colors = spec.colors
end
TRB.Functions.FillSpecCacheSettings = FillSpecCacheSettings

local function GetSpellRemainingTime(snapshotSpell, leeway)
	-- For snapshotData objects that contain .isActive or .endTime
	local currentTime = GetTime()
	local remainingTime = 0
	local endTime = nil

	if snapshotSpell == nil then
		return remainingTime
	end
	
	if leeway and snapshotSpell.endTimeLeeway ~= nil then
		endTime = snapshotSpell.endTimeLeeway
	else
		endTime = snapshotSpell.endTime
	end

	if endTime ~= nil and (snapshotSpell.isActive or endTime > currentTime) then
		remainingTime = endTime - currentTime
	elseif snapshotSpell.startTime ~= nil and snapshotSpell.duration ~= nil and snapshotSpell.duration > 0 then
		remainingTime = snapshotSpell.duration - (currentTime - snapshotSpell.startTime)
	end

	if remainingTime < 0 then
		remainingTime = 0
	end

	return remainingTime
end
TRB.Functions.GetSpellRemainingTime = GetSpellRemainingTime

-- Bar Manipulation Functions

local function SetThresholdIconSizeAndPosition(settings, thresholdLine)
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
TRB.Functions.SetThresholdIconSizeAndPosition = SetThresholdIconSizeAndPosition

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
	if TRB.Functions.Number:IsNumeric(xOfs) and TRB.Functions.Number:IsNumeric(yOfs) then
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
		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].horizontal.EditBox:SetText(TRB.Functions.Number:RoundTo(xOfs, 0))
		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical:SetValue(yOfs)
		TRB.Frames.interfaceSettingsFrameContainer.controls[TRB.Data.character.specName].vertical.EditBox:SetText(TRB.Functions.Number:RoundTo(yOfs, 0))
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
	--[[
		Threshold StrataFrameLevel info, decreasing:
		- Starts at 1200 for unusable
		- Starts at 1400 for not enough resources
		- Starts at 1600 for usable
		- Counter increments by 3 on every render in modules that source threshold data from the spell table
		- Threshold Line Frame is X-2, Icon Frame Level is X-1, Cooldown Frame Level is X, for X = Counter
		Example:
		Threshold doesn't have enough resources and is the 4th threshold processed.
		Counter = 9 (seen 3).
		Line = 1389, Icon = 1390, Cooldown = 1391

		This is done to maintain backward compatability for how threshold line stacking used to work before this change.
	]]
	local borderSubtraction = 0

	if not settings.thresholds.overlapBorder then
		borderSubtraction = settings.bar.border * 2
	end

	threshold:SetWidth(settings.thresholds.width)
	threshold:SetHeight(settings.bar.height - borderSubtraction)
	threshold.texture = threshold.texture or threshold:CreateTexture(nil, "OVERLAY")
	threshold.texture:SetAllPoints(threshold)
	threshold.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settings.colors.threshold.under, true))
	threshold:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetLine)
	threshold:Hide()
	
	if hasIcon == true then
		threshold.icon = threshold.icon or CreateFrame("Frame", nil, threshold, "BackdropTemplate")
		threshold.icon:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
		threshold.icon:SetFrameStrata(TRB.Data.settings.core.strata.level)
		threshold.icon.texture = threshold.icon.texture or threshold.icon:CreateTexture(nil, "BACKGROUND")
---@diagnostic disable-next-line: param-type-mismatch
		threshold.icon.texture:SetAllPoints(threshold.icon)
---@diagnostic disable-next-line: param-type-mismatch
		threshold.icon.cooldown = threshold.icon.cooldown or CreateFrame("Cooldown", nil, threshold.icon, "CooldownFrameTemplate")
---@diagnostic disable-next-line: param-type-mismatch
		threshold.icon.cooldown:SetAllPoints(threshold.icon)
		threshold.icon.cooldown:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
		threshold.icon.cooldown:SetFrameStrata(TRB.Data.settings.core.strata.level)

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
			TRB.Functions.SetThresholdIconSizeAndPosition(settings, threshold)
		else
			threshold.icon:Hide()
		end
	end
end
TRB.Functions.ResetThresholdLine = ResetThresholdLine

local function RedrawThresholdLines(settings)
	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame

	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			TRB.Functions.ResetThresholdLine(resourceFrame.thresholds[x], settings, true)
		end
	end

	entries = TRB.Functions.Table:Length(passiveFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			TRB.Functions.ResetThresholdLine(passiveFrame.thresholds[x], settings, false)
			passiveFrame.thresholds[x].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settings.colors.threshold.mindbender, true))
		end
	end

	TRB.Frames.resourceFrame = resourceFrame
	TRB.Frames.passiveFrame = passiveFrame
end
TRB.Functions.RedrawThresholdLines = RedrawThresholdLines

local function AdjustThresholdDisplay(spell, threshold, showThreshold, currentFrameLevel, pairOffset, thresholdColor, snapshotData, settings)
	if settings.thresholds[spell.settingKey].enabled and showThreshold then
		local currentTime = GetTime()
		local frameLevel = currentFrameLevel
		local outOfRange = settings.thresholds.outOfRange == true and UnitAffectingCombat("player") and IsSpellInRange(spell.name, "target") == 0

		if outOfRange then
			thresholdColor = settings.colors.threshold.outOfRange
			frameLevel = TRB.Data.constants.frameLevels.thresholdOutOfRange
		end

		if not spell.hasCooldown then
			frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
		end

		threshold:Show()
		threshold:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
		threshold.icon:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
		threshold.icon.cooldown:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
---@diagnostic disable-next-line: undefined-field
		threshold.texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
		threshold.icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(thresholdColor, true))
		if currentFrameLevel >= TRB.Data.constants.frameLevels.thresholdOver then
			spell.thresholdUsable = true
		else
			spell.thresholdUsable = false
		end

		if settings.thresholds.icons.desaturated == true then
			threshold.icon.texture:SetDesaturated(not spell.thresholdUsable or outOfRange)
		end
		
		if settings.thresholds.icons.showCooldown and spell.hasCooldown and snapshotData.startTime ~= nil and currentTime < (snapshotData.startTime + snapshotData.duration) and (snapshotData.maxCharges == nil or snapshotData.charges < snapshotData.maxCharges) then
			threshold.icon.cooldown:SetCooldown(snapshotData.startTime, snapshotData.duration)
		else
			threshold.icon.cooldown:SetCooldown(0, 0)
		end
	else
		threshold:Hide()
		spell.thresholdUsable = false
	end
end
TRB.Functions.AdjustThresholdDisplay = AdjustThresholdDisplay

local function ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, potionSnapshot, conjuredChillglobeSnapshot, character, resourceFrame, calculateManaGainFunction)
	local currentTime = GetTime()
	local potionCooldownThreshold = 0
	local potionThresholdColor = specSettings.colors.threshold.over
	if potionSnapshot.onCooldown then
		if specSettings.thresholds.potionCooldown.enabled then
			if specSettings.thresholds.potionCooldown.mode == "gcd" then
				local gcd = TRB.Functions.GetCurrentGCDTime()
				potionCooldownThreshold = gcd * specSettings.thresholds.potionCooldown.gcdsMax
			elseif specSettings.thresholds.potionCooldown.mode == "time" then
				potionCooldownThreshold = specSettings.thresholds.potionCooldown.timeMax
			end
		end
	end

	if not potionSnapshot.onCooldown or (potionCooldownThreshold > math.abs(potionSnapshot.startTime + potionSnapshot.duration - currentTime))then
		if potionSnapshot.onCooldown then
			potionThresholdColor = specSettings.colors.threshold.unusable
		end
		local ampr1Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank1.mana, true)
		if specSettings.thresholds.aeratedManaPotionRank1.enabled and (castingBarValue + ampr1Total) < character.maxResource then
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[1], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr1Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[1]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[1].icon.cooldown:SetCooldown(potionSnapshot.startTime, potionSnapshot.duration)
			else
				resourceFrame.thresholds[1].icon.cooldown:SetCooldown(0, 0)
			end			
		else
			resourceFrame.thresholds[1]:Hide()
		end
		
		local ampr2Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank2.mana, true)
		if specSettings.thresholds.aeratedManaPotionRank2.enabled and (castingBarValue + ampr2Total) < character.maxResource then
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[2], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr2Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[2]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[2].icon.cooldown:SetCooldown(potionSnapshot.startTime, potionSnapshot.duration)
			else
				resourceFrame.thresholds[2].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[2]:Hide()
		end
		
		local ampr3Total = calculateManaGainFunction(character.items.potions.aeratedManaPotionRank3.mana, true)
		if specSettings.thresholds.aeratedManaPotionRank3.enabled and (castingBarValue + ampr3Total) < character.maxResource then
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[3], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr3Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[3]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[3].icon.cooldown:SetCooldown(potionSnapshot.startTime, potionSnapshot.duration)
			else
				resourceFrame.thresholds[3].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[3]:Hide()
		end

		local poffr1Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank1.mana, true)
		if specSettings.thresholds.potionOfFrozenFocusRank1.enabled and (castingBarValue + poffr1Total) < character.maxResource then
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[4], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr1Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[4]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[4].icon.cooldown:SetCooldown(potionSnapshot.startTime, potionSnapshot.duration)
			else
				resourceFrame.thresholds[4].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[4]:Hide()
		end

		local poffr2Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank2.mana, true)
		if specSettings.thresholds.potionOfFrozenFocusRank2.enabled and (castingBarValue + poffr2Total) < character.maxResource then
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[5], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr2Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[5].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[5]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[5].icon.cooldown:SetCooldown(potionSnapshot.startTime, potionSnapshot.duration)
			else
				resourceFrame.thresholds[5].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[5]:Hide()
		end

		local poffr3Total = calculateManaGainFunction(character.items.potions.potionOfFrozenFocusRank3.mana, true)
		if specSettings.thresholds.potionOfFrozenFocusRank3.enabled and (castingBarValue + poffr3Total) < character.maxResource then
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[6], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr3Total), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[6].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[6].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[6]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[6].icon.cooldown:SetCooldown(potionSnapshot.startTime, potionSnapshot.duration)
			else
				resourceFrame.thresholds[6].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[6]:Hide()
		end
		
		local toggle = specSettings.thresholds.icons.desaturated and potionSnapshot.onCooldown
		resourceFrame.thresholds[1].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[2].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[3].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[4].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[5].icon.texture:SetDesaturated(toggle)
		resourceFrame.thresholds[6].icon.texture:SetDesaturated(toggle)
	else
		resourceFrame.thresholds[1]:Hide()
		resourceFrame.thresholds[2]:Hide()
		resourceFrame.thresholds[3]:Hide()
		resourceFrame.thresholds[4]:Hide()
		resourceFrame.thresholds[5]:Hide()
		resourceFrame.thresholds[6]:Hide()
	end
	
	if character.items.conjuredChillglobe.isEquipped and (currentMana / character.maxResource) < character.items.conjuredChillglobe.manaThresholdPercent then
		local conjuredChillglobeTotal = calculateManaGainFunction(character.items.conjuredChillglobe[character.items.conjuredChillglobe.equippedVersion].mana, true)
		if specSettings.thresholds.conjuredChillglobe.enabled and (castingBarValue + conjuredChillglobeTotal) < character.maxResource then
			if conjuredChillglobeSnapshot.onCooldown then
				potionThresholdColor = specSettings.colors.threshold.unusable
			end
			TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[7], resourceFrame, specSettings.thresholds.width, (castingBarValue + conjuredChillglobeTotal), character.maxResource)
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[7].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
			resourceFrame.thresholds[7].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(potionThresholdColor, true))
			resourceFrame.thresholds[7]:Show()
				
			if specSettings.thresholds.icons.showCooldown then
				resourceFrame.thresholds[7].icon.cooldown:SetCooldown(conjuredChillglobeSnapshot.startTime, conjuredChillglobeSnapshot.duration)
			else
				resourceFrame.thresholds[7].icon.cooldown:SetCooldown(0, 0)
			end
		else
			resourceFrame.thresholds[7]:Hide()
		end
	else
		resourceFrame.thresholds[7]:Hide()
	end
end
TRB.Functions.ManageCommonHealerThresholds = ManageCommonHealerThresholds

local function IsComboPointUser()
	local _, _, classIndexId = UnitClass("player")
	local specId = GetSpecialization()

	if 	(classIndexId == 4) or -- Rogue
		(classIndexId == 10 and specId == 3) or -- Windwalker Monk
		(classIndexId == 11 and specId == 2) or -- Feral Druid
		(classIndexId == 13) -- Evoker
		then
		return true
	end
	return false
end
TRB.Functions.IsComboPointUser = IsComboPointUser

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

        castingFrame:Show()
        castingFrame:SetMinMaxValues(0, settings.bar.width)
        castingFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        castingFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        castingFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        castingFrame:SetStatusBarTexture(settings.textures.castingBar)
        castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.bar.casting, true))
        castingFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
        castingFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barCasting)

        passiveFrame:Show()
        passiveFrame:SetMinMaxValues(0, settings.bar.width)
        passiveFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
        passiveFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
        passiveFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
        passiveFrame:SetStatusBarTexture(settings.textures.passiveBar)
        passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.bar.passive, true))
        passiveFrame:SetFrameStrata(TRB.Data.settings.core.strata.level)
		passiveFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barPassive)

		if TRB.Frames.resource2Frames ~= nil and settings.comboPoints ~= nil and IsComboPointUser() then
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
				
				container:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.comboPoints.background, true))
				container:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
				container:SetFrameStrata(TRB.Data.settings.core.strata.level)
				container:SetFrameLevel(TRB.Data.constants.frameLevels.cpContainer)
		
				border:ClearAllPoints()
				border:SetPoint("CENTER", container)
				border:SetPoint("CENTER", 0, 0)
				border:SetBackdropColor(0, 0, 0, 0)
				border:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.comboPoints.border, true))
				border:SetFrameStrata(TRB.Data.settings.core.strata.level)
				border:SetFrameLevel(TRB.Data.constants.frameLevels.cpBorder)
		
				resource:Show()
				resource:SetMinMaxValues(0, 1)
				resource:SetPoint("LEFT", container, "LEFT", 0, 0)
				resource:SetPoint("RIGHT", container, "RIGHT", 0, 0)
				resource:SetStatusBarTexture(settings.textures.comboPointsBar)
				resource:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.comboPoints.base, true))
				resource:SetFrameStrata(TRB.Data.settings.core.strata.level)
				resource:SetFrameLevel(TRB.Data.constants.frameLevels.cpContainer)
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
        leftTextFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
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
        middleTextFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
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
        rightTextFrame:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
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
	if settings == nil then
		return
	end

	if settings.bar.pinToPersonalResourceDisplay then
		TRB.Functions.RepositionBarForPRD(settings, containerFrame)
	else
		containerFrame:ClearAllPoints()
		containerFrame:SetPoint("CENTER", UIParent)
		containerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	end

	if TRB.Frames.resource2Frames ~= nil and settings.comboPoints ~= nil and IsComboPointUser() then
		local containerFrame2 = TRB.Frames.resource2ContainerFrame
		local length = TRB.Functions.Table:Length(TRB.Frames.resource2Frames)
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
				border:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(settings.colors.comboPoints.border, true))

				border:SetWidth(nodeWidth)
				border:SetHeight(settings.comboPoints.height)
				
				resource:SetHeight(settings.comboPoints.height-(settings.comboPoints.border*2))
			else
				container:Hide()
			end
		end
	end

	TRB.Functions.RedrawThresholdLines(settings)
end
TRB.Functions.RepositionBar = RepositionBar

local function TriggerResourceBarUpdates()
	--To be implemented in each class/spec module
end
TRB.Functions.TriggerResourceBarUpdates = TriggerResourceBarUpdates

-- Bar Text Functions

local function UpdateResourceBar(settings, refreshText)
	TRB.Functions.BarText:RefreshLookupDataBase(settings)
	TRB.Functions.RefreshLookupData()

	if refreshText then
		local leftText, middleText, rightText = TRB.Functions.BarText:BarText(settings)
		TRB.Functions.BarText:UpdateResourceBarText(settings, leftText, middleText, rightText)
	end
end
TRB.Functions.UpdateResourceBar = UpdateResourceBar

-- Character Functions


local function CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
---@diagnostic disable-next-line: missing-parameter
    TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Data.character.isPvp = TRB.Functions.Talent:ArePvpTalentsActive()

	TRB.Data.barTextCache = {}
	TRB.Functions.FillSpellData()
end
TRB.Functions.CheckCharacter = CheckCharacter

local function CheckCharacter_Class()
	--To be implemented in each class/spec module
end
TRB.Functions.CheckCharacter_Class = CheckCharacter_Class

local function UpdateSnapshot()
	local _
	TRB.Data.snapshotData.resource = UnitPower("player", TRB.Data.resource, true)

	if TRB.Data.resource2 ~= nil then
		TRB.Data.snapshotData.resource2 = UnitPower("player", TRB.Data.resource2, true)
	end

	TRB.Data.snapshotData.haste = UnitSpellHaste("player")
	TRB.Data.snapshotData.crit = GetCritChance()
	TRB.Data.snapshotData.mastery = GetMasteryEffect()
	TRB.Data.snapshotData.versatilityOffensive = GetCombatRatingBonus(29)
	TRB.Data.snapshotData.versatilityDefensive = GetCombatRatingBonus(31)

	TRB.Data.snapshotData.hasteRating = GetCombatRating(20)
	TRB.Data.snapshotData.critRating = GetCombatRating(11)
	TRB.Data.snapshotData.masteryRating = GetCombatRating(26)
	TRB.Data.snapshotData.versatilityRating = GetCombatRating(29)
	
---@diagnostic disable-next-line: assign-type-mismatch
	TRB.Data.snapshotData.strength, _, _, _ = UnitStat("player", 1)
	---@diagnostic disable-next-line: assign-type-mismatch
	TRB.Data.snapshotData.agility, _, _, _ = UnitStat("player", 2)
	---@diagnostic disable-next-line: assign-type-mismatch
	TRB.Data.snapshotData.stamina, _, _, _ = UnitStat("player", 3)
	---@diagnostic disable-next-line: assign-type-mismatch
	TRB.Data.snapshotData.intellect, _, _, _ = UnitStat("player", 4)

end
TRB.Functions.UpdateSnapshot = UpdateSnapshot

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