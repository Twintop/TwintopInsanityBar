local addonName, TRB = ...
local L = TRB.Localization
local _, _, classIndexId = UnitClass("player")

-- Addon details data
TRB.Details = {}
TRB.Details.addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version") .. "-" .. C_AddOns.GetAddOnMetadata(addonName, "X-ReleaseType")
TRB.Details.addonAuthor = C_AddOns.GetAddOnMetadata(addonName, "Author")
TRB.Details.addonAuthorServer = C_AddOns.GetAddOnMetadata(addonName, "X-AuthorServer")
TRB.Details.addonTitle = C_AddOns.GetAddOnMetadata(addonName, "Title")
TRB.Details.addonReleaseDate = C_AddOns.GetAddOnMetadata(addonName, "X-ReleaseDate")
TRB.Details.supportedSpecs = "|cFFA330C9" .. L["DemonHunter"] .. "|r - " .. L["DemonHunterHavoc"] .. ", " .. L["DemonHunterVengeance"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFFFF7C0A" .. L["Druid"] .. "|r - " .. L["DruidBalance"] .. ", " .. L["DruidFeral"] .. ", " .. L["DruidRestoration"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFF33937F" .. L["Evoker"] .. "|r - " .. L["EvokerDevastation"] .. ", " .. L["EvokerPreservation"] .. ", " .. L["EvokerAugmentation"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFFAAD372" .. L["Hunter"] .. "|r - " .. L["HunterBeastMastery"] .. ", " .. L["HunterMarksmanship"] .. ", Survival\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFF00FF98" .. L["Monk"] .. "|r - " .. L["MonkMistweaver"] .. ", " .. L["MonkWindwalker"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFFF48CBA" .. L["Paladin"] .. "|r - " .. L["PaladinHoly"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFFFFFFFF" .. L["Priest"] .. "|r - " .. L["PriestDiscipline"] .. ", " .. L["PriestHoly"] .. ", " .. L["PriestShadow"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFFFFF468" .. L["Rogue"] .. "|r - " .. L["RogueAssassination"] .. ", " .. L["RogueOutlaw"] .. ", " .. L["RogueSubtlety"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFF0070DD" .. L["Shaman"] .. "|r - " .. L["ShamanElemental"] .. ", " .. L["ShamanEnhancement"] .. " (" .. L["ExperimentalMinimal"] .. "), " .. L["ShamanRestoration"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|cFFC69B6D" .. L["Warrior"] .. "|r - " .. L["WarriorArms"] .. ", " .. L["WarriorFury"]

local addonData = {
	loaded = false,
	registered = false,
	libs = {}
}
addonData.libs.SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundWilhelmScream"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\wilhelm.ogg")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundBoxingArenaGong"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundAirHorn"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg")

if not addonData.libs.SharedMedia:IsValid("border", "1 Pixel") then -- No localization on this as it is usually provided by WeakAuras
	addonData.libs.SharedMedia:Register("border", "1 Pixel", "Interface\\Buttons\\WHITE8X8")
end

addonData.libs.ScrollingTable = LibStub:GetLibrary("ScrollingTable")

addonData.libs.LibSmoothStatusBar = LibStub:GetLibrary("LibSmoothStatusBar-1.0")

TRB.Details.addonData = addonData

-- Some class functions get referenced by other methods. These live in a consistent location but are actually created in the class modules.
TRB.Functions.Class = {}

-- Working data
TRB.Data = {}

TRB.Data.constants = {
	borderWidthFactor = 4,
	defaultSettings = {
		fonts = {
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT",
		},
		textures = {
			background="Interface\\Tooltips\\UI-Tooltip-Background",
			backgroundName="Blizzard Tooltip",
			border="Interface\\Buttons\\WHITE8X8",
			borderName="1 Pixel",
			resourceBar="Interface\\TargetingFrame\\UI-StatusBar",
			resourceBarName="Blizzard",
		},
		sounds = {
			sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
			soundName = L["LSMSoundAirHorn"]
		}
	},
	frameCategories = {
		container = "Container",
		resource = "Resource"
	},
	frameNames = {
		container = "Container",
		resource = "Resource",
		casting = "Casting",
		passive = "Passive",
		border = "Border",
	},
	frameLevels = {
		barContainer = 0,
		barPassive = 80,
		barCasting = 90,
		barResource = 100,
		barBorder = 101,
		cpContainer = 0,
		cpResource = 110,
		cpBorder = 111,
		thresholdBase = 1000,
		thresholdOutOfRange = 1200,
		thresholdBleedSame = 1400,
		thresholdBleedBetter = 1600,
		thresholdUnusable = 1800,
		thresholdUnder = 2000,
		thresholdOver = 2200,
		thresholdBleedDownOrWorse = 2400,
		thresholdHighPriority = 2600,
		thresholdOffsetLine = 2,
		thresholdOffsetIcon = 1,
		thresholdOffsetCooldown = 0,
		thresholdOffsetNoCooldown = 100,
		barText = 5000
	},
	optionsUi = {
		xPadding = 10,
		xPadding2 = 30,
		xCoord = 5,
		xCoord2 = 320,
		xOffset1 = 50,
		xOffset2 = 370, --Calculated below
		dropdownWidth = 225,
		sliderWidth = 260,
		sliderHeight = 20,
		maxOptionsWidth = 650
	}
}

TRB.Data.constants.optionsUi.xOffset2 = TRB.Data.constants.optionsUi.xCoord2 + TRB.Data.constants.optionsUi.xOffset1

TRB.Data.settings = {}

TRB.Data.specSupported = false
TRB.Data.resource = nil
TRB.Data.resourceFactor = 1
TRB.Data.barConstructedForSpec = nil

TRB.Data.barTextVariables = {
	icons = {},
	values = {},
	pipe = {
		{ variable = "||n", description = L["BarTextNewline"], printInSettings = true },
		{ variable = "||c", description = "", printInSettings = false },
		{ variable = "||r", description = "", printInSettings = false },
	},
	percent = {
		{ variable = "%%" }
	}
}

TRB.Data.barTextCache = {}

-- This is here for reference/what every implementation should use as a minimum
TRB.Data.character = {
	guid = UnitGUID("player"),
	className = "",
	specName = "",
	specGroup = GetActiveSpecGroup(),
	maxResource = 100,
	talents = TRB.Classes.Talents:New() --[[@as TRB.Classes.Talents]],
	items = {}
}

TRB.Data.spells = {}

TRB.Data.lookup = {}
TRB.Data.lookupLogic = {}

TRB.Data.sanityCheckValues = {
	barMaxWidth = 0,
	barMinWidth = 0,
	barMaxHeight = 0,
	barMinHeight = 0
}


-- Frames
TRB.Frames = {}

---@type Frame
TRB.Frames.barContainerFrame = CreateFrame("Frame", "TwintopResourceBarFrame", UIParent, "BackdropTemplate")
---@type Frame
TRB.Frames.resourceFrame = CreateFrame("StatusBar", "TwintopResourceBarFrame_Resource", TRB.Frames.barContainerFrame, "BackdropTemplate")
---@type Frame
TRB.Frames.castingFrame = CreateFrame("StatusBar", "TwintopResourceBarFrame_Resource_Casting", TRB.Frames.barContainerFrame, "BackdropTemplate")
---@type Frame
TRB.Frames.passiveFrame = CreateFrame("StatusBar", "TwintopResourceBarFrame_Resource_Passive", TRB.Frames.barContainerFrame, "BackdropTemplate")
---@type Frame
TRB.Frames.barBorderFrame = CreateFrame("StatusBar", "TwintopResourceBarFrame_Resource_Border", TRB.Frames.barContainerFrame, "BackdropTemplate")

---@diagnostic disable-next-line: inject-field
TRB.Frames.passiveFrame.thresholds = {}
---@diagnostic disable-next-line: inject-field
TRB.Frames.resourceFrame.thresholds = {}

TRB.Frames.textFrames = {}

TRB.Frames.targetsTimerFrame = CreateFrame("Frame")
TRB.Frames.targetsTimerFrame.sinceLastUpdate = 0

---@class Frame
TRB.Frames.timerFrame = CreateFrame("Frame")
TRB.Frames.timerFrame.sinceLastUpdate = 0
TRB.Frames.timerFrame.ttdSinceLastUpdate = 0
TRB.Frames.timerFrame.characterCheckSinceLastUpdate = 0

-- For the following specs, we need to have a secondary bar/bars created
-- We're going to make these as StatusBars so we can use them for Death Knight runes and Warlock soulshards in the future
if classIndexId == 2 or classIndexId == 4 or classIndexId == 5 or classIndexId == 7 or classIndexId == 10 or classIndexId == 11 or classIndexId == 12 or classIndexId == 13 then
	TRB.Frames.resource2Frames = {}
	TRB.Frames.resource2ContainerFrame = CreateFrame("Frame", "TwintopResourceBarFrame2", TRB.Frames.barContainerFrame, "BackdropTemplate")
	
	for x = 1, 10 do
		TRB.Frames.resource2Frames[x] = {}
		TRB.Frames.resource2Frames[x].containerFrame = CreateFrame("Frame", "TwintopResourceBarFrame_ComboPoint_"..x, TRB.Frames.resource2ContainerFrame, "BackdropTemplate")
		TRB.Frames.resource2Frames[x].borderFrame = CreateFrame("StatusBar", nil, TRB.Frames.resource2Frames[x].containerFrame, "BackdropTemplate")
		TRB.Frames.resource2Frames[x].resourceFrame = CreateFrame("StatusBar", nil, TRB.Frames.resource2Frames[x].containerFrame, "BackdropTemplate")
	end
end

function TRB.Frames.timerFrame:onUpdate(sinceLastUpdate)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData

	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.ttdSinceLastUpdate = self.ttdSinceLastUpdate + sinceLastUpdate
	self.characterCheckSinceLastUpdate  = self.characterCheckSinceLastUpdate  + sinceLastUpdate
	if self.sinceLastUpdate >= 0.05 then -- in seconds
		TRB.Functions.Class:TriggerResourceBarUpdates()
		self.sinceLastUpdate = 0
	end

	if self.characterCheckSinceLastUpdate >= TRB.Data.settings.core.dataRefreshRate then -- in seconds
		TRB.Functions.Class:CheckCharacter()
		self.characterCheckSinceLastUpdate  = 0
	end

	local guid = UnitGUID("target")
	if targetData.currentTargetGuid ~= guid then
		targetData.currentTargetGuid = guid
	end

	if guid ~= nil then
		local isDead = UnitIsDeadOrGhost("target")

		if isDead and targetData.targets[targetData.currentTargetGuid] ~= nil then
			targetData:Remove(guid)
		elseif guid ~= TRB.Data.character.guid and targetData.ttdIsActive then
			targetData:InitializeTarget(guid)
			local target = targetData.targets[targetData.currentTargetGuid]
			if self.ttdSinceLastUpdate >= target.timeToDie.settings.sampleRate then
				target.timeToDie:Update(currentTime)
				self.ttdSinceLastUpdate = 0
			end
		end
	end
end

TRB.Frames.combatFrame = CreateFrame("Frame", "TwintopResourceBarFrame_CombatFrame", TRB.Frames.barContainerFrame)

-- Settings placeholders
TRB.Frames.interfaceSettingsFrameContainer = {}
TRB.Frames.interfaceSettingsFrameContainer.controls = {}


local function ParseCmdString(msg)
	if msg then
		while (strfind(msg,"  ") ~= nil) do
			msg = string.gsub(msg,"  "," ")
		end
		local a,b,c=strfind(msg,"(%S+)")
		if a then
			return c,strsub(msg,b+2)
		else
			return ""
		end
	end
end

function SlashCmdList.TWINTOP(msg)
	local cmd, subcmd = ParseCmdString(msg)
	if cmd == "reset" then
		StaticPopup_Show("TwintopResourceBar_Reset")
	elseif cmd == "fill" then
		TRB.Functions.Spell:FillSpellData()
	elseif cmd == "move" then
		local x, y = ParseCmdString(subcmd)
		TRB.Functions.Bar:SetPositionXY(tonumber(x), tonumber(y))
	elseif cmd == "news" then
		TRB.Functions.News:Show()
	else
		if TRB.Data.barConstructedForSpec == nil then
			InterfaceOptionsFrame_OpenToCategory(TRB.Frames.interfaceSettingsFrameContainer.panel)
		else
			InterfaceOptionsFrame_OpenToCategory(TRB.Frames.interfaceSettingsFrameContainer.panel)
		end
	end
end

Twintop_Data = TRB.Data