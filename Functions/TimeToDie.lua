---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.TimeToDie = {}

local function CourtOfStars_PatrolCaptainGerdo()
    -- TODO: How to determine if the Flask of Solemn Night has been clicked?
    -- return 0.25
    return 0
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
    -- Shadowmoon Burial Grounds
    ["76057"] = 0.2, -- Carrion Worm (pre-Bonemaw)

    -- Court of Stars
    ["104215"] = CourtOfStars_PatrolCaptainGerdo(),

    -- Halls of Valor
    ["94960"] = 0.1, -- Hymdall
    ["95674"] = 0.6, -- Fenryr (p1)
    ["95676"] = 0.8, -- Odyn
    
    -- Trial of Valor
    ["114263"] = 0.1, -- Odyn
    
    -- Sanctum of Domination
    ["175732"] = SanctumOfDomination_SylvanasWindrunner()
}

function TRB.Functions.TimeToDie:GetUnitDeathHealthPercentage(unit)
    local unitGuid = UnitGUID(unit)

    if select(1, strsplit("-", unitGuid)) == "Creature" then
        local npcId = select(6, strsplit("-", unitGuid))
        return unitDeathHealthPercentageList[npcId] or 0
    else
        return 0
    end
end