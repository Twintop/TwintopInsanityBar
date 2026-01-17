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
TRB.Details.supportedSpecs = "|c" .. select(4, GetClassColor("DEATHKNIGHT")) .. L["DeathKnight"] .. "|r - " .. L["DeathKnightBlood"] .. ", " .. L["DeathKnightFrost"] .. ", " .. L["DeathKnightUnholy"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("DEMONHUNTER")) .. L["DemonHunter"] .. "|r - " .. L["DemonHunterHavoc"] .. ", " .. L["DemonHunterVengeance"] .. ", " .. L["DemonHunterDevourer"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("DRUID")) .. L["Druid"] .. "|r - " .. L["DruidBalance"] .. ", " .. L["DruidFeral"] .. ", " .. L["DruidRestoration"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("EVOKER")) .. L["Evoker"] .. "|r - " .. L["EvokerDevastation"] .. ", " .. L["EvokerPreservation"] .. ", " .. L["EvokerAugmentation"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("HUNTER")) .. L["Hunter"] .. "|r - " .. L["HunterBeastMastery"] .. ", " .. L["HunterMarksmanship"] .. ", Survival\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("MAGE")) .. L["Mage"] .. "|r - " .. L["MageArcane"] .. ", " .. L["MageFire"] .. ", " .. L["MageFrost"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("MONK")) .. L["Monk"] .. "|r - " .. L["MonkMistweaver"] .. ", " .. L["MonkWindwalker"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("PALADIN")) .. L["Paladin"] .. "|r - " .. L["PaladinHoly"] .. ", " .. L["PaladinProtection"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("PRIEST")) .. L["Priest"] .. "|r - " .. L["PriestDiscipline"] .. ", " .. L["PriestHoly"] .. ", " .. L["PriestShadow"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("ROGUE")) .. L["Rogue"] .. "|r - " .. L["RogueAssassination"] .. ", " .. L["RogueOutlaw"] .. ", " .. L["RogueSubtlety"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("SHAMAN")) .. L["Shaman"] .. "|r - " .. L["ShamanElemental"] .. ", " .. L["ShamanEnhancement"] .. ", " .. L["ShamanRestoration"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("WARLOCK")) .. L["Warlock"] .. "|r - " .. L["WarlockAffliction"] .. ", " .. L["WarlockDemonology"] .. ", " .. L["WarlockDestruction"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("WARRIOR")) .. L["Warrior"] .. "|r - " .. L["WarriorArms"] .. ", " .. L["WarriorFury"] .. ", " .. L["WarriorProtection"] .. "\n"

local addonData = {
	loaded = false,
	registered = false,
	libs = {},
	toc = select(4, GetBuildInfo()),
	build = select(2, GetBuildInfo()),
}
addonData.libs.SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundWilhelmScream"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\wilhelm.ogg")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundBoxingArenaGong"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg")
addonData.libs.SharedMedia:Register("sound", L["LSMSoundAirHorn"], "Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg")

addonData.libs.SharedMedia:Register("statusbar", L["LSMStatusBarM1"], "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\m1.tga")
addonData.libs.SharedMedia:Register("statusbar", L["LSMStatusBarClean"], "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\clean.blp")
addonData.libs.SharedMedia:Register("statusbar", L["LSMStatusBarSmoother"], "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga")

if not addonData.libs.SharedMedia:IsValid("border", "1 Pixel") then -- No localization on this as it is usually provided by WeakAuras
	addonData.libs.SharedMedia:Register("border", "1 Pixel", "Interface\\Buttons\\WHITE8X8")
end

addonData.libs.ScrollingTable = LibStub:GetLibrary("ScrollingTable")

addonData.libs.LibSmoothMove = LibStub:GetLibrary("LibSmoothMove-1.0")

--addonData.libs.LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.0")

TRB.Details.addonData = addonData

-- Some class functions get referenced by other methods. These live in a consistent location but are actually created in the class modules.
TRB.Functions = TRB.Functions or {}
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
			resourceBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
			resourceBarName="TRB: Smoother",
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
		border = "Border",
	},
	frameLevels = {
		barContainer = 0,
		barResource = 100,
		barBorder = 201,
		cpContainer = 0,
		cpResource = 300,
		cpBorder = 301,
		thresholdBase = 1000,
		thresholdOutOfRange = 1200,
		thresholdUnusable = 1800,
		thresholdUnder = 2000,
		thresholdOver = 2200,
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

TRB.Data.cache = {}
TRB.Data.cache.barText = {}
TRB.Data.cache.symbols = {}
TRB.Data.cache.barTextTree = {}
TRB.Data.cache.colors = {
	bar = {},
	border = {},
	backdrop = {}
}
TRB.Data.cache.values = {
	bar = {},
	threshold = {},
	resource = {},
	frame = {},
	range = {}
}
---@type TRB.Classes.SpellThreshold[]
TRB.Data.cache.thresholdSpells = {}
TRB.Data.specCache = {}

TRB.Data.character = {
	guid = UnitGUID("player"),
	raceId = 0,
	specId = GetSpecialization() or 0,
	classId = classIndexId,
	className = "",
	specName = "",
	maxResource = 100,
	talents = TRB.Classes.Talents:New() --[[@as TRB.Classes.Talents]],
	items = {}
}
_, _, TRB.Data.character.raceId = UnitRace("player")

-- Register built-in bar types
TRB.Classes.BarTypeRegistry:GetInstance():RegisterBuiltInTypes()

---@type TRB.Classes.SpellsData
---@diagnostic disable-next-line: missing-fields
TRB.Data.spellsData = {}

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

TRB.Frames.textFrames = {}

TRB.Frames.targetsTimerFrame = CreateFrame("Frame")
TRB.Frames.targetsTimerFrame.sinceLastUpdate = 0

---@class Frame
TRB.Frames.timerFrame = CreateFrame("Frame")
TRB.Frames.timerFrame.sinceLastUpdate = 0
TRB.Frames.timerFrame.characterCheckSinceLastUpdate = 0

function TRB.Frames.timerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.characterCheckSinceLastUpdate  = self.characterCheckSinceLastUpdate  + sinceLastUpdate

	if self.sinceLastUpdate >= 0.05 then -- in seconds
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshotData.targetData

		if self.characterCheckSinceLastUpdate >= TRB.Data.settings.core.dataRefreshRate then -- in seconds
			TRB.Data.character.latency = TRB.Functions.Character:GetLatency()
			self.characterCheckSinceLastUpdate = 0
		end

		-- Stop all current target tracking
		local guid = nil --UnitGUID("target")
		if targetData.currentTargetGuid ~= guid then
			targetData.currentTargetGuid = guid
		end

		if guid ~= nil then
			local isDead = UnitIsDeadOrGhost("target")

			if isDead and targetData.targets[targetData.currentTargetGuid] ~= nil then
				targetData:Remove(guid)
			end
		end
		
		TRB.Functions.Class:TriggerResourceBarUpdates()
		self.sinceLastUpdate = 0
	end
end

TRB.Frames.combatFrame = CreateFrame("Frame", "TwintopResourceBarFrame_CombatFrame", UIParent)
TRB.Frames.combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		TRB.Data.character.inCombat = true
		TRB.Data.character.combatStartTime = GetTime()
	elseif event == "PLAYER_REGEN_ENABLED" then
		TRB.Data.character.inCombat = false
		TRB.Data.character.combatStartTime = nil
	end
	TRB.Functions.Bar:ShowResourceBar()
end)

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
			Settings.OpenToCategory(TRB.Details.addonCategory.main.ID)
		else
			if TRB.Data.barConstructedForSpec ~= nil and TRB.Details.addonCategory.specs[TRB.Data.barConstructedForSpec] ~= nil and TRB.Details.addonCategory.specs[TRB.Data.barConstructedForSpec].ID ~= nil then
				Settings.OpenToCategory(TRB.Details.addonCategory.specs[TRB.Data.barConstructedForSpec].ID)
			else
				Settings.OpenToCategory(TRB.Details.addonCategory.main.ID)
			end
		end
	end
end

Twintop_Data = TRB.Data