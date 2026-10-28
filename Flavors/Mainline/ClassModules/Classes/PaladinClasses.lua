local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Mainline.Paladin = TRB.Classes.Mainline.Paladin or {}


---@class TRB.Classes.Mainline.Paladin.HolySpells : TRB.Classes.Mainline.Healer.HealerSpells
---@field flashOfLight TRB.Classes.SpellBase
---@field divinePurpose TRB.Classes.SpellBase
---@field holyLight TRB.Classes.SpellBase
TRB.Classes.Mainline.Paladin.HolySpells = setmetatable({}, {__index = TRB.Classes.Mainline.Healer.HealerSpells})
TRB.Classes.Mainline.Paladin.HolySpells.__index = TRB.Classes.Mainline.Paladin.HolySpells

function TRB.Classes.Mainline.Paladin.HolySpells:New()
    ---@type TRB.Classes.Mainline.Healer.HealerSpells
    local base = TRB.Classes.Mainline.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Mainline.Paladin.HolySpells) --[[@as TRB.Classes.Mainline.Paladin.HolySpells]]

    self.flashOfLight = TRB.Classes.SpellBase:New({
        id = 19750,
        baseline = true,
		resource = 1
    })

    self.divinePurpose = TRB.Classes.SpellBase:New({
        id = 223819,
        spellId = 223819, -- Id the proc's activation overlay is announced under
        isBuff = true,
        duration = 12
    })

	self.holyLight = TRB.Classes.SpellBase:New({
		id = 82326,
		resource = 1
	})

    return self
end

---Fills barTextVariables for Holy Paladin options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mainline.Paladin.HolySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mainline.Paladin.HolySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mainline.Paladin.HolySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#flashOfLight", icon = spells.flashOfLight.icon, description = spells.flashOfLight.name, printInSettings = true },
		{ variable = "#holyLight", icon = spells.holyLight.icon, description = spells.holyLight.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$castingHolyPower", description = L["PaladinHolyBarTextVariable_castingHolyPower"], printInSettings = true, color = false, category = varCategory.RESOURCES },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$holyPowerPlusCasting", description = L["PaladinHolyBarTextVariable_holyPowerPlusCasting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsPlusCasting", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$divinePurposeTime", description = L["PaladinBarTextVariable_divinePurposeTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Holy, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mainline.Paladin.HolySpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Mainline.Paladin.ProtectionSpells : TRB.Classes.SpecializationSpellsBase
---@field flashOfLight TRB.Classes.SpellBase
---@field divinePurpose TRB.Classes.SpellBase
TRB.Classes.Mainline.Paladin.ProtectionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mainline.Paladin.ProtectionSpells.__index = TRB.Classes.Mainline.Paladin.ProtectionSpells

function TRB.Classes.Mainline.Paladin.ProtectionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mainline.Paladin.ProtectionSpells) --[[@as TRB.Classes.Mainline.Paladin.ProtectionSpells]]

	self.flashOfLight = TRB.Classes.SpellBase:New({
		id = 19750,
		baseline = true
	})

	self.divinePurpose = TRB.Classes.SpellBase:New({
		id = 223819,
		spellId = 223819, -- Id the proc's activation overlay is announced under
		isBuff = true,
		duration = 12
	})

    return self
end

---Fills barTextVariables for Protection Paladin options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mainline.Paladin.ProtectionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mainline.Paladin.ProtectionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mainline.Paladin.ProtectionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$divinePurposeTime", description = L["PaladinBarTextVariable_divinePurposeTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Protection, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mainline.Paladin.ProtectionSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Mainline.Paladin.RetributionSpells : TRB.Classes.SpecializationSpellsBase
---@field divinePurpose TRB.Classes.SpellBase
---@field executionSentence TRB.Classes.SpellBase
---@field judgeJuryAndExecutioner TRB.Classes.SpellBase
---@field avengingWrath TRB.Classes.SpellBase
---@field radiantGlory TRB.Classes.SpellBase
---@field divineWrath TRB.Classes.SpellBase
---@field wakeOfAshes TRB.Classes.SpellBase
TRB.Classes.Mainline.Paladin.RetributionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mainline.Paladin.RetributionSpells.__index = TRB.Classes.Mainline.Paladin.RetributionSpells

function TRB.Classes.Mainline.Paladin.RetributionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mainline.Paladin.RetributionSpells) --[[@as TRB.Classes.Mainline.Paladin.RetributionSpells]]

    self.divinePurpose = TRB.Classes.SpellBase:New({
        id = 223819,
        spellId = 408458, -- Id the proc's activation overlay is announced under
        isBuff = true,
        duration = 12
    })

    self.executionSentence = TRB.Classes.SpellBase:New({
        id = 343527,
        isTalent = true,
        duration = 10
    })

    self.judgeJuryAndExecutioner = TRB.Classes.SpellBase:New({
        id = 1253174,
        talentId = 406157,
        isTalent = true,
        duration = 15,
        spenderCost = 3 -- Every Retribution Holy Power spender costs 3
    })

    self.avengingWrath = TRB.Classes.SpellBase:New({
        id = 31884,
        isTalent = true,
        duration = 20
    })

    self.radiantGlory = TRB.Classes.SpellBase:New({
        id = 458359,
        isTalent = true,
        duration = 8 -- The Avenging Wrath Wake of Ashes grants
    })

    self.divineWrath = TRB.Classes.SpellBase:New({
        id = 406872,
        isTalent = true,
        durationPerRank = { 3, 4 } -- Seconds added to either Avenging Wrath, by talent rank
    })

    self.wakeOfAshes = TRB.Classes.SpellBase:New({
        id = 255937,
        isTalent = true
    })

    return self
end

---Fills barTextVariables for Retribution Paladin options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mainline.Paladin.RetributionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mainline.Paladin.RetributionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mainline.Paladin.RetributionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#es", icon = spells.executionSentence.icon, description = spells.executionSentence.name, printInSettings = true },
		{ variable = "#executionSentence", icon = spells.executionSentence.icon, description = spells.executionSentence.name, printInSettings = false },
		{ variable = "#jje", icon = spells.judgeJuryAndExecutioner.icon, description = spells.judgeJuryAndExecutioner.name, printInSettings = true },
		{ variable = "#judgeJuryAndExecutioner", icon = spells.judgeJuryAndExecutioner.icon, description = spells.judgeJuryAndExecutioner.name, printInSettings = false },
		{ variable = "#aw", icon = spells.avengingWrath.icon, description = spells.avengingWrath.name, printInSettings = true },
		{ variable = "#avengingWrath", icon = spells.avengingWrath.icon, description = spells.avengingWrath.name, printInSettings = false },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$divinePurposeTime", description = L["PaladinBarTextVariable_divinePurposeTime"], printInSettings = true, color = false },
		{ variable = "$esTime", description = L["PaladinRetributionBarTextVariable_esTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$jjeTime", description = L["PaladinRetributionBarTextVariable_jjeTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$awTime", description = L["PaladinRetributionBarTextVariable_awTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
	})
end

---Gets built-in castbar channel tick profiles for Retribution, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mainline.Paladin.RetributionSpells.GetCastbarTickProfiles()
	return {}
end


--[[
    BarGroups Factory for Paladin
    Creates the appropriate BarGroup instances for each Paladin specialization.
    
    Holy: Primary bar (N=1) + Holy Power (N=5)
    Protection: Primary bar (N=1) + Holy Power (N=5)
    Retribution: Primary bar (N=1) + Holy Power (N=5)
]]

---@class TRB.Classes.Mainline.Paladin.BarGroupsFactory
TRB.Classes.Mainline.Paladin.BarGroupsFactory = {}
TRB.Classes.Mainline.Paladin.BarGroupsFactory.__index = TRB.Classes.Mainline.Paladin.BarGroupsFactory

---Creates BarGroup instances for the specified Paladin specialization
---@param specId integer # 1=Holy, 2=Protection, 3=Retribution
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Mainline.Paladin.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary mana bar (1 node) - all specs use mana
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Holy Power (5 nodes) - all Paladin specs use Holy Power
    -- Secondary bars are parented to UIParent for independent visibility
    barGroups.secondary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_ComboPoint",
        5,
        false -- not primary
    )

    -- Health bar (1 node)
    barGroups.health = TRB.Classes.BarGroup:New(
        parentFrame or UIParent,
        "TwintopResourceBarFrame_Health",
        1,
        false -- not primary
    )

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Mainline.Paladin.BarGroupsFactory:GetSpecConfiguration(specId)
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true,
            resourceType = "Mana"
        },
        secondary = {
            maxNodes = 5,
            isPrimary = false,
            resourceType = "HolyPower"
        },
        health = {
            maxNodes = 1,
            isPrimary = false,
            resourceType = "Health"
        }
    }
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["paladin_holy"] = TRB.Classes.Mainline.Paladin.HolySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["paladin_protection"] = TRB.Classes.Mainline.Paladin.ProtectionSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["paladin_retribution"] = TRB.Classes.Mainline.Paladin.RetributionSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["paladin_holy"] = TRB.Classes.Mainline.Paladin.HolySpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["paladin_protection"] = TRB.Classes.Mainline.Paladin.ProtectionSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["paladin_retribution"] = TRB.Classes.Mainline.Paladin.RetributionSpells.GetCastbarTickProfiles

-- Register audio cue vocabularies
do
	local L = TRB.Localization

	local function HolyPowerSource()
		return {
			id = "holyPower",
			label = L["PaladinAudioCueSourceHolyPower"],
			description = L["PaladinAudioCueSourceHolyPowerDescription"],
			sliderLabel = L["PaladinHolyPowerThresholdSliderTitle"],
			defaultName = L["PaladinAudioCueHolyPowerDefaultName"],
			min = 0,
			max = 5,
			step = 1,
			decimals = 0,
			compare = "atLeast",
			requiresCombat = true,
			legacyIds = { "holyPowerThreshold1", "holyPowerThreshold2", "holyPowerThreshold3" },
			defaultCues = {
				{
					id = "holyPowerThreshold1",
					name = L["PaladinAudioHolyPowerThreshold1"],
					enabled = false,
					sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"],
					thresholdValue = 3,
				},
				{
					id = "holyPowerThreshold2",
					name = L["PaladinAudioHolyPowerThreshold2"],
					enabled = false,
					sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"],
					thresholdValue = 4,
				},
				{
					id = "holyPowerThreshold3",
					name = L["PaladinAudioHolyPowerThreshold3"],
					enabled = false,
					sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName = L["LSMSoundBoxingArenaGong"],
					thresholdValue = 5,
				},
			},
		}
	end

	local divinePurpose = {
		id = "divinePurpose",
		label = L["PaladinAudioDivinePurpose"],
		trigger = L["PaladinAudioTriggerDivinePurpose"],
		tooltip = L["PaladinAudioCheckboxDivinePurposeTooltip"],
	}

	TRB.Functions.AudioCues:Register("paladin_holy", {
		builtIns = {
			{
				id = "infusionOfLight",
				label = L["PaladinHolyInfusionOfLight"],
				trigger = L["PaladinHolyAudioTriggerInfusionOfLight"],
				tooltip = L["PaladinHolyAudioCheckboxInfusionOfLightTooltip"],
			},
			divinePurpose,
		},
		counters = { HolyPowerSource() },
	})

	TRB.Functions.AudioCues:Register("paladin_protection", {
		builtIns = { divinePurpose },
		counters = { HolyPowerSource() },
	})

	-- Shared by the Avenging Wrath Source dropdowns on the Indicators and Audio tabs.
	TRB.Classes.Mainline.Paladin.AvengingWrathSourceOptions = {
		{ value = "cast", label = L["PaladinRetributionAvengingWrathSourceCast"] },
		{ value = "radiantGlory", label = L["PaladinRetributionAvengingWrathSourceRadiantGlory"] },
		{ value = "both", label = L["PaladinRetributionAvengingWrathSourceBoth"] },
	}

	TRB.Functions.AudioCues:Register("paladin_retribution", {
		builtIns = {
			divinePurpose,
			{
				id = "avengingWrath",
				label = L["PaladinRetributionAudioAvengingWrath"],
				trigger = L["PaladinRetributionAudioTriggerAvengingWrath"],
				tooltip = L["PaladinRetributionAudioCheckboxAvengingWrathTooltip"],
				config = {
					{
						key = "source",
						control = "dropdown",
						label = L["PaladinRetributionAvengingWrathSource"],
						options = TRB.Classes.Mainline.Paladin.AvengingWrathSourceOptions,
						default = "both",
					},
				},
			},
		},
		counters = { HolyPowerSource() },
	})
end

-- Spec descriptors: the traits Core needs to know about these specs (see Core\Classes\SpecDescriptor.lua).
-- Everything class-specific that shared code used to hard-code by class/spec id is declared here instead.
do
	local L = TRB.Localization
	local SpecDescriptor = TRB.Classes.SpecDescriptor
	SpecDescriptor:Declare("paladin_holy", {
		manaBar = true,
		secondary = { exportable = true },
		barTextAnchorFrames = {
			secondary = {
				{ label = L["HolyPower1"], frame = "ComboPoint_1" }, { label = L["HolyPower2"], frame = "ComboPoint_2" }, { label = L["HolyPower3"], frame = "ComboPoint_3" }, { label = L["HolyPower4"], frame = "ComboPoint_4" },
				{ label = L["HolyPower5"], frame = "ComboPoint_5" },
			},
		},
	})
	SpecDescriptor:Declare("paladin_protection", {
		manaBar = true,
		secondary = { exportable = true },
		barTextAnchorFrames = {
			secondary = {
				{ label = L["HolyPower1"], frame = "ComboPoint_1" }, { label = L["HolyPower2"], frame = "ComboPoint_2" }, { label = L["HolyPower3"], frame = "ComboPoint_3" }, { label = L["HolyPower4"], frame = "ComboPoint_4" },
				{ label = L["HolyPower5"], frame = "ComboPoint_5" },
			},
		},
	})
	SpecDescriptor:Declare("paladin_retribution", {
		manaBar = true,
		secondary = { exportable = true },
		barTextAnchorFrames = {
			secondary = {
				{ label = L["HolyPower1"], frame = "ComboPoint_1" }, { label = L["HolyPower2"], frame = "ComboPoint_2" }, { label = L["HolyPower3"], frame = "ComboPoint_3" }, { label = L["HolyPower4"], frame = "ComboPoint_4" },
				{ label = L["HolyPower5"], frame = "ComboPoint_5" },
			},
		},
	})
end
