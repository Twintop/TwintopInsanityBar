local _, TRB = ...

-- Addon details data
TRB.Details = {}
TRB.Details.addonVersion = "9.0.5.3"
TRB.Details.addonReleaseDate = "February 22, 2021"
TRB.Details.supportedSpecs = "|cFFFF7C0ADruid|r - Balance\n|cFFAAD372Hunter|r - Beast Mastery, Marksmanship, Survival\n|cFFFFFFFFPriest|r - Shadow\n|cFF0070DDShaman|r - Elemental"

local addonData = {
	loaded = false,
	registered = false,
	libs = {}
}
addonData.libs.SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
addonData.libs.SharedMedia:Register("sound", "TRB: Wilhelm Scream", "Interface\\Addons\\TwintopInsanityBar\\wilhelm.ogg")
addonData.libs.SharedMedia:Register("sound", "TRB: Boxing Arena Gong", "Interface\\Addons\\TwintopInsanityBar\\BoxingArenaSound.ogg")
addonData.libs.SharedMedia:Register("sound", "TRB: Air Horn", "Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg")
TRB.Details.addonData = addonData

-- Frames
TRB.Frames = {}

TRB.Frames.barContainerFrame = CreateFrame("Frame", "TwintopResourceBarFrame", UIParent, "BackdropTemplate")
TRB.Frames.resourceFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")
TRB.Frames.castingFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")
TRB.Frames.passiveFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")
TRB.Frames.barBorderFrame = CreateFrame("StatusBar", nil, TRB.Frames.barContainerFrame, "BackdropTemplate")

TRB.Frames.passiveFrame.thresholds = {}
TRB.Frames.resourceFrame.thresholds = {}

TRB.Frames.leftTextFrame = CreateFrame("Frame", nil, TRB.Frames.barContainerFrame)
TRB.Frames.middleTextFrame = CreateFrame("Frame", nil, TRB.Frames.barContainerFrame)
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

TRB.Frames.combatFrame = CreateFrame("Frame")

TRB.Frames.interfaceSettingsFrameContainer = {}
TRB.Frames.interfaceSettingsFrameContainer.controls = {}

-- Working data
TRB.Data = {}

TRB.Data.settings = {}

TRB.Data.specSupported = false
TRB.Data.resource = nil 
TRB.Data.resourceFactor = 1

TRB.Data.barTextVariables = {
    icons = {},
    values = {},
	pipe = {
		{ variable = "||n", description = "Insert a Newline", printInSettings = true },
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
	specGroup = GetActiveSpecGroup(),
    maxResource = 100,
    talents = {},
    items = {}
}

TRB.Data.spells = {}

TRB.Data.lookup = {}

-- This is here for reference/what every implementation should use as a minimum
TRB.Functions.ResetSnapshotData()

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

-- This gets overwritten with a spec/class specific version of the function
local function BarText()
    return "", "", ""
end
TRB.Data.BarText = BarText

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

function SlashCmdList.TWINTOP(msg)
    local cmd, subcmd = TRB.Functions.ParseCmdString(msg);
    if cmd == "reset" then
        StaticPopup_Show("TwintopResourceBar_Reset")
    elseif cmd == "set" then
        cmd, subcmd = TRB.Functions.ParseCmdString(subcmd)

        if cmd == "numEntries" and subcmd ~= nil then
            local num = TRB.Functions.RoundTo(subcmd, 0)
            settings.ttd.numEntries = num
        end
    elseif cmd == "fill" then
        TRB.Functions.FillSpellData()
    elseif cmd == "move" then
        local x, y = TRB.Functions.ParseCmdString(subcmd)
        TRB.Functions.UpdateBarPosition(tonumber(x), tonumber(y))
    else
        InterfaceOptionsFrame_OpenToCategory(TRB.Frames.interfaceSettingsFrameContainer.panel)
    end
end