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

TRB.Details.addonData = addonData

-- Some class functions get referenced by other methods. These live in a consistent location but are actually created in the class modules.
TRB.Functions = TRB.Functions or {}
TRB.Functions.Class = {}

---Returns true when spec-specific timer variables (buff durations, rune cooldowns, etc.)
---are actively counting down, meaning lookup data changes with elapsed time even when
---no events fire. Each class module overrides this for specs that have such variables.
---The base implementation returns false (no spec-specific timers).
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	return false
end

-- Working data
TRB.Data = {}

-- Central registry of per-spec maximum primary resource values. Single source of truth shared by
-- the class options panels (default maxResource / overcap config) and the custom-threshold form
-- sub-targets (e.g. Druid's per-form primary thresholds), so the numbers are never duplicated.
-- Keyed by class token -> spec token -> resource token -> max value.
TRB.Data.maxResource = {
	deathknight = {
		blood = { runicPower = 125 },
		frost = { runicPower = 110 },
		unholy = { runicPower = 100 },
	},
	demonhunter = {
		havoc = { fury = 170 },
		vengeance = { fury = 120 },
		devourer = { fury = 140 },
	},
	druid = {
		balance = { astralPower = 140 },
		feral = { energy = 160 },
		guardian = { rage = 100 },
	},
	hunter = {
		beastMastery = { focus = 100 },
		marksmanship = { focus = 100 },
		survival = { focus = 100 },
	},
	monk = {
		brewmaster = { energy = 100 },
		windwalker = { energy = 150 },
	},
	priest = {
		shadow = { insanity = 150 },
	},
	rogue = {
		assassination = { energy = 300 },
		outlaw = { energy = 250 },
		subtlety = { energy = 200 },
	},
	shaman = {
		elemental = { maelstrom = 175 },
	},
	warrior = {
		arms = { rage = 130 },
		fury = { rage = 130 },
		protection = { rage = 130 },
	},
}
-- Dirty flag: set to true whenever data consumed by lookup refresh changes.
-- When false and no timers are active, UpdateResourceBarText skips the refresh entirely.
TRB.Data.lookupDirty = true

TRB.Data.constants = {
	borderWidthFactor = 2,
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
		gradientColorPickerFrameSize = 25,
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
	backdrop = {},
	gradient = {}
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
---@field public classToken string  -- uppercase WoW class file token, e.g. "DEATHKNIGHT"
---@field public classModuleName string -- PascalCase addon module key, e.g. "DeathKnight"
---@field public specName string    -- camelCase, e.g. "beastMastery"
---@field public specNameLower string -- all-lowercase convenience form, e.g. "beastmastery"
---@field public specNameUpper string -- uppercase convenience form, e.g. "BEASTMASTERY"
---@field public compositeKey string -- "className_specName", e.g. "deathknight_frost"

---@class TRB.Data.ClassRegistryEntry
---@field public classId number
---@field public className string   -- all-lowercase settings key, e.g. "deathknight"
---@field public classToken string  -- uppercase WoW class file token, e.g. "DEATHKNIGHT"
---@field public classModuleName string -- PascalCase addon module/options key, e.g. "DeathKnight"
---@field public specs TRB.Data.SpecRegistryEntry[]

---@type TRB.Data.ClassRegistryEntry[]
TRB.Data.classRegistryOrder = {}

---@type table<string, TRB.Data.ClassRegistryEntry>
TRB.Data.classRegistry = {}

---@type table<number, TRB.Data.ClassRegistryEntry>
TRB.Data.classRegistryByIds = {}

---@type table<string, TRB.Data.ClassRegistryEntry>
TRB.Data.classRegistryByTokens = {}

---@type TRB.Data.SpecRegistryEntry[]
TRB.Data.specRegistryOrder = {}

---@type table<string, TRB.Data.SpecRegistryEntry>
TRB.Data.specRegistry = {}

---@type table<number, table<number, TRB.Data.SpecRegistryEntry>>
TRB.Data.specRegistryByIds = {}

do
	local function regClass(classId, className, classToken, classModuleName, specs)
		local classEntry = {
			classId = classId,
			className = className,
			classToken = classToken,
			classModuleName = classModuleName,
			specs = {},
		}

		TRB.Data.classRegistry[className] = classEntry
		TRB.Data.classRegistryByIds[classId] = classEntry
		TRB.Data.classRegistryByTokens[classToken] = classEntry
		table.insert(TRB.Data.classRegistryOrder, classEntry)

		if not TRB.Data.specRegistryByIds[classId] then
			TRB.Data.specRegistryByIds[classId] = {}
		end

		for _, spec in ipairs(specs) do
			local specId = spec[1]
			local specName = spec[2]
			local compositeKey = className .. "_" .. specName
			local entry = {
				classId = classId,
				specId = specId,
				className = className,
				classToken = classToken,
				classModuleName = classModuleName,
				specName = specName,
				specNameLower = string.lower(specName),
				specNameUpper = string.upper(specName),
				compositeKey = compositeKey,
			}
			TRB.Data.specRegistry[compositeKey] = entry
			TRB.Data.specRegistryByIds[classId][specId] = entry
			table.insert(classEntry.specs, entry)
			table.insert(TRB.Data.specRegistryOrder, entry)
		end
	end

	regClass(1, "warrior", "WARRIOR", "Warrior", {
		{ 1, "arms" }, { 2, "fury" }, { 3, "protection" }
	})
	regClass(2, "paladin", "PALADIN", "Paladin", {
		{ 1, "holy" }, { 2, "protection" }, { 3, "retribution" }
	})
	regClass(3, "hunter", "HUNTER", "Hunter", {
		{ 1, "beastMastery" }, { 2, "marksmanship" }, { 3, "survival" }
	})
	regClass(4, "rogue", "ROGUE", "Rogue", {
		{ 1, "assassination" }, { 2, "outlaw" }, { 3, "subtlety" }
	})
	regClass(5, "priest", "PRIEST", "Priest", {
		{ 1, "discipline" }, { 2, "holy" }, { 3, "shadow" }
	})
	regClass(6, "deathknight", "DEATHKNIGHT", "DeathKnight", {
		{ 1, "blood" }, { 2, "frost" }, { 3, "unholy" }
	})
	regClass(7, "shaman", "SHAMAN", "Shaman", {
		{ 1, "elemental" }, { 2, "enhancement" }, { 3, "restoration" }
	})
	regClass(8, "mage", "MAGE", "Mage", {
		{ 1, "arcane" }, { 2, "fire" }, { 3, "frost" }
	})
	regClass(9, "warlock", "WARLOCK", "Warlock", {
		{ 1, "affliction" }, { 2, "demonology" }, { 3, "destruction" }
	})
	regClass(10, "monk", "MONK", "Monk", {
		{ 1, "brewmaster" }, { 2, "mistweaver" }, { 3, "windwalker" }
	})
	regClass(11, "druid", "DRUID", "Druid", {
		{ 1, "balance" }, { 2, "feral" }, { 3, "guardian" }, { 4, "restoration" }
	})
	regClass(12, "demonhunter", "DEMONHUNTER", "DemonHunter", {
		{ 1, "havoc" }, { 2, "vengeance" }, { 3, "devourer" }
	})
	regClass(13, "evoker", "EVOKER", "Evoker", {
		{ 1, "devastation" }, { 2, "preservation" }, { 3, "augmentation" }
	})
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

-- Global player cast/channel/empower state model for the castbar bar type.
TRB.Data.castbar = TRB.Classes.Castbar:New()

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
	-- Fully invalidate memoization so formatting branches that depend on inCombat
	-- (e.g., overcap text coloring) rewrite all lookup strings on the next refresh.
	TRB.Functions.BarText:InvalidateLookupMemoization()
	TRB.Functions.BarVisibility:MarkDirty()
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

	if event == "PLAYER_TALENT_UPDATE" then
		local specName = TRB.Data.barConstructedForSpec
		if specName ~= nil and TRB.Data.specCache[specName] ~= nil and TRB.Data.specCache[specName].talents ~= nil then
			if not TRB.Data.specCache[specName].talents:HaveTalentsChanged() then
				return
			end
		end
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