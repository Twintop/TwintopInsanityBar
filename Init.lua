local addonName, TRB = ...
local _, _, classIndexId = UnitClass("player")

-- Addon details data
TRB.Details = {}
TRB.Details.addonVersion = GetAddOnMetadata(addonName, "Version") .. "-" .. GetAddOnMetadata(addonName, "X-ReleaseType")
TRB.Details.addonAuthor = GetAddOnMetadata(addonName, "Author")
TRB.Details.addonAuthorServer = GetAddOnMetadata(addonName, "X-AuthorServer")
TRB.Details.addonTitle = GetAddOnMetadata(addonName, "Title")
TRB.Details.addonReleaseDate = GetAddOnMetadata(addonName, "X-ReleaseDate")
TRB.Details.supportedSpecs = "|cFFA330C9Demon Hunter|r - Havoc\n|cFFFF7C0ADruid|r - Balance, Feral, Restoration\n|cFF33937FEvoker|r - Devastation (Experimental/Minimal), Preservation (Experimental)\n|cFFAAD372Hunter|r - Beast Mastery, Marksmanship, Survival\n|cFF00FF98Monk|r - Mistweaver, Windwalker\n|cFFFFFFFFPriest|r - Holy, Shadow\n|cFFFFF468Rogue|r - Assassination, Outlaw\n|cFF0070DDShaman|r - Elemental, Restoration\n|cFFC69B6DWarrior|r - Arms, Fury"

local addonData = {
	loaded = false,
	registered = false,
	libs = {}
}
addonData.libs.SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
---@diagnostic disable-next-line: undefined-field
addonData.libs.SharedMedia:Register("sound", "TRB: Wilhelm Scream", "Interface\\Addons\\TwintopInsanityBar\\Sounds\\wilhelm.ogg")
---@diagnostic disable-next-line: undefined-field
addonData.libs.SharedMedia:Register("sound", "TRB: Boxing Arena Gong", "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg")
---@diagnostic disable-next-line: undefined-field
addonData.libs.SharedMedia:Register("sound", "TRB: Air Horn", "Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg")

---@diagnostic disable-next-line: undefined-field
if not addonData.libs.SharedMedia:IsValid("border", "1 Pixel") then
	---@diagnostic disable-next-line: undefined-field
	addonData.libs.SharedMedia:Register("border", "1 Pixel", "Interface\\Buttons\\WHITE8X8")
end

TRB.Details.addonData = addonData

-- Frames
TRB.Frames = {}

TRB.Frames.barContainerFrame = CreateFrame("Frame", "TwintopResourceBarFrame", UIParent, "BackdropTemplate")
---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.resourceFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")
---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.castingFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")
---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.passiveFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")
---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.barBorderFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")

TRB.Frames.passiveFrame.thresholds = {}
TRB.Frames.resourceFrame.thresholds = {}

---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.leftTextFrame = CreateFrame("Frame", nil, TRB.Frames.barContainerFrame)
---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.middleTextFrame = CreateFrame("Frame", nil, TRB.Frames.barContainerFrame)
---@diagnostic disable-next-line: param-type-mismatch
TRB.Frames.rightTextFrame = CreateFrame("Frame", nil, TRB.Frames.barContainerFrame)

TRB.Frames.leftTextFrame.font = TRB.Frames.leftTextFrame:CreateFontString(nil, "BACKGROUND")
TRB.Frames.middleTextFrame.font = TRB.Frames.middleTextFrame:CreateFontString(nil, "BACKGROUND")
TRB.Frames.rightTextFrame.font = TRB.Frames.rightTextFrame:CreateFontString(nil, "BACKGROUND")

TRB.Frames.targetsTimerFrame = CreateFrame("Frame")
TRB.Frames.targetsTimerFrame.sinceLastUpdate = 0

TRB.Frames.timerFrame = CreateFrame("Frame")
TRB.Frames.timerFrame.sinceLastUpdate = 0
TRB.Frames.timerFrame.ttdSinceLastUpdate = 0
TRB.Frames.timerFrame.characterCheckSinceLastUpdate = 0

-- For the following specs, we need to have a secondary bar/bars created
-- We're going to make these as StatusBars so we can use them for Death Knight runes and Warlock soulshards in the future
if classIndexId == 4 or classIndexId == 10 or classIndexId == 11 or classIndexId == 13 then
	TRB.Frames.resource2Frames = {}
	---@diagnostic disable-next-line: param-type-mismatch
	TRB.Frames.resource2ContainerFrame = CreateFrame("Frame", "TwintopResourceBarFrame2", TRB.Frames.barContainerFrame, "BackdropTemplate")
	
	for x = 1, 7 do
		TRB.Frames.resource2Frames[x] = {}
		---@diagnostic disable-next-line: param-type-mismatch
		TRB.Frames.resource2Frames[x].containerFrame = CreateFrame("Frame", nil, TRB.Frames.resource2ContainerFrame, "BackdropTemplate")
		TRB.Frames.resource2Frames[x].borderFrame = CreateFrame("StatusBar", nil, TRB.Frames.resource2Frames[x].containerFrame, "BackdropTemplate")
		TRB.Frames.resource2Frames[x].resourceFrame = CreateFrame("StatusBar", nil, TRB.Frames.resource2Frames[x].containerFrame, "BackdropTemplate")
	end
end

function TRB.Frames.timerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	self.ttdSinceLastUpdate = self.ttdSinceLastUpdate + sinceLastUpdate
	self.characterCheckSinceLastUpdate  = self.characterCheckSinceLastUpdate  + sinceLastUpdate
	if self.sinceLastUpdate >= 0.05 then -- in seconds
		TRB.Functions.Class:TriggerResourceBarUpdates()
		--EventRegistry.TriggerEvent("TwintopResourceBar.Update", "trigger")
		self.sinceLastUpdate = 0
	end

	if self.characterCheckSinceLastUpdate >= TRB.Data.settings.core.dataRefreshRate then -- in seconds
		TRB.Functions.Class:CheckCharacter()
		self.characterCheckSinceLastUpdate  = 0
	end

	local guid = UnitGUID("target")
	if TRB.Data.snapshotData.targetData.currentTargetGuid ~= guid then
		TRB.Data.snapshotData.targetData.currentTargetGuid = guid
	end

	if guid ~= TRB.Data.character.guid and TRB.Data.snapshotData.targetData.ttdIsActive and self.ttdSinceLastUpdate >= TRB.Data.settings.core.ttd.sampleRate then -- in seconds
		local currentTime = GetTime()

		if guid ~= nil then
			TRB.Functions.Target.InitializeTarget_Class(guid)

			local isDead = UnitIsDeadOrGhost("target")
			local currentHealth = UnitHealth("target")
			local maxHealth = UnitHealthMax("target")
			local healthDelta = 0
			local timeDelta = 0
			local dps = 0
			local ttd = 0
			local count = 0

			if TRB.Data.snapshotData.targetData.targets[guid] ~= nil then
				count = TRB.Functions.Table:Length(TRB.Data.snapshotData.targetData.targets[guid].snapshot)
				if count > 0 and TRB.Data.snapshotData.targetData.targets[guid].snapshot[1] ~= nil then
					healthDelta = math.max(TRB.Data.snapshotData.targetData.targets[guid].snapshot[1].health - currentHealth, 0)
					timeDelta = math.max(currentTime - TRB.Data.snapshotData.targetData.targets[guid].snapshot[1].time, 0)
				end
			end

			if isDead then
				TRB.Functions.Target:RemoveTarget(guid)
			elseif currentHealth <= 0 or maxHealth <= 0 then
				dps = 0
				ttd = 0
			else
				if count == 0 or TRB.Data.snapshotData.targetData.targets[guid].snapshot[count] == nil or
					(TRB.Data.snapshotData.targetData.targets[guid].snapshot[1].health == currentHealth and count == TRB.Data.settings.core.ttd.numEntries) then
					dps = 0
				elseif healthDelta == 0 or timeDelta == 0 then
					dps = TRB.Data.snapshotData.targetData.targets[guid].snapshot[count].dps
				else
					dps = healthDelta / timeDelta
				end

				if dps == nil or dps == 0 then
					ttd = 0
				else
					ttd = currentHealth / dps
				end
			end

			if not isDead then
				TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = currentTime

				if count >= TRB.Data.settings.core.ttd.numEntries then
					table.remove(TRB.Data.snapshotData.targetData.targets[guid].snapshot, 1)
				end

				table.insert(TRB.Data.snapshotData.targetData.targets[guid].snapshot, {
					health=currentHealth,
					time=currentTime,
					dps=dps
				})

				TRB.Data.snapshotData.targetData.targets[guid].ttd = ttd
			end
		end
		self.ttdSinceLastUpdate = 0
	end
end

TRB.Frames.combatFrame = CreateFrame("Frame")

-- Settings placeholders
TRB.Frames.interfaceSettingsFrameContainer = {}
TRB.Frames.interfaceSettingsFrameContainer.controls = {}

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
			soundName="TRB: Air Horn"
		}
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
		{ variable = "||n", description = "Insert a Newline. Alternative to pressing Enter.", printInSettings = true },
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
---@diagnostic disable-next-line: missing-parameter
	specGroup = GetActiveSpecGroup(),
    maxResource = 100,
    talents = {},
    items = {}
}

TRB.Data.spells = {}

TRB.Data.lookup = {}
TRB.Data.lookupLogic = {}

TRB.Functions.Character:ResetSnapshotData()

TRB.Data.sanityCheckValues = {
	barMaxWidth = 0,
	barMinWidth = 0,
	barMaxHeight = 0,
	barMinHeight = 0
}

-- This gets overwritten with a spec/class specific version of the function
local function IsValidVariableForSpec(input)
    return true
end
TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

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
        StaticPopup_Show("TwintopResourceBar_Reset")
    elseif cmd == "fill" then
        TRB.Functions.Spell:FillSpellData()
    elseif cmd == "move" then
        local x, y = ParseCmdString(subcmd)
        TRB.Functions.Bar:SetPositionXY(tonumber(x), tonumber(y))
    else
		Settings.OpenToCategory(TRB.Frames.interfaceSettingsFrameContainer.panel)
        --InterfaceOptionsFrame_OpenToCategory(TRB.Frames.interfaceSettingsFrameContainer.panel)
    end
end
