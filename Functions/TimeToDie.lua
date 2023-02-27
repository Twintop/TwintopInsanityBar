---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.TimeToDie = {}

local triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = false
local instanceDifficulty = 0

local ttdEventFrame = CreateFrame("Frame", "TwintopResourceBar_TtdEventFrame", TRB.Frames.barContainerFrame)
ttdEventFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if arg3 == 210385 then
            triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = true
        end
    end
end)

-- Reset any values we may have triggered previously whenever a loading screen occurs
local ttdPlayerEnteringWorldFrame = CreateFrame("Frame", "TwintopResourceBar_TtdPlayerEnteringWorldFrame", TRB.Frames.barContainerFrame)
ttdPlayerEnteringWorldFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ttdPlayerEnteringWorldFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local instanceId = select(8, GetInstanceInfo())
        instanceDifficulty = select(3, GetInstanceInfo())

        if instanceId == 1571 then -- Court of Stars
            ttdEventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = false
        end
    end
end)

local function CourtOfStars_PatrolCaptainGerdo()
    if triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight then
        return 0.25
    else
        return 0
    end
end

local function SanctumOfDomination_SylvanasWindrunner()
    if instanceDifficulty == 16 then -- Mythic
        return 0.45
    else
        return 0.5
    end
end

local unitDeathHealthPercentageList = {
    ---- Vanilla ----

    ---- Burning Crusade ----
    --- Hyjal Summit ---
    ["17968"] = 0.1, -- Archimonde

    ---- Wrath of the Lich King ----
    --- Ulduar ---
    ["32871"] = 0.03, -- Algalon the Observer
    --- Icecrown Citadel ---
    ["36597"] = 0.1, -- The Lich King

    ---- Cataclysm ----
    --- Grim Batol ---
    ["40320"] = 0.2, -- Valiona

    ---- Mists of Pandaria ----

    ---- Warlords of Draenor ----
    --- Shadowmoon Burial Grounds ---
    ["76057"] = 0.2, -- Carrion Worm (trash/pre-Bonemaw)

    ---- Legion ----
    --- Court of Stars ---
    ["104215"] = CourtOfStars_PatrolCaptainGerdo,
    --- Halls of Valor ---
    ["94960"] = 0.1, -- Hymdall
    ["95674"] = 0.6, -- Fenryr (p1)
    ["95676"] = 0.8, -- Odyn
    --- Maw of Souls ---
    ["96759"] = 0.7, -- Helya
    --- Trial of Valor ---
    ["114263"] = 0.1, -- Odyn

    ---- Battle for Azeroth ----
    --- Uldir ---
    ["135452"] = 0.1, -- MOTHER
    -- Battle of Dazar'alor ---
    ["165396"] = 0.055, -- Lady Jaina Proudmoore

    ---- Shadowlands ----
    --- De Other Side ---
    ["164555"] = 0.105, -- Millificent Manastorm
    ["164556"] = 0.105, -- Millhouse Manastorm
    ["166608"] = 0.105, -- Mueh'zala
    --- Sanguine Depths ---
    ["162133"] = 0.7, -- General Kaal (gauntlet)
    ["162099"] = 0.505, -- General Kaal
    --- Sanctum of Domination ---
    ["175732"] = SanctumOfDomination_SylvanasWindrunner,

    ---- Dragonflight ----
    --- Brackenhide Hollow ---
    ["186121"] = 0.045, -- Decatriarch Wratheye TODO: verify 5% vs 4.5%
}

function TRB.Functions.TimeToDie:GetUnitDeathHealthPercentage(unit)
    local unitGuid = UnitGUID(unit)

    if select(6, strsplit("-", unitGuid)) ~= nil then
        local npcId = select(6, strsplit("-", unitGuid))
        if type(unitDeathHealthPercentageList[npcId]) == "number" then
            return unitDeathHealthPercentageList[npcId] or 0
        elseif type(unitDeathHealthPercentageList[npcId]) == "function" then
            return unitDeathHealthPercentageList[npcId]() or 0
        else
            return 0
        end
    else
        return 0
    end
end