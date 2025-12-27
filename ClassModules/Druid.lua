local _, TRB = ...
if TRB.Data.character.classId ~= 11 then --Only do this if we're on a Druid!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	balance = TRB.Classes.SpecCache:New(),
	feral = TRB.Classes.SpecCache:New(),
	guardian = TRB.Classes.SpecCache:New(),
	restoration = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function CalculateManaGain(mana, isPotion)
	if isPotion == nil then
		isPotion = false
	end

	local modifier = 1.0

	return mana * modifier
end

local function FillSpecializationCache()
	-- Balance
	specCache.balance.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		},
		furyOfElune = {
			astralPower = 0,
			ticks = 0,
			remaining = 0
		}
	}
	
	specCache.balance.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		pandemicModifier = 1.0,
		effects = {
		},
		items = {
			twwSeason1SetBonusCount = 0
		}
	}
	
	---@type TRB.Classes.Druid.BalanceSpells
	specCache.balance.spellsData.spells = TRB.Classes.Druid.BalanceSpells:New()
	local spells = specCache.balance.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	
	specCache.balance.snapshotData.audio = {
		playedSsCue = false,
		playedSfCue = false,
		playedstarweaverCue = false
	}
	--[[---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.moonkinForm.id] = TRB.Classes.Snapshot:New(spells.moonkinForm, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.furyOfElune.id] = TRB.Classes.Snapshot:New(spells.furyOfElune, {
		guid = nil
	})
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.sunderedFirmament.id] = TRB.Classes.Snapshot:New(spells.sunderedFirmament, {
		guid = nil
	})
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.theLightOfElune.id] = TRB.Classes.Snapshot:New(spells.theLightOfElune, {
		guid = nil
	})]]
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.eclipseSolar.id] = TRB.Classes.Snapshot:New(spells.eclipseSolar)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.eclipseLunar.id] = TRB.Classes.Snapshot:New(spells.eclipseLunar)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.celestialAlignment.id] = TRB.Classes.Snapshot:New(spells.celestialAlignment)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.incarnationChosenOfElune.id] = TRB.Classes.Snapshot:New(spells.incarnationChosenOfElune)
	--[[---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.starfall.id] = TRB.Classes.Snapshot:New(spells.starfall)]]
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.newMoon.id] = TRB.Classes.Snapshot:New(spells.newMoon, {
		currentSpellId = nil,
		currentIcon = "",
		currentKey = "",
		checkAfter = nil
	})
	--[[---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.starweaversWarp.id] = TRB.Classes.Snapshot:New(spells.starweaversWarp)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.starweaversWeft.id] = TRB.Classes.Snapshot:New(spells.starweaversWeft)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.touchTheCosmos.id] = TRB.Classes.Snapshot:New(spells.touchTheCosmos)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.forceOfNature.id] = TRB.Classes.Snapshot:New(spells.forceOfNature)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.astralCommunion.id] = TRB.Classes.Snapshot:New(spells.astralCommunion)
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.starlord.id] = TRB.Classes.Snapshot:New(spells.starlord)
	
	--Keeper of the Grove
	---@type TRB.Classes.Snapshot
	specCache.balance.snapshotData.snapshots[spells.dreamburst.id] = TRB.Classes.Snapshot:New(spells.dreamburst)]]

	-- Feral
	specCache.feral.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.feral.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		maxResource2 = 5,
		pandemicModifier = 1.0,
		effects = {
		}
	}
	
	---@type TRB.Classes.Druid.FeralSpells
	specCache.feral.spellsData.spells = TRB.Classes.Druid.FeralSpells:New()
	local spells = specCache.feral.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]

	specCache.feral.snapshotData.attributes.resourceRegen = 0
	specCache.feral.snapshotData.attributes.comboPoints = 0
	specCache.feral.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.maim.id] = TRB.Classes.Snapshot:New(spells.maim)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.brutalSlash.id] = TRB.Classes.Snapshot:New(spells.brutalSlash)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.feralFrenzy.id] = TRB.Classes.Snapshot:New(spells.feralFrenzy)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.franticFrenzy.id] = TRB.Classes.Snapshot:New(spells.franticFrenzy)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.clearcasting.id] = TRB.Classes.Snapshot:New(spells.clearcasting)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.tigersFury.id] = TRB.Classes.Snapshot:New(spells.tigersFury)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.shadowmeld.id] = TRB.Classes.Snapshot:New(spells.shadowmeld, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.prowl.id] = TRB.Classes.Snapshot:New(spells.prowl, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.suddenAmbush.id] = TRB.Classes.Snapshot:New(spells.suddenAmbush)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.berserk.id] = TRB.Classes.Snapshot:New(spells.berserk, {
		lastTick = nil,
		nextTick = nil,
		untilNextTick = 0,
		ticks = 0,
	})
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id] = TRB.Classes.Snapshot:New(spells.incarnationAvatarOfAshamane)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.bloodtalons.id] = TRB.Classes.Snapshot:New(spells.bloodtalons)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.apexPredatorsCraving.id] = TRB.Classes.Snapshot:New(spells.apexPredatorsCraving)
	-- Druid of the Claw
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.ravageMinimum.id] = TRB.Classes.Snapshot:New(spells.ravageMinimum)
	---@type TRB.Classes.Snapshot
	specCache.feral.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)

	-- Guardian
	specCache.guardian.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0
		}
	}
	
	specCache.guardian.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		pandemicModifier = 1.0,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Druid.GuardianSpells
	specCache.guardian.spellsData.spells = TRB.Classes.Druid.GuardianSpells:New()
	local spells = specCache.guardian.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	---@type TRB.Classes.Snapshot
	specCache.guardian.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)
	---@type TRB.Classes.Snapshot
	specCache.guardian.snapshotData.snapshots[spells.berserk.id] = TRB.Classes.Snapshot:New(spells.berserk)
	---@type TRB.Classes.Snapshot
	specCache.guardian.snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id] = TRB.Classes.Snapshot:New(spells.incarnationGuardianOfUrsoc)

	specCache.guardian.snapshotData.audio = {
	}

	-- Restoration
	specCache.restoration.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.restoration.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 4,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Druid.RestorationSpells
	specCache.restoration.spellsData.spells = TRB.Classes.Druid.RestorationSpells:New()
	local spells = specCache.restoration.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]

	specCache.restoration.snapshotData.attributes.manaRegen = 0
	specCache.restoration.snapshotData.audio = {
		innervateCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.efflorescence.id] = TRB.Classes.Snapshot:New(spells.efflorescence)
	--[[---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.reforestation.id] = TRB.Classes.Snapshot:New(spells.reforestation, nil, "always")]]
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.incarnationTreeOfLife.id] = TRB.Classes.Snapshot:New(spells.incarnationTreeOfLife)

	specCache.restoration.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Balance()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "balance")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Balance using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(1)
end

local function FillSpellData_Balance()
	Setup_Balance()
	specCache.balance.spellsData:FillSpellData()
	local spells = specCache.balance.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.balance.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#moonkinForm", icon = spells.moonkinForm.icon, description = spells.moonkinForm.name, printInSettings = true },

		{ variable = "#wrath", icon = spells.wrath.icon, description = spells.wrath.name, printInSettings = true },
		{ variable = "#starfire", icon = spells.starfire.icon, description = spells.starfire.name, printInSettings = true },
		
		{ variable = "#starsurge", icon = spells.starsurge.icon, description = spells.starsurge.name, printInSettings = true },
		{ variable = "#starfall", icon = spells.fullMoon.icon, description = spells.fullMoon.name, printInSettings = true },
		{ variable = "#starweaver", icon = string.format(L["DruidBalanceIcon_starweaver"], spells.starweaversWarp.icon, spells.starweaversWeft.icon), description = L["DruidBalanceIconDescription_starweaver"], printInSettings = true },
		{ variable = "#starweaversWarp", icon = spells.starweaversWarp.icon, description = spells.starweaversWarp.name, printInSettings = true },
		{ variable = "#starweaversWeft", icon = spells.starweaversWeft.icon, description = spells.starweaversWeft.name, printInSettings = true },
		{ variable = "#starlord", icon = spells.starlord.icon, description = spells.starlord.name, printInSettings = true},

		{ variable = "#eclipse", icon = string.format(L["DruidBalanceIcon_eclipse"], spells.incarnationChosenOfElune.icon, spells.celestialAlignment.icon, spells.eclipseSolar.icon, spells.eclipseLunar.icon), description = L["DruidBalanceIconDescription_eclipse"], printInSettings = true },
		{ variable = "#celestialAlignment", icon = spells.celestialAlignment.icon, description = spells.celestialAlignment.name, printInSettings = true },			
		{ variable = "#icoe", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = true },			
		{ variable = "#coe", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
		{ variable = "#incarnation", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
		{ variable = "#incarnationChosenOfElune", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
		{ variable = "#solar", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = true },
		{ variable = "#eclipseSolar", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = false },
		{ variable = "#solarEclipse", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = false },
		{ variable = "#lunar", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = true },
		{ variable = "#eclipseLunar", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = false },
		{ variable = "#lunarEclipse", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = false },
		
		{ variable = "#naturesBalance", icon = spells.naturesBalance.icon, description = spells.naturesBalance.name, printInSettings = true },
		
		{ variable = "#soulOfTheForest", icon = spells.soulOfTheForest.icon, description = spells.soulOfTheForest.name, printInSettings = true },
		
		{ variable = "#stellarFlare", icon = spells.stellarFlare.icon, description = spells.stellarFlare.name, printInSettings = true },

		{ variable = "#foe", icon = spells.furyOfElune.icon, description = spells.furyOfElune.name, printInSettings = false },
		{ variable = "#furyOfElune", icon = spells.furyOfElune.icon, description = spells.furyOfElune.name, printInSettings = true },
		
		{ variable = "#sunderedFirmament", icon = spells.sunderedFirmament.icon, description = spells.sunderedFirmament.name, printInSettings = true },
		
		{ variable = "#bb", icon = spells.bounteousBloom.icon, description = spells.bounteousBloom.name, printInSettings = true },
		{ variable = "#bounteousBloom", icon = spells.bounteousBloom.icon, description = spells.bounteousBloom.name, printInSettings = false },

		{ variable = "#dreamburst", icon = spells.dreamburst.icon, description = spells.dreamburst.name, printInSettings = true},

		{ variable = "#newMoon", icon = spells.newMoon.icon, description = spells.newMoon.name, printInSettings = true },
		{ variable = "#halfMoon", icon = spells.halfMoon.icon, description = spells.halfMoon.name, printInSettings = true },
		{ variable = "#fullMoon", icon = spells.fullMoon.icon, description = spells.fullMoon.name, printInSettings = true },
		{ variable = "#moon", icon = string.format(L["DruidBalanceIcon_moon"], spells.newMoon.icon, spells.halfMoon.icon, spells.fullMoon.icon), description = L["DruidBalanceIconDescription_moon"], printInSettings = true },
	}
	specCache.balance.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$astralPower", description = L["DruidBalanceBarTextVariable_astralPower"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$astralPowerMax", description = L["DruidBalanceBarTextVariable_astralPowerMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DruidBalanceBarTextVariable_casting"], printInSettings = true, color = false },

		--{ variable = "$moonkinForm", description = L["DruidBalanceBarTextVariable_moonkinForm"], printInSettings = true, color = false },
		{ variable = "$eclipse", description = L["DruidBalanceBarTextVariable_eclipse"], printInSettings = true, color = false },
		{ variable = "$eclipseTime", description = L["DruidBalanceBarTextVariable_eclipseTime"], printInSettings = true, color = false },
		{ variable = "$lunar", description = L["DruidBalanceBarTextVariable_lunar"], printInSettings = true, color = false },
		{ variable = "$lunarEclipse", description = "", printInSettings = false, color = false },
		{ variable = "$eclipseLunar", description = "", printInSettings = false, color = false },
		{ variable = "$solar", description = L["DruidBalanceBarTextVariable_solar"], printInSettings = true, color = false },
		{ variable = "$solarEclipse", description = "", printInSettings = false, color = false },
		{ variable = "$eclipseSolar", description = "", printInSettings = false, color = false },
		{ variable = "$celestialAlignment", description = L["DruidBalanceBarTextVariable_celestialAlignment"], printInSettings = true, color = false },

		--[[{ variable = "$pulsarCollected", description = L["DruidBalanceBarTextVariable_pulsarCollected"], printInSettings = true, color = false },
		{ variable = "$pulsarCollectedPercent", description = L["DruidBalanceBarTextVariable_pulsarCollectedPercent"], printInSettings = true, color = false },
		{ variable = "$pulsarRemaining", description = L["DruidBalanceBarTextVariable_pulsarRemaining"], printInSettings = true, color = false },
		{ variable = "$pulsarRemainingPercent", description = L["DruidBalanceBarTextVariable_pulsarRemainingPercent"], printInSettings = true, color = false },
		{ variable = "$pulsarNextStarsurge", description = L["DruidBalanceBarTextVariable_pulsarNextStarsurge"], printInSettings = true, color = false },
		{ variable = "$pulsarNextStarfall", description = L["DruidBalanceBarTextVariable_pulsarNextStarfall"], printInSettings = true, color = false },
		{ variable = "$pulsarStarsurgeCount", description = L["DruidBalanceBarTextVariable_pulsarStarsurgeCount"], printInSettings = true, color = false },
		{ variable = "$pulsarStarfallCount", description = L["DruidBalanceBarTextVariable_pulsarStarfallCount"], printInSettings = true, color = false },
		
		{ variable = "$foeTicks", description = L["DruidBalanceBarTextVariable_foeTicks"], printInSettings = true, color = false },
		{ variable = "$foeTime", description = L["DruidBalanceBarTextVariable_foeTime"], printInSettings = true, color = false },
		{ variable = "$bbTicks", description = L["DruidBalanceBarTextVariable_bbTicks"], printInSettings = true, color = false },
		{ variable = "$bbTime", description = L["DruidBalanceBarTextVariable_bbTime"], printInSettings = true, color = false },
		{ variable = "$starlordTime", description = L["DruidBalanceBarTextVariable_starlordTime"], printInSettings = true, color = false },
		{ variable = "$starlordStacks", description = L["DruidBalanceBarTextVariable_starlordStacks"], printInSettings = true, color = false },

		{ variable = "$dreamburstTime", description = L["DruidBalanceBarTextVariable_dreamburstTime"], printInSettings = true, color = false },
		{ variable = "$dreamburstStacks", description = L["DruidBalanceBarTextVariable_dreamburstStacks"], printInSettings = true, color = false },

		{ variable = "$moonAstralPower", description = L["DruidBalanceBarTextVariable_moonAstralPower"], printInSettings = true, color = false },   
		{ variable = "$moonCharges", description = L["DruidBalanceBarTextVariable_moonCharges"], printInSettings = true, color = false },   
		{ variable = "$moonCooldown", description = L["DruidBalanceBarTextVariable_moonCooldown"], printInSettings = true, color = false },
		{ variable = "$moonCooldownTotal", description = L["DruidBalanceBarTextVariable_moonCooldownTotal"], printInSettings = true, color = false },

		{ variable = "$starweaverTime", description = L["DruidBalanceBarTextVariable_starweaverTime"], printInSettings = true, color = false },
		{ variable = "$starweaver", description = L["DruidBalanceBarTextVariable_starweaver"], printInSettings = true, color = false },
		{ variable = "$starweaversWarp", description = L["DruidBalanceBarTextVariable_starweaversWarp"], printInSettings = true, color = false },
		{ variable = "$starweaversWeft", description = L["DruidBalanceBarTextVariable_starweaversWeft"], printInSettings = true, color = false },]]
	}
end

local function Setup_Feral()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "feral")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Feral using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(2)
end

local function FillSpellData_Feral()
	Setup_Feral()
	specCache.feral.spellsData:FillSpellData()
	local spells = specCache.feral.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.feral.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#apexPredatorsCraving", icon = spells.apexPredatorsCraving.icon, description = spells.apexPredatorsCraving.name, printInSettings = true },
		{ variable = "#berserk", icon = spells.berserk.icon, description = spells.berserk.name, printInSettings = true },
		{ variable = "#bloodtalons", icon = spells.bloodtalons.icon, description = spells.bloodtalons.name, printInSettings = true },
		{ variable = "#brutalSlash", icon = spells.brutalSlash.icon, description = spells.brutalSlash.name, printInSettings = true },
		{ variable = "#carnivorousInstinct", icon = spells.carnivorousInstinct.icon, description = spells.carnivorousInstinct.name, printInSettings = true },
		{ variable = "#catForm", icon = spells.catForm.icon, description = spells.catForm.name, printInSettings = true },
		{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
		{ variable = "#feralFrenzy", icon = spells.feralFrenzy.icon, description = spells.feralFrenzy.name, printInSettings = true },
		{ variable = "#ferociousBite", icon = spells.ferociousBiteMinimum.icon, description = spells.ferociousBiteMinimum.name, printInSettings = true },
		{ variable = "#incarnation", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = true },
		{ variable = "#incarnationAvatarOfAshamane", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = false },
		{ variable = "#lunarInspiration", icon = spells.lunarInspiration.icon, description = spells.lunarInspiration.name, printInSettings = true },
		{ variable = "#maim", icon = spells.maim.icon, description = spells.maim.name, printInSettings = true },
		{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
		{ variable = "#primalWrath", icon = spells.primalWrath.icon, description = spells.primalWrath.name, printInSettings = true },
		{ variable = "#prowl", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = true },
		{ variable = "#stealth", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = false },
		{ variable = "#rake", icon = spells.rake.icon, description = spells.rake.name, printInSettings = true },
		{ variable = "#ravage", icon = spells.ravageMinimum.icon, description = spells.ravageMinimum.name, printInSettings = true },
		{ variable = "#rip", icon = spells.rip.icon, description = spells.rip.name, printInSettings = true },
		{ variable = "#shadowmeld", icon = spells.shadowmeld.icon, description = spells.shadowmeld.name, printInSettings = true },
		{ variable = "#shred", icon = spells.shred.icon, description = spells.shred.name, printInSettings = true },
		{ variable = "#suddenAmbush", icon = spells.suddenAmbush.icon, description = spells.suddenAmbush.name, printInSettings = true },
		{ variable = "#swipe", icon = spells.swipe.icon, description = spells.swipe.name, printInSettings = true },
		{ variable = "#tigersFury", icon = spells.tigersFury.icon, description = spells.tigersFury.name, printInSettings = true },
	}
	specCache.feral.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },

		{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DruidFeralBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

		--[[{ variable = "$lunarInspiration", description = L["DruidFeralBarTextVariable_lunarInspiration"], printInSettings = true, color = false },

		{ variable = "$brutalSlashCharges", description = L["DruidFeralBarTextVariable_brutalSlashCharges"], printInSettings = true, color = false },
		{ variable = "$brutalSlashCooldown", description = L["DruidFeralBarTextVariable_brutalSlashCooldown"], printInSettings = true, color = false },
		{ variable = "$brutalSlashCooldownTotal", description = L["DruidFeralBarTextVariable_brutalSlashCooldownTotal"], printInSettings = true, color = false },  
		
		{ variable = "$bloodtalonsStacks", description = L["DruidFeralBarTextVariable_bloodtalonsStacks"], printInSettings = true, color = false },
		{ variable = "$bloodtalonsTime", description = L["DruidFeralBarTextVariable_bloodtalonsTime"], printInSettings = true, color = false },
		
		{ variable = "$clearcastingStacks", description = L["DruidFeralBarTextVariable_clearcastingStacks"], printInSettings = true, color = false },
		{ variable = "$clearcastingTime", description = L["DruidFeralBarTextVariable_clearcastingTime"], printInSettings = true, color = false },]]
		
		{ variable = "$berserkTime", description = L["DruidFeralBarTextVariable_berserkTime"], printInSettings = true, color = false },
		{ variable = "$incarnationTime", description = "", printInSettings = false, color = false },
		{ variable = "$incarnationTicks", description = L["DruidFeralBarTextVariable_incarnationTicks"], printInSettings = true, color = false },
		{ variable = "$incarnationTickTime", description = L["DruidFeralBarTextVariable_incarnationTickTime"], printInSettings = true, color = false },
		{ variable = "$incarnationNextCp", description = L["DruidFeralBarTextVariable_incarnationNextCp"], printInSettings = true, color = false },

		--[[{ variable = "$suddenAmbushTime", description = L["DruidFeralBarTextVariable_suddenAmbushTime"], printInSettings = true, color = false },
		
		{ variable = "$apexPredatorsCravingTime", description = L["DruidFeralBarTextVariable_apexPredatorsCravingTime"], printInSettings = true, color = false },
		
		{ variable = "$tigersFuryTime", description = L["DruidFeralBarTextVariable_tigersFuryTime"], printInSettings = true, color = false },
		{ variable = "$tigersFuryCooldownTime", description = L["DruidFeralBarTextVariable_tigersFuryCooldownTime"], printInSettings = true, color = false },]]
	}
end

local function Setup_Guardian()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "guardian")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Guardian using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(3)
end

local function FillSpellData_Guardian()
	Setup_Guardian()
	specCache.guardian.spellsData:FillSpellData()
	local spells = specCache.guardian.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.guardian.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true }
	}

	specCache.guardian.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$rage", description = L["DruidGuardianBatTextVariable_rage"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$rageMax", description = L["DruidGuardianBatTextVariable_rageMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$berserkTime", description = L["DruidGuardianBarTextVariable_berserkTime"], printInSettings = true, color = false },
		{ variable = "$incarnationTime", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Restoration()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "restoration", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Restoration using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(4)
end

local function FillSpellData_Restoration()
	Setup_Restoration()
	specCache.restoration.spellsData:FillSpellData()
	local spells = specCache.restoration.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.restoration.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#efflorescence", icon = spells.efflorescence.icon, description = spells.efflorescence.name, printInSettings = true },
		{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
		{ variable = "#incarnation", icon = spells.incarnationTreeOfLife.icon, description = spells.incarnationTreeOfLife.name, printInSettings = true },
		{ variable = "#reforestation", icon = spells.reforestation.icon, description = spells.reforestation.name, printInSettings = true },
	}
	specCache.restoration.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DruidRestorationBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$incarnationTime", description = L["DruidRestorationBarTextVariable_incarnationTime"], printInSettings = false, color = false },

		{ variable = "$efflorescenceTime", description = L["DruidRestorationBarTextVariable_efflorescenceTime"], printInSettings = true, color = false },

		--[[{ variable = "$reforestationStacks", description = L["DruidRestorationBarTextVariable_reforestationStacks"], printInSettings = false, color = false },]]
	}
end

local function GetCurrentMoonSpell()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local moon = snapshotData.snapshots[spells.newMoon.id]
	local currentTime = GetTime()
	if talents:IsTalentActive(spells.newMoon) and (moon.attributes.checkAfter == nil or currentTime >= moon.attributes.checkAfter) then
		---@diagnostic disable-next-line: redundant-parameter
		local spellInfo = C_Spell.GetSpellInfo(spells.newMoon.name) --[[@as SpellInfo]]
		moon.attributes.currentSpellId = spellInfo.spellID

		if moon.attributes.currentSpellId == spells.newMoon.id then
			moon.attributes.currentKey = "newMoon"
		elseif moon.attributes.currentSpellId == spells.halfMoon.id then
			moon.attributes.currentKey = "halfMoon"
		elseif moon.attributes.currentSpellId == spells.fullMoon.id then
			moon.attributes.currentKey = "fullMoon"
		else
			moon.attributes.currentKey = "newMoon"
		end
		moon.attributes.checkAfter = nil
		moon.attributes.currentIcon = spells[moon.attributes.currentKey].icon
	else
		moon.attributes.currentSpellId = spells.newMoon.id
		moon.attributes.currentKey = "newMoon"
		moon.attributes.checkAfter = nil
	end
	--moon.cooldown:GetRemainingTime(currentTime)
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	targetData:UpdateTrackedSpells(currentTime)
end

local function TargetsCleanup(clearAll)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 then
		targetData:Cleanup(clearAll)
	elseif TRB.Data.character.specId == 2 then
		targetData:Cleanup(clearAll)
	elseif TRB.Data.character.specId == 3 then
		targetData:Cleanup(clearAll)
	elseif TRB.Data.character.specId == 4 then
		targetData:Cleanup(clearAll)
	end
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups

	-- Feral uses secondary bar (Combo Points). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0 for Feral, use the factory's maxNodes as a fallback.
	if barGroups and barGroups.secondary and TRB.Data.character.specId == 2 then
		local maxComboPoints = TRB.Data.character.maxResource2
		if maxComboPoints == nil or maxComboPoints == 0 then
			maxComboPoints = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxComboPoints
	end

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for _ = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Feral uses secondary bar (Combo Points); Balance/Guardian/Restoration do not.
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 2 then
			local maxComboPoints = TRB.Data.character.maxResource2 or 5
			
			-- Ensure we have enough nodes for the max combo points
			barGroups.secondary:SetMaxNodes(maxComboPoints)
			
			-- Ensure secondary group knows the correct node count
			barGroups.secondary:SetNodeCount(maxComboPoints)
			barGroups.secondary:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")
			barGroups.secondary:Show()
			
			-- Apply layout to position all nodes correctly
			barGroups.secondary:ApplyLayout(
				settings.bar.width,
				settings.comboPoints.width,
				settings.comboPoints.height,
				settings.comboPoints.border
			)
			
			-- Explicitly set textures and colors for each Combo Point node
			local frameLevels = TRB.Data.constants.frameLevels
			for i = 1, maxComboPoints do
				local node = barGroups.secondary:GetNode(i)
				if node then
					node:SetTextures(
						settings.textures.comboPointsBar,
						settings.textures.comboPointsBorder,
						settings.textures.comboPointsBackground
					)
					node:SetMinMax(0, 1)
					node:SetBorderColor(settings.colors.comboPoints.border)
					node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
					node:SetColor(settings.colors.comboPoints.base)
					node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
				end
			end
		else
			barGroups.secondary:Hide()
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function GetBerserkRemainingTime()
	local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Druid.FeralSpells]
	local snapshotData = TRB.Data.snapshotData --[@as TRB.Classes.SnapshotData]
	if talents:IsTalentActive(spells.incarnationAvatarOfAshamane) then
		return snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].cooldown.remaining
	else
		return snapshotData.snapshots[spells.berserk.id].cooldown.remaining
	end
end

local function GetEclipseRemainingTime()
	local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Druid.BalanceSpells]
	local snapshotData = TRB.Data.snapshotData --[@as TRB.Classes.SnapshotData]
	local remainingTime = 0
	local icon = nil

	if snapshotData.snapshots[spells.celestialAlignment.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.celestialAlignment.id].buff.remaining
		icon = spells.celestialAlignment.icon
	elseif snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.remaining
		icon = spells.incarnationChosenOfElune.icon
	elseif snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.eclipseSolar.id].buff.remaining
		icon = spells.eclipseSolar.icon
	elseif snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.eclipseLunar.id].buff.remaining
		icon = spells.eclipseLunar.icon
	end

	return remainingTime, icon
end

local function RefreshLookupData_Balance()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.balance
	local sharedSettings = TRB.Data.specCache["balance"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedAstralPower = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentAstralPowerColor = sharedSettings.colors.text.current.color
	local castingAstralPowerColor = sharedSettings.colors.text.casting.color

	local astralPowerThreshold = math.min(spells.starsurge:GetPrimaryResourceCost(), spells.starfall:GetPrimaryResourceCost())

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled and normalizedAstralPower >= astralPowerThreshold then
			currentAstralPowerColor = sharedSettings.colors.text.overThreshold.color
			castingAstralPowerColor = sharedSettings.colors.text.overThreshold.color
		end
	end

	--$astralPower
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentAstralPower = normalizedAstralPower
	local currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, _currentAstralPower)-- TRB.Functions.Number:RoundTo(normalizedAstralPower, resourcePrecision, "floor"))
	--$casting
	local castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	
	--[[
	--$statweaverTime
	local _starweaverTime = 0
	local _starweaver = false
	local _starweaversWarp = false
	local _starweaversWeft = false

	if snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive then
		_starweaverTime = snapshotData.snapshots[spells.starweaversWarp.id].buff:GetRemainingTime(currentTime)
		_starweaver = true
		_starweaversWarp = true
	elseif snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive then
		_starweaverTime = snapshotData.snapshots[spells.starweaversWeft.id].buff:GetRemainingTime(currentTime)
		_starweaver = true
		_starweaversWeft = true
	end
	local starweaverTime = TRB.Functions.BarText:TimerPrecision(_starweaverTime)

	----------
	--$foeAstralPower
	local foeAstralPower = snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.theLightOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource + snapshotData.snapshots[spells.forceOfNature.id].buff.resource
	--$foeTicks
	local foeTicks = snapshotData.snapshots[spells.furyOfElune.id].buff.ticks + snapshotData.snapshots[spells.theLightOfElune.id].buff.ticks + snapshotData.snapshots[spells.sunderedFirmament.id].buff.ticks
	--$foeTime
	local _foeTime = math.max(snapshotData.snapshots[spells.furyOfElune.id].buff:GetRemainingTime(currentTime), math.max(snapshotData.snapshots[spells.theLightOfElune.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.sunderedFirmament.id].buff:GetRemainingTime(currentTime)))
	local foeTime = TRB.Functions.BarText:TimerPrecision(_foeTime)
	
	----------	
	--$bbAstralPower
	local bbAstralPower = snapshotData.snapshots[spells.forceOfNature.id].buff.resource
	--$bbTicks
	local bbTicks = snapshotData.snapshots[spells.forceOfNature.id].buff.ticks
	--$bbTime
	local _bbTime = snapshotData.snapshots[spells.forceOfNature.id].buff:GetRemainingTime(currentTime)
	local bbTime = TRB.Functions.BarText:TimerPrecision(_bbTime)]]

	--New Moon
	local currentMoonIcon = spells.newMoon.icon
	--$moonAstralPower
	--[[local moonAstralPower = 0
	--$moonCharges
	local moonCharges = snapshotData.snapshots[spells.newMoon.id].cooldown.charges
	--$moonCooldown
	local _moonCooldown = 0
	--$moonCooldownTotal
	local _moonCooldownTotal = 0
	if snapshotData.snapshots[spells.newMoon.id].attributes.currentKey ~= "" and snapshotData.snapshots[spells.newMoon.id].attributes.currentSpellId ~= nil then
		currentMoonIcon = spells[snapshotData.snapshots[spells.newMoon.id].attributes.currentKey].icon
		moonAstralPower = spells[snapshotData.snapshots[spells.newMoon.id].attributes.currentKey].resource

		if snapshotData.snapshots[spells.newMoon.id].cooldown.onCooldown and snapshotData.snapshots[spells.newMoon.id].cooldown.charges < snapshotData.snapshots[spells.newMoon.id].cooldown.maxCharges then
			_moonCooldown = snapshotData.snapshots[spells.newMoon.id].cooldown:GetRemainingTime(currentTime)
			_moonCooldownTotal = snapshotData.snapshots[spells.newMoon.id].cooldown.remainingTotal
		end
	end
	local moonCooldown = TRB.Functions.BarText:TimerPrecision(_moonCooldown)
	local moonCooldownTotal = TRB.Functions.BarText:TimerPrecision(_moonCooldownTotal)
	]]
	--$eclipseTime
	local _eclispeTime, eclipseIcon = GetEclipseRemainingTime()
	local eclipseTime = TRB.Functions.BarText:TimerPrecision(_eclispeTime)

	--[[--#starweaver
	local starweaverIcon = spells.starweaversWarp.icon
	if snapshotData.snapshots[spells.starweaversWeft.id].buff.isActive then
		starweaverIcon = spells.starweaversWeft.icon
	end

	--$starlordTime
	local _starlordTime = snapshotData.snapshots[spells.starlord.id].buff:GetRemainingTime(currentTime)
	local starlordTime = TRB.Functions.BarText:TimerPrecision(_starlordTime)
	--$starlordStacks
	local _starlordStacks = snapshotData.snapshots[spells.starlord.id].buff.applications or 0
	local starlordStacks = string.format("%.0f", _starlordStacks)

	--$dreamburstTime
	local _dreamburstTime = snapshotData.snapshots[spells.dreamburst.id].buff:GetRemainingTime(currentTime)
	local dreamburstTime = TRB.Functions.BarText:TimerPrecision(_dreamburstTime)
	--$dreamburstStacks
	local _dreamburstStacks = snapshotData.snapshots[spells.dreamburst.id].buff.applications or 0
	local dreamburstStacks = string.format("%.0f", _dreamburstStacks)]]
	----------------------------
	
	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentAstralPower
	lookup["$astralPower"] = currentAstralPower
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$astralPowerMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingAstralPower
	lookup["#moon"] = currentMoonIcon
	lookup["#eclipse"] = eclipseIcon or spells.celestialAlignment.icon
	lookup["$eclipseTime"] = eclipseTime
	lookup["$eclipse"] = ""
	lookup["$lunar"] = ""
	lookup["$lunarEclipse"] = ""
	lookup["$eclipseLunar"] = ""
	lookup["$solar"] = ""
	lookup["$solarEclipse"] = ""
	lookup["$eclipseSolar"] = ""
	lookup["$celestialAlignment"] = ""
	--lookup["#starweaver"] = starweaverIcon
	--lookup["$moonkinForm"] = ""
	--[[lookup["$starweaverTime"] = starweaverTime
	lookup["$starweaver"] = ""
	lookup["$starweaversWarp"] = ""
	lookup["$starweaversWeft"] = ""
	lookup["$moonAstralPower"] = moonAstralPower
	lookup["$moonCharges"] = moonCharges
	lookup["$moonCooldown"] = moonCooldown
	lookup["$moonCooldownTotal"] = moonCooldownTotal
	lookup["$foeAstralPower"] = foeAstralPower
	lookup["$foeTicks"] = foeTicks
	lookup["$foeTime"] = foeTime
	lookup["$bbAstralPower"] = bbAstralPower
	lookup["$bbTicks"] = bbTicks
	lookup["$bbTime"] = bbTime
	lookup["$talentStellarFlare"] = ""
	lookup["$starlordTime"] = starlordTime
	lookup["$starlordStacks"] = starlordStacks
	lookup["$dreamburstTime"] = dreamburstTime
	lookup["$dreamburstStacks"] = dreamburstStacks]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedAstralPower
	lookupLogic["$astralPower"] = normalizedAstralPower
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$astralPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = currentAstralPower
	lookupLogic["$eclipseTime"] = _eclispeTime
	--[[lookupLogic["$starweaver"] = _starweaver
	lookupLogic["$starweaverTime"] = _starweaverTime
	lookupLogic["$starweaversWarp"] = _starweaversWarp
	lookupLogic["$starweaversWeft"] = _starweaversWeft
	lookupLogic["$moonAstralPower"] = moonAstralPower
	lookupLogic["$moonCharges"] = moonCharges
	lookupLogic["$moonCooldown"] = _moonCooldown
	lookupLogic["$moonCooldownTotal"] = _moonCooldownTotal
	lookupLogic["$foeAstralPower"] = foeAstralPower
	lookupLogic["$foeTicks"] = foeTicks
	lookupLogic["$foeTime"] = _foeTime
	lookupLogic["$bbAstralPower"] = bbAstralPower
	lookupLogic["$bbTicks"] = bbTicks
	lookupLogic["$bbTime"] = _bbTime
	lookupLogic["$starlordTime"] = _starlordTime
	lookupLogic["$starlordStacks"] = starlordStacks
	lookupLogic["$dreamburstTime"] = _dreamburstTime
	lookupLogic["$dreamburstStacks"] = dreamburstStacks]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Feral()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.feral
	local sharedSettings = TRB.Data.specCache["feral"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedEnergy = snapshotData.attributes.resourceModified or 0

	--Spec specific implementation

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = sharedSettings.colors.text.overThreshold.color
				castingEnergyColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = sharedSettings.colors.text.spending.color
	end

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)-- TRB.Functions.Number:RoundTo(normalizedAstralPower, resourcePrecision, "floor"))
	--$casting
	local castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	--[[	
	--$brutalSlashCharges
	local brutalSlashCharges = snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges
	--$brutalSlashCooldown
	local _brutalSlashCooldown = snapshotData.snapshots[spells.brutalSlash.id].cooldown:GetRemainingTime(currentTime)
	--$brutalSlashCooldownTotal
	local _brutalSlashCooldownTotal = snapshotData.snapshots[spells.brutalSlash.id].cooldown.remainingTotal

	local brutalSlashCooldown = TRB.Functions.BarText:TimerPrecision(_brutalSlashCooldown)
	local brutalSlashCooldownTotal = TRB.Functions.BarText:TimerPrecision(_brutalSlashCooldownTotal)
	
	--$bloodtalonsStacks
	local bloodtalonsStacks = snapshotData.snapshots[spells.bloodtalons.id].buff.applications or 0

	--$bloodtalonsTime
	local _bloodtalonsTime = snapshotData.snapshots[spells.bloodtalons.id].buff:GetRemainingTime(currentTime)
	local bloodtalonsTime = TRB.Functions.BarText:TimerPrecision(_bloodtalonsTime)
	
	--$tigersFuryTime
	local _tigersFuryTime = snapshotData.snapshots[spells.tigersFury.id].buff:GetRemainingTime(currentTime)
	local tigersFuryTime = TRB.Functions.BarText:TimerPrecision(_tigersFuryTime)
	
	--$tigersFuryCooldownTime
	local _tigersFuryCooldownTime = snapshotData.snapshots[spells.tigersFury.id].cooldown:GetRemainingTime(currentTime)
	local tigersFuryCooldownTime = TRB.Functions.BarText:TimerPrecision(_tigersFuryCooldownTime)

	--$suddenAmbushTime
	local _suddenAmbushTime = snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
	local suddenAmbushTime = TRB.Functions.BarText:TimerPrecision(_suddenAmbushTime)
	
	--$clearcastingStacks
	local clearcastingStacks = snapshotData.snapshots[spells.clearcasting.id].buff.applications

	--$clearcastingTime
	local _clearcastingTime = snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
	local clearcastingTime = TRB.Functions.BarText:TimerPrecision(_clearcastingTime)]]

	--$berserkTime (and $incarnationTime)
	local _berserkTime = GetBerserkRemainingTime()
	local berserkTime = TRB.Functions.BarText:TimerPrecision(_berserkTime)

	--$incarnationTicks 
	local _incarnationTicks = snapshotData.snapshots[spells.berserk.id].attributes.ticks
	
	--$incarnationTickTime
	local _incarnationTickTime = snapshotData.snapshots[spells.berserk.id].attributes.untilNextTick
	local incarnationTickTime = TRB.Functions.BarText:TimerPrecision(_incarnationTickTime)

	--[[--$apexPredatorsCravingTime
	local _apexPredatorsCravingTime = snapshotData.snapshots[spells.apexPredatorsCraving.id].buff:GetRemainingTime(currentTime)
	local apexPredatorsCravingTime = TRB.Functions.BarText:TimerPrecision(_apexPredatorsCravingTime)]]
	--$incarnationNextCp
	local incarnationNextCp = 0

		for x = 1, TRB.Data.character.maxResource2 do
		if snapshotData.attributes.resource2 < x then
			if incarnationNextCp == 0 and _incarnationTicks > 0 then
				incarnationNextCp = x
			end
		end
	end

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$inStealth"] = ""
	lookup["$berserkTime"] = berserkTime
	lookup["$incarnationTime"] = berserkTime
	lookup["$incarnationTicks"] = _incarnationTicks
	lookup["$incarnationTickTime"] = incarnationTickTime
	lookup["$incarnationNextCp"] = incarnationNextCp
	--[[
	lookup["$lunarInspiration"] = ""
	lookup["$brutalSlashCharges"] = brutalSlashCharges
	lookup["$brutalSlashCooldown"] = brutalSlashCooldown
	lookup["$brutalSlashCooldownTotal"] = brutalSlashCooldownTotal
	lookup["$bloodtalonsStacks"] = bloodtalonsStacks
	lookup["$bloodtalonsTime"] = bloodtalonsTime
	lookup["$suddenAmbushTime"] = suddenAmbushTime
	lookup["$clearcastingStacks"] = clearcastingStacks
	lookup["$clearcastingTime"] = clearcastingTime
	lookup["$apexPredatorsCravingTime"] = apexPredatorsCravingTime
	lookup["$tigersFuryTime"] = tigersFuryTime
	lookup["$tigersFuryCooldownTime"] = tigersFuryCooldownTime]]
	TRB.Data.lookup = lookup
	

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$inStealth"] = IsStealthed()
	lookupLogic["$berserkTime"] = _berserkTime
	lookupLogic["$incarnationTime"] = _berserkTime
	lookupLogic["$incarnationTicks"] = _incarnationTicks
	lookupLogic["$incarnationTickTime"] = _incarnationTickTime
	lookupLogic["$incarnationNextCp"] = incarnationNextCp
	--[[
	lookupLogic["$brutalSlashCharges"] = brutalSlashCharges
	lookupLogic["$brutalSlashCooldown"] = _brutalSlashCooldown
	lookupLogic["$brutalSlashCooldownTotal"] = _brutalSlashCooldownTotal
	lookupLogic["$bloodtalonsStacks"] = bloodtalonsStacks
	lookupLogic["$bloodtalonsTime"] = _bloodtalonsTime
	lookupLogic["$suddenAmbushTime"] = _suddenAmbushTime
	lookupLogic["$clearcastingStacks"] = clearcastingStacks
	lookupLogic["$clearcastingTime"] = _clearcastingTime
	lookupLogic["$apexPredatorsCravingTime"] = _apexPredatorsCravingTime
	lookupLogic["$tigersFuryTime"] = _tigersFuryTime
	lookupLogic["$tigersFuryCooldownTime"] = _tigersFuryCooldownTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Guardian()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.guardian
	local sharedSettings = TRB.Data.specCache["guardian"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	--Spec specific implementation

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)-- TRB.Functions.Number:RoundTo(_currentRage, resourcePrecision, "floor"))
	--$casting
	local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))

	
	--$berserkTime (and $incarnationTime)
	local berserkSnapshotBuff = snapshotData.snapshots[spells.berserk.id].buff

	if not berserkSnapshotBuff.isActive then
		berserkSnapshotBuff = snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff
	end

	local _berserkTime = berserkSnapshotBuff:GetRemainingTime(currentTime)
	local berserkTime = TRB.Functions.BarText:TimerPrecision(_berserkTime)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingRage
	lookup["$berserkTime"] = berserkTime
	lookup["$incarnationTime"] = berserkTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$rage"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$berserkTime"] = _berserkTime
	lookupLogic["$incarnationTime"] = _berserkTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Restoration()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.druid.restoration
	local sharedSettings = TRB.Data.specCache["restoration"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.druid.restoration.colors.text.current.color
	local castingManaColor = TRB.Data.settings.druid.restoration.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.druid.restoration.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	--[[local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end]]
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	--$efflorescenceTime
	local _efflorescenceTime = snapshots[spells.efflorescence.id].buff:GetRemainingTime(currentTime) --TODO: This isn't actually how this works, double check/fix it
	local efflorescenceTime = TRB.Functions.BarText:TimerPrecision(_efflorescenceTime)

	--$incarnationTime
	local _incarnationTime = snapshots[spells.incarnationTreeOfLife.id].buff:GetRemainingTime(currentTime)
	local incarnationTime = TRB.Functions.BarText:TimerPrecision(_incarnationTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$incarnationTime"] = incarnationTime
	lookup["$efflorescenceTime"] = efflorescenceTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$efflorescenceTime"] = _efflorescenceTime
	lookupLogic["$incarnationTime"] = _incarnationTime
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting_Balance(spell)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	local resource = spell.resource

	if talents:IsTalentActive(spells.boundlessMoonlight) and spell.attributes.boundlessMoonlight ~= nil and spell.attributes.boundlessMoonlight > 0 then
		resource = resource + (spells.boundlessMoonlight.attributes.resourceMod * spell.attributes.boundlessMoonlight)
	end

	if talents:IsTalentActive(spells.theEternalMoon) and spell.attributes.theEternalMoon ~= nil and spell.attributes.theEternalMoon > 0 then
		resource = resource + (spells.theEternalMoon.attributes.moonResourceMod * spell.attributes.theEternalMoon)
	end

	casting.startTime = currentTime
	casting.resourceRaw = spell.resource
	casting.resourceFinal = spell.resource
	casting.spellId = spell.id
	casting.icon = spell.icon
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Restoration()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
		
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			if spellId == spells.wrath.id then
				FillSnapshotDataCasting_Balance(spells.wrath)

				if talents:IsTalentActive(spells.wildSurges) then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.attributes.resourceMod
				end
				if talents:IsTalentActive(spells.soulOfTheForest) and snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.attributes.modifier.wrath)
				end
			elseif spellId == spells.starfire.id then
				FillSnapshotDataCasting_Balance(spells.starfire)
				if talents:IsTalentActive(spells.wildSurges) then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.attributes.resourceMod
				end
				if talents:IsTalentActive(spells.moonGuardian) then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.moonGuardian.attributes.resourceMod
				end
				if talents:IsTalentActive(spells.soulOfTheForest) and snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.attributes.modifier.starfire)
				end
			elseif spellId == spells.stellarFlare.id then
				FillSnapshotDataCasting_Balance(spells.stellarFlare)
			elseif spellId == spells.newMoon.id then
				FillSnapshotDataCasting_Balance(spells.newMoon)
			elseif spellId == spells.halfMoon.id then
				FillSnapshotDataCasting_Balance(spells.halfMoon)
			elseif spellId == spells.fullMoon.id then
				FillSnapshotDataCasting_Balance(spells.fullMoon)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.eclipseSolar.castId then
				snapshotData.snapshots[spells.eclipseSolar.id].buff:InitializeCustom(spells.eclipseSolar.duration, currentTime)
			elseif spellId == spells.eclipseLunar.castId then
				snapshotData.snapshots[spells.eclipseLunar.id].buff:InitializeCustom(spells.eclipseLunar.duration, currentTime)
			elseif spellId == spells.celestialAlignment.castId or spellId == spells.celestialAlignment.talentId then
				local duration = spells.celestialAlignment.duration

				snapshotData.snapshots[spells.celestialAlignment.id].buff:InitializeCustom(duration, currentTime)
			elseif spellId == spells.incarnationChosenOfElune.castId or spellId == spells.incarnationChosenOfElune.id then
				local duration = spells.incarnationChosenOfElune.duration

				snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
				local spells = spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.berserk.castId then
				snapshotData.snapshots[spells.berserk.id].buff:InitializeCustom(spells.berserk.duration, currentTime)
			elseif spellId == spells.incarnationAvatarOfAshamane.castId or spellId == spells.incarnationAvatarOfAshamane.attributes.castId2 then
				snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff:InitializeCustom(spells.incarnationAvatarOfAshamane.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.berserk.castId then
				snapshotData.snapshots[spells.berserk.id].buff:InitializeCustom(spells.berserk.duration, currentTime)
			elseif spellId == spells.incarnationGuardianOfUrsoc.castId then
				snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff:InitializeCustom(spells.incarnationGuardianOfUrsoc.duration, currentTime)
			end
		elseif event == "SPELL_UPDATE_ICON" then

		end
	elseif TRB.Data.character.specId == 4 then
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Restoration()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.efflorescence.castId then
				snapshotData.snapshots[spells.efflorescence.id].buff:InitializeCustom(spells.efflorescence.duration, currentTime)
			elseif spellId == spells.incarnationTreeOfLife.castId then
				snapshotData.snapshots[spells.incarnationTreeOfLife.id].buff:InitializeCustom(spells.incarnationTreeOfLife.duration, currentTime)
			elseif spellId == spells.lifebloom.castId then
				if talents:IsTalentActive(spells.lifetreading) then
					snapshotData.snapshots[spells.efflorescence.id].buff:InitializeCustom(spells.efflorescence.duration, currentTime)
				end
			end
		end
	end
end

---Calculates the incoming combo points for a given effect
---@param spell TRB.Classes.SpellBase
---@param buffSnapshot TRB.Classes.Snapshot
---@param cpSnapshot TRB.Classes.Snapshot
local function CalculateIncomingComboPointsForEffect(spell, buffSnapshot, cpSnapshot)
	local currentTime = GetTime()
	buffSnapshot.buff:GetRemainingTime(currentTime)
	local remainingTime = buffSnapshot.buff.remaining

	if remainingTime > 0 then
		local offset = spell.attributes.offset or 0
		local totalCps = TRB.Functions.Number:RoundTo((remainingTime - offset) / spell:GetTickRate(), 0, "ceil", true) or 0
		local untilNextTick = remainingTime - offset - (spell:GetTickRate() * math.max(0, totalCps - 1))-- - (currentTime - (cpSnapshot.attributes.lastTick or currentTime))

		if buffSnapshot.buff.endTime < currentTime then
			totalCps = 1
			untilNextTick = 0
		elseif untilNextTick < 0 then
			totalCps = totalCps + 1
			untilNextTick = 0
		end

		cpSnapshot.attributes.ticks = totalCps
		cpSnapshot.attributes.nextTick = currentTime + untilNextTick
		cpSnapshot.attributes.untilNextTick = untilNextTick
		cpSnapshot.attributes.tickRate = spell:GetTickRate()
	else
		buffSnapshot.buff:Reset()
		cpSnapshot.attributes.lastTick = nil
		cpSnapshot.attributes.ticks = 0
		cpSnapshot.attributes.nextTick = nil
		cpSnapshot.attributes.untilNextTick = 0
		cpSnapshot.attributes.tickRate = spell:GetTickRate()
	end
end

local function UpdateBerserkIncomingComboPoints()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local berserk = TRB.Data.snapshotData.snapshots[spells.berserk.id] --[[@as TRB.Classes.Snapshot]]
	local incarnationAvatarOfAshamane = TRB.Data.snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id] --[[@as TRB.Classes.Snapshot]]
	if incarnationAvatarOfAshamane.buff.isActive then
		CalculateIncomingComboPointsForEffect(spells.incarnationAvatarOfAshamane, incarnationAvatarOfAshamane, berserk)
	else
		CalculateIncomingComboPointsForEffect(spells.berserk, berserk, berserk)
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
end

local function UpdateSnapshot_Balance()
	UpdateSnapshot()
	GetCurrentMoonSpell()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	snapshotData.snapshots[spells.celestialAlignment.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.eclipseSolar.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.eclipseLunar.id].buff:GetRemainingTime(currentTime)
	
	--[[snapshotData.snapshots[spells.furyOfElune.id].buff:UpdateTicks(currentTime)
	snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
	snapshotData.snapshots[spells.theLightOfElune.id].buff:UpdateTicks(currentTime)
	snapshotData.snapshots[spells.forceOfNature.id].buff:UpdateTicks(currentTime)
	snapshotData.snapshots[spells.starfall.id].buff:GetRemainingTime(currentTime)
	
	if talents:IsTalentActive(spells.theEternalMoon) then
		if snapshotData.snapshots[spells.furyOfElune.id].buff.isActive then
			snapshotData.snapshots[spells.furyOfElune.id].buff.resource = snapshotData.snapshots[spells.furyOfElune.id].buff.resource + spells.theEternalMoon.attributes.furyResourceMod
		end

		if snapshotData.snapshots[spells.sunderedFirmament.id].buff.isActive then
			snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource = snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource + spells.theEternalMoon.attributes.furyResourceMod
		end

		if snapshotData.snapshots[spells.theLightOfElune.id].buff.isActive then
			snapshotData.snapshots[spells.theLightOfElune.id].buff.resource = snapshotData.snapshots[spells.theLightOfElune.id].buff.resource + spells.theEternalMoon.attributes.furyResourceMod
		end
	end]]
end

local function UpdateSnapshot_Feral()
	UpdateSnapshot()
	UpdateBerserkIncomingComboPoints()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	--snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
	--snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
	
	-- Incarnation: King of the Jungle doesn't show up in-game as a combat log event. Check for it manually instead.
	--[[if talents:IsTalentActive(spells.incarnationAvatarOfAshamane) then
		snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff:GetRemainingTime(currentTime)
	end

	snapshotData.snapshots[spells.tigersFury.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.tigersFury.id].cooldown:Refresh(true)

	snapshotData.snapshots[spells.feralFrenzy.id].cooldown:Refresh()
	snapshotData.snapshots[spells.maim.id].cooldown:Refresh()
	
	snapshotData.snapshots[spells.ravage.id].buff:GetRemainingTime(currentTime)

	if talents:IsTalentActive(spells.brutalSlash) then
		snapshotData.snapshots[spells.brutalSlash.id].cooldown:Refresh()
	end
	
	if talents:IsTalentActive(spells.bloodtalons) then
		snapshotData.snapshots[spells.bloodtalons.id].cooldown:Refresh()
	end
	
	if talents:IsTalentActive(spells.empoweredShapeshifting) then
		snapshotData.snapshots[spells.frenziedRegeneration.id].cooldown:Refresh()
	end]]
end

local function UpdateSnapshot_Guardian()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	snapshotData.snapshots[spells.berserk.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff:GetRemainingTime(currentTime)
	-- Add any Guardian-specific snapshot updates here when spells are defined
end

local function UpdateSnapshot_Restoration()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.druid
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.balance
		local specCacheSettings = TRB.Data.specCache.balance.settings
		UpdateSnapshot_Balance()

		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
				local affectingCombat = TRB.Data.character.inCombat
				local flashBar = false
				local barBorderColor = specSettings.colors.bar.border

				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local thresholds = primaryNode:GetThresholds()
				local nodeResourceFrame = primaryNode:GetResourceFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
						TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					local isUsable = spell:IsUsable()
						
					local astralCommunionOffset = 0
					--[[if snapshotData.snapshots[spells.astralCommunion.id].buff.isActive then
						astralCommunionOffset = -spells.astralCommunion.attributes.resourceMod
					end]]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.settingKey == spells.starsurge.settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif isUsable then-- snapshots[spells.starweaversWeft.id].buff.isActive or snapshots[spells.touchTheCosmos.id].buff.isActive or currentResource >= spells.starsurge:GetPrimaryResourceCost() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
							
							if showThreshold then
								if isUsable --[[(snapshots[spells.starweaversWeft.id].buff.isActive or snapshots[spells.touchTheCosmos.id].buff.isActive)]] and specSettings.audio.starweaversReady.enabled and snapshotData.audio.playedstarweaverCue == false then
									snapshotData.audio.playedstarweaverCue = true
									snapshotData.audio.playedSfCue = true
									PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
								elseif specSettings.audio.ssReady.enabled and snapshotData.audio.playedSsCue == false then
									snapshotData.audio.playedSsCue = true
									PlaySoundFile(specSettings.audio.ssReady.sound, coreSettings.audio.channel.channel)
								end
							else
								snapshotData.audio.playedSsCue = false
								snapshotData.audio.playedstarweaverCue = false
							end
						elseif spell.settingKey == spells.starsurge2.settingKey then
							--[[resourceAmount = spells.starsurge2:GetPrimaryResourceCost() + astralCommunionOffset
							local aboveCounts = 0
							if snapshots[spells.starweaversWeft.id].buff.isActive then
								aboveCounts = aboveCounts + 1
							end
							
							if snapshots[spells.touchTheCosmos.id].buff.isActive then
								aboveCounts = aboveCounts + 1
							end
							
							if isUsable then-- currentResource >= resourceAmount then
								aboveCounts = aboveCounts + 2
							elseif currentResource >= spells.starsurge:GetPrimaryResourceCost() then
								aboveCounts = aboveCounts + 1
							end]]

							--[[if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount >= TRB.Data.character.maxResource then
								showThreshold = false
							else]]if specCacheSettings.thresholds.specProperties.starsurgeThresholdOnlyOverShow then--and aboveCounts < 2 then
								showThreshold = false
							--[[elseif aboveCounts >= 2 then
								thresholdColor = specCacheSettings.colors.threshold.over.color]]
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.settingKey == spells.starsurge3.settingKey then
							--[[resourceAmount = spells.starsurge3:GetPrimaryResourceCost() + (astralCommunionOffset * 2)
							local aboveCounts = 0
							if snapshots[spells.starweaversWeft.id].buff.isActive then
								aboveCounts = aboveCounts + 1
							end
							
							if snapshots[spells.touchTheCosmos.id].buff.isActive then
								aboveCounts = aboveCounts + 1
							end
							
							if isUsable then-- currentResource >= resourceAmount then
								aboveCounts = aboveCounts + 3
							elseif currentResource >= spells.starsurge2:GetPrimaryResourceCost() + astralCommunionOffset then
								aboveCounts = aboveCounts + 2
							elseif currentResource >= spells.starsurge:GetPrimaryResourceCost() then
								aboveCounts = aboveCounts + 1
							end

							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount >= TRB.Data.character.maxResource then
								showThreshold = false
							else]]if specCacheSettings.thresholds.specProperties.starsurgeThresholdOnlyOverShow then-- and aboveCounts < 3 then
								showThreshold = false
							--[[elseif aboveCounts >= 3 then
								thresholdColor = specCacheSettings.colors.threshold.over.color]]
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.starfall.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif isUsable then -- snapshots[spells.starweaversWarp.id].buff.isActive or snapshots[spells.touchTheCosmos.id].buff.isActive or currentResource >= spells.starfall:GetPrimaryResourceCost() then
								--[[if snapshots[spells.starfall.id].buff.isActive and (snapshots[spells.starfall.id].buff.remaining) > (TRB.Data.character.pandemicModifier * spells.starfall.pandemicTime) then
									thresholdColor = specCacheSettings.colors.threshold.starfallPandemic.color
								else]]
									thresholdColor = specCacheSettings.colors.threshold.over.color
								--end
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end

							if showThreshold then
								if isUsable --[[(snapshots[spells.starweaversWarp.id].buff.isActive or snapshots[spells.touchTheCosmos.id].buff.isActive)]] and specSettings.audio.starweaversReady.enabled and snapshotData.audio.playedstarweaverCue == false then
									snapshotData.audio.playedstarweaverCue = true
									snapshotData.audio.playedSfCue = true
									PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
								elseif specSettings.audio.sfReady.enabled and snapshotData.audio.playedSfCue == false then
									snapshotData.audio.playedSfCue = true
									PlaySoundFile(specSettings.audio.sfReady.sound, coreSettings.audio.channel.channel)
								end
							end
						end
					--The rest isn't used. Keeping it here for consistency until I can finish abstracting this whole mess out
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.hasCooldown then
						--[[if snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						else]]if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then --currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end

					--[[
					TODO: Find out if this is still required for Starfall?
					local snapshotCooldown = nil
					if snapshots[spell.id] ~= nil then
						snapshotCooldown = snapshots[spell.id].cooldown
					end
					]]
					
					if resourceAmount == nil then
						showThreshold = false
					elseif resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end
				
				if specSettings.colors.bar.flashSsEnabled and spells.starsurge:IsUsable() then-- currentResource >= spells.starsurge:GetPrimaryResourceCost() then
					flashBar = true
				end

				local barColor = specSettings.colors.bar.base

				--[[if not snapshots[spells.moonkinForm.id].buff.isActive and affectingCombat then
					barColor = specSettings.colors.bar.moonkinFormMissing
					if specSettings.colors.bar.flashEnabled then
						flashBar = true
					end
				else]]if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
					local timeThreshold = 0
					local useEndOfEclipseColor = false

					if specSettings.endOfEclipse.enabled and (not specSettings.endOfEclipse.celestialAlignmentOnly or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive) then
						useEndOfEclipseColor = true
						if specSettings.endOfEclipse.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfEclipse.gcdsMax
						elseif specSettings.endOfEclipse.mode == "time" then
							timeThreshold = specSettings.endOfEclipse.timeMax
						end
					end

					if useEndOfEclipseColor and GetEclipseRemainingTime() <= timeThreshold then
						barColor = specSettings.colors.bar.eclipse1GCD
					else
						if snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive or (snapshots[spells.eclipseSolar.id].buff.isActive and snapshots[spells.eclipseLunar.id].buff.isActive) then
							barColor = specSettings.colors.bar.celestial
						elseif snapshots[spells.eclipseSolar.id].buff.isActive then
							barColor = specSettings.colors.bar.solar
						else
							barColor = specSettings.colors.bar.lunar
						end
					end
				end
				
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				if flashBar then
					TRB.Functions.Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		if TRB.Data.character.maxResource2 == nil then
			return
		end
		local specSettings = classSettings.feral
		local specCacheSettings = TRB.Data.specCache.feral.settings
		UpdateSnapshot_Feral()

		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local thresholds = primaryNode:GetThresholds()
				local nodeResourceFrame = primaryNode:GetResourceFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
						TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.attributes.isClearcasting and snapshots[spells.clearcasting.id].buff.applications ~= nil and snapshots[spells.clearcasting.id].buff.applications > 0 then
						if spell.id == spells.brutalSlash.id then
							if not talents:IsTalentActive(spells.brutalSlash) then
								showThreshold = false
							elseif snapshots[spells.brutalSlash.id].cooldown.charges > 0 then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end
						elseif spell.id == spells.swipe.id then
							if talents:IsTalentActive(spells.brutalSlash) then
								showThreshold = false
							else
								thresholdColor = specCacheSettings.colors.threshold.over.color
							end
						else
							thresholdColor = specCacheSettings.colors.threshold.over.color
						end
					elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.ferociousBiteMinimum.id then
							if snapshots[spells.ravageMinimum.id].buff.isActive then
								showThreshold = false
							elseif spell.id == spells.ferociousBiteMinimum.id and spell.settingKey == "ferociousBiteMinimum" then
								if isUsable then--currentResource >= resourceAmount or snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.ferociousBiteMaximum.id and spell.settingKey == "ferociousBiteMaximum" then
								if isUsable then--currentResource >= resourceAmount or snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						elseif spell.id == spells.ravageMinimum.id then
							if not snapshots[spells.ravageMinimum.id].buff.isActive then
								showThreshold = false
							elseif spell.id == spells.ravageMinimum.id and spell.settingKey == "ravageMinimum" then
								if isUsable then--currentResource >= resourceAmount or snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.ravageMaximum.id and spell.settingKey == "ravageMaximum" then
								if isUsable then--currentResource >= resourceAmount or snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						elseif spell.id == spells.moonfire.id then
							if not talents:IsTalentActive(spells.lunarInspiration) then
								showThreshold = false
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.swipe.id then
							if talents:IsTalentActive(spells.brutalSlash) then
								showThreshold = false
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.brutalSlash.id then
							if not talents:IsTalentActive(spells.brutalSlash) then
								showThreshold = false
							elseif snapshots[spells.brutalSlash.id].cooldown.charges == 0 then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.frenziedRegeneration.id then
							if not talents:IsTalentActive(spells.empoweredShapeshifting) then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.feralFrenzy.id then
							if talents:IsTalentActive(spells.franticFrenzy) then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.franticFrenzy.id then
							if not talents:IsTalentActive(spells.franticFrenzy) then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base
				
				if snapshots[spells.clearcasting.id].buff.remaining > 0 then
					barColor = specSettings.colors.bar.clearcasting
				end

				if snapshotData.attributes.resource2 == 5 and spells.ferociousBiteMaximum:IsUsable() then-- currentResource >= spells.ferociousBiteMaximum:GetPrimaryResourceCost() then
					barColor = specSettings.colors.bar.maxBite
				end

				if snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
					barColor = specSettings.colors.bar.apexPredator
				end

				local barBorderColor = specSettings.colors.bar.border
				if IsStealthed() then
					barBorderColor = specSettings.colors.bar.borderStealth
				end

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local berserkTotalCps = snapshots[spells.berserk.id].attributes.ticks
				local berserkNextTick = snapshots[spells.berserk.id].attributes.tickRate - snapshots[spells.berserk.id].attributes.untilNextTick

				local berserkTickShown = 0

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								if specSettings.colors.comboPoints.generation and berserkTickShown == 0 and berserkTotalCps > 0 then
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, berserkNextTick * 1000, spells.berserk:GetTickRate() * 1000)
									berserkTickShown = 1

									if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
										cpColor = specSettings.colors.comboPoints.penultimate
									elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
										cpColor = specSettings.colors.comboPoints.final
									end
								else
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
								end
							end
							
							cpNode:SetBorderColor(cpBorderColor)
							cpNode:SetColor(cpColor)
							cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						end
					end
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.guardian
		local specCacheSettings = TRB.Data.specCache.guardian.settings
		UpdateSnapshot_Guardian()

		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local thresholds = primaryNode:GetThresholds()
				local nodeResourceFrame = primaryNode:GetResourceFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
						TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.maul.id then
							if talents:IsTalentActive(spells.raze) then
								showThreshold = false
							elseif talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif isUsable then-- currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end

					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base
				if snapshots[spells.berserk.id].buff.isActive or snapshots[spells.incarnationGuardianOfUrsoc.id].buff.isActive then
					local snapshotBuff = snapshots[spells.berserk.id].buff

					if not snapshotBuff.isActive then
						snapshotBuff = snapshots[spells.incarnationGuardianOfUrsoc.id].buff
					end

					local timeThreshold = 0
					local useEndOfBerserkColor = false

					if specSettings.endOfBerserk.enabled then
						useEndOfBerserkColor = true
						if specSettings.endOfBerserk.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfBerserk.gcdsMax
						elseif specSettings.endOfBerserk.mode == "time" then
							timeThreshold = specSettings.endOfBerserk.timeMax
						end
					end

					if useEndOfBerserkColor and snapshotBuff.remaining <= timeThreshold then
						barColor = specSettings.colors.bar.berserkEnd.color
					else
						barColor = specSettings.colors.bar.berserk.color
					end
				end
				
				primaryNode:SetBorderColor(specSettings.colors.bar.border)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 4 then
		local specSettings = classSettings.restoration
		local specCacheSettings = TRB.Data.specCache.restoration.settings
		UpdateSnapshot_Restoration()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border
			
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local barColor = specSettings.colors.bar.base
				local affectingCombat = TRB.Data.character.inCombat

				if affectingCombat and talents:IsTalentActive(spells.efflorescence) and not snapshots[spells.efflorescence.id].buff.isActive then
					barColor = specSettings.colors.bar.noEfflorescence
				elseif snapshots[spells.incarnationTreeOfLife.id].buff.isActive and (talents:IsTalentActive(spells.cenariusGuidance) or snapshots[spells.clearcasting.id].buff.isActive) then
					local timeThreshold = 0
					local useEndOfIncarnationColor = false

					if specSettings.endOfIncarnation.enabled then
						useEndOfIncarnationColor = true
						if specSettings.endOfIncarnation.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfIncarnation.gcdsMax
						elseif specSettings.endOfIncarnation.mode == "time" then
							timeThreshold = specSettings.endOfIncarnation.timeMax
						end
					end

					if useEndOfIncarnationColor and snapshots[spells.incarnationTreeOfLife.id].buff.remaining <= timeThreshold then
						barColor = specSettings.colors.bar.incarnationEnd
					else
						barColor = specSettings.colors.bar.incarnation
					end
				end
	
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end
			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	end
end

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	
	if TRB.Data.character.specId == 1 then
		specCache.balance.talents:GetTalents()
		FillSpellData_Balance()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.balance)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Balance
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.balance.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#wrath"] = spells.wrath.icon
		lookup["#moonkinForm"] = spells.moonkinForm.icon
		lookup["#starsurge"] = spells.starsurge.icon
		lookup["#starfall"] = spells.starfall.icon
		lookup["#celestialAlignment"] = spells.celestialAlignment.icon
		lookup["#icoe"] = spells.incarnationChosenOfElune.icon
		lookup["#coe"] = spells.incarnationChosenOfElune.icon
		lookup["#incarnation"] = spells.incarnationChosenOfElune.icon
		lookup["#incarnationChosenOfElune"] = spells.incarnationChosenOfElune.icon
		lookup["#solar"] = spells.eclipseSolar.icon
		lookup["#eclipseSolar"] = spells.eclipseSolar.icon
		lookup["#solarEclipse"] = spells.eclipseSolar.icon
		lookup["#lunar"] = spells.eclipseLunar.icon
		lookup["#eclipseLunar"] = spells.eclipseLunar.icon
		lookup["#lunarEclipse"] = spells.eclipseLunar.icon
		lookup["#naturesBalance"] = spells.naturesBalance.icon
		lookup["#soulOfTheForest"] = spells.soulOfTheForest.icon
		lookup["#foe"] = spells.furyOfElune.icon
		lookup["#furyOfElune"] = spells.furyOfElune.icon
		lookup["#sunderedFirmament"] = spells.sunderedFirmament.icon
		lookup["#stellarFlare"] = spells.stellarFlare.icon
		lookup["#newMoon"] = spells.newMoon.icon
		lookup["#halfMoon"] = spells.halfMoon.icon
		lookup["#fullMoon"] = spells.fullMoon.icon
		lookup["#starweaversWarp"] = spells.starweaversWarp.icon
		lookup["#starweaversWeft"] = spells.starweaversWeft.icon
		lookup["#starlord"] = spells.starlord.icon
		lookup["#bb"] = spells.bounteousBloom.icon
		lookup["#bounteousBloom"] = spells.bounteousBloom.icon
		lookup["#dreamburst"] = spells.dreamburst.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.balance.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "balance" then
			TRB.Data.barConstructedForSpec = "balance"
			ConstructResourceBar(specCache.balance.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.feral.talents:GetTalents()
		FillSpellData_Feral()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.feral)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Feral
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.feral.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#apexPredatorsCraving"] = spells.apexPredatorsCraving.icon
		lookup["#berserk"] = spells.berserk.icon
		lookup["#bloodtalons"] = spells.bloodtalons.icon
		lookup["#brutalSlash"] = spells.brutalSlash.icon
		lookup["#carnivorousInstinct"] = spells.carnivorousInstinct.icon
		lookup["#catForm"] = spells.catForm.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		lookup["#feralFrenzy"] = spells.feralFrenzy.icon
		lookup["#ferociousBite"] = spells.ferociousBiteMinimum.icon
		lookup["#incarnation"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#incarnationAvatarOfAshamane"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#lunarInspiration"] = spells.lunarInspiration.icon
		lookup["#maim"] = spells.maim.icon
		lookup["#moonfire"] = spells.moonfire.icon
		lookup["#primalWrath"] = spells.primalWrath.icon
		lookup["#prowl"] = spells.prowl.icon
		lookup["#stealth"] = spells.prowl.icon
		lookup["#rake"] = spells.rake.icon
		lookup["#ravage"] = spells.ravageMinimum.icon
		lookup["#rip"] = spells.rip.icon
		lookup["#shadowmeld"] = spells.shadowmeld.icon
		lookup["#shred"] = spells.shred.icon
		lookup["#suddenAmbush"] = spells.suddenAmbush.icon
		lookup["#swipe"] = spells.swipe.icon
		lookup["#tigersFury"] = spells.tigersFury.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.feral.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "feral" then
			TRB.Data.barConstructedForSpec = "feral"
			ConstructResourceBar(specCache.feral.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.guardian.talents:GetTalents()
		FillSpellData_Guardian()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.guardian)

		--local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		--local spells = spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Guardian
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.guardian)

		TRB.Data.lookup = {}
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.guardian.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "guardian" then
			TRB.Data.barConstructedForSpec = "guardian"
			ConstructResourceBar(specCache.guardian.settings)
		end
	elseif TRB.Data.character.specId == 4 then
		specCache.restoration.talents:GetTalents()
		FillSpellData_Restoration()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.restoration)

		local lookup = TRB.Data.lookup or {}
		lookup["#efflorescence"] = spells.efflorescence.icon
		lookup["#incarnation"] = spells.incarnationTreeOfLife.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		lookup["#reforestation"] = spells.reforestation.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.restoration.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "restoration" then
			TRB.Data.barConstructedForSpec = "restoration"
			ConstructResourceBar(specCache.restoration.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end
	
	TRB.Functions.Class:EventRegistration()

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
				TRB.Functions.Character:ResetCaches()
			end
		end)
	end)
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
eventFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end
	
	if TRB.Data.character.classId == 11 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Druid.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.balance == nil or
						TwintopInsanityBarSettings.druid.balance.displayText == nil then
						settings.druid.balance.displayText.barText = TRB.Options.Druid.BalanceLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.feral == nil or
						TwintopInsanityBarSettings.druid.feral.displayText == nil then
						settings.druid.feral.displayText.barText = TRB.Options.Druid.FeralLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.guardian == nil or
						TwintopInsanityBarSettings.druid.guardian.displayText == nil then
						settings.druid.guardian.displayText.barText = TRB.Options.Druid.GuardianLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.restoration == nil or
						TwintopInsanityBarSettings.druid.restoration.displayText == nil then
						settings.druid.restoration.displayText.barText = TRB.Options.Druid.RestorationLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Druid.LoadDefaultSettings(true)
					TRB.Data.settings = settings
				end
				FillSpecializationCache()

				SLASH_TWINTOP1 	= "/twintop"
				SLASH_TWINTOP2 	= "/tt"
				SLASH_TWINTOP3 	= "/tib"
				SLASH_TWINTOP4 	= "/tit"
				SLASH_TWINTOP5 	= "/ttib"
				SLASH_TWINTOP6 	= "/ttit"
				SLASH_TWINTOP7 	= "/trb"
				SLASH_TWINTOP8 	= "/trt"
				SLASH_TWINTOP9 	= "/ttrt"
				SLASH_TWINTOP10 = "/ttrb"
			end
		end

		if event == "PLAYER_LOGOUT" then
			TwintopInsanityBarSettings = TRB.Data.settings
		end

		if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
			if not TRB.Details.addonData.optionsPanelStarted then
				TRB.Details.addonData.optionsPanelStarted = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
						TRB.Data.settings.druid.balance = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidBalanceFull"], TRB.Data.settings.druid.balance)
						TRB.Data.settings.druid.feral = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidFeralFull"], TRB.Data.settings.druid.feral)
						TRB.Data.settings.druid.guardian = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidGuardianFull"], TRB.Data.settings.druid.guardian)
						TRB.Data.settings.druid.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidRestorationFull"], TRB.Data.settings.druid.restoration)
						
						FillSpellData_Balance()
						FillSpellData_Feral()
						FillSpellData_Guardian()
						FillSpellData_Restoration()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Druid.ConstructOptionsPanel(specCache)

						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end

						TRB.Functions.Class:EventRegistration()
						TRB.Functions.News:Init()
						TRB.Details.addonData.optionsPanelFinished = true
					end)
				end)
			end

			if TRB.Details.addonData.optionsPanelFinished and (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED") then
				C_Timer.After(0, function()
					C_Timer.After(0.1, function()
						SwitchSpec()
					end)
				end)
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	local specId = GetSpecialization()
	if specId ~= TRB.Data.character.specId then
		SwitchSpec()
	end
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "druid"

	local barGroups = TRB.Frames.barGroups

	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "balance"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.LunarPower, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.LunarPower, false)
		GetCurrentMoonSpell()

		--TRB.Data.snapshotData.snapshots[TRB.Data.spellsData.spells.moonkinForm.id].buff:Initialize(nil, true)
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil and barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		TRB.Data.character.specName = "feral"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)
		local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
				-- Rebuild secondary bar layout when combo point count changes
				if barGroups and barGroups.secondary then
					barGroups.secondary:SetMaxNodes(maxComboPoints)
					barGroups.secondary:SetNodeCount(maxComboPoints)
					barGroups.secondary:SetLayout(sharedSettings.comboPoints.spacing, sharedSettings.comboPoints.fullWidth, "HORIZONTAL")
					barGroups.secondary:ApplyLayout(
						sharedSettings.bar.width,
						sharedSettings.comboPoints.width,
						sharedSettings.comboPoints.height,
						sharedSettings.comboPoints.border
					)
					-- Apply textures and colors to any newly created nodes
					local frameLevels = TRB.Data.constants.frameLevels
					for i = 1, maxComboPoints do
						local node = barGroups.secondary:GetNode(i)
						if node then
							node:SetTextures(
								sharedSettings.textures.comboPointsBar,
								sharedSettings.textures.comboPointsBorder,
								sharedSettings.textures.comboPointsBackground
							)
							node:SetMinMax(0, 1)
							node:SetBorderColor(sharedSettings.colors.comboPoints.border)
							node:SetBackgroundColorFromString(sharedSettings.colors.comboPoints.background)
							node:SetColor(sharedSettings.colors.comboPoints.base)
							node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
						end
					end
				end
			end
		end

		if talents:IsTalentActive(spells.circleOfLifeAndDeath) then
			TRB.Data.character.pandemicModifier = spells.circleOfLifeAndDeath.attributes.modifier
		end
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "guardian"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Rage, false)
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil and barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
		end
	elseif TRB.Data.character.specId == 4 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		TRB.Data.character.specName = "restoration"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil and barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	local primaryResourceToken
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.druid.balance == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.LunarPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		primaryResourceToken = "LUNAR_POWER"
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.druid.feral == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ComboPoints
		TRB.Data.resource2Factor = 1
		primaryResourceToken = "ENERGY"
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.druid.guardian == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		primaryResourceToken = "RAGE"
	elseif TRB.Data.character.specId == 4 and TRB.Data.settings.core.enabled.druid.restoration then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		primaryResourceToken = "MANA"
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
	TRB.Data.resourceToken = primaryResourceToken
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 or TRB.Data.character.specId == 4 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		if sharedSettings ~= nil then
			local affectingCombat = TRB.Data.character.inCombat
			if not TRB.Data.specSupported or force or
				(TRB.Data.character.advancedFlight and not sharedSettings.displayBar.dragonriding) or
				((not affectingCombat) and (not UnitInVehicle("player")) and (not sharedSettings.displayBar.alwaysShow)) then
				if barGroups and barGroups.primary then
					barGroups.primary:Hide()
				end
				if barGroups and barGroups.secondary then
					barGroups.secondary:Hide()
				end
				TRB.Functions.BarText:Hide(sharedSettings)
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if sharedSettings.displayBar.neverShow == true then
					if barGroups and barGroups.primary then
						barGroups.primary:Hide()
					end
					if barGroups and barGroups.secondary then
						barGroups.secondary:Hide()
					end
					TRB.Functions.BarText:Hide(sharedSettings)
				else
					if barGroups and barGroups.primary then
						barGroups.primary:Show()
					end
					if barGroups and barGroups.secondary then
						if TRB.Data.character.specId == 2 then -- Feral uses Combo Points
							barGroups.secondary:Show()
							barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
						else
							barGroups.secondary:Hide()
						end
					end
					TRB.Functions.BarText:Show(sharedSettings)
				end
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
			end
			TRB.Functions.BarText:Hide(sharedSettings)
			snapshotData.attributes.isTracking = false
		end
	else
		if barGroups and barGroups.primary then
			barGroups.primary:Hide()
		end
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end

	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
		settings = TRB.Data.settings.druid.balance
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		settings = TRB.Data.settings.druid.feral
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
		settings = TRB.Data.settings.druid.guardian
	elseif TRB.Data.character.specId == 4 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		settings = TRB.Data.settings.druid.restoration
	else
		return false
	end

	local affectingCombat = TRB.Data.character.inCombat

	if TRB.Data.character.specId == 1 then -- Balance
		--[[if var == "$moonkinForm" then
			if snapshots[spells.moonkinForm.id].buff.isActive then
				valid = true
			end
		else]]if var == "$eclipse" then
			if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
				valid = true
			end
		elseif var == "$solar" or var == "$eclipseSolar" or var == "$solarEclipse" then
			if snapshots[spells.eclipseSolar.id].buff.isActive then
				valid = true
			end
		elseif var == "$lunar" or var == "$eclipseLunar" or var == "$lunarEclipse" then
			if snapshots[spells.eclipseLunar.id].buff.isActive then
				valid = true
			end
		elseif var == "$celestialAlignment" then
			if snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
				valid = true
			end
		elseif var == "$eclipseTime" then
			if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
				valid = true
			end
		elseif var == "$resource" or var == "$astralPower" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$astralPowerMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0 then
				valid = true
			end
		--[[elseif var == "$foeAstralPower" then
			if snapshots[spells.furyOfElune.id].buff.resource > 0 or snapshots[spells.theEternalMoon.id].buff.resource > 0 or snapshots[spells.sunderedFirmament.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$foeTicks" then
			if snapshots[spells.furyOfElune.id].buff.isActive or snapshots[spells.theLightOfElune.id].buff.isActive or snapshots[spells.sunderedFirmament.id].buff.isActive then
				valid = true
			end
		elseif var == "$foeTime" then
			if snapshots[spells.furyOfElune.id].buff.isActive or snapshots[spells.theLightOfElune.id].buff.isActive or snapshots[spells.sunderedFirmament.id].buff.isActive then
				valid = true
			end
		elseif var == "$bbAstralPower" then
			if snapshots[spells.forceOfNature.id].buff.resource > 0 then
				valid = true
			end
		elseif var == "$bbTicks" then
			if snapshots[spells.forceOfNature.id].buff.isActive then
				valid = true
			end
		elseif var == "$bbTime" then
			if snapshots[spells.forceOfNature.id].buff.isActive then
				valid = true
			end
		elseif var == "$starweaverTime" then
			if snapshots[spells.starweaversWarp.id].buff.isActive or snapshots[spells.starweaversWarp.id].buff.isActive  then
				valid = true
			end
		elseif var == "$starweaversWarp" then
			if snapshots[spells.starweaversWarp.id].buff.isActive then
				valid = true
			end
		elseif var == "$starweaversWeft" then
			if snapshots[spells.starweaversWarp.id].buff.isActive then
				valid = true
			end
		elseif var == "$moonAstralPower" then
			if talents:IsTalentActive(spells.newMoon) then
				valid = true
			end
		elseif var == "$moonCharges" then
			if talents:IsTalentActive(spells.newMoon) then
				if snapshots[spells.newMoon.id].cooldown.charges > 0 then
					valid = true
				end
			end
		elseif var == "$moonCooldown" then
			if talents:IsTalentActive(spells.newMoon) then
				if snapshots[spells.newMoon.id].cooldown.onCooldown then
					valid = true
				end
			end
		elseif var == "$moonCooldownTotal" then
			if talents:IsTalentActive(spells.newMoon) then
				if snapshots[spells.newMoon.id].cooldown.charges < snapshots[spells.newMoon.id].cooldown.maxCharges then
					valid = true
				end
			end
		end
		elseif var == "$starlordStacks" then
			if snapshots[spells.starlord.id].buff.isActive then
				valid = true
			end
		elseif var == "$starlordTime" then
			if snapshots[spells.starlord.id].buff.isActive then
				valid = true
			end
		elseif var == "$dreamburstStacks" then
			if snapshots[spells.dreamburst.id].buff.isActive then
				valid = true
			end
		elseif var == "$dreamburstTime" then
			if snapshots[spells.dreamburst.id].buff.isActive then
				valid = true
			end]]
		end
	elseif TRB.Data.character.specId == 2 then -- Feral
		if var == "$resource" or var == "$energy" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$comboPoints" then
			valid = true
		elseif var == "$comboPointsMax" then
			valid = true
		--[[
		elseif var == "$lunarInspiration" then
			if talents:IsTalentActive(spells.lunarInspiration) == true then
				valid = true
			end
		elseif var == "$brutalSlashCharges" then
			if talents:IsTalentActive(spells.brutalSlash) then
				if snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges > 0 then
					valid = true
				end
			end
		elseif var == "$brutalSlashCooldown" then
			if talents:IsTalentActive(spells.brutalSlash) then
				if snapshotData.snapshots[spells.brutalSlash.id].cooldown.onCooldown then
					valid = true
				end
			end
		elseif var == "$brutalSlashCooldownTotal" then
			if talents:IsTalentActive(spells.brutalSlash) then
				if snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges < snapshotData.snapshots[spells.brutalSlash.id].cooldown.maxCharges then
					valid = true
				end
			end
		elseif var == "$bloodtalonsStacks" then
			if snapshots[spells.bloodtalons.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$bloodtalonsTime" then
			if snapshots[spells.bloodtalons.id].buff.isActive then
				valid = true
			end
		elseif var == "$suddenAmbushTime" then
			if snapshots[spells.suddenAmbush.id].buff.isActive then
				valid = true
			end
		elseif var == "$clearcastingStacks" then
			if snapshots[spells.clearcasting.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$clearcastingTime" then
			if snapshots[spells.clearcasting.id].buff.isActive then
				valid = true
			end]]
		elseif var == "$berserkTime" or var == "$incarnationTime" then
			if GetBerserkRemainingTime() > 0 then
				valid = true
			end
		elseif var == "$incarnationTicks" then
			if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				valid = true
			end
		elseif var == "$incarnationTickTime" then
			if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				valid = true
			end
		elseif var == "$incarnationNextCp" then
			if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				valid = true
			end
		--[[elseif var == "$apexPredatorsCravingTime" then
			if snapshots[spells.apexPredatorsCraving.id].buff.isActive then
				valid = true
			end
		elseif var == "$tigersFuryTime" then
			if snapshots[spells.tigersFury.id].buff.isActive then
				valid = true
			end
		elseif var == "$tigersFuryCooldownTime" then
			if snapshots[spells.tigersFury.id].cooldown:IsUnusable() then
				valid = true
			end]]
		elseif var == "$inStealth" then
			if IsStealthed() then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then -- Guardian
		if var == "$resource" or var == "$rage" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$rageMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$berserkTime" or var == "$incarnationTime" then
			if snapshotData.snapshots[spells.berserk.id].buff.isActive or snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 4 then --Restoration
		if var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$efflorescenceTime" then
			if snapshots[spells.efflorescence.id].buff.isActive then
				valid = true
			end
		elseif var == "$incarnationTime" then
			if snapshots[spells.incarnationTreeOfLife.id].buff.isActive  then
				valid = true
			end
		end
	else
		valid = false
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups
	if not (barGroups and barGroups.primary) then
		return nil, true
	end

	local normalizedRelativeFrame = string.gsub(relativeToFrame or "", "_", "")
	if normalizedRelativeFrame == "Resource" or normalizedRelativeFrame == "ResourceBar" then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			return primaryNode:GetResourceFrame(), true
		end
		return nil, true
	end

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local cpNode = barGroups.secondary:GetNode(comboPoint)
			if cpNode then
				return cpNode:GetResourceFrame(), true
			end
		end
	end

	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 and TRB.Data.character.specId ~= 4 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end