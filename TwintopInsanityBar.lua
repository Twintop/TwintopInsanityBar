local barContainerFrame = CreateFrame("Frame", nil, UIParent);
local insanityFrame = CreateFrame("StatusBar", nil, barContainerFrame);
local castingFrame = CreateFrame("StatusBar", nil, barContainerFrame);
local passiveFrame = CreateFrame("StatusBar", nil, barContainerFrame);

local leftTextFrame = CreateFrame("Frame", nil, barContainerFrame);
local middleTextFrame = CreateFrame("Frame", nil, barContainerFrame);
local rightTextFrame = CreateFrame("Frame", nil, barContainerFrame);

insanityFrame.threshold = CreateFrame("Frame", nil, insanityFrame);
passiveFrame.threshold = CreateFrame("Frame", nil, passiveFrame);
leftTextFrame.font = leftTextFrame:CreateFontString(nil, "BACKGROUND");
middleTextFrame.font = middleTextFrame:CreateFontString(nil, "BACKGROUND");
rightTextFrame.font = rightTextFrame:CreateFontString(nil, "BACKGROUND");

local asTimerFrame = CreateFrame("Frame");
asTimerFrame.sinceLastUpdate = 0;

local timerFrame = CreateFrame("Frame");
timerFrame.sinceLastUpdate = 0;

local combatFrame = CreateFrame("Frame");

local mindbenderAudioCueFrame = CreateFrame("Frame");
mindbenderAudioCueFrame.sinceLastPlay = 0;
mindbenderAudioCueFrame.sinceLastUpdate = 0;

local interfaceSettingsFrame = nil;

local settings = nil;

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
};

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
};

spells.mindBlast.name = select(1, GetSpellInfo(spells.mindBlast.id));
spells.mindFlay.name = select(1, GetSpellInfo(spells.mindFlay.id));
spells.mindSear.name = select(1, GetSpellInfo(spells.mindSear.id));
spells.shadowfiend.name = select(1, GetSpellInfo(spells.shadowfiend.id));
spells.shadowWordVoid.name = select(1, GetSpellInfo(spells.shadowWordVoid.id));
spells.vampiricTouch.name = select(1, GetSpellInfo(spells.vampiricTouch.id));
spells.lingeringInsanity.name = select(1, GetSpellInfo(spells.lingeringInsanity.id));

local snapshotData = {
	insanity = 0,
	haste = 0,
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
};

local addonData = {
	loaded = false,
	registered = false
};

local function FindBuffByName(spellName)
	for i = 1, 40 do
		local unitSpellName = UnitBuff("player", i);
		if not unitSpellName then
			return;
		elseif spellName == unitSpellName then
			return UnitBuff("player", i);
		end
	end
end

local function FindBuffById(spellId)
	for i = 1, 40 do
		local unitSpellId = select(10, UnitBuff("player", i));
		if not unitSpellId then
			return;
		elseif spellId == unitSpellId then
			return UnitBuff("player", i);
		end
	end
end

local function FindDebuffByName(spellName)
	for i = 1, 40 do
		local unitSpellName = UnitDebuff("player", i);
		if not unitSpellName then
			return;
		elseif spellName == unitSpellName then
			return UnitDebuff("player", i);
		end
	end
end

local function FindDebuffById(spellId)
	for i = 1, 40 do
		local unitSpellId = select(10, UnitDebuff("player", i));
		if not unitSpellId then
			return;
		elseif spellId == unitSpellId then
			print("Found", spellId);
			return UnitDebuff("player", i);
		end
	end
end


local function RoundTo(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function GetRGBAFromString(s, normalize)
    local _a = 1;
    local _r = 0;
    local _g = 1;
    local _b = 0;
    
    if not (s == nil) then        
        _a = tonumber(string.sub(s, 1, 2), 16);
        _r = tonumber(string.sub(s, 3, 4), 16);
        _g = tonumber(string.sub(s, 5, 6), 16);
        _b = tonumber(string.sub(s, 7, 8), 16);        
    end
    
	if normalize then
		return _r/255, _g/255, _b/255, _a/255;
	else
		return _r, _g, _b, _a;
	end
end

local function PulseFrame(frame)
	frame:SetAlpha(((1.0 - settings.colors.bar.flashAlpha) * math.abs(math.sin(2 * (GetTime()/settings.colors.bar.flashPeriod)))) + settings.colors.bar.flashAlpha);
end

local function GetCurrentGCDTime()
	local haste = UnitSpellHaste("player") / 100;
	
	local gcd = 1.5 / (1 + haste);
	
	if gcd < 0.75 then		
		gcd = 0.75;		
	end
	
	return gcd;
end

local function LoadDefaultSettings()
	settings = {
		version=1,
		showSummary=false,
		showS2MSummary=true,
		hasteApproachingThreshold=135,
		hasteThreshold=140,
		voidEruptionThreshold=true,
		auspiciousSpiritsTracker=true,
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
				hasteBelow="FFFFFFFF",
				hasteApproaching="FFFFFF00",
				hasteAbove="FF00FF00"
			},
			bar={
				border="FF431863",
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
			fontSize=18,
			fontFace="Fonts\\FRIZQT__.TTF",
			left={
				lingeringInsanityStacks=false,
				voidformStacks=true,
				voidformIncomingStacks=true,
				showHaste=true
			},
			middle={
				lingeringInsanityStacks=true,
				lingeringInsanityTime=true,
				voidformTime=true,
				voidformDrain=true
			},
			right={
				castingInsanity=true,
				passiveInsanity=true,
				currentInsanity=true
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
			border="Interface\\Tooltips\\UI-Tooltip-Border",
			bar="Interface\\TargetingFrame\\UI-StatusBar"
		}
	};
end

local function UpdateSettingsForNewVersion()
	if settings.version ~= 1 then
		if settings.version == nil then
			settings.version = 1;
			settings.bar.dragAndDrop=false;
		end
	end
end

local function RepositionInsanityFrameThreshold()
	insanityFrame.threshold:SetPoint("CENTER", insanityFrame, "LEFT", ((settings.bar.width-(settings.bar.border*2)) * (characterData.voidformThreshold / characterData.maxInsanity)), 0);
end

local function CheckCharacter()
	characterData.guid = UnitGUID("player");
	characterData.maxInsanity = UnitPowerMax("player", SPELL_POWER_INSANITY);
	characterData.specGroup = GetActiveSpecGroup();
	characterData.talents.fotm.isSelected = select(4, GetTalentInfo(1, 1, characterData.specGroup));
	characterData.talents.lotv.isSelected = select(4, GetTalentInfo(7, 1, characterData.specGroup));
	characterData.talents.as.isSelected = select(4, GetTalentInfo(5, 1, characterData.specGroup));
	characterData.talents.mindbender.isSelected = select(4, GetTalentInfo(6, 2, characterData.specGroup));
		
	spells.s2m.name = select(2, GetTalentInfo(7, 3, characterData.specGroup));
	spells.mindbender.name = select(2, GetTalentInfo(6, 3, characterData.specGroup));
	spells.darkVoid.name = select(2, GetTalentInfo(3, 3, characterData.specGroup));

	insanityFrame:SetMinMaxValues(0, characterData.maxInsanity);
	castingFrame:SetMinMaxValues(0, characterData.maxInsanity);	
	passiveFrame:SetMinMaxValues(0, characterData.maxInsanity);	
		
	if characterData.talents.lotv.isSelected then
		characterData.voidformThreshold = 60;
	else
		characterData.voidformThreshold = 90;
	end
	
	if characterData.voidformThreshold < characterData.maxInsanity then
		insanityFrame.threshold:Show();
		RepositionInsanityFrameThreshold();
	else
		insanityFrame.threshold:Hide();
	end
	
	local t20Head = 0;
	if IsEquippedItem(147165) then
		t20Head = 1;
	end
	
	local t20Shoulder = 0;
	if IsEquippedItem(147168) then
		t20Shoulder = 1;
	end
	
	local t20Back = 0;
	if IsEquippedItem(147163) then
		t20Back = 1;
	end
	
	local t20Chest = 0;
	if IsEquippedItem(147167) then
		t20Chest = 1;
	end
	
	local t20Hands = 0;
	if IsEquippedItem(147164) then
		t20Hands = 1;
	end
	
	local t20Legs = 0;
	if IsEquippedItem(147166) then
		t20Legs = 1;
	end
	
	characterData.items.t20Pieces = t20Head + t20Shoulder + t20Back + t20Chest + t20Hands + t20Legs;
end

local function EventRegistration()
	if GetSpecialization() == 3 then
		CheckCharacter();
		
		if settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected then
			asTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) asTimerFrame:onUpdate(sinceLastUpdate); end);
		else
			asTimerFrame:SetScript("OnUpdate", nil);
		end
		
		if settings.mindbender.useNotification.enabled then
			mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate); end);
		else
			mindbenderAudioCueFrame:SetScript("OnUpdate", nil);
		end
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate); end);
		barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT");
		barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
		addonData.registered = true;
	else
		asTimerFrame:SetScript("OnUpdate", nil);
		mindbenderAudioCueFrame:SetScript("OnUpdate", nil);
		timerFrame:SetScript("OnUpdate", nil);			
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT");
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED");
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
		addonData.registered = false;			
		barContainerFrame:Hide();
	end	
end

local function ShowInsanityBar()
	if addonData.registered == false then
		EventRegistration();
	end

	barContainerFrame:Show();
	--insanityFrame:Hide();
	--passiveFrame:Hide();
	--leftTextFrame:Hide();
	--middleTextFrame:Hide();
	--rightTextFrame:Hide();	
end

local function HideInsanityBar()
	local affectingCombat = UnitAffectingCombat("player");

	if (not affectingCombat) and (
		(not settings.displayBar.alwaysShow) and (
			(not settings.displayBar.notZeroShow) or
			(settings.displayBar.notZeroShow and snapshotData.insanity == 0))) then
		barContainerFrame:Hide();	
	else
		barContainerFrame:Show();	
	end
end

local function CaptureBarPosition()
	local point, relativeTo, relativePoint, xOfs, yOfs = barContainerFrame:GetPoint();
	local maxWidth = math.floor(GetScreenWidth());
	local maxHeight = math.floor(GetScreenHeight());

	if relativePoint == "CENTER" then
		--No action needed.
	elseif relativePoint == "TOP" then
		yOfs = ((maxHeight/2) + yOfs - (settings.bar.height/2));
	elseif relativePoint == "TOPRIGHT" then
		xOfs = ((maxWidth/2) + xOfs - (settings.bar.width/2));
		yOfs = ((maxHeight/2) + yOfs - (settings.bar.height/2));
	elseif relativePoint == "RIGHT" then
		xOfs = ((maxWidth/2) + xOfs - (settings.bar.width/2));
	elseif relativePoint == "BOTTOMRIGHT" then
		xOfs = ((maxWidth/2) + xOfs - (settings.bar.width/2));
		yOfs = -((maxHeight/2) - yOfs - (settings.bar.height/2));
	elseif relativePoint == "BOTTOM" then
		yOfs = -((maxHeight/2) - yOfs - (settings.bar.height/2));
	elseif relativePoint == "BOTTOMLEFT" then
		xOfs = -((maxWidth/2) - xOfs - (settings.bar.width/2));
		yOfs = -((maxHeight/2) - yOfs - (settings.bar.height/2));
	elseif relativePoint == "LEFT" then				
		xOfs = -((maxWidth/2) - xOfs - (settings.bar.width/2));
	elseif relativePoint == "TOPLEFT" then
		xOfs = -((maxWidth/2) - xOfs - (settings.bar.width/2));
		yOfs = ((maxHeight/2) + yOfs - (settings.bar.height/2));
	end
				
	interfaceSettingsFrame.controls.horizontal:SetValue(xOfs);
	interfaceSettingsFrame.controls.horizontal.EditBox:SetText(RoundTo(xOfs, 0));
	interfaceSettingsFrame.controls.vertical:SetValue(yOfs);
	interfaceSettingsFrame.controls.vertical.EditBox:SetText(RoundTo(yOfs, 0));	
end

local function ConstructInsanityBar()
	barContainerFrame:Show();
	barContainerFrame:SetBackdrop({edgeFile = settings.textures.border, tile = true, tileSize=4, edgeSize=settings.bar.border*4});
	barContainerFrame:ClearAllPoints();
	barContainerFrame:SetPoint("CENTER", UIParent);
	barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos);
	barContainerFrame:SetBackdropBorderColor(GetRGBAFromString(settings.colors.bar.border, true));
	barContainerFrame:SetBackdropColor(0, 0, 0, 1);
	barContainerFrame:SetWidth(settings.bar.width);
	barContainerFrame:SetHeight(settings.bar.height);
	barContainerFrame:SetFrameStrata("BACKGROUND");
	barContainerFrame:SetFrameLevel(0);
	
	barContainerFrame:SetMovable(settings.bar.dragAndDrop);
	barContainerFrame:EnableMouse(settings.bar.dragAndDrop);

	barContainerFrame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving and settings.bar.dragAndDrop then
			self:StartMoving();
			self.isMoving = true;
		end
	end);

	barContainerFrame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving and settings.bar.dragAndDrop then
			self:StopMovingOrSizing();
			CaptureBarPosition();
			self.isMoving = false;
		end
	end);

	barContainerFrame:SetScript("OnHide", function(self)
		if self.isMoving then
			self:StopMovingOrSizing();
			CaptureBarPosition();
			self.isMoving = false;
		end
	end);
	
	insanityFrame:Show();
	insanityFrame:SetMinMaxValues(0, 100);
	insanityFrame:SetHeight(settings.bar.height-(settings.bar.border*2));	
	insanityFrame:SetPoint("LEFT", barContainerFrame, "LEFT", settings.bar.border, 0);
	insanityFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", -settings.bar.border, 0);
	insanityFrame:SetStatusBarTexture(settings.textures.bar);
	insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base));
	insanityFrame:SetFrameStrata("BACKGROUND");
	insanityFrame:SetFrameLevel(100);
	
	insanityFrame.threshold:SetWidth(2);
	insanityFrame.threshold:SetHeight(settings.bar.height-(settings.bar.border*2));
	insanityFrame.threshold.texture = insanityFrame.threshold:CreateTexture(nil, "BACKGROUND");
	insanityFrame.threshold.texture:SetAllPoints(insanityFrame.threshold);
	insanityFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.under, true));
	insanityFrame.threshold:SetFrameStrata("BACKGROUND");
	insanityFrame.threshold:SetFrameLevel(500);
	insanityFrame.threshold:Show();
	
	castingFrame:Show();
	castingFrame:SetMinMaxValues(0, 100);
	castingFrame:SetHeight(settings.bar.height-(settings.bar.border*2));
	castingFrame:SetPoint("LEFT", barContainerFrame, "LEFT", settings.bar.border, 0);
	castingFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", -settings.bar.border, 0);
	castingFrame:SetStatusBarTexture(settings.textures.bar);
	castingFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.casting));
	castingFrame:SetFrameStrata("BACKGROUND");
	castingFrame:SetFrameLevel(90);
	
	passiveFrame:Show();
	passiveFrame:SetMinMaxValues(0, 100);
	passiveFrame:SetHeight(settings.bar.height-(settings.bar.border*2));
	passiveFrame:SetPoint("LEFT", barContainerFrame, "LEFT", settings.bar.border, 0);
	passiveFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", -settings.bar.border, 0);
	passiveFrame:SetStatusBarTexture(settings.textures.bar);
	passiveFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.passive));
	passiveFrame:SetFrameStrata("BACKGROUND");
	passiveFrame:SetFrameLevel(80);
	
	passiveFrame.threshold:SetWidth(2);
	passiveFrame.threshold:SetHeight(settings.bar.height-(settings.bar.border*2));
	passiveFrame.threshold.texture = passiveFrame.threshold:CreateTexture(nil, "BACKGROUND");
	passiveFrame.threshold.texture:SetAllPoints(passiveFrame.threshold);
	passiveFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.mindbender, true));
	passiveFrame.threshold:SetFrameStrata("BACKGROUND");
	passiveFrame.threshold:SetFrameLevel(500);
	passiveFrame.threshold:Show();
	
	leftTextFrame:Show();
	leftTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2));
	leftTextFrame:SetHeight(settings.bar.height);
	leftTextFrame:SetPoint("LEFT", barContainerFrame, "LEFT", settings.bar.border+2, 0);
	leftTextFrame:SetFrameStrata("BACKGROUND");
	leftTextFrame:SetFrameLevel(200);
	leftTextFrame.font:SetPoint("LEFT", 0, 0);
	leftTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0);
	leftTextFrame.font:SetJustifyH("LEFT");
	leftTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSize, "OUTLINE");
	leftTextFrame.font:Show();
	
	middleTextFrame:Show();
	middleTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2));
	middleTextFrame:SetHeight(settings.bar.height);
	middleTextFrame:SetPoint("CENTER", barContainerFrame, "CENTER", 0, 0);
	middleTextFrame:SetFrameStrata("BACKGROUND");
	middleTextFrame:SetFrameLevel(200);
	middleTextFrame.font:SetPoint("CENTER", 0, 0);
	middleTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0);
	middleTextFrame.font:SetJustifyH("CENTER");
	middleTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSize, "OUTLINE");
	middleTextFrame.font:Show();
	
	rightTextFrame:Show();
	rightTextFrame:SetWidth(settings.bar.width-(settings.bar.border*2));
	rightTextFrame:SetHeight(settings.bar.height);
	rightTextFrame:SetPoint("RIGHT", barContainerFrame, "RIGHT", -settings.bar.border, 0);
	rightTextFrame:SetFrameStrata("BACKGROUND");
	rightTextFrame:SetFrameLevel(200);
	rightTextFrame.font:SetPoint("RIGHT", 0, 0);
	rightTextFrame.font:SetTextColor(255/255, 255/255, 255/255, 1.0);
	rightTextFrame.font:SetJustifyH("RIGHT");
	rightTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSize, "OUTLINE");
	rightTextFrame.font:Show();
end

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18
local function BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent);
	f.EditBox = CreateFrame("EditBox", nil, f);
	f:SetPoint("TOPLEFT", posX, posY);
	f:SetMinMaxValues(minValue, maxValue);
	f:SetValueStep(stepValue);
	f:SetSize(sizeX, sizeY);
    f:EnableMouseWheel(true);
	f:SetObeyStepOnDrag(true);
    f:SetOrientation("Horizontal");
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true,
        edgeSize = 8,
        tileSize = 8,
        insets = {left = 3, right = 3, top = 6, bottom = 6}
    });
    f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0);
    f:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 1, 1, 1);
    end);
	f:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0);
    end);
    f:SetScript("OnMouseWheel", function(self, delta)
        if delta > 0 then
            self:SetValue(self:GetValue() + self:GetValueStep());
        else
            self:SetValue(self:GetValue() - self:GetValueStep());
        end
    end);
    f:SetScript("OnValueChanged", function(self, value)
		self.EditBox:SetText(value);
	end);	
    f.MinLabel = f:CreateFontString(nil, "Overlay");
    f.MinLabel:SetFontObject(GameFontHighlightSmall);
    f.MinLabel:SetSize(0, 14);
    f.MinLabel:SetWordWrap(false);
    f.MinLabel:SetPoint("TopLeft", f, "BottomLeft", 0, -1);
    f.MinLabel:SetText(minValue);
    f.MaxLabel = f:CreateFontString(nil, "Overlay");
    f.MaxLabel:SetFontObject(GameFontHighlightSmall);
    f.MaxLabel:SetSize(0, 14);
    f.MaxLabel:SetWordWrap(false);
    f.MaxLabel:SetPoint("TopRight", f, "BottomRight", 0, -1);
    f.MaxLabel:SetText(maxValue);
    f.Title = f:CreateFontString(nil, "Overlay");
    f.Title:SetFontObject(GameFontNormal);
    f.Title:SetSize(0, 14);
    f.Title:SetWordWrap(false);
    f.Title:SetPoint("Bottom", f, "Top");
    f.Title:SetText(title);
    f.Thumb = f:CreateTexture(nil, "Artwork");
    f.Thumb:SetSize(32, 32);
    f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal");
    f:SetThumbTexture(f.Thumb);

	local eb = f.EditBox;
    eb:EnableMouseWheel(true);
    eb:SetAutoFocus(false);
    eb:SetNumeric(false);
    eb:SetJustifyH("Center");
    eb:SetFontObject(GameFontHighlightSmall);
    eb:SetSize(50, 14);
    eb:SetPoint("Top", f, "Bottom", 0, -1);
    eb:SetTextInsets(4, 4, 0, 0);
    eb:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        edgeSize = 1,
        tileSize = 5
    });
    eb:SetBackdropColor(0, 0, 0, 1);
    eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0);
    eb:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
    end);
    eb:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
    end);
    eb:SetScript("OnMouseWheel", function(self, delta)
        if delta > 0 then
            f:SetValue(f:GetValue() + f:GetValueStep());
        else
            f:SetValue(f:GetValue() - f:GetValueStep());
        end
    end);
    eb:SetScript("OnEscapePressed", function(self)
        self:ClearFocus();
    end);
    eb:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText());
        if value then
            local min, max = f:GetMinMaxValues();
            if value >= min and value <= max then
                f:SetValue(value);
            elseif value < min then
                f:SetValue(min);
            elseif value > max then
                f:SetValue(max);
            end
			value = RoundTo(value, numDecimalPlaces);
            eb:SetText(f:GetValue());
        else
            f:SetValue(f:GetValue());
        end
        self:ClearFocus();
    end);
    eb:SetScript("OnEditFocusLost", function(self)
        self:HighlightText(0, 0);
    end);
    eb:SetScript("OnEditFocusGained", function(self)
        self:HighlightText(0, -1);
    end);
    f.Plus = CreateFrame("Button", nil, f);
    f.Plus:SetSize(18, 18);
    f.Plus:RegisterForClicks("AnyUp");
    f.Plus:SetPoint("Left", f, "Right", 0, 0);
    f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
    f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
    f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight");
    f.Plus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() + f:GetValueStep());
    end);
    f.Minus = CreateFrame("Button", nil, f);
    f.Minus:SetSize(18, 18);
    f.Minus:RegisterForClicks("AnyUp");
    f.Minus:SetPoint("Right", f, "Left", 0, 0);
    f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
    f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
    f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight");
    f.Minus:SetScript("OnClick", function(self)
        f:SetValue(f:GetValue() - f:GetValueStep());
	end);

	f:SetValue(defaultValue);
    eb:SetText(defaultValue);
	eb:SetCursorPosition(0);

	return f;
end

local function ConvertColorDecimalToHex(r, g, b, a)
	local _r, _g, _b, _a;

	if r == 0 or r == nil then
		_r = "00";
	else
		_r = string.format("%x", math.ceil(r * 255));
	end

	if g == 0 or g == nil then
		_g = "00";
	else
		_g = string.format("%x", math.ceil(g * 255));
	end
	
	if b == 0 or b == nil then
		_b = "00";
	else
		_b = string.format("%x", math.ceil(b * 255));
	end

	if a == 0 or a == nil then
		_a = "00";
	else
		_a = string.format("%x", math.ceil(a * 255));
	end

	return _a .. _r .. _g .. _b;
end

local function ShowColorPicker(r, g, b, a, callback)
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		callback, callback, callback;
	ColorPickerFrame:SetColorRGB(r, g, b);
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
	ColorPickerFrame.previousValues = {r, g, b, a};
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
end

local function BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
	local f = CreateFrame("Button", nil, parent);
	f:SetSize(sizeFrame, sizeFrame);
	f:SetPoint("TOPLEFT", posX, posY);
	f:SetBackdrop({edgeFile = settings.textures.border, tile = true, tileSize=4, edgeSize=12});
	f.Texture = f:CreateTexture(nil, "BACKGROUND");
	f.Texture:ClearAllPoints();
	f.Texture:SetPoint("TOPLEFT", 4, -4);
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4);
	f.Texture:SetColorTexture(GetRGBAFromString(settingsEntry, true));
    f:EnableMouse(true);
	f.Font = f:CreateFontString(nil, "BACKGROUND");
	f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0);
	f.Font:SetFontObject(GameFontHighlight);
	f.Font:SetText(description)
	f.Font:SetWordWrap(true);
	f.Font:SetJustifyH("LEFT");
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame);
	return f;
end

local function BuildSectionHeader(parent, title, posX, posY)
	local f = CreateFrame("Frame", nil, parent);
	f:ClearAllPoints();
	f:SetPoint("TOPLEFT", parent);
	f:SetPoint("TOPLEFT", posX, posY);
	f:SetWidth(500);
	f:SetHeight(30);
	f.font = f:CreateFontString(nil, "BACKGROUND");
	f.font:SetFontObject(GameFontNormalLarge);
	f.font:SetPoint("LEFT", f, "LEFT");
    f.font:SetSize(0, 14);
	f.font:SetJustifyH("LEFT");
	f.font:SetSize(500, 30);
	f.font:SetText(title);
	return f;
end

local function ConstructOptionsPanel()
	local xPadding = 10;
	local xPadding2 = 30;
	local xMax = 550;
	local xCoord = 0;
	local xCoord2 = 325;
	local yCoord = -5;
	local xOffset1 = 50;
	local xOffset2 = 275;
	
	local yOffset1 = 65;
	local yOffset2 = 30;
	local yOffset3 = 40;
	local yOffset4 = 20;

	local maxWidth = math.floor(GetScreenWidth());
	local minWidth = 120;
	
	local maxHeight = math.floor(GetScreenHeight());
	local minHeight = 20;
	local barWidth = 250;
	local barHeight = 20;
	local title = "";

	interfaceSettingsFrame = {};
	interfaceSettingsFrame.panel = CreateFrame("Frame", "TwintopInsanityBarPanel", UIParent);
	interfaceSettingsFrame.panel.name = "Twintop's Insanity Bar";
	local parent = interfaceSettingsFrame.panel;
	
	local controls = {};
	controls.colors = {};
	controls.checkBoxes = {};
	local f = nil;

	yCoord = -5;	
	controls.barPositionSection = BuildSectionHeader(parent, "Twintop's Insanity Bar", xCoord+xPadding, yCoord);

	StaticPopupDialogs["TwintopInsanityBar_Reset"] = {
			text = "Do you want to reset Twintop's Insanity Bar back to it's default configuration? This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				LoadDefaultSettings();
				ReloadUI();			
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		};

	yCoord = yCoord - yOffset3;
	controls.resetButton = CreateFrame("Button", "TwintopInsanityBar_ResetButton", parent)
	f = controls.resetButton;
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord+xPadding*2, yCoord);
	f:SetWidth(150);
	f:SetHeight(30);
	f:SetText("Reset to Defaults");
	f:SetNormalFontObject("GameFontNormal");
	f.ntex = f:CreateTexture();
	f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
	f.ntex:SetTexCoord(0, 0.625, 0, 0.6875);
	f.ntex:SetAllPoints()	;
	f:SetNormalTexture(f.ntex);
	f.htex = f:CreateTexture();
	f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight");
	f.htex:SetTexCoord(0, 0.625, 0, 0.6875);
	f.htex:SetAllPoints();
	f:SetHighlightTexture(f.htex);	
	f.ptex = f:CreateTexture();
	f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
	f.ptex:SetTexCoord(0, 0.625, 0, 0.6875);
	f.ptex:SetAllPoints();
	f:SetPushedTexture(f.ptex);
	f:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopInsanityBar_Reset");
	end);

	InterfaceOptions_AddCategory(interfaceSettingsFrame.panel);
	
	interfaceSettingsFrame.barLayoutPanel = CreateFrame("Frame", "TwintopInsanityBar_BarLayoutPanel", parent);
	interfaceSettingsFrame.barLayoutPanel.name = "Bar Layout and Colors";
	interfaceSettingsFrame.barLayoutPanel.parent = parent.name;
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barLayoutPanel);
	
	interfaceSettingsFrame.barTextPanel = CreateFrame("Frame", "TwintopInsanityBar_BarTextPanel", parent);
	interfaceSettingsFrame.barTextPanel.name = "Bar Text and Colors";
	interfaceSettingsFrame.barTextPanel.parent = parent.name;
	InterfaceOptions_AddCategory(interfaceSettingsFrame.barTextPanel);
	
	interfaceSettingsFrame.optionalFeaturesPanel = CreateFrame("Frame", "TwintopInsanityBar_OptionalFeaturesPanel", parent);
	interfaceSettingsFrame.optionalFeaturesPanel.name = "Optional Features";
	interfaceSettingsFrame.optionalFeaturesPanel.parent = parent.name;
	InterfaceOptions_AddCategory(interfaceSettingsFrame.optionalFeaturesPanel);

	
	yCoord = -5;
	parent = interfaceSettingsFrame.barLayoutPanel;
	controls.barPositionSection = BuildSectionHeader(parent, "Bar Position and Size", xCoord+xPadding, yCoord);
	
	yCoord = yCoord - yOffset3;
	title = "Bar Width";
	controls.width = BuildSlider(parent, title, minWidth, maxWidth, settings.bar.width, 1, 0,
								 barWidth, barHeight, xCoord+xPadding2, yCoord);
	controls.width:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end
		self.EditBox:SetText(value);
		settings.bar.width = value;
		barContainerFrame:SetWidth(value);
		insanityFrame:SetWidth(value-(settings.bar.border*2));
		castingFrame:SetWidth(value-(settings.bar.border*2));
		passiveFrame:SetWidth(value-(settings.bar.border*2));
		RepositionInsanityFrameThreshold();
	end);

	title = "Bar Height";
	controls.height = BuildSlider(parent, title, settings.bar.border*4 + 1, maxHeight, settings.bar.height, 1, 0,
									barWidth, barHeight, xCoord2, yCoord);
	controls.height:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end		
		self.EditBox:SetText(value);		
		settings.bar.height = value;
		barContainerFrame:SetHeight(value);
		insanityFrame:SetHeight(value-(settings.bar.border*2));
		insanityFrame.threshold:SetHeight(value-(settings.bar.border*2));
		castingFrame:SetHeight(value-(settings.bar.border*2));
		passiveFrame:SetHeight(value-(settings.bar.border*2));
		passiveFrame.threshold:SetHeight(value-(settings.bar.border*2));
	end);

	title = "Bar Horizontal Position";
	yCoord = yCoord - yOffset1;
	controls.horizontal = BuildSlider(parent, title, math.ceil(-maxWidth/2), math.floor(maxWidth/2), settings.bar.xPos, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord);
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end
		self.EditBox:SetText(value);		
		settings.bar.xPos = value;
		barContainerFrame:ClearAllPoints();
		barContainerFrame:SetPoint("CENTER", UIParent);
		barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos);
	end);

	title = "Bar Vertical Position";
	controls.vertical = BuildSlider(parent, title, math.ceil(-maxHeight/2), math.ceil(maxHeight/2), settings.bar.yPos, 1, 0,
								  barWidth, barHeight, xCoord2, yCoord);
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end
		self.EditBox:SetText(value);
		settings.bar.yPos = value;
		barContainerFrame:ClearAllPoints();
		barContainerFrame:SetPoint("CENTER", UIParent);
		barContainerFrame:SetPoint("CENTER", settings.bar.xPos, settings.bar.yPos);
	end);

	yCoord = yCoord - yOffset3;
	controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TIBCB1_1", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.lockPosition;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled");
	f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.";
	f:SetChecked(settings.bar.dragAndDrop);
	f:SetScript("OnClick", function(self, ...)
		settings.bar.dragAndDrop = self:GetChecked();
		barContainerFrame:SetMovable(settings.bar.dragAndDrop);
		barContainerFrame:EnableMouse(settings.bar.dragAndDrop);
	end);

	yCoord = yCoord - yOffset3;
	controls.barColorsSection = BuildSectionHeader(parent, "Bar Colors", xCoord+xPadding, yCoord);

	yCoord = yCoord - yOffset2;
	controls.colors.base = BuildColorPicker(parent, "Insanity while not in Voidform", settings.colors.bar.base, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.base;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.base.Texture:SetColorTexture(r, g, b, a);
		settings.colors.bar.base = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.base, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	controls.colors.border = BuildColorPicker(parent, "Insanity Bar's border", settings.colors.bar.border, 225, 25, xCoord2, yCoord);
	f = controls.colors.border;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		controls.colors.border.Texture:SetColorTexture(r, g, b, a);
		settings.colors.bar.border = ConvertColorDecimalToHex(r, g, b, a);
		barContainerFrame:SetBackdropBorderColor(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.border, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset2;
	controls.colors.enterVoidform = BuildColorPicker(parent, "Insanity when you can cast Void Eruption", settings.colors.bar.enterVoidform, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.enterVoidform;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.enterVoidform.Texture:SetColorTexture(r, g, b, a);
		settings.colors.bar.enterVoidform = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.enterVoidform, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	controls.colors.inVoidform = BuildColorPicker(parent, "Insanity while in Voidform", settings.colors.bar.inVoidform, 250, 25, xCoord2, yCoord);
	f = controls.colors.inVoidform;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.inVoidform.Texture:SetColorTexture(r, g, b, a);
		settings.colors.bar.inVoidform = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.inVoidform, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset2;
	controls.colors.casting = BuildColorPicker(parent, "Insanity from hardcasting spells", settings.colors.bar.casting, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.casting;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.casting.Texture:SetColorTexture(r, g, b, a);
		castingFrame:SetStatusBarColor(r, g, b, a);
		settings.colors.bar.casting = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.casting, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);	
		
	controls.colors.inVoidform2GCD = BuildColorPicker(parent, "Insanity while you have between 1-2 GCDs left in Voidform", settings.colors.bar.inVoidform2GCD, 250, 25, xCoord2, yCoord);
	f = controls.colors.inVoidform2GCD;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.inVoidform2GCD.Texture:SetColorTexture(r, g, b, a);
		settings.colors.bar.inVoidform2GCD = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.inVoidform2GCD, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset2;
	controls.colors.thresholdUnder = BuildColorPicker(parent, "Under min. req. Insanity to cast Void Eruption Threshold Line", settings.colors.threshold.under, 260, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.thresholdUnder;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, a);
		settings.colors.threshold.under = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.threshold.under, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	controls.colors.inVoidform1GCD = BuildColorPicker(parent, "Insanity while you have less than 1 GCD left in Voidform", settings.colors.bar.inVoidform1GCD, 250, 25, xCoord2, yCoord);
	f = controls.colors.inVoidform1GCD;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.inVoidform1GCD.Texture:SetColorTexture(r, g, b, a);
		settings.colors.bar.inVoidform1GCD = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.inVoidform1GCD, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset2;
	controls.colors.thresholdOver = BuildColorPicker(parent, "Over min. req. Insanity to cast Void Eruption Threshold Line", settings.colors.threshold.over, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.thresholdOver;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end

		controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, a);
		settings.colors.threshold.over = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.threshold.over, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);
	
	yCoord = yCoord - yOffset3;
	controls.barDisplaySection = BuildSectionHeader(parent, "Bar Display", xCoord+xPadding, yCoord);

	yCoord = yCoord - yOffset3;

	title = "Void Eruption Flash Alpha";
	controls.flashAlpha = BuildSlider(parent, title, 0, 1, settings.colors.bar.flashAlpha, 0.01, 2,
								 barWidth, barHeight, xCoord+xPadding2, yCoord);
	controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end	

		value = RoundTo(value, 2);
		self.EditBox:SetText(value);
		settings.colors.bar.flashAlpha = value;
	end);

	title = "Void Eruption Flash Period (sec)";
	controls.flashPeriod = BuildSlider(parent, title, 0, 2, settings.colors.bar.flashPeriod, 0.05, 2,
									barWidth, barHeight, xCoord2, yCoord);
	controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end

		value = RoundTo(value, 2);
		self.EditBox:SetText(value);		
		settings.colors.bar.flashPeriod = value;
	end);

	yCoord = yCoord - yOffset3;
	controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TIBRB1_2", parent, "UIRadioButtonTemplate");
	f = controls.checkBoxes.alwaysShow;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Always show Insanity Bar");
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight);
	f.tooltip = "This will make the Insanity Bar always visible on your UI, even when out of combat.";
	f:SetChecked(settings.displayBar.alwaysShow);
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(true);
		controls.checkBoxes.notZeroShow:SetChecked(false);
		controls.checkBoxes.combatShow:SetChecked(false);
		settings.displayBar.alwaysShow = true;
		settings.displayBar.notZeroShow = false;
		HideInsanityBar();
	end);

	controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TIBRB1_3", parent, "UIRadioButtonTemplate");
	f = controls.checkBoxes.notZeroShow;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-15);
	getglobal(f:GetName() .. 'Text'):SetText("Show Insanity Bar when Insanity > 0");
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight);
	f.tooltip = "This will make the Insanity Bar show out of combat only if Insanity > 0, hidden otherwise when out of combat.";
	f:SetChecked(settings.displayBar.notZeroShow);
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(false);
		controls.checkBoxes.notZeroShow:SetChecked(true);
		controls.checkBoxes.combatShow:SetChecked(false);
		settings.displayBar.alwaysShow = false;
		settings.displayBar.notZeroShow = true;
		HideInsanityBar();
	end);

	controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TIBRB1_4", parent, "UIRadioButtonTemplate");
	f = controls.checkBoxes.combatShow;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-30);
	getglobal(f:GetName() .. 'Text'):SetText("Only show Insanity Bar in combat");
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight);
	f.tooltip = "This will make the Insanity Bar only be visible on your UI when in combat.";
	f:SetChecked((not settings.displayBar.alwaysShow) and (not settings.displayBar.notZeroShow));
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.alwaysShow:SetChecked(false);
		controls.checkBoxes.notZeroShow:SetChecked(false);
		controls.checkBoxes.combatShow:SetChecked(true);
		settings.displayBar.alwaysShow = false;
		settings.displayBar.notZeroShow = false;
		HideInsanityBar();
	end);


	controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TIBCB1_5", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.flashEnabled;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Void Eruption Usable");
	f.tooltip = "This will flash the bar when Void Eruption can be cast.";
	f:SetChecked(settings.voidEruptionThreshold);
	f:SetScript("OnClick", function(self, ...)
		settings.voidEruptionThreshold = self:GetChecked();
	end);

	controls.checkBoxes.vfThresholdShow = CreateFrame("CheckButton", "TIBCB1_6", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.vfThresholdShow;
	f:SetPoint("TOPLEFT", xCoord2, yCoord-20);
	getglobal(f:GetName() .. 'Text'):SetText("Show Void Eruption Threshold Line");
	f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Void Eruption.";
	f:SetChecked(settings.voidEruptionThreshold);
	f:SetScript("OnClick", function(self, ...)
		settings.voidEruptionThreshold = self:GetChecked();
	end);

	------------------------------------------------

	yCoord = -5;
	parent = interfaceSettingsFrame.barTextPanel;

	controls.textDisplaySection = BuildSectionHeader(parent, "Text Display", xCoord+xPadding, yCoord);

	title = "Bar Font Size";
	yCoord = yCoord - yOffset3;
	controls.fontSize = BuildSlider(parent, title, 6, 72, settings.displayText.fontSize, 1, 0,
								  barWidth, barHeight, xCoord+xPadding2, yCoord);
	controls.fontSize:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end
		self.EditBox:SetText(value);		
		settings.displayText.fontSize = value;
		leftTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSize, "OUTLINE");
		middleTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSize, "OUTLINE");
		rightTextFrame.font:SetFont(settings.displayText.fontFace, settings.displayText.fontSize, "OUTLINE");
	end);

	controls.checkBoxes.textMiddleLIS = CreateFrame("CheckButton", "TIBCB2_M1", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textMiddleLIS;
	f:SetPoint("TOPLEFT", xCoord2, yCoord+5);
	getglobal(f:GetName() .. 'Text'):SetText("Middle: Show Lingering Insanity Stacks");
	f.tooltip = "Show Lingering Insanity stacks remaining in middle of the bar when not in Voidform.";
	f:SetChecked(settings.displayText.middle.lingeringInsanityStacks);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.middle.lingeringInsanityStacks = self:GetChecked();
	end);

	controls.checkBoxes.textMiddleLIT = CreateFrame("CheckButton", "TIBCB2_M2", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textMiddleLIT;
	f:SetPoint("TOPLEFT", xCoord2, yCoord-15);
	getglobal(f:GetName() .. 'Text'):SetText("Middle: Show Lingering Insanity Time");
	f.tooltip = "Show Lingering Insanity effective duration remaining in middle of the bar when not in Voidform.";
	f:SetChecked(settings.displayText.middle.lingeringInsanityTime);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.middle.lingeringInsanityTime = self:GetChecked();
	end);

	yCoord = yCoord - yOffset3 + 5;
	controls.checkBoxes.textLeftHaste = CreateFrame("CheckButton", "TIBCB2_L1", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textLeftHaste;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Left: Show Haste Percentage");
	f.tooltip = "Show the current Haste Percentage on the far left of the bar.";
	f:SetChecked(settings.displayText.left.showHaste);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.left.showHaste = self:GetChecked();
	end);

	controls.checkBoxes.textMiddleVD = CreateFrame("CheckButton", "TIBCB2_M3", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textMiddleVD;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Middle: Show Current Voidform Drain");
	f.tooltip = "Show the current Insanity drain based on Insanity Drain Stacks, in Insanity/sec.";
	f:SetChecked(settings.displayText.middle.voidformDrain);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.middle.voidformDrain = self:GetChecked();
	end);
	
	yCoord = yCoord - yOffset4;
	controls.checkBoxes.textLeftVF = CreateFrame("CheckButton", "TIBCB2_L2", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textLeftVF;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Left: Show Voidform Stacks");
	f.tooltip = "Show the number of stacks of Voidform.";
	f:SetChecked(settings.displayText.left.voidformStacks);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.left.voidformStacks = self:GetChecked();
	end);

	controls.checkBoxes.textMiddleVTR = CreateFrame("CheckButton", "TIBCB2_M4", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textMiddleVTR;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Middle: Show Voidform Time");
	f.tooltip = "Show the amount of time, in seconds, that your current Voidform is expected to last based on current Insanity levels.";
	f:SetChecked(settings.displayText.middle.voidformTime);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.middle.voidformTime = self:GetChecked();
	end);

	yCoord = yCoord - yOffset4;
	controls.checkBoxes.textLeftIVF = CreateFrame("CheckButton", "TIBCB2_L3", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textLeftIVF;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Left: Show Incoming Voidform Stacks");
	f.tooltip = "Show the number of incoming stacks of Voidform based on the expected remaining duration of Voidform.";
	f:SetChecked(settings.displayText.left.voidformIncomingStacks);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.left.voidformIncomingStacks = self:GetChecked();
	end);

	controls.checkBoxes.textRightCaI = CreateFrame("CheckButton", "TIBCB2_R1", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textRightCaI;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Right: Show Casting Insanity Value");
	f.tooltip = "Show the amount of incoming Insanity from hardcasted spells.";
	f:SetChecked(settings.displayText.right.castingInsanity);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.right.castingInsanity = self:GetChecked();
	end);

	yCoord = yCoord - yOffset4;
	controls.checkBoxes.textLeftLI = CreateFrame("CheckButton", "TIBCB2_L4", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textLeftLI;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Left: Show Lingering Insanity Stacks");
	f.tooltip = "Show Lingering Insanity stacks on left side of bar next to Haste% when not in Voidform. Old style (pre 7.1.5) display.";
	f:SetChecked(settings.displayText.left.lingeringInsanityStacks);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.left.lingeringInsanityStacks = self:GetChecked();
	end);

	controls.checkBoxes.textRightCuI = CreateFrame("CheckButton", "TIBCB2_R2", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textRightCuI;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Right: Show Current Insanity Value");
	f.tooltip = "Show the current amount of Insanity.";
	f:SetChecked(settings.displayText.right.currentInsanity);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.right.currentInsanity = self:GetChecked();
	end);
	
	yCoord = yCoord - yOffset2;	
	controls.textColorsSection = BuildSectionHeader(parent, "Text Colors", xCoord+xPadding, yCoord);
	
	yCoord = yCoord - yOffset2;	
	controls.colors.currentInsanityText = BuildColorPicker(parent, "Current Insanity", settings.colors.text.currentInsanity, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.currentInsanityText;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.currentInsanityText.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.currentInsanity = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.currentInsanity, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);
	
	controls.colors.leftText = BuildColorPicker(parent, "Left Text (Except Haste% in Voidform)", settings.colors.text.left, 250, 25, xCoord2, yCoord);
	f = controls.colors.leftText;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.leftText.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.left = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.left, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset2;	
	controls.colors.castingInsanityText = BuildColorPicker(parent, "Insanity from hardcasting spells", settings.colors.text.castingInsanity, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.castingInsanityText;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.castingInsanityText.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.castingInsanity = ConvertColorDecimalToHex(r, g, b, a);
		barContainerFrame:SetBackdropBorderColor(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.currentInsanity, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	controls.colors.middleText = BuildColorPicker(parent, "Middle Text", settings.colors.text.middle, 225, 25, xCoord2, yCoord);
	f = controls.colors.middleText;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.middleText.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.middle = ConvertColorDecimalToHex(r, g, b, a);
		barContainerFrame:SetBackdropBorderColor(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.middle, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);
	
	yCoord = yCoord - yOffset1;	
	title = "Low to Medium Haste% Threshold in Voidform";
	controls.hasteApproachingThreshold = BuildSlider(parent, title, 0, 500, settings.hasteApproachingThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord);
	controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		elseif value > settings.hasteThreshold then
			value = settings.hasteThreshold;
		end

		value = RoundTo(value, 2);
		self.EditBox:SetText(value);		
		settings.hasteApproachingThreshold = value;
	end);

	controls.colors.hasteBelow = BuildColorPicker(parent, "Low Haste% in Voidform", settings.colors.text.hasteBelow,
												250, 25, xCoord2, yCoord+10);
	f = controls.colors.hasteBelow;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.hasteBelow.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.hasteBelow = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.hasteBelow, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	controls.colors.hasteApproaching = BuildColorPicker(parent, "Medium Haste% in Voidform", settings.colors.text.hasteApproaching,
												250, 25, xCoord2, yCoord-30);
	f = controls.colors.hasteApproaching;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.hasteApproaching.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.hasteApproaching = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.hasteApproaching, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	controls.colors.hasteAbove = BuildColorPicker(parent, "High Haste% in Voidform", settings.colors.text.hasteAbove,
												250, 25, xCoord2, yCoord-70);
	f = controls.colors.hasteAbove;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		--Text doesn't care about Alpha, but the color picker does!
		a = 1.0;

		controls.colors.hasteAbove.Texture:SetColorTexture(r, g, b, a);
		settings.colors.text.hasteAbove = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.text.hasteAbove, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset1;	
	title = "Medium to High Haste% Threshold in Voidform";
	controls.hasteThreshold = BuildSlider(parent, title, 0, 500, settings.hasteThreshold, 0.25, 2,
									barWidth, barHeight, xCoord+xPadding2, yCoord);
	controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		elseif value < settings.hasteApproachingThreshold then
			value = settings.hasteApproachingThreshold;
		end

		value = RoundTo(value, 2);
		self.EditBox:SetText(value);		
		settings.hasteThreshold = value;
	end);

	---------------------------

	yCoord = -5;
	parent = interfaceSettingsFrame.optionalFeaturesPanel;

	controls.textSection = BuildSectionHeader(parent, "Passive Options", xCoord+xPadding, yCoord);

	yCoord = yCoord - yOffset2;
	controls.checkBoxes.textRightPI = CreateFrame("CheckButton", "TIBCB3_1", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.textRightPI;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Right Text: Show Passive Insanity Value");
	f.tooltip = "Show the amount of incoming Insanity from Auspicious Spirits and Mindbender.";
	f:SetChecked(settings.displayText.right.passiveInsanity);
	f:SetScript("OnClick", function(self, ...)
		settings.displayText.right.passiveInsanity = self:GetChecked();
	end);

	controls.checkBoxes.s2mDeath = CreateFrame("CheckButton", "TIBCB3_2", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.s2mDeath;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Play Wilhelm Scream when S2M Ends");
	f.tooltip = "When you (almost) die, horribly, after Surrender to Madness ends, play the infamous Wilhelm Scream to make you feel a bit better.";
	f:SetChecked(settings.audio.s2mDeath.enabled);
	f:SetScript("OnClick", function(self, ...)
		settings.audio.s2mDeath.enabled = self:GetChecked();
	end);

	yCoord = yCoord - yOffset4;
	controls.checkBoxes.showSummary = CreateFrame("CheckButton", "TIBCB3_3", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.showSummary;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Show Voidform Summary");
	f.tooltip = "Shows a summary in chat of your last Voidform including total duration, total stacks, final drain rate, and stacks gained while channeling Void Torrent.";
	f:SetChecked(settings.showSummary);
	f:SetScript("OnClick", function(self, ...)
		settings.showSummary = self:GetChecked();
	end);

	--[[
	controls.checkBoxes.showS2MSummary = CreateFrame("CheckButton", "TIBCB3_4", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.showS2MSummary;
	f:SetPoint("TOPLEFT", xCoord2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Show Surrender to Madness Summary");
	f.tooltip = "Shows a summary in chat of your last Surrender to Madness, including total duration of S2M, total duration of Voidform, total stacks, final drain rate, and stacks gained while channeling Void Torrent.";
	f:SetChecked(settings.showS2MSummary);
	f:SetScript("OnClick", function(self, ...)
		settings.showS2MSummary = self:GetChecked();
	end);
	]]--

	yCoord = yCoord - yOffset3;
	controls.colors.passive = BuildColorPicker(parent, "Insanity from Auspicious Spirits and Shadowfiend swings", settings.colors.bar.passive, 250, 25, xCoord+xPadding*2, yCoord);
	f = controls.colors.passive;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		
		controls.colors.passive.Texture:SetColorTexture(r, g, b, a);
		passiveFrame:SetStatusBarColor(r, g, b, a);
		settings.colors.bar.passive = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.bar.passive, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset2;
	controls.textSection = BuildSectionHeader(parent, "Auspicious Spirits Tracking", xCoord+xPadding, yCoord);

	yCoord = yCoord - yOffset2;
	controls.checkBoxes.as = CreateFrame("CheckButton", "TIBCB3_5", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.as;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Track Auspicious Spirits");
	f.tooltip = "Track Shadowy Apparitions in flight that will generate Insanity upon reaching their target with the Auspicious Spirits talent.";
	f:SetChecked(settings.auspiciousSpiritsTracker);
	f:SetScript("OnClick", function(self, ...)
		settings.auspiciousSpiritsTracker = self:GetChecked();
		
		if settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected and GetSpecialization() == 3 then
			asTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) asTimerFrame:onUpdate(sinceLastUpdate); end);
		else
			asTimerFrame:SetScript("OnUpdate", nil);
		end	
		snapshotData.auspiciousSpirits.total = 0;
		snapshotData.auspiciousSpirits.units = 0;
		snapshotData.auspiciousSpirits.tracker = {};
	end);

	yCoord = yCoord - yOffset2;
	controls.textSection = BuildSectionHeader(parent, "Shadowfiend (+ Mindbender) Tracking", xCoord+xPadding, yCoord);

	yCoord = yCoord - yOffset2;	
	controls.checkBoxes.mindbender = CreateFrame("CheckButton", "TIBCB3_6", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.mindbender;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend Insanity Gain");
	f.tooltip = "Show the gain of Insanity over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below.";
	f:SetChecked(settings.mindbender.enabled);
	f:SetScript("OnClick", function(self, ...)
		settings.mindbender.enabled = self:GetChecked();
	end);

	controls.colors.mindbenderThreshold = BuildColorPicker(parent, "Shadowfiend Insanity Gain Threshold Line", settings.colors.bar.passive, 250, 25, xCoord2, yCoord);
	f = controls.colors.mindbenderThreshold;
	f.recolorTexture = function(color)
		local r, g, b, a;
		if color then
			r, g, b, a = unpack(color);
		else
			r, g, b = ColorPickerFrame:GetColorRGB();
			a = OpacitySliderFrame:GetValue();
		end
		
		controls.colors.mindbenderThreshold.Texture:SetColorTexture(r, g, b, a);
		passiveFrame:SetStatusBarColor(r, g, b, a);
		settings.colors.threshold.mindbender = ConvertColorDecimalToHex(r, g, b, a);
	end
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			local r, g, b, a = GetRGBAFromString(settings.colors.threshold.mindbender, true);
			ShowColorPicker(r, g, b, a, self.recolorTexture);
		end
	end);

	yCoord = yCoord - yOffset1;	
	controls.checkBoxes.mindbenderModeGCDs = CreateFrame("CheckButton", "TIBRB3_7", parent, "UIRadioButtonTemplate");
	f = controls.checkBoxes.mindbenderModeGCDs;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from GCDs remaining");
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight);
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X GCDs, based on player's current GCD.";
	if settings.mindbender.mode == "gcd" then
		f:SetChecked(true);
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(true);
		controls.checkBoxes.mindbenderModeSwings:SetChecked(false);
		controls.checkBoxes.mindbenderModeTime:SetChecked(false);
		settings.mindbender.mode = "gcd";
	end);

	title = "Shadowfiend GCDs - 0.75sec Floor";
	controls.mindbenderGCDs = BuildSlider(parent, title, 1, 10, settings.mindbender.gcdsMax, 1, 0,
									barWidth, barHeight, xCoord2, yCoord);
	controls.mindbenderGCDs:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end

		self.EditBox:SetText(value);		
		settings.mindbender.gcdsMax = value;
	end);


	yCoord = yCoord - yOffset1;	
	controls.checkBoxes.mindbenderModeSwings = CreateFrame("CheckButton", "TIBRB3_8", parent, "UIRadioButtonTemplate");
	f = controls.checkBoxes.mindbenderModeSwings;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from Swings remaining");
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight);
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X melee swings from Shadowfiend/Mindbender. This is only different from the GCD option if you are above 200% haste (GCD cap).";
	if settings.mindbender.mode == "swing" then
		f:SetChecked(true);
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(false);
		controls.checkBoxes.mindbenderModeSwings:SetChecked(true);
		controls.checkBoxes.mindbenderModeTime:SetChecked(false);
		settings.mindbender.mode = "swing";
	end);

	title = "Shadowfiend Swings - No Floor";
	controls.mindbenderSwings = BuildSlider(parent, title, 1, 10, settings.mindbender.swingsMax, 1, 0,
									barWidth, barHeight, xCoord2, yCoord);
	controls.mindbenderSwings:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end

		self.EditBox:SetText(value);		
		settings.mindbender.swingsMax = value;
	end);

	yCoord = yCoord - yOffset1;	
	controls.checkBoxes.mindbenderModeTime = CreateFrame("CheckButton", "TIBRB3_9", parent, "UIRadioButtonTemplate");
	f = controls.checkBoxes.mindbenderModeTime;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Insanity from Time remaining");
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight);
	f.tooltip = "Shows the amount of Insanity incoming over the up to next X seconds.";
	if settings.mindbender.mode == "time" then
		f:SetChecked(true);
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.mindbenderModeGCDs:SetChecked(false);
		controls.checkBoxes.mindbenderModeSwings:SetChecked(false);
		controls.checkBoxes.mindbenderModeTime:SetChecked(true);
		settings.mindbender.mode = "time";
	end);

	title = "Shadowfiend Time Remaining";
	controls.mindbenderTime = BuildSlider(parent, title, 0, 15, settings.mindbender.timeMax, 0.25, 2,
									barWidth, barHeight, xCoord2, yCoord);
	controls.mindbenderTime:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end

		value = RoundTo(value, 2);
		self.EditBox:SetText(value);		
		settings.mindbender.timeMax = value;
	end);

	yCoord = yCoord - yOffset1;	
	yCoord = yCoord - yOffset2;	
	controls.checkBoxes.mindbenderAudio = CreateFrame("CheckButton", "TIBCB3_10", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.mindbenderAudio;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord);
	getglobal(f:GetName() .. 'Text'):SetText("Play Audio Cue to use Shadowfiend");
	f.tooltip = "Plays an audio cue when in Voidform, Shadowfiend/Mindbender is offcooldown, and the number of Drain Stacks is above a certain threshold.";
	f:SetChecked(settings.mindbender.useNotification.enabled);
	f:SetScript("OnClick", function(self, ...)
		settings.mindbender.useNotification.enabled = self:GetChecked();
		if settings.mindbender.useNotification.enabled then
			mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate); end);
		else
			mindbenderAudioCueFrame:SetScript("OnUpdate", nil);
		end
	end);

	controls.checkBoxes.mindbenderAudioStacks = CreateFrame("CheckButton", "TIBCB3_11", parent, "ChatConfigCheckButtonTemplate");
	f = controls.checkBoxes.mindbenderAudioStacks;
	f:SetPoint("TOPLEFT", xCoord+xPadding*2, yCoord-20);
	getglobal(f:GetName() .. 'Text'):SetText("Use Voidform Stacks instead of Drain Stacks");
	f.tooltip = "Uses the current Voidform Stacks instead of computed Drain Stacks for the audio cue.";
	f:SetChecked(settings.mindbender.useNotification.useVoidformStacks);
	f:SetScript("OnClick", function(self, ...)
		settings.mindbender.useNotification.useVoidformStacks = self:GetChecked();
	end);

	title = "Stacks to Trigger Audio Cue";
	controls.mindbenderStacks = BuildSlider(parent, title, 1, 100, settings.mindbender.useNotification.thresholdStacks, 1, 0,
									barWidth, barHeight, xCoord2, yCoord);
	controls.mindbenderStacks:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues();
		if value > max then
			value = max;
		elseif value < min then
			value = min;
		end

		self.EditBox:SetText(value);		
		settings.mindbender.useNotification.thresholdStacks = value;
	end);

	interfaceSettingsFrame.controls = controls;
	
end

local function InsanityDrain(stacks)
    local pct = 1.00;
    if characterData.items.t20Pieces >= 4 then
        if snapshotData.voidform.s2m.active then
            pct = 0.95;
        else
            pct = 0.90;
        end
    end    
    
    return (6.0 + ((stacks - 1) * 0.92)) * pct;
end

local function RemainingTimeAndStackCount()
    local currentTime = GetTime();
    local _
	_, _, _, _, snapshotData.voidform.duration, _, _, _, _, snapshotData.voidform.spellId = FindBuffById(spells.voidform.id);
    	
    if snapshotData.voidform.spellId == nil then		
		snapshotData.voidform.totalStacks = 0;
		snapshotData.voidform.drainStacks = 0;
		snapshotData.voidform.additionalStacks = 0;
		snapshotData.voidform.currentDrainRate = 0;
		snapshotData.voidform.duration = 0;
		snapshotData.voidform.spellId = nil;
		snapshotData.voidform.startTime = 0;
		snapshotData.voidform.previousStackTime = 0;
		snapshotData.voidform.remainingTime = 0;
		snapshotData.voidform.voidTorrent.stacks = 0;
		snapshotData.voidform.voidTorrent.startTime = nil;
		snapshotData.voidform.dispersion.stacks = 0;
		snapshotData.voidform.dispersion.startTime = nil;
    else
		local down, up, lagHome, lagWorld = GetNetStats();
		local TimeDiff = currentTime - snapshotData.voidform.previousStackTime;        
		local remainingInsanity = tonumber(snapshotData.insanity);
		
		local remainingTime = 0;
		local moreStacks = 0;
		local latency = lagWorld / 1000;
		local workingStack = snapshotData.voidform.drainStacks;
		local startingStack = workingStack;
		
		while (remainingInsanity > 0)
		do
			moreStacks = moreStacks+1;
			local drain = InsanityDrain(workingStack);
			local stackTime = 1.0;
			
			if workingStack == startingStack then					
				stackTime = 1.0 - TimeDiff + latency;					
			end
			
			if (stackTime > 0) then                    
				if (drain * stackTime) >= remainingInsanity then                       
					stackTime = remainingInsanity / drain;
					remainingInsanity = 0;
				else
					remainingInsanity = remainingInsanity - (drain * stackTime);
				end
				
				remainingTime = remainingTime + stackTime;
			end               
			
			workingStack = workingStack + 1;
		end
		
		snapshotData.voidform.remainingTime = remainingTime;
		snapshotData.voidform.currentDrainRate = InsanityDrain(snapshotData.voidform.drainStacks);
		snapshotData.voidform.additionalStacks = moreStacks;
    end  
end

local function CalculateInsanityGain(insanity, fotm)
	local modifier = 1.0;
	
	if fotm and characterData.talents.fotm.isSelected then
		modifier = modifier * characterData.talents.fotm.modifier;
	end
	
	--TODO: Add check for S2M debuff and make incoming insanity gain 0 while up
	if spells.s2m.isActive then
		modifier = modifier * spells.s2m.modifier;
	end

	if spells.s2m.isDebuffActive then
		modifier = modifier * spells.s2m.modifierDebuff;
	end
	
	return insanity * modifier;	
end

local function ResetCastingSnapshotData()
	snapshotData.casting.spellId = nil;
	snapshotData.casting.startTime = nil;
	snapshotData.casting.endTime = nil;
	snapshotData.casting.insanityRaw = 0;
	snapshotData.casting.insanityFinal = 0;
end

local function BarTextLeft()    
    local returnString = "";
    local hasteColor = settings.colors.text.left;
    
    if snapshotData.voidform.totalStacks ~= nil and snapshotData.voidform.totalStacks > 0 then        
        if settings.hasteThreshold <= snapshotData.haste then
            hasteColor = settings.colors.text.hasteAbove;    
        elseif settings.hasteApproachingThreshold <= snapshotData.haste then
            hasteColor = settings.colors.text.hasteApproaching;    
        else
            hasteColor = settings.colors.text.hasteBelow;
        end
    end
	
	if settings.displayText.left.showHaste then
		returnString = string.format("|c%s%.2f%%|c%s", hasteColor, snapshotData.haste, settings.colors.text.left);
	end

	if snapshotData.voidform.totalStacks > 0 then
		if returnString ~= "" and settings.displayText.left.voidformIncomingStacks or settings.displayText.left.voidformStacks then
			returnString = returnString .. " - ";
		end

		if settings.displayText.left.voidformStacks then
			returnString = returnString .. string.format("%.0f ", snapshotData.voidform.totalStacks);
		end
		
		if settings.displayText.left.voidformIncomingStacks then
			returnString = returnString .. string.format("(+%.0f) ", snapshotData.voidform.additionalStacks);                
		end

		if settings.displayText.left.voidformIncomingStacks or settings.displayText.left.voidformStacks then
			returnString = returnString .. string.format("VF");
		end
	else            
		if settings.displayText.left.lingeringInsanityStacks and snapshotData.lingeringInsanity.stacksLast ~= nil and snapshotData.lingeringInsanity.stacksLast > 0 then
			if returnString ~= "" then
				returnString = returnString .. " - ";
			end

			returnString = returnString .. string.format("%.0f LI", snapshotData.lingeringInsanity.stacksLast);                
		end
	end
    return returnString;
end

local function BarTextMiddle()    
    local returnString =  string.format("|c%s", settings.colors.text.middle);
    
	if snapshotData.voidform.currentDrainRate == 0 then
		if (settings.displayText.middle.lingeringInsanityStacks or settings.displayText.middle.lingeringInsanityTime) and snapshotData.lingeringInsanity.stacksLast ~= nil and snapshotData.lingeringInsanity.stacksLast > 0 then
			if settings.displayText.middle.lingeringInsanityStacks then
				returnString = returnString .. string.format("%.0f LI", snapshotData.lingeringInsanity.stacksLast);
			end
			
			if settings.displayText.middle.lingeringInsanityStacks and settings.displayText.middle.lingeringInsanityTime then
				returnString = returnString .. string.format(" - ");    
			end
			
			if settings.displayText.middle.lingeringInsanityTime then                    
				local timeleft = snapshotData.lingeringInsanity.timeLeftBase - (GetTime() - snapshotData.lingeringInsanity.lastTickTime);                    
				returnString = returnString .. string.format("%.1f sec", timeleft);                    
			end                
		end
	else            
		if settings.displayText.middle.voidformTime then
			returnString = returnString .. string.format("%.1f sec", snapshotData.voidform.remainingTime);
		end 
		
		if settings.displayText.middle.voidformTime and settings.displayText.middle.voidformDrain then
			returnString = returnString .. string.format(" - ");
		end
		
		if settings.displayText.middle.voidformDrain then                
			returnString = returnString .. string.format("%.1f/sec", snapshotData.voidform.currentDrainRate);
		end
	end    
    return returnString;
end

local function BarTextRight()    
    local passiveInsanity = (CalculateInsanityGain(spells.auspiciousSpirits.insanity, false) * snapshotData.auspiciousSpirits.total) + snapshotData.mindbender.insanityFinal;
	local castingInsanityString = "0";
	local returnString = "";
	
	local passiveInsanityString = string.format("%.0f", passiveInsanity);
	
    if characterData.talents.fotm.isSelected or math.floor(snapshotData.casting.insanityFinal) ~= snapshotData.casting.insanityFinal then        
        if (snapshotData.casting.insanityFinal > 0 and settings.displayText.right.castingInsanity) and (passiveInsanity > 0 and settings.displayText.right.passiveInsanity) then            
            returnString = string.format("|c%s%.2f|r + |c%s%s|r", settings.colors.text.castingInsanity, snapshotData.casting.insanityFinal, settings.colors.text.passiveInsanity, passiveInsanityString);
        elseif (snapshotData.casting.insanityFinal > 0 and settings.displayText.right.castingInsanity) then
            returnString = string.format("|c%s%.2f|r", settings.colors.text.castingInsanity, snapshotData.casting.insanityFinal);
        elseif (passiveInsanity > 0 and settings.displayText.right.passiveInsanity) then
            returnString = string.format("|c%s%s|r ", settings.colors.text.passiveInsanity, passiveInsanityString);
        end        
    else
        if (snapshotData.casting.insanityFinal > 0 and settings.displayText.right.castingInsanity) and (passiveInsanity > 0 and settings.displayText.right.passiveInsanity) then
            returnString = string.format("|c%s%.0f|r + |c%s%.0f|r", settings.colors.text.castingInsanity, snapshotData.casting.insanityFinal, settings.colors.text.passiveInsanity, passiveInsanityString);
        elseif (snapshotData.casting.insanityFinal > 0 and settings.displayText.right.castingInsanity) then
            returnString = string.format("|c%s%.0f|r", settings.colors.text.castingInsanity, snapshotData.casting.insanityFinal);
        elseif (passiveInsanity > 0 and settings.displayText.right.passiveInsanity) then
            returnString = string.format("|c%s%.0f|r", settings.colors.text.passiveInsanity, passiveInsanityString);
        end        
	end
	
	if settings.displayText.right.currentInsanity then
		if returnString ~= "" then
			returnString = returnString .. " + ";
		end
		returnString = returnString .. string.format("|c%s%.0f%%|r", settings.colors.text.currentInsanity, snapshotData.insanity);        
	end

	return returnString;
end

local function UpdateCastingInsanityFinal(fotm)	
	snapshotData.casting.insanityFinal = CalculateInsanityGain(snapshotData.casting.insanityRaw, fotm);
	RemainingTimeAndStackCount();
end

local function CastingSpell()
	local currentTime = GetTime();	
	local currentSpell = UnitCastingInfo("player");
	local currentChannel = UnitChannelInfo("player");
	
	if currentSpell == nil and currentChannel == nil then
		ResetCastingSnapshotData();
		return false;
	else
		if currentSpell == nil then
			local spellName = select(1, currentChannel);
			if spellName == spells.mindFlay.name then
				snapshotData.casting.spellId = spells.mindFlay.id;
				snapshotData.casting.startTime = currentTime;
				snapshotData.casting.insanityRaw = spells.mindFlay.insanity;
				UpdateCastingInsanityFinal(spells.mindFlay.fotm);
			elseif spellName == spells.mindSear.name then --TODO: Try to figure out total targets being hit
				snapshotData.casting.spellId = spells.mindSear.id;
				snapshotData.casting.startTime = currentTime;
				snapshotData.casting.insanityRaw = spells.mindSear.insanity;
				UpdateCastingInsanityFinal(spells.mindSear.fotm);
			else
				ResetCastingSnapshotData();
				return false;
			end
		else	
			local spellName = select(1, currentSpell);
			if spellName == spells.mindBlast.name then
				local t20p2 = GetSpellInfo(247226);
				local t20p2Stacks = select(3, FindBuffById(247226));  
				if t20p2Stacks == nil then
					t20p2Stacks = 0;
				end
				
				snapshotData.casting.startTime = currentTime;
				snapshotData.casting.insanityRaw = spells.mindBlast.insanity + t20p2Stacks;
				snapshotData.casting.spellId = spells.mindBlast.id;
				UpdateCastingInsanityFinal(spells.mindBlast.fotm);
			elseif spellName == spells.shadowWordVoid.name then
				snapshotData.casting.startTime = currentTime;
				snapshotData.casting.insanityRaw = spells.shadowWordVoid.insanity;
				snapshotData.casting.spellId = spells.shadowWordVoid.id;
				UpdateCastingInsanityFinal(spells.shadowWordVoid.fotm);
			elseif spellName == spells.vampiricTouch.name then
				snapshotData.casting.startTime = currentTime;
				snapshotData.casting.insanityRaw = spells.vampiricTouch.insanity;
				snapshotData.casting.spellId = spells.vampiricTouch.id;
				UpdateCastingInsanityFinal(spells.vampiricTouch.fotm);
			elseif spellName == spells.darkVoid.name then
				snapshotData.casting.startTime = currentTime;
				snapshotData.casting.insanityRaw = spells.darkVoid.insanity;
				snapshotData.casting.spellId = spells.darkVoid.id;
				UpdateCastingInsanityFinal(spells.darkVoid.fotm);
			else
				ResetCastingSnapshotData();
				return false;				
			end		
		end
		return true;
	end
end

local function LingeringInsanityValues()
	local currentTime = GetTime();	
	local _, _, liCount, _, liDuration, _, _, _, _, liSpellId = FindBuffById(spells.lingeringInsanity.id);
	
	if liCount ~= nil and liCount > 0 then
		if snapshotData.lingeringInsanity.spellId == nil then
			snapshotData.lingeringInsanity.spellId = liSpellId;
			snapshotData.lingeringInsanity.duration = liDuration;
			snapshotData.lingeringInsanity.stacksTotal = liCount;
		end
		
		if snapshotData.lingeringInsanity.stacksLast ~= liCount then
			snapshotData.lingeringInsanity.stacksLast = liCount;
			snapshotData.lingeringInsanity.lastTickTime = currentTime;
			snapshotData.lingeringInsanity.timeLeftBase = snapshotData.lingeringInsanity.stacksLast;
			--[[ Keeping this here in case they change how the stacks on LI work.
			local timeLeftBase = snapshotData.lingeringInsanity.stacksLast / 2;
			
			if mod(snapshotData.lingeringInsanity.stacksLast, 2) == 1 then
				timeLeftBase = timeLeftBase + 0.5;
			end
			snapshotData.lingeringInsanity.timeLeftBase = timeLeftBase;	
			]]--
		end
	else
		snapshotData.lingeringInsanity.stacksTotal = 0;
		snapshotData.lingeringInsanity.stacksLast = 0;
		snapshotData.lingeringInsanity.duration = 0;
		snapshotData.lingeringInsanity.spellId = nil;
		snapshotData.lingeringInsanity.lastTickTime = nil;
		snapshotData.lingeringInsanity.timeLeftBase = 0;
	end
end

local function UpdateMindbenderValues()
    local currentTime = GetTime();
    local haveTotem, name, startTime, duration, icon = GetTotemInfo(1);
	local timeRemaining = startTime+duration-currentTime;
    if settings.mindbender.enabled and haveTotem and timeRemaining > 0 then
		snapshotData.mindbender.isActive = true;
		if settings.mindbender.enabled then
			local swingSpeed = 1.5 / (1 + (snapshotData.haste/100));		
			if swingSpeed > 1.5 then
				swingSpeed = 1.5;
			end
			
			local timeToNextSwing = swingSpeed - (currentTime - snapshotData.mindbender.swingTime);
			
			if timeToNextSwing < 0 then
				timeToNextSwing = 0;
			elseif timeToNextSwing > 1.5 then
				timeToNextSwing = 1.5;
			end        
			
			snapshotData.mindbender.remaining.time = timeRemaining;
			snapshotData.mindbender.remaining.swings = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed);
			
			local gcd = swingSpeed;				
			if gcd < 0.75 then
				gcd = 0.75;
			end
			
			if timeRemaining > (gcd * snapshotData.mindbender.remaining.swings) then
				snapshotData.mindbender.remaining.gcds = math.ceil(((gcd * snapshotData.mindbender.remaining.swings) - timeToNextSwing) / swingSpeed);
			else
				snapshotData.mindbender.remaining.gcds = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed);
			end	
				
			snapshotData.mindbender.swingTime = currentTime;
			
			local countValue = 0;
			
			if settings.mindbender.mode == "swing" then
				if snapshotData.mindbender.remaining.swings > settings.mindbender.swingsMax then
					countValue = settings.mindbender.swingsMax;
				else
					countValue = snapshotData.mindbender.remaining.swings;
				end
			elseif settings.mindbender.mode == "time" then
				if snapshotData.mindbender.remaining.time > settings.mindbender.time then
					countValue = math.ceil((settings.mindbender.time - timeToNextSwing) / swingSpeed);                
				else
					countValue = math.ceil((snapshotData.mindbender.remaining.time - timeToNextSwing) / swingSpeed);
				end
			else --assume GCD
				if snapshotData.mindbender.remaining.swings > settings.mindbender.swingsMax then
					countValue = settings.mindbender.gcdsMax;
				else
					countValue = snapshotData.mindbender.remaining.gcds;
				end
			end

			if characterData.talents.mindbender.isSelected then
				snapshotData.mindbender.insanityRaw = countValue * spells.mindbender.insanity;
			else
				snapshotData.mindbender.insanityRaw = countValue * spells.shadowfiend.insanity;
			end
			snapshotData.mindbender.insanityFinal = CalculateInsanityGain(snapshotData.mindbender.insanityRaw, false);
		end
	else
		snapshotData.mindbender.onCooldown = not (GetSpellCooldown(spells.mindbender.id) == 0);
		snapshotData.mindbender.isActive = false;
		snapshotData.mindbender.swingTime = 0;
		snapshotData.mindbender.remaining = {}
		snapshotData.mindbender.remaining.swings = 0;
		snapshotData.mindbender.remaining.gcds = 0;
		snapshotData.mindbender.remaining.time = 0;
		snapshotData.mindbender.insanityRaw = 0;
		snapshotData.mindbender.insanityFinal = 0;		
	end        
end

local function UpdateSnapshot()
	spells.s2m.isActive = select(10, FindBuffById(spells.s2m.id));
	spells.s2m.isDebuffActive = select(10, FindDebuffById(spells.s2m.debuffId));
	snapshotData.haste = UnitSpellHaste("player");
	snapshotData.insanity = UnitPower("player", SPELL_POWER_INSANITY);
	LingeringInsanityValues();
	UpdateMindbenderValues();
end

local function UpdateInsanityBar()
	if GetSpecialization() ~= 3 then
		HideInsanityBar();
		return;
	end	

	if barContainerFrame:IsShown() then
		UpdateSnapshot();

		if snapshotData.insanity == 0 then
			HideInsanityBar();
		end

		RemainingTimeAndStackCount();
		
		insanityFrame:SetValue(snapshotData.insanity);
		
		if CastingSpell() then
			castingFrame:SetValue(snapshotData.insanity + snapshotData.casting.insanityFinal);
		else
			castingFrame:SetValue(snapshotData.insanity);
		end
		
		if characterData.talents.as.isSelected or snapshotData.mindbender.insanityFinal > 0 then
			passiveFrame:SetValue(snapshotData.insanity + snapshotData.casting.insanityFinal + ((CalculateInsanityGain(spells.auspiciousSpirits.insanity, false) * snapshotData.auspiciousSpirits.total) + snapshotData.mindbender.insanityFinal));
			if snapshotData.mindbender.insanityFinal > 0 and (castingFrame:GetValue() + snapshotData.mindbender.insanityFinal) < characterData.maxInsanity then
				passiveFrame.threshold:SetPoint("CENTER", passiveFrame, "LEFT", ((settings.bar.width-(settings.bar.border*2)) * ((castingFrame:GetValue() + snapshotData.mindbender.insanityFinal) / characterData.maxInsanity)), 0);
				passiveFrame.threshold.texture:Show();
			else
				passiveFrame.threshold.texture:Hide();
			end
		else
			passiveFrame.threshold.texture:Hide();
			passiveFrame:SetValue(snapshotData.insanity + snapshotData.casting.insanityFinal);
		end
			
		leftTextFrame.font:SetText(BarTextLeft());
		middleTextFrame.font:SetText(BarTextMiddle());
		rightTextFrame.font:SetText(BarTextRight());
		
		if snapshotData.voidform.totalStacks > 0 then
			barContainerFrame:SetAlpha(1.0);
			insanityFrame.threshold:Hide();
			local gcd = GetCurrentGCDTime();	
			if snapshotData.voidform.remainingTime <= gcd then
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.inVoidform1GCD, true));
			elseif snapshotData.voidform.remainingTime <= (gcd * 2.0) then
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.inVoidform2GCD, true));
			else
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.inVoidform, true));	
			end
		else
			if characterData.voidformThreshold < characterData.maxInsanity and settings.voidEruptionThreshold then
				insanityFrame.threshold:Show();
			else
				insanityFrame.threshold:Hide();
			end

			if snapshotData.insanity >= characterData.voidformThreshold then
				insanityFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.over, true));
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.enterVoidform, true));
				if settings.colors.bar.flashEnabled then
					PulseFrame(barContainerFrame);
				--insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.enterVoidformFlash, true));
				end
			else
				insanityFrame.threshold.texture:SetColorTexture(GetRGBAFromString(settings.colors.threshold.under, true));
				insanityFrame:SetStatusBarColor(GetRGBAFromString(settings.colors.bar.base, true));
				barContainerFrame:SetAlpha(1.0);
			end
		end
	end
end

local function ResetVoidformSnapshotData()
	snapshotData.voidform.totalStacks = 0;
	snapshotData.voidform.drainStacks = 0;
	snapshotData.voidform.additionalStacks = 0;
	snapshotData.voidform.currentDrainRate = 0;
	snapshotData.voidform.duration = 0;
	snapshotData.voidform.spellId = nil;
	snapshotData.voidform.startTime = 0;
	snapshotData.voidform.previousStackTime = 0;
	snapshotData.voidform.remainingTime = 0;
	snapshotData.voidform.voidTorrent.stacks = 0;
	snapshotData.voidform.voidTorrent.startTime = nil;
	snapshotData.voidform.dispersion.stacks = 0;
	snapshotData.voidform.dispersion.startTime = nil;
end

local function PrintVoidformSummary(isS2M)
	local currentTime = GetTime();
	print("--------------------------");
	if isS2M then
		print("Surrender to Madness Info:");
		print("--------------------------");
		print(string.format("S2M Duration: %.2f seconds", (currentTime-snapshotData.voidform.s2m.startTime)));
	else
		print("Voidform Info:");
		print("--------------------------");	
	end
	print(string.format("Voidform Duration: %.2f seconds", (currentTime-snapshotData.voidform.startTime)));

	if snapshotData.voidform.totalStacks > 100 then
		print(string.format("Voidform Stacks: 100 (+%.0f)", (snapshotData.voidform.totalStacks-100)));
	else
		print(string.format("Voidform Stacks: %.0f", snapshotData.voidform.totalStacks));
	end

	print(string.format("Dispersion Stacks: %.0f", snapshotData.voidform.dispersion.stacks));
	print(string.format("Void Torrent Stacks: %.0f", snapshotData.voidform.voidTorrent.stacks));
	print(string.format("Final Drain: %.0f stacks; %.1f / sec", snapshotData.voidform.drainStacks, InsanityDrain(snapshotData.voidform.drainStacks)));
	print("--------------------------");
end

local function AuspiciousSpiritsCleanup(guid)
	if guid ~= nil and settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected then
		if snapshotData.auspiciousSpirits.tracker[guid] then
			snapshotData.auspiciousSpirits.total = snapshotData.auspiciousSpirits.total - snapshotData.auspiciousSpirits.tracker[guid].count;
			
			if snapshotData.auspiciousSpirits.total < 0 then
				snapshotData.auspiciousSpirits.total = 0;
			end
			snapshotData.auspiciousSpirits.tracker[guid] = nil;
			
			snapshotData.auspiciousSpirits.units = snapshotData.auspiciousSpirits.units - 1;
			
			if snapshotData.auspiciousSpirits.units < 0 then
				snapshotData.auspiciousSpirits.units = 0;
			end
		end
	else
		snapshotData.auspiciousSpirits.total = 0;
		snapshotData.auspiciousSpirits.units = 0;
		snapshotData.auspiciousSpirits.tracker = {};
	end
end 

function timerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate;
	if self.sinceLastUpdate >= 0.05 then -- in seconds
		UpdateInsanityBar();
		self.sinceLastUpdate = 0;
	end
end

function mindbenderAudioCueFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate;
	self.sinceLastPlay = self.sinceLastPlay + sinceLastUpdate;
	if self.sinceLastUpdate >= 0.05 then -- in seconds	
		if self.sinceLastPlay >= 0.75 and not snapshotData.mindbender.isActive then -- in seconds
			if settings.mindbender.useNotification.useVoidformStacks == true and not snapshotData.mindbender.onCooldown and snapshotData.voidform.totalStacks >= settings.mindbender.useNotification.thresholdStacks then
				PlaySoundFile(settings.audio.mindbender.sound, "Master", false);
				self.sinceLastPlay = 0;
			elseif settings.mindbender.useNotification.useVoidformStacks == false and not snapshotData.mindbender.onCooldown and snapshotData.voidform.drainStacks >= settings.mindbender.useNotification.thresholdStacks then
				PlaySoundFile(settings.audio.mindbender.sound, "Master", false);
				self.sinceLastPlay = 0;
			end;
		end
		
		self.sinceLastUpdate = 0;
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local currentTime = GetTime();
	local triggerUpdate = false;
	
	if event == "UNIT_POWER_FREQUENT" then	
		local unit, unitPowerType = ...
		if unit == "player" and unitPowerType == "INSANITY" then
			snapshotData.insanity = UnitPower("player", SPELL_POWER_INSANITY);
      
			if snapshotData.voidform.totalStacks >= 100 then --When above 100 stacks there are no longer combat log events for Voidform stacks, need to do a manual check instead			
				if (currentTime - snapshotData.voidform.previousStackTime) >= 1 then					
					snapshotData.voidform.previousStackTime = currentTime;
					snapshotData.voidform.totalStacks = snapshotData.voidform.totalStacks + 1;
										
					if snapshotData.voidform.voidTorrent.startTime == nil and snapshotData.voidform.dispersion.startTime == nil then						
						snapshotData.voidform.drainStacks = snapshotData.voidform.drainStacks + 1;						
					elseif snapshotData.voidform.voidTorrent.startTime ~= nil then						
						snapshotData.voidform.voidTorrent.stacks = snapshotData.voidform.voidTorrent.stacks + 1;						
					else						
						snapshotData.voidform.dispersion.stacks = snapshotData.voidform.dispersion.stacks + 1;						
					end                
				end				
			end
		end
					
		triggerUpdate = true;
	end
	
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo(); --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

		local s2mDeath = false;
		
		if destGUID == characterData.guid then
			if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and
				((characterData.talents.mindbender.isSelected and sourceName == spells.mindbender.name) or 
				 (not characterData.talents.mindbender.isSelected and sourceName == spells.shadowfiend.name)) then 
				snapshotData.mindbender.swingTime = currentTime;
			elseif (type == "SPELL_INSTAKILL" or type == "UNIT_DIED" or type == "UNIT_DESTROYED") then
				if snapshotData.voidform.s2m.active then -- Surrender to Madness ended
					s2mDeath = true;
				end
			end	
		end
		
		if sourceGUID == characterData.guid then  
            if spellId == spells.voidform.id then
                if type == "SPELL_AURA_APPLIED" then -- Entered Voidform                    
					snapshotData.voidform.previousStackTime = currentTime;
                    snapshotData.voidform.drainStacks = 1;
                    snapshotData.voidform.startTime = currentTime;
                    snapshotData.voidform.totalStacks = 1;
                    snapshotData.voidform.voidTorrent.startTime = nil;
                    snapshotData.voidform.voidTorrent.stacks = 0;
                    snapshotData.voidform.dispersion.startTime = nil;
                    snapshotData.voidform.dispersion.stacks = 0;
					
					triggerUpdate = true;
                elseif type == "SPELL_AURA_APPLIED_DOSE" then -- New Voidform Stack   
                    snapshotData.voidform.previousStackTime = currentTime;
                    snapshotData.voidform.totalStacks = snapshotData.voidform.totalStacks + 1;
                    
                    if snapshotData.voidform.voidTorrent.startTime == nil and snapshotData.voidform.dispersion.startTime == nil then
                        snapshotData.voidform.drainStacks = snapshotData.voidform.drainStacks + 1;                        
                    elseif snapshotData.voidform.voidTorrent.startTime ~= nil then                        
                        snapshotData.voidform.voidTorrent.stacks = snapshotData.voidform.voidTorrent.stacks + 1;                        
                    else                        
                        snapshotData.voidform.dispersion.stacks = snapshotData.voidform.dispersion.stacks + 1;                        
                    end
					
					triggerUpdate = true;
                elseif type == "SPELL_AURA_REMOVED" then -- Exited Voidform
                    if settings.showSummary == true then
						PrintVoidformSummary(false);
                    end
            
                    ResetVoidformSnapshotData();
					triggerUpdate = true;
                end                
            elseif spellId == spells.voidTorrent.id then                
                if type == "SPELL_AURA_APPLIED" then -- Started channeling Void Torrent                    
                    snapshotData.voidform.voidTorrent.startTime = currentTime;                    
                elseif type == "SPELL_AURA_REMOVED" and snapshotData.voidform.voidTorrent.startTime ~= nil then -- Stopped channeling Void Torrent                    
                    snapshotData.voidform.voidTorrent.startTime = nil;                    
                end
					
				triggerUpdate = true;
            elseif spellId == spells.dispersion.id then                
                if type == "SPELL_AURA_APPLIED" then -- Started channeling Dispersion                    
                    snapshotData.voidform.dispersion.startTime = currentTime;                    
                elseif type == "SPELL_AURA_REMOVED" and snapshotData.voidform.dispersion.startTime ~= nil then -- Stopped channeling Dispersion                    
                    snapshotData.voidform.dispersion.startTime = nil;                    
                end
					
				triggerUpdate = true;
            elseif spellId == spells.s2m.id then                
                if type == "SPELL_AURA_APPLIED" then -- Gain Surrender to Madness   
                    snapshotData.voidform.s2m.active = true;
                    snapshotData.voidform.s2m.startTime = currentTime;
					UpdateCastingInsanityFinal();
					
					triggerUpdate = true;
                elseif type == "SPELL_AURA_REMOVED" and snapshotData.voidform.s2m.active then -- Gain Surrender to Madness 
					s2mDeath = true;
                end
			elseif settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected and spellId == spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
				if not snapshotData.auspiciousSpirits.tracker[destGUID] or snapshotData.auspiciousSpirits.tracker[destGUID] == nil then
					snapshotData.auspiciousSpirits.tracker[destGUID] = {};
					snapshotData.auspiciousSpirits.tracker[destGUID].count = 0;
					snapshotData.auspiciousSpirits.units = snapshotData.auspiciousSpirits.units + 1;
				end
            
				snapshotData.auspiciousSpirits.total = snapshotData.auspiciousSpirits.total + 1;
				snapshotData.auspiciousSpirits.tracker[destGUID].count = snapshotData.auspiciousSpirits.tracker[destGUID].count + 1;
				snapshotData.auspiciousSpirits.tracker[destGUID].lastUpdate = currentTime;
				triggerUpdate = true;
			elseif settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected and spellId == spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
				snapshotData.auspiciousSpirits.total = snapshotData.auspiciousSpirits.total - 1;
				if snapshotData.auspiciousSpirits.tracker[destGUID] and snapshotData.auspiciousSpirits.tracker[destGUID].count > 0 then   
					snapshotData.auspiciousSpirits.tracker[destGUID].count = snapshotData.auspiciousSpirits.tracker[destGUID].count - 1;
					snapshotData.auspiciousSpirits.tracker[destGUID].lastUpdate = currentTime;
                
					if snapshotData.auspiciousSpirits.tracker[destGUID].count <= 0 then
						AuspiciousSpiritsCleanup(destGUID);
					end
				end
				triggerUpdate = true;
			elseif type == "SPELL_CAST_FAILED" and spellId ~= spells.dispersion.id then
				local gcd = GetCurrentGCDTime();
				if snapshotData.casting.startTime == nil or currentTime > (snapshotData.casting.startTime+gcd) then
					ResetCastingSnapshotData();
					triggerUpdate = true;
				end
			end
		end
		
		if settings.auspiciousSpiritsTracker and characterData.talents.as.isSelected then
			if destGUID ~= characterData.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				AuspiciousSpiritsCleanup(destGUID);
				triggerUpdate = true;
			end
			
			if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or event == "PLAYER_REGEN_ENABLED" then -- We died, or, exited combat, go ahead and purge the list
				for guid,count in pairs(snapshotData.auspiciousSpirits.tracker) do 
					AuspiciousSpiritsCleanup(guid);
				end
				
				snapshotData.auspiciousSpirits.tracker = {};
				snapshotData.auspiciousSpirits.units = 0;
				snapshotData.auspiciousSpirits.total = 0;
				triggerUpdate = true;
			end
		end
		
		if s2mDeath then
			if settings.audio.s2mDeath.enabled then
				PlaySoundFile(settings.audio.s2mDeath.sound, "Master");
			end
			
			if settings.showS2MSummary == true then
				PrintVoidformSummary(true);
			end
			
			ResetCastingSnapshotData();
			ResetVoidformSnapshotData();
			snapshotData.voidform.s2m.startTime = nil;
			snapshotData.voidform.s2m.active = false;	
			triggerUpdate = true;
		end
	end
				
	if triggerUpdate then
		UpdateInsanityBar();
	end
end);

function asTimerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime();
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate;
	if self.sinceLastUpdate >= 1 then -- in seconds
		local newUnits = 0;
		local newTotal = 0;
		for guid,count in pairs(snapshotData.auspiciousSpirits.tracker) do
			if (currentTime - snapshotData.auspiciousSpirits.tracker[guid].lastUpdate) > 10 then
				AuspiciousSpiritsCleanup(guid);
			else
				newUnits = newUnits + 1;
				newTotal = newTotal + snapshotData.auspiciousSpirits.tracker[guid].count;
			end
		end
		snapshotData.auspiciousSpirits.units = newUnits;
		snapshotData.auspiciousSpirits.total = newTotal;
		UpdateInsanityBar();
		self.sinceLastUpdate = 0;
	end
end

combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event =="PLAYER_REGEN_DISABLED" then
		ShowInsanityBar();
	else
		HideInsanityBar();
	end
end);

insanityFrame:RegisterEvent("ADDON_LOADED");
insanityFrame:RegisterEvent("PLAYER_TALENT_UPDATE");
insanityFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
insanityFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
insanityFrame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out
insanityFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	local _, _, classIndex = UnitClass("player");
	if classIndex == 5 then
		local checkSpec = false;

		if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
			if not addonData.loaded then
				addonData.loaded = true
				settings = TwintopInsanityBarSettings;
				if settings == nil then
					LoadDefaultSettings();
				else
					UpdateSettingsForNewVersion();
				end
				ConstructInsanityBar();
				ConstructOptionsPanel();
			end			
		end	

		if event == "PLAYER_LOGOUT" then
			TwintopInsanityBarSettings = settings;
		end
				
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
			EventRegistration();		
				
			affectingCombat = UnitAffectingCombat("player");

			if (not affectingCombat) and (
				(not settings.displayBar.alwaysShow) and (
					(not settings.displayBar.notZeroShow) or
					(settings.displayBar.notZeroShow and snapshotData.insanity == 0))) then	
				barContainerFrame:Hide();
			end
		end
	end
end);