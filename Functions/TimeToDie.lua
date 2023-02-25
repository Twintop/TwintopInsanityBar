---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.TimeToDie = {}

local triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = false

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
    --local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    local difficultyID = select(3, GetInstanceInfo())

    if difficultyID == 16 then -- Mythic
        return 0.45
    else
        return 0.5
    end
end

local unitDeathHealthPercentageList = {
    ---- Wrath of the Lich King ----
    --- Icecrown Citadel
    ["36597"] = 0.1, -- The Lich King

    ---- Warlords of Draenor ----
    -- Shadowmoon Burial Grounds
    ["76057"] = 0.2, -- Carrion Worm (pre-Bonemaw)

    ---- Legion ----
    -- Court of Stars
    ["104215"] = CourtOfStars_PatrolCaptainGerdo,
    -- Halls of Valor
    ["94960"] = 0.1, -- Hymdall
    ["95674"] = 0.6, -- Fenryr (p1)
    ["95676"] = 0.8, -- Odyn    
    -- Trial of Valor
    ["114263"] = 0.1, -- Odyn
    
    ---- Battle for Azeroth ----
    -- Battle of Dazar'alor
    ["165396"] = 0.055, -- Lady Jaina Proudmoore

    ---- Shadowlands ----
    -- Sanctum of Domination
    ["175732"] = SanctumOfDomination_SylvanasWindrunner
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