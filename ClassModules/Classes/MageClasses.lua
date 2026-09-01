local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Mage = TRB.Classes.Mage or {}


---@class TRB.Classes.Mage.ArcaneSpells : TRB.Classes.SpecializationSpellsBase
---@field arcaneSurge TRB.Classes.SpellBase
---@field arcaneSalvo TRB.Classes.SpellBase
TRB.Classes.Mage.ArcaneSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.ArcaneSpells.__index = TRB.Classes.Mage.ArcaneSpells

function TRB.Classes.Mage.ArcaneSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.ArcaneSpells) --[[@as TRB.Classes.Mage.ArcaneSpells]]
    -- Mage Class Baseline Abilities

    -- Arcane Baseline Abilities
    self.arcaneSurge = TRB.Classes.SpellBase:New({
        id = 365350,
        duration = 15
    })

    -- Mage Class Talents

    -- Arcane Spec Talents

    -- Stacks are read off Arcane Barrage's cast count, so the bar tracks that spell, not the talent.
    self.arcaneSalvo = TRB.Classes.SpellBase:New({
        id = 44425,
        talentId = 384452,
        isTalent = true,
        maxStacks = TRB.Data.maxResource.mage.arcane.arcaneSalvo
    })

    return self
end

---Fills barTextVariables for Arcane Mage options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mage.ArcaneSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mage.ArcaneSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#arcaneSurge", icon = spells.arcaneSurge.icon, description = spells.arcaneSurge.name, printInSettings = true },
		{ variable = "#arcaneSalvo", icon = spells.arcaneSalvo.icon, description = spells.arcaneSalvo.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MageBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["MageBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["MageBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["MageBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
					
		{ variable = "$arcaneCharges", description = L["MageArcaneBarTextVariable_arcaneCharges"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$arcaneChargesMax", description = L["MageArcaneBarTextVariable_arcaneChargesMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		-- Duration is read from the spell description at cast time, so this stays a plain number.
		{ variable = "$arcaneSurgeTime", description = L["MageArcaneBarTextVariable_arcaneSurgeTime"], printInSettings = true, color = false },

		-- Stack count comes from Arcane Barrage's cast count, which is secret in combat.
		{ variable = "$arcaneSalvoStacks", description = L["MageArcaneBarTextVariable_arcaneSalvoStacks"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$arcaneSalvoStacksMax", description = L["MageArcaneBarTextVariable_arcaneSalvoStacksMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
	})
end

---Gets built-in castbar channel tick profiles for Arcane, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mage.ArcaneSpells.GetCastbarTickProfiles()
	return {
		-- Arcane Missiles
		[5143] = { mode = "fixedCount", baseDuration = 2, tickCount = 5, firstTickAtStart = true, chains = true },
		-- Kleptomania
		[198100] = { mode = "fixedCount", baseDuration = 4, tickCount = 8 },
	}
end

-- Key the Midnight Season 2 Arcane set is registered under at the bottom of this file.
local arcaneMidnightSeason2SetKey = "mage_arcane_midnightSeason2"

---Gets built-in castbar tick modifiers for Arcane (talent/set/buff-conditional bonus ticks), keyed by
---channel spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.CastbarTickModifier[]>
function TRB.Classes.Mage.ArcaneSpells.GetCastbarTickModifiers()
	return {
		-- Arcane Missiles
		[5143] = {
			-- Amplification: +2 missiles while talented
			{ talentId = 236628, bonusTicks = 2 },
			-- Midnight Season 2 (2pc): +1 missile over the same channel duration
			{ setBonus = arcaneMidnightSeason2SetKey, setBonusPieces = 2, bonusTicks = 1 },
		},
	}
end


---@class TRB.Classes.Mage.FireSpells : TRB.Classes.SpecializationSpellsBase
---@field fireBlast TRB.Classes.SpellBase
---@field flameOn TRB.Classes.SpellBase
---@field ferventFlickering TRB.Classes.SpellBase
TRB.Classes.Mage.FireSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.FireSpells.__index = TRB.Classes.Mage.FireSpells

function TRB.Classes.Mage.FireSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.FireSpells) --[[@as TRB.Classes.Mage.FireSpells]]
    
    self.fireBlast = TRB.Classes.SpellBase:New({
        id = 108853,
        talentId = 1246833,
        isTalent = true,
        hasCharges = true
    })

    -- Flame On: grants +1 Fire Blast charge
    self.flameOn = TRB.Classes.SpellBase:New({
        id = 205029,
        talentId = 205029,
        isTalent = true,
    })

    -- Fervent Flickering: grants +1 Fire Blast charge
    self.ferventFlickering = TRB.Classes.SpellBase:New({
        id = 387044,
        talentId = 387044,
        isTalent = true,
    })

    return self
end

---Fills barTextVariables for Fire Mage options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mage.FireSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mage.FireSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MageBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["MageBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["MageBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["MageBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$fireBlastCharges", description = L["MageFireBarTextVariable_fireBlastCharges"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCE },
        { variable = "$fbCharges", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCE },
        { variable = "$fireBlastChargesMax", description = L["MageFireBarTextVariable_fireBlastChargesMax"], printInSettings = true, color = false, category = varCategory.RESOURCE },
        { variable = "$fbChargesMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCE },
		{ variable = "$fireBlastTime", description = L["MageFireBarTextVariable_fireBlastTime"], printInSettings = true, color = false, secret = true },
		{ variable = "$fbTime", description = "", printInSettings = false, color = false, secret = true },
	})
end

---Gets built-in castbar channel tick profiles for Fire, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mage.FireSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Mage.FrostSpells : TRB.Classes.SpecializationSpellsBase
---@field icicles TRB.Classes.SpellBase
---@field shatter TRB.Classes.SpellBase
---@field iceLance TRB.Classes.SpellBase
---@field fingersOfFrost TRB.Classes.SpellBase
---@field brainFreeze TRB.Classes.SpellBase
TRB.Classes.Mage.FrostSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mage.FrostSpells.__index = TRB.Classes.Mage.FrostSpells

function TRB.Classes.Mage.FrostSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mage.FrostSpells) --[[@as TRB.Classes.Mage.FrostSpells]]

    self.icicles = TRB.Classes.SpellBase:New({
        id = 205473,
        talentId = 1246832,
        isTalent = true,
        maxStacks = 5
    })
    self.shatter = TRB.Classes.SpellBase:New({
        id = 1246769,
        maxStacks = 20,
        stackThreshold = 5
    })
    self.iceLance = TRB.Classes.SpellBase:New({
        id = 30455
    })
    self.fingersOfFrost = TRB.Classes.SpellBase:New({
        id = 44544,
        duration = 15,
        maxStacks = 2
    })
    self.brainFreeze = TRB.Classes.SpellBase:New({
        id = 190446
    })

    return self
end

---Fills barTextVariables for Frost Mage options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mage.FrostSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mage.FrostSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#shatter", icon = spells.shatter.icon, description = spells.shatter.name, printInSettings = true },
		{ variable = "#fingersOfFrost", icon = spells.fingersOfFrost.icon, description = spells.fingersOfFrost.name, printInSettings = true },
		{ variable = "#brainFreeze", icon = spells.brainFreeze.icon, description = spells.brainFreeze.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MageBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["MageBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["MageBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["MageBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$icicles", description = L["MageFrostBarTextVariable_icicles"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$iciclesMax", description = L["MageFrostBarTextVariable_iciclesMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		-- Stack count exists only on the Cooldown Manager's item for Shatter; the max is spell data.
		{ variable = "$shatterStacks", description = L["MageFrostBarTextVariable_shatterStacks"], printInSettings = true, color = false, secret = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
		{ variable = "$shatterStacksMax", description = L["MageFrostBarTextVariable_shatterStacksMax"], printInSettings = true, color = false },

		-- Tracked in Lua off SPELL_UPDATE_USES, so these stay plain numbers rather than secrets.
		{ variable = "$fingersOfFrostStacks", description = L["MageFrostBarTextVariable_fingersOfFrostStacks"], printInSettings = true, color = false },
		{ variable = "$fingersOfFrostStacksMax", description = L["MageFrostBarTextVariable_fingersOfFrostStacksMax"], printInSettings = true, color = false },
		{ variable = "$fingersOfFrostTime", description = L["MageFrostBarTextVariable_fingersOfFrostTime"], printInSettings = true, color = false },

		{ variable = "$brainFreezeTime", description = L["MageFrostBarTextVariable_brainFreezeTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
	})
end

---Gets built-in castbar channel tick profiles for Frost, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mage.FrostSpells.GetCastbarTickProfiles()
	return {
		-- Ray of Frost
		[205021] = { mode = "fixedCount", baseDuration = 4, tickCount = 8 },
    }
end


--[[
    BarGroups Factory for Mage
    Creates the appropriate BarGroup instances for each Mage specialization.
    
    Arcane: Primary bar (N=1) + Arcane Charges (N=4) + Arcane Salvo (N=1, 0-25 via GetSpellCastCount)
    Fire: Primary bar (N=1) + Fire Blast Charges (N=3)
    Frost: Primary bar (N=1) + Icicles (N=5)
]]

---@class TRB.Classes.Mage.BarGroupsFactory
TRB.Classes.Mage.BarGroupsFactory = {}
TRB.Classes.Mage.BarGroupsFactory.__index = TRB.Classes.Mage.BarGroupsFactory

---Creates BarGroup instances for the specified Mage specialization
---@param specId integer # 1=Arcane, 2=Fire, 3=Frost
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Mage.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    if specId == 1 then -- Arcane
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Arcane Charges (4 nodes)
        -- Secondary bars are parented to UIParent for independent visibility
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            4,
            false -- not primary
        )

        -- Arcane Salvo stacks (single node filled by the secret cast count)
        barGroups.arcaneSalvo = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ArcaneSalvo",
            1,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 2 then -- Fire
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Fire Blast Charges (up to 3 nodes: 1 base + 2 from talents)
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            3,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 3 then -- Frost
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Icicles (5 nodes)
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            5,
            false -- not primary
        )

        -- Shatter stacks on the current target
        barGroups.shatter = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Shatter",
            20,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )
    end

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Mage.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Arcane
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 4,
                isPrimary = false,
                resourceType = "ArcaneCharges"
            },
            arcaneSalvo = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "ArcaneSalvo",
                usesSecretValue = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 2 then -- Fire
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 3,
                isPrimary = false,
                resourceType = "FireBlastCharges",
                -- Fire Blast charges come from the spell's cooldown charge count (secret in combat),
                -- so the count cannot be compared or curve-evaluated in Lua. Custom thresholds on
                -- this bar are restricted to the static color mode (and the icon stays full color).
                usesSecretValue = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 3 then -- Frost
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 5,
                isPrimary = false,
                resourceType = "Icicles"
            },
            shatter = {
                maxNodes = 20,
                isPrimary = false,
                resourceType = "Shatter",
                usesSecretValue = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    end

    return {}
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["mage_arcane"] = TRB.Classes.Mage.ArcaneSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["mage_fire"] = TRB.Classes.Mage.FireSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["mage_frost"] = TRB.Classes.Mage.FrostSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["mage_arcane"] = TRB.Classes.Mage.ArcaneSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["mage_fire"] = TRB.Classes.Mage.FireSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["mage_frost"] = TRB.Classes.Mage.FrostSpells.GetCastbarTickProfiles

-- Register built-in castbar tick modifiers (talent/set/buff-conditional bonus ticks)
TRB.Data.castbarTickModifiersRegistry = TRB.Data.castbarTickModifiersRegistry or {}
TRB.Data.castbarTickModifiersRegistry["mage_arcane"] = TRB.Classes.Mage.ArcaneSpells.GetCastbarTickModifiers

-- Register class sets whose bonuses the addon reacts to. Functions\Item.lua counts the equipped pieces of
-- every registered set once per gear change and caches it.
TRB.Data.itemSetRegistry = TRB.Data.itemSetRegistry or {}
---@type TRB.Classes.ItemSetDefinition
TRB.Data.itemSetRegistry[arcaneMidnightSeason2SetKey] = {
	headId = 271564,
	shoulderId = 271562,
	chestId = 271567,
	handId = 271565,
	legId = 271563,
}

-- Register audio cue vocabularies
do
	local L = TRB.Localization

	TRB.Functions.AudioCues:Register("mage_arcane", {
		counters = {
			{
				id = "arcaneCharges",
				label = L["MageAudioCueSourceArcaneCharges"],
				description = L["MageAudioCueSourceArcaneChargesDescription"],
				sliderLabel = L["MageArcaneChargeThresholdSliderTitle"],
				defaultName = L["MageAudioCueArcaneChargeDefaultName"],
				min = 0,
				max = 4,
				step = 1,
				decimals = 0,
				compare = "atLeast",
				requiresCombat = true,
				legacyIds = { "arcaneChargeThreshold1", "arcaneChargeThreshold2" },
				defaultCues = {
					{
						id = "arcaneChargeThreshold1",
						name = L["MageAudioArcaneChargeThreshold1"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 2,
					},
					{
						id = "arcaneChargeThreshold2",
						name = L["MageAudioArcaneChargeThreshold2"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 4,
					},
				},
			},
		},
	})

	TRB.Functions.AudioCues:Register("mage_frost", {
		builtIns = {
			{
				id = "fingersOfFrostCharge1",
				label = L["MageFrostAudioFingersOfFrostCharge1"],
				trigger = L["MageFrostAudioTriggerFingersOfFrostCharge1"],
				tooltip = L["MageFrostAudioCheckboxFingersOfFrostCharge1Tooltip"],
				config = {
					{
						key = "playOnDrop",
						control = "checkbox",
						label = L["AudioCuePlayOnDropCheckbox"],
						tooltip = L["MageFrostAudioCheckboxFingersOfFrostPlayOnDropTooltip"],
						default = false,
					},
				},
			},
			{
				id = "fingersOfFrostCharge2",
				label = L["MageFrostAudioFingersOfFrostCharge2"],
				trigger = L["MageFrostAudioTriggerFingersOfFrostCharge2"],
				tooltip = L["MageFrostAudioCheckboxFingersOfFrostCharge2Tooltip"],
			},
			{
				id = "brainFreeze",
				label = L["MageFrostAudioBrainFreeze"],
				trigger = L["MageFrostAudioTriggerBrainFreeze"],
				tooltip = L["MageFrostAudioCheckboxBrainFreezeTooltip"],
			},
		},
		counters = {
			{
				id = "icicles",
				label = L["MageAudioCueSourceIcicles"],
				description = L["MageAudioCueSourceIciclesDescription"],
				sliderLabel = L["MageIciclesThresholdSliderTitle"],
				defaultName = L["MageAudioCueIciclesDefaultName"],
				min = 0,
				max = 5,
				step = 1,
				decimals = 0,
				compare = "atLeast",
				requiresCombat = true,
				legacyIds = { "iciclesThreshold1" },
				defaultCues = {
					{
						id = "iciclesThreshold1",
						name = L["MageAudioIciclesThreshold1"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 3,
					},
				},
			},
		},
	})
end
