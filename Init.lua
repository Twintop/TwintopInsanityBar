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
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("DRUID")) .. L["Druid"] .. "|r - " .. L["DruidBalance"] .. ", " .. L["DruidFeral"] .. ", " .. L["DruidGuardian"] .. ", " .. L["DruidRestoration"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("EVOKER")) .. L["Evoker"] .. "|r - " .. L["EvokerDevastation"] .. ", " .. L["EvokerPreservation"] .. ", " .. L["EvokerAugmentation"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("HUNTER")) .. L["Hunter"] .. "|r - " .. L["HunterBeastMastery"] .. ", " .. L["HunterMarksmanship"] .. ", " .. L["HunterSurvival"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("MAGE")) .. L["Mage"] .. "|r - " .. L["MageArcane"] .. ", " .. L["MageFire"] .. ", " .. L["MageFrost"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("MONK")) .. L["Monk"] .. "|r - " .. L["MonkBrewmaster"] .. ", " .. L["MonkMistweaver"] .. ", " .. L["MonkWindwalker"] .. "\n"
TRB.Details.supportedSpecs = TRB.Details.supportedSpecs .. "|c" .. select(4, GetClassColor("PALADIN")) .. L["Paladin"] .. "|r - " .. L["PaladinHoly"] .. ", " .. L["PaladinProtection"] .. ", " .. L["PaladinRetribution"] .. "\n"
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

addonData.libs.LibEditMode = TRB.LibEditMode or LibStub:GetLibrary("LibEditMode-1.0")

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
		fonts = {}, -- This will get populated by Functions\Settings.lua
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
		bar = 100,
		comboPoint = 300,
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
		xCoord2 = 360,
		xOffset1 = 50,
		xOffset2 = 410, --Calculated below
		dropdownWidth = 350,
		sliderWidth = 300,
		sliderHeight = 20,
		maxOptionsWidth = 720,
		colorPickerTextWidth = 350,
		colorPickerFrameSize = 25,
		tabWidth = {
			small = 125,
			medium = 150,
			large = 175,
			xlarge = 250
		}
	},
	---All 9 valid anchor points for bar positioning
	anchorPoints = {
		"TOPLEFT", "TOP", "TOPRIGHT",
		"LEFT", "CENTER", "RIGHT",
		"BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"
	},
	---Maps a legacy relativeTo value to the corresponding anchor/attach point pair
	---Used by PortForwardSettings migration and runtime fallback
	relativeToAnchorMap = {
		["TOP"]         = { anchorPoint = "TOP",         attachPoint = "BOTTOM" },
		["TOPLEFT"]     = { anchorPoint = "TOPLEFT",     attachPoint = "BOTTOMLEFT" },
		["TOPRIGHT"]    = { anchorPoint = "TOPRIGHT",    attachPoint = "BOTTOMRIGHT" },
		["BOTTOM"]      = { anchorPoint = "BOTTOM",      attachPoint = "TOP" },
		["BOTTOMLEFT"]  = { anchorPoint = "BOTTOMLEFT",  attachPoint = "TOPLEFT" },
		["BOTTOMRIGHT"] = { anchorPoint = "BOTTOMRIGHT",  attachPoint = "TOPRIGHT" },
	},
	---Maps an anchorPoint to the closest legacy relativeTo value.
	---Used for dual-write from anchor UI back to legacy fields.
	anchorPointToRelativeToMap = {
		["TOPLEFT"]     = "TOPLEFT",
		["TOP"]         = "TOP",
		["TOPRIGHT"]    = "TOPRIGHT",
		["LEFT"]        = "TOPLEFT",
		["CENTER"]      = "TOP",
		["RIGHT"]       = "TOPRIGHT",
		["BOTTOMLEFT"]  = "BOTTOMLEFT",
		["BOTTOM"]      = "BOTTOM",
		["BOTTOMRIGHT"] = "BOTTOMRIGHT",
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
	castTime = {},
	frame = {},
	range = {}
}
---@type TRB.Classes.SpellThreshold[]
TRB.Data.cache.thresholdSpells = {}
TRB.Data.specCache = {}

-- Canonical registry of all supported class/spec combinations.
-- Each entry maps a compositeKey ("className_specName") to its identifiers.
---@class TRB.Data.SpecRegistryEntry
---@field public classId number
---@field public specId number
---@field public className string   -- all-lowercase, e.g. "deathknight"
---@field public specName string    -- camelCase, e.g. "beastMastery"
---@field public compositeKey string -- "className_specName", e.g. "deathknight_frost"

---@type table<string, TRB.Data.SpecRegistryEntry>
TRB.Data.specRegistry = {}

---@type table<number, table<number, TRB.Data.SpecRegistryEntry>>
TRB.Data.specRegistryByIds = {}

do
	local function reg(classId, specId, className, specName)
		local compositeKey = className .. "_" .. specName
		local entry = {
			classId = classId,
			specId = specId,
			className = className,
			specName = specName,
			compositeKey = compositeKey,
		}
		TRB.Data.specRegistry[compositeKey] = entry
		if not TRB.Data.specRegistryByIds[classId] then
			TRB.Data.specRegistryByIds[classId] = {}
		end
		TRB.Data.specRegistryByIds[classId][specId] = entry
	end

	-- Death Knight (classId 6)
	reg(6, 1, "deathknight", "blood")
	reg(6, 2, "deathknight", "frost")
	reg(6, 3, "deathknight", "unholy")

	-- Demon Hunter (classId 12)
	reg(12, 1, "demonhunter", "havoc")
	reg(12, 2, "demonhunter", "vengeance")
	reg(12, 3, "demonhunter", "devourer")

	-- Druid (classId 11)
	reg(11, 1, "druid", "balance")
	reg(11, 2, "druid", "feral")
	reg(11, 3, "druid", "guardian")
	reg(11, 4, "druid", "restoration")

	-- Evoker (classId 13)
	reg(13, 1, "evoker", "devastation")
	reg(13, 2, "evoker", "preservation")
	reg(13, 3, "evoker", "augmentation")

	-- Hunter (classId 3)
	reg(3, 1, "hunter", "beastMastery")
	reg(3, 2, "hunter", "marksmanship")
	reg(3, 3, "hunter", "survival")

	-- Mage (classId 8)
	reg(8, 1, "mage", "arcane")
	reg(8, 2, "mage", "fire")
	reg(8, 3, "mage", "frost")

	-- Monk (classId 10)
	reg(10, 1, "monk", "brewmaster")
	reg(10, 2, "monk", "mistweaver")
	reg(10, 3, "monk", "windwalker")

	-- Paladin (classId 2)
	reg(2, 1, "paladin", "holy")
	reg(2, 2, "paladin", "protection")
	reg(2, 3, "paladin", "retribution")

	-- Priest (classId 5)
	reg(5, 1, "priest", "discipline")
	reg(5, 2, "priest", "holy")
	reg(5, 3, "priest", "shadow")

	-- Rogue (classId 4)
	reg(4, 1, "rogue", "assassination")
	reg(4, 2, "rogue", "outlaw")
	reg(4, 3, "rogue", "subtlety")

	-- Shaman (classId 7)
	reg(7, 1, "shaman", "elemental")
	reg(7, 2, "shaman", "enhancement")
	reg(7, 3, "shaman", "restoration")

	-- Warlock (classId 9)
	reg(9, 1, "warlock", "affliction")
	reg(9, 2, "warlock", "demonology")
	reg(9, 3, "warlock", "destruction")

	-- Warrior (classId 1)
	reg(1, 1, "warrior", "arms")
	reg(1, 2, "warrior", "fury")
	reg(1, 3, "warrior", "protection")
end

TRB.Data.character = {
	guid = UnitGUID("player"),
	raceId = 0,
	specId = GetSpecialization() or 0,
	classId = classIndexId,
	className = "",
	specName = "",
	compositeKey = nil, -- className_specName composite key, set by CheckCharacter()
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

TRB.Frames.renderTransitionFrame = CreateFrame("Frame")
TRB.Frames.renderTransitionFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TRB.Frames.renderTransitionFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
TRB.Frames.renderTransitionFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
TRB.Frames.renderTransitionFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
TRB.Frames.renderTransitionFrame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
TRB.Frames.renderTransitionFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
TRB.Frames.renderTransitionFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end

	if TRB.Functions and TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
		-- Increase initial transition time to cover the loading sequence delay
		TRB.Functions.Bar:QueueRenderTransition("init:" .. event, 2.5)
	end
end)

-- Settings placeholders
TRB.Frames.interfaceSettingsFrameContainer = {}
TRB.Frames.interfaceSettingsFrameContainer.controls = {}

-- Minimap button: initialize once settings are loaded
local minimapButtonInitFrame = CreateFrame("Frame")
minimapButtonInitFrame:RegisterEvent("PLAYER_LOGIN")
minimapButtonInitFrame:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()
	-- Delay slightly to ensure saved variables and settings merging is complete
	C_Timer.After(2, function()
		TRB.Functions.MinimapButton:Initialize()
	end)
end)


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
	elseif cmd == "minimap" then
		local minimapCmd = ParseCmdString(subcmd)
		if minimapCmd == "hide" then
			TRB.Functions.MinimapButton:Hide()
		elseif minimapCmd == "show" then
			TRB.Functions.MinimapButton:Show()
		else
			TRB.Functions.MinimapButton:Toggle()
		end
	else
		TRB.Options.OptionsFrame:Show()
		if TRB.Data.barConstructedForSpec ~= nil then
			TRB.Options.OptionsFrame:SelectCategory(TRB.Data.barConstructedForSpec)
		else
			TRB.Options.OptionsFrame:SelectCategory("main")
		end
	end
end

Twintop_Data = TRB.Data