local addonVersion = "8.0.1.4"
local addonReleaseDate = "May 23, 2018"
local barContainerFrame = CreateFrame("Frame", nil, UIParent)
local insanityFrame = CreateFrame("StatusBar", nil, barContainerFrame)
local castingFrame = CreateFrame("StatusBar", nil, barContainerFrame)
local passiveFrame = CreateFrame("StatusBar", nil, barContainerFrame)
local barBorderFrame = CreateFrame("StatusBar", nil, barContainerFrame)

local leftTextFrame = CreateFrame("Frame", nil, barContainerFrame)
local middleTextFrame = CreateFrame("Frame", nil, barContainerFrame)
local rightTextFrame = CreateFrame("Frame", nil, barContainerFrame)

insanityFrame.threshold = CreateFrame("Frame", nil, insanityFrame)
passiveFrame.threshold = CreateFrame("Frame", nil, passiveFrame)
leftTextFrame.font = leftTextFrame:CreateFontString(nil, "BACKGROUND")
middleTextFrame.font = middleTextFrame:CreateFontString(nil, "BACKGROUND")
rightTextFrame.font = rightTextFrame:CreateFontString(nil, "BACKGROUND")

local asTimerFrame = CreateFrame("Frame")
asTimerFrame.sinceLastUpdate = 0

local timerFrame = CreateFrame("Frame")
timerFrame.sinceLastUpdate = 0
timerFrame.ttdSinceLastUpdate = 0

local combatFrame = CreateFrame("Frame")

local mindbenderAudioCueFrame = CreateFrame("Frame")
mindbenderAudioCueFrame.sinceLastPlay = 0
mindbenderAudioCueFrame.sinceLastUpdate = 0

local interfaceSettingsFrame = nil

local settings = nil

Global_TwintopInsanityBar = {
	ttd = 0,
	voidform = {
		stacks = 0,
		incomingStacks = 0,
		drainStacks = 0,
		drain = 0,
		drainTime = 0
	},
	lingeringInsanity = {
		timeLeft = 0,
		stacks = 0
	},
	insanity = {
		insanity = 0,
		casting = 0,
		passive = 0
	},
	auspiciousSpirits = {
		count = 0,
		insanity = 0
	},
	mindbender = {
		insanity = 0,
		gcds = 0,
		swings = 0,
		time = 0
	}
}

local characterData = {
	guid = UnitGUID("player"),
	maxInsanity = 100,
	voidformThreshold = 90,
	specGroup = GetActiveSpecGroup(),
	talents = {
		fotm = {
			isSelected = false,
			modifier = 1.2
		},
		lotv = {
			isSelected = false
		},
		as = {
			isSelected = false
		},
		mindbender = {
			isSelected = false
		}
	},
	items = {
		t20Pieces = 0
	}
}

local spells = {
	voidform = {
		id = 194249
	},
	voidTorrent = {
		--id = 205065
		id = 263165
	},
	dispersion = {
		id = 47585
	},
	s2m = {
		name = select(2, GetTalentInfo(7, 3, characterData.specGroup)),
		isActive = false,
		isDebuffActive = false,
		modifier = 2.0,
		modifierDebuff = 0.0,
		--id = 212570
		id = 193223,
		debuffId = 263406
	},
	darkVoid = {
		name = select(2, GetTalentInfo(3, 3, characterData.specGroup)),
		insanity = 30,
		id = 263346,
		fotm = false
	},
	vampiricTouch = {
		id = 34914,
		name = "",
		insanity = 6,
		fotm = false
	},
	mindBlast = {
		id = 8092,
		name = "",
		insanity = 12,
		fotm = true
	},
	shadowWordVoid = {
		id = 205351,
		name = "",
		insanity = 15,
		fotm = false
	},
	mindFlay = {
		id = 15407,
		name = "",
		insanity = 3,
		fotm = true
	},
	mindSear = {
		id = 48045,
		name = "",
		insanity = 3 * 1.25, --Need to figure out a better value here.
		fotm = false
	},
	shadowfiend = {
		id = 34433,
		name = "",
		insanity = 3
	},
	mindbender = {
		id = 34433,
		name = select(2, GetTalentInfo(6, 2, characterData.specGroup)),
		insanity = 6
	},
	lingeringInsanity = {
		id = 197937,
		name = ""
	},
	auspiciousSpirits = {
		idSpawn = 147193,
		idImpact = 148859,
		insanity = 2
	}
}

spells.mindBlast.name = select(1, GetSpellInfo(spells.mindBlast.id))
spells.mindFlay.name = select(1, GetSpellInfo(spells.mindFlay.id))
spells.mindSear.name = select(1, GetSpellInfo(spells.mindSear.id))
spells.shadowfiend.name = select(1, GetSpellInfo(spells.shadowfiend.id))
spells.shadowWordVoid.name = select(1, GetSpellInfo(spells.shadowWordVoid.id))
spells.vampiricTouch.name = select(1, GetSpellInfo(spells.vampiricTouch.id))
spells.lingeringInsanity.name = select(1, GetSpellInfo(spells.lingeringInsanity.id))

local snapshotData = {
	insanity = 0,
	haste = 0,
	target = {
		guid = nil,
		snapshot = {},
		ttd = 0,
		ttdIsActive = false
	},
	casting = {
		spellId = nil,
		startTime = nil,
		endTime = nil,
		insanityRaw = 0,
		insanityFinal = 0
	},
	voidform = {
		totalStacks = 0,
		drainStacks = 0,
		additionalStacks = 0,
		currentDrainRate = 0,
		duration = 0,
		spellId = nil,
		startTime = 0,
		previousStackTime = 0,
		remainingTime = 0,
		voidTorrent = {
			stacks = 0,
			startTime = nil
		},
		dispersion = {
			stacks = 0,
			startTime = nil
		},
		s2m = {
			startTime = nil,
			active = false
		}
	},
	auspiciousSpirits = {
		tracker = {},
		units = 0,
		total = 0
	},
	mindbender = {
		isActive = false,
		onCooldown = false,
		swingTime = 0,
		remaining = {
			swings = 0,
			gcds = 0,
			time = 0
		},
		insanityRaw = 0,
		insanityFinal = 0
	},
	lingeringInsanity = {
		stacksTotal = 0,
		stacksLast = 0,
		duration = 0,
		spellId = nil,
		lastTickTime = nil,
		timeLeftBase = 0
	}
}

local addonData = {
	loaded = false,
	registered = false
}

local function TableLength(T)
	local count = 0
	local _
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

local function FindBuffByName(spellName)
	for i = 1, 40 do
		local unitSpellName = UnitBuff("player", i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName then
			return UnitBuff("player", i)
		end
	end
end

local function FindBuffById(spellId)
	for i = 1, 40 do
		local unitSpellId = select(10, UnitBuff("player", i))
		if not unitSpellId then
			return
		elseif spellId == unitSpellId then
			return UnitBuff("player", i)
		end
	end
end

local function FindDebuffByName(spellName)
	for i = 1, 40 do
		local unitSpellName = UnitDebuff("player", i)
		if not unitSpellName then
			return
		elseif spellName == unitSpellName then
			return UnitDebuff("player", i)
		end
	end
end

local function FindDebuffById(spellId)
	for i = 1, 40 do
		local unitSpellId = select(10, UnitDebuff("player", i))
		if not unitSpellId then
			return
		elseif spellId == unitSpellId then
			print("Found", spellId)
			return UnitDebuff("player", i)
		end
	end
end


local function RoundTo(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function GetRGBAFromString(s, normalize)
    local _a = 1
    local _r = 0
    local _g = 1
    local _b = 0
    
    if not (s == nil) then        
        _a = tonumber(string.sub(s, 1, 2), 16)
        _r = tonumber(string.sub(s, 3, 4), 16)
        _g = tonumber(string.sub(s, 5, 6), 16)
        _b = tonumber(string.sub(s, 7, 8), 16)        
    end
    
	if normalize then
		return _r/255, _g/255, _b/255, _a/255
	else
		return _r, _g, _b, _a
	end
end

local function PulseFrame(frame)
	frame:SetAlpha(((1.0 - settings.colors.bar.flashAlpha) * math.abs(math.sin(2 * (GetTime()/settings.colors.bar.flashPeriod)))) + settings.colors.bar.flashAlpha)
end

local function GetCurrentGCDTime()
	local haste = UnitSpellHaste("player") / 100
	
	local gcd = 1.5 / (1 + haste)
	
	if gcd < 0.75 then		
		gcd = 0.75		
	end
	
	return gcd
end

local function LoadDefaultSettings()
	settings = {
		showSummary=false,
		showS2MSummary=true,
		hasteApproachingThreshold=135,
		hasteThreshold=140,
		hastePrecision=2,
		voidEruptionThreshold=true,
		auspiciousSpiritsTracker=true,
		ttd = {
			refreshRate = 0.2,
			maxEntries = 15
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true
		},
		bar = {		
			width=555,
			height=34,
			xPos=0,
			yPos=-200,
			border=4,
			dragAndDrop=false
		},
		mindbender={
			mode="gcd",
			swingsMax=4,
			gcdsMax=2,
			timeMax=3.0,
			enabled=true,
			useNotification = {
				enabled=false,
				useVoidformStacks=false, --If true, use VF stacks instead of Drain stacks
				thresholdStacks=10
			}
		},
		colors={
			text={
				currentInsanity="FFC2A3E0",
				castingInsanity="FFFFFFFF",
				passiveInsanity="FFDF00FF",		
				left="FFFFFFFF",
				middle="FFFFFFFF",
				right="FFFFFFFF",
				hasteBelow="FFFFFFFF",
				hasteApproaching="FFFFFF00",
				hasteAbove="FF00FF00"
			},
			bar={
				border="FF431863",
				background="66000000",
				base="FF763BAF",
				enterVoidform="FF5C2F89",
				--enterVoidformFlash="FFAA1863",
				inVoidform="FF431863",
				inVoidform2GCD="FFFFFF00",
				inVoidform1GCD="FFFF0000",
				casting="FFFFFFFF",
				passive="FFDF00FF",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true
			},
			threshold={
				under="FFFFFFFF",
				over="FF00FF00",
				mindbender="FFFF11FF"
			}
		},
		displayText={
			fontSizeLeft=18,
			fontSizeMiddle=18,
			fontSizeRight=18,
			fontSizeLock=true,
			fontFace="Fonts\\FRIZQT__.TTF",
			left={
				outVoidformText="$haste%",
				inVoidformText="$haste% - $vfStacks (+$vfIncoming) VF",
			},
			middle={
				outVoidformText="{$liStacks}[$liStacks LI - $liTime sec]",
				inVoidformText="$vfTime sec - $vfDrain/sec ",
			},
			right={
				outVoidformText="{$casting}[$casting + ]{$passive}[$passive + ]$insanity%",
				inVoidformText="{$casting}[$casting + ]{$passive}[$passive + ]$insanity%",
			}
		},
		audio={
			s2mDeath={
				enabled=true,
				sound="Interface\\Addons\\TwintopInsanityBar\\wilhelm.ogg"
			},
			mindbender={
				sound="Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg"
			}
		},
		textures={
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			border="Interface\\Tooltips\\UI-Tooltip-Border",
			bar="Interface\\TargetingFrame\\UI-StatusBar"
		}
	}
end

local function MergeSettings(settings, user)
	for k, v in pairs(user) do
        if (type(v) == "table") and (type(settings[k] or false) == "table") then
            MergeSettings(settings[k], user[k])
        else
            settings[k] = v
        end
    end
    return settings
end

local function RepositionInsanityFrameThreshold()
	insanityFrame.threshold:SetPoint("CENTER", insanityFrame, "LEFT", ((settings.bar.width-(settings.bar.border*2)) * (characterData.voidformThreshold / characterData.maxInsanity)), 0)
end

local function CheckCharacter()
	characterData.guid = UnitGUID("player")
	characterData.maxInsanity = UnitPowerMax("player", SPELL_POWER_INSANITY)
	characterData.specGroup = GetActiveSpecGroup()
	characterData.talents.fotm.isSelected = select(4, GetTalentInfo(1, 1, characterData.specGroup))
	characterData.talents.lotv.isSelected = select(4, GetTalentInfo(7, 1, characterData.specGroup))
	characterData.talents.as.isSelected = select(4, GetTalentInfo(5, 1, characterData.specGroup))
	characterData.talents.mindbender.isSelected = select(4, GetTalentInfo(6, 2, characterData.specGroup))
		
	spells.s2m.name = select(2, GetTalentInfo(7, 3, characterData.specGroup))
	spells.mindbender.name = select(2, GetTalentInfo(6, 3, characterData.specGroup))
	spells.darkVoid.name = select(2, GetTalentInfo(3, 3, characterData.specGroup))

	insanityFrame:SetMinMaxValues(0, characterData.maxInsanity)
	castingFrame:SetMinMaxValues(0, characterData.maxInsanity)	
	passiveFrame:SetMinMaxValues(0, characterData.maxInsanity)	
		
	if characterData.talents.lotv.isSelected then
		characterData.voidformThreshold = 60
	else
		characterData.voidformThreshold = 90
	end
	
	if characterData.voidformThreshold < characterData.maxInsanity then
		insanityFrame.threshold:Show()
		RepositionInsanityFrameThreshold()
	else
		insanityFrame.threshold:Hide()
	end
	
	local t20Head = 0
	if IsEquippedItem(147165) then
		t20Head = 1
	end
	
	local t20Shoulder = 0
	if IsEquippedItem(147168) then
		t20Shoulder = 1
	end
	
	local t20Back = 0
	if IsEquippedItem(147163) then
		t20Back = 1
	end
	
	local t20Chest = 0
	if IsEquippedItem(147167) then
		t20Chest = 1
	end
	
	local t20Hands = 0
	if IsEquippedItem(147164) then
		t20Hands = 1
	end
	
	local t20Legs = 0
	if IsEquippedItem(147166) then
		t20Legs = 1
	end
	
	characterData.items.t20Pieces = t20Head + t20Shoulder + t20Back + t20Chest + t20Hands + t20Legs
end

local function EventRegistration()
	if GetSpecialization() == 3 then
		CheckCharacter()
		
		if settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected then
			asTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) asTimerFrame:onUpdate(sinceLastUpdate) end)
		else
			asTimerFrame:SetScript("OnUpdate", nil)
		end
		
		if settings.mindbender.useNotification.enabled then
			mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate) end)
		else
			mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
		end
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
		barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		addonData.registered = true
	else
		asTimerFrame:SetScript("OnUpdate", nil)
		mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)			
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		addonData.registered = false			
		barContainerFrame:Hide()
	end	
end

local function IsTtdActive()
	if string.find(settings.displayText.left.outVoidformText, "$ttd") or
		string.find(settings.displayText.left.inVoidformText, "$ttd") or
		string.find(settings.displayText.middle.outVoidformText, "$ttd") or
		string.find(settings.displayText.middle.inVoidformText, "$ttd") or
		string.find(settings.displayText.right.outVoidformText, "$ttd") or
		string.find(settings.displayText.right.inVoidformText, "$ttd") then
		snapshotData.target.ttdIsActive = true
	else
		snapshotData.target.ttdIsActive = false
	end
end

local function ShowInsanityBar()
	if addonData.registered == false then
		EventRegistration()
	end

	barContainerFrame:Show()
end

local function HideInsanityBar()
	local affectingCombat = UnitAffectingCombat("player")

	if (not affectingCombat) and (
		(not settings.displayBar.alwaysShow) and (
			(not settings.displayBar.notZeroShow) or
			(settings.displayBar.notZeroShow and snapshotData.insanity == 0))) then
		barContainerFrame:Hide()	
	else
		barContainerFrame:Show()	
	end
end

local function CaptureBarPosition()
	local point, relativeTo, relativePoint, xOfs, yOfs = barContainerFrame:GetPoint()
	local maxWidth = math.floor(GetScreenWidth())
	local maxHeight = math.floor(GetScreenHeight())

	if relativePoint == "CENTER" then
		--No action needed.
	elseif relativePoint == "TOP" then
		yOfs = ((maxHeight/2) + yOfs - (settings.bar.height/2))
	elseif relativePoint == "TOPRIGHT" then
		xOfs = ((maxWidth/2) + xOfs - (settings.bar.width/2))
		yOfs = ((maxHeight/2) + yOfs - (settings.bar.height/2))
	elseif relativePoint == "RIGHT" then
		xOfs = ((maxWidth/2) + xOfs - (settings.bar.width/2))
	elseif relativePoint == "BOTTOMRIGHT" then
		xOfs = ((maxWidth/2) + xOfs - (settings.bar.width/2))
		yOfs = -((maxHeight/2) - yOfs - (settings.bar.height/2))
	elseif relativePoint == "BOTTOM" then
		yOfs = -((maxHeight/2) - yOfs - (settings.bar.height/2))
	elseif relativePoint == "BOTTOMLEFT" then
		xOfs = -((maxWidth/2) - xOfs - (settings.bar.width/2))
		yOfs = -((maxHeight/2) - yOfs - (settings.bar.height/2))
	elseif relativePoint == "LEFT" then				
		xOfs = -((maxWidth/2) - xOfs - (settings.bar.width/2))
	elseif relativePoint == "TOPLEFT" then
		xOfs = -((maxWidth/2) - xOfs - (settings.bar.width/2))
		yOfs = ((maxHeight/2) + yOfs - (settings.bar.height/2))
	end
				
	interfaceSettingsFrame.controls.horizontal:SetValue(xOfs)
	interfaceSettingsFrame.controls.horizontal.EditBox:SetText(RoundTo(xOfs, 0))
	interfaceSettingsFrame.controls.vertical:SetValue(yOfs)
	interfaceSettingsFrame.controls.vertical.EditBox:SetText(RoundTo(yOfs, 0))	
end

local function ConstructInsanityBar()
	barContainerFrame:Show()
	barContainerFrame:SetBackdrop({ bgFile = settings.textures.background,									
									tile = true,
									tileSize=8,
									edgeSize=0,
									insets = {0, 0, 0, 0}
									})
	barContainerFrame:ClearAllPoints()
	barContainerFrame:SetPoint("CENTER", UIParent)
	barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	barContainerFrame:SetBackdropColor(GetRGBAFromString(settings.colors.bar.background, true))
	barContainerFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
	barContainerFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
	barContainerFrame:SetFrameStrata("BACKGROUND")
	barContainerFrame:SetFrameLevel(0)
	
	barContainerFrame:SetMovable(settings.bar.dragAndDrop)
	barContainerFrame:EnableMouse(settings.bar.dragAndDrop)

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

	barContainerFrame:SetScript("OnHide", function(self)
		if self.isMoving then
			self:StopMovingOrSizing()
			CaptureBarPosition()
			self.isMoving = false
		end
	end)
	
	barBorderFrame:Show()
	if settings.bar.border < 1 then
		barBorderFrame:SetBackdrop({ })
	else
		barBorderFrame:SetBackdrop({ edgeFile = settings.textures.border,
									tile = true,
									tileSize=4,
									edgeSize=settings.bar.border*4,								
									insets = {0, 0, 0, 0}
									})
	end
	barBorderFrame:ClearAllPoints()
	barBorderFrame:SetPoint("CENTER", barContainerFrame)
	barBorderFrame:SetPoint("CENTER", 0, 0)
	barBorderFrame:SetBackdropColor(0, 0, 0, 0)
	barBorderFrame:SetBackdropBorderColor(GetRGBAFromString(settings.colors.bar.border, true))
	barBorderFrame:SetWidth(settings.bar.width)
	barBorderFrame:SetHeight(settings.bar.height)
	barBorderFrame:SetFrameStrata("BACKGROUND")
	barBorderFrame:SetFrameLevel(129)

	insanityFrame:Show()
	insanityFrame:SetMinMaxValues(0, 100)
	insanityFrame:SetHeight(settings.bar.height-(settings.bar.border*2))	
	insanityFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
	insanityFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
	insanityFrame:SetStatusBarTexture(settings.textures.bar)
	insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base))
	insanityFrame:SetFrameStrata("BACKGROUND")
	insanityFrame:SetFrameLevel(100)
	
	insanityFrame.threshold:SetWidth(2)
	insanityFrame.threshold:SetHeight(settings.bar.height-(settings.bar.border*2))
	insanityFrame.threshold.texture = insanityFrame.threshold:CreateTexture(nil, "BACKGROUND")
	insanityFrame.threshold.texture:SetAllPoints(insanityFrame.threshold)
	insanityFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.under, true))
	insanityFrame.threshold:SetFrameStrata("BACKGROUND")
	insanityFrame.threshold:SetFrameLevel(129)
	insanityFrame.threshold:Show()
	
	castingFrame:Show()
	castingFrame:SetMinMaxValues(0, 100)
	castingFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
	castingFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
	castingFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
	castingFrame:SetStatusBarTexture(settings.textures.bar)
	castingFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.casting))
	castingFrame:SetFrameStrata("BACKGROUND")
	castingFrame:SetFrameLevel(90)
	
	passiveFrame:Show()
	passiveFrame:SetMinMaxValues(0, 100)
	passiveFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
	passiveFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 0, 0)
	passiveFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
	passiveFrame:SetStatusBarTexture(settings.textures.bar)
	passiveFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.passive))
	passiveFrame:SetFrameStrata("BACKGROUND")
	passiveFrame:SetFrameLevel(80)
	
	passiveFrame.threshold:SetWidth(2)
	passiveFrame.threshold:SetHeight(settings.bar.height-(settings.bar.border*2))
	passiveFrame.threshold.texture = passiveFrame.threshold:CreateTexture(nil, "BACKGROUND")
	passiveFrame.threshold.texture:SetAllPoints(passiveFrame.threshold)
	passiveFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.mindbender, true))
	passiveFrame.threshold:SetFrameStrata("BACKGROUND")
	passiveFrame.threshold:SetFrameLevel(129)
	passiveFrame.threshold:Show()
	
	leftTextFrame:Show()
	leftTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2)-2)
	leftTextFrame:SetHeight(settings.bar.height * 3.5)
	leftTextFrame:SetPoint("LEFT", barContainerFrame, "LEFT", 2, 0)
	leftTextFrame:SetFrameStrata("BACKGROUND")
	leftTextFrame:SetFrameLevel(128)
	leftTextFrame.font:SetPoint("LEFT", 0, 0)
	leftTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
	leftTextFrame.font:SetJustifyH("LEFT")
	leftTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSizeLeft, "OUTLINE")
	leftTextFrame.font:Show()
	
	middleTextFrame:Show()
	middleTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
	middleTextFrame:SetHeight(settings.bar.height * 3.5)
	middleTextFrame:SetPoint("CENTER", barContainerFrame, "CENTER", 0, 0)
	middleTextFrame:SetFrameStrata("BACKGROUND")
	middleTextFrame:SetFrameLevel(128)
	middleTextFrame.font:SetPoint("CENTER", 0, 0)
	middleTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
	middleTextFrame.font:SetJustifyH("CENTER")
	middleTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSizeMiddle, "OUTLINE")
	middleTextFrame.font:Show()
	
	rightTextFrame:Show()
	rightTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
	rightTextFrame:SetHeight(settings.bar.height * 3.5)
	rightTextFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", 0, 0)
	rightTextFrame:SetFrameStrata("BACKGROUND")
	rightTextFrame:SetFrameLevel(128)
	rightTextFrame.font:SetPoint("RIGHT", 0, 0)
	rightTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0)
	rightTextFrame.font:SetJustifyH("RIGHT")
	rightTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSizeRight, "OUTLINE")
	rightTextFrame.font:Show()
end

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18
local function BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent)
	f.EditBox = CreateFrame("EditBox", nil, f)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetMinMaxValues(minValue, maxValue)
	f:SetValueStep(stepValue)
	f:SetSize(sizeX, sizeY)
    f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
    f:SetOrientation("Horizontal")
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true,
        edgeSize = 8,
        tileSize = 8,
        insets = {left = 3, right = 3, top = 6, bottom = 6}
    })
    f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
    f:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 1, 1, 1)
    end)
	f:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
    end)
    f:SetScript("OnMouseWheel", function(self, delta)
        if delta > 0 then
            self:SetValue(self:GetValue() + self:GetValueStep())
        else
            self:SetValue(self:GetValue() - self:GetValueStep())
        end
    end)
    f:SetScript("OnValueChanged", function(self, value)
		self.EditBox:SetText(value)
	end)	
    f.MinLabel = f:CreateFontString(nil, "Overlay")
    f.MinLabel:SetFontObject(GameFontHighlightSmall)
    f.MinLabel:SetSize(0, 14)
    f.MinLabel:SetWordWrap(false)
    f.MinLabel:SetPoint("TopLeft", f, "BottomLeft", 0, -1)
    f.MinLabel:SetText(minValue)
    f.MaxLabel = f:CreateFontString(nil, "Overlay")
    f.MaxLabel:SetFontObject(GameFontHighlightSmall)
    f.MaxLabel:SetSize(0, 14)
    f.MaxLabel:SetWordWrap(false)
    f.MaxLabel:SetPoint("TopRight", f, "BottomRight", 0, -1)
    f.MaxLabel:SetText(maxValue)
    f.Title = f:CreateFontString(nil, "Overlay")
    f.Title:SetFontObject(GameFontNormal)
    f.Title:SetSize(0, 14)
    f.Title:SetWordWrap(false)
    f.Title:SetPoint("Bottom", f, "Top")
    f.Title:SetText(title)
    f.Thumb = f:CreateTexture(nil, "Artwork")
    f.Thumb:SetSize(32, 32)
    f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
    eb:EnableMouseWheel(true)
    eb:SetAutoFocus(false)
    eb:SetNumeric(false)
    eb:SetJustifyH("Center")
    eb:SetFontObject(GameFontHighlightSmall)
    eb:SetSize(50, 14)
    eb:SetPoint("Top", f, "Bottom", 0, -1)
    eb:SetTextInsets(4, 4, 0, 0)
    eb:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        edgeSize = 1,
        tileSize = 5
    })
    eb:SetBackdropColor(0, 0, 0, 1)
    eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    eb:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
    end)
    eb:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    end)
    eb:SetScript("OnMouseWheel", function(self, delta)
        if delta > 0 then
            f:SetValue(f:GetValue() + f:GetValueStep())
        else
            f:SetValue(f:GetValue() - f:GetValueStep())
        end
    end)
    eb:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    eb:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            local min, max = f:GetMinMaxValues()
            if value >= min and value <= max then
                f:SetValue(value)
            elseif value < min then
                f:SetValue(min)
            elseif value > max then
                f:SetValue(max)
            end
			value = RoundTo(value, numDecimalPlaces)
            eb:SetText(f:GetValue())
        else
            f:SetValue(f:GetValue())
        end
        self:ClearFocus()
    end)
    eb:SetScript("OnEditFocusLost", function(self)
        self:HighlightText(0, 0)
    end)
    eb:SetScript("OnEditFocusGained", function(self)
        self:HighlightText(0, -1)
    end)
    f.Plus = CreateFrame("Button", nil, f)
    f.Plus:SetSize(18, 18)
    f.Plus:RegisterForClicks("AnyUp")
    f.Plus:SetPoint("Left", f, "Right", 0, 0)
    f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
    f.Plus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() + f:GetValueStep())
    end)
    f.Minus = CreateFrame("Button", nil, f)
    f.Minus:SetSize(18, 18)
    f.Minus:RegisterForClicks("AnyUp")
    f.Minus:SetPoint("Right", f, "Left", 0, 0)
    f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
    f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
    f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
    f.Minus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() - f:GetValueStep())
	end)

	f:SetValue(defaultValue)
    eb:SetText(defaultValue)
	eb:SetCursorPosition(0)

	return f
end

local function BuildTextBox(parent, text, maxLetters, width, height, xPos, yPos)
	local f = CreateFrame("EditBox", nil, parent)
	f:SetPoint("TOPLEFT", xPos, yPos)
	f:SetAutoFocus(false)
	f:SetMaxLetters(maxLetters)
    f:SetJustifyH("Left")
    f:SetFontObject(GameFontHighlight)
    f:SetSize(width, height)
    f:SetTextInsets(4, 4, 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        edgeSize = 1,
        tileSize = 5
    })
    f:SetBackdropColor(0, 0, 0, 1)
    f:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    f:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
    end)
    f:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    end)
    f:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    f:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
    end)
	f:SetText(text)
	f:SetCursorPosition(0)

	return f
end

local function ConvertColorDecimalToHex(r, g, b, a)
	local _r, _g, _b, _a

	if r == 0 or r == nil then
		_r = "00"
	else
		_r = string.format("%x", math.ceil(r * 255))
	end

	if g == 0 or g == nil then
		_g = "00"
	else
		_g = string.format("%x", math.ceil(g * 255))
	end
	
	if b == 0 or b == nil then
		_b = "00"
	else
		_b = string.format("%x", math.ceil(b * 255))
	end

	if a == 0 or a == nil then
		_a = "00"
	else
		_a = string.format("%x", math.ceil(a * 255))
	end

	return _a .. _r .. _g .. _b
end

local function ShowColorPicker(r, g, b, a, callback)
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		callback, callback, callback
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
	ColorPickerFrame.previousValues = {r, g, b, a}
	ColorPickerFrame:Hide() -- Need to run the OnShow handler.
	ColorPickerFrame:Show()
end

local function BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
	local f = CreateFrame("Button", nil, parent)
	f:SetSize(sizeFrame, sizeFrame)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetBackdrop({edgeFile = settings.textures.border, tile = true, tileSize=4, edgeSize=12})
	f.Texture = f:CreateTexture(nil, "BACKGROUND")
	f.Texture:ClearAllPoints()
	f.Texture:SetPoint("TOPLEFT", 4, -4)
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4)
	f.Texture:SetColorTexture(GetRGBAFromString(settingsEntry, true))
    f:EnableMouse(true)
	f.Font = f:CreateFontString(nil, "BACKGROUND")
	f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0)
	f.Font:SetFontObject(GameFontHighlight)
	f.Font:SetText(description)
	f.Font:SetWordWrap(true)
	f.Font:SetJustifyH("LEFT")
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame)
	return f
end

local function BuildSectionHeader(parent, title, posX, posY)
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(500)
	f:SetHeight(30)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormalLarge)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(500, 30)
	f.font:SetText(title)
	return f
end

local function BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset)
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(offset)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormalSmall)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("RIGHT")
	f.font:SetSize(offset, 20)
	f.font:SetText(var)

	f.description = CreateFrame("Frame", nil, parent)
	local fd = f.description
	fd:ClearAllPoints()
	fd:SetPoint("TOPLEFT", parent)
	fd:SetPoint("TOPLEFT", posX+offset+10, posY)
	fd:SetWidth(200)
	fd:SetHeight(20)
	fd.font = fd:CreateFontString(nil, "BACKGROUND")
	fd.font:SetFontObject(GameFontHighlightSmall)
	fd.font:SetPoint("LEFT", fd, "LEFT")
    fd.font:SetSize(0, 14)
	fd.font:SetJustifyH("LEFT")
	fd.font:SetSize(200, 20)
	fd.font:SetText(desc)

	return f
end

local function ConstructOptionsPanel()
	local xPadding = 10
	local xPadding2 = 30
	local xMax = 550
	local xCoord = 0
	local xCoord2 = 325
	local yCoord = -5
	local xOffset1 = 50
	local xOffset2 = 275
	
	local yOffset1 = 65
	local yOffset2 = 30
	local yOffset3 = 40
	local yOffset4 = 20

	local maxWidth = math.floor(GetScreenWidth())
	local minWidth = math.max(math.ceil(settings.bar.border * 8), 120)
	
	local maxHeight = math.floor(GetScreenHeight())
	local minHeight = math.max(math.ceil(settings.bar.border * 8), 1)
	local barWidth = 250
	local barHeight = 20
	local title = ""

	local maxBorderHeight = math.min(math.floor(settings.bar.height/8), math.floor(settings.bar.width/8))

	interfaceSettingsFrame = {}
	interfaceSettingsFrame.panel = CreateFrame("Frame", "TwintopInsanityBarPanel", UIParent)
	interfaceSettingsFrame.panel.name = "Twintop's Insanity Bar"
	local parent = interfaceSettingsFrame.panel
	
	local controls = {}
	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	local f = nil

	yCoord = -5	
	controls.barPositionSection = BuildSectionHeader(parent, "Twintop's Insanity Bar", xCoord+xPadding, yCoord)

	StaticPopupDialogs["TwintopInsanityBar_Reset"] = {
		text = "Do you want to reset Twintop's Insanity Bar back to it's default configuration? This will cause your UI to be reloaded!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			LoadDefaultSettings()
			ReloadUI()			
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	yCoord = yCoord - yOffset3
	controls.labels.infoVersion = BuildDisplayTextHelpEntry(parent, "Author:", "Twintop <Astral> - Turalyon-US", xCoord+xPadding*2, yCoord, 75)
	yCoord = yCoord - yOffset4
	controls.labels.infoVersion = BuildDisplayTextHelpEntry(parent, "Version:", addonVersion, xCoord+xPadding*2, yCoord, 75)
	yCoord = yCoord - yOffset4
	controls.labels.infoVersion = BuildDisplayTextHelpEntry(parent, "Released:", addonReleaseDate, xCoord+xPadding*2, yCoord, 75)

	yCoord = yCoord - yOffset3
	controls.resetButton = CreateFrame("Button", "TwintopInsanityBar_ResetButton", parent)
	f = controls.resetButton
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord+xPadding*2, yCoord)
	f:SetWidth(150)
	f:SetHeight(30)
	f:SetText("Reset to Defaults")
	f:SetNormalFontObject("GameFontNormal")
	f.ntex = f:CreateTexture()
	f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	f.ntex:SetAllPoints()	
	f:SetNormalTexture(f.ntex)
	f.htex = f:CreateTexture()
	f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
	f.htex:SetAllPoints()
	f:SetHighlightTexture(f.htex)	
	f.ptex = f:CreateTexture()
	f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	f.ptex:SetAllPoints()
	f:SetPushedTexture(f.ptex)
	f:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopInsanityBar_Reset")
	end)

	InterfaceOptions_AddCategory(interfaceSettingsFrame.panel)
	
	interfaceSettingsFrame.barLayoutPanel = CreateFrame("Frame", "TwintopInsanityBar_BarLayoutPanel", parent)
	interfaceSettingsFrame.barLayoutPanel.name = "Bar Layout and Colors"
	interfaceSettingsFrame.barLayoutPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barLayoutPanel)
	
	interfaceSettingsFrame.barFontPanel = CreateFrame("Frame", "TwintopInsanityBar_BarFontPanel", parent)
	interfaceSettingsFrame.barFontPanel.name = "Bar Font and Colors"
	interfaceSettingsFrame.barFontPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barFontPanel)
	
	interfaceSettingsFrame.barTextPanel = CreateFrame("Frame", "TwintopInsanityBar_BarTextPanel", parent)
	interfaceSettingsFrame.barTextPanel.name = "Bar Text Display"
	interfaceSettingsFrame.barTextPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barTextPanel)
	
	interfaceSettingsFrame.optionalFeaturesPanel = CreateFrame("Frame", "TwintopInsanityBar_OptionalFeaturesPanel", parent)
	interfaceSettingsFrame.optionalFeaturesPanel.name = "Optional Features"
	interfaceSettingsFrame.optionalFeaturesPanel.parent = parent.name
	InterfaceOptions_AddCategory(interfaceSettingsFrame.optionalFeaturesPanel)

	
	yCoord = -5
	parent = interfaceSettingsFrame.barLayoutPanel
	controls.barPositionSection = BuildSectionHeader(parent, "Bar Position and Size", xCoord+xPadding, yCoord)
	
	yCoord = yCoord - yOffset3
	title = "Bar Width"
	controls.width = BuildSlider(parent, title, minWidth, maxWidth, settings.bar.width, 1, 0,
								 barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.width:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)
		settings.bar.width = value
		barContainerFrame:SetWidth(value-(settings.bar.border*2))
		barBorderFrame:SetWidth(settings.bar.width)
		insanityFrame:SetWidth(value-(settings.bar.border*2))
		castingFrame:SetWidth(value-(settings.bar.border*2))
		passiveFrame:SetWidth(value-(settings.bar.border*2))
		RepositionInsanityFrameThreshold()
		local maxBorderSize = math.min(math.floor(settings.bar.height/ 8), math.floor(settings.bar.width / 8))
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(maxBorderSize)
	end)

	title = "Bar Height"
	controls.height = BuildSlider(parent, title, minHeight, maxHeight, settings.bar.height, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.height:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end		
		self.EditBox:SetText(value)		
		settings.bar.height = value
		barContainerFrame:SetHeight(value-(settings.bar.border*2))
		barBorderFrame:SetHeight(settings.bar.height)
		insanityFrame:SetHeight(value-(settings.bar.border*2))
		insanityFrame.threshold:SetHeight(value-(settings.bar.border*2))
		castingFrame:SetHeight(value-(settings.bar.border*2))
		passiveFrame:SetHeight(value-(settings.bar.border*2))
		passiveFrame.threshold:SetHeight(value-(settings.bar.border*2))		
		leftTextFrame:SetHeight(settings.bar.height * 3.5)
		middleTextFrame:SetHeight(settings.bar.height * 3.5)
		rightTextFrame:SetHeight(settings.bar.height * 3.5)
		local maxBorderSize = math.min(math.floor(settings.bar.height/ 8), math.floor(settings.bar.width / 8))
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(maxBorderSize)
	end)

	title = "Bar Horizontal Position"
	yCoord = yCoord - yOffset1
	controls.horizontal = BuildSlider(parent, title, math.ceil(-maxWidth/2), math.floor(maxWidth/2), settings.bar.xPos, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		settings.bar.xPos = value
		barContainerFrame:ClearAllPoints()
		barContainerFrame:SetPoint("CENTER", UIParent)
		barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	end)

	title = "Bar Vertical Position"
	controls.vertical = BuildSlider(parent, title, math.ceil(-maxHeight/2), math.ceil(maxHeight/2), settings.bar.yPos, 1, 0,
								  barWidth, barHeight, xCoord2, yCoord)
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)
		settings.bar.yPos = value
		barContainerFrame:ClearAllPoints()
		barContainerFrame:SetPoint("CENTER", UIParent)
		barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos)
	end)

	title = "Bar Border Width"
	yCoord = yCoord - yOffset1
	controls.borderWidth = BuildSlider(parent, title, 0, maxBorderHeight, settings.bar.border, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.borderWidth:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		settings.bar.border = value
		barContainerFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
		barContainerFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
		barBorderFrame:SetWidth(settings.bar.width)
		barBorderFrame:SetHeight(settings.bar.height)
		if settings.bar.border < 1 then
			barBorderFrame:SetBackdrop({ })
		else
			barBorderFrame:SetBackdrop({ edgeFile = settings.textures.border,
										tile = true,
										tileSize=4,
										edgeSize=settings.bar.border*4,								
										insets = {0, 0, 0, 0}
										})
		end
		barBorderFrame:SetBackdropColor(0, 0, 0, 0)
		barBorderFrame:SetBackdropBorderColor(GetRGBAFromString(settings.colors.bar.border, true))
		insanityFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
		insanityFrame.threshold:SetHeight(settings.bar.height-(settings.bar.border*2))
		castingFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
		passiveFrame:SetHeight(settings.bar.height-(settings.bar.border*2))
		passiveFrame.threshold:SetHeight(settings.bar.height-(settings.bar.border*2))
		leftTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2)-2)
		middleTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
		rightTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2))
		leftTextFrame:SetHeight(settings.bar.height * 3.5)
		middleTextFrame:SetHeight(settings.bar.height * 3.5)
		rightTextFrame:SetHeight(settings.bar.height * 3.5)

		local minBarWidth = math.max(settings.bar.border * 8, 120)
		local minBarHeight = math.max(settings.bar.border * 8, 1)
		controls.height:SetMinMaxValues(minBarHeight, maxHeight)
		controls.height.MinLabel:SetText(minBarHeight)
		controls.width:SetMinMaxValues(minBarWidth, maxWidth)
		controls.width.MinLabel:SetText(minBarWidth)
	end)

	controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TIBCB1_1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.lockPosition
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
	f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved."
	f:SetChecked(settings.bar.dragAndDrop)
	f:SetScript("OnClick", function(self, ...)
		settings.bar.dragAndDrop = self:GetChecked()
		barContainerFrame:SetMovable(settings.bar.dragAndDrop)
		barContainerFrame:EnableMouse(settings.bar.dragAndDrop)
	end)

	yCoord = yCoord - yOffset3
	controls.barColorsSection = BuildSectionHeader(parent, "Bar Colors", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset2
	controls.colors.base = BuildColorPicker(parent, "Insanity while not in Voidform", settings.colors.bar.base, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.base
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.base.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.base = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.base, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.inVoidform = BuildColorPicker(parent, "Insanity while in Voidform", settings.colors.bar.inVoidform, 250, 25, xCoord2, yCoord)
	f = controls.colors.inVoidform
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.inVoidform.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.inVoidform = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.inVoidform, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset2
	controls.colors.enterVoidform = BuildColorPicker(parent, "Insanity when you can cast Void Eruption", settings.colors.bar.enterVoidform, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.enterVoidform
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.enterVoidform.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.enterVoidform = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.enterVoidform, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.border = BuildColorPicker(parent, "Insanity Bar's border", settings.colors.bar.border, 225, 25, xCoord2, yCoord)
	f = controls.colors.border
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		controls.colors.border.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.border = ConvertColorDecimalToHex(r, g, b, a)
		barBorderFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.border, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset2
	controls.colors.casting = BuildColorPicker(parent, "Insanity from hardcasting spells", settings.colors.bar.casting, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.casting
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.casting.Texture:SetColorTexture(r, g, b, a)
		castingFrame:SetStatusBarColor(r, g, b, a)
		settings.colors.bar.casting = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.casting, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)	
		
	controls.colors.background = BuildColorPicker(parent, "Unfilled bar background", settings.colors.bar.background, 250, 25, xCoord2, yCoord)
	f = controls.colors.background
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.background.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.background = ConvertColorDecimalToHex(r, g, b, a)
		barContainerFrame:SetBackdropColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.background, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset2
	controls.colors.thresholdUnder = BuildColorPicker(parent, "Under min. req. Insanity to cast Void Eruption Threshold Line", settings.colors.threshold.under, 260, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.thresholdUnder
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, a)
		settings.colors.threshold.under = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.threshold.under, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)	
		
	controls.colors.inVoidform2GCD = BuildColorPicker(parent, "Insanity while you have between 1-2 GCDs left in Voidform", settings.colors.bar.inVoidform2GCD, 250, 25, xCoord2, yCoord)
	f = controls.colors.inVoidform2GCD
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.inVoidform2GCD.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.inVoidform2GCD = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.inVoidform2GCD, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset2
	controls.colors.thresholdOver = BuildColorPicker(parent, "Over min. req. Insanity to cast Void Eruption Threshold Line", settings.colors.threshold.over, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.thresholdOver
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, a)
		settings.colors.threshold.over = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.threshold.over, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.inVoidform1GCD = BuildColorPicker(parent, "Insanity while you have less than 1 GCD left in Voidform", settings.colors.bar.inVoidform1GCD, 250, 25, xCoord2, yCoord)
	f = controls.colors.inVoidform1GCD
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end

		controls.colors.inVoidform1GCD.Texture:SetColorTexture(r, g, b, a)
		settings.colors.bar.inVoidform1GCD = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.inVoidform1GCD, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)
	
	yCoord = yCoord - yOffset3
	controls.barDisplaySection = BuildSectionHeader(parent, "Bar Display", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset3

	title = "Void Eruption Flash Alpha"
	controls.flashAlpha = BuildSlider(parent, title, 0, 1, settings.colors.bar.flashAlpha, 0.01, 2,
								 barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end	

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)
		settings.colors.bar.flashAlpha = value
	end)

	title = "Void Eruption Flash Period (sec)"
	controls.flashPeriod = BuildSlider(parent, title, 0, 2, settings.colors.bar.flashPeriod, 0.05, 2,
									barWidth, barHeight, xCoord2, yCoord)
	controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		settings.colors.bar.flashPeriod = value
	end)

	yCoord = yCoord - yOffset3
	controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TIBRB1_2", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.alwaysShow
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Always show Insanity Bar")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "This will make the Insanity Bar always visible on your UI, even when out of combat."
	f:SetChecked(settings.displayBar.alwaysShow)
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(true)
		controls.checkBoxes.notZeroShow:SetChecked(false)
		controls.checkBoxes.combatShow:SetChecked(false)
		settings.displayBar.alwaysShow = true
		settings.displayBar.notZeroShow = false
		HideInsanityBar()
	end)

	controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TIBRB1_3", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.notZeroShow
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-15)
	getglobal(f:GetName() .. 'Text'):SetText("Show Insanity Bar when Insanity > 0")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "This will make the Insanity Bar show out of combat only if Insanity > 0, hidden otherwise when out of combat."
	f:SetChecked(settings.displayBar.notZeroShow)
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(false)
		controls.checkBoxes.notZeroShow:SetChecked(true)
		controls.checkBoxes.combatShow:SetChecked(false)
		settings.displayBar.alwaysShow = false
		settings.displayBar.notZeroShow = true
		HideInsanityBar()
	end)

	controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TIBRB1_4", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.combatShow
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText("Only show Insanity Bar in combat")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "This will make the Insanity Bar only be visible on your UI when in combat."
	f:SetChecked((not settings.displayBar.alwaysShow) and (not settings.displayBar.notZeroShow))
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(false)
		controls.checkBoxes.notZeroShow:SetChecked(false)
		controls.checkBoxes.combatShow:SetChecked(true)
		settings.displayBar.alwaysShow = false
		settings.displayBar.notZeroShow = false
		HideInsanityBar()
	end)


	controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TIBCB1_5", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.flashEnabled
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Void Eruption Usable")
	f.tooltip = "This will flash the bar when Void Eruption can be cast."
	f:SetChecked(settings.voidEruptionThreshold)
	f:SetScript("OnClick", function(self, ...)
		settings.voidEruptionThreshold = self:GetChecked()
	end)

	controls.checkBoxes.vfThresholdShow = CreateFrame("CheckButton", "TIBCB1_6", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.vfThresholdShow
	f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText("Show Void Eruption Threshold Line")
	f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Void Eruption."
	f:SetChecked(settings.colors.bar.flashEnabled)
	f:SetScript("OnClick", function(self, ...)
		settings.colors.bar.flashEnabled = self:GetChecked()
	end)

	

	------------------------------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.barFontPanel

	controls.textDisplaySection = BuildSectionHeader(parent, "Font Size and Colors", xCoord+xPadding, yCoord)

	title = "Left Bar Text Font Size"
	yCoord = yCoord - yOffset3
	controls.fontSizeLeft = BuildSlider(parent, title, 6, 72, settings.displayText.fontSizeLeft, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		settings.displayText.fontSizeLeft = value
		leftTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSizeLeft, "OUTLINE")
		if settings.displayText.fontSizeLock then
			controls.fontSizeMiddle:SetValue(value)
			controls.fontSizeRight:SetValue(value)
		end
	end)
	
	controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TIBCB2_F1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fontSizeLock
	f:SetPoint("TOPLEFT", xCoord2+10, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
	f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
	f:SetChecked(settings.displayText.fontSizeLock)
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.fontSizeLock = self:GetChecked()
		if settings.displayText.fontSizeLock then
			controls.fontSizeMiddle:SetValue(settings.displayText.fontSizeLeft)
			controls.fontSizeRight:SetValue(settings.displayText.fontSizeLeft)
		end
	end)

	controls.colors.leftText = BuildColorPicker(parent, "Left Text", settings.colors.text.left,
													250, 25, xCoord2, yCoord-30)	f = controls.colors.leftText
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.leftText.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.left = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.left, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.middleText = BuildColorPicker(parent, "Middle Text", settings.colors.text.middle,
													225, 25, xCoord2, yCoord-70)
	f = controls.colors.middleText
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.middleText.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.middle = ConvertColorDecimalToHex(r, g, b, a)
		barContainerFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.middle, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.rightText = BuildColorPicker(parent, "Right Text", settings.colors.text.right,
													225, 25, xCoord2, yCoord-110)
	f = controls.colors.rightText
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.rightText.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.right = ConvertColorDecimalToHex(r, g, b, a)
		barContainerFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.right, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)
	
	title = "Middle Bar Text Font Size"
	yCoord = yCoord - yOffset1
	controls.fontSizeMiddle = BuildSlider(parent, title, 6, 72, settings.displayText.fontSizeMiddle, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		settings.displayText.fontSizeMiddle = value
		middleTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSizeMiddle, "OUTLINE")
		if settings.displayText.fontSizeLock then
			controls.fontSizeLeft:SetValue(value)
			controls.fontSizeRight:SetValue(value)
		end
	end)
	
	title = "Right Bar Text Font Size"
	yCoord = yCoord - yOffset1
	controls.fontSizeRight = BuildSlider(parent, title, 6, 72, settings.displayText.fontSizeRight, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end
		self.EditBox:SetText(value)		
		settings.displayText.fontSizeRight = value
		rightTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSizeRight, "OUTLINE")
		if settings.displayText.fontSizeLock then
			controls.fontSizeLeft:SetValue(value)
			controls.fontSizeMiddle:SetValue(value)
		end
	end)

	yCoord = yCoord - yOffset1	
	controls.colors.currentInsanityText = BuildColorPicker(parent, "Current Insanity", settings.colors.text.currentInsanity, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.currentInsanityText
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.currentInsanityText.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.currentInsanity = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.currentInsanity, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.castingInsanityText = BuildColorPicker(parent, "Insanity from hardcasting spells", settings.colors.text.castingInsanity, 250, 25, xCoord2, yCoord)
	f = controls.colors.castingInsanityText
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.castingInsanityText.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.castingInsanity = ConvertColorDecimalToHex(r, g, b, a)
		barContainerFrame:SetBackdropBorderColor(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.currentInsanity, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset1	
	title = "Low to Medium Haste% Threshold in Voidform"
	controls.hasteApproachingThreshold = BuildSlider(parent, title, 0, 500, settings.hasteApproachingThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value > settings.hasteThreshold then
			value = settings.hasteThreshold
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		settings.hasteApproachingThreshold = value
	end)

	controls.colors.hasteBelow = BuildColorPicker(parent, "Low Haste% in Voidform", settings.colors.text.hasteBelow,
												250, 25, xCoord2, yCoord+10)
	f = controls.colors.hasteBelow
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.hasteBelow.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.hasteBelow = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.hasteBelow, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.hasteApproaching = BuildColorPicker(parent, "Medium Haste% in Voidform", settings.colors.text.hasteApproaching,
												250, 25, xCoord2, yCoord-30)
	f = controls.colors.hasteApproaching
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.hasteApproaching.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.hasteApproaching = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.hasteApproaching, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	controls.colors.hasteAbove = BuildColorPicker(parent, "High Haste% in Voidform", settings.colors.text.hasteAbove,
												250, 25, xCoord2, yCoord-70)
	f = controls.colors.hasteAbove
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0

		controls.colors.hasteAbove.Texture:SetColorTexture(r, g, b, a)
		settings.colors.text.hasteAbove = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.hasteAbove, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset1	
	title = "Medium to High Haste% Threshold in Voidform"
	controls.hasteThreshold = BuildSlider(parent, title, 0, 500, settings.hasteThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value < settings.hasteApproachingThreshold then
			value = settings.hasteApproachingThreshold
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		settings.hasteThreshold = value
	end)

	yCoord = yCoord - yOffset1	
	title = "Haste Decimals to Show"
	controls.hastePrecision = BuildSlider(parent, title, 0, 10, settings.hastePrecision, 1, 0,
									barWidth, barHeight, xCoord+xPadding2, yCoord)
	controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = RoundTo(value, 0)
		self.EditBox:SetText(value)		
		settings.hastePrecision = value
	end)

	------------------------------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.barTextPanel

	controls.textCustomSection = BuildSectionHeader(parent, "Bar Display Text Customization", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset2
	controls.labels.outVoidform = CreateFrame("Frame", nil, parent)
	f = controls.labels.outVoidform
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", xCoord+xPadding2+100, yCoord)
	f:SetWidth(225)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("CENTER")
	f.font:SetSize(225, 20)
	f.font:SetText("Out of Voidform")

	controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
	f = controls.labels.inVoidform
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", xCoord2+25, yCoord)
	f:SetWidth(200)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("CENTER")
	f.font:SetSize(225, 20)
	f.font:SetText("In Voidform")

	yCoord = yCoord - yOffset4
	controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
	f = controls.labels.inVoidform
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	f:SetWidth(90)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("RIGHT")
	f.font:SetSize(90, 20)
	f.font:SetText("Left Text")

	controls.textbox.voidformOutLeft = BuildTextBox(parent, settings.displayText.left.outVoidformText,
													500, 225, 24, xCoord+xPadding*2+100, yCoord)
	f = controls.textbox.voidformOutLeft
	f:SetScript("OnTextChanged", function(self, input)
		settings.displayText.left.outVoidformText = self:GetText()
		IsTtdActive()
	end)

	controls.textbox.voidformInLeft = BuildTextBox(parent, settings.displayText.left.inVoidformText,
													500, 225, 24, xCoord2+25, yCoord)
	f = controls.textbox.voidformInLeft
	f:SetScript("OnTextChanged", function(self, input)
		settings.displayText.left.inVoidformText = self:GetText()
		IsTtdActive()
	end)

	yCoord = yCoord - yOffset2
	controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
	f = controls.labels.inVoidform
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	f:SetWidth(90)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("RIGHT")
	f.font:SetSize(90, 20)
	f.font:SetText("Middle Text")

	controls.textbox.voidformOutMiddle = BuildTextBox(parent, settings.displayText.middle.outVoidformText,
													500, 225, 24, xCoord+xPadding*2+100, yCoord)
	f = controls.textbox.voidformOutMiddle
	f:SetScript("OnTextChanged", function(self, input)
		settings.displayText.middle.outVoidformText = self:GetText()
		IsTtdActive()
	end)

	controls.textbox.voidformInMiddle = BuildTextBox(parent, settings.displayText.middle.inVoidformText,
													500, 225, 24, xCoord2+25, yCoord)
	f = controls.textbox.voidformInMiddle
	f:SetScript("OnTextChanged", function(self, input)
		settings.displayText.middle.inVoidformText = self:GetText()
		IsTtdActive()
	end)

	yCoord = yCoord - yOffset2
	controls.labels.inVoidform = CreateFrame("Frame", nil, parent)
	f = controls.labels.inVoidform
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	f:SetWidth(90)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("RIGHT")
	f.font:SetSize(90, 20)
	f.font:SetText("Right Text")

	controls.textbox.voidformOutRight = BuildTextBox(parent, settings.displayText.right.outVoidformText,
													500, 225, 24, xCoord+xPadding*2+100, yCoord)
	f = controls.textbox.voidformOutRight
	f:SetScript("OnTextChanged", function(self, input)
		settings.displayText.right.outVoidformText = self:GetText()
		IsTtdActive()
	end)

	controls.textbox.voidformInRight = BuildTextBox(parent, settings.displayText.right.inVoidformText,
													500, 225, 24, xCoord2+25, yCoord)
	f = controls.textbox.voidformInRight
	f:SetScript("OnTextChanged", function(self, input)
		settings.displayText.right.inVoidformText = self:GetText()
		IsTtdActive()
	end)

	yCoord = yCoord - yOffset2
	controls.labels.instructionsVar = CreateFrame("Frame", nil, parent)
	f = controls.labels.instructionsVar
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	f:SetWidth(600)
	f:SetHeight(20)
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(GameFontHighlight)
	f.font:SetPoint("LEFT", f, "LEFT")
    f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(600, 20)
	f.font:SetText("For conditional display (only if $VARIABLE is active/non-zero): {$VARIABLE}[WHAT TO DISPLAY]")

	yCoord = yCoord - yOffset4
	controls.labels.vfStacksVar = BuildDisplayTextHelpEntry(parent, "$vfStacks", "Current Voidform Stack Count", xCoord, yCoord, 85)
	controls.labels.insanityVar = BuildDisplayTextHelpEntry(parent, "$insanity", "Current Insanity", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.vfStacksIncomingVar = BuildDisplayTextHelpEntry(parent, "$vfIncoming", "Incoming Voidform Stacks", xCoord, yCoord, 85)
	controls.labels.castingVar = BuildDisplayTextHelpEntry(parent, "$casting", "Insanity from Hardcasting Spells", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.vfDrainStacksVar = BuildDisplayTextHelpEntry(parent, "$vfDrainStacks", "Current Voidform Drain Stacks Count", xCoord, yCoord, 85)
	controls.labels.passiveVar = BuildDisplayTextHelpEntry(parent, "$passive", "Insanity from Passive Sources", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.vfDrainVar = BuildDisplayTextHelpEntry(parent, "$vfDrain", "Insanity drained per second", xCoord, yCoord, 85)
	controls.labels.asInsanityVar = BuildDisplayTextHelpEntry(parent, "$asInsanity", "Insanity from Auspicious Spirits", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.vfTimeVar = BuildDisplayTextHelpEntry(parent, "$vfTime", "Time until Voidform will end", xCoord, yCoord, 85)
	controls.labels.asCountVar = BuildDisplayTextHelpEntry(parent, "$asCount", "Number of Auspicious Spirits in Flight", xCoord2-70, yCoord, 130)
	
	yCoord = yCoord - yOffset4
	controls.labels.mbGcdsVar = BuildDisplayTextHelpEntry(parent, "$mbGcds", "Number of GCDs left on Mindbender", xCoord, yCoord, 85)
	controls.labels.mbInsanityVar = BuildDisplayTextHelpEntry(parent, "$mbInsanity", "Insanity from Mindbender (per settings)", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.mbTimeVar = BuildDisplayTextHelpEntry(parent, "$mbTime", "Time left on Mindbender", xCoord, yCoord, 85)
	controls.labels.mbSwingsVar = BuildDisplayTextHelpEntry(parent, "$mbSwings", "Number of Swings left on Mindbender", xCoord2-70, yCoord, 130)
	
	yCoord = yCoord - yOffset4
	controls.labels.liStacksVar = BuildDisplayTextHelpEntry(parent, "$liStacks", "Lingering Insanity Stacks", xCoord, yCoord, 85)
	controls.labels.liTimeVar = BuildDisplayTextHelpEntry(parent, "$liTime", "Lingering Insanity time remaining", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.hasteVar = BuildDisplayTextHelpEntry(parent, "$haste", "Current Haste%", xCoord, yCoord, 85)
	controls.labels.ttdVar = BuildDisplayTextHelpEntry(parent, "$ttd", "Time To Die of current target", xCoord2-70, yCoord, 130)

	yCoord = yCoord - yOffset4
	controls.labels.gcdVar = BuildDisplayTextHelpEntry(parent, "$gcd", "Current GCD, in seconds", xCoord, yCoord, 85)
	controls.labels.newlineVar = BuildDisplayTextHelpEntry(parent, "||n", "Insert a Newline", xCoord2-70, yCoord, 130)
	---------------------------

	yCoord = -5
	parent = interfaceSettingsFrame.optionalFeaturesPanel

	controls.textSection = BuildSectionHeader(parent, "Passive Options", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset2
	controls.checkBoxes.textRightPI = CreateFrame("CheckButton", "TIBCB3_1", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.textRightPI
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Right Text: Show Passive Insanity Value")
	f.tooltip = "Show the amount of incoming Insanity from Auspicious Spirits and Mindbender."
	f:SetChecked(settings.displayText.right.passiveInsanity)
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.right.passiveInsanity = self:GetChecked()
	end)

	controls.checkBoxes.s2mDeath = CreateFrame("CheckButton", "TIBCB3_2", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.s2mDeath
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Play Wilhelm Scream when S2M Ends")
	f.tooltip = "When you (almost) die, horribly, after Surrender to Madness ends, play the infamous Wilhelm Scream to make you feel a bit better."
	f:SetChecked(settings.audio.s2mDeath.enabled)
	f:SetScript("OnClick", function(self, ...)
		settings.audio.s2mDeath.enabled = self:GetChecked()
	end)

	yCoord = yCoord - yOffset4
	controls.checkBoxes.showSummary = CreateFrame("CheckButton", "TIBCB3_3", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showSummary
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Show Voidform Summary")
	f.tooltip = "Shows a summary in chat of your last Voidform including total duration, total stacks, final drain rate, and stacks gained while channeling Void Torrent."
	f:SetChecked(settings.showSummary)
	f:SetScript("OnClick", function(self, ...)
		settings.showSummary = self:GetChecked()
	end)

	--[[
	controls.checkBoxes.showS2MSummary = CreateFrame("CheckButton", "TIBCB3_4", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showS2MSummary
	f:SetPoint("TOPLEFT", xCoord2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Show Surrender to Madness Summary")
	f.tooltip = "Shows a summary in chat of your last Surrender to Madness, including total duration of S2M, total duration of Voidform, total stacks, final drain rate, and stacks gained while channeling Void Torrent."
	f:SetChecked(settings.showS2MSummary)
	f:SetScript("OnClick", function(self, ...)
		settings.showS2MSummary = self:GetChecked()
	end)
	]]--

	yCoord = yCoord - yOffset3
	controls.colors.passive = BuildColorPicker(parent, "Insanity from Auspicious Spirits and Shadowfiend swings", settings.colors.bar.passive, 250, 25, xCoord+xPadding*2, yCoord)
	f = controls.colors.passive
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		
		controls.colors.passive.Texture:SetColorTexture(r, g, b, a)
		passiveFrame:SetStatusBarColor(r, g, b, a)
		settings.colors.bar.passive = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.passive, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset2
	controls.textSection = BuildSectionHeader(parent, "Auspicious Spirits Tracking", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset2
	controls.checkBoxes.as = CreateFrame("CheckButton", "TIBCB3_5", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.as
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Track Auspicious Spirits")
	f.tooltip = "Track Shadowy Apparitions in flight that will generate Insanity upon reaching their target with the Auspicious Spirits talent."
	f:SetChecked(settings.auspiciousSpiritsTracker)
	f:SetScript("OnClick", function(self, ...)
		settings.auspiciousSpiritsTracker = self:GetChecked()
		
		if settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected and GetSpecialization() == 3 then
			asTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) asTimerFrame:onUpdate(sinceLastUpdate) end)
		else
			asTimerFrame:SetScript("OnUpdate", nil)
		end	
		snapshotData.auspiciousSpirits.total = 0
		snapshotData.auspiciousSpirits.units = 0
		snapshotData.auspiciousSpirits.tracker = {}
	end)

	yCoord = yCoord - yOffset2
	controls.textSection = BuildSectionHeader(parent, "Shadowfiend (+ Mindbender) Tracking", xCoord+xPadding, yCoord)

	yCoord = yCoord - yOffset2	
	controls.checkBoxes.mindbender = CreateFrame("CheckButton", "TIBCB3_6", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindbender
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend Insanity Gain")
	f.tooltip = "Show the gain of Insanity over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below."
	f:SetChecked(settings.mindbender.enabled)
	f:SetScript("OnClick", function(self, ...)
		settings.mindbender.enabled = self:GetChecked()
	end)

	controls.colors.mindbenderThreshold = BuildColorPicker(parent, "Shadowfiend Insanity Gain Threshold Line", settings.colors.bar.passive, 250, 25, xCoord2, yCoord)
	f = controls.colors.mindbenderThreshold
	f.recolorTexture = function(color)
		local r, g, b, a
		if color then
			r, g, b, a = unpack(color)
		else
			r, g, b = ColorPickerFrame:GetColorRGB()
			a = OpacitySliderFrame:GetValue()
		end
		
		controls.colors.mindbenderThreshold.Texture:SetColorTexture(r, g, b, a)
		passiveFrame:SetStatusBarColor(r, g, b, a)
		settings.colors.threshold.mindbender = ConvertColorDecimalToHex(r, g, b, a)
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.threshold.mindbender, true)
			ShowColorPicker(r, g, b, a, self.recolorTexture)
		end
	end)

	yCoord = yCoord - yOffset1	
	controls.checkBoxes.mindbenderModeGCDs = CreateFrame("CheckButton", "TIBRB3_7", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.mindbenderModeGCDs
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from GCDs remaining")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X GCDs, based on player's current GCD."
	if settings.mindbender.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(true)
		controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
		controls.checkBoxes.mindbenderModeTime:SetChecked(false)
		settings.mindbender.mode = "gcd"
	end)

	title = "Shadowfiend GCDs - 0.75sec Floor"
	controls.mindbenderGCDs = BuildSlider(parent, title, 1, 10, settings.mindbender.gcdsMax, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderGCDs:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)		
		settings.mindbender.gcdsMax = value
	end)


	yCoord = yCoord - yOffset1	
	controls.checkBoxes.mindbenderModeSwings = CreateFrame("CheckButton", "TIBRB3_8", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.mindbenderModeSwings
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from Swings remaining")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X melee swings from Shadowfiend/Mindbender. This is only different from the GCD option if you are above 200% haste (GCD cap)."
	if settings.mindbender.mode == "swing" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
		controls.checkBoxes.mindbenderModeSwings:SetChecked(true)
		controls.checkBoxes.mindbenderModeTime:SetChecked(false)
		settings.mindbender.mode = "swing"
	end)

	title = "Shadowfiend Swings - No Floor"
	controls.mindbenderSwings = BuildSlider(parent, title, 1, 10, settings.mindbender.swingsMax, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderSwings:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)		
		settings.mindbender.swingsMax = value
	end)

	yCoord = yCoord - yOffset1	
	controls.checkBoxes.mindbenderModeTime = CreateFrame("CheckButton", "TIBRB3_9", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.mindbenderModeTime
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from Time remaining")
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X seconds."
	if settings.mindbender.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
		controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
		controls.checkBoxes.mindbenderModeTime:SetChecked(true)
		settings.mindbender.mode = "time"
	end)

	title = "Shadowfiend Time Remaining"
	controls.mindbenderTime = BuildSlider(parent, title, 0, 15, settings.mindbender.timeMax, 0.25, 2,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderTime:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		value = RoundTo(value, 2)
		self.EditBox:SetText(value)		
		settings.mindbender.timeMax = value
	end)

	yCoord = yCoord - yOffset1	
	yCoord = yCoord - yOffset2	
	controls.checkBoxes.mindbenderAudio = CreateFrame("CheckButton", "TIBCB3_10", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindbenderAudio
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText("Play Audio Cue to use Shadowfiend")
	f.tooltip = "Plays an audio cue when in Voidform, Shadowfiend/Mindbender is offcooldown, and the number of Drain Stacks is above a certain threshold."
	f:SetChecked(settings.mindbender.useNotification.enabled)
	f:SetScript("OnClick", function(self, ...)
		settings.mindbender.useNotification.enabled = self:GetChecked()
		if settings.mindbender.useNotification.enabled then
			mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate) end)
		else
			mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
		end
	end)

	controls.checkBoxes.mindbenderAudioStacks = CreateFrame("CheckButton", "TIBCB3_11", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindbenderAudioStacks
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText("Use Voidform Stacks instead of Drain Stacks")
	f.tooltip = "Uses the current Voidform Stacks instead of computed Drain Stacks for the audio cue."
	f:SetChecked(settings.mindbender.useNotification.useVoidformStacks)
	f:SetScript("OnClick", function(self, ...)
		settings.mindbender.useNotification.useVoidformStacks = self:GetChecked()
	end)

	title = "Stacks to Trigger Audio Cue"
	controls.mindbenderStacks = BuildSlider(parent, title, 1, 100, settings.mindbender.useNotification.thresholdStacks, 1, 0,
									barWidth, barHeight, xCoord2, yCoord)
	controls.mindbenderStacks:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		end

		self.EditBox:SetText(value)		
		settings.mindbender.useNotification.thresholdStacks = value
	end)

	interfaceSettingsFrame.controls = controls
	
end

local function InsanityDrain(stacks)
    local pct = 1.00
    if characterData.items.t20Pieces >= 4 then
        if snapshotData.voidform.s2m.active then
            pct = 0.95
        else
            pct = 0.90
        end
    end    
    
    return (6.0 + ((stacks - 1) * 0.92)) * pct
end

local function RemainingTimeAndStackCount()
    local currentTime = GetTime()
    local _
	_, _, _, _, snapshotData.voidform.duration, _, _, _, _, snapshotData.voidform.spellId = FindBuffById(spells.voidform.id)
    	
    if snapshotData.voidform.spellId == nil then		
		--[[ Commented out to try and fix Issue #12 -- https://github.com/Twintop/TwintopInsanityBar/issues/12
		snapshotData.voidform.totalStacks = 0
		snapshotData.voidform.drainStacks = 0
		snapshotData.voidform.additionalStacks = 0
		snapshotData.voidform.currentDrainRate = 0
		snapshotData.voidform.duration = 0
		snapshotData.voidform.spellId = nil
		snapshotData.voidform.startTime = 0
		snapshotData.voidform.previousStackTime = 0
		snapshotData.voidform.remainingTime = 0
		snapshotData.voidform.voidTorrent.stacks = 0
		snapshotData.voidform.voidTorrent.startTime = nil
		snapshotData.voidform.dispersion.stacks = 0
		snapshotData.voidform.dispersion.startTime = nil
		]]
    else
		local down, up, lagHome, lagWorld = GetNetStats()
		local TimeDiff = currentTime - snapshotData.voidform.previousStackTime        
		local remainingInsanity = tonumber(snapshotData.insanity)
		
		local remainingTime = 0
		local moreStacks = 0
		local latency = lagWorld / 1000
		local workingStack = snapshotData.voidform.drainStacks
		local startingStack = workingStack
		
		while (remainingInsanity > 0)
		do
			moreStacks = moreStacks+1
			local drain = InsanityDrain(workingStack)
			local stackTime = 1.0
			
			if workingStack == startingStack then					
				stackTime = 1.0 - TimeDiff + latency					
			end
			
			if (stackTime > 0) then                    
				if (drain * stackTime) >= remainingInsanity then                       
					stackTime = remainingInsanity / drain
					remainingInsanity = 0
				else
					remainingInsanity = remainingInsanity - (drain * stackTime)
				end
				
				remainingTime = remainingTime + stackTime
			end               
			
			workingStack = workingStack + 1
		end
		
		snapshotData.voidform.remainingTime = remainingTime
		snapshotData.voidform.currentDrainRate = InsanityDrain(snapshotData.voidform.drainStacks)
		snapshotData.voidform.additionalStacks = moreStacks
    end  
end

local function CalculateInsanityGain(insanity, fotm)
	local modifier = 1.0
	
	if fotm and characterData.talents.fotm.isSelected then
		modifier = modifier * characterData.talents.fotm.modifier
	end
	
	--TODO: Add check for S2M debuff and make incoming insanity gain 0 while up
	if spells.s2m.isActive then
		modifier = modifier * spells.s2m.modifier
	end

	if spells.s2m.isDebuffActive then
		modifier = modifier * spells.s2m.modifierDebuff
	end
	
	return insanity * modifier	
end

local function ResetCastingSnapshotData()
	snapshotData.casting.spellId = nil
	snapshotData.casting.startTime = nil
	snapshotData.casting.endTime = nil
	snapshotData.casting.insanityRaw = 0
	snapshotData.casting.insanityFinal = 0
end

local function RemoveInvalidVariablesFromBarText(input)
	--1         11                       36
	--a         b                        c
	--{$liStacks}[$liStacks - $liTime sec]	
	local returnText = ""
	local p = 0
	while p < string.len(input) do
		local a, b, c, a1, b1, c1
		a, a1 = string.find(input, "{", p)
		if a ~= nil then
			b, b1 = string.find(input, "}", a)

			if b ~= nil and string.sub(input, b+1, b+1) == "[" then
				c, c1 = string.find(input, "]", b+1)

				if c ~= nil then
					if p ~= a then
						returnText = returnText .. string.sub(input, p, a-1)
					end
					
					local valid = false
					local var = string.sub(input, a+1, b-1)
					
					if var == "$haste" then
						valid = true
					elseif var == "$gcd" then
						valid = true
					elseif var == "$vfIncoming" then
						if snapshotData.voidform.additionalStacks ~= nil and snapshotData.voidform.additionalStacks > 0 then
							valid = true
						end
					elseif var == "$vfStacks" then
						if snapshotData.voidform.totalStacks ~= nil and snapshotData.voidform.totalStacks > 0 then
							valid = true
						end
					elseif var == "$liStacks" then
						if snapshotData.lingeringInsanity.stacksLast ~= nil and snapshotData.lingeringInsanity.stacksLast > 0 then
							valid = true
						end
					elseif var == "$liTime" then
						if snapshotData.lingeringInsanity.timeLeftBase ~= nil and snapshotData.lingeringInsanity.lastTickTime ~= nil then
							valid = true
						end
					elseif var == "$vfDrainStacks" then
						if snapshotData.voidform.drainStacks ~= nil and snapshotData.voidform.drainStacks > 0 then
							valid = true
						end						
					elseif var == "$vfDrain" then
						if snapshotData.voidform.currentDrainRate ~= nil and snapshotData.voidform.currentDrainRate > 0 then
							valid = true
						end
					elseif var == "$vfTime" then
						if snapshotData.voidform.remainingTime ~= nil and snapshotData.voidform.remainingTime > 0 then
							valid = true
						end
					elseif var == "$insanity" then
						valid = true
					elseif var == "$casting" then
						if snapshotData.casting.insanityFinal ~= nil and snapshotData.casting.insanityFinal > 0 then
							valid = true
						end
					elseif var == "$passive" then
						if (CalculateInsanityGain(spells.auspiciousSpirits.insanity, false) * snapshotData.auspiciousSpirits.total) + snapshotData.mindbender.insanityFinal > 0 then
							valid = true
						end
					elseif var == "$mbInsanity" then						
						if snapshotData.mindbender.insanityFinal > 0 then
							valid = true
						end
					elseif var == "$mbGcds" then
						if snapshotData.mindbender.remaining.gcds > 0 then
							valid = true
						end
					elseif var == "$mbSwings" then
						if snapshotData.mindbender.remaining.swings > 0 then
							valid = true
						end
					elseif var == "$mbTime" then
						if snapshotData.mindbender.remaining.time > 0 then
							valid = true
						end
					elseif var == "$asCount" then
						if snapshotData.auspiciousSpirits.total > 0 then
							valid = true
						end
					elseif var == "$asInsanity" then
						if snapshotData.auspiciousSpirits.total > 0 then
							valid = true
						end
					elseif var == "$ttd" then
						if UnitGUID("target") ~= nil and snapshotData.target.ttd > 0 then
							valid = true
						end
					else
						valid = false					
					end

					if valid == true then
						returnText = returnText .. string.sub(input, b+2, c-1)
					end					
					p = c+1
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

local function BarText()
	--$haste
	local _hasteColor = settings.colors.text.left
	local _hasteValue = RoundTo(snapshotData.haste, settings.hastePrecision)
    
    if snapshotData.voidform.totalStacks ~= nil and snapshotData.voidform.totalStacks > 0 then        
        if settings.hasteThreshold <= snapshotData.haste then
            _hasteColor = settings.colors.text.hasteAbove    
        elseif settings.hasteApproachingThreshold <= snapshotData.haste then
            _hasteColor = settings.colors.text.hasteApproaching    
        else
            _hasteColor = settings.colors.text.hasteBelow
        end
    end

	--$gcd
	local _gcd = 1.5 / (1 + (snapshotData.haste/100))
	if _gcd > 1.5 then
		_gcd = 1.5
	elseif _gcd < 0.75 then
		_gcd = 0.75
	end
	local gcd = string.format("%.2f", _gcd)

	local hastePercent = string.format("|c%s%." .. settings.hastePrecision .. "f%%|c%s", _hasteColor, snapshotData.haste, settings.colors.text.left)
	--$vfStacks
	local voidformStacks = string.format("%.0f", snapshotData.voidform.totalStacks)
	--$vfIncoming
	local voidformStacksIncoming = string.format("%.0f", snapshotData.voidform.additionalStacks)
	
	----------
	
	--$liStacks
	local lingeringInsanityStacks = string.format("%.0f", snapshotData.lingeringInsanity.stacksLast)
	--$liTime
	local _lingeringInsanityTimeleft = 0
	if snapshotData.lingeringInsanity.timeLeftBase ~= nil and snapshotData.lingeringInsanity.lastTickTime ~= nil then
		_lingeringInsanityTimeleft = snapshotData.lingeringInsanity.timeLeftBase - (GetTime() - snapshotData.lingeringInsanity.lastTickTime)
	end
	local lingeringInsanityTime = string.format("%.1f", _lingeringInsanityTimeleft)

	----------

	--$vfDrainStacks
	local voidformDrainStacks = string.format("%.0f", snapshotData.voidform.drainStacks)
	--$vfDrain
	local voidformDrainAmount = string.format("%.1f", snapshotData.voidform.currentDrainRate)
	--$vfTime
	local voidformDrainTime = string.format("%.1f", snapshotData.voidform.remainingTime)
	
	----------

	--$insanity
	local currentInsanity = string.format("|c%s%.0f%%|r", settings.colors.text.currentInsanity, snapshotData.insanity)
	--$casting
	local castingInsanity = string.format("|c%s%.0f|r", settings.colors.text.castingInsanity, snapshotData.casting.insanityFinal)
	if snapshotData.casting.insanityFinal > 0 and characterData.talents.fotm.isSelected then        
		castingInsanity = string.format("|c%s%.2f|r", settings.colors.text.castingInsanity, snapshotData.casting.insanityFinal)
	end
	--$mbInsanity
	local mbInsanity = string.format("%.0f", snapshotData.mindbender.insanityFinal)
	--$mbGcds
	local mbGcds = string.format("%.0f", snapshotData.mindbender.remaining.gcds)
	--$mbSwings
	local mbSwings = string.format("%.0f", snapshotData.mindbender.remaining.swings)
	--$mbTime
	local mbTime = string.format("%.1f", snapshotData.mindbender.remaining.time)
	--$asCount
	local asCount = string.format("%.0f", snapshotData.auspiciousSpirits.total)
	--$asInsanity
	local _asInsanity = CalculateInsanityGain(spells.auspiciousSpirits.insanity, false) * snapshotData.auspiciousSpirits.total
	local asInsanity
	asInsanity = string.format("%.0f", _asInsanity)
	--$passive
	local _passiveInsanity = _asInsanity + snapshotData.mindbender.insanityFinal
	local passiveInsanity
	passiveInsanity = string.format("|c%s%.0f|r", settings.colors.text.passiveInsanity, _passiveInsanity)

	----------

	--$ttd
	local ttd = ""
	if snapshotData.target.ttdIsActive and snapshotData.target.ttd ~= 0 then
		local ttdMinutes = math.floor(snapshotData.target.ttd / 60)
		local ttdSeconds = snapshotData.target.ttd % 60
		ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)
	else
		ttd = "--"
	end
	----------------------------

	local returnText = {}
	returnText[0] = {}
	returnText[1] = {}
	returnText[2] = {}
	if snapshotData.voidform.totalStacks > 0 then
		returnText[0].text = settings.displayText.left.inVoidformText
		returnText[1].text = settings.displayText.middle.inVoidformText
		returnText[2].text = settings.displayText.right.inVoidformText
	else
		returnText[0].text = settings.displayText.left.outVoidformText
		returnText[1].text = settings.displayText.middle.outVoidformText
		returnText[2].text = settings.displayText.right.outVoidformText
	end

	returnText[0].color = string.format("|c%s", settings.colors.text.left)
	returnText[1].color = string.format("|c%s", settings.colors.text.middle)
	returnText[2].color = string.format("|c%s", settings.colors.text.right)

	for x = 0, 2 do
		returnText[x].text = RemoveInvalidVariablesFromBarText(returnText[x].text)
		returnText[x].text = returnText[x].color .. returnText[x].text
		returnText[x].text = string.gsub(returnText[x].text, "||n", string.format("\n") .. returnText[x].color)
		returnText[x].text = string.gsub(returnText[x].text, "$haste", hastePercent .. returnText[x].color)
		returnText[x].text = string.gsub(returnText[x].text, "$gcd", gcd)
		returnText[x].text = string.gsub(returnText[x].text, "$vfIncoming", voidformStacksIncoming)
		returnText[x].text = string.gsub(returnText[x].text, "$vfStacks", voidformStacks)
		returnText[x].text = string.gsub(returnText[x].text, "$liStacks", lingeringInsanityStacks)
		returnText[x].text = string.gsub(returnText[x].text, "$liTime", lingeringInsanityTime)
		returnText[x].text = string.gsub(returnText[x].text, "$vfDrainStacks", voidformDrainStacks)
		returnText[x].text = string.gsub(returnText[x].text, "$vfDrain", voidformDrainAmount)
		returnText[x].text = string.gsub(returnText[x].text, "$vfTime", voidformDrainTime)
		returnText[x].text = string.gsub(returnText[x].text, "$insanity", currentInsanity .. returnText[x].color)
		returnText[x].text = string.gsub(returnText[x].text, "$casting", castingInsanity .. returnText[x].color)
		returnText[x].text = string.gsub(returnText[x].text, "$passive", passiveInsanity .. returnText[x].color)		
		returnText[x].text = string.gsub(returnText[x].text, "$mbInsanity", mbInsanity)
		returnText[x].text = string.gsub(returnText[x].text, "$mbGcds", mbGcds)
		returnText[x].text = string.gsub(returnText[x].text, "$mbSwings", mbSwings)
		returnText[x].text = string.gsub(returnText[x].text, "$mbTime", mbTime)
		returnText[x].text = string.gsub(returnText[x].text, "$asCount", asCount)
		returnText[x].text = string.gsub(returnText[x].text, "$asInsanity", asInsanity)
		returnText[x].text = string.gsub(returnText[x].text, "$ttd", ttd .. returnText[x].color)
	end

	Global_TwintopInsanityBar = {
		ttd = ttd or "--",
		voidform = {
			stacks = snapshotData.voidform.totalStacks or 0,
			incomingStacks = snapshotData.voidform.additionalStacks or 0,
			drainStacks = snapshotData.voidform.drainStacks or 0,
			drain = snapshotData.voidform.currentDrainRate or 0,
			drainTime = snapshotData.voidform.remainingTime or 0
		},
		lingeringInsanity = {
			timeLeft = _lingeringInsanityTimeleft,
			stacks = snapshotData.lingeringInsanity.stacksLast or 0,
		},
		insanity = {
			insanity = snapshotData.insanity or 0,
			casting = snapshotData.casting.insanityFinal or 0,
			passive = _passiveInsanity
		},
		auspiciousSpirits = {
			count = snapshotData.auspiciousSpirits.total or 0,
			insanity = _asInsanity
		},
		mindbender = {
			insanity = snapshotData.mindbender.insanityFinal or 0,
			gcds = snapshotData.mindbender.remaining.gcds or 0,
			swings = snapshotData.mindbender.remaining.swings or 0,
			time = snapshotData.mindbender.remaining.time or 0
		}
	}

	return returnText[0].text, returnText[1].text, returnText[2].text
end

local function UpdateCastingInsanityFinal(fotm)	
	snapshotData.casting.insanityFinal = CalculateInsanityGain(snapshotData.casting.insanityRaw, fotm)
	RemainingTimeAndStackCount()
end

local function CastingSpell()
	local currentTime = GetTime()	
	local currentSpell = UnitCastingInfo("player")
	local currentChannel = UnitChannelInfo("player")
	
	if currentSpell == nil and currentChannel == nil then
		ResetCastingSnapshotData()
		return false
	else
		if currentSpell == nil then
			local spellName = select(1, currentChannel)
			if spellName == spells.mindFlay.name then
				snapshotData.casting.spellId = spells.mindFlay.id
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.insanityRaw = spells.mindFlay.insanity
				UpdateCastingInsanityFinal(spells.mindFlay.fotm)
			elseif spellName == spells.mindSear.name then --TODO: Try to figure out total targets being hit
				snapshotData.casting.spellId = spells.mindSear.id
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.insanityRaw = spells.mindSear.insanity
				UpdateCastingInsanityFinal(spells.mindSear.fotm)
			else
				ResetCastingSnapshotData()
				return false
			end
		else	
			local spellName = select(1, currentSpell)
			if spellName == spells.mindBlast.name then
				local t20p2 = GetSpellInfo(247226)
				local t20p2Stacks = select(3, FindBuffById(247226))  
				if t20p2Stacks == nil then
					t20p2Stacks = 0
				end
				
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.insanityRaw = spells.mindBlast.insanity + t20p2Stacks
				snapshotData.casting.spellId = spells.mindBlast.id
				UpdateCastingInsanityFinal(spells.mindBlast.fotm)
			elseif spellName == spells.shadowWordVoid.name then
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.insanityRaw = spells.shadowWordVoid.insanity
				snapshotData.casting.spellId = spells.shadowWordVoid.id
				UpdateCastingInsanityFinal(spells.shadowWordVoid.fotm)
			elseif spellName == spells.vampiricTouch.name then
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.insanityRaw = spells.vampiricTouch.insanity
				snapshotData.casting.spellId = spells.vampiricTouch.id
				UpdateCastingInsanityFinal(spells.vampiricTouch.fotm)
			elseif spellName == spells.darkVoid.name then
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.insanityRaw = spells.darkVoid.insanity
				snapshotData.casting.spellId = spells.darkVoid.id
				UpdateCastingInsanityFinal(spells.darkVoid.fotm)
			else
				ResetCastingSnapshotData()
				return false				
			end		
		end
		return true
	end
end

local function LingeringInsanityValues()
	local currentTime = GetTime()	
	local _, _, liCount, _, liDuration, _, _, _, _, liSpellId = FindBuffById(spells.lingeringInsanity.id)
	
	if liCount ~= nil and liCount > 0 then
		if snapshotData.lingeringInsanity.spellId == nil then
			snapshotData.lingeringInsanity.spellId = liSpellId
			snapshotData.lingeringInsanity.duration = liDuration
			snapshotData.lingeringInsanity.stacksTotal = liCount
		end
		
		if snapshotData.lingeringInsanity.stacksLast ~= liCount then
			snapshotData.lingeringInsanity.stacksLast = liCount
			snapshotData.lingeringInsanity.lastTickTime = currentTime
			snapshotData.lingeringInsanity.timeLeftBase = snapshotData.lingeringInsanity.stacksLast
			--[[ Keeping this here in case they change how the stacks on LI work.
			local timeLeftBase = snapshotData.lingeringInsanity.stacksLast / 2
			
			if mod(snapshotData.lingeringInsanity.stacksLast, 2) == 1 then
				timeLeftBase = timeLeftBase + 0.5
			end
			snapshotData.lingeringInsanity.timeLeftBase = timeLeftBase	
			]]--
		end
	else
		snapshotData.lingeringInsanity.stacksTotal = 0
		snapshotData.lingeringInsanity.stacksLast = 0
		snapshotData.lingeringInsanity.duration = 0
		snapshotData.lingeringInsanity.spellId = nil
		snapshotData.lingeringInsanity.lastTickTime = nil
		snapshotData.lingeringInsanity.timeLeftBase = 0
	end
end

local function UpdateMindbenderValues()
    local currentTime = GetTime()
    local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
	local timeRemaining = startTime+duration-currentTime
    if settings.mindbender.enabled and haveTotem and timeRemaining > 0 then
		snapshotData.mindbender.isActive = true
		if settings.mindbender.enabled then
			local swingSpeed = 1.5 / (1 + (snapshotData.haste/100))		
			if swingSpeed > 1.5 then
				swingSpeed = 1.5
			end
			
			local timeToNextSwing = swingSpeed - (currentTime - snapshotData.mindbender.swingTime)
			
			if timeToNextSwing < 0 then
				timeToNextSwing = 0
			elseif timeToNextSwing > 1.5 then
				timeToNextSwing = 1.5
			end        
			
			snapshotData.mindbender.remaining.time = timeRemaining
			snapshotData.mindbender.remaining.swings = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
			
			local gcd = swingSpeed				
			if gcd < 0.75 then
				gcd = 0.75
			end
			
			if timeRemaining > (gcd * snapshotData.mindbender.remaining.swings) then
				snapshotData.mindbender.remaining.gcds = math.ceil(((gcd * snapshotData.mindbender.remaining.swings) - timeToNextSwing) / swingSpeed)
			else
				snapshotData.mindbender.remaining.gcds = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
			end	
				
			snapshotData.mindbender.swingTime = currentTime
			
			local countValue = 0
			
			if settings.mindbender.mode == "swing" then
				if snapshotData.mindbender.remaining.swings > settings.mindbender.swingsMax then
					countValue = settings.mindbender.swingsMax
				else
					countValue = snapshotData.mindbender.remaining.swings
				end
			elseif settings.mindbender.mode == "time" then
				if snapshotData.mindbender.remaining.time > settings.mindbender.time then
					countValue = math.ceil((settings.mindbender.time - timeToNextSwing) / swingSpeed)                
				else
					countValue = math.ceil((snapshotData.mindbender.remaining.time - timeToNextSwing) / swingSpeed)
				end
			else --assume GCD
				if snapshotData.mindbender.remaining.swings > settings.mindbender.swingsMax then
					countValue = settings.mindbender.gcdsMax
				else
					countValue = snapshotData.mindbender.remaining.gcds
				end
			end

			if characterData.talents.mindbender.isSelected then
				snapshotData.mindbender.insanityRaw = countValue * spells.mindbender.insanity
			else
				snapshotData.mindbender.insanityRaw = countValue * spells.shadowfiend.insanity
			end
			snapshotData.mindbender.insanityFinal = CalculateInsanityGain(snapshotData.mindbender.insanityRaw, false)
		end
	else
		snapshotData.mindbender.onCooldown = not (GetSpellCooldown(spells.mindbender.id) == 0)
		snapshotData.mindbender.isActive = false
		snapshotData.mindbender.swingTime = 0
		snapshotData.mindbender.remaining = {}
		snapshotData.mindbender.remaining.swings = 0
		snapshotData.mindbender.remaining.gcds = 0
		snapshotData.mindbender.remaining.time = 0
		snapshotData.mindbender.insanityRaw = 0
		snapshotData.mindbender.insanityFinal = 0		
	end        
end

local function UpdateSnapshot()
	spells.s2m.isActive = select(10, FindBuffById(spells.s2m.id))
	spells.s2m.isDebuffActive = select(10, FindDebuffById(spells.s2m.debuffId))
	snapshotData.haste = UnitSpellHaste("player")
	snapshotData.insanity = UnitPower("player", SPELL_POWER_INSANITY)
	LingeringInsanityValues()
	UpdateMindbenderValues()
end

local function UpdateInsanityBar()
	if GetSpecialization() ~= 3 then
		HideInsanityBar()
		return
	end	

	if barContainerFrame:IsShown() then
		UpdateSnapshot()

		if snapshotData.insanity == 0 then
			HideInsanityBar()
		end

		RemainingTimeAndStackCount()
		
		insanityFrame:SetValue(snapshotData.insanity)
		
		if CastingSpell() then
			castingFrame:SetValue(snapshotData.insanity + snapshotData.casting.insanityFinal)
		else
			castingFrame:SetValue(snapshotData.insanity)
		end
		
		if characterData.talents.as.isSelected or snapshotData.mindbender.insanityFinal > 0 then
			passiveFrame:SetValue(snapshotData.insanity + snapshotData.casting.insanityFinal + ((CalculateInsanityGain(spells.auspiciousSpirits.insanity, false) * snapshotData.auspiciousSpirits.total) + snapshotData.mindbender.insanityFinal))
			if snapshotData.mindbender.insanityFinal > 0 and (castingFrame:GetValue() + snapshotData.mindbender.insanityFinal) < characterData.maxInsanity then
				passiveFrame.threshold:SetPoint("CENTER", passiveFrame, "LEFT", ((settings.bar.width-(settings.bar.border*2)) * ((castingFrame:GetValue() + snapshotData.mindbender.insanityFinal) / characterData.maxInsanity)), 0)
				passiveFrame.threshold.texture:Show()
			else
				passiveFrame.threshold.texture:Hide()
			end
		else
			passiveFrame.threshold.texture:Hide()
			passiveFrame:SetValue(snapshotData.insanity + snapshotData.casting.insanityFinal)
		end

		local leftText, middleText, rightText = BarText()
		leftTextFrame.font:SetText(leftText)
		middleTextFrame.font:SetText(middleText)
		rightTextFrame.font:SetText(rightText)
		
		if snapshotData.voidform.totalStacks > 0 then
			barContainerFrame:SetAlpha(1.0)
			insanityFrame.threshold:Hide()
			local gcd = GetCurrentGCDTime()	
			if snapshotData.voidform.remainingTime <= gcd then
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.inVoidform1GCD, true))
			elseif snapshotData.voidform.remainingTime <= (gcd * 2.0) then
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.inVoidform2GCD, true))
			else
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.inVoidform, true))	
			end
		else
			if characterData.voidformThreshold < characterData.maxInsanity and settings.voidEruptionThreshold then
				insanityFrame.threshold:Show()
			else
				insanityFrame.threshold:Hide()
			end

			if snapshotData.insanity >= characterData.voidformThreshold then
				insanityFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.over, true))
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.enterVoidform, true))
				if settings.colors.bar.flashEnabled then
					PulseFrame(barContainerFrame)
				--insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.enterVoidformFlash, true))
				else
					barContainerFrame:SetAlpha(1.0)
				end
			else
				insanityFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.under, true))
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base, true))
				barContainerFrame:SetAlpha(1.0)
			end
		end
	end
end

local function ResetVoidformSnapshotData()
	snapshotData.voidform.totalStacks = 0
	snapshotData.voidform.drainStacks = 0
	snapshotData.voidform.additionalStacks = 0
	snapshotData.voidform.currentDrainRate = 0
	snapshotData.voidform.duration = 0
	snapshotData.voidform.spellId = nil
	snapshotData.voidform.startTime = 0
	snapshotData.voidform.previousStackTime = 0
	snapshotData.voidform.remainingTime = 0
	snapshotData.voidform.voidTorrent.stacks = 0
	snapshotData.voidform.voidTorrent.startTime = nil
	snapshotData.voidform.dispersion.stacks = 0
	snapshotData.voidform.dispersion.startTime = nil
end

local function PrintVoidformSummary(isS2M)
	local currentTime = GetTime()
	print("--------------------------")
	if isS2M then
		print("Surrender to Madness Info:")
		print("--------------------------")
		print(string.format("S2M Duration: %.2f seconds", (currentTime-snapshotData.voidform.s2m.startTime)))
	else
		print("Voidform Info:")
		print("--------------------------")	
	end
	print(string.format("Voidform Duration: %.2f seconds", (currentTime-snapshotData.voidform.startTime)))

	if snapshotData.voidform.totalStacks > 100 then
		print(string.format("Voidform Stacks: 100 (+%.0f)", (snapshotData.voidform.totalStacks-100)))
	else
		print(string.format("Voidform Stacks: %.0f", snapshotData.voidform.totalStacks))
	end

	print(string.format("Dispersion Stacks: %.0f", snapshotData.voidform.dispersion.stacks))
	print(string.format("Void Torrent Stacks: %.0f", snapshotData.voidform.voidTorrent.stacks))
	print(string.format("Final Drain: %.0f stacks %.1f / sec", snapshotData.voidform.drainStacks, InsanityDrain(snapshotData.voidform.drainStacks)))
	print("--------------------------")
end

local function AuspiciousSpiritsCleanup(guid)
	if guid ~= nil and settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected then
		if snapshotData.auspiciousSpirits.tracker[guid] then
			snapshotData.auspiciousSpirits.total = snapshotData.auspiciousSpirits.total - snapshotData.auspiciousSpirits.tracker[guid].count
			
			if snapshotData.auspiciousSpirits.total < 0 then
				snapshotData.auspiciousSpirits.total = 0
			end
			snapshotData.auspiciousSpirits.tracker[guid] = nil
			
			snapshotData.auspiciousSpirits.units = snapshotData.auspiciousSpirits.units - 1
			
			if snapshotData.auspiciousSpirits.units < 0 then
				snapshotData.auspiciousSpirits.units = 0
			end
		end
	else
		snapshotData.auspiciousSpirits.total = 0
		snapshotData.auspiciousSpirits.units = 0
		snapshotData.auspiciousSpirits.tracker = {}
	end
end 

function timerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.ttdSinceLastUpdate = self.ttdSinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 0.05 then -- in seconds
		UpdateInsanityBar()
		self.sinceLastUpdate = 0
	end

	if snapshotData.target.ttdIsActive and self.ttdSinceLastUpdate >= settings.ttd.refreshRate then -- in seconds
		local currentTime = GetTime()
		if snapshotData.target.guid ~= UnitGUID("target") then
			snapshotData.target.guid = UnitGUID("target")
			snapshotData.target.snapshot = {}
			snapshotData.target.ttd = 0
		end
		
		local isDead = UnitIsDeadOrGhost("target")
		local currentHealth = UnitHealth("target")
		local maxHealth = UnitHealthMax("target")
		local healthDelta = 0
		local timeDelta = 0
		local dps = 0
		local ttd = 0

		local count = TableLength(snapshotData.target.snapshot)
		if count > 0 and snapshotData.target.snapshot[1] ~= nil then
			healthDelta = math.max(snapshotData.target.snapshot[1].health - currentHealth, 0)
			timeDelta = math.max(currentTime - snapshotData.target.snapshot[1].time, 0)
		end

		if isDead or currentHealth <= 0 or maxHealth <= 0 then
			dps = 0
			ttd = 0
		else
			if count == 0 or snapshotData.target.snapshot[count] == nil or
				(snapshotData.target.snapshot[1].health == currentHealth and count == settings.ttd.maxEntries) then
				dps = 0
			elseif healthDelta == 0 or timeDelta == 0 then
				dps = snapshotData.target.snapshot[count].dps
			else
				dps = healthDelta / timeDelta
			end

			if dps == nil or dps == 0 then
				ttd = 0
			else
				ttd = currentHealth / dps
			end
		end

		if count >= settings.ttd.maxEntries then
			table.remove(snapshotData.target.snapshot, 1)
		end

		table.insert(snapshotData.target.snapshot, {
			health=currentHealth,
			time=currentTime,
			dps=dps
		})

		snapshotData.target.ttd = ttd

		self.ttdSinceLastUpdate = 0
	end
end

function mindbenderAudioCueFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.sinceLastPlay = self.sinceLastPlay + sinceLastUpdate
	if self.sinceLastUpdate >= 0.05 then -- in seconds	
		if self.sinceLastPlay >= 0.75 and not snapshotData.mindbender.isActive then -- in seconds
			if settings.mindbender.useNotification.useVoidformStacks == true and not snapshotData.mindbender.onCooldown and snapshotData.voidform.totalStacks >= settings.mindbender.useNotification.thresholdStacks then
				PlaySoundFile(settings.audio.mindbender.sound, "Master", false)
				self.sinceLastPlay = 0
			elseif settings.mindbender.useNotification.useVoidformStacks == false and not snapshotData.mindbender.onCooldown and snapshotData.voidform.drainStacks >= settings.mindbender.useNotification.thresholdStacks then
				PlaySoundFile(settings.audio.mindbender.sound, "Master", false)
				self.sinceLastPlay = 0
			end
		end
		
		self.sinceLastUpdate = 0
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local currentTime = GetTime()
	local triggerUpdate = false
	
	if event == "UNIT_POWER_FREQUENT" then	
		local unit, unitPowerType = ...
		if unit == "player" and unitPowerType == "INSANITY" then
			snapshotData.insanity = UnitPower("player", SPELL_POWER_INSANITY)
      
			if snapshotData.voidform.totalStacks >= 100 then --When above 100 stacks there are no longer combat log events for Voidform stacks, need to do a manual check instead			
				if (currentTime - snapshotData.voidform.previousStackTime) >= 1 then					
					snapshotData.voidform.previousStackTime = currentTime
					snapshotData.voidform.totalStacks = snapshotData.voidform.totalStacks + 1
										
					if snapshotData.voidform.voidTorrent.startTime == nil and snapshotData.voidform.dispersion.startTime == nil then						
						snapshotData.voidform.drainStacks = snapshotData.voidform.drainStacks + 1						
					elseif snapshotData.voidform.voidTorrent.startTime ~= nil then						
						snapshotData.voidform.voidTorrent.stacks = snapshotData.voidform.voidTorrent.stacks + 1						
					else						
						snapshotData.voidform.dispersion.stacks = snapshotData.voidform.dispersion.stacks + 1						
					end                
				end				
			end
		end
					
		triggerUpdate = true
	end
	
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

		local s2mDeath = false
		
		if destGUID == characterData.guid then
			if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and
				((characterData.talents.mindbender.isSelected and sourceName == spells.mindbender.name) or 
				 (not characterData.talents.mindbender.isSelected and sourceName == spells.shadowfiend.name)) then 
				snapshotData.mindbender.swingTime = currentTime
			elseif (type == "SPELL_INSTAKILL" or type == "UNIT_DIED" or type == "UNIT_DESTROYED") then
				if snapshotData.voidform.s2m.active then -- Surrender to Madness ended
					s2mDeath = true
				end
			end	
		end
		
		if sourceGUID == characterData.guid then  
            if spellId == spells.voidform.id then
                if type == "SPELL_AURA_APPLIED" then -- Entered Voidform                    
					snapshotData.voidform.previousStackTime = currentTime
                    snapshotData.voidform.drainStacks = 1
                    snapshotData.voidform.startTime = currentTime
                    snapshotData.voidform.totalStacks = 1
                    snapshotData.voidform.voidTorrent.startTime = nil
                    snapshotData.voidform.voidTorrent.stacks = 0
                    snapshotData.voidform.dispersion.startTime = nil
                    snapshotData.voidform.dispersion.stacks = 0
					
					triggerUpdate = true
                elseif type == "SPELL_AURA_APPLIED_DOSE" then -- New Voidform Stack   
                    snapshotData.voidform.previousStackTime = currentTime
                    snapshotData.voidform.totalStacks = snapshotData.voidform.totalStacks + 1
                    
                    if snapshotData.voidform.voidTorrent.startTime == nil and snapshotData.voidform.dispersion.startTime == nil then
                        snapshotData.voidform.drainStacks = snapshotData.voidform.drainStacks + 1                        
                    elseif snapshotData.voidform.voidTorrent.startTime ~= nil then                        
                        snapshotData.voidform.voidTorrent.stacks = snapshotData.voidform.voidTorrent.stacks + 1                        
                    else                        
                        snapshotData.voidform.dispersion.stacks = snapshotData.voidform.dispersion.stacks + 1                        
                    end
					
					triggerUpdate = true
                elseif type == "SPELL_AURA_REMOVED" then -- Exited Voidform
                    if settings.showSummary == true then
						PrintVoidformSummary(false)
                    end
            
                    ResetVoidformSnapshotData()
					triggerUpdate = true
                end                
            elseif spellId == spells.voidTorrent.id then                
                if type == "SPELL_AURA_APPLIED" then -- Started channeling Void Torrent                    
                    snapshotData.voidform.voidTorrent.startTime = currentTime                    
                elseif type == "SPELL_AURA_REMOVED" and snapshotData.voidform.voidTorrent.startTime ~= nil then -- Stopped channeling Void Torrent                    
                    snapshotData.voidform.voidTorrent.startTime = nil                    
                end
					
				triggerUpdate = true
            elseif spellId == spells.dispersion.id then                
                if type == "SPELL_AURA_APPLIED" then -- Started channeling Dispersion                    
                    snapshotData.voidform.dispersion.startTime = currentTime                    
                elseif type == "SPELL_AURA_REMOVED" and snapshotData.voidform.dispersion.startTime ~= nil then -- Stopped channeling Dispersion                    
                    snapshotData.voidform.dispersion.startTime = nil                    
                end
					
				triggerUpdate = true
            elseif spellId == spells.s2m.id then                
                if type == "SPELL_AURA_APPLIED" then -- Gain Surrender to Madness   
                    snapshotData.voidform.s2m.active = true
                    snapshotData.voidform.s2m.startTime = currentTime
					UpdateCastingInsanityFinal()
					
					triggerUpdate = true
                elseif type == "SPELL_AURA_REMOVED" and snapshotData.voidform.s2m.active then -- Gain Surrender to Madness 
					s2mDeath = true
                end
			elseif settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected and spellId == spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
				if not snapshotData.auspiciousSpirits.tracker[destGUID] or snapshotData.auspiciousSpirits.tracker[destGUID] == nil then
					snapshotData.auspiciousSpirits.tracker[destGUID] = {}
					snapshotData.auspiciousSpirits.tracker[destGUID].count = 0
					snapshotData.auspiciousSpirits.units = snapshotData.auspiciousSpirits.units + 1
				end
            
				snapshotData.auspiciousSpirits.total = snapshotData.auspiciousSpirits.total + 1
				snapshotData.auspiciousSpirits.tracker[destGUID].count = snapshotData.auspiciousSpirits.tracker[destGUID].count + 1
				snapshotData.auspiciousSpirits.tracker[destGUID].lastUpdate = currentTime
				triggerUpdate = true
			elseif settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected and spellId == spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
				snapshotData.auspiciousSpirits.total = snapshotData.auspiciousSpirits.total - 1
				if snapshotData.auspiciousSpirits.tracker[destGUID] and snapshotData.auspiciousSpirits.tracker[destGUID].count > 0 then   
					snapshotData.auspiciousSpirits.tracker[destGUID].count = snapshotData.auspiciousSpirits.tracker[destGUID].count - 1
					snapshotData.auspiciousSpirits.tracker[destGUID].lastUpdate = currentTime
                
					if snapshotData.auspiciousSpirits.tracker[destGUID].count <= 0 then
						AuspiciousSpiritsCleanup(destGUID)
					end
				end
				triggerUpdate = true
			elseif type == "SPELL_CAST_FAILED" and spellId ~= spells.dispersion.id then
				local gcd = GetCurrentGCDTime()
				if snapshotData.casting.startTime == nil or currentTime > (snapshotData.casting.startTime+gcd) then
					ResetCastingSnapshotData()
					triggerUpdate = true
				end
			end
		end
		
		if settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected then
			if destGUID ~= characterData.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				AuspiciousSpiritsCleanup(destGUID)
				triggerUpdate = true
			end
			
			if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or event == "PLAYER_REGEN_ENABLED" then -- We died, or, exited combat, go ahead and purge the list
				for guid,count in pairs(snapshotData.auspiciousSpirits.tracker) do 
					AuspiciousSpiritsCleanup(guid)
				end
				
				snapshotData.auspiciousSpirits.tracker = {}
				snapshotData.auspiciousSpirits.units = 0
				snapshotData.auspiciousSpirits.total = 0
				triggerUpdate = true
			end
		end
		
		if s2mDeath then
			if settings.audio.s2mDeath.enabled then
				PlaySoundFile(settings.audio.s2mDeath.sound, "Master")
			end
			
			if settings.showS2MSummary == true then
				PrintVoidformSummary(true)
			end
			
			ResetCastingSnapshotData()
			ResetVoidformSnapshotData()
			snapshotData.voidform.s2m.startTime = nil
			snapshotData.voidform.s2m.active = false	
			triggerUpdate = true
		end
	end
				
	if triggerUpdate then
		UpdateInsanityBar()
	end
end)

function asTimerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		local newUnits = 0
		local newTotal = 0
		for guid,count in pairs(snapshotData.auspiciousSpirits.tracker) do
			if (currentTime - snapshotData.auspiciousSpirits.tracker[guid].lastUpdate) > 10 then
				AuspiciousSpiritsCleanup(guid)
			else
				newUnits = newUnits + 1
				newTotal = newTotal + snapshotData.auspiciousSpirits.tracker[guid].count
			end
		end
		snapshotData.auspiciousSpirits.units = newUnits
		snapshotData.auspiciousSpirits.total = newTotal
		UpdateInsanityBar()
		self.sinceLastUpdate = 0
	end
end

combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event =="PLAYER_REGEN_DISABLED" then
		ShowInsanityBar()
	else
		HideInsanityBar()
	end
end)

insanityFrame:RegisterEvent("ADDON_LOADED")
insanityFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
insanityFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
insanityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
insanityFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
insanityFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	local _, _, classIndex = UnitClass("player")
	if classIndex == 5 then
		local checkSpec = false

		if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
			if not addonData.loaded then
				addonData.loaded = true
				LoadDefaultSettings()
				if TwintopInsanityBarSettings then
					settings = MergeSettings(settings,TwintopInsanityBarSettings)
				end
				ConstructInsanityBar()
				ConstructOptionsPanel()

				SLASH_TWINTOP1 = "/twintop"
				SLASH_TWINTOP2 = "/tib"
			end			
		end	

		if event == "PLAYER_LOGOUT" then
			TwintopInsanityBarSettings = settings
		end
				
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
			EventRegistration()		
				
			local affectingCombat = UnitAffectingCombat("player")

			if (not affectingCombat) and (
				(not settings.displayBar.alwaysShow) and (
					(not settings.displayBar.notZeroShow) or
					(settings.displayBar.notZeroShow and snapshotData.insanity == 0))) then	
				barContainerFrame:Hide()
			end
		end
	end
end)

-- Taken from BlizzBugsSuck (which appears to be abandoned) -- https://www.curseforge.com/wow/addons/blizzbugssuck
-- Fix InterfaceOptionsFrame_OpenToCategory not actually opening the category (and not even scrolling to it)
-- Confirmed still broken in 6.2.2.20490 (6.2.2a)
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then
			local val = (Smax/(shownpanels-15))*(mypanel-2)
			InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end

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

function SlashCmdList.TWINTOP(msg)
	local cmd, subcmd = ParseCmdString(msg);
	if cmd == "reset" then
		StaticPopup_Show("TwintopInsanityBar_Reset")
	elseif cmd == "layout" then
		InterfaceOptionsFrame_OpenToCategory(interfaceSettingsFrame.barLayoutPanel)
	elseif cmd == "font" then
		InterfaceOptionsFrame_OpenToCategory(interfaceSettingsFrame.barFontPanel)
	elseif cmd == "text" then
		InterfaceOptionsFrame_OpenToCategory(interfaceSettingsFrame.barTextPanel)
	elseif cmd == "optional" then
		InterfaceOptionsFrame_OpenToCategory(interfaceSettingsFrame.optionalFeaturesPanel)
	else
		InterfaceOptionsFrame_OpenToCategory(interfaceSettingsFrame.panel)
	end
end