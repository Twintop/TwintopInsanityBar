---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.TimeToDie = {}

local triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = false
local instanceDifficulty = 0
local instanceId = 0
local locale = "enUS"

local ttdEventFrame = CreateFrame("Frame", "TwintopResourceBar_TtdEventFrame", TRB.Frames.barContainerFrame)
ttdEventFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if arg3 == 210385 then
            triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = true
        end
    elseif event == "CHAT_MSG_MONSTER_EMOTE" then
        if instanceId == 1571 then
            if ((locale == "enUS" or locale == "enGB" or locale == "enTW" or locale == "enCN") and string.find(arg1, "sneakily adds poison to the Flask of the Solemn Night.")) or
                ((locale == "esMX") and string.find(arg1, "agrega sigilosamente veneno al frasco de la noche solemne.")) or
                ((locale == "esES") and string.find(arg1, "añade veneno al frasco de la noche solemne!")) or
                ((locale == "ptBR" or locale == "ptPT") and string.find(arg1, "sorrateiramente põe veneno no Frasco da Noite Solene.")) or
                ((locale == "frFR") and string.find(arg1, "ajoute discrètement du poison dans le flacon de la nuit solennelle.")) or
                ((locale == "deDE") and string.find(arg1, "fügt dem Fläschchen der ehrwürdigen Nacht heimlich Gift hinzu.")) or
                ((locale == "itIT") and string.find(arg1, "versa furtivamente del veleno nel Tonico della Notte Solenne.")) or
                ((locale == "ruRU") and string.find(arg1, "незаметно добавляет яд в настой священной ночи.")) or
                ((locale == "koKR") and string.find(arg1, "엄숙한 밤의 영약에 몰래 독을 더합니다.")) or
                ((locale == "zhCN") and string.find(arg1, "偷偷在庄严静夜合剂中下了毒。")) or
                ((locale == "zhTW") and string.find(arg1, "偷偷地在莊嚴之夜藥劑裡面加入毒藥。")) then
                triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = true
            end
        end
    end
end)

-- Reset any values we may have triggered previously whenever a loading screen occurs
local ttdPlayerEnteringWorldFrame = CreateFrame("Frame", "TwintopResourceBar_TtdPlayerEnteringWorldFrame", TRB.Frames.barContainerFrame)
ttdPlayerEnteringWorldFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ttdPlayerEnteringWorldFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        ttdEventFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        ttdEventFrame:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE")
        
        locale = GetLocale()
        instanceId = select(8, GetInstanceInfo())
        instanceDifficulty = select(3, GetInstanceInfo())

        if instanceId == 1571 then -- Court of Stars
            ttdEventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            ttdEventFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
            triggeredCourtOfStars_PatrolCaptainGerdo_FlaskOfSolemnNight = false
        end
    end
end)

local function Firelands_Ragnaros()
    if instanceDifficulty == 3 or -- Normal 10 man
        instanceDifficulty == 4 or -- Normal 25 man
        instanceDifficulty == 33 then -- Timewalking
        return 0.1
    else
        return 0.0
    end
end

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
    ["40320"] = 0.505, -- Valiona
    --- Firelands ---
    ["52409"] = Firelands_Ragnaros,

    ---- Mists of Pandaria ----
    --- Mogu'shan Palace ---
    ["61442"] = 0.1, -- Kuai the Brute
    ["61444"] = 0.1, -- Ming the Cunning
    ["61445"] = 0.1, -- Haiyan the Unstoppable

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
    --- Battle of Dazar'alor ---
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
    ["209574"] = 0.2, -- Aurostor
    --- Brackenhide Hollow ---
    ["186121"] = 0.045, -- Decatriarch Wratheye
    --- Uldaman: Legacy of Tyr ---
    ["184580"] = 0.1, -- Olaf
    ["184581"] = 0.1, -- Baelog
    ["184582"] = 0.1, -- Eric "The Swift"
    --- Dawn of the Infinite ---
    ["198933"] = 0.85, -- Iridikron

    ---- The War Within ----
    --- Darkflame Cleft ---
    ["208747"] = 0.445, -- The Darkness
    --- The Dawnbreaker ---
    ["213937"] = 0.605, -- Rasta'nan
}

function TRB.Functions.TimeToDie:GetUnitDeathHealthPercentage(unit)
    local unitGuid = UnitGUID(unit)

    return TRB.Functions.TimeToDie:GetDeathHealthPercentage(unitGuid)
end

function TRB.Functions.TimeToDie:GetDeathHealthPercentage(guid)
    local npcId = select(6, strsplit("-", guid))
    if npcId ~= nil then
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