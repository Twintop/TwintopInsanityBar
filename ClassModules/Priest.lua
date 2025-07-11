local _, TRB = ...
if TRB.Data.character.classId ~= 5 then --Only do this if we're on a Priest!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resourceFrame = TRB.Frames.resourceFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	discipline = TRB.Classes.SpecCache:New(),
	holy = TRB.Classes.SpecCache:New(),
	shadow = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function CalculateManaGain(mana, isPotion)
	if isPotion == nil then
		isPotion = false
	end

	local modifier = 1.0

	if isPotion then
		if TRB.Data.character.items.alchemyStone then
			local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
			local spells = spellsData.spells --[[@as TRB.Classes.Healer.HealerSpells]]
			modifier = modifier * spells.alchemistStone.attributes.resourcePercent
		end
	end

	return mana * modifier
end

local function FillSpecializationCache()
	-- Discipline
	specCache.discipline.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			channeledPotion = 0,
			manaTideTotem = 0,
			innervate = 0,
			potionOfChilledClarity = 0,
			symbolOfHope = 0,
			shadowfiend = 0,
		},
		dots = {
			swpCount = 0
		},
		isPvp = false
	}

	specCache.discipline.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		effects = {
		},
		items = {
			potions = {
				algariManaPotionRank3 = {
					id = 212241,
					mana = 270000
				},
				algariManaPotionRank2 = {
					id = 212240,
					mana = 234783
				},
				algariManaPotionRank1 = {
					id = 212239,
					mana = 204159
				},
				cavedwellersDelightRank3 = {
					id = 212244,
					mana = 202500
				},
				cavedwellersDelightRank2 = {
					id = 212243,
					mana = 176087
				},
				cavedwellersDelightRank1 = {
					id = 212243,
					mana = 153119
				},
				slumberingSoulSerumRank3 = {
					id = 212247,
					mana = 375000
				},
				slumberingSoulSerumRank2 = {
					id = 212246,
					mana = 326090
				},
				slumberingSoulSerumRank1 = {
					id = 212245,
					mana = 283550
				},				
			},
			alchemyStone = false
		}
	}
	
	specCache.discipline.spellsData.spells = TRB.Classes.Priest.DisciplineSpells:New()
	---@type TRB.Classes.Priest.DisciplineSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.discipline.spellsData.spells

	specCache.discipline.snapshotData.attributes.manaRegen = 0
	specCache.discipline.snapshotData.audio = {
		innervateCue = false,
		surgeOfLightCue = false,
		surgeOfLight2Cue = false
	}
	---@type TRB.Classes.Healer.Innervate
	specCache.discipline.snapshotData.snapshots[spells.innervate.id] = TRB.Classes.Healer.Innervate:New(spells.innervate)
	---@type TRB.Classes.Healer.PotionOfChilledClarity
	specCache.discipline.snapshotData.snapshots[spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(spells.potionOfChilledClarity)
	---@type TRB.Classes.Healer.ManaTideTotem
	specCache.discipline.snapshotData.snapshots[spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(spells.manaTideTotem)
	---@type TRB.Classes.Healer.SymbolOfHope
	specCache.discipline.snapshotData.snapshots[spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(spells.symbolOfHope, CalculateManaGain)
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.discipline.snapshotData.snapshots[spells.slumberingSoulSerumRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.slumberingSoulSerumRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.algariManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.algariManaPotionRank1)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.discipline.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.discipline.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Priest.Shadowfiend
	specCache.discipline.snapshotData.snapshots[spells.shadowfiend.id] = TRB.Classes.Priest.Shadowfiend:New(TRB.Data.settings.priest.discipline.shadowfiend, specCache.discipline.talents, CalculateManaGain, spells.shadowfiend, spells.mindbender, spells.voidwraith)
	---@type TRB.Classes.Healer.Cannibalize
	specCache.discipline.snapshotData.snapshots[spells.cannibalize.id] = TRB.Classes.Healer.Cannibalize:New(spells.cannibalize)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(spells.surgeOfLight)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.powerWordRadiance.id] = TRB.Classes.Snapshot:New(spells.powerWordRadiance)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.shadowCovenant.id] = TRB.Classes.Snapshot:New(spells.shadowCovenant)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.atonement.id] = TRB.Classes.Snapshot:New(spells.atonement, {
		minRemainingTime = 0,
		maxRemainingTime = 0
	})
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.entropicRift.id] = TRB.Classes.Snapshot:New(spells.entropicRift, {
		guid = nil,
		totemId = nil
	}, false, true)

	specCache.discipline.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Holy
	specCache.holy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			channeledPotion = 0,
			manaTideTotem = 0,
			innervate = 0,
			potionOfChilledClarity = 0,
			symbolOfHope = 0,
			shadowfiend = 0,
		},
		dots = {
			swpCount = 0
		},
		isPvp = false
	}

	specCache.holy.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
		items = {
			potions = {
				algariManaPotionRank3 = {
					id = 212241,
					mana = 270000
				},
				algariManaPotionRank2 = {
					id = 212240,
					mana = 234783
				},
				algariManaPotionRank1 = {
					id = 212239,
					mana = 204159
				},
				cavedwellersDelightRank3 = {
					id = 212244,
					mana = 202500
				},
				cavedwellersDelightRank2 = {
					id = 212243,
					mana = 176087
				},
				cavedwellersDelightRank1 = {
					id = 212243,
					mana = 153119
				},
				slumberingSoulSerumRank3 = {
					id = 212247,
					mana = 375000
				},
				slumberingSoulSerumRank2 = {
					id = 212246,
					mana = 326090
				},
				slumberingSoulSerumRank1 = {
					id = 212245,
					mana = 283550
				},
			},
			alchemyStone = false
		}
	}

	---@type TRB.Classes.Priest.HolySpells
	specCache.holy.spellsData.spells = TRB.Classes.Priest.HolySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	specCache.holy.snapshotData.attributes.manaRegen = 0
	specCache.holy.snapshotData.audio = {
		innervateCue = false,
		resonantWordsCue = false,
		lightweaverCue = false,
		surgeOfLightCue = false,
		surgeOfLight2Cue = false
	}
	---@type TRB.Classes.Healer.Innervate
	specCache.holy.snapshotData.snapshots[spells.innervate.id] = TRB.Classes.Healer.Innervate:New(spells.innervate)
	---@type TRB.Classes.Healer.PotionOfChilledClarity
	specCache.holy.snapshotData.snapshots[spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(spells.potionOfChilledClarity)
	---@type TRB.Classes.Healer.ManaTideTotem
	specCache.holy.snapshotData.snapshots[spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(spells.manaTideTotem)
	---@type TRB.Classes.Priest.Shadowfiend
	specCache.holy.snapshotData.snapshots[spells.shadowfiend.id] = TRB.Classes.Priest.Shadowfiend:New(TRB.Data.settings.priest.holy.shadowfiend, specCache.holy.talents, CalculateManaGain, spells.shadowfiend, nil, nil)
	---@type TRB.Classes.Healer.Cannibalize
	specCache.holy.snapshotData.snapshots[spells.cannibalize.id] = TRB.Classes.Healer.Cannibalize:New(spells.cannibalize)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.apotheosis.id] = TRB.Classes.Snapshot:New(spells.apotheosis, nil, "sometimes")
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(spells.surgeOfLight)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.resonantWords.id] = TRB.Classes.Snapshot:New(spells.resonantWords)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.lightweaver.id] = TRB.Classes.Snapshot:New(spells.lightweaver)
	---@type TRB.Classes.Healer.SymbolOfHope
	specCache.holy.snapshotData.snapshots[spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(spells.symbolOfHope, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.holyWordSerenity.id] = TRB.Classes.Snapshot:New(spells.holyWordSerenity)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.holyWordSanctify.id] = TRB.Classes.Snapshot:New(spells.holyWordSanctify)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.holyWordChastise.id] = TRB.Classes.Snapshot:New(spells.holyWordChastise)
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.holy.snapshotData.snapshots[spells.slumberingSoulSerumRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.slumberingSoulSerumRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.algariManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.algariManaPotionRank1)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.holy.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.holy.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.sacredReverence.id] = TRB.Classes.Snapshot:New(spells.sacredReverence, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.answeredPrayers.id] = TRB.Classes.Snapshot:New(spells.answeredPrayers, nil, "always")

	-- Shadow
	specCache.shadow.Global_TwintopResourceBar = {
		voidform = {
		},
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			auspiciousSpirits = 0,
			shadowfiend = 0,
			ecttv = 0
		},
		auspiciousSpirits = {
			count = 0,
			insanity = 0
		},
		dots = {
			swpCount = 0,
			vtCount = 0,
			dpCount = 0
		},
		shadowfiend = {
			insanity = 0,
			gcds = 0,
			swings = 0,
			time = 0
		}
	}

	specCache.shadow.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		devouringPlagueThreshold = 50,
		effects = {
		},
		items = {
			twwSeason2SetBonusCount = 0
		}
	}

	---@type TRB.Classes.Priest.ShadowSpells
	specCache.shadow.spellsData.spells = TRB.Classes.Priest.ShadowSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	specCache.shadow.snapshotData.audio = {
		playedDpCue = false,
		playedMdCue = false,
		overcapCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.voidform.id] = TRB.Classes.Snapshot:New(spells.voidform, nil, "sometimes")
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.darkAscension.id] = TRB.Classes.Snapshot:New(spells.darkAscension, nil, "sometimes")
	---@type TRB.Classes.Priest.Shadowfiend
	specCache.shadow.snapshotData.snapshots[spells.shadowfiend.id] = TRB.Classes.Priest.Shadowfiend:New(TRB.Data.settings.priest.shadow.mindbender, specCache.shadow.talents, CalculateManaGain, spells.shadowfiend, spells.mindbender, spells.voidwraith)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.devouredDespair.id] = TRB.Classes.Snapshot:New(spells.devouredDespair, {
		resourceRaw = 0,
		resourceFinal = 0
	})
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.idolOfCthun.id] = TRB.Classes.Snapshot:New(spells.idolOfCthun, {
		numberActive = 0,
		resourceRaw = 0,
		resourceFinal = 0,
		maxTicksRemaining = 0,
		activeList = {}
	})
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.mindDevourer.id] = TRB.Classes.Snapshot:New(spells.mindDevourer)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.mindFlayInsanity.id] = TRB.Classes.Snapshot:New(spells.mindFlayInsanity)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.twistOfFate.id] = TRB.Classes.Snapshot:New(spells.twistOfFate)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.shatteredPsyche.id] = TRB.Classes.Snapshot:New(spells.shatteredPsyche)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.shadowyInsight.id] = TRB.Classes.Snapshot:New(spells.shadowyInsight)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.mindBlast.id] = TRB.Classes.Snapshot:New(spells.mindBlast)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.idolOfYoggSaron.id] = TRB.Classes.Snapshot:New(spells.idolOfYoggSaron)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.thingFromBeyond.id] = TRB.Classes.Snapshot:New(spells.thingFromBeyond)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.entropicRift.id] = TRB.Classes.Snapshot:New(spells.entropicRift, {
		guid = nil,
		totemId = nil
	}, false, true)
end

local function Setup_Discipline()
	TRB.Functions.Character:FillSpecializationCacheSettings("priest", "discipline", true)
end

local function FillSpellData_Discipline()
	Setup_Discipline()
	---@type TRB.Classes.SpellsData
	specCache.discipline.spellsData:FillSpellData()
	local spells = specCache.discipline.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.discipline.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#atonement", icon = spells.atonement.icon, description = spells.atonement.name, printInSettings = true },
		{ variable = "#entropicRift", icon = spells.entropicRift.icon, description = spells.entropicRift.name, printInSettings = true },
		{ variable = "#pwRadiance", icon = spells.powerWordRadiance.icon, description = spells.powerWordRadiance.name, printInSettings = true },
		{ variable = "#powerWordRadiance", icon = spells.powerWordRadiance.icon, description = spells.powerWordRadiance.name, printInSettings = false },
		{ variable = "#sc", icon = spells.shadowCovenant.icon, description = spells.shadowCovenant.name, printInSettings = true },
		{ variable = "#shadowCovenant", icon = spells.shadowCovenant.icon, description = spells.shadowCovenant.name, printInSettings = false },
		{ variable = "#sf", icon = string.format(L["PriestShadowIcon_sf"], spells.shadowfiend.icon, spells.mindbender.icon, spells.voidwraith.icon), description = spells.shadowfiend.name .. " / " .. spells.mindbender.name .. " / " .. spells.voidwraith.name, printInSettings = true },
		{ variable = "#mindbender", icon = spells.mindbender.icon, description = spells.mindbender.name, printInSettings = false },
		{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = spells.shadowfiend.name, printInSettings = false },
		{ variable = "#voidwraith", icon = spells.voidwraith.icon, description = spells.voidwraith.name, printInSettings = false },
		{ variable = "#sol", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = true },
		{ variable = "#surgeOfLight", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = false },
		{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
		{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },

		{ variable = "#swp", icon = spells.entropicRift.icon, description = spells.entropicRift.name, printInSettings = true },

		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },
		
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

		{ variable = "#amp", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = true },
		{ variable = "#algariManaPotion", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = true },
		{ variable = "#slumberingSoulSerum", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = true },
	}
	specCache.discipline.barTextVariables.values = {
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

		{ variable = "$mana", description = L["PriestDisciplineBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PriestDisciplineBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PriestDisciplineBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PriestDisciplineBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["PriestDisciplineBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["PriestDisciplineBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["PriestDisciplineBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["PriestDisciplineBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$atonementCount", description = L["PriestDisciplineBarTextVariable_atonementCount"], printInSettings = true, color = false },
		{ variable = "$atonementTime", description = L["PriestDisciplineBarTextVariable_atonementTime"], printInSettings = true, color = false },
		{ variable = "$atonementMinTime", description = L["PriestDisciplineBarTextVariable_atonementMinTime"], printInSettings = true, color = false },
		{ variable = "$atonementMaxTime", description = L["PriestDisciplineBarTextVariable_atonementMaxTime"], printInSettings = true, color = false },

		{ variable = "$solStacks", description = L["PriestDisciplineBarTextVariable_solStacks"], printInSettings = true, color = false },
		{ variable = "$solTime", description = L["PriestDisciplineBarTextVariable_solTime"], printInSettings = true, color = false },
				
		{ variable = "$scTime", description = L["PriestDisciplineBarTextVariable_scTime"], printInSettings = true, color = false },
		{ variable = "$shadowCovenantTime", description = "", printInSettings = false, color = false },

		{ variable = "$pwRadianceTime", description = L["PriestDisciplineBarTextVariable_pwRadianceTime"], printInSettings = true, color = false },
		{ variable = "$radianceTime", description = "", printInSettings = false, color = false },
		{ variable = "$powerWordRadianceTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$pwRadianceCharges", description = L["PriestDisciplineBarTextVariable_pwRadianceCharges"], printInSettings = true, color = false },
		{ variable = "$radianceCharges", description = "", printInSettings = false, color = false },
		{ variable = "$powerWordRadianceCharges", description = "", printInSettings = false, color = false },
		
		{ variable = "$bowMana", description = L["PriestDisciplineBarTextVariable_bowMana"], printInSettings = true, color = false },
		{ variable = "$bowTime", description = L["PriestDisciplineBarTextVariable_bowTime"], printInSettings = true, color = false },
		{ variable = "$bowTicks", description = L["PriestDisciplineBarTextVariable_bowTicks"], printInSettings = true, color = false },
		
		{ variable = "$sohMana", description = L["PriestDisciplineBarTextVariable_sohMana"], printInSettings = true, color = false },
		{ variable = "$sohTime", description = L["PriestDisciplineBarTextVariable_sohTime"], printInSettings = true, color = false },
		{ variable = "$sohTicks", description = L["PriestDisciplineBarTextVariable_sohTicks"], printInSettings = true, color = false },

		{ variable = "$innervateMana", description = L["PriestDisciplineBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["PriestDisciplineBarTextVariable_innervateTime"], printInSettings = true, color = false },
		
		{ variable = "$mttMana", description = L["PriestDisciplineBarTextVariable_mttMana"], printInSettings = true, color = false },
		{ variable = "$mttTime", description = L["PriestDisciplineBarTextVariable_mttTime"], printInSettings = true, color = false },
					
		{ variable = "$mrMana", description = L["PriestDisciplineBarTextVariable_mrMana"], printInSettings = true, color = false },
		{ variable = "$mrTime", description = L["PriestDisciplineBarTextVariable_mrTime"], printInSettings = true, color = false },

		{ variable = "$channeledMana", description = L["PriestDisciplineBarTextVariable_channeledMana"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTicks", description = L["PriestDisciplineBarTextVariable_slumberingSoulSerumTicks"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTime", description = L["PriestDisciplineBarTextVariable_slumberingSoulSerumTime"], printInSettings = true, color = false },
		
		{ variable = "$potionOfChilledClarityMana", description = L["PriestDisciplineBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
		{ variable = "$potionOfChilledClarityTime", description = L["PriestDisciplineBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

		{ variable = "$potionCooldown", description = L["PriestDisciplineBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["PriestDisciplineBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$swpCount", description = L["PriestDisciplineBarTextVariable_swpCount"], printInSettings = true, color = false },
		{ variable = "$swpTime", description = L["PriestDisciplineBarTextVariable_swpTime"], printInSettings = true, color = false },
		
		{ variable = "$sfMana", description = L["PriestDisciplineBarTextVariable_sfMana"], printInSettings = true, color = false },
		{ variable = "$sfGcds", description = L["PriestDisciplineBarTextVariable_sfGcds"], printInSettings = true, color = false },
		{ variable = "$sfSwings", description = L["PriestDisciplineBarTextVariable_sfSwings"], printInSettings = true, color = false },
		{ variable = "$sfTime", description = L["PriestDisciplineBarTextVariable_sfTime"], printInSettings = true, color = false },
		{ variable = "$sfCount", description = L["PriestDisciplineBarTextVariable_sfCount"], printInSettings = true, color = false },
		
		{ variable = "$entropicRiftTime", description = L["PriestDisciplineBarTextVariable_entropicRiftTime"], printInSettings = true },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function Setup_Holy()
	TRB.Functions.Character:FillSpecializationCacheSettings("priest", "holy", true)
end

local function FillSpellData_Holy()
	Setup_Holy()
	specCache.holy.spellsData:FillSpellData()
	local spells = specCache.holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.holy.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#answeredPrayers", icon = spells.answeredPrayers.icon, description = spells.answeredPrayers.name, printInSettings = true },			
		{ variable = "#apotheosis", icon = spells.apotheosis.icon, description = spells.apotheosis.name, printInSettings = true },			
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },
		{ variable = "#flashHeal", icon = spells.flashHeal.icon, description = spells.flashHeal.name, printInSettings = true },
		{ variable = "#heal", icon = spells.heal.icon, description = spells.heal.name, printInSettings = true },
		{ variable = "#hf", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = true },
		{ variable = "#holyFire", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = false },
		{ variable = "#hwChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = true },
		{ variable = "#chastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
		{ variable = "#holyWordChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
		{ variable = "#hwSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = true },
		{ variable = "#sanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
		{ variable = "#holyWordSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
		{ variable = "#hwSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = true },
		{ variable = "#serenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
		{ variable = "#holyWordSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
		{ variable = "#lightweaver", icon = spells.lightweaver.icon, description = spells.lightweaver.name, printInSettings = true },
		{ variable = "#rw", icon = spells.resonantWords.icon, description = spells.resonantWords.name, printInSettings = true },
		{ variable = "#resonantWords", icon = spells.resonantWords.icon, description = spells.resonantWords.name, printInSettings = false },
		{ variable = "#innervate", icon = spells.innervate.icon, description = spells.innervate.name, printInSettings = true },
		{ variable = "#lotn", icon = spells.lightOfTheNaaru.icon, description = spells.lightOfTheNaaru.name, printInSettings = true },
		{ variable = "#lightOfTheNaaru", icon = spells.lightOfTheNaaru.icon, description = spells.lightOfTheNaaru.name, printInSettings = false },
		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },
		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },
		{ variable = "#poh", icon = spells.prayerOfHealing.icon, description = spells.prayerOfHealing.name, printInSettings = true },
		{ variable = "#prayerOfHealing", icon = spells.prayerOfHealing.icon, description = spells.prayerOfHealing.name, printInSettings = false },
		{ variable = "#sacredReverence", icon = spells.sacredReverence.icon, description = spells.sacredReverence.name, printInSettings = true },
		{ variable = "#smite", icon = spells.smite.icon, description = spells.smite.name, printInSettings = true },
		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },
		{ variable = "#sol", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = true },
		{ variable = "#surgeOfLight", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = false },

		{ variable = "#amp", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = true },
		{ variable = "#algariManaPotion", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = true },
		{ variable = "#slumberingSoulSerum", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = false },

		{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
		{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },
		
		{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = spells.shadowfiend.name, printInSettings = false },
		{ variable = "#sf", icon = spells.shadowfiend.icon, description = spells.shadowfiend.name, printInSettings = true },
	}
	specCache.holy.barTextVariables.values = {
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

		{ variable = "$mana", description = L["PriestHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PriestHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PriestHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PriestHolyBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["PriestHolyBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["PriestHolyBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["PriestHolyBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["PriestHolyBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwChastiseTime", description = L["PriestHolyBarTextVariable_hwChastiseTime"], printInSettings = true, color = false },
		{ variable = "$chastiseTime", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordChastiseTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSanctifyTime", description = L["PriestHolyBarTextVariable_hwSanctifyTime"], printInSettings = true, color = false },
		{ variable = "$sanctifyTime", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSanctifyTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSanctifyCharges", description = L["PriestHolyBarTextVariable_hwSanctifyCharges"], printInSettings = true, color = false },
		{ variable = "$sanctifyCharges", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSanctifyCharges", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSerenityTime", description = L["PriestHolyBarTextVariable_hwSerenityTime"], printInSettings = true, color = false },
		{ variable = "$serenityTime", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSerenityTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSerenityCharges", description = L["PriestHolyBarTextVariable_hwSerenityCharges"], printInSettings = true, color = false },
		{ variable = "$serenityCharges", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSerenityCharges", description = "", printInSettings = false, color = false },
		
		{ variable = "$sacredReverenceStacks", description = L["PriestHolyBarTextVariable_sacredReverenceStacks"], printInSettings = true, color = false },

		{ variable = "$apotheosisTime", description = L["PriestHolyBarTextVariable_apotheosisTime"], printInSettings = true, color = false },
		
		{ variable = "$answeredPrayersStacks", description = L["PriestHolyBarTextVariable_answeredPrayersStacks"], printInSettings = true, color = false },
		{ variable = "$answeredPrayersMaxStacks", description = L["PriestHolyBarTextVariable_answeredPrayersMaxStacks"], printInSettings = true, color = false },
		{ variable = "$answeredPrayersRemainingStacks", description = L["PriestHolyBarTextVariable_answeredPrayersRemainingStacks"], printInSettings = true, color = false },

		{ variable = "$solStacks", description = L["PriestHolyBarTextVariable_solStacks"], printInSettings = true, color = false },
		{ variable = "$solTime", description = L["PriestHolyBarTextVariable_solTime"], printInSettings = true, color = false },
		
		{ variable = "$lightweaverStacks", description = L["PriestHolyBarTextVariable_lightweaverStacks"], printInSettings = true, color = false },
		{ variable = "$lightweaverTime", description = L["PriestHolyBarTextVariable_lightweaverTime"], printInSettings = true, color = false },

		{ variable = "$rwTime", description = L["PriestHolyBarTextVariable_rwTime"], printInSettings = true, color = false },
		
		{ variable = "$bowMana", description = L["PriestHolyBarTextVariable_bowMana"], printInSettings = true, color = false },
		{ variable = "$bowTime", description = L["PriestHolyBarTextVariable_bowTime"], printInSettings = true, color = false },
		{ variable = "$bowTicks", description = L["PriestHolyBarTextVariable_bowTicks"], printInSettings = true, color = false },

		{ variable = "$sohMana", description = L["PriestHolyBarTextVariable_sohMana"], printInSettings = true, color = false },
		{ variable = "$sohTime", description = L["PriestHolyBarTextVariable_sohTime"], printInSettings = true, color = false },
		{ variable = "$sohTicks", description = L["PriestHolyBarTextVariable_sohTicks"], printInSettings = true, color = false },

		{ variable = "$innervateMana", description = L["PriestHolyBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["PriestHolyBarTextVariable_innervateTime"], printInSettings = true, color = false },

		{ variable = "$potionOfChilledClarityMana", description = L["PriestHolyBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
		{ variable = "$potionOfChilledClarityTime", description = L["PriestHolyBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },
								
		{ variable = "$mrMana", description = L["PriestHolyBarTextVariable_mrMana"], printInSettings = true, color = false },
		{ variable = "$mrTime", description = L["PriestHolyBarTextVariable_mrTime"], printInSettings = true, color = false },

		{ variable = "$mttMana", description = L["PriestHolyBarTextVariable_mttMana"], printInSettings = true, color = false },
		{ variable = "$mttTime", description = L["PriestHolyBarTextVariable_mttTime"], printInSettings = true, color = false },

		{ variable = "$channeledMana", description = L["PriestHolyBarTextVariable_channeledMana"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTicks", description = L["PriestHolyBarTextVariable_slumberingSoulSerumTicks"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTime", description = L["PriestHolyBarTextVariable_slumberingSoulSerumTime"], printInSettings = true, color = false },
		
		{ variable = "$potionCooldown", description = L["PriestHolyBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["PriestHolyBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$swpCount", description = L["PriestHolyBarTextVariable_swpCount"], printInSettings = true, color = false },
		{ variable = "$swpTime", description = L["PriestHolyBarTextVariable_swpTime"], printInSettings = true, color = false },
		
		{ variable = "$sfMana", description = L["PriestHolyBarTextVariable_sfMana"], printInSettings = true, color = false },
		{ variable = "$sfGcds", description = L["PriestHolyBarTextVariable_sfGcds"], printInSettings = true, color = false },
		{ variable = "$sfSwings", description = L["PriestHolyBarTextVariable_sfSwings"], printInSettings = true, color = false },
		{ variable = "$sfTime", description = L["PriestHolyBarTextVariable_sfTime"], printInSettings = true, color = false },
		{ variable = "$sfCount", description = L["PriestHolyBarTextVariable_sfCount"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function Setup_Shadow()
	TRB.Functions.Character:FillSpecializationCacheSettings("priest", "shadow")
end

local function FillSpellData_Shadow()
	Setup_Shadow()
	specCache.shadow.spellsData:FillSpellData()
	local spells = specCache.shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.shadow.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#as", icon = spells.auspiciousSpirits.icon, description = spells.auspiciousSpirits.name, printInSettings = true },
		{ variable = "#auspiciousSpirits", icon = spells.auspiciousSpirits.icon, description = spells.auspiciousSpirits.name, printInSettings = false },
		
		{ variable = "#cthun", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = true },
		{ variable = "#idolOfCthun", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = false },
		{ variable = "#loi", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = false },

		{ variable = "#dp", icon = spells.devouringPlague.icon, description = spells.devouringPlague.name, printInSettings = true },
		{ variable = "#devouringPlague", icon = spells.devouringPlague.icon, description = spells.devouringPlague.name, printInSettings = false },

		{ variable = "#entropicRift", icon = spells.entropicRift.icon, description = spells.entropicRift.name, printInSettings = true },

		{ variable = "#halo", icon = spells.halo.icon, description = spells.halo.name, printInSettings = true },

		{ variable = "#mDev", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = true },
		{ variable = "#mindDevourer", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = false },

		{ variable = "#mindgames", icon = spells.mindgames.icon, description = spells.mindgames.name, printInSettings = true },

		{ variable = "#mb", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = true },
		{ variable = "#mindBlast", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = false },
		
		{ variable = "#md", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = true },
		{ variable = "#massDispel", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = false },
		
		{ variable = "#mfi", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = true },
		{ variable = "#mindFlayInsanity", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = false },

		{ variable = "#mf", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = true },
		{ variable = "#mindFlay", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = false },
																
		{ variable = "#sa", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = true },
		{ variable = "#shadowyApparition", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = false },
																																																				
		{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
		{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },

		{ variable = "#sf", icon = string.format(L["PriestShadowIcon_sf"], spells.shadowfiend.icon, spells.mindbender.icon, spells.voidwraith.icon), description = spells.shadowfiend.name .. " / " .. spells.mindbender.name .. " / " .. spells.voidwraith.name, printInSettings = true },
		{ variable = "#mindbender", icon = spells.mindbender.icon, description = spells.mindbender.name, printInSettings = false },
		{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = spells.shadowfiend.name, printInSettings = false },
		{ variable = "#voidwraith", icon = spells.voidwraith.icon, description = spells.voidwraith.name, printInSettings = false },
																						
		{ variable = "#si", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = true },
		{ variable = "#shadowyInsight", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = false },
		
		{ variable = "#sp", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = true },
		{ variable = "#shatteredPsyche", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = false },
		{ variable = "#mm", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = false },
		{ variable = "#mindMelt", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = false },
		
		{ variable = "#tfb", icon = spells.thingFromBeyond.icon, description = spells.thingFromBeyond.name, printInSettings = true },
		{ variable = "#thingFromBeyond", icon = spells.thingFromBeyond.icon, description = spells.thingFromBeyond.name, printInSettings = false },
		
		{ variable = "#tof", icon = spells.twistOfFate.icon, description = spells.twistOfFate.name, printInSettings = true },
		{ variable = "#twistOfFate", icon = spells.twistOfFate.icon, description = spells.twistOfFate.name, printInSettings = false },

		{ variable = "#vb", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = true },
		{ variable = "#voidBolt", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = false },
		{ variable = "#vf", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = true },
		{ variable = "#voidform", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = false },
																															
		{ variable = "#voit", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = true },
		{ variable = "#voidTorrent", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = false },

		{ variable = "#vt", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = true },
		{ variable = "#vampiricTouch", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = false },
		
		{ variable = "#ys", icon = spells.idolOfYoggSaron.icon, description = spells.idolOfYoggSaron.name, printInSettings = true },
		{ variable = "#idolOfYoggSaron", icon = spells.idolOfYoggSaron.icon, description = spells.idolOfYoggSaron.name, printInSettings = false },
	}
	specCache.shadow.barTextVariables.values = {
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

		{ variable = "$insanity", description = L["PriestShadowBarTextVariable_insanity"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$insanityMax", description = L["PriestShadowBarTextVariable_insanityMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PriestShadowBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["PriestShadowBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$insanityPlusCasting", description = L["PriestShadowBarTextVariable_insanityPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$insanityPlusPassive", description = L["PriestShadowBarTextVariable_insanityPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$insanityTotal", description = L["PriestShadowBarTextVariable_insanityTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		{ variable = "$overcap", description = "Will hardcast spell will overcap Insanity? Logic variable only!", printInSettings = true, color = false },
		{ variable = "$insanityOvercap", description = "", printInSettings = false, color = false },
		{ variable = "$resourceOvercap", description = "", printInSettings = false, color = false },

		{ variable = "$sfInsanity", description = L["PriestShadowBarTextVariable_mbInsanity"], printInSettings = true, color = false },
		{ variable = "$mbInsanity", description = L["PriestShadowBarTextVariable_mbInsanity"], printInSettings = false, color = false },
		{ variable = "$sfGcds", description = L["PriestShadowBarTextVariable_mbGcds"], printInSettings = true, color = false },
		{ variable = "$mbGcds", description = L["PriestShadowBarTextVariable_mbGcds"], printInSettings = false, color = false },
		{ variable = "$sfSwings", description = L["PriestShadowBarTextVariable_mbSwings"], printInSettings = true, color = false },
		{ variable = "$mbSwings", description = L["PriestShadowBarTextVariable_mbSwings"], printInSettings = false, color = false },
		{ variable = "$sfTime", description = L["PriestShadowBarTextVariable_mbTime"], printInSettings = true, color = false },
		{ variable = "$mbTime", description = L["PriestShadowBarTextVariable_mbTime"], printInSettings = false, color = false },
		{ variable = "$sfCount", description = L["PriestShadowBarTextVariable_sfCount"], printInSettings = true, color = false },
		{ variable = "$mbCount", description = L["PriestShadowBarTextVariable_sfCount"], printInSettings = false, color = false },

		{ variable = "$cttvEquipped", description = L["PriestShadowBarTextVariable_cttvEquipped"], printInSettings = true, color = false },
		{ variable = "$ecttvCount", description = L["PriestShadowBarTextVariable_ecttvCount"], printInSettings = true, color = false },
		{ variable = "$loiInsanity", description = L["PriestShadowBarTextVariable_loiInsanity"], printInSettings = true, color = false },
		{ variable = "$loiTicks", description = L["PriestShadowBarTextVariable_loiTicks"], printInSettings = true, color = false },

		{ variable = "$asInsanity", description = L["PriestShadowBarTextVariable_asInsanity"], printInSettings = true, color = false },
		{ variable = "$asCount", description = L["PriestShadowBarTextVariable_asCount"], printInSettings = true, color = false },

		{ variable = "$swpCount", description = L["PriestShadowBarTextVariable_swpCount"], printInSettings = true, color = false },
		{ variable = "$swpTime", description = L["PriestShadowBarTextVariable_swpTime"], printInSettings = true, color = false },
		{ variable = "$vtCount", description = L["PriestShadowBarTextVariable_vtCount"], printInSettings = true, color = false },
		{ variable = "$vtTime", description = L["PriestShadowBarTextVariable_vtTime"], printInSettings = true, color = false },
		{ variable = "$dpCount", description = L["PriestShadowBarTextVariable_dpCount"], printInSettings = true, color = false },
		{ variable = "$dpTime", description = L["PriestShadowBarTextVariable_dpTime"], printInSettings = true, color = false },

		{ variable = "$tofTime", description = L["PriestShadowBarTextVariable_tofTime"], printInSettings = true, color = false },

		{ variable = "$mdTime", description = L["PriestShadowBarTextVariable_mdTime"], printInSettings = true, color = false },

		{ variable = "$mfiTime", description = L["PriestShadowBarTextVariable_mfiTime"], printInSettings = true, color = false },
		{ variable = "$mfiStacks", description = L["PriestShadowBarTextVariable_mfiStacks"], printInSettings = true, color = false },
		
		{ variable = "$siTime", description = L["PriestShadowBarTextVariable_siTime"], printInSettings = true, color = false },
		
		{ variable = "$mindBlastCharges", description = L["PriestShadowBarTextVariable_mindBlastCharges"], printInSettings = true, color = false },
		{ variable = "$mindBlastMaxCharges", description = L["PriestShadowBarTextVariable_mindBlastMaxCharges"], printInSettings = true, color = false },

		{ variable = "$spTime", description = L["PriestShadowBarTextVariable_spTime"], printInSettings = true, color = false },
		{ variable = "$mmTime", description = L["PriestShadowBarTextVariable_spTime"], printInSettings = false, color = false },
		{ variable = "$spStacks", description = L["PriestShadowBarTextVariable_spStacks"], printInSettings = true, color = false },
		{ variable = "$mmStacks", description = L["PriestShadowBarTextVariable_spStacks"], printInSettings = false, color = false },

		{ variable = "$vfTime", description = L["PriestShadowBarTextVariable_vfTime"], printInSettings = true, color = false },

		{ variable = "$ysTime", description = L["PriestShadowBarTextVariable_ysTime"], printInSettings = true, color = false },
		{ variable = "$ysStacks", description = L["PriestShadowBarTextVariable_ysStacks"], printInSettings = true, color = false },
		{ variable = "$ysRemainingStacks", description = L["PriestShadowBarTextVariable_ysRemainingStacks"], printInSettings = true, color = false },
		{ variable = "$tfbTime", description = L["PriestShadowBarTextVariable_tfbTime"], printInSettings = true, color = false },

		{ variable = "$reTime", description = L["PriestShadowBarTextVariable_reTime"], printInSettings = true, color = false },
		{ variable = "$reStacks", description = L["PriestShadowBarTextVariable_reStacks"], printInSettings = true, color = false },

		{ variable = "$entropicRiftTime", description = L["PriestShadowBarTextVariable_entropicRiftTime"], printInSettings = true },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function CheckVoidTendrilExists(guid)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local idolOfCthun = snapshotData.snapshots[spells.idolOfCthun.id]
	if guid == nil or (not idolOfCthun.attributes.activeList[guid] or idolOfCthun.attributes.activeList[guid] == nil) then
		return false
	end
	return true
end

local function InitializeVoidTendril(guid)
	if guid ~= nil and not CheckVoidTendrilExists(guid) then
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local idolOfCthun = snapshotData.snapshots[spells.idolOfCthun.id]
		idolOfCthun.attributes.activeList[guid] = {}
		idolOfCthun.attributes.activeList[guid].startTime = nil
		idolOfCthun.attributes.activeList[guid].tickTime = nil
		idolOfCthun.attributes.activeList[guid].type = nil
		idolOfCthun.attributes.activeList[guid].targetsHit = 0
		idolOfCthun.attributes.activeList[guid].hasStruckTargets = false
	end
end

local function RemoveVoidTendril(guid)
	if guid ~= nil and CheckVoidTendrilExists(guid) then
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local idolOfCthun = snapshotData.snapshots[spells.idolOfCthun.id]
		idolOfCthun.attributes.activeList[guid] = nil
	end
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 then -- Discipline
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Holy
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Shadow
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		targetData:UpdateTrackedSpells(currentTime)

		targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] or 0

		if targetData.count[spells.auspiciousSpirits.id] < 0 then
			targetData.count[spells.auspiciousSpirits.id] = 0
			targetData.custom.auspiciousSpiritsGenerate = 0
		else
			targetData.custom.auspiciousSpiritsGenerate = spells.auspiciousSpirits.attributes.targetChance(targetData.count[spells.auspiciousSpirits.id]) * targetData.count[spells.auspiciousSpirits.id]
		end
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
	if clearAll == true then
		if TRB.Data.character.specId == 1 then
		elseif TRB.Data.character.specId == 2 then
		elseif TRB.Data.character.specId == 3 then
			targetData.custom.auspiciousSpiritsGenerate = 0
		end
	end
end

local function ConstructResourceBar(settings)
	for _, v in pairs(resourceFrame.thresholds) do
		v:Hide();
	end

	for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
		if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
			TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
		end
		TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
	end
	
	for _, v in pairs(passiveFrame.thresholds) do
		v:Hide();
	end

	if TRB.Data.character.specId == 1 then
		for x = 1, 8 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.passiveFrame.thresholds[x], settings, false)
		end
		TRB.Frames.resource2ContainerFrame:Show()
	elseif TRB.Data.character.specId == 2 then
		for x = 1, 8 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.passiveFrame.thresholds[x], settings, false)
		end
		TRB.Frames.resource2ContainerFrame:Show()
	elseif TRB.Data.character.specId == 3 then
		for x = 1, 1 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.passiveFrame.thresholds[x], settings, false)
		end
		TRB.Frames.resource2ContainerFrame:Hide()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
end

local function CalculateHolyWordCooldown(base, spellId)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local mod = 1

	if snapshots[spells.apotheosis.id].buff.isActive then
		mod = mod * spells.apotheosis--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier
	end

	if talents:IsTalentActive(spells.lightOfTheNaaru) then
		mod = mod * (1 + (spells.lightOfTheNaaru--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier * talents.talents[spells.lightOfTheNaaru.id].currentRank))
	end

	return mod * (base)
end

local function CalculateResourceGain(resource)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshLookupData_Discipline()
	local specSettings = TRB.Data.settings.priest.discipline
	local sharedSettings = TRB.Data.specCache["discipline"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	--$sohMana
	local _sohMana = symbolOfHope.buff.mana
	local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
	--$sohTicks
	local _sohTicks = symbolOfHope.buff.ticks or 0
	local sohTicks = string.format("%.0f", _sohTicks)
	--$sohTime
	local _sohTime = symbolOfHope.buff:GetRemainingTime(currentTime)
	local sohTime = TRB.Functions.BarText:TimerPrecision(_sohTime)

	local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	--$innervateMana
	local _innervateMana = innervate.mana
	local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
	--$innervateTime
	local _innervateTime = innervate.buff:GetRemainingTime(currentTime)
	local innervateTime = TRB.Functions.BarText:TimerPrecision(_innervateTime)

	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	--$potionOfChilledClarityMana
	local _potionOfChilledClarityMana = potionOfChilledClarity.mana
	local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
	--$potionOfChilledClarityTime
	local _potionOfChilledClarityTime = potionOfChilledClarity.buff:GetRemainingTime(currentTime)
	local potionOfChilledClarityTime = TRB.Functions.BarText:TimerPrecision(_potionOfChilledClarityTime)
	
	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	--$mttMana
	local _mttMana = manaTideTotem.mana
	local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
	--$mttTime
	local _mttTime = manaTideTotem.buff:GetRemainingTime(currentTime)
	local mttTime = TRB.Functions.BarText:TimerPrecision(_mttTime)
	
	local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
	--$mrMana
	local _mrMana = moltenRadiance.mana
	local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
	--$mrTime
	local _mrTime = moltenRadiance.buff.remaining
	local mrTime = TRB.Functions.BarText:TimerPrecision(_mrTime)
	
	local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
	--$bowMana
	local _bowMana = blessingOfWinter.mana
	local bowMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_bowMana, manaPrecision, "floor", true))
	--$bowTime
	local _bowTime = blessingOfWinter.buff.remaining
	local bowTime = TRB.Functions.BarText:TimerPrecision(_bowTime)
	--$bowTicks
	local _bowTicks = blessingOfWinter.buff.ticks or 0
	local bowTicks = string.format("%.0f", _bowTicks)

	--$potionCooldownSeconds
	local _potionCooldown = snapshots[spells.algariManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--$channeledMana
	local _channeledMana = channeledManaPotion.mana
	local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
	--$slumberingSoulSerumTicks
	local _slumberingSoulSerumTicks = channeledManaPotion.ticks or 0
	local slumberingSoulSerumTicks = string.format("%.0f", _slumberingSoulSerumTicks)
	--$slumberingSoulSerumTime
	local _slumberingSoulSerumTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
	local slumberingSoulSerumTime = TRB.Functions.BarText:TimerPrecision(_slumberingSoulSerumTime)

	local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
	
	--$sfMana
	local _sfMana = shadowfiend.resourceFinal or 0
	local sfMana = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
	--$sfGcds
	local _sfGcds = shadowfiend.remainingGcds
	local sfGcds = string.format("%.0f", _sfGcds)
	--$sfSwings
	local _sfSwings = shadowfiend.remainingSwings
	local sfSwings = string.format("%.0f", _sfSwings)
	--$sfTime
	local _sfTime = shadowfiend.remainingTime
	local sfTime = TRB.Functions.BarText:TimerPrecision(_sfTime)

	--$passive
	local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana + _bowMana
	local passiveMana = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
	--$manaTotal
	local _manaTotal = math.min(_passiveMana + snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
	--$manaPlusCasting
	local _manaPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
	--$manaPlusPassive
	local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))
	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end
	local _manaPercent = (normalizedMana/maxResource)
	local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.Number:RoundTo(_manaPercent*100, manaPrecision, "floor"))

	--$solStacks
	local _solStacks = snapshots[spells.surgeOfLight.id].buff.applications or 0
	local solStacks = string.format("%.0f", _solStacks)
	--$solTime
	local _solTime = snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime) or 0
	local solTime = TRB.Functions.BarText:TimerPrecision(_solTime)

	--$scTime
	local _scTime = snapshots[spells.shadowCovenant.id].buff:GetRemainingTime(currentTime)
	local scTime = TRB.Functions.BarText:TimerPrecision(_scTime)

	--$pwRadianceTime
	local _pwRadianceTime = snapshots[spells.powerWordRadiance.id].cooldown.remaining
	local pwRadianceTime = TRB.Functions.BarText:TimerPrecision(_pwRadianceTime)
	
	--$pwRadianceCharges
	local _pwRadianceCharges = snapshots[spells.powerWordRadiance.id].cooldown.charges
	local pwRadianceCharges = string.format("%.0f", _pwRadianceCharges)
	
	--$atonementMinTime
	local _atonementMinTime = snapshots[spells.atonement.id].attributes.minRemainingTime
	local atonementMinTime = TRB.Functions.BarText:TimerPrecision(_atonementMinTime)
	
	--$atonementMaxTime
	local _atonementMaxTime = snapshots[spells.atonement.id].attributes.maxRemainingTime
	local atonementMaxTime = TRB.Functions.BarText:TimerPrecision(_atonementMaxTime)

	
	--$atonementTime
	local _atonementTime = 0

	if target ~= nil then
		_atonementTime = target.spells[spells.atonement.id].remainingTime or 0
	end
	local atonementTime = TRB.Functions.BarText:TimerPrecision(_atonementTime)

	--$atonementCount
	local _atonementCount = snapshotData.targetData.count[spells.atonement.id] or 0
	local atonementCount = string.format("%s", _atonementCount)

	-----------
	--$swpCount and $swpTime		
	local _shadowWordPainCount = snapshotData.targetData.count[spells.shadowWordPain.id] or 0
	local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
	local _shadowWordPainTime = 0
	
	if target ~= nil then
		_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
	end

	local shadowWordPainTime

	if sharedSettings.colors.text.dots.options.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.shadowWordPain.id].active then
			if _shadowWordPainTime > spells.shadowWordPain.pandemicTime then
				shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			end
		else
			shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _shadowWordPainCount)
			shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		shadowWordPainTime = TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime)
	end

	--$entropicRiftTime
	local _entropicRiftTime = snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
	local entropicRiftTime = TRB.Functions.BarText:TimerPrecision(_entropicRiftTime)

	Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.channeledPotion = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
	Global_TwintopResourceBar.resource.potionOfChilledClarity = _potionOfChilledClarityMana or 0
	Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
	Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
	
	Global_TwintopResourceBar.potionOfSpiritualClarity = Global_TwintopResourceBar.potionOfSpiritualClarity or {}
	Global_TwintopResourceBar.potionOfSpiritualClarity.mana = _channeledMana
	Global_TwintopResourceBar.potionOfSpiritualClarity.ticks = _slumberingSoulSerumTicks or 0
	
	Global_TwintopResourceBar.symbolOfHope = Global_TwintopResourceBar.symbolOfHope or {}
	Global_TwintopResourceBar.symbolOfHope.mana = _sohMana
	Global_TwintopResourceBar.symbolOfHope.ticks = _sohTicks or 0

	Global_TwintopResourceBar.shadowfiend = Global_TwintopResourceBar.shadowfiend or {}
	Global_TwintopResourceBar.shadowfiend.mana = shadowfiend.resourceFinal or 0
	Global_TwintopResourceBar.shadowfiend.gcds = shadowfiend.remainingGcds or 0
	Global_TwintopResourceBar.shadowfiend.swings = shadowfiend.remainingSwings or 0
	Global_TwintopResourceBar.shadowfiend.time = shadowfiend.remainingTime or 0
	Global_TwintopResourceBar.shadowfiend.count = shadowfiend:TotalActive()

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.swpCount = _shadowWordPainCount or 0

	Global_TwintopResourceBar.atonement = Global_TwintopResourceBar.atonement or {}
	Global_TwintopResourceBar.atonement.count = _atonementCount
	Global_TwintopResourceBar.atonement.targetTime = _atonementTime
	Global_TwintopResourceBar.atonement.minTime = _atonementMinTime
	Global_TwintopResourceBar.atonement.maxTime = _atonementMaxTime

	local lookup = TRB.Data.lookup

	lookup["$manaTotal"] = manaTotal
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourcePlusCasting"] = manaPlusCasting
	lookup["$manaPlusCasting"] = manaPlusCasting
	lookup["$resourcePlusPassive"] = manaPlusPassive
	lookup["$manaPlusPassive"] = manaPlusPassive
	lookup["$resourceTotal"] = manaTotal
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$resource"] = currentMana
	lookup["$casting"] = castingMana
	lookup["$passive"] = passiveMana
	lookup["$solStacks"] = solStacks
	lookup["$solTime"] = solTime
	lookup["$sohMana"] = sohMana
	lookup["$sohTime"] = sohTime
	lookup["$sohTicks"] = sohTicks
	lookup["$innervateMana"] = innervateMana
	lookup["$innervateTime"] = innervateTime
	lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
	lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
	lookup["$mrMana"] = mrMana
	lookup["$mrTime"] = mrTime
	lookup["$mttMana"] = mttMana
	lookup["$mttTime"] = mttTime
	lookup["$bowMana"] = bowMana
	lookup["$bowTime"] = bowTime
	lookup["$bowTicks"] = bowTicks
	lookup["$channeledMana"] = channeledMana
	lookup["$slumberingSoulSerumTicks"] = slumberingSoulSerumTicks
	lookup["$slumberingSoulSerumTime"] = slumberingSoulSerumTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$sfMana"] = sfMana
	lookup["$sfGcds"] = sfGcds
	lookup["$sfSwings"] = sfSwings
	lookup["$sfTime"] = sfTime
	lookup["$sfCount"] = shadowfiend:TotalActive()
	lookup["$swpCount"] = shadowWordPainCount
	lookup["$swpTime"] = shadowWordPainTime
	lookup["$pwRadianceTime"] = pwRadianceTime
	lookup["$radianceTime"] = pwRadianceTime
	lookup["$powerWordRadianceTime"] = pwRadianceTime
	lookup["$pwRadianceCharges"] = pwRadianceCharges
	lookup["$radianceCharges"] = pwRadianceCharges
	lookup["$powerWordRadianceCharges"] = pwRadianceCharges
	lookup["$scTime"] = scTime
	lookup["$shadowCovenantTime"] = scTime
	lookup["$atonementMinTime"] = atonementMinTime
	lookup["$atonementMaxTime"] = atonementMaxTime
	lookup["$atonementTime"] = atonementTime
	lookup["$atonementCount"] = atonementCount
	lookup["$entropicRiftTime"] = entropicRiftTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaTotal"] = _manaTotal
	lookupLogic["$manaMax"] = maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
	lookupLogic["$manaPlusCasting"] = _manaPlusCasting
	lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
	lookupLogic["$manaPlusPassive"] = _manaPlusPassive
	lookupLogic["$resourceTotal"] = _manaTotal
	lookupLogic["$resourceMax"] = maxResource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$passive"] = _passiveMana
	lookupLogic["$solStacks"] = _solStacks
	lookupLogic["$solTime"] = _solTime
	lookupLogic["$sohMana"] = _sohMana
	lookupLogic["$sohTime"] = _sohTime
	lookupLogic["$sohTicks"] = _sohTicks
	lookupLogic["$innervateMana"] = _innervateMana
	lookupLogic["$innervateTime"] = _innervateTime
	lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
	lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
	lookupLogic["$mrMana"] = _mrMana
	lookupLogic["$mrTime"] = _mrTime
	lookupLogic["$bowMana"] = _bowMana
	lookupLogic["$bowTime"] = _bowTime
	lookupLogic["$bowTicks"] = _bowTicks
	lookupLogic["$mttMana"] = _mttMana
	lookupLogic["$mttTime"] = _mttTime
	lookupLogic["$channeledMana"] = _channeledMana
	lookupLogic["$slumberingSoulSerumTicks"] = _slumberingSoulSerumTicks
	lookupLogic["$slumberingSoulSerumTime"] = _slumberingSoulSerumTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	lookupLogic["$sfMana"] = _sfMana
	lookupLogic["$sfGcds"] = _sfGcds
	lookupLogic["$sfSwings"] = _sfSwings
	lookupLogic["$sfTime"] = _sfTime
	lookupLogic["$sfCount"] = shadowfiend:TotalActive()
	lookupLogic["$swpCount"] = _shadowWordPainCount
	lookupLogic["$swpTime"] = _shadowWordPainTime
	lookupLogic["$pwRadianceTime"] = _pwRadianceTime
	lookupLogic["$radianceTime"] = _pwRadianceTime
	lookupLogic["$powerWordRadianceTime"] = _pwRadianceTime
	lookupLogic["$pwRadianceCharges"] = _pwRadianceCharges
	lookupLogic["$radianceCharges"] = _pwRadianceCharges
	lookupLogic["$powerWordRadianceCharges"] = _pwRadianceCharges
	lookupLogic["$scTime"] = _scTime
	lookupLogic["$shadowCovenantTime"] = _scTime
	lookupLogic["$atonementMinTime"] = _atonementMinTime
	lookupLogic["$atonementMaxTime"] = _atonementMaxTime
	lookupLogic["$atonementTime"] = _atonementTime
	lookupLogic["$atonementCount"] = _atonementCount
	lookupLogic["$entropicRiftTime"] = _entropicRiftTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Holy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.priest.holy
	local sharedSettings = TRB.Data.specCache["holy"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	--$sohMana
	local _sohMana = symbolOfHope.buff.mana
	local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
	--$sohTicks
	local _sohTicks = symbolOfHope.buff.ticks or 0
	local sohTicks = string.format("%.0f", _sohTicks)
	--$sohTime
	local _sohTime = symbolOfHope.buff:GetRemainingTime(currentTime)
	local sohTime = TRB.Functions.BarText:TimerPrecision(_sohTime)

	local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	--$innervateMana
	local _innervateMana = innervate.mana
	local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
	--$innervateTime
	local _innervateTime = innervate.buff:GetRemainingTime(currentTime)
	local innervateTime = TRB.Functions.BarText:TimerPrecision(_innervateTime)

	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	--$potionOfChilledClarityMana
	local _potionOfChilledClarityMana = potionOfChilledClarity.mana
	local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
	--$potionOfChilledClarityTime
	local _potionOfChilledClarityTime = potionOfChilledClarity.buff:GetRemainingTime(currentTime)
	local potionOfChilledClarityTime = TRB.Functions.BarText:TimerPrecision(_potionOfChilledClarityTime)
	
	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	--$mttMana
	local _mttMana = manaTideTotem.mana
	local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
	--$mttTime
	local _mttTime = manaTideTotem.buff:GetRemainingTime(currentTime)
	local mttTime = TRB.Functions.BarText:TimerPrecision(_mttTime)
	
	local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
	--$mrMana
	local _mrMana = moltenRadiance.mana
	local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
	--$mrTime
	local _mrTime = moltenRadiance.buff.remaining
	local mrTime = TRB.Functions.BarText:TimerPrecision(_mrTime)
	
	local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
	--$bowMana
	local _bowMana = blessingOfWinter.mana
	local bowMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_bowMana, manaPrecision, "floor", true))
	--$bowTime
	local _bowTime = blessingOfWinter.buff.remaining
	local bowTime = TRB.Functions.BarText:TimerPrecision(_bowTime)
	--$bowTicks
	local _bowTicks = blessingOfWinter.buff.ticks or 0
	local bowTicks = string.format("%.0f", _bowTicks)

	--$potionCooldownSeconds
	local _potionCooldown = snapshots[spells.algariManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--$channeledMana
	local _channeledMana = channeledManaPotion.mana
	local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
	--$slumberingSoulSerumTicks
	local _slumberingSoulSerumTicks = channeledManaPotion.ticks or 0
	local slumberingSoulSerumTicks = string.format("%.0f", _slumberingSoulSerumTicks)
	--$slumberingSoulSerumTime
	local _slumberingSoulSerumTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
	local slumberingSoulSerumTime = TRB.Functions.BarText:TimerPrecision(_slumberingSoulSerumTime)

	local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
	
	--$sfMana
	local _sfMana = shadowfiend.resourceFinal or 0
	local sfMana = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
	--$sfGcds
	local _sfGcds = shadowfiend.remainingGcds
	local sfGcds = string.format("%.0f", _sfGcds)
	--$sfSwings
	local _sfSwings = shadowfiend.remainingSwings
	local sfSwings = string.format("%.0f", _sfSwings)
	--$sfTime
	local _sfTime = shadowfiend.remainingTime
	local sfTime = TRB.Functions.BarText:TimerPrecision(_sfTime)

	--$passive
	local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana + _bowMana
	local passiveMana = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
	--$manaTotal
	local _manaTotal = math.min(_passiveMana + snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
	--$manaPlusCasting
	local _manaPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
	--$manaPlusPassive
	local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))
	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end
	local _manaPercent = (normalizedMana/maxResource)
	local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.Number:RoundTo(_manaPercent*100, manaPrecision, "floor"))

	--$hwChastiseTime
	local _hwChastiseTime = snapshots[spells.holyWordChastise.id].cooldown.remaining
	local hwChastiseTime = TRB.Functions.BarText:TimerPrecision(_hwChastiseTime)

	--$hwSanctifyTime
	local _hwSanctifyTime = snapshots[spells.holyWordSanctify.id].cooldown.remaining
	local hwSanctifyTime = TRB.Functions.BarText:TimerPrecision(_hwSanctifyTime)

	--$hwSerenityTime
	local _hwSerenityTime = snapshots[spells.holyWordSerenity.id].cooldown.remaining
	local hwSerenityTime = TRB.Functions.BarText:TimerPrecision(_hwSerenityTime)
	
	--$hwSanctifyCharges
	local _hwSanctifyCharges = snapshots[spells.holyWordSanctify.id].cooldown.charges
	local hwSanctifyCharges = string.format("%.0f", _hwSanctifyCharges)
	
	--$hwSerenityCharges
	local _hwSerenityCharges = snapshots[spells.holyWordSerenity.id].cooldown.charges
	local hwSerenityCharges = string.format("%.0f", _hwSerenityCharges)

	--$apotheosisTime
	local _apotheosisTime = snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
	local apotheosisTime = TRB.Functions.BarText:TimerPrecision(_apotheosisTime)
	
	--$answeredPrayersStacks
	local _answeredPrayersStacks = snapshots[spells.answeredPrayers.id].buff.applications or 0
	local answeredPrayersStacks = string.format("%.0f", _answeredPrayersStacks)
	--$answeredPrayersMaxStacks
	local _answeredPrayersMaxStacks = 0	
	if spells.answeredPrayers ~= nil and talents.talents[spells.answeredPrayers.talentId] ~= nil then
		_answeredPrayersMaxStacks = spells.answeredPrayers.attributes.maxStackRank[talents.talents[spells.answeredPrayers.talentId].currentRank] or 0
	end
	local answeredPrayersMaxStacks = string.format("%.0f", _answeredPrayersMaxStacks)
	--$answeredPrayersRemainingStacks
	local _answeredPrayersRemainingStacks = _answeredPrayersMaxStacks - _answeredPrayersStacks
	local answeredPrayersRemainingStacks = string.format("%.0f", _answeredPrayersRemainingStacks)

	--$solStacks
	local _solStacks = snapshots[spells.surgeOfLight.id].buff.applications or 0
	local solStacks = string.format("%.0f", _solStacks)
	--$solTime
	local _solTime = snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime) or 0
	local solTime = TRB.Functions.BarText:TimerPrecision(_solTime)

	--$lightweaverStacks
	local _lightweaverStacks = snapshots[spells.lightweaver.id].buff.applications or 0
	local lightweaverStacks = string.format("%.0f", _lightweaverStacks)
	--$lightweaverTime
	local _lightweaverTime = snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime) or 0
	local lightweaverTime = TRB.Functions.BarText:TimerPrecision(_lightweaverTime)
	
	--$rwTime
	local _rwTime = snapshots[spells.resonantWords.id].buff:GetRemainingTime(currentTime) or 0
	local rwTime = TRB.Functions.BarText:TimerPrecision(_rwTime)
	
	--$lightweaverStacks
	local _sacredReverenceStacks = snapshots[spells.sacredReverence.id].buff.applications or 0
	local sacredReverenceStacks = string.format("%.0f", _sacredReverenceStacks)

	-----------
	--$swpCount and $swpTime
	local _shadowWordPainCount = snapshotData.targetData.count[spells.shadowWordPain.id] or 0
	local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
	local _shadowWordPainTime = 0
	
	if target ~= nil then
		_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
	end

	local shadowWordPainTime

	if sharedSettings.colors.text.dots.options.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.shadowWordPain.id].active then
			if _shadowWordPainTime > spells.shadowWordPain.pandemicTime then
				shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			end
		else
			shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _shadowWordPainCount)
			shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		shadowWordPainTime = TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime)
	end

	Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.channeledPotion = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
	Global_TwintopResourceBar.resource.potionOfChilledClarity = _potionOfChilledClarityMana or 0
	Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
	Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
	
	Global_TwintopResourceBar.potionOfSpiritualClarity = Global_TwintopResourceBar.potionOfSpiritualClarity or {}
	Global_TwintopResourceBar.potionOfSpiritualClarity.mana = _channeledMana
	Global_TwintopResourceBar.potionOfSpiritualClarity.ticks = _slumberingSoulSerumTicks or 0
	
	Global_TwintopResourceBar.symbolOfHope = Global_TwintopResourceBar.symbolOfHope or {}
	Global_TwintopResourceBar.symbolOfHope.mana = _sohMana
	Global_TwintopResourceBar.symbolOfHope.ticks = _sohTicks or 0

	Global_TwintopResourceBar.shadowfiend = Global_TwintopResourceBar.shadowfiend or {}
	Global_TwintopResourceBar.shadowfiend.mana = shadowfiend.resourceFinal or 0
	Global_TwintopResourceBar.shadowfiend.gcds = shadowfiend.remainingGcds or 0
	Global_TwintopResourceBar.shadowfiend.swings = shadowfiend.remainingSwings or 0
	Global_TwintopResourceBar.shadowfiend.time = shadowfiend.remainingTime or 0
	Global_TwintopResourceBar.shadowfiend.count = shadowfiend:TotalActive()

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.swpCount = _shadowWordPainCount or 0

	local lookup = TRB.Data.lookup
	lookup["$manaTotal"] = manaTotal
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourcePlusCasting"] = manaPlusCasting
	lookup["$manaPlusCasting"] = manaPlusCasting
	lookup["$resourcePlusPassive"] = manaPlusPassive
	lookup["$manaPlusPassive"] = manaPlusPassive
	lookup["$resourceTotal"] = manaTotal
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$resource"] = currentMana
	lookup["$casting"] = castingMana
	lookup["$passive"] = passiveMana
	lookup["$hwChastiseTime"] = hwChastiseTime
	lookup["$chastiseTime"] = hwChastiseTime
	lookup["$holyWordChastiseTime"] = hwChastiseTime
	lookup["$hwSanctifyTime"] = hwSanctifyTime
	lookup["$sanctifyTime"] = hwSanctifyTime
	lookup["$holyWordSanctifyTime"] = hwSanctifyTime
	lookup["$hwSerenityTime"] = hwSerenityTime
	lookup["$serenityTime"] = hwSerenityTime
	lookup["$holyWordSerenityTime"] = hwSerenityTime
	lookup["$hwSanctifyCharges"] = hwSanctifyCharges
	lookup["$sanctifyCharges"] = hwSanctifyCharges
	lookup["$holyWordSanctifyCharges"] = hwSanctifyCharges
	lookup["$hwSerenityCharges"] = hwSerenityCharges
	lookup["$serenityCharges"] = hwSerenityCharges
	lookup["$holyWordSerenityCharges"] = hwSerenityCharges
	lookup["$sohMana"] = sohMana
	lookup["$sohTime"] = sohTime
	lookup["$sohTicks"] = sohTicks
	lookup["$innervateMana"] = innervateMana
	lookup["$innervateTime"] = innervateTime
	lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
	lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
	lookup["$mrMana"] = mrMana
	lookup["$mrTime"] = mrTime
	lookup["$mttMana"] = mttMana
	lookup["$mttTime"] = mttTime
	lookup["$bowMana"] = bowMana
	lookup["$bowTime"] = bowTime
	lookup["$bowTicks"] = bowTicks
	lookup["$channeledMana"] = channeledMana
	lookup["$slumberingSoulSerumTicks"] = slumberingSoulSerumTicks
	lookup["$slumberingSoulSerumTime"] = slumberingSoulSerumTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$solStacks"] = solStacks
	lookup["$solTime"] = solTime
	lookup["$sfMana"] = sfMana
	lookup["$sfGcds"] = sfGcds
	lookup["$sfSwings"] = sfSwings
	lookup["$sfTime"] = sfTime
	lookup["$sfCount"] = shadowfiend:TotalActive()
	lookup["$lightweaverStacks"] = lightweaverStacks
	lookup["$lightweaverTime"] = lightweaverTime
	lookup["$apotheosisTime"] = apotheosisTime
	lookup["$answeredPrayersStacks"] = answeredPrayersStacks
	lookup["$answeredPrayersMaxStacks"] = answeredPrayersMaxStacks
	lookup["$answeredPrayersRemainingStacks"] = answeredPrayersRemainingStacks
	lookup["$sacredReverenceStacks"] = sacredReverenceStacks
	lookup["$swpCount"] = shadowWordPainCount
	lookup["$swpTime"] = shadowWordPainTime
	lookup["$rwTime"] = rwTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaTotal"] = _manaTotal
	lookupLogic["$manaMax"] = maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
	lookupLogic["$manaPlusCasting"] = _manaPlusCasting
	lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
	lookupLogic["$manaPlusPassive"] = _manaPlusPassive
	lookupLogic["$resourceTotal"] = _manaTotal
	lookupLogic["$resourceMax"] = maxResource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$passive"] = _passiveMana
	lookupLogic["$hwChastiseTime"] = _hwChastiseTime
	lookupLogic["$chastiseTime"] = _hwChastiseTime
	lookupLogic["$holyWordChastiseTime"] = _hwChastiseTime
	lookupLogic["$hwSanctifyTime"] = _hwSanctifyTime
	lookupLogic["$sanctifyTime"] = _hwSanctifyTime
	lookupLogic["$holyWordSanctifyTime"] = _hwSanctifyTime
	lookupLogic["$hwSerenityTime"] = _hwSerenityTime
	lookupLogic["$serenityTime"] = _hwSerenityTime
	lookupLogic["$holyWordSerenityTime"] = _hwSerenityTime
	lookupLogic["$hwSanctifyCharges"] = _hwSanctifyCharges
	lookupLogic["$sanctifyCharges"] = _hwSanctifyCharges
	lookupLogic["$holyWordSanctifyCharges"] = _hwSanctifyCharges
	lookupLogic["$hwSerenityCharges"] = _hwSerenityCharges
	lookupLogic["$serenityCharges"] = _hwSerenityCharges
	lookupLogic["$holyWordSerenityCharges"] = _hwSerenityCharges
	lookupLogic["$sohMana"] = _sohMana
	lookupLogic["$sohTime"] = _sohTime
	lookupLogic["$sohTicks"] = _sohTicks
	lookupLogic["$innervateMana"] = _innervateMana
	lookupLogic["$innervateTime"] = _innervateTime
	lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
	lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
	lookupLogic["$mrMana"] = _mrMana
	lookupLogic["$mrTime"] = _mrTime
	lookupLogic["$bowMana"] = _bowMana
	lookupLogic["$bowTime"] = _bowTime
	lookupLogic["$bowTicks"] = _bowTicks
	lookupLogic["$mttMana"] = _mttMana
	lookupLogic["$mttTime"] = _mttTime
	lookupLogic["$channeledMana"] = _channeledMana
	lookupLogic["$slumberingSoulSerumTicks"] = _slumberingSoulSerumTicks
	lookupLogic["$slumberingSoulSerumTime"] = _slumberingSoulSerumTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	lookupLogic["$solStacks"] = _solStacks
	lookupLogic["$solTime"] = _solTime
	lookupLogic["$sfMana"] = _sfMana
	lookupLogic["$sfGcds"] = _sfGcds
	lookupLogic["$sfSwings"] = _sfSwings
	lookupLogic["$sfTime"] = _sfTime
	lookupLogic["$lightweaverStacks"] = _lightweaverStacks
	lookupLogic["$lightweaverTime"] = _lightweaverTime
	lookupLogic["$apotheosisTime"] = _apotheosisTime
	lookupLogic["$answeredPrayersStacks"] = _answeredPrayersStacks
	lookupLogic["$answeredPrayersMaxStacks"] = _answeredPrayersMaxStacks
	lookupLogic["$answeredPrayersRemainingStacks"] = _answeredPrayersRemainingStacks
	lookupLogic["$sacredReverenceStacks"] = _sacredReverenceStacks
	lookupLogic["$swpCount"] = _shadowWordPainCount
	lookupLogic["$swpTime"] = _shadowWordPainTime
	lookupLogic["$rwTime"] = rwTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Shadow()
	local specSettings = TRB.Data.settings.priest.shadow
	local sharedSettings = TRB.Data.specCache["shadow"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedInsanity = snapshotData.attributes.resource / TRB.Data.resourceFactor


	--$vfTime
	local _voidformTime = snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)

	--TODO: not use this hacky workaroud for timers
	if snapshots[spells.darkAscension.id].buff:GetRemainingTime(currentTime) > 0 then
		_voidformTime = snapshots[spells.darkAscension.id].buff.remaining
	end

	local voidformTime = TRB.Functions.BarText:TimerPrecision(_voidformTime)
	----------

	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentInsanityColor = sharedSettings.colors.text.current.color
	local castingInsanityColor = sharedSettings.colors.text.casting.color

	local insanityThreshold = spells.devouringPlague:GetPrimaryResourceCost()

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overcap.enabled and overcap then
			currentInsanityColor = sharedSettings.colors.text.overcap.color
			castingInsanityColor = sharedSettings.colors.text.overcap.color
		elseif sharedSettings.colors.text.overThreshold.enabled and normalizedInsanity >= insanityThreshold then
			currentInsanityColor = sharedSettings.colors.text.overThreshold.color
			castingInsanityColor = sharedSettings.colors.text.overThreshold.color
		end
	end

	--$insanity
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentInsanity = normalizedInsanity
	local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_currentInsanity, resourcePrecision, "floor"))
	--$casting
	local _castingInsanity = snapshotData.casting.resourceFinal
	local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, resourcePrecision, "floor"))
	
	local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
	
	--$mbInsanity
	local _mbInsanity = shadowfiend.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal
	local mbInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_mbInsanity, resourcePrecision, "floor"))
	--$mbGcds
	local _mbGcds = shadowfiend.remainingGcds
	local mbGcds = string.format("%.0f", _mbGcds)
	--$mbSwings
	local _mbSwings = shadowfiend.remainingSwings
	local mbSwings = string.format("%.0f", _mbSwings)
	--$mbTime
	local _mbTime = shadowfiend.remainingTime
	local mbTime = TRB.Functions.BarText:TimerPrecision(_mbTime)
	--$loiInsanity
	local _loiInsanity = snapshots[spells.idolOfCthun.id].attributes.resourceFinal
	local loiInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_loiInsanity, resourcePrecision, "floor"))
	--$loiTicks
	local _loiTicks = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining
	local loiTicks = string.format("%.0f", _loiTicks)
	--$ecttvCount
	local _ecttvCount = snapshots[spells.idolOfCthun.id].attributes.numberActive
	local ecttvCount = string.format("%.0f", _ecttvCount)
	--$asCount
	local _asCount = targetData.count[spells.auspiciousSpirits.id] or 0
	local asCount = string.format("%.0f", _asCount)
	--$asInsanity
	local _asInsanity = CalculateResourceGain(spells.auspiciousSpirits.resource) * (targetData.custom.auspiciousSpiritsGenerate or 0)
	local asInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_asInsanity, resourcePrecision, "ceil"))
	--$passive
	local _passiveInsanity = _asInsanity + _mbInsanity + _loiInsanity
	local passiveInsanity = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.Number:RoundTo(_passiveInsanity, resourcePrecision, "floor"))
	--$insanityTotal
	local _insanityTotal = math.min(_passiveInsanity + snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
	local insanityTotal = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityTotal, resourcePrecision, "floor"))
	--$insanityPlusCasting
	local _insanityPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
	local insanityPlusCasting = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_insanityPlusCasting, resourcePrecision, "floor"))
	--$insanityPlusPassive
	local _insanityPlusPassive = math.min(_passiveInsanity + normalizedInsanity, TRB.Data.character.maxResource)
	local insanityPlusPassive = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityPlusPassive, resourcePrecision, "floor"))


	----------
	--$swpCount and $swpTime
	local _shadowWordPainCount = targetData.count[spells.shadowWordPain.id] or 0
	local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
	local _shadowWordPainTime = 0
	
	if target ~= nil then
		_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
	end

	local shadowWordPainTime

	--$vtCount and $vtTime
	local _vampiricTouchCount = targetData.count[spells.vampiricTouch.id] or 0
	local vampiricTouchCount = string.format("%s", _vampiricTouchCount)
	local _vampiricTouchTime = 0
	
	if target ~= nil then
		_vampiricTouchTime = target.spells[spells.vampiricTouch.id].remainingTime or 0
	end

	local vampiricTouchTime

	--$dpTime
	local _devouringPlagueTime
	if target ~= nil then
		_devouringPlagueTime = target.spells[spells.devouringPlague.id].remainingTime or 0
	else
		_devouringPlagueTime = 0
	end

	local devouringPlagueTime = TRB.Functions.BarText:TimerPrecision(_devouringPlagueTime)

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.shadowWordPain.id].active then
			if (not talents:IsTalentActive(spells.misery) and target.spells[spells.shadowWordPain.id].remainingTime > spells.shadowWordPain.pandemicTime) or
				(talents:IsTalentActive(spells.misery) and target.spells[spells.shadowWordPain.id].remainingTime > spells.shadowWordPain.attributes.miseryPandemicTime) then
				shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			end
		else
			shadowWordPainCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _shadowWordPainCount)
			shadowWordPainTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end

		if target ~= nil and target.spells[spells.vampiricTouch.id].active then
			if target.spells[spells.vampiricTouch.id].remainingTime > spells.vampiricTouch.pandemicTime then
				vampiricTouchCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _vampiricTouchCount)
				vampiricTouchTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_vampiricTouchTime))
			else
				vampiricTouchCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _vampiricTouchCount)
				vampiricTouchTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_vampiricTouchTime))
			end
		else
			vampiricTouchCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _vampiricTouchCount)
			vampiricTouchTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		shadowWordPainTime = TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime)
		vampiricTouchTime = TRB.Functions.BarText:TimerPrecision(_vampiricTouchTime)
	end

	--$dpCount
	local devouringPlagueCount = targetData.count[spells.devouringPlague.id] or 0

	--$mdTime
	local _mdTime = snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)
	local mdTime = TRB.Functions.BarText:TimerPrecision(_mdTime)
	
	--$mfiTime
	local _mfiTime = 0
	--$mfiStacks
	local _mfiStacks = 0
	
	if snapshots[spells.mindFlayInsanity.id].buff.isActive then
		_mfiTime = snapshots[spells.mindFlayInsanity.id].buff:GetRemainingTime(currentTime)
		_mfiStacks = snapshots[spells.mindFlayInsanity.id].buff.applications or 0
	end
	
	local mfiTime = TRB.Functions.BarText:TimerPrecision(_mfiTime)
	local mfiStacks = string.format("%.0f", _mfiStacks)

	--$tofTime
	local _tofTime = snapshots[spells.twistOfFate.id].buff:GetRemainingTime(currentTime)
	local tofTime = TRB.Functions.BarText:TimerPrecision(_tofTime)
	
	--$mindBlastCharges
	local mindBlastCharges = snapshots[spells.mindBlast.id].cooldown.charges or 0
	
	--$mindBlastMaxCharges
	local mindBlastMaxCharges = snapshots[spells.mindBlast.id].cooldown.maxCharges or 0

	--$siTime
	local _siTime = snapshots[spells.shadowyInsight.id].buff:GetRemainingTime(currentTime)
	local siTime = TRB.Functions.BarText:TimerPrecision(_siTime)
	
	--$spTime
	local _spTime = snapshots[spells.shatteredPsyche.id].buff:GetRemainingTime(currentTime)
	local spTime = TRB.Functions.BarText:TimerPrecision(_spTime)
	--$spStacks
	local spStacks = snapshots[spells.shatteredPsyche.id].buff.applications or 0
	
	--$ysTime
	local _ysTime = snapshots[spells.idolOfYoggSaron.id].buff:GetRemainingTime(currentTime)
	local ysTime = TRB.Functions.BarText:TimerPrecision(_ysTime)
	--$ysStacks
	local ysStacks = snapshots[spells.idolOfYoggSaron.id].buff.applications or 0
	--$ysRemainingStacks
	local ysRemainingStacks = (spells.idolOfYoggSaron.attributes.requiredStacks - ysStacks) or spells.idolOfYoggSaron.attributes.requiredStacks
	--$tfbTime
	local _tfbTime = snapshots[spells.thingFromBeyond.id].buff:GetRemainingTime(currentTime)
	local tfbTime = TRB.Functions.BarText:TimerPrecision(_tfbTime)
	
	--$reStacks
	local reStacks = 0
	--$reTime
	local _reTime = 0
	if target ~= nil then
		reStacks = target.spells[spells.resonantEnergy.debuffId].stacks or 0
		_reTime = target.spells[spells.resonantEnergy.debuffId].remainingTime
	end
	local reTime = TRB.Functions.BarText:TimerPrecision(_reTime)

	--$entropicRiftTime
	local _entropicRiftTime = snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
	local entropicRiftTime = TRB.Functions.BarText:TimerPrecision(_entropicRiftTime)

	--$cttvEquipped
	local cttvEquipped = TRB.Functions.Class:IsValidVariableForSpec("$cttvEquipped")

	----------------------------

	Global_TwintopResourceBar.voidform = {
	}
	Global_TwintopResourceBar.resource.passive = _passiveInsanity
	Global_TwintopResourceBar.resource.auspiciousSpirits = _asInsanity
	Global_TwintopResourceBar.resource.shadowfiend = _mbInsanity or 0
	Global_TwintopResourceBar.resource.mindbender = _mbInsanity or 0
	Global_TwintopResourceBar.resource.ecttv = snapshots[spells.idolOfCthun.id].attributes.resourceFinal or 0
	
	Global_TwintopResourceBar.auspiciousSpirits = Global_TwintopResourceBar.auspiciousSpirits or {}
	Global_TwintopResourceBar.auspiciousSpirits.count = targetData.count[spells.auspiciousSpirits.id] or 0
	Global_TwintopResourceBar.auspiciousSpirits.insanity = _asInsanity

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.swpCount = _shadowWordPainCount or 0
	Global_TwintopResourceBar.dots.vtCount = _vampiricTouchCount or 0
	Global_TwintopResourceBar.dots.dpCount = devouringPlagueCount or 0

	Global_TwintopResourceBar.shadowfiend = Global_TwintopResourceBar.shadowfiend or {}
	Global_TwintopResourceBar.shadowfiend.insanity = _mbInsanity or 0
	Global_TwintopResourceBar.shadowfiend.gcds = shadowfiend.remainingGcds or 0
	Global_TwintopResourceBar.shadowfiend.swings = shadowfiend.remainingSwings or 0
	Global_TwintopResourceBar.shadowfiend.time = shadowfiend.remainingTime or 0
	Global_TwintopResourceBar.shadowfiend.count = shadowfiend:TotalActive()

	Global_TwintopResourceBar.mindbender = Global_TwintopResourceBar.mindbender or {}
	Global_TwintopResourceBar.mindbender.insanity = _mbInsanity or 0
	Global_TwintopResourceBar.mindbender.gcds = shadowfiend.remainingGcds or 0
	Global_TwintopResourceBar.mindbender.swings = shadowfiend.remainingSwings or 0
	Global_TwintopResourceBar.mindbender.time = shadowfiend.remainingTime or 0
	Global_TwintopResourceBar.mindbender.count = shadowfiend:TotalActive()

	Global_TwintopResourceBar.eternalCallToTheVoid = Global_TwintopResourceBar.eternalCallToTheVoid or {}
	Global_TwintopResourceBar.eternalCallToTheVoid.insanity = snapshots[spells.idolOfCthun.id].attributes.resourceFinal or 0
	Global_TwintopResourceBar.eternalCallToTheVoid.ticks = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining or 0
	Global_TwintopResourceBar.eternalCallToTheVoid.count = snapshots[spells.idolOfCthun.id].attributes.numberActive or 0

	local lookup = TRB.Data.lookup

	lookup["$swpCount"] = shadowWordPainCount
	lookup["$swpTime"] = shadowWordPainTime
	lookup["$vtCount"] = vampiricTouchCount
	lookup["$vtTime"] = vampiricTouchTime
	lookup["$dpCount"] = devouringPlagueCount
	lookup["$dpTime"] = devouringPlagueTime
	lookup["$mdTime"] = mdTime
	lookup["$mfiTime"] = mfiTime
	lookup["$mfiStacks"] = mfiStacks
	lookup["$tofTime"] = tofTime
	lookup["$vfTime"] = voidformTime
	lookup["$spTime"] = spTime
	lookup["$mmTime"] = spTime
	lookup["$spStacks"] = spStacks
	lookup["$mmStacks"] = spStacks
	lookup["$ysTime"] = ysTime
	lookup["$ysStacks"] = ysStacks
	lookup["$ysRemainingStacks"] = ysRemainingStacks
	lookup["$reStacks"] = reStacks
	lookup["$reTime"] = reTime
	lookup["$tfbTime"] = tfbTime
	lookup["$siTime"] = siTime
	lookup["$mindBlastCharges"] = mindBlastCharges
	lookup["$mindBlastMaxCharges"] = mindBlastMaxCharges
	lookup["$insanityTotal"] = insanityTotal
	lookup["$insanityMax"] = TRB.Data.character.maxResource
	lookup["$insanity"] = currentInsanity
	lookup["$resourcePlusCasting"] = insanityPlusCasting
	lookup["$insanityPlusCasting"] = insanityPlusCasting
	lookup["$resourcePlusPassive"] = insanityPlusPassive
	lookup["$insanityPlusPassive"] = insanityPlusPassive
	lookup["$resourceTotal"] = insanityTotal
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentInsanity
	lookup["$casting"] = castingInsanity
	lookup["$passive"] = passiveInsanity
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$insanityOvercap"] = overcap
	lookup["$sfInsanity"] = mbInsanity
	lookup["$mbInsanity"] = mbInsanity
	lookup["$sfGcds"] = mbGcds
	lookup["$mbGcds"] = mbGcds
	lookup["$sfSwings"] = mbSwings
	lookup["$mbSwings"] = mbSwings
	lookup["$sfTime"] = mbTime
	lookup["$mbTime"] = mbTime
	lookup["$sfCount"] = shadowfiend:TotalActive()
	lookup["$mbCount"] = shadowfiend:TotalActive()
	lookup["$loiInsanity"] = loiInsanity
	lookup["$loiTicks"] = loiTicks
	lookup["$cttvEquipped"] = ""
	lookup["$ecttvCount"] = ecttvCount
	lookup["$asCount"] = asCount
	lookup["$asInsanity"] = asInsanity
	lookup["$entropicRiftTime"] = entropicRiftTime
	lookup["$overcap"] = ""
	lookup["$insanityOvercap"] = ""
	lookup["$resourceOvercap"] = ""
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$swpCount"] = _shadowWordPainCount
	lookupLogic["$swpTime"] = _shadowWordPainTime
	lookupLogic["$vtCount"] = _vampiricTouchCount
	lookupLogic["$vtTime"] = _vampiricTouchTime
	lookupLogic["$dpCount"] = devouringPlagueCount
	lookupLogic["$dpTime"] = _devouringPlagueTime
	lookupLogic["$mdTime"] = _mdTime
	lookupLogic["$mfiTime"] = _mfiTime
	lookupLogic["$mfiStacks"] = _mfiStacks
	lookupLogic["$tofTime"] = _tofTime
	lookupLogic["$vfTime"] = _voidformTime
	lookupLogic["$spTime"] = _spTime
	lookupLogic["$mmTime"] = _spTime
	lookupLogic["$spStacks"] = spStacks
	lookupLogic["$mmStacks"] = spStacks
	lookupLogic["$ysTime"] = _ysTime
	lookupLogic["$ysStacks"] = ysStacks
	lookupLogic["$ysRemainingStacks"] = ysRemainingStacks
	lookupLogic["$reStacks"] = reStacks
	lookupLogic["$reTime"] = _reTime
	lookupLogic["$tfbTime"] = _tfbTime
	lookupLogic["$siTime"] = _siTime
	lookupLogic["$mindBlastCharges"] = mindBlastCharges
	lookupLogic["$mindBlastMaxCharges"] = mindBlastMaxCharges
	lookupLogic["$insanityTotal"] = _insanityTotal
	lookupLogic["$insanityMax"] = TRB.Data.character.maxResource
	lookupLogic["$insanity"] = _currentInsanity
	lookupLogic["$resourcePlusCasting"] = _insanityPlusCasting
	lookupLogic["$insanityPlusCasting"] = _insanityPlusCasting
	lookupLogic["$resourcePlusPassive"] = _insanityPlusPassive
	lookupLogic["$insanityPlusPassive"] = _insanityPlusPassive
	lookupLogic["$resourceTotal"] = _insanityTotal
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = _currentInsanity
	lookupLogic["$casting"] = _castingInsanity
	lookupLogic["$passive"] = _passiveInsanity
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$insanityOvercap"] = overcap
	lookupLogic["$sfInsanity"] = _mbInsanity
	lookupLogic["$mbInsanity"] = _mbInsanity
	lookupLogic["$sfGcds"] = _mbGcds
	lookupLogic["$mbGcds"] = _mbGcds
	lookupLogic["$sfSwings"] = _mbSwings
	lookupLogic["$mbSwings"] = _mbSwings
	lookupLogic["$sfTime"] = _mbTime
	lookupLogic["$mbTime"] = _mbTime
	lookupLogic["$sfCount"] = shadowfiend:TotalActive()
	lookupLogic["$mbCount"] = shadowfiend:TotalActive()
	lookupLogic["$loiInsanity"] = _loiInsanity
	lookupLogic["$loiTicks"] = _loiTicks
	lookupLogic["$cttvEquipped"] = cttvEquipped
	lookupLogic["$ecttvCount"] = _ecttvCount
	lookupLogic["$asCount"] = _asCount
	lookupLogic["$asInsanity"] = _asInsanity
	lookupLogic["$entropicRiftTime"] = _entropicRiftTime
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Discipline()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Holy()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
end

local function UpdateCastingResourceFinal_Shadow()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateResourceGain(TRB.Data.snapshotData.casting.resourceRaw)
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()
	local affectingCombat = TRB.Data.character.inCombat

	if TRB.Data.character.specId == 1 then
		casting:SnapshotManaSpell()
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Discipline()
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()

			if spellId == spells.heal.id then
				casting.spellKey = "heal"
			elseif spellId == spells.flashHeal.id then
				casting.spellKey = "flashHeal"
			elseif spellId == spells.prayerOfHealing.id then
				casting.spellKey = "prayerOfHealing"
			elseif spellId == spells.smite.id then
				casting.spellKey = "smite"
			elseif talents:IsTalentActive(spells.voiceOfHarmony) then
				if spellId == spells.holyFire.id then --Voice of Harmony
					casting.spellKey = "holyFire"
				end
			end
			UpdateCastingResourceFinal_Holy()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.symbolOfHope.id then
				casting.spellId = spells.symbolOfHope.id
				casting.startTime = currentTime
				casting.resourceRaw = 0
				casting.icon = spells.symbolOfHope.icon
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.mindBlast.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindBlast.resource
				casting.spellId = spells.mindBlast.id
				casting.icon = spells.mindBlast.icon
			elseif spellId == spells.darkAscension.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.darkAscension.resource
				casting.spellId = spells.darkAscension.id
				casting.icon = spells.darkAscension.icon

				if TRB.Data.character.items.twwSeason2SetBonusCount >= 2 then
					casting.resourceRaw = casting.resourceRaw + spells.voidBolt.resource
				end
			elseif spellId == spells.voidEruption.id then
				if TRB.Data.character.items.twwSeason2SetBonusCount >= 2 then
					casting.startTime = currentTime
					casting.resourceRaw = spells.voidBolt.resource
					casting.spellId = spells.darkAscension.id
					casting.icon = spells.darkAscension.icon
				end
			elseif spellId == spells.vampiricTouch.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.vampiricTouch.resource
				casting.spellId = spells.vampiricTouch.id
				casting.icon = spells.vampiricTouch.icon
			elseif spellId == spells.mindgames.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindgames.resource
				casting.spellId = spells.mindgames.id
				casting.icon = spells.mindgames.icon
			elseif spellId == spells.halo.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.halo.resource
				casting.spellId = spells.halo.id
				casting.icon = spells.halo.icon
			elseif spellId == spells.massDispel.id and talents:IsTalentActive(spells.hallucinations) and affectingCombat then
				casting.startTime = currentTime
				casting.resourceRaw = spells.hallucinations.resource
				casting.spellId = spells.massDispel.id
				casting.icon = spells.massDispel.icon
			elseif spellId == spells.voidBlast.id then
				casting.startTime = currentTime
				if talents:IsTalentActive(spells.voidInfusion) then
					casting.resourceRaw = spells.voidBlast.resource * spells.voidInfusion.attributes.resourceMod
				else
					casting.resourceRaw = spells.voidBlast.resource
				end
				casting.spellId = spells.voidBlast.id
				casting.icon = spells.voidBlast.icon
			end
			UpdateCastingResourceFinal_Shadow()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.mindFlay.id then
				casting.spellId = spells.mindFlay.id
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindFlay.resource
				casting.icon = spells.mindFlay.icon
			elseif spellId == spells.mindFlayInsanity.castId then
				casting.spellId = spells.mindFlayInsanity.castId
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindFlayInsanity.resource
				casting.icon = spells.mindFlayInsanity.icon
			elseif spellId == spells.voidTorrent.id then
				casting.spellId = spells.voidTorrent.id
				casting.startTime = currentTime
				casting.resourceRaw = spells.voidTorrent.resource
				casting.icon = spells.voidTorrent.icon
			end
			UpdateCastingResourceFinal_Shadow()
		end
	end
end

local function UpdateExternalCallToTheVoidValues()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local idolOfCthun = snapshotData.snapshots[spells.idolOfCthun.id]
	local currentTime = GetTime()
	local totalTicksRemaining_Lasher = 0
	local totalTicksRemaining_Tendril = 0
	local totalInsanity_Lasher = 0
	local totalInsanity_Tendril = 0
	local totalActive = 0

	-- TODO: Add separate counts for Tendril vs Lasher?
	if TRB.Functions.Table:Length(idolOfCthun.attributes.activeList) > 0 then
		for vtGuid, v in pairs(idolOfCthun.attributes.activeList) do
			if idolOfCthun.attributes.activeList[vtGuid] ~= nil and idolOfCthun.attributes.activeList[vtGuid].startTime ~= nil then
				local endTime = idolOfCthun.attributes.activeList[vtGuid].startTime + spells.lashOfInsanity_Tendril.duration
				local timeRemaining = endTime - currentTime

				if timeRemaining < 0 then
					RemoveVoidTendril(vtGuid)
				else
					if idolOfCthun.attributes.activeList[vtGuid].type == "Lasher" then
						if idolOfCthun.attributes.activeList[vtGuid].tickTime ~= nil and currentTime > (idolOfCthun.attributes.activeList[vtGuid].tickTime + 5) then
							idolOfCthun.attributes.activeList[vtGuid].targetsHit = 0
						end

						local nextTick = idolOfCthun.attributes.activeList[vtGuid].tickTime + spells.lashOfInsanity_Lasher.attributes.tickDuration

						if nextTick < currentTime then
							nextTick = currentTime --There should be a tick. ANY second now. Maybe.
							totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
						end
						-- NOTE: Might need to be math.floor()
						local ticksRemaining = math.ceil((endTime - nextTick) / spells.lashOfInsanity_Lasher.attributes.tickDuration)

						totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * spells.lashOfInsanity_Lasher.resource)
						totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + ticksRemaining
					else
						local nextTick = idolOfCthun.attributes.activeList[vtGuid].tickTime + spells.lashOfInsanity_Tendril.attributes.tickDuration

						if nextTick < currentTime then
							nextTick = currentTime --There should be a tick. ANY second now. Maybe.
							totalTicksRemaining_Tendril = totalTicksRemaining_Tendril + 1
						end

						-- NOTE: Might need to be math.floor()
						local ticksRemaining = math.ceil((endTime - nextTick) / spells.lashOfInsanity_Tendril.attributes.tickDuration) --Not needed as it is 1sec, but adding in case it changes

						totalInsanity_Tendril = totalInsanity_Tendril + (ticksRemaining * spells.lashOfInsanity_Tendril.resource)
						totalTicksRemaining_Tendril = totalTicksRemaining_Tendril + ticksRemaining
					end

					totalActive = totalActive + 1
				end
			end
		end
	end

	idolOfCthun.attributes.maxTicksRemaining = totalTicksRemaining_Tendril + totalTicksRemaining_Lasher
	idolOfCthun.attributes.numberActive = totalActive
	idolOfCthun.attributes.resourceRaw = totalInsanity_Tendril + totalInsanity_Lasher
	idolOfCthun.attributes.resourceFinal = CalculateResourceGain(idolOfCthun.attributes.resourceRaw)
end

local function UpdateAtonement()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local atonement = TRB.Data.snapshotData.snapshots[spells.atonement.id] --[[@as TRB.Classes.Snapshot]]
	local targets = TRB.Data.snapshotData.targetData.targets
	local minRemainingTime = nil
	local maxRemainingTime = nil
	local currentTime = GetTime()
	if TRB.Functions.Table:Length(targets) > 0 then
		for guid, target in pairs(targets) do
			if target.spells[spells.atonement.id].active and target.spells[spells.atonement.id].endTime ~= nil then
				local remainingTime = (target.spells[spells.atonement.id].endTime - currentTime)
				if remainingTime > 0 and remainingTime > (maxRemainingTime or 0) then
					maxRemainingTime = remainingTime
				end
			
				if remainingTime > 0 and remainingTime < (minRemainingTime or 999) then
					minRemainingTime = remainingTime
				end
			end
		end
	end

	atonement.attributes.minRemainingTime = minRemainingTime or 0
	atonement.attributes.maxRemainingTime = maxRemainingTime or 0
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
	shadowfiend:Update()
end

local function UpdateSnapshot_Healers()
	local _
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	local currentTime = GetTime()
	
	local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	innervate:Update()

	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	manaTideTotem:Update()

	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	symbolOfHope:Update()

	local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
	moltenRadiance:Update()

	local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
	blessingOfWinter:Update()
	
	local cannibalize = snapshots[spells.cannibalize.id] --[[@as TRB.Classes.Healer.Cannibalize]]
	cannibalize:Update()
	
	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	potionOfChilledClarity:Update()

	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	channeledManaPotion:Update()

	snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime)

	-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
	snapshots[spells.algariManaPotionRank1.id].cooldown.startTime, snapshots[spells.algariManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.algariManaPotionRank1.id)
	snapshots[spells.algariManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Voidweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.ShadowSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local entropicRift = snapshots[spells.entropicRift.id]
	
	if entropicRift.attributes.totemId ~= nil then
		local haveTotem, name, startTime, duration, _ = GetTotemInfo(entropicRift.attributes.totemId)
		if haveTotem then
			entropicRift.buff:InitializeCustom(duration, startTime)
		else
			entropicRift:Reset()
		end
	end
end

local function UpdateSnapshot_Discipline()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	UpdateSnapshot_Voidweaver()
	UpdateAtonement()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.powerWordRadiance.id].cooldown:Refresh(true)
	snapshots[spells.shadowCovenant.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Holy()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.holyWordSerenity.id].cooldown:Refresh(true)
	snapshots[spells.holyWordSanctify.id].cooldown:Refresh(true)
	snapshots[spells.holyWordChastise.id].cooldown:Refresh()
	snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.resonantWords.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime)
	
	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	symbolOfHope.cooldown:Refresh()
end

local function UpdateSnapshot_Shadow()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateExternalCallToTheVoidValues()
	UpdateSnapshot_Voidweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.darkAscension.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.mindFlayInsanity.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)

	snapshots[spells.mindBlast.id].cooldown:Refresh()

	local devouredDespair = snapshots[spells.devouredDespair.id]
	devouredDespair.buff:UpdateTicks()
	devouredDespair.attributes.resourceRaw = devouredDespair.buff.resource
	devouredDespair.attributes.resourceFinal = CalculateResourceGain(devouredDespair.attributes.resourceRaw)
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.priest
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		local specSettings = classSettings.discipline
		local specCacheSettings = TRB.Data.specCache.discipline.settings
		UpdateSnapshot_Discipline()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

				if snapshots[spells.surgeOfLight.id].buff.isActive then
					if snapshots[spells.surgeOfLight.id].buff.applications == 1 then
						if specSettings.colors.bar.surgeOfLightBorderChange1 then
							barBorderColor = specSettings.colors.bar.surgeOfLight1
						end

						if specSettings.audio.surgeOfLight.enabled and not snapshotData.audio.surgeOfLightCue then
							snapshotData.audio.surgeOfLightCue = true
							PlaySoundFile(specSettings.audio.surgeOfLight.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshots[spells.surgeOfLight.id].buff.applications == 2 then
						if specSettings.colors.bar.surgeOfLightBorderChange2 then
							barBorderColor = specSettings.colors.bar.surgeOfLight2
						end

						if specSettings.audio.surgeOfLight2.enabled and not snapshotData.audio.surgeOfLight2Cue then
							snapshotData.audio.surgeOfLight2Cue = true
							PlaySoundFile(specSettings.audio.surgeOfLight2.sound, coreSettings.audio.channel.channel)
						end
					end
				end

				if snapshots[spells.shadowCovenant.id].buff.isActive then
					if specSettings.colors.bar.shadowCovenantBorderChange then
						barBorderColor = specSettings.colors.bar.shadowCovenant
					end
				end

				if potionOfChilledClarity.buff.isActive then
					if specSettings.colors.bar.potionOfChilledClarityBorderChange then
						barBorderColor = specSettings.colors.bar.potionOfChilledClarity
					end
				elseif innervate.buff.isActive then
					if specSettings.colors.bar.innervateBorderChange then
						barBorderColor = specSettings.colors.bar.innervate
					end

					if specSettings.audio.innervate.enabled and snapshotData.audio.innervateCue == false then
						snapshotData.audio.innervateCue = true
						PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
					end
				end

				if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				local passiveValue, thresholdCount = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specCacheSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				thresholdCount = thresholdCount + 1
				TRB.Data.cache.values.threshold[spells.shadowfiend.id] = TRB.Data.cache.values.threshold[spells.shadowfiend.id] or {}
				if (talents:IsTalentActive(spells.shadowfiend) or talents:IsTalentActive(spells.mindbender) or talents:IsTalentActive(spells.voidwraith)) and specCacheSettings.thresholds.thresholdDictionary["shadowfiend"].enabled and specSettings.colors.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specCacheSettings, snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], passiveFrame, thresholdCount, castingBarValue, passiveValue, snapshots[spells.shadowfiend.id]--[[@as TRB.Classes.Priest.Shadowfiend]].resourceFinal)
				else
					TRB.Functions.Threshold:Hide(spells.shadowfiend.id, TRB.Frames.passiveFrame.thresholds[thresholdCount])
				end

				thresholdCount = thresholdCount + 1
				TRB.Data.cache.values.threshold[spells.cannibalize.id] = TRB.Data.cache.values.threshold[spells.cannibalize.id] or {}
				if TRB.Data.character.raceId == 5 and specCacheSettings.thresholds.thresholdDictionary["cannibalize"].enabled and specSettings.colors.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specCacheSettings, snapshots[spells.cannibalize.id] --[[@as TRB.Classes.Healer.Cannibalize]], passiveFrame, thresholdCount, castingBarValue, passiveValue)
				else
					TRB.Functions.Threshold:Hide(spells.cannibalize.id, TRB.Frames.passiveFrame.thresholds[thresholdCount])
				end

				passiveBarValue = castingBarValue + passiveValue

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				end


				local potion = snapshots[spells.algariManaPotionRank1.id].cooldown
				local potionCooldownThreshold = 0
				local potionThresholdColor = specCacheSettings.colors.threshold.over.color
				local potionFrameLevel = TRB.Data.constants.frameLevels.thresholdOver

				if potion.onCooldown then
					potionThresholdColor = specCacheSettings.colors.threshold.unusable.color
					potionFrameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					if specCacheSettings.thresholds.potionCooldown.enabled then
						if specCacheSettings.thresholds.potionCooldown.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							potionCooldownThreshold = gcd * specCacheSettings.thresholds.potionCooldown.gcdsMax
						elseif specCacheSettings.thresholds.potionCooldown.mode == "time" then
							potionCooldownThreshold = specCacheSettings.thresholds.potionCooldown.timeMax
						end
					end
				end

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					pairOffset = (thresholdId - 1) * 3
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local resourceAmount = 0
					local snapshot = snapshots[spell.id]

					if spell.attributes.isPotion then
						snapshot = snapshots[spells.algariManaPotionRank1.id]
						thresholdColor = potionThresholdColor
						frameLevel = potionFrameLevel
						if not potion.onCooldown or (potionCooldownThreshold > math.abs(potion.startTime + potion.duration - currentTime)) then
							local potionMana = CalculateManaGain(TRB.Data.character.items.potions[spell.settingKey].mana, true)
							resourceAmount = castingBarValue + potionMana
							if specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and resourceAmount < TRB.Data.character.maxResource then
							else
								showThreshold = false
							end
						else
							showThreshold = false
						end
					elseif spell.id == spells.shadowfiend.id or spell.id == spells.mindbender.id or spell.id == spells.voidwraith.id then
						snapshot = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
						if talents:IsTalentActive(spell) then--and not snapshot.buff.isActive then
							local mbActive = talents:IsTalentActive(spells.mindbender)
							local vwActive = talents:IsTalentActive(spells.voidwraith)
							if  (spell.id == spells.shadowfiend.id and not mbActive and not vwActive) or
								(spell.id == spells.mindbender.id and mbActive and not vwActive) or
								(spell.id == spells.voidwraith.id and vwActive) then
								if specCacheSettings.thresholds.thresholdDictionary["shadowfiend"].enabled and (not snapshot.cooldown:IsUnusable() or specCacheSettings.thresholds.thresholdDictionary["shadowfiend"].cooldown) then
									local _, swingsRemaining, _, _, _ = snapshot:GetMaximumValues()
									local shadowfiendMana

									if spell.id == spells.voidwraith.id and vwActive then
										if mbActive then
											shadowfiendMana = swingsRemaining * snapshot.voidwraith.attributes.resourcePercentMindbender * TRB.Data.character.maxResource
										else
											shadowfiendMana = swingsRemaining * snapshot.voidwraith.attributes.resourcePercent * TRB.Data.character.maxResource
										end
									elseif spell.id == spells.mindbender.id and mbActive then
										shadowfiendMana = swingsRemaining * snapshot.mindbender.attributes.resourcePercent * TRB.Data.character.maxResource
									else
										shadowfiendMana = swingsRemaining * snapshot.shadowfiend.attributes.resourcePercent * TRB.Data.character.maxResource
									end

									resourceAmount = castingBarValue + shadowfiendMana
									if snapshot.cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									end
			
									local totalActive = snapshot:TotalActive()

									if (totalActive == 0 or talents:IsTalentActive(spells.depthOfShadows)) and shadowfiendMana > 0 and resourceAmount < TRB.Data.character.maxResource then
									else
										showThreshold = false
									end
								else
									showThreshold = false
								end
							else
								showThreshold = false
							end
						else
							showThreshold = false
						end
					elseif spell.id == spells.cannibalize.id then
						snapshot = snapshots[spells.cannibalize.id] --[[@as TRB.Classes.Healer.Cannibalize]]
						local cannibalizeTotal = CalculateManaGain(snapshot:GetMaxManaReturn())
						resourceAmount = castingBarValue + cannibalizeTotal
						if not snapshot.buff.isActive and TRB.Data.character.raceId == 5 and specCacheSettings.thresholds.thresholdDictionary["cannibalize"].enabled and resourceAmount < TRB.Data.character.maxResource and (not snapshot.cooldown.onCooldown or specCacheSettings.thresholds.thresholdDictionary["cannibalize"].cooldown) then
							if snapshot.cooldown.onCooldown then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end
						else
							showThreshold = false
						end
					else
						resourceAmount = spell:GetPrimaryResourceCost()
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, TRB.Data.character.maxResource)
				end

				local barColor = specSettings.colors.bar.base

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				if talents:IsTalentActive(spells.powerWordRadiance) and specSettings.colors.comboPoints.powerWordRadianceEnabled then
					local cpBR, cpBG, cpBB, cpBA = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.powerWordRadiance
					local currentCp = 1
					
					local spell = spells.powerWordRadiance
					local cooldown = snapshots[spell.id].cooldown

					local cp1Time = 1
					local cp1Duration = 1
					local cp1Color = cpColor
					local cp2Time = 1
					local cp2Duration = 1
					local cp2Color = cpColor
					local hasCp2 = false
					if cooldown.maxCharges == 2 then -- Light's Promise
						if cooldown.charges == 2 then
							cp1Time = 1
							cp1Duration = 1
							cp2Time = 1
							cp2Duration = 1
							hasCp2 = true
						elseif cooldown.charges == 1 then
							cp1Time = 1
							cp1Duration = 1
							cp2Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
							cp2Duration = cooldown.duration
							hasCp2 = true
						else
							cp1Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
							cp1Duration = cooldown.duration
							cp2Time = 0
							cp2Duration = 1
							hasCp2 = true
						end
					else -- Baseline
						hasCp2 = false
						if cooldown.onCooldown then
							cp1Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
							cp1Duration = cooldown.duration
						else
							cp1Time = 1
							cp1Duration = 1
						end
					end
					
					if cp1Time < 0 then
						cp1Time = cp1Duration
					end

					if cp1Time == math.huge or cp1Duration == math.huge then
						cp1Time = 1
						cp1Duration = 1
					end

					if cp2Time < 0 then
						cp2Time = cp2Duration
					end

					if cp2Time == math.huge or cp2Duration == math.huge then
						cp2Time = 1
						cp2Duration = 1
					end

					local comboPointName = "comboPoint" .. currentCp
					TRB.Functions.Bar:SetValue(specCacheSettings, comboPointName, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp1Time, cp1Duration)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].resourceFrame, comboPointName, cp1Color)
					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].borderFrame, comboPointName, cpBorderColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[currentCp].containerFrame, comboPointName, cpBR, cpBG, cpBB, cpBA)
					currentCp = currentCp + 1

					if hasCp2 then
						comboPointName = "comboPoint" .. currentCp
						TRB.Functions.Bar:SetValue(specCacheSettings, comboPointName, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp2Time, cp2Duration)
						TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].resourceFrame, comboPointName, cp2Color)
						TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].borderFrame, comboPointName, cpBorderColor)
						TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[currentCp].containerFrame, comboPointName, cpBR, cpBG, cpBB, cpBA)
						currentCp = currentCp + 1
					end
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		local specSettings = classSettings.holy
		local specCacheSettings = TRB.Data.specCache.holy.settings
		UpdateSnapshot_Holy()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
				local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

				if snapshots[spells.lightweaver.id].buff.isActive then
					if specSettings.colors.bar.lightweaverBorderChange then
						barBorderColor = specSettings.colors.bar.lightweaver
					end

					if specSettings.audio.lightweaver.enabled and snapshotData.audio.lightweaverCue == false then
						snapshotData.audio.lightweaverCue = true
						PlaySoundFile(specSettings.audio.lightweaver.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.lightweaverCue = false
				end

				if snapshots[spells.resonantWords.id].buff.isActive then
					if specSettings.colors.bar.resonantWordsBorderChange then
						barBorderColor = specSettings.colors.bar.resonantWords
					end

					if specSettings.audio.resonantWords.enabled and snapshotData.audio.resonantWordsCue == false then
						snapshotData.audio.resonantWordsCue = true
						PlaySoundFile(specSettings.audio.resonantWords.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.resonantWordsCue = false
				end

				if snapshots[spells.surgeOfLight.id].buff.isActive then
					if snapshots[spells.surgeOfLight.id].buff.applications == 1 then
						if specSettings.colors.bar.surgeOfLightBorderChange1 then
							barBorderColor = specSettings.colors.bar.surgeOfLight1
						end

						if specSettings.audio.surgeOfLight.enabled and not snapshotData.audio.surgeOfLightCue then
							snapshotData.audio.surgeOfLightCue = true
							PlaySoundFile(specSettings.audio.surgeOfLight.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshots[spells.surgeOfLight.id].buff.applications == 2 then
						if specSettings.colors.bar.surgeOfLightBorderChange2 then
							barBorderColor = specSettings.colors.bar.surgeOfLight2
						end

						if specSettings.audio.surgeOfLight2.enabled and not snapshotData.audio.surgeOfLight2Cue then
							snapshotData.audio.surgeOfLight2Cue = true
							PlaySoundFile(specSettings.audio.surgeOfLight2.sound, coreSettings.audio.channel.channel)
						end
					end
				end

				if potionOfChilledClarity.buff.isActive then
					if specSettings.colors.bar.potionOfChilledClarityBorderChange then
						barBorderColor = specSettings.colors.bar.potionOfChilledClarity
					end
				elseif innervate.buff.isActive then
					if specSettings.colors.bar.innervateBorderChange then
						barBorderColor = specSettings.colors.bar.innervate
					end

					if specSettings.audio.innervate.enabled and snapshotData.audio.innervateCue == false then
						snapshotData.audio.innervateCue = true
						PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
					end
				end

				if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				local passiveValue, thresholdCount = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specCacheSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				thresholdCount = thresholdCount + 1
				if talents:IsTalentActive(spells.shadowfiend) and specCacheSettings.thresholds.thresholdDictionary["shadowfiend"].enabled and specSettings.colors.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specCacheSettings, snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], passiveFrame, thresholdCount, castingBarValue, passiveValue, snapshots[spells.shadowfiend.id]--[[@as TRB.Classes.Priest.Shadowfiend]].resourceFinal)
				else
					TRB.Functions.Threshold:Hide(spells.shadowfiend.id, TRB.Frames.passiveFrame.thresholds[thresholdCount])
				end

				thresholdCount = thresholdCount + 1
				if TRB.Data.character.raceId == 5 and specCacheSettings.thresholds.thresholdDictionary["cannibalize"].enabled and specSettings.colors.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specCacheSettings, snapshots[spells.cannibalize.id] --[[@as TRB.Classes.Healer.Cannibalize]], passiveFrame, thresholdCount, castingBarValue, passiveValue)
				else
					TRB.Functions.Threshold:Hide(spells.cannibalize.id, TRB.Frames.passiveFrame.thresholds[thresholdCount])
				end

				passiveBarValue = castingBarValue + passiveValue

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				end

				
				local potion = snapshots[spells.algariManaPotionRank1.id].cooldown
				local potionCooldownThreshold = 0
				local potionThresholdColor = specCacheSettings.colors.threshold.over.color
				local potionFrameLevel = TRB.Data.constants.frameLevels.thresholdOver

				if potion.onCooldown then
					potionThresholdColor = specCacheSettings.colors.threshold.unusable.color
					potionFrameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					if specCacheSettings.thresholds.potionCooldown.enabled then
						if specCacheSettings.thresholds.potionCooldown.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							potionCooldownThreshold = gcd * specCacheSettings.thresholds.potionCooldown.gcdsMax
						elseif specCacheSettings.thresholds.potionCooldown.mode == "time" then
							potionCooldownThreshold = specCacheSettings.thresholds.potionCooldown.timeMax
						end
					end
				end

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					pairOffset = (thresholdId - 1) * 3
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					local resourceAmount = 0

					if spell.attributes.isPotion then
						snapshot = snapshots[spells.algariManaPotionRank1.id]
						thresholdColor = potionThresholdColor
						frameLevel = potionFrameLevel
						if not potion.onCooldown or (potionCooldownThreshold > math.abs(potion.startTime + potion.duration - currentTime)) then
							local potionMana = CalculateManaGain(TRB.Data.character.items.potions[spell.settingKey].mana, true)
							resourceAmount = castingBarValue + potionMana
							if specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and resourceAmount < TRB.Data.character.maxResource then
							else
								showThreshold = false
							end
						else
							showThreshold = false
						end
					elseif spell.id == spells.shadowfiend.id then
						snapshot = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
						if talents:IsTalentActive(spell) and not snapshot.buff.isActive and specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and (not snapshot.cooldown:IsUnusable() or specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].cooldown) then
							local _, swingsRemaining, _, _, _ = snapshot:GetMaximumValues()
							local shadowfiendMana = swingsRemaining * snapshot.spell.attributes.resourcePercent * TRB.Data.character.maxResource

							resourceAmount = castingBarValue + shadowfiendMana
							if snapshot.cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end
	
							if not snapshot:IsAnyActive() and shadowfiendMana > 0 and resourceAmount < TRB.Data.character.maxResource then
							else
								showThreshold = false
							end
						else
							showThreshold = false
						end
					elseif spell.id == spells.symbolOfHope.id and talents:IsTalentActive(spell) then
						snapshot = snapshots[spells.symbolOfHope.id]
						local currentManaPercent = (currentResource / TRB.Data.character.maxResource) * 100
						if not snapshot.buff.isActive and currentManaPercent <= specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].minimumManaPercent and specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and (not snapshot.cooldown:IsUnusable() or specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].cooldown) then
							local symbolOfHopeMana = symbolOfHope:CalculateTime(spells.symbolOfHope.ticks+1, (spells.symbolOfHope.duration / (1 + ((snapshotData.attributes.haste or 0) / 100))) / spells.symbolOfHope.ticks, 0, true)

							resourceAmount = castingBarValue + symbolOfHopeMana
							if snapshot.cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end
	
							if symbolOfHopeMana > 0 and resourceAmount < TRB.Data.character.maxResource then
							else
								showThreshold = false
							end
						else
							showThreshold = false
						end
					elseif spell.id == spells.cannibalize.id then
						snapshot = snapshots[spells.cannibalize.id] --[[@as TRB.Classes.Healer.Cannibalize]]
						local cannibalizeTotal = CalculateManaGain(snapshot:GetMaxManaReturn())
						resourceAmount = castingBarValue + cannibalizeTotal
						if not snapshot.buff.isActive and TRB.Data.character.raceId == 5 and specCacheSettings.thresholds.thresholdDictionary["cannibalize"].enabled and resourceAmount < TRB.Data.character.maxResource and (not snapshot.cooldown.onCooldown or specCacheSettings.thresholds.thresholdDictionary["cannibalize"].cooldown) then
							if snapshot.cooldown.onCooldown then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end
						else
							showThreshold = false
						end
					else
						resourceAmount = spell:GetPrimaryResourceCost()
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, TRB.Data.character.maxResource)
				end

				local barColor = nil
				local holyWordCooldownCompletes = false
				local holyWordCooldownCompletesKey = nil

				if snapshotData.casting.spellKey ~= nil then
					local maybeHolyWordSpell = spells[snapshotData.casting.spellKey]--[[@as TRB.Classes.Priest.HolyWordSpell]]
					if maybeHolyWordSpell ~= nil and
						maybeHolyWordSpell.holyWordKey ~= nil and
						maybeHolyWordSpell.holyWordReduction ~= nil and
						maybeHolyWordSpell.holyWordReduction >= 0 and
						talents:IsTalentActive(spells[maybeHolyWordSpell.holyWordKey]) then

						local castTimeRemains = snapshotData.casting.endTime - currentTime
						local holyWordCooldownRemaining = snapshots[spells[maybeHolyWordSpell.holyWordKey].id].cooldown:GetRemainingTime(currentTime)
						local calcHolyWordCooldown = CalculateHolyWordCooldown(maybeHolyWordSpell.holyWordReduction, spells[snapshotData.casting.spellKey].id)

						if (holyWordCooldownRemaining - calcHolyWordCooldown - castTimeRemains) <= 0 then
							holyWordCooldownCompletes = true
							holyWordCooldownCompletesKey = maybeHolyWordSpell.holyWordKey
							if specSettings.colors.bar[maybeHolyWordSpell.holyWordKey .. "Enabled"] then
								barColor = specSettings.colors.bar[maybeHolyWordSpell.holyWordKey]
							end
						end
					end
				end

				if snapshots[spells.apotheosis.id].buff.isActive and barColor == nil then
					local timeThreshold = 0
					local useEndOfApotheosisColor = false

					if specSettings.endOfApotheosis.enabled then
						useEndOfApotheosisColor = true
						if specSettings.endOfApotheosis.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfApotheosis.gcdsMax
						elseif specSettings.endOfApotheosis.mode == "time" then
							timeThreshold = specSettings.endOfApotheosis.timeMax
						end
					end

					if useEndOfApotheosisColor and snapshots[spells.apotheosis.id].buff.remaining <= timeThreshold then
						barColor = specSettings.colors.bar.apotheosisEnd
					else
						barColor = specSettings.colors.bar.apotheosis
					end
				elseif barColor == nil then
					barColor = specSettings.colors.bar.base
				end

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)

				local cpBR, cpBG, cpBB, cpBA = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local cpBorderColor = specSettings.colors.comboPoints.border
				local cpColor = specSettings.colors.comboPoints.base
				local cpSacredReverenceColor = specSettings.colors.comboPoints.sacredReverence
				local cpCompleteColor = specSettings.colors.comboPoints.completeCooldown
				local currentCp = 1
				local srBuff = snapshots[spells.sacredReverence.id].buff
				
				for x = 1, 3, 1 do
					local spell
					local completes = false
					local holyWordBarsEnabled = false
					if x == 1 then
						spell = spells.holyWordSerenity
						cpColor = specSettings.colors.comboPoints.holyWordSerenity
						holyWordBarsEnabled = specSettings.colors.comboPoints.holyWordSerenityEnabled
					elseif x == 2 then
						spell = spells.holyWordSanctify
						cpColor = specSettings.colors.comboPoints.holyWordSanctify
						holyWordBarsEnabled = specSettings.colors.comboPoints.holyWordSanctifyEnabled
					else
						spell = spells.holyWordChastise
						cpColor = specSettings.colors.comboPoints.holyWordChastise
						holyWordBarsEnabled = specSettings.colors.comboPoints.holyWordChastiseEnabled
					end
					local cooldown = snapshots[spell.id].cooldown

					if specSettings.colors.comboPoints.completeCooldownEnabled and holyWordCooldownCompletes and spells[holyWordCooldownCompletesKey].id == spell.id then
						completes = true
					end

					if talents:IsTalentActive(spell) and holyWordBarsEnabled then
						local cp1Time = 1
						local cp1Duration = 1
						local cp1Color = cpColor
						local cp2Time = 1
						local cp2Duration = 1
						local cp2Color = cpColor
						local hasCp2 = false
						if cooldown.maxCharges == 2 then -- Miracle Worker for Serenity and Sanctify
							if cooldown.charges == 2 then
								cp1Time = 1
								cp1Duration = 1
								cp2Time = 1
								cp2Duration = 1
								hasCp2 = true
							elseif cooldown.charges == 1 then
								cp1Time = 1
								cp1Duration = 1
								cp2Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
								cp2Duration = cooldown.duration
								if completes then
									cp2Color = cpCompleteColor
								end
								hasCp2 = true
							else
								cp1Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
								cp1Duration = cooldown.duration
								if completes then
									cp1Color = cpCompleteColor
								end
								cp2Time = 0
								cp2Duration = 1
								hasCp2 = true
							end
						else -- Chastise or baseline Serenity and Sanctify
							hasCp2 = false
							if cooldown.onCooldown then
								cp1Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
								cp1Duration = cooldown.duration
								if completes then
									cp1Color = cpCompleteColor
								end
							else
								cp1Time = 1
								cp1Duration = 1
							end
						end
						
						if cp1Time < 0 then
							cp1Time = cp1Duration
						end

						if cp1Time == math.huge or cp1Duration == math.huge then
							cp1Time = 1
							cp1Duration = 1
						end

						if cp2Time < 0 then
							cp2Time = cp2Duration
						end

						if cp2Time == math.huge or cp2Duration == math.huge then
							cp2Time = 1
							cp2Duration = 1
						end
						
						if specSettings.colors.comboPoints.sacredReverenceEnabled and spell.id ~= spells.holyWordChastise.id and srBuff.isActive and cp1Time == cp1Duration and (not hasCp2 or srBuff.applications == 2 or (srBuff.applications == 1 and cp2Time < cp2Duration)) then
							cp1Color = cpSacredReverenceColor
						end

						local comboPointName = "comboPoint" .. currentCp
						TRB.Functions.Bar:SetValue(specCacheSettings, comboPointName, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp1Time, cp1Duration)
						TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].resourceFrame, comboPointName, cp1Color)
						TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].borderFrame, comboPointName, cpBorderColor)
						TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[currentCp].containerFrame, comboPointName, cpBR, cpBG, cpBB, cpBA)
						currentCp = currentCp + 1
	
						if hasCp2 then
							comboPointName = "comboPoint" .. currentCp
							TRB.Functions.Bar:SetValue(specCacheSettings, comboPointName, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp2Time, cp2Duration)
							TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].resourceFrame, comboPointName, cp2Color)
							TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[currentCp].borderFrame, comboPointName, cpBorderColor)
							TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[currentCp].containerFrame, comboPointName, cpBR, cpBG, cpBB, cpBA)
							currentCp = currentCp + 1
						end
					end
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local specSettings = classSettings.shadow
		local specCacheSettings = TRB.Data.specCache.shadow.settings
		UpdateSnapshot_Shadow()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor

				local passiveValue = 0
				local barBorderColor = specSettings.colors.bar.border
				local barColor = specSettings.colors.bar.base

				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					barBorderColor = specSettings.colors.bar.borderOvercap
					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					barBorderColor = specSettings.colors.bar.border
					snapshotData.audio.overcapCue = false
				end

				if specSettings.colors.bar.mindDevourer.enabled and snapshots[spells.mindDevourer.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.mindDevourer.color
				elseif specSettings.colors.bar.mindFlayInsanityBorderChange and snapshots[spells.mindFlayInsanity.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.borderMindFlayInsanity
				end

				if snapshotData.casting.spellId ~= nil and specSettings.colors.bar.showCasting  then
					castingBarValue = snapshotData.casting.resourceFinal + currentResource
				else
					castingBarValue = currentResource
				end

				local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
				if specSettings.colors.bar.showPassive and
					(talents:IsTalentActive(spells.auspiciousSpirits) or
					(shadowfiend.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal) > 0 or
					snapshots[spells.idolOfCthun.id].attributes.resourceFinal > 0) then
					passiveValue = ((CalculateResourceGain(spells.auspiciousSpirits.resource) * (snapshotData.targetData.custom.auspiciousSpiritsGenerate or 0)) + shadowfiend.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal + snapshots[spells.idolOfCthun.id].attributes.resourceFinal)
					TRB.Data.cache.values.threshold["shadowfiend"] = TRB.Data.cache.values.threshold["shadowfiend"] or {}
					local sfCache = TRB.Data.cache.values.threshold["shadowfiend"]
					if (shadowfiend.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal) > 0 and (castingBarValue + (shadowfiend.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal)) < TRB.Data.character.maxResource then
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, "shadowfiend", TRB.Frames.passiveFrame.thresholds[1], true, passiveFrame, (castingBarValue + (shadowfiend.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal)), TRB.Data.character.maxResource)
						
						if sfCache.color ~= specCacheSettings.colors.threshold.mindbender.color then
							TRB.Functions.Color:SetThresholdColor(TRB.Frames.passiveFrame.thresholds[1], specCacheSettings.colors.threshold.mindbender.color, true, 5, 3)
							sfCache.color = specCacheSettings.colors.threshold.mindbender.color
						end

						if sfCache.shown ~= true then
							TRB.Frames.passiveFrame.thresholds[1]:Show()
							sfCache.shown = true
						end
					elseif sfCache.shown ~= false then
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						sfCache.shown = false
					end
				else
					TRB.Frames.passiveFrame.thresholds[1]:Hide()
					passiveValue = 0
				end

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.settingKey == spells.devouringPlague--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount >= TRB.Data.character.maxResource then
								showThreshold = false
							elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and currentTime < snapshots[spells.mindDevourer.id].buff.endTime then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.settingKey == spells.devouringPlague2--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount >= TRB.Data.character.maxResource then
								showThreshold = false
							elseif snapshots[spells.mindDevourer.id].buff.isActive and
								currentResource >= spells.devouringPlague:GetPrimaryResourceCost() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif specCacheSettings.thresholds.specProperties.devouringPlagueThresholdOnlyOverShow and
									spells.devouringPlague:GetPrimaryResourceCost() > currentResource  then
								showThreshold = false
							elseif currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.settingKey == spells.devouringPlague3--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount >= TRB.Data.character.maxResource then
								showThreshold = false
							elseif snapshots[spells.mindDevourer.id].buff.isActive and
								currentResource >= spells.devouringPlague2:GetPrimaryResourceCost() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif specCacheSettings.thresholds.specProperties.devouringPlagueThresholdOnlyOverShow and
								spells.devouringPlague2:GetPrimaryResourceCost() > currentResource then
								showThreshold = false
							elseif currentResource >= resourceAmount then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
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
						if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, TRB.Data.character.maxResource)
				end

				if snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= spells.devouringPlague:GetPrimaryResourceCost() or snapshots[spells.mindDevourer.id].buff.isActive then
					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barContainerFrame:SetAlpha(1.0)
					end

					if snapshots[spells.mindDevourer.id].buff.isActive and specSettings.audio.mdProc.enabled and snapshotData.audio.playedMdCue == false then
						snapshotData.audio.playedDpCue = true
						snapshotData.audio.playedMdCue = true
						PlaySoundFile(specSettings.audio.mdProc.sound, coreSettings.audio.channel.channel)
					elseif specSettings.audio.dpReady.enabled and snapshotData.audio.playedDpCue == false then
						snapshotData.audio.playedDpCue = true
						PlaySoundFile(specSettings.audio.dpReady.sound, coreSettings.audio.channel.channel)
					end
				else
					barContainerFrame:SetAlpha(1.0)
					snapshotData.audio.playedDpCue = false
					snapshotData.audio.playedMdCue = false
				end

				passiveBarValue = castingBarValue + passiveValue

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				end

				if snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= spells.devouringPlague:GetPrimaryResourceCost() then
					castingBarColor = specSettings.colors.bar.devouringPlagueUsableCasting
				else
					castingBarColor = specSettings.colors.bar.casting
				end

				if specSettings.colors.bar.instantMindBlast.enabled and snapshots[spells.mindBlast.id].cooldown.charges > 0 and snapshots[spells.shadowyInsight.id].buff.isActive then
					barColor = specSettings.colors.bar.instantMindBlast.color
				elseif snapshots[spells.voidform.id].buff.isActive or snapshots[spells.darkAscension.id].buff.isActive then
					local timeLeft = snapshots[spells.voidform.id].buff.remaining
					if snapshots[spells.darkAscension.id].buff.isActive then
						timeLeft = snapshots[spells.darkAscension.id].buff.remaining
					end
					local timeThreshold = 0
					local useEndOfVoidformColor = false

					if specSettings.endOfVoidform.enabled then
						useEndOfVoidformColor = true
						if specSettings.endOfVoidform.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfVoidform.gcdsMax
						elseif specSettings.endOfVoidform.mode == "time" then
							timeThreshold = specSettings.endOfVoidform.timeMax
						end
					end

					if useEndOfVoidformColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.inVoidform1GCD
					elseif snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= spells.devouringPlague:GetPrimaryResourceCost() then
						barColor = specSettings.colors.bar.devouringPlagueUsable
					else
						barColor = specSettings.colors.bar.inVoidform
					end
				else
					if snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= spells.devouringPlague:GetPrimaryResourceCost() then
						barColor = specSettings.colors.bar.devouringPlagueUsable
					else
						barColor = specSettings.colors.bar.base
					end
				end
				
				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local currentTime = GetTime()
		local _
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

		local settings
		if TRB.Data.character.specId == 1 then
			settings = TRB.Data.settings.priest.discipline
			spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		elseif TRB.Data.character.specId == 2 then
			settings = TRB.Data.settings.priest.holy
			spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		elseif TRB.Data.character.specId == 3 then
			settings = TRB.Data.settings.priest.shadow
			spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if (TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (TRB.Data.character.specId == 2 and TRB.Data.barConstructedForSpec == "holy") then -- Let's check raid effect mana stuff
				if settings.passiveGeneration.symbolOfHope and (entry.spellId == spells.symbolOfHope.tickId or entry.spellId == spells.symbolOfHope.id) then
					local castByToken = UnitTokenFromGUID(entry.sourceGuid)
					local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
					symbolOfHope.buff:Initialize(entry.type, nil, castByToken)
				elseif settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
					local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					innervate.buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						snapshotData.audio.innervateCue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.innervateCue = false
					end
				elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
					local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
					manaTideTotem.buff:Initialize(entry.type)
				elseif entry.spellId == spells.potionOfChilledClarity.id then
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					potionOfChilledClarity.buff:Initialize(entry.type)
				elseif entry.spellId == spells.moltenRadiance.id then
					local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					moltenRadiance.buff:Initialize(entry.type)
				elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
					local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
					blessingOfWinter.buff:Initialize(entry.type)
				elseif entry.spellId == spells.cannibalize.buffId then
					local cannibalize = snapshots[spells.cannibalize.id] --[[@as TRB.Classes.Healer.Cannibalize]]
					cannibalize.buff:Initialize(entry.type)
				elseif entry.type == "SPELL_ENERGIZE" and entry.spellId == snapshots[spells.shadowfiend.id].spell.energizeId then
					local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
					shadowfiend:LogSwingTime(entry.sourceGuid, currentTime)
				end
			elseif TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
				if entry.type == "SPELL_ENERGIZE" and (entry.spellId == spells.mindbender.energizeId or entry.spellId == spells.shadowfiend.energizeId or entry.spellId == spells.voidwraith.energizeId) then
					local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
					shadowfiend:LogSwingTime(entry.sourceGuid, currentTime)
				end
			end
		end
		
		if entry.sourceGuid == TRB.Data.character.guid then
			if (TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (TRB.Data.character.specId == 2 and TRB.Data.barConstructedForSpec == "holy") then -- Let's check raid effect mana stuff
				if entry.spellId == spells.slumberingSoulSerumRank1.spellId or entry.spellId == spells.slumberingSoulSerumRank2.spellId or entry.spellId == spells.slumberingSoulSerumRank3.spellId then
					local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
					channeledManaPotion.buff:Initialize(entry.type)
				elseif entry.spellId == spells.surgeOfLight.id then
					if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
						snapshotData.audio.surgeOfLight2Cue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.surgeOfLightCue = false
						snapshotData.audio.surgeOfLight2Cue = false
					end
				elseif entry.spellId == spells.cannibalize.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				end
			end

			if TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "discipline" then
				if entry.spellId == spells.atonement.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid, true, true) then
						targetData:HandleCombatLogBuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.powerWordRadiance.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast PW: Radiance
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.evangelism.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast PW: Radiance
						local targets = TRB.Data.snapshotData.targetData.targets
						for _, target in pairs(targets) do
							if target.spells[spells.atonement.id].active and target.spells[spells.atonement.id].endTime ~= nil then
								target.spells[spells.atonement.id].endTime = target.spells[spells.atonement.id].endTime + spells.evangelism.attributes.atonementMod
								target.spells[spells.atonement.id].remainingTime = target.spells[spells.atonement.id].remainingTime + spells.evangelism.attributes.atonementMod
							end
						end
					end
				end
			elseif TRB.Data.character.specId == 2 and TRB.Data.barConstructedForSpec == "holy" then
				if entry.spellId == spells.holyWordSerenity.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast HW: Serenity
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.holyWordSanctify.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast HW: Sanctify
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.holyWordChastise.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast HW: Chastise
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.symbolOfHope.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				end
			elseif TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
				if entry.spellId == spells.vampiricTouch.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.devouringPlague.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif settings.auspiciousSpiritsTracker and talents:IsTalentActive(spells.auspiciousSpirits) and entry.spellId == spells.auspiciousSpirits.attributes.idSpawn and entry.type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
					for guid, _ in pairs(targetData.targets) do
						if targetData.targets[guid].spells[spells.vampiricTouch.id].active then
							targetData.targets[guid].spells[spells.auspiciousSpirits.id].active = true
							targetData.targets[guid].spells[spells.auspiciousSpirits.id].count = targetData.targets[guid].spells[spells.auspiciousSpirits.id].count + 1
							targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] + 1
						end
					end
				elseif settings.auspiciousSpiritsTracker and talents:IsTalentActive(spells.auspiciousSpirits) and entry.spellId == spells.auspiciousSpirits.attributes.idImpact and (entry.type == "SPELL_DAMAGE" or entry.type == "SPELL_MISSED" or entry.type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
					if targetData:CheckTargetExists(entry.destinationGuid) then
						targetData.targets[entry.destinationGuid].spells[spells.auspiciousSpirits.id].count = targetData.targets[entry.destinationGuid].spells[spells.auspiciousSpirits.id].count - 1
						targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] - 1
					end
				elseif entry.type == "SPELL_ENERGIZE" and (entry.spellId == spells.shadowCrash.id or entry.spellId == spells.voidCrash.id) then
				elseif entry.spellId == spells.powerInfusion.id then
					if entry.type == "SPELL_AURA_APPLIED" then
						if TRB.Data.settings.priest.shadow.audio.powerInfusion.enabled then
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.powerInfusion.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif entry.type == "SPELL_SUMMON" and settings.voidTendrilTracker and (entry.spellId == spells.idolOfCthun_Tendril.id or entry.spellId == spells.idolOfCthun_Lasher.id) then
					InitializeVoidTendril(entry.destinationGuid)
					if entry.spellId == spells.idolOfCthun_Tendril.id then
						snapshots[spells.idolOfCthun.id].attributes.activeList[entry.destinationGuid].type = "Tendril"
					elseif entry.spellId == spells.idolOfCthun_Lasher.id then
						snapshots[spells.idolOfCthun.id].attributes.activeList[entry.destinationGuid].type = "Lasher"
						snapshots[spells.idolOfCthun.id].attributes.activeList[entry.destinationGuid].targetsHit = 0
						snapshots[spells.idolOfCthun.id].attributes.activeList[entry.destinationGuid].hasStruckTargets = true
					end

					snapshots[spells.idolOfCthun.id].attributes.numberActive = snapshots[spells.idolOfCthun.id].attributes.numberActive + 1
					snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining + spells.lashOfInsanity_Tendril.ticks
					snapshots[spells.idolOfCthun.id].attributes.activeList[entry.destinationGuid].startTime = currentTime
					snapshots[spells.idolOfCthun.id].attributes.activeList[entry.destinationGuid].tickTime = currentTime
				elseif entry.spellId == spells.resonantEnergy.debuffId then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				end
			end

			-- Voidweaver
			if (TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "shadow") then
				if entry.spellId == spells.entropicRift.id then
					if entry.type == "UNIT_DIED" then
						snapshots[entry.spellId]:Reset()
					elseif entry.type == "SPELL_SUMMON" then
						C_Timer.After(0, function()
							C_Timer.After(0.1, function()
								for x = 1, 5 do
									local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
									if shadowfiend.spawns[x].guid == nil then
										local haveTotem, name, startTime, duration, _ = GetTotemInfo(x)
										if haveTotem then
											if name == spells.entropicRift.name then
												snapshots[entry.spellId].attributes.guid = entry.destinationGuid
												snapshots[entry.spellId].attributes.totemId = x
												snapshots[entry.spellId].buff:InitializeCustom(duration, startTime)
												break
											end
										end
									end
								end
							end)
						end)
					end
					snapshots[entry.spellId].buff:RequestRefresh(GetTime() + 0.05)
				end
			end

			-- Spec agnostic
			if entry.spellId == spells.shadowWordPain.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			elseif 	entry.type == "SPELL_SUMMON" and
					((TRB.Data.character.specId == 3 and settings.mindbender.enabled) or (TRB.Data.character.specId ~= 3 and settings.shadowfiend.enabled))
					and (entry.spellId == spells.shadowfiend.id or (TRB.Data.character.specId ~= 2 and (entry.spellId == spells.mindbender.id or entry.spellId == spells.voidwraith.id))) then
				local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]

				C_Timer.After(0, function()
					C_Timer.After(0.1, function()
						local haveTotem, name
						for x = 1, #shadowfiend.spawns do
							if shadowfiend.spawns[x].guid == nil then
								haveTotem, name, _, _, _ = GetTotemInfo(x)
								if haveTotem then
									if TRB.Data.character.specId == 2 and name ~= spells.lightwell.name then
										shadowfiend.spawns[x]:Activate(entry.spellId, entry.destinationGuid, currentTime)
										break
									elseif (TRB.Data.character.specId == 1 or TRB.Data.character.specId == 3) and name ~= spells.entropicRift.name then
										shadowfiend.spawns[x]:Activate(entry.spellId, entry.destinationGuid, currentTime)
										break
									end
								end
							end
						end
					end)
				end)
			end
		elseif TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "shadow" and settings.voidTendrilTracker and (entry.spellId == spells.idolOfCthun_Tendril.tickId or entry.spellId == spells.idolOfCthun_Lasher.tickId) and CheckVoidTendrilExists(entry.sourceGuid) then
			if entry.spellId == spells.idolOfCthun_Lasher.tickId and entry.type == "SPELL_DAMAGE" then
				if currentTime > (snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].tickTime + 0.1) then --This is a new tick
					snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].targetsHit = 0
				end
				snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].targetsHit = snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].targetsHit + 1
				snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].tickTime = currentTime
				snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].hasStruckTargets = true
			else
				snapshots[spells.idolOfCthun.id].attributes.activeList[entry.sourceGuid].tickTime = currentTime
			end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			if targetData:Remove(entry.destinationGuid) then
				RefreshTargetTracking()
			end
		end
	end
end)

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization() or 0

	if TRB.Data.character.specId == 1 then
		specCache.discipline.talents:GetTalents()
		FillSpellData_Discipline()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.discipline)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.shadowWordPain)
		targetData:AddSpellTracking(spells.atonement)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Discipline
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.discipline.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.discipline)

		local lookup = TRB.Data.lookup or {}
		lookup["#atonement"] = spells.atonement.icon
		lookup["#pwRadiance"] = spells.powerWordRadiance.icon
		lookup["#radiance"] = spells.powerWordRadiance.icon
		lookup["#powerWordRadiance"] = spells.powerWordRadiance.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#sc"] = spells.shadowCovenant.icon
		lookup["#shadowCovenant"] = spells.shadowCovenant.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
		lookup["#bow"] = spells.blessingOfWinter.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#sol"] = spells.surgeOfLight.icon
		lookup["#surgeOfLight"] = spells.surgeOfLight.icon
		lookup["#amp"] = spells.algariManaPotionRank1.icon
		lookup["#algariManaPotion"] = spells.algariManaPotionRank1.icon
		lookup["#poff"] = spells.slumberingSoulSerumRank1.icon
		lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#entropicRift"] = spells.entropicRift.icon
		
		if specCache.discipline.talents:IsTalentActive(spells.voidwraith) then
			lookup["#sf"] = spells.voidwraith.icon
			lookup["#mindbender"] = spells.voidwraith.icon
			lookup["#shadowfiend"] = spells.voidwraith.icon
			lookup["#voidwraith"] = spells.voidwraith.icon
		else
			if specCache.discipline.talents:IsTalentActive(spells.mindbender) then
				lookup["#sf"] = spells.mindbender.icon
				lookup["#mindbender"] = spells.mindbender.icon
				lookup["#shadowfiend"] = spells.mindbender.icon
				lookup["#voidwraith"] = spells.mindbender.icon
			else
				lookup["#sf"] = spells.shadowfiend.icon
				lookup["#mindbender"] = spells.shadowfiend.icon
				lookup["#shadowfiend"] = spells.shadowfiend.icon
				lookup["#voidwraith"] = spells.shadowfiend.icon
			end
		end

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		talents = specCache.discipline.talents
		TRB.Data.barConstructedForSpec = "discipline"
		ConstructResourceBar(specCache.discipline.settings)
	elseif TRB.Data.character.specId == 2 then
		specCache.holy.talents:GetTalents()
		FillSpellData_Holy()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.shadowWordPain)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.holy.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.holy)

		local lookup = TRB.Data.lookup or {}
		lookup["#answeredPrayers"] = spells.answeredPrayers.icon
		lookup["#apotheosis"] = spells.apotheosis.icon
		lookup["#flashHeal"] = spells.flashHeal.icon
		lookup["#heal"] = spells.heal.icon
		lookup["#hf"] = spells.holyFire.icon
		lookup["#holyFire"] = spells.holyFire.icon
		lookup["#hwChastise"] = spells.holyWordChastise.icon
		lookup["#chastise"] = spells.holyWordChastise.icon
		lookup["#holyWordChastise"] = spells.holyWordChastise.icon
		lookup["#hwSanctify"] = spells.holyWordSanctify.icon
		lookup["#sanctify"] = spells.holyWordSanctify.icon
		lookup["#holyWordSanctify"] = spells.holyWordSanctify.icon
		lookup["#hwSerenity"] = spells.holyWordSerenity.icon
		lookup["#serenity"] = spells.holyWordSerenity.icon
		lookup["#holyWordSerenity"] = spells.holyWordSerenity.icon
		lookup["#lightweaver"] = spells.lightweaver.icon
		lookup["#rw"] = spells.resonantWords.icon
		lookup["#resonantWords"] = spells.resonantWords.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#lotn"] = spells.lightOfTheNaaru.icon
		lookup["#lightOfTheNaaru"] = spells.lightOfTheNaaru.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
		lookup["#bow"] = spells.blessingOfWinter.icon
		lookup["#poh"] = spells.prayerOfHealing.icon
		lookup["#prayerOfHealing"] = spells.prayerOfHealing.icon
		lookup["#smite"] = spells.smite.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#sol"] = spells.surgeOfLight.icon
		lookup["#surgeOfLight"] = spells.surgeOfLight.icon
		lookup["#amp"] = spells.algariManaPotionRank1.icon
		lookup["#algariManaPotion"] = spells.algariManaPotionRank1.icon
		lookup["#poff"] = spells.slumberingSoulSerumRank1.icon
		lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#sacredReverence"] = spells.sacredReverence.icon
		lookup["#sf"] = spells.shadowfiend.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		talents = specCache.holy.talents
		TRB.Data.barConstructedForSpec = "holy"
		ConstructResourceBar(specCache.holy.settings)
	elseif TRB.Data.character.specId == 3 then
		specCache.shadow.talents:GetTalents()
		FillSpellData_Shadow()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.shadow)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.auspiciousSpirits, false, true)
		targetData:AddSpellTracking(spells.devouringPlague)
		targetData:AddSpellTracking(spells.shadowWordPain)
		targetData:AddSpellTracking(spells.vampiricTouch)
		targetData:AddSpellTracking(spells.resonantEnergy)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.shadow.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.shadow)

		local lookup = {}
		lookup["#as"] = spells.auspiciousSpirits.icon
		lookup["#auspiciousSpirits"] = spells.auspiciousSpirits.icon
		lookup["#sa"] = spells.shadowyApparition.icon
		lookup["#shadowyApparition"] = spells.shadowyApparition.icon
		lookup["#mb"] = spells.mindBlast.icon
		lookup["#mindBlast"] = spells.mindBlast.icon
		lookup["#mf"] = spells.mindFlay.icon
		lookup["#mindFlay"] = spells.mindFlay.icon
		lookup["#mfi"] = spells.mindFlayInsanity.icon
		lookup["#mindFlayInsanity"] = spells.mindFlayInsanity.icon
		lookup["#mindgames"] = spells.mindgames.icon
		lookup["#vf"] = spells.voidform.icon
		lookup["#voidform"] = spells.voidform.icon
		lookup["#vb"] = spells.voidBolt.icon
		lookup["#voidBolt"] = spells.voidBolt.icon
		lookup["#voit"] = spells.voidTorrent.icon
		lookup["#voidTorrent"] = spells.voidTorrent.icon
		lookup["#vt"] = spells.vampiricTouch.icon
		lookup["#vampiricTouch"] = spells.vampiricTouch.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#dp"] = spells.devouringPlague.icon
		lookup["#devouringPlague"] = spells.devouringPlague.icon
		lookup["#mDev"] = spells.mindDevourer.icon
		lookup["#mindDevourer"] = spells.mindDevourer.icon
		lookup["#tof"] = spells.twistOfFate.icon
		lookup["#twistOfFate"] = spells.twistOfFate.icon
		lookup["#si"] = spells.shadowyInsight.icon
		lookup["#shadowyInsight"] = spells.shadowyInsight.icon
		lookup["#mm"] = spells.shatteredPsyche.icon
		lookup["#mindMelt"] = spells.shatteredPsyche.icon
		lookup["#sp"] = spells.shatteredPsyche.icon
		lookup["#shatteredPsyche"] = spells.shatteredPsyche.icon
		lookup["#ys"] = spells.idolOfYoggSaron.icon
		lookup["#idolOfYoggSaron"] = spells.idolOfYoggSaron.icon
		lookup["#tfb"] = spells.thingFromBeyond.icon
		lookup["#thingFromBeyond"] = spells.thingFromBeyond.icon
		lookup["#md"] = spells.massDispel.icon
		lookup["#massDispel"] = spells.massDispel.icon
		lookup["#cthun"] = spells.idolOfCthun.icon
		lookup["#idolOfCthun"] = spells.idolOfCthun.icon
		lookup["#loi"] = spells.idolOfCthun.icon
		lookup["#halo"] = spells.halo.icon
		lookup["#entropicRift"] = spells.entropicRift.icon

		if specCache.shadow.talents:IsTalentActive(spells.voidwraith) then
			lookup["#sf"] = spells.voidwraith.icon
			lookup["#mindbender"] = spells.voidwraith.icon
			lookup["#shadowfiend"] = spells.voidwraith.icon
			lookup["#voidwraith"] = spells.voidwraith.icon
		else	
			if specCache.shadow.talents:IsTalentActive(spells.mindbender) then
				lookup["#sf"] = spells.mindbender.icon
				lookup["#mindbender"] = spells.mindbender.icon
				lookup["#shadowfiend"] = spells.mindbender.icon
				lookup["#voidwraith"] = spells.mindbender.icon
			else
				lookup["#sf"] = spells.shadowfiend.icon
				lookup["#mindbender"] = spells.shadowfiend.icon
				lookup["#shadowfiend"] = spells.shadowfiend.icon
				lookup["#voidwraith"] = spells.shadowfiend.icon
			end
		end

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		talents = specCache.shadow.talents
		TRB.Data.barConstructedForSpec = "shadow"
		ConstructResourceBar(specCache.shadow.settings)
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

	TRB.Functions.Class:EventRegistration()
end

resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end

	if TRB.Data.character.classId == 5 then
		if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Priest.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.discipline == nil or
						TwintopInsanityBarSettings.priest.discipline.displayText == nil then
						settings.priest.discipline.displayText.barText = TRB.Options.Priest.DisciplineLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.holy == nil or
						TwintopInsanityBarSettings.priest.holy.displayText == nil then
						settings.priest.holy.displayText.barText = TRB.Options.Priest.HolyLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.shadow == nil or
						TwintopInsanityBarSettings.priest.shadow.displayText == nil then
						settings.priest.shadow.displayText.barText = TRB.Options.Priest.ShadowLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Priest.LoadDefaultSettings(true)
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
						TRB.Data.settings.priest.discipline = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestDisciplineFull"], TRB.Data.settings.priest.discipline)
						TRB.Data.settings.priest.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestHolyFull"], TRB.Data.settings.priest.holy)
						TRB.Data.settings.priest.shadow = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestShadowFull"], TRB.Data.settings.priest.shadow)
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Priest.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "priest"
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		TRB.Data.character.specName = "discipline"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
		local settings = TRB.Data.settings.priest.discipline
		TRB.Data.character.items.alchemyStone = spells.alchemistStone.attributes.isAlchemistStoneEquipped()

		if talents:IsTalentActive(spells.voidwraith) then
			snapshots[spells.shadowfiend.id].spell = spells.voidwraith
		else
			if talents:IsTalentActive(spells.mindbender) then
				snapshots[spells.shadowfiend.id].spell = spells.mindbender
			else
				snapshots[spells.shadowfiend.id].spell = spells.shadowfiend
			end
		end
		
		local totalPowerWordCharges = 0
		
		if talents:IsTalentActive(spells.powerWordRadiance) and settings.colors.comboPoints.powerWordRadianceEnabled then
			totalPowerWordCharges = totalPowerWordCharges + 1
			if talents:IsTalentActive(spells.lightsPromise) then
				totalPowerWordCharges = totalPowerWordCharges + 1
			end
		end
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	
		if sharedSettings ~= nil then
			if totalPowerWordCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = totalPowerWordCharges
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		TRB.Data.character.specName = "holy"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
		local settings = TRB.Data.settings.priest.holy
		TRB.Data.character.items.alchemyStone = spells.alchemistStone.attributes.isAlchemistStoneEquipped()
		

		local totalHolyWordCharges = 0
		
		if talents:IsTalentActive(spells.holyWordSerenity) and settings.colors.comboPoints.holyWordSerenityEnabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
			if talents:IsTalentActive(spells.miracleWorker) then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end
		end
		
		if talents:IsTalentActive(spells.holyWordSanctify) and settings.colors.comboPoints.holyWordSanctifyEnabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
			if talents:IsTalentActive(spells.miracleWorker) then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end
		end
		
		if talents:IsTalentActive(spells.holyWordChastise) and settings.colors.comboPoints.holyWordChastiseEnabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
		end
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	
		if sharedSettings ~= nil then
			if totalHolyWordCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = totalHolyWordCharges
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		TRB.Data.character.specName = "shadow"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity)
		
		if talents:IsTalentActive(spells.voidwraith) then
			snapshots[spells.shadowfiend.id].spell = spells.voidwraith
		else
			if talents:IsTalentActive(spells.mindbender) then
				snapshots[spells.shadowfiend.id].spell = spells.mindbender
			else
				snapshots[spells.shadowfiend.id].spell = spells.shadowfiend
			end
		end
		
		local twwSeason2SetBonus = spells.twwSeason2SetBonus

		local headItemLink = GetInventoryItemLink("player", 1)
		local shoulderItemLink = GetInventoryItemLink("player", 3)
		local chestItemLink = GetInventoryItemLink("player", 5)
		local handItemLink = GetInventoryItemLink("player", 10)
		local legItemLink = GetInventoryItemLink("player", 7)

		local twwSeason2SetBonusCount = 0
		if TRB.Functions.Item:DoesItemLinkMatchId(headItemLink, twwSeason2SetBonus.attributes.headId) then
			twwSeason2SetBonusCount = twwSeason2SetBonusCount + 1
		end
		if TRB.Functions.Item:DoesItemLinkMatchId(shoulderItemLink, twwSeason2SetBonus.attributes.shoulderId) then
			twwSeason2SetBonusCount = twwSeason2SetBonusCount + 1
		end
		if TRB.Functions.Item:DoesItemLinkMatchId(chestItemLink, twwSeason2SetBonus.attributes.chestId) then
			twwSeason2SetBonusCount = twwSeason2SetBonusCount + 1
		end
		if TRB.Functions.Item:DoesItemLinkMatchId(handItemLink, twwSeason2SetBonus.attributes.handId) then
			twwSeason2SetBonusCount = twwSeason2SetBonusCount + 1
		end
		if TRB.Functions.Item:DoesItemLinkMatchId(legItemLink, twwSeason2SetBonus.attributes.legId) then
			twwSeason2SetBonusCount = twwSeason2SetBonusCount + 1
		end

		TRB.Data.character.items.twwSeason2SetBonusCount = twwSeason2SetBonusCount
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.priest.discipline == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana

		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.priest.shadow == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Insanity
		TRB.Data.resourceFactor = 100
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then

		local notZeroShowValue = TRB.Data.character.maxResource
		if TRB.Data.character.specId == 3 then
			notZeroShowValue = 0
		end
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		TRB.Functions.Bar:HideResourceBarGeneric(sharedSettings, force, notZeroShowValue)
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end
function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local spells = spellsData.spells
	local settings = nil
	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.priest.discipline
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.priest.holy
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.priest.shadow
	else
		return false
	end

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HealerSpells]]
		if var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$manaTotal" then
			valid = true
		elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
			valid = true
		elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$sohMana" then
			local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
			if symbolOfHope.buff.isActive then
				valid = true
			end
		elseif var == "$sohTime" then
			local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
			if symbolOfHope.buff.isActive then
				valid = true
			end
		elseif var == "$sohTicks" then
			local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
			if symbolOfHope.buff.isActive then
				valid = true
			end
		elseif var == "$innervateMana" then
			local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
			if innervate.buff.isActive then
				valid = true
			end
		elseif var == "$innervateTime" then
			local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
			if innervate.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfChilledClarityMana" then
			local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
			if potionOfChilledClarity.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfChilledClarityTime" then
			local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
			if potionOfChilledClarity.buff.isActive then
				valid = true
			end
		elseif var == "$mttMana" then
			local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
			if manaTideTotem.buff.isActive then
				valid = true
			end
		elseif var == "$mttTime" then
			local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
			if manaTideTotem.buff.isActive then
				valid = true
			end
		elseif var == "$mrMana" then
			local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$mrTime" then
			local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$bowMana" then
			local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$bowTime" then
			local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$bowTicks" then
			local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$channeledMana" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$slumberingSoulSerumTicks" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$slumberingSoulSerumTime" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionCooldown" then
			if snapshots[spells.algariManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		elseif var == "$potionCooldownSeconds" then
			if snapshots[spells.algariManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		elseif var == "$solStacks" then
			if snapshots[spells.surgeOfLight.id].buff.isActive then
				valid = true
			end
		elseif var == "$solTime" then
			if snapshots[spells.surgeOfLight.id].buff.isActive then
				valid = true
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		if var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
				valid = true
			end
		elseif var == "$pwRadianceTime" or var == "$radianceTime" or var == "$powerWordRadianceTime" then
			if snapshots[spells.powerWordRadiance.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$pwRadianceCharges" or var == "$radianceCharges" or var == "$powerWordRadianceCharges" then
			if snapshots[spells.powerWordRadiance.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$scTime" or var == "$shadowCovenantTime" then
			if snapshots[spells.shadowCovenant.id].buff.isActive then
				valid = true
			end
		elseif var == "$atonementCount" then
			if snapshotData.targetData.count[spells.atonement.id] > 0 then
				valid = true
			end
		elseif var == "$atonementTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitIsFriend("player", "target") and
				target ~= nil and
				((target.spells[spells.atonement.id] ~= nil and
				target.spells[spells.atonement.id].remainingTime > 0)) then
				valid = true
			end
		elseif var == "$atonementMinTime" then
			if snapshots[spells.atonement.id].attributes.minRemainingTime > 0 then
				valid = true
			end
		elseif var == "$atonementMaxTime" then
			if snapshots[spells.atonement.id].attributes.maxRemainingTime > 0 then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		if var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
				valid = true
			end
		elseif var == "$lightweaverTime" then
			if snapshots[spells.lightweaver.id].buff.isActive then
				valid = true
			end
		elseif var == "$lightweaverStacks" then
			if snapshots[spells.lightweaver.id].buff.isActive then
				valid = true
			end
		elseif var == "$rwTime" then
			if snapshots[spells.resonantWords.id].buff.isActive then
				valid = true
			end
		elseif var == "$apotheosisTime" then
			if snapshots[spells.apotheosis.id].buff.isActive then
				valid = true
			end
		elseif var == "$answeredPrayersStacks" then
			if snapshots[spells.answeredPrayers.id].buff.isActive then
				valid = true
			end
		elseif var == "$answeredPrayersMaxStacks" then
			if spells.answeredPrayers.attributes.maxStackRank[talents.talents[spells.answeredPrayers.talentId].currentRank] > 0 then
				valid = true
			end
		elseif var == "$answeredPrayersRemainingStacks" then
			if spells.answeredPrayers.attributes.maxStackRank[talents.talents[spells.answeredPrayers.talentId].currentRank] > 0 then
				valid = true
			end
		elseif var == "$hwChastiseTime" or var == "$chastiseTime" or var == "$holyWordChastiseTime" then
			if snapshots[spells.holyWordChastise.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$hwSerenityTime" or var == "$serenityTime" or var == "$holyWordSerenityTime" then
			if snapshots[spells.holyWordSerenity.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$hwSanctifyTime" or var == "$sanctifyTime" or var == "$holyWordSanctifyTime" then
			if snapshots[spells.holyWordSanctify.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$hwChastiseCharges" or var == "$chastiseCharges" or var == "$holyWordChastiseCharges" then
			if snapshots[spells.holyWordChastise.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$hwSerenityCharges" or var == "$serenityCharges" or var == "$holyWordSerenityCharges" then
			if snapshots[spells.holyWordSerenity.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$sacredReverenceStacks" then
			if snapshots[spells.sacredReverence.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		if var == "$vfTime" then
			if (snapshots[spells.voidform.id].buff.remaining ~= nil and snapshots[spells.voidform.id].buff.remaining > 0) or
				(snapshots[spells.darkAscension.id].buff.remaining ~= nil and snapshots[spells.darkAscension.id].buff.remaining > 0) then
				valid = true
			end
		elseif var == "$resource" or var == "$insanity" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$insanityMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$insanityTotal" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) or
				(((CalculateResourceGain(spells.auspiciousSpirits.resource) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + shadowfiend.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0) then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
			local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) <= threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed <= threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if snapshotData.attributes.resource > 0 or
				((CalculateResourceGain(spells.auspiciousSpirits.resource) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + shadowfiend.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$passive" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if ((CalculateResourceGain(spells.auspiciousSpirits.resource) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + shadowfiend.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0 then
				valid = true
			end
		elseif var == "$mbInsanity" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if shadowfiend.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$mbGcds" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if shadowfiend.remainingGcds > 0 then
				valid = true
			end
		elseif var == "$mbSwings" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if shadowfiend.remainingSwings > 0 then
				valid = true
			end
		elseif var == "$mbTime" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if shadowfiend.remainingTime > 0 then
				valid = true
			end
		elseif var == "$mbCount" then
			local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
			if shadowfiend:IsAnyActive() then
				valid = true
			end
		elseif var == "$loiInsanity" then
			if snapshots[spells.idolOfCthun.id].attributes.resourceFinal > 0 then
				valid = true
			end
		elseif var == "$loiTicks" then
			if snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining > 0 then
				valid = true
			end
		elseif var == "$cttvEquipped" then
			if TRB.Data.settings.priest.shadow.voidTendrilTracker and (talents:IsTalentActive(spells.idolOfCthun)) then
				valid = true
			end
		elseif var == "$ecttvCount" then
			if TRB.Data.settings.priest.shadow.voidTendrilTracker and snapshots[spells.idolOfCthun.id].attributes.numberActive > 0 then
				valid = true
			end
		elseif var == "$asCount" then
			if snapshotData.targetData.count[spells.auspiciousSpirits.id] > 0 then
				valid = true
			end
		elseif var == "$asInsanity" then
			if snapshotData.targetData.count[spells.auspiciousSpirits.id] > 0 then
				valid = true
			end
		elseif var == "$vtCount" then
			if snapshotData.targetData.count[spells.vampiricTouch.id] > 0 then
				valid = true
			end
		elseif var == "$vtTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.vampiricTouch.id] ~= nil and
				target.spells[spells.vampiricTouch.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$dpCount" then
			if snapshotData.targetData.count[spells.devouringPlague.id] > 0 then
				valid = true
			end
		elseif var == "$dpTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.devouringPlague.id] ~= nil and
				target.spells[spells.devouringPlague.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$mdTime" then
			if snapshots[spells.mindDevourer.id].buff.isActive then
				valid = true
			end
		elseif var == "$mfiTime" then
			if snapshots[spells.mindFlayInsanity.id].buff.isActive then
				valid = true
			end
		elseif var == "$mfiStacks" then
			if snapshots[spells.mindFlayInsanity.id].buff.isActive then
				valid = true
			end
		elseif var == "$tofTime" then
			if snapshots[spells.twistOfFate.id].buff.isActive then
				valid = true
			end
		elseif var == "$siTime" then
			if snapshots[spells.shadowyInsight.id].buff.isActive then
				valid = true
			end
		elseif var == "$mmTime" or "$spTime" then
			if snapshots[spells.shatteredPsyche.id].buff.isActive then
				valid = true
			end
		elseif var == "$mmStacks" or "$spStacks" then
			if snapshots[spells.shatteredPsyche.id].buff.isActive then
				valid = true
			end
		elseif var == "$ysTime" then
			if snapshots[spells.idolOfYoggSaron.id].buff.isActive then
				valid = true
			end
		elseif var == "$ysStacks" then
			if snapshots[spells.idolOfYoggSaron.id].buff.isActive then
				valid = true
			end
		elseif var == "$ysRemainingStacks" then
			if talents:IsTalentActive(spells.idolOfYoggSaron) then
				valid = true
			end
		elseif var == "$tfbTime" then
			if snapshots[spells.thingFromBeyond.id].buff.isActive then
				valid = true
			end
		elseif var == "$reTime" then
			if target and target.spells[spells.resonantEnergy.debuffId].active then
				valid = true
			end
		elseif var == "$reStacks" then
			if target and target.spells[spells.resonantEnergy.debuffId].active then
				valid = true
			end
		elseif var == "$mindBlastCharges" then
			if snapshots[spells.mindBlast.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$mindBlastMaxCharges" then
			if snapshots[spells.mindBlast.id].cooldown.charges > 0  then
				valid = true
			end
		else
			valid = false
		end
	end

	-- Voidweaver
	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.ShadowSpells]]
		if var == "$entropicRiftTime" then
			if snapshots[spells.entropicRift.id].buff.isActive then
				valid = true
			end
		end
	end

	-- Spec Agnostic
	local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	if var == "$swpCount" then
		if snapshotData.targetData.count[spells.shadowWordPain.id] > 0 then
			valid = true
		end
	elseif var == "$swpTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			(target.spells[spells.shadowWordPain.id] ~= nil and
			target.spells[spells.shadowWordPain.id].remainingTime > 0) then
			valid = true
		end		
	elseif var == "$sfMana" then
		local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
		if shadowfiend.resourceRaw > 0 then
			valid = true
		end
	elseif var == "$sfGcds" then
		local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
		if shadowfiend.remainingGcds > 0 then
			valid = true
		end
	elseif var == "$sfSwings" then
		local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
		if shadowfiend.remainingSwings > 0 then
			valid = true
		end
	elseif var == "$sfTime" then
		local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
		if shadowfiend.remainingTime > 0 then
			valid = true
		end
	elseif var == "$sfCount" then
		local shadowfiend = snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Priest.Shadowfiend]]
		if shadowfiend:IsAnyActive() then
			valid = true
		end
	end
	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local settings = TRB.Data.settings.priest
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		if TRB.Functions.String:StartsWith(relativeToFrame, "PowerWord_") then
			if TRB.Functions.String:Contains(relativeToFrame, "Radiance") and settings.discipline.colors.comboPoints.powerWordRadianceEnabled and talents:IsTalentActive(spells.powerWordRadiance) then
				if TRB.Functions.String:EndsWith(relativeToFrame, "1") then
					return _G["TwintopResourceBarFrame_ComboPoint_1"], true
				elseif TRB.Functions.String:EndsWith(relativeToFrame, "2") and talents:IsTalentActive(spells.lightsPromise) then
					return _G["TwintopResourceBarFrame_ComboPoint_2"], true
				else
					return nil, false
				end
			else
				return nil, false
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		if TRB.Functions.String:StartsWith(relativeToFrame, "HolyWord_") then
			if TRB.Functions.String:Contains(relativeToFrame, "Serenity") and settings.holy.colors.comboPoints.holyWordSerenityEnabled and talents:IsTalentActive(spells.holyWordSerenity) then
				if TRB.Functions.String:EndsWith(relativeToFrame, "1") then
					return _G["TwintopResourceBarFrame_ComboPoint_1"], true
				elseif TRB.Functions.String:EndsWith(relativeToFrame, "2") and talents:IsTalentActive(spells.miracleWorker) then
					return _G["TwintopResourceBarFrame_ComboPoint_2"], true
				else
					return nil, false
				end
			elseif TRB.Functions.String:Contains(relativeToFrame, "Sanctify") and settings.holy.colors.comboPoints.holyWordSanctifyEnabled and talents:IsTalentActive(spells.holyWordSanctify) then
				if TRB.Functions.String:EndsWith(relativeToFrame, "1") then
					local nextHwCount = 1
					if settings.holy.colors.comboPoints.holyWordSerenityEnabled and talents:IsTalentActive(spells.holyWordSerenity) then
						nextHwCount = nextHwCount + 1
						if talents:IsTalentActive(spells.miracleWorker) then
							nextHwCount = nextHwCount + 1
						end
					end
					return _G["TwintopResourceBarFrame_ComboPoint_"..nextHwCount], true
				elseif TRB.Functions.String:EndsWith(relativeToFrame, "2") and talents:IsTalentActive(spells.miracleWorker) then
					local nextHwCount = 2
					if settings.holy.colors.comboPoints.holyWordSerenityEnabled and talents:IsTalentActive(spells.holyWordSerenity) then
						nextHwCount = nextHwCount + 1
						if talents:IsTalentActive(spells.miracleWorker) then
							nextHwCount = nextHwCount + 1
						end
					end
					return _G["TwintopResourceBarFrame_ComboPoint_"..nextHwCount], true
				else
					return nil, false
				end
			elseif TRB.Functions.String:EndsWith(relativeToFrame, "Chastise_1") and settings.holy.colors.comboPoints.holyWordChastiseEnabled and talents:IsTalentActive(spells.holyWordChastise) then
				local nextHwCount = 1
				if settings.holy.colors.comboPoints.holyWordSerenityEnabled and talents:IsTalentActive(spells.holyWordSerenity) then
					nextHwCount = nextHwCount + 1
					if talents:IsTalentActive(spells.miracleWorker) then
						nextHwCount = nextHwCount + 1
					end
				end
				
				if settings.holy.colors.comboPoints.holyWordSanctifyEnabled and talents:IsTalentActive(spells.holyWordSanctify) then
					nextHwCount = nextHwCount + 1
					if talents:IsTalentActive(spells.miracleWorker) then
						nextHwCount = nextHwCount + 1
					end
				end
				return _G["TwintopResourceBarFrame_ComboPoint_"..nextHwCount], true
			else
				return nil, false
			end
		end
	elseif TRB.Data.character.specId == 3 then
	end
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end
	
	UpdateResourceBar()
end