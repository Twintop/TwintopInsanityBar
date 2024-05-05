local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 5 then --Only do this if we're on a Priest!
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
local timerFrame = TRB.Frames.timerFrame
local combatFrame = TRB.Frames.combatFrame

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}
TRB.Data.character = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	discipline = TRB.Classes.SpecCache:New(),
	holy = TRB.Classes.SpecCache:New(),
	shadow = TRB.Classes.SpecCache:New()
}

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
		ttd = 0,
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
		maxResource = 100,
		effects = {
		},
		items = {
			potions = {
				aeratedManaPotionRank3 = {
					id = 191386,
					mana = 27600
				},
				aeratedManaPotionRank2 = {
					id = 191385,
					mana = 24000
				},
				aeratedManaPotionRank1 = {
					id = 191384,
					mana = 20869
				},
				potionOfFrozenFocusRank3 = {
					id = 191365,
					mana = 48300
				},
				potionOfFrozenFocusRank2 = {
					id = 191364,
					mana = 42000
				},
				potionOfFrozenFocusRank1 = {
					id = 191363,
					mana = 36521
				},
			},
			conjuredChillglobe = {
				id = 194300,
				isEquipped = false,
				manaThresholdPercent = 0.65,
				mana = 0
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
	specCache.discipline.snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.potionOfFrozenFocusRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.aeratedManaPotionRank1)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(spells.conjuredChillglobe)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.discipline.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.discipline.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.shadowfiend.id] = TRB.Classes.Healer.HealerRegenBase:New(spells.shadowfiend, {
		guid = nil,
		totemId = nil,
		onCooldown = false,
		swingTime = 0,
		remaining = {
			swings = 0,
			gcds = 0,
			time = 0
		},
		resourceRaw = 0,
		resourceFinal = 0
	})
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(spells.surgeOfLight)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.powerWordRadiance.id] = TRB.Classes.Snapshot:New(spells.powerWordRadiance)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.shadowCovenant.id] = TRB.Classes.Snapshot:New(spells.shadowCovenant)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.rapture.id] = TRB.Classes.Snapshot:New(spells.rapture)
	---@type TRB.Classes.Snapshot
	specCache.discipline.snapshotData.snapshots[spells.atonement.id] = TRB.Classes.Snapshot:New(spells.atonement, {
		minRemainingTime = 0,
		maxRemainingTime = 0
	})

	specCache.discipline.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Holy
	specCache.holy.Global_TwintopResourceBar = {
		ttd = 0,
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
		maxResource = 100,
		effects = {
		},
		items = {
			potions = {
				aeratedManaPotionRank3 = {
					id = 191386,
					mana = 27600
				},
				aeratedManaPotionRank2 = {
					id = 191385,
					mana = 24000
				},
				aeratedManaPotionRank1 = {
					id = 191384,
					mana = 20869
				},
				potionOfFrozenFocusRank3 = {
					id = 191365,
					mana = 48300
				},
				potionOfFrozenFocusRank2 = {
					id = 191364,
					mana = 42000
				},
				potionOfFrozenFocusRank1 = {
					id = 191363,
					mana = 36521
				},
			},
			conjuredChillglobe = {
				id = 194300,
				isEquipped = false,
				manaThresholdPercent = 0.65,
				mana = 0
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
	---@type TRB.Classes.Healer.HealerRegenBase
	specCache.holy.snapshotData.snapshots[spells.shadowfiend.id] = TRB.Classes.Healer.HealerRegenBase:New(spells.shadowfiend, {
		guid = nil,
		totemId = nil,
		onCooldown = false,
		swingTime = 0,
		remaining = {
			swings = 0,
			gcds = 0,
			time = 0
		},
		resourceRaw = 0,
		resourceFinal = 0
	})
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.apotheosis.id] = TRB.Classes.Snapshot:New(spells.apotheosis)
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
	specCache.holy.snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.potionOfFrozenFocusRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.aeratedManaPotionRank1)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(spells.conjuredChillglobe)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.holy.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.holy.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.divineConversation.id] = TRB.Classes.Snapshot:New(spells.divineConversation)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.prayerFocus.id] = TRB.Classes.Snapshot:New(spells.prayerFocus)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.sacredReverence.id] = TRB.Classes.Snapshot:New(spells.sacredReverence, nil, true)

	-- Shadow
	specCache.shadow.Global_TwintopResourceBar = {
		ttd = 0,
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
		maxResource = 100,
		devouringPlagueThreshold = 50,
		effects = {
		},
		items = {
			callToTheVoid = false
		}
	}

	---@type TRB.Classes.Priest.ShadowSpells
	specCache.shadow.spellsData.spells = TRB.Classes.Priest.ShadowSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	specCache.shadow.snapshotData.audio = {
		playedDpCue = false,
		playedMdCue = false,
		overcapCue = false,
		deathsTormentCue = false,
		deathsTormentMaxCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.voidform.id] = TRB.Classes.Snapshot:New(spells.voidform)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.darkAscension.id] = TRB.Classes.Snapshot:New(spells.darkAscension)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.shadowfiend.id] = TRB.Classes.Snapshot:New(spells.shadowfiend, {
		guid = nil,
		totemId = nil,
		onCooldown = false,
		swingTime = 0,
		remaining = {
			swings = 0,
			gcds = 0,
			time = 0
		},
		resourceRaw = 0,
		resourceFinal = 0
	})
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
	specCache.shadow.snapshotData.snapshots[spells.surgeOfInsanity.id] = TRB.Classes.Snapshot:New(spells.mindFlayInsanity)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.deathspeaker.id] = TRB.Classes.Snapshot:New(spells.deathspeaker)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.twistOfFate.id] = TRB.Classes.Snapshot:New(spells.twistOfFate)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.mindMelt.id] = TRB.Classes.Snapshot:New(spells.mindMelt)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.shadowyInsight.id] = TRB.Classes.Snapshot:New(spells.shadowyInsight)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.voidBolt.id] = TRB.Classes.Snapshot:New(spells.voidBolt, {
		lastSuccess = nil,
		flightTime = 1.0
	})
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.mindBlast.id] = TRB.Classes.Snapshot:New(spells.mindBlast)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.idolOfYoggSaron.id] = TRB.Classes.Snapshot:New(spells.idolOfYoggSaron)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.thingFromBeyond.id] = TRB.Classes.Snapshot:New(spells.thingFromBeyond)
	---@type TRB.Classes.Snapshot
	specCache.shadow.snapshotData.snapshots[spells.deathsTorment.id] = TRB.Classes.Snapshot:New(spells.deathsTorment)
end

local function Setup_Discipline()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "discipline")
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
		{ variable = "#ptw", icon = spells.purgeTheWicked.icon, description = spells.purgeTheWicked.name, printInSettings = true },
		{ variable = "#purgeTheWicked", icon = spells.purgeTheWicked.icon, description = spells.purgeTheWicked.name, printInSettings = false },
		{ variable = "#pwRadiance", icon = spells.powerWordRadiance.icon, description = spells.powerWordRadiance.name, printInSettings = true },
		{ variable = "#powerWordRadiance", icon = spells.powerWordRadiance.icon, description = spells.powerWordRadiance.name, printInSettings = false },
		{ variable = "#rapture", icon = spells.rapture.icon, description = spells.rapture.name, printInSettings = true },
		{ variable = "#sc", icon = spells.shadowCovenant.icon, description = spells.shadowCovenant.name, printInSettings = true },
		{ variable = "#shadowCovenant", icon = spells.shadowCovenant.icon, description = spells.shadowCovenant.name, printInSettings = false },
		{ variable = "#sf", icon = string.format(L["PriestDisciplineIcon_sf"], spells.shadowfiend.icon, spells.mindbender.icon), description = spells.shadowfiend.name .. " / " .. spells.mindbender.name, printInSettings = true },
		{ variable = "#mindbender", icon = spells.mindbender.icon, description = spells.mindbender.name, printInSettings = false },
		{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = spells.shadowfiend.name, printInSettings = false },
		{ variable = "#sol", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = true },
		{ variable = "#surgeOfLight", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = false },
		{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
		{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },

		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },
		
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

		{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
		{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
		{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
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
		
		{ variable = "$raptureTime", description = L["PriestDisciplineBarTextVariable_raptureTime"], printInSettings = true, color = false },
		
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
		{ variable = "$potionOfFrozenFocusTicks", description = L["PriestDisciplineBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
		{ variable = "$potionOfFrozenFocusTime", description = L["PriestDisciplineBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
		
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

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function Setup_Holy()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "holy")
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

		{ variable = "#apotheosis", icon = spells.apotheosis.icon, description = spells.apotheosis.name, printInSettings = true },			
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },
		{ variable = "#coh", icon = spells.circleOfHealing.icon, description = spells.circleOfHealing.name, printInSettings = true },
		{ variable = "#circleOfHealing", icon = spells.circleOfHealing.icon, description = spells.circleOfHealing.name, printInSettings = false },
		{ variable = "#flashHeal", icon = spells.flashHeal.icon, description = spells.flashHeal.name, printInSettings = true },
		{ variable = "#ha", icon = spells.harmoniousApparatus.icon, description = spells.harmoniousApparatus.name, printInSettings = true },
		{ variable = "#harmoniousApparatus", icon = spells.harmoniousApparatus.icon, description = spells.harmoniousApparatus.name, printInSettings = false },
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
		{ variable = "#pom", icon = spells.prayerOfMending.icon, description = spells.prayerOfMending.name, printInSettings = true },
		{ variable = "#prayerOfMending", icon = spells.prayerOfMending.icon, description = spells.prayerOfMending.name, printInSettings = false },
		{ variable = "#renew", icon = spells.renew.icon, description = spells.renew.name, printInSettings = true },
		{ variable = "#sacredReverence", icon = spells.sacredReverence.icon, description = spells.sacredReverence.name, printInSettings = true },
		{ variable = "#smite", icon = spells.smite.icon, description = spells.smite.name, printInSettings = true },
		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },
		{ variable = "#sol", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = true },
		{ variable = "#surgeOfLight", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = false },

		{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
		{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
		{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },

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
		{ variable = "$potionOfFrozenFocusTicks", description = L["PriestHolyBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
		{ variable = "$potionOfFrozenFocusTime", description = L["PriestHolyBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
		
		{ variable = "$potionCooldown", description = L["PriestHolyBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["PriestHolyBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$swpCount", description = L["PriestHolyBarTextVariable_swpCount"], printInSettings = true, color = false },
		{ variable = "$swpTime", description = L["PriestHolyBarTextVariable_swpTime"], printInSettings = true, color = false },
		
		{ variable = "$sfMana", description = L["PriestHolyBarTextVariable_sfMana"], printInSettings = true, color = false },
		{ variable = "$sfGcds", description = L["PriestHolyBarTextVariable_sfGcds"], printInSettings = true, color = false },
		{ variable = "$sfSwings", description = L["PriestHolyBarTextVariable_sfSwings"], printInSettings = true, color = false },
		{ variable = "$sfTime", description = L["PriestHolyBarTextVariable_sfTime"], printInSettings = true, color = false },


		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function Setup_Shadow()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "shadow")
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
		
		{ variable = "#mm", icon = spells.mindMelt.icon, description = spells.mindMelt.name, printInSettings = true },
		{ variable = "#mindMelt", icon = spells.mindMelt.icon, description = spells.mindMelt.name, printInSettings = false },
																
		{ variable = "#sa", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = true },
		{ variable = "#shadowyApparition", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = false },
																																																				
		{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
		{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },

		{ variable = "#swd", icon = spells.deathspeaker.icon, description = spells.deathspeaker.name, printInSettings = true },
		{ variable = "#shadowWordDeath", icon = spells.deathspeaker.icon, description = spells.deathspeaker.name, printInSettings = false },
		{ variable = "#deathspeaker", icon = spells.deathspeaker.icon, description = spells.deathspeaker.name, printInSettings = false },

		{ variable = "#sf", icon = string.format(L["PriestShadowIcon_sf"], spells.shadowfiend.icon, spells.mindbender.icon), description = spells.shadowfiend.name .. " / " .. spells.mindbender.name, printInSettings = true },
		{ variable = "#mindbender", icon = spells.mindbender.icon, description = spells.mindbender.name, printInSettings = false },
		{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = spells.shadowfiend.name, printInSettings = false },
																						
		{ variable = "#si", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = true },
		{ variable = "#shadowyInsight", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = false },
		
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

		{ variable = "#deathsTorment", icon = spells.deathsTorment.icon, description = spells.deathsTorment.name, printInSettings = true },			
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

		{ variable = "$mbInsanity", description = L["PriestShadowBarTextVariable_mbInsanity"], printInSettings = true, color = false },
		{ variable = "$mbGcds", description = L["PriestShadowBarTextVariable_mbGcds"], printInSettings = true, color = false },
		{ variable = "$mbSwings", description = L["PriestShadowBarTextVariable_mbSwings"], printInSettings = true, color = false },
		{ variable = "$mbTime", description = L["PriestShadowBarTextVariable_mbTime"], printInSettings = true, color = false },

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
		
		{ variable = "$deathspeakerTime", description = L["PriestShadowBarTextVariable_deathspeakerTime"], printInSettings = true, color = false },
		
		{ variable = "$siTime", description = L["PriestShadowBarTextVariable_siTime"], printInSettings = true, color = false },
		
		{ variable = "$mindBlastCharges", description = L["PriestShadowBarTextVariable_mindBlastCharges"], printInSettings = true, color = false },
		{ variable = "$mindBlastMaxCharges", description = L["PriestShadowBarTextVariable_mindBlastMaxCharges"], printInSettings = true, color = false },

		{ variable = "$mmTime", description = L["PriestShadowBarTextVariable_mmTime"], printInSettings = true, color = false },
		{ variable = "$mmStacks", description = L["PriestShadowBarTextVariable_mmStacks"], printInSettings = true, color = false },

		{ variable = "$vfTime", description = L["PriestShadowBarTextVariable_vfTime"], printInSettings = true, color = false },

		{ variable = "$ysTime", description = L["PriestShadowBarTextVariable_ysTime"], printInSettings = true, color = false },
		{ variable = "$ysStacks", description = L["PriestShadowBarTextVariable_ysStacks"], printInSettings = true, color = false },
		{ variable = "$ysRemainingStacks", description = L["PriestShadowBarTextVariable_ysRemainingStacks"], printInSettings = true, color = false },
		{ variable = "$tfbTime", description = L["PriestShadowBarTextVariable_tfbTime"], printInSettings = true, color = false },
		
		{ variable = "$deathsTormentStacks", description = L["PriestShadowBarTextVariable_deathsTormentStacks"], printInSettings = true, color = false },

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
	local specId = GetSpecialization()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData

	if specId == 1 then -- Discipline
		targetData:UpdateTrackedSpells(currentTime)
	elseif specId == 2 then -- Holy
		targetData:UpdateTrackedSpells(currentTime)
	elseif specId == 3 then -- Shadow
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
		local specId = GetSpecialization()
		if specId == 2 then
		elseif specId == 2 then
		elseif specId == 3 then
			targetData.custom.auspiciousSpiritsGenerate = 0
		end
	end
end

local function ConstructResourceBar(settings)
	local specId = GetSpecialization()

	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			resourceFrame.thresholds[x]:Hide()
		end
	end

	entries = TRB.Functions.Table:Length(passiveFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			passiveFrame.thresholds[x]:Hide()
		end
	end

	if specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		for x = 1, 9 do
			if TRB.Frames.resourceFrame.thresholds[x] == nil then
				TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
			end

			TRB.Frames.resourceFrame.thresholds[x]:Show()
			TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.resourceFrame.thresholds[x]:Hide()
		end

		for x = 1, 8 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end

			TRB.Frames.passiveFrame.thresholds[x]:Show()
			TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.passiveFrame.thresholds[x]:Hide()
		end
		
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe, settings)
		TRB.Frames.resource2ContainerFrame:Show()

		if talents:IsTalentActive(spells.mindbender) then
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], spells.mindbender, settings)
		else
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], spells.shadowfiend, settings)
		end
	elseif specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		for x = 1, 9 do
			if TRB.Frames.resourceFrame.thresholds[x] == nil then
				TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
			end

			TRB.Frames.resourceFrame.thresholds[x]:Show()
			TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.resourceFrame.thresholds[x]:Hide()
		end

		for x = 1, 8 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end

			TRB.Frames.passiveFrame.thresholds[x]:Show()
			TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.passiveFrame.thresholds[x]:Hide()
		end
		
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], spells.shadowfiend, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[9], spells.symbolOfHope, settings)
		TRB.Frames.resource2ContainerFrame:Show()
	elseif specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		for x = 1, 3 do
			if TRB.Frames.resourceFrame.thresholds[x] == nil then
				TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
			end

			TRB.Frames.resourceFrame.thresholds[x]:Show()
			TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.resourceFrame.thresholds[x]:Hide()
		end

		for x = 1, 1 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end

			TRB.Frames.passiveFrame.thresholds[x]:Show()
			TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.passiveFrame.thresholds[x]:Hide()
		end

		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.devouringPlague, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.devouringPlague2, settings)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.devouringPlague3, settings)
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
	local divineConversationValue = 0
	local prayerFocusValue = 0

	if snapshots[spells.divineConversation.id].buff.isActive then
		if TRB.Data.character.isPvp then
			divineConversationValue = spells.divineConversation.attributes.reductionPvp
		else
			divineConversationValue = spells.divineConversation.attributes.reduction
		end
	end

	if snapshots[spells.prayerFocus.id].buff.isActive and (spellId == spells.heal.id or spellId == spells.prayerOfHealing.id) then
		prayerFocusValue = spells.prayerFocus.attributes.holyWordReduction
	end

	if snapshots[spells.apotheosis.id].buff.isActive then
		mod = mod * spells.apotheosis--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier
	end

	if talents:IsTalentActive(spells.lightOfTheNaaru) then
		mod = mod * (1 + (spells.lightOfTheNaaru--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier * talents.talents[spells.lightOfTheNaaru.id].currentRank))
	end

	return mod * (base + prayerFocusValue) + divineConversationValue
end

local function CalculateResourceGain(resource)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshLookupData_Discipline()
	local specSettings = TRB.Data.settings.priest.discipline
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	
	if TRB.Data.character.items.imbuedFrostweaveSlippers then
		snapshotData.attributes.manaRegen = snapshotData.attributes.manaRegen + (TRB.Data.character.maxResource * spells.imbuedFrostweaveSlippers.attributes.resourcePercent)
	end

	local currentManaColor = specSettings.colors.text.current
	local castingManaColor = specSettings.colors.text.casting

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
	local _potionCooldown = snapshots[spells.aeratedManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--$channeledMana
	local _channeledMana = channeledManaPotion.mana
	local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
	--$potionOfFrozenFocusTicks
	local _potionOfFrozenFocusTicks = channeledManaPotion.ticks or 0
	local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
	--$potionOfFrozenFocusTime
	local _potionOfFrozenFocusTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
	local potionOfFrozenFocusTime = TRB.Functions.BarText:TimerPrecision(_potionOfFrozenFocusTime)
	
	--$sfMana
	local _sfMana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0
	local sfMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
	--$sfGcds
	local _sfGcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds
	local sfGcds = string.format("%.0f", _sfGcds)
	--$sfSwings
	local _sfSwings = snapshots[spells.shadowfiend.id].attributes.remaining.swings
	local sfSwings = string.format("%.0f", _sfSwings)
	--$sfTime
	local _sfTime = snapshots[spells.shadowfiend.id].attributes.remaining.time
	local sfTime = TRB.Functions.BarText:TimerPrecision(_sfTime)

	--$passive
	local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana + _bowMana
	local passiveMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

	--$raptureTime
	local _raptureTime = snapshots[spells.rapture.id].buff:GetRemainingTime(currentTime)
	local raptureTime = TRB.Functions.BarText:TimerPrecision(_raptureTime)

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
	local _shadowWordPainCount
	if talents:IsTalentActive(spells.purgeTheWicked) then
		_shadowWordPainCount = snapshotData.targetData.count[spells.purgeTheWicked.id] or 0
	else
		_shadowWordPainCount = snapshotData.targetData.count[spells.shadowWordPain.id] or 0
	end
	local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
	local _shadowWordPainTime = 0
	
	if target ~= nil then
		if talents:IsTalentActive(spells.purgeTheWicked) then
			_shadowWordPainTime = target.spells[spells.purgeTheWicked.id].remainingTime or 0
		else
			_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
		end
	end

	local shadowWordPainTime

	if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and (target.spells[spells.shadowWordPain.id].active or target.spells[spells.purgeTheWicked.id].active) then
			if _shadowWordPainTime > spells.shadowWordPain.pandemicTime then
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			end
		else
			shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _shadowWordPainCount)
			shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
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
	Global_TwintopResourceBar.channeledPotion = {
		mana = _channeledMana,
		ticks = _potionOfFrozenFocusTicks
	}
	Global_TwintopResourceBar.symbolOfHope = {
		mana = _sohMana,
		ticks = _sohTicks,
	}
	Global_TwintopResourceBar.shadowfiend = {
		mana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0,
		gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
		swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
		time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
	}
	Global_TwintopResourceBar.dots = {
		swpCount = _shadowWordPainCount or 0
	}
	Global_TwintopResourceBar.atonement = {
		count = _atonementCount,
		targetTime = _atonementTime,
		minTime = _atonementMinTime,
		maxTime = _atonementMaxTime
	}


	local lookup = TRB.Data.lookup
	
	if talents:IsTalentActive(spells.mindbender) then
		lookup["#sf"] = spells.mindbender.icon
		lookup["#mindbender"] = spells.mindbender.icon
		lookup["#shadowfiend"] = spells.mindbender.icon
	else
		lookup["#sf"] = spells.shadowfiend.icon
		lookup["#mindbender"] = spells.shadowfiend.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
	end

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
	lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
	lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$sfMana"] = sfMana
	lookup["$sfGcds"] = sfGcds
	lookup["$sfSwings"] = sfSwings
	lookup["$sfTime"] = sfTime
	lookup["$swpCount"] = shadowWordPainCount
	lookup["$swpTime"] = shadowWordPainTime
	lookup["$pwRadianceTime"] = pwRadianceTime
	lookup["$radianceTime"] = pwRadianceTime
	lookup["$powerWordRadianceTime"] = pwRadianceTime
	lookup["$pwRadianceCharges"] = pwRadianceCharges
	lookup["$radianceCharges"] = pwRadianceCharges
	lookup["$powerWordRadianceCharges"] = pwRadianceCharges
	lookup["$raptureTime"] = raptureTime
	lookup["$scTime"] = scTime
	lookup["$shadowCovenantTime"] = scTime
	lookup["$atonementMinTime"] = atonementMinTime
	lookup["$atonementMaxTime"] = atonementMaxTime
	lookup["$atonementTime"] = atonementTime
	lookup["$atonementCount"] = atonementCount
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
	lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
	lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	lookupLogic["$sfMana"] = _sfMana
	lookupLogic["$sfGcds"] = _sfGcds
	lookupLogic["$sfSwings"] = _sfSwings
	lookupLogic["$sfTime"] = _sfTime
	lookupLogic["$swpCount"] = _shadowWordPainCount
	lookupLogic["$swpTime"] = _shadowWordPainTime
	lookupLogic["$pwRadianceTime"] = _pwRadianceTime
	lookupLogic["$radianceTime"] = _pwRadianceTime
	lookupLogic["$powerWordRadianceTime"] = _pwRadianceTime
	lookupLogic["$pwRadianceCharges"] = _pwRadianceCharges
	lookupLogic["$radianceCharges"] = _pwRadianceCharges
	lookupLogic["$powerWordRadianceCharges"] = _pwRadianceCharges
	lookupLogic["$raptureTime"] = _raptureTime
	lookupLogic["$scTime"] = _scTime
	lookupLogic["$shadowCovenantTime"] = _scTime
	lookupLogic["$atonementMinTime"] = _atonementMinTime
	lookupLogic["$atonementMaxTime"] = _atonementMaxTime
	lookupLogic["$atonementTime"] = _atonementTime
	lookupLogic["$atonementCount"] = _atonementCount
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Holy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.priest.holy
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	
	if TRB.Data.character.items.imbuedFrostweaveSlippers then
		snapshotData.attributes.manaRegen = snapshotData.attributes.manaRegen + (TRB.Data.character.maxResource * spells.imbuedFrostweaveSlippers.resourcePercent)
	end

	local currentManaColor = specSettings.colors.text.current
	local castingManaColor = specSettings.colors.text.casting

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
	local _potionCooldown = snapshots[spells.aeratedManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--$channeledMana
	local _channeledMana = channeledManaPotion.mana
	local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
	--$potionOfFrozenFocusTicks
	local _potionOfFrozenFocusTicks = channeledManaPotion.ticks or 0
	local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
	--$potionOfFrozenFocusTime
	local _potionOfFrozenFocusTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
	local potionOfFrozenFocusTime = TRB.Functions.BarText:TimerPrecision(_potionOfFrozenFocusTime)
	
	--$sfMana
	local _sfMana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0
	local sfMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
	--$sfGcds
	local _sfGcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds
	local sfGcds = string.format("%.0f", _sfGcds)
	--$sfSwings
	local _sfSwings = snapshots[spells.shadowfiend.id].attributes.remaining.swings
	local sfSwings = string.format("%.0f", _sfSwings)
	--$sfTime
	local _sfTime = snapshots[spells.shadowfiend.id].attributes.remaining.time
	local sfTime = TRB.Functions.BarText:TimerPrecision(_sfTime)

	--$passive
	local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana + _bowMana
	local passiveMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

	if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.shadowWordPain.id].active then
			if _shadowWordPainTime > spells.shadowWordPain.pandemicTime then
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			end
		else
			shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _shadowWordPainCount)
			shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
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
	Global_TwintopResourceBar.channeledPotion = {
		mana = _channeledMana,
		ticks = _potionOfFrozenFocusTicks
	}
	Global_TwintopResourceBar.symbolOfHope = {
		mana = _sohMana,
		ticks = _sohTicks
	}
	Global_TwintopResourceBar.shadowfiend = {
		mana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0,
		gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
		swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
		time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
	}
	Global_TwintopResourceBar.dots = {
		swpCount = _shadowWordPainCount or 0
	}


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
	lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
	lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$solStacks"] = solStacks
	lookup["$solTime"] = solTime
	lookup["$sfMana"] = sfMana
	lookup["$sfGcds"] = sfGcds
	lookup["$sfSwings"] = sfSwings
	lookup["$sfTime"] = sfTime
	lookup["$lightweaverStacks"] = lightweaverStacks
	lookup["$lightweaverTime"] = lightweaverTime
	lookup["$apotheosisTime"] = apotheosisTime
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
	lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
	lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
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
	lookupLogic["$sacredReverenceStacks"] = _sacredReverenceStacks
	lookupLogic["$swpCount"] = _shadowWordPainCount
	lookupLogic["$swpTime"] = _shadowWordPainTime
	lookupLogic["$rwTime"] = rwTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Shadow()
	local specSettings = TRB.Data.settings.priest.shadow
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

	local currentInsanityColor = specSettings.colors.text.currentInsanity
	local castingInsanityColor = specSettings.colors.text.castingInsanity

	local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

	if snapshots[spells.mindDevourer.id].buff.isActive then
		insanityThreshold = 0
	end

	if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
		if specSettings.colors.text.overcapEnabled and overcap then
			currentInsanityColor = specSettings.colors.text.overcapInsanity
			castingInsanityColor = specSettings.colors.text.overcapInsanity
		elseif specSettings.colors.text.overThresholdEnabled and normalizedInsanity >= insanityThreshold then
			currentInsanityColor = specSettings.colors.text.overThreshold
			castingInsanityColor = specSettings.colors.text.overThreshold
		end
	end

	--$insanity
	local resourcePrecision = specSettings.resourcePrecision or 0
	local _currentInsanity = normalizedInsanity
	local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_currentInsanity, resourcePrecision, "floor"))
	--$casting
	local _castingInsanity = snapshotData.casting.resourceFinal
	local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, resourcePrecision, "floor"))
	--$mbInsanity
	local _mbInsanity = snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal
	local mbInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_mbInsanity, resourcePrecision, "floor"))
	--$mbGcds
	local _mbGcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds
	local mbGcds = string.format("%.0f", _mbGcds)
	--$mbSwings
	local _mbSwings = snapshots[spells.shadowfiend.id].attributes.remaining.swings
	local mbSwings = string.format("%.0f", _mbSwings)
	--$mbTime
	local _mbTime = snapshots[spells.shadowfiend.id].attributes.remaining.time
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
	local passiveInsanity = string.format("|c%s%s|r", specSettings.colors.text.passiveInsanity, TRB.Functions.Number:RoundTo(_passiveInsanity, resourcePrecision, "floor"))
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
	local devouringPlagueTime
	if target ~= nil then
		devouringPlagueTime = TRB.Functions.BarText:TimerPrecision(target.spells[spells.devouringPlague.id].remainingTime or 0)
	else
		devouringPlagueTime = TRB.Functions.BarText:TimerPrecision(0)
	end

	if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.shadowWordPain.id].active then
			if (not talents:IsTalentActive(spells.misery) and target.spells[spells.shadowWordPain.id].remainingTime > spells.shadowWordPain.pandemicTime) or
				(talents:IsTalentActive(spells.misery) and target.spells[spells.shadowWordPain.id].remainingTime > spells.shadowWordPain.attributes.miseryPandemicTime) then
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%sf|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_shadowWordPainTime))
			end
		else
			shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _shadowWordPainCount)
			shadowWordPainTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end

		if target ~= nil and target.spells[spells.vampiricTouch.id].active then
			if target.spells[spells.vampiricTouch.id].remainingTime > spells.vampiricTouch.pandemicTime then
				vampiricTouchCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _vampiricTouchCount)
				vampiricTouchTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_vampiricTouchTime))
			else
				vampiricTouchCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _vampiricTouchCount)
				vampiricTouchTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_vampiricTouchTime))
			end
		else
			vampiricTouchCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _vampiricTouchCount)
			vampiricTouchTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
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
	local _mfiTime = snapshots[spells.surgeOfInsanity.id].buff:GetRemainingTime(currentTime)
	local mfiTime = TRB.Functions.BarText:TimerPrecision(_mfiTime)

	--$mfiStacks
	local _mfiStacks = snapshots[spells.surgeOfInsanity.id].buff.applications or 0
	local mfiStacks = string.format("%.0f", _mfiStacks)
	
	--$deathspeakerTime
	local _deathspeakerTime = snapshots[spells.deathspeaker.id].buff:GetRemainingTime(currentTime)
	local deathspeakerTime = TRB.Functions.BarText:TimerPrecision(_deathspeakerTime)

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
	
	--$mmTime
	local _mmTime = snapshots[spells.mindMelt.id].buff:GetRemainingTime(currentTime)
	local mmTime = TRB.Functions.BarText:TimerPrecision(_mmTime)
	--$mmStacks
	local mmStacks = snapshots[spells.mindMelt.id].buff.applications or 0
	
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
	
	--$deathsTormentStacks
	local deathsTormentStacks = snapshots[spells.deathsTorment.id].buff.applications or 0

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
	Global_TwintopResourceBar.auspiciousSpirits = {
		count = targetData.count[spells.auspiciousSpirits.id] or 0,
		insanity = _asInsanity
	}
	Global_TwintopResourceBar.dots = {
		swpCount = _shadowWordPainCount or 0,
		vtCount = _vampiricTouchCount or 0,
		dpCount = devouringPlagueCount or 0
	}
	Global_TwintopResourceBar.shadowfiend = {
		insanity = _mbInsanity or 0,
		gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
		swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
		time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
	}
	Global_TwintopResourceBar.mindbender = {
		insanity = _mbInsanity,
		gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
		swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
		time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
	}
	Global_TwintopResourceBar.eternalCallToTheVoid = {
		insanity = snapshots[spells.idolOfCthun.id].attributes.resourceFinal or 0,
		ticks = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining or 0,
		count = snapshots[spells.idolOfCthun.id].attributes.numberActive or 0
	}

	local lookup = TRB.Data.lookup
	
	if talents:IsTalentActive(spells.mindbender) then
		lookup["#sf"] = spells.mindbender.icon
		lookup["#mindbender"] = spells.mindbender.icon
		lookup["#shadowfiend"] = spells.mindbender.icon
	else
		lookup["#sf"] = spells.shadowfiend.icon
		lookup["#mindbender"] = spells.shadowfiend.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
	end

	lookup["$swpCount"] = shadowWordPainCount
	lookup["$swpTime"] = shadowWordPainTime
	lookup["$vtCount"] = vampiricTouchCount
	lookup["$vtTime"] = vampiricTouchTime
	lookup["$dpCount"] = devouringPlagueCount
	lookup["$dpTime"] = devouringPlagueTime
	lookup["$mdTime"] = mdTime
	lookup["$mfiTime"] = mfiTime
	lookup["$mfiStacks"] = mfiStacks
	lookup["$deathspeakerTime"] = deathspeakerTime
	lookup["$tofTime"] = tofTime
	lookup["$vfTime"] = voidformTime
	lookup["$mmTime"] = mmTime
	lookup["$mmStacks"] = mmStacks
	lookup["$ysTime"] = ysTime
	lookup["$ysStacks"] = ysStacks
	lookup["$ysRemainingStacks"] = ysRemainingStacks
	lookup["$deathsTormentStacks"] = deathsTormentStacks
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
	lookup["$mbInsanity"] = mbInsanity
	lookup["$mbGcds"] = mbGcds
	lookup["$mbSwings"] = mbSwings
	lookup["$mbTime"] = mbTime
	lookup["$loiInsanity"] = loiInsanity
	lookup["$loiTicks"] = loiTicks
	lookup["$cttvEquipped"] = ""
	lookup["$ecttvCount"] = ecttvCount
	lookup["$asCount"] = asCount
	lookup["$asInsanity"] = asInsanity
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
	lookupLogic["$dpTime"] = devouringPlagueTime
	lookupLogic["$mdTime"] = _mdTime
	lookupLogic["$mfiTime"] = _mfiTime
	lookupLogic["$mfiStacks"] = _mfiStacks
	lookupLogic["$deathspeakerTime"] = _deathspeakerTime
	lookupLogic["$tofTime"] = _tofTime
	lookupLogic["$vfTime"] = _voidformTime
	lookupLogic["$mmTime"] = _mmTime
	lookupLogic["$mmStacks"] = mmStacks
	lookupLogic["$ysTime"] = _ysTime
	lookupLogic["$ysStacks"] = ysStacks
	lookupLogic["$ysRemainingStacks"] = ysRemainingStacks
	lookupLogic["$deathsTormentStacks"] = deathsTormentStacks
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
	lookupLogic["$mbInsanity"] = _mbInsanity
	lookupLogic["$mbGcds"] = _mbGcds
	lookupLogic["$mbSwings"] = _mbSwings
	lookupLogic["$mbTime"] = _mbTime
	lookupLogic["$loiInsanity"] = _loiInsanity
	lookupLogic["$loiTicks"] = _loiTicks
	lookupLogic["$cttvEquipped"] = cttvEquipped
	lookupLogic["$ecttvCount"] = _ecttvCount
	lookupLogic["$asCount"] = _asCount
	lookupLogic["$asInsanity"] = _asInsanity
	TRB.Data.lookupLogic = lookupLogic
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

local function CastingSpell()
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()
	local affectingCombat = UnitAffectingCombat("player")
	local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
	local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
	local specId = GetSpecialization()

	if currentSpellName == nil and currentChannelName == nil then
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	else
		if specId == 1 then
			local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
			if currentSpellName == nil then
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			else
				local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

				if spellId then
					local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellId, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true)

					snapshotData.casting.startTime = currentSpellStartTime / 1000
					snapshotData.casting.endTime = currentSpellEndTime / 1000
					snapshotData.casting.resourceRaw = manaCost
					snapshotData.casting.spellId = spellId
					snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

					UpdateCastingResourceFinal_Discipline()
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			return true
		elseif specId == 2 then
			local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
			if currentSpellName == nil then
				if currentChannelId == spells.symbolOfHope.id then
					snapshotData.casting.spellId = spells.symbolOfHope.id
					snapshotData.casting.startTime = currentChannelStartTime / 1000
					snapshotData.casting.endTime = currentChannelEndTime / 1000
					snapshotData.casting.resourceRaw = 0
					snapshotData.casting.icon = spells.symbolOfHope.icon
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			else
				local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

				if spellId then
					local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellId, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true)

					snapshotData.casting.startTime = currentSpellStartTime / 1000
					snapshotData.casting.endTime = currentSpellEndTime / 1000
					snapshotData.casting.resourceRaw = manaCost
					snapshotData.casting.spellId = spellId
					snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

					UpdateCastingResourceFinal_Holy()
					if currentSpellId == spells.heal.id then
						snapshotData.casting.spellKey = "heal"
					elseif currentSpellId == spells.flashHeal.id then
						snapshotData.casting.spellKey = "flashHeal"
					elseif currentSpellId == spells.prayerOfHealing.id then
						snapshotData.casting.spellKey = "prayerOfHealing"
					elseif currentSpellId == spells.renew.id then --This shouldn't happen
						snapshotData.casting.spellKey = "renew"
					elseif currentSpellId == spells.smite.id then
						snapshotData.casting.spellKey = "smite"
					elseif talents:IsTalentActive(spells.harmoniousApparatus) then
						if currentSpellId == spells.circleOfHealing.id then --Harmonious Apparatus / This shouldn't happen
							snapshotData.casting.spellKey = "circleOfHealing"
						elseif currentSpellId == spells.prayerOfMending.id then --Harmonious Apparatus / This shouldn't happen
							snapshotData.casting.spellKey = "prayerOfMending"
						elseif currentSpellId == spells.holyFire.id then --Harmonious Apparatus
							snapshotData.casting.spellKey = "holyFire"
						end
					end
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			return true
		elseif specId == 3 then
			local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
			if currentSpellName == nil then
				if currentChannelId == spells.mindFlay.id then
					snapshotData.casting.spellId = spells.mindFlay.id
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.mindFlay.resource
					snapshotData.casting.icon = spells.mindFlay.icon
				elseif currentChannelId == spells.mindFlayInsanity.id then
					snapshotData.casting.spellId = spells.mindFlayInsanity.id
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.mindFlayInsanity.resource
					snapshotData.casting.icon = spells.mindFlayInsanity.icon
				elseif currentChannelId == spells.voidTorrent.id then
					snapshotData.casting.spellId = spells.voidTorrent.id
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.voidTorrent.resource
					snapshotData.casting.icon = spells.voidTorrent.icon
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
				UpdateCastingResourceFinal_Shadow()
			else
				if currentSpellId == spells.mindBlast.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.mindBlast.resource
					snapshotData.casting.spellId = spells.mindBlast.id
					snapshotData.casting.icon = spells.mindBlast.icon
				elseif currentSpellId == spells.mindSpike.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.mindSpike.resource
					snapshotData.casting.spellId = spells.mindSpike.id
					snapshotData.casting.icon = spells.mindSpike.icon
				elseif currentSpellId == spells.mindSpikeInsanity.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.mindSpikeInsanity.resource
					snapshotData.casting.spellId = spells.mindSpikeInsanity.id
					snapshotData.casting.icon = spells.mindSpikeInsanity.icon
				elseif currentSpellId == spells.darkAscension.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.darkAscension.resource
					snapshotData.casting.spellId = spells.darkAscension.id
					snapshotData.casting.icon = spells.darkAscension.icon
				elseif currentSpellId == spells.vampiricTouch.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.vampiricTouch.resource
					snapshotData.casting.spellId = spells.vampiricTouch.id
					snapshotData.casting.icon = spells.vampiricTouch.icon
				elseif currentSpellId == spells.mindgames.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.mindgames.resource
					snapshotData.casting.spellId = spells.mindgames.id
					snapshotData.casting.icon = spells.mindgames.icon
				elseif currentSpellId == spells.halo.id then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.halo.resource
					snapshotData.casting.spellId = spells.halo.id
					snapshotData.casting.icon = spells.halo.icon
				elseif currentSpellId == spells.massDispel.id and talents:IsTalentActive(spells.hallucinations) and affectingCombat then
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.hallucinations.resource
					snapshotData.casting.spellId = spells.massDispel.id
					snapshotData.casting.icon = spells.massDispel.icon
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
				UpdateCastingResourceFinal_Shadow()
			end
			
			return true
		end
	end
end

local function GetMaximumShadowfiendResults()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells|TRB.Classes.Priest.ShadowSpells]]
	local specId = GetSpecialization()
	if specId ~= 1 and specId ~= 2 and specId ~= 3 then
		return false, 0, 0, 0, 0, 0
	end

	---@type TRB.Classes.Snapshot
	local shadowfiend = TRB.Data.snapshotData.snapshots[spells.shadowfiend.id]

	local swingTime = shadowfiend.attributes.swingTime

	local currentTime = GetTime()
	local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
	local timeRemaining = startTime+duration-currentTime

	if not haveTotem then
		if specId == 1 then
			if talents:IsTalentActive(spells.mindbender) then
				timeRemaining = spells.mindbender.duration
			else
				timeRemaining = spells.shadowfiend.duration
			end
			swingTime = currentTime
		elseif specId == 2 then
			timeRemaining = spells.shadowfiend.duration
			swingTime = currentTime
		end
	end

	local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.attributes.haste / 100))
	local swingsRemaining = 0
	local gcdsRemaining = 0

	if swingSpeed > 1.5 then
		swingSpeed = 1.5
	end

	local timeToNextSwing = swingSpeed - (currentTime - swingTime)

	if timeToNextSwing < 0 then
		timeToNextSwing = 0
	elseif timeToNextSwing > 1.5 then
		timeToNextSwing = 1.5
	end

	swingsRemaining = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)

	local gcd = swingSpeed
	if gcd < 0.75 then
		gcd = 0.75
	end

	if timeRemaining > (gcd * swingsRemaining) then
		gcdsRemaining = math.ceil(((gcd * swingsRemaining) - timeToNextSwing) / swingSpeed)
	else
		gcdsRemaining = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
	end

	return haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed
end

---Update a specific Shadowfiend's values
---@param shadowfiend TRB.Classes.Snapshot|TRB.Classes.Healer.HealerRegenBase
local function UpdateSpecificShadowfiendValues(shadowfiend)
	local specId = GetSpecialization()
	local currentTime = GetTime()
	local settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells|TRB.Classes.Priest.ShadowSpells]]

	if specId == 1 then
		settings = TRB.Data.settings.priest.discipline.shadowfiend
	elseif specId == 2 and talents:IsTalentActive(spells.shadowfiend) then
		settings = TRB.Data.settings.priest.holy.shadowfiend
	elseif specId == 3 then
		settings = TRB.Data.settings.priest.shadow.mindbender
	else
		return
	end

	local doReset = false
	if shadowfiend.attributes.totemId == nil then
		doReset = true
	else
		local haveTotem, name, startTime, duration, icon = GetTotemInfo(shadowfiend.attributes.totemId)
		local timeRemaining = startTime+duration-currentTime

		if settings.enabled and haveTotem and timeRemaining > 0 then
			shadowfiend.buff.isActive = true
			if settings.enabled then
				local _, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
				shadowfiend.attributes.remaining.time = timeRemaining
				shadowfiend.attributes.remaining.swings = swingsRemaining
				shadowfiend.attributes.remaining.gcds = gcdsRemaining

				shadowfiend.attributes.swingTime = currentTime

				local countValue = 0

				if settings.mode == "swing" then
					if shadowfiend.attributes.remaining.swings > settings.swingsMax then
						countValue = settings.swingsMax
					else
						countValue = shadowfiend.attributes.remaining.swings
					end
				elseif settings.mode == "time" then
					if shadowfiend.attributes.remaining.time > settings.timeMax then
						countValue = math.ceil((settings.timeMax - timeToNextSwing) / swingSpeed)
					else
						countValue = math.ceil((shadowfiend.attributes.remaining.time - timeToNextSwing) / swingSpeed)
					end
				else --assume GCD
					if shadowfiend.attributes.remaining.gcds > settings.gcdsMax then
						countValue = settings.gcdsMax
					else
						countValue = shadowfiend.attributes.remaining.gcds
					end
				end

				if specId == 1 then
					shadowfiend.attributes.resourceRaw = countValue * shadowfiend.spell.attributes.resourcePercent * TRB.Data.character.maxResource
					shadowfiend.attributes.resourceFinal = CalculateManaGain(shadowfiend.attributes.resourceRaw, false)
				elseif specId == 2 then
					shadowfiend.attributes.resourceRaw = countValue * shadowfiend.spell.attributes.resourcePercent * TRB.Data.character.maxResource
					shadowfiend.attributes.resourceFinal = CalculateManaGain(shadowfiend.attributes.resourceRaw, false)
				elseif specId == 3 then
					shadowfiend.attributes.resourceRaw = countValue * shadowfiend.spell.resource
					shadowfiend.attributes.resourceFinal = CalculateResourceGain(shadowfiend.attributes.resourceRaw)
				end

				if specId == 1 or specId == 2 then
					shadowfiend.mana = shadowfiend.attributes.resourceFinal
				end
			end
		else
			doReset = true
		end
	end
	
	if doReset then
		shadowfiend.buff:Reset()
		shadowfiend.attributes.swingTime = 0
		shadowfiend.attributes.remaining.swings = 0
		shadowfiend.attributes.remaining.gcds = 0
		shadowfiend.attributes.remaining.time = 0
		shadowfiend.attributes.resourceRaw = 0
		shadowfiend.attributes.resourceFinal = 0
		if specId == 3 then
			shadowfiend.attributes.totemId = nil
			shadowfiend.attributes.guid = nil
		end
		if specId == 1 or specId == 2 then
			shadowfiend.mana = 0
		end
	end

	shadowfiend.cooldown:Refresh(true)
end

local function UpdateShadowfiendValues()
	local specId = GetSpecialization()
	local _
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells|TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local shadowfiend = snapshotData.snapshots[spells.shadowfiend.id]

	UpdateSpecificShadowfiendValues(shadowfiend)
	
	if specId == 3 then
		local devouredDespair = snapshotData.snapshots[spells.devouredDespair.id]
		devouredDespair.buff:UpdateTicks()
		devouredDespair.attributes.resourceRaw = devouredDespair.buff.resource
		devouredDespair.attributes.resourceFinal = CalculateResourceGain(devouredDespair.attributes.resourceRaw)
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
	--TODO #339: Comment out to reduce load while testing
	UpdateShadowfiendValues()
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
	
	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	potionOfChilledClarity:Update()

	local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	channeledManaPotion:Update()

	snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime)

	-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
	snapshots[spells.aeratedManaPotionRank1.id].cooldown.startTime, snapshots[spells.aeratedManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
	snapshots[spells.aeratedManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)

	snapshots[spells.conjuredChillglobe.id].cooldown.startTime, snapshots[spells.conjuredChillglobe.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
	snapshots[spells.conjuredChillglobe.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Discipline()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	UpdateAtonement()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.powerWordRadiance.id].cooldown:Refresh(true)
	snapshots[spells.rapture.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.shadowCovenant.id].buff:Refresh()
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
	--TODO #339: Comment out to reduce load while testing
	UpdateExternalCallToTheVoidValues()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	--TODO #339: Comment out to reduce load while testing
	snapshots[spells.voidform.id].buff:Refresh()
	snapshots[spells.darkAscension.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.surgeOfInsanity.id].buff:Refresh()
	snapshots[spells.deathspeaker.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)
	
	--TODO #339: Comment out to reduce load while testing
	snapshots[spells.mindBlast.id].cooldown:Refresh()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local specId = GetSpecialization()
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.priest
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		local specSettings = classSettings.discipline
		UpdateSnapshot_Discipline()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
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
				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				if CastingSpell() and specSettings.bar.showCasting  then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end
				
				TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

				local shadowfiend = snapshots[spells.shadowfiend.id]

				if talents:IsTalentActive(spells.shadowfiend) and not shadowfiend.buff.isActive then
					local shadowfiendThresholdColor = specSettings.colors.threshold.over
					if specSettings.thresholds.shadowfiend.enabled and (not shadowfiend.cooldown:IsUnusable() or specSettings.thresholds.shadowfiend.cooldown) then
						local haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
						local shadowfiendMana = swingsRemaining * shadowfiend.spell.attributes.resourcePercent * TRB.Data.character.maxResource

						if shadowfiend.cooldown:IsUnusable() then
							shadowfiendThresholdColor = specSettings.colors.threshold.unusable
						end

						if not haveTotem and shadowfiendMana > 0 and (castingBarValue + shadowfiendMana) < TRB.Data.character.maxResource then
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, (castingBarValue + shadowfiendMana), TRB.Data.character.maxResource)
				---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
				---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
							resourceFrame.thresholds[8]:Show()

							if specSettings.thresholds.icons.showCooldown and shadowfiend.cooldown.remaining > 0 then
								resourceFrame.thresholds[8].icon.cooldown:SetCooldown(shadowfiend.cooldown.startTime, shadowfiend.cooldown.duration)
							else
								resourceFrame.thresholds[8].icon.cooldown:SetCooldown(0, 0)
							end
						else
							resourceFrame.thresholds[8]:Hide()
						end
					else
						resourceFrame.thresholds[8]:Hide()
					end
				else
					resourceFrame.thresholds[8]:Hide()
				end

				local passiveValue, thresholdCount = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				thresholdCount = thresholdCount + 1
				if specSettings.thresholds.shadowfiend.enabled and specSettings.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specSettings, snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], passiveFrame, thresholdCount, castingBarValue, passiveValue)
				else
					TRB.Frames.passiveFrame.thresholds[thresholdCount]:Hide()
				end

				passiveBarValue = castingBarValue + passiveValue
				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end

				local resourceBarColor = specSettings.colors.bar.base

				if snapshots[spells.rapture.id].buff.isActive then
					local timeThreshold = 0
					local useEndOfRaptureColor = false

					if specSettings.endOfRapture.enabled then
						useEndOfRaptureColor = true
						if specSettings.endOfRapture.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfRapture.gcdsMax
						elseif specSettings.endOfRapture.mode == "time" then
							timeThreshold = specSettings.endOfRapture.timeMax
						end
					end

					if useEndOfRaptureColor and snapshots[spells.rapture.id].buff.remaining <= timeThreshold then
						resourceBarColor = specSettings.colors.bar.raptureEnd
					else
						resourceBarColor = specSettings.colors.bar.rapture
					end
				elseif resourceBarColor == nil then
					resourceBarColor = specSettings.colors.bar.base
				end

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				
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

					TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp1Time, cp1Duration)
					TRB.Frames.resource2Frames[currentCp].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cp1Color, true))
					TRB.Frames.resource2Frames[currentCp].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[currentCp].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBA)
					currentCp = currentCp + 1

					if hasCp2 then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp2Time, cp2Duration)
						TRB.Frames.resource2Frames[currentCp].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cp2Color, true))
						TRB.Frames.resource2Frames[currentCp].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[currentCp].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBA)
						currentCp = currentCp + 1
					end
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		end
	elseif specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		local specSettings = classSettings.holy
		UpdateSnapshot_Holy()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
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
				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				if CastingSpell() and specSettings.bar.showCasting  then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end
				
				TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

				local shadowfiend = snapshots[spells.shadowfiend.id]

				if talents:IsTalentActive(spells.shadowfiend) and not shadowfiend.buff.isActive then
					local shadowfiendThresholdColor = specSettings.colors.threshold.over
					if specSettings.thresholds.shadowfiend.enabled and (not shadowfiend.cooldown:IsUnusable() or specSettings.thresholds.shadowfiend.cooldown) then
						local haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
						local shadowfiendMana = swingsRemaining * shadowfiend.spell.attributes.resourcePercent * TRB.Data.character.maxResource

						if shadowfiend.cooldown:IsUnusable() then
							shadowfiendThresholdColor = specSettings.colors.threshold.unusable
						end

						if not haveTotem and shadowfiendMana > 0 and (castingBarValue + shadowfiendMana) < TRB.Data.character.maxResource then
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, (castingBarValue + shadowfiendMana), TRB.Data.character.maxResource)
				---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
				---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
							resourceFrame.thresholds[8]:Show()

							if specSettings.thresholds.icons.showCooldown and shadowfiend.cooldown.remaining > 0 then
								resourceFrame.thresholds[8].icon.cooldown:SetCooldown(shadowfiend.cooldown.startTime, shadowfiend.cooldown.duration)
							else
								resourceFrame.thresholds[8].icon.cooldown:SetCooldown(0, 0)
							end
						else
							resourceFrame.thresholds[8]:Hide()
						end
					else
						resourceFrame.thresholds[8]:Hide()
					end
				else
					resourceFrame.thresholds[8]:Hide()
				end

				local currentManaPercent = (currentResource / TRB.Data.character.maxResource) * 100

				if talents:IsTalentActive(spells.symbolOfHope) and not symbolOfHope.buff.isActive and currentManaPercent <= specSettings.thresholds.symbolOfHope.minimumManaPercent then
					local symbolOfHopeThresholdColor = specSettings.colors.threshold.over
					if specSettings.thresholds.symbolOfHope.enabled and (not symbolOfHope.cooldown:IsUnusable() or specSettings.thresholds.symbolOfHope.cooldown) then
						local symbolOfHopeMana = symbolOfHope:CalculateTime(spells.symbolOfHope.ticks+1, (spells.symbolOfHope.duration / (1 + (snapshotData.attributes.haste / 100))) / spells.symbolOfHope.ticks, 0, true)

						if symbolOfHope.cooldown:IsUnusable() then
							symbolOfHopeThresholdColor = specSettings.colors.threshold.unusable
						end

						if symbolOfHopeMana > 0 and (castingBarValue + symbolOfHopeMana) < TRB.Data.character.maxResource then
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[9], resourceFrame, (castingBarValue + symbolOfHopeMana), TRB.Data.character.maxResource)
				---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[9].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(symbolOfHopeThresholdColor, true))
				---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[9].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(symbolOfHopeThresholdColor, true))
							resourceFrame.thresholds[9]:Show()

							if specSettings.thresholds.icons.showCooldown and symbolOfHope.cooldown.remaining > 0 then
								resourceFrame.thresholds[9].icon.cooldown:SetCooldown(symbolOfHope.cooldown.startTime, symbolOfHope.cooldown.duration)
							else
								resourceFrame.thresholds[9].icon.cooldown:SetCooldown(0, 0)
							end
						else
							resourceFrame.thresholds[9]:Hide()
						end
					else
						resourceFrame.thresholds[9]:Hide()
					end
				else
					resourceFrame.thresholds[9]:Hide()
				end

				local passiveValue, thresholdCount = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				thresholdCount = thresholdCount + 1
				if specSettings.thresholds.shadowfiend.enabled and specSettings.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specSettings, snapshots[spells.shadowfiend.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], passiveFrame, thresholdCount, castingBarValue, passiveValue)
				else
					TRB.Frames.passiveFrame.thresholds[thresholdCount]:Hide()
				end

				passiveBarValue = castingBarValue + passiveValue
				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end

				local resourceBarColor = nil
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

						if (holyWordCooldownRemaining - CalculateHolyWordCooldown(maybeHolyWordSpell.holyWordReduction, spells[snapshotData.casting.spellKey].id) - castTimeRemains) <= 0 then
							holyWordCooldownCompletes = true
							holyWordCooldownCompletesKey = maybeHolyWordSpell.holyWordKey
							if specSettings.bar[maybeHolyWordSpell.holyWordKey .. "Enabled"] then
								resourceBarColor = specSettings.colors.bar[maybeHolyWordSpell]
							end
						end
					end
				end

				if snapshots[spells.apotheosis.id].buff.isActive and resourceBarColor == nil then
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
						resourceBarColor = specSettings.colors.bar.apotheosisEnd
					else
						resourceBarColor = specSettings.colors.bar.apotheosis
					end
				elseif resourceBarColor == nil then
					resourceBarColor = specSettings.colors.bar.base
				end

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))

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

						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp1Time, cp1Duration)
						TRB.Frames.resource2Frames[currentCp].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cp1Color, true))
						TRB.Frames.resource2Frames[currentCp].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[currentCp].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBA)
						currentCp = currentCp + 1

						if hasCp2 then
							if specSettings.colors.comboPoints.sacredReverenceEnabled and srBuff.isActive and cooldown.charges == 2 then
								cp2Color = cpSacredReverenceColor
							end

							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp2Time, cp2Duration)
							TRB.Frames.resource2Frames[currentCp].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cp2Color, true))
							TRB.Frames.resource2Frames[currentCp].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
							TRB.Frames.resource2Frames[currentCp].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBA)
							currentCp = currentCp + 1
						end
					end
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		end
	elseif specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local specSettings = classSettings.shadow
		UpdateSnapshot_Shadow()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

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

				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderColor = specSettings.colors.bar.borderOvercap
					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					barBorderColor = specSettings.colors.bar.border
					snapshotData.audio.overcapCue = false
				end

				if specSettings.colors.bar.mindFlayInsanityBorderChange and TRB.Functions.Class:IsValidVariableForSpec("$mfiTime") then
					barBorderColor = specSettings.colors.bar.borderMindFlayInsanity
				end

				if specSettings.colors.bar.deathsTorment.enabled and snapshots[spells.deathsTorment.id].buff.applications >= specSettings.deathsTorment.stacks then
					barBorderColor = specSettings.colors.bar.deathsTorment.color
				end

				if specSettings.colors.bar.deathspeaker.enabled and TRB.Functions.Class:IsValidVariableForSpec("$deathspeakerTime") then
					barBorderColor = specSettings.colors.bar.deathspeaker.color
				end
				
				if specSettings.colors.bar.deathsTormentMax.enabled and snapshots[spells.deathsTorment.id].buff.applications == spells.deathsTorment.attributes.maxStacks then
					barBorderColor = specSettings.colors.bar.deathsTormentMax.color
				end
				
				if specSettings.colors.bar.mindDevourer.enabled and snapshots[spells.mindDevourer.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.mindDevourer.color
				end

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				if CastingSpell() and specSettings.bar.showCasting  then
					castingBarValue = snapshotData.casting.resourceFinal + currentResource
				else
					castingBarValue = currentResource
				end

				if specSettings.bar.showPassive and
					(talents:IsTalentActive(spells.auspiciousSpirits) or
					(snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal) > 0 or
					snapshots[spells.idolOfCthun.id].attributes.resourceFinal > 0) then
					passiveValue = ((CalculateResourceGain(spells.auspiciousSpirits.resource) * (snapshotData.targetData.custom.auspiciousSpiritsGenerate or 0)) + snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal + snapshots[spells.idolOfCthun.id].attributes.resourceFinal)
					if (snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal) > 0 and (castingBarValue + (snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal)) < TRB.Data.character.maxResource then
						TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, (castingBarValue + (snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal)), TRB.Data.character.maxResource)
						TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
						TRB.Frames.passiveFrame.thresholds[1]:Show()
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
					end
				else
					TRB.Frames.passiveFrame.thresholds[1]:Hide()
					passiveValue = 0
				end

				local pairOffset = 0

				local pairOffset = 0
				for _, v in pairs(TRB.Data.spellsData.spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						pairOffset = (spell.thresholdId - 1) * 3
						local resourceAmount = -spell:GetPrimaryResourceCost()
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
						
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.settingKey == spells.devouringPlague--[[@as TRB.Classes.SpellThreshold]].settingKey then
								if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif resourceAmount >= TRB.Data.character.maxResource then
									showThreshold = false
								elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and currentTime < snapshots[spells.mindDevourer.id].buff.endTime then
									thresholdColor = specSettings.colors.threshold.over
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.settingKey == spells.devouringPlague2--[[@as TRB.Classes.SpellThreshold]].settingKey then
								if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif -resourceAmount >= TRB.Data.character.maxResource then
									showThreshold = false
								elseif snapshots[spells.mindDevourer.id].buff.isActive and
									currentResource >= spells.devouringPlague:GetPrimaryResourceCost() then
									thresholdColor = specSettings.colors.threshold.over
								elseif specSettings.thresholds.devouringPlagueThresholdOnlyOverShow and
										spells.devouringPlague:GetPrimaryResourceCost() > currentResource  then
									showThreshold = false
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.settingKey == spells.devouringPlague3--[[@as TRB.Classes.SpellThreshold]].settingKey then
								if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif -resourceAmount >= TRB.Data.character.maxResource then
									showThreshold = false
								elseif snapshots[spells.mindDevourer.id].buff.isActive and
									currentResource >= spells.devouringPlague2:GetPrimaryResourceCost() then
									thresholdColor = specSettings.colors.threshold.over
								elseif specSettings.thresholds.devouringPlagueThresholdOnlyOverShow and
									spells.devouringPlague2:GetPrimaryResourceCost() > currentResource then
									showThreshold = false
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
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
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif currentResource >= -resourceAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else -- This is an active/available/normal spell threshold
							if currentResource >= -resourceAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spells[spell.settingKey].id], specSettings)
					end
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
				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end


				if snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= TRB.Data.character.devouringPlagueThreshold then
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.devouringPlagueUsableCasting, true))
				else
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
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
					elseif snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= TRB.Data.character.devouringPlagueThreshold then
						barColor = specSettings.colors.bar.devouringPlagueUsable
					else
						barColor = specSettings.colors.bar.inVoidform
					end
				else
					if snapshots[spells.mindDevourer.id].buff.isActive or currentResource >= TRB.Data.character.devouringPlagueThreshold then
						barColor = specSettings.colors.bar.devouringPlagueUsable
					else
						barColor = specSettings.colors.bar.base
					end
				end
				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
			end
		end
		
		--TODO #339: Comment out to reduce load while testing
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local triggerUpdate = false

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local currentTime = GetTime()
		local _
		local specId = GetSpecialization()
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

		local settings
		if specId == 1 then
			settings = TRB.Data.settings.priest.discipline
			spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		elseif specId == 2 then
			settings = TRB.Data.settings.priest.holy
			spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		elseif specId == 3 then
			settings = TRB.Data.settings.priest.shadow
			spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if (specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (specId == 2 and TRB.Data.barConstructedForSpec == "holy") then -- Let's check raid effect mana stuff
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
				elseif entry.type == "SPELL_ENERGIZE" and entry.spellId == snapshots[spells.shadowfiend.id].spell.energizeId then
					snapshots[spells.shadowfiend.id].attributes.swingTime = currentTime
					snapshots[spells.shadowfiend.id].cooldown:Refresh(true)
					triggerUpdate = true
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
				if entry.type == "SPELL_ENERGIZE" and (entry.spellId == spells.mindbender.energizeId or entry.spellId == spells.shadowfiend.energizeId) then
					if entry.sourceGuid == snapshots[spells.shadowfiend.id].attributes.guid then
						snapshots[spells.shadowfiend.id].attributes.swingTime = currentTime
						snapshots[spells.shadowfiend.id].cooldown:Refresh(true)
					end
					triggerUpdate = true
				end
			end
		end
		
		if entry.sourceGuid == TRB.Data.character.guid then
			if (specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (specId == 2 and TRB.Data.barConstructedForSpec == "holy") then -- Let's check raid effect mana stuff
				if entry.spellId == spells.potionOfFrozenFocusRank1.spellId or entry.spellId == spells.potionOfFrozenFocusRank2.spellId or entry.spellId == spells.potionOfFrozenFocusRank3.spellId then
					local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
					channeledManaPotion.buff:Initialize(entry.type)
				elseif entry.spellId == spells.surgeOfLight.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
						snapshotData.audio.surgeOfLight2Cue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.surgeOfLightCue = false
						snapshotData.audio.surgeOfLight2Cue = false
					end
				elseif entry.type == "SPELL_SUMMON" and (entry.spellId == spells.shadowfiend.id or (specId == 1 and entry.spellId == spells.mindbender.id)) then
					local currentSf = snapshots[spells.shadowfiend.id].attributes
					local totemId = 1
					currentSf.guid = entry.sourceGuid
					currentSf.totemId = totemId
				end
			end

			if specId == 1 and TRB.Data.barConstructedForSpec == "discipline" then
				if entry.spellId == spells.rapture.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.atonement.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid, true, true) then
						triggerUpdate = targetData:HandleCombatLogBuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.shadowCovenant.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.purgeTheWicked.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.powerWordRadiance.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast PW: Radiance
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.evangelism.id then
					if entry.type == "SPELL_CAST_SUCCESS" then -- Cast PW: Radiance
						local targets = TRB.Data.snapshotData.targetData.targets
						if TRB.Functions.Table:Length(targets) > 0 then
							for guid, target in pairs(targets) do
								if target.spells[spells.atonement.id].active and target.spells[spells.atonement.id].endTime ~= nil then
									target.spells[spells.atonement.id].endTime = target.spells[spells.atonement.id].endTime + spells.evangelism.attributes.atonementMod
									target.spells[spells.atonement.id].remainingTime = target.spells[spells.atonement.id].remainingTime + spells.evangelism.attributes.atonementMod
								end
							end
						end
					end
				end
			elseif specId == 2 and TRB.Data.barConstructedForSpec == "holy" then
				if entry.spellId == spells.apotheosis.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.lightweaver.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.resonantWords.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.holyWordSerenity.id then
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
				elseif entry.spellId == spells.divineConversation.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.prayerFocus.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.sacredReverence.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				elseif entry.spellId == spells.symbolOfHope.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
				if entry.spellId == spells.voidform.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.darkAscension.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.vampiricTouch.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.devouringPlague.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif settings.auspiciousSpiritsTracker and talents:IsTalentActive(spells.auspiciousSpirits) and entry.spellId == spells.auspiciousSpirits.attributes.idSpawn and entry.type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
					for guid, _ in pairs(targetData.targets) do
						if targetData.targets[guid].spells[spells.vampiricTouch.id].active then
							targetData.targets[guid].spells[spells.auspiciousSpirits.id].active = true
							targetData.targets[guid].spells[spells.auspiciousSpirits.id].count = targetData.targets[guid].spells[spells.auspiciousSpirits.id].count + 1
						end
						targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] + 1
					end
					triggerUpdate = true
				elseif settings.auspiciousSpiritsTracker and talents:IsTalentActive(spells.auspiciousSpirits) and entry.spellId == spells.auspiciousSpirits.attributes.idImpact and (entry.type == "SPELL_DAMAGE" or entry.type == "SPELL_MISSED" or entry.type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
					if targetData:CheckTargetExists(entry.destinationGuid) then
						targetData.targets[entry.destinationGuid].spells[spells.auspiciousSpirits.id].count = targetData.targets[entry.destinationGuid].spells[spells.auspiciousSpirits.id].count - 1
						targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] - 1
					end
					triggerUpdate = true
				elseif entry.type == "SPELL_ENERGIZE" and entry.spellId == spells.shadowCrash.id then
					triggerUpdate = true
				elseif entry.spellId == spells.mindDevourer.buffId then
					snapshots[spells.mindDevourer.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.devouredDespair.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.mindFlayInsanity.buffId or entry.spellId == spells.mindSpikeInsanity.buffId then
					snapshots[spells.surgeOfInsanity.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.deathspeaker.buffId then
					snapshots[spells.deathspeaker.id].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" then
						if TRB.Data.settings.priest.shadow.audio.deathspeaker.enabled then
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif entry.spellId == spells.deathsTorment.id then
					snapshots[spells.deathsTorment.id].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" or entry.type == "SPELL_AURA_APPLIED_DOSE" then
						if TRB.Data.settings.priest.shadow.audio.deathsTormentMax.enabled and not snapshotData.audio.deathsTormentMaxCue and snapshots[spells.deathsTorment.id].buff.applications == spells.deathsTorment.attributes.maxStacks then
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.deathsTormentMax.sound, TRB.Data.settings.core.audio.channel.channel)
							snapshotData.audio.deathsTormentCue = true
							snapshotData.audio.deathsTormentMaxCue = true
						elseif TRB.Data.settings.priest.shadow.audio.deathsTorment.enabled and not snapshotData.audio.deathsTormentCue and snapshots[spells.deathsTorment.id].buff.applications >= settings.deathsTorment.stacks then
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.deathsTorment.sound, TRB.Data.settings.core.audio.channel.channel)
							snapshotData.audio.deathsTormentCue = true
						end
					elseif entry.type == "SPELL_AURA_REMOVED" or entry.type == "SPELL_AURA_REMOVED_DOSE" then
						snapshotData.audio.deathsTormentCue = false
						snapshotData.audio.deathsTormentMaxCue = false
					end
				elseif entry.spellId == spells.twistOfFate.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.shadowyInsight.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.mindMelt.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.idolOfYoggSaron.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.thingFromBeyond.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
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
				elseif entry.type == "SPELL_SUMMON" and settings.mindbender.enabled and (entry.spellId == spells.shadowfiend.id or entry.spellId == spells.mindbender.id) then
					local currentSf = snapshots[spells.shadowfiend.id].attributes
					local totemId = 1
					currentSf.guid = entry.sourceGuid
					currentSf.totemId = totemId
				end
			end

			-- Spec agnostic
			if entry.spellId == spells.shadowWordPain.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			end
		elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" and settings.voidTendrilTracker and (entry.spellId == spells.idolOfCthun_Tendril.tickId or entry.spellId == spells.idolOfCthun_Lasher.tickId) and CheckVoidTendrilExists(entry.sourceGuid) then
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
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
			triggerUpdate = true
		end
	end

	if triggerUpdate then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end)

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		TRB.Functions.Class:TriggerResourceBarUpdates()
		self.sinceLastUpdate = 0
	end
end

combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event =="PLAYER_REGEN_DISABLED" then
		TRB.Functions.Bar:ShowResourceBar()
	else
		TRB.Functions.Bar:HideResourceBar()
	end
end)

local function SwitchSpec()
	barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local specId = GetSpecialization()
	if specId == 1 then
		specCache.discipline.talents:GetTalents()
		FillSpellData_Discipline()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.discipline)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.shadowWordPain)
		targetData:AddSpellTracking(spells.purgeTheWicked)
		targetData:AddSpellTracking(spells.atonement)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Discipline
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.discipline)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.discipline)

		local lookup = TRB.Data.lookup or {}
		lookup["#atonement"] = spells.atonement.icon
		lookup["#pwRadiance"] = spells.powerWordRadiance.icon
		lookup["#radiance"] = spells.powerWordRadiance.icon
		lookup["#powerWordRadiance"] = spells.powerWordRadiance.icon
		lookup["#ptw"] = spells.purgeTheWicked.icon
		lookup["#purgeTheWicked"] = spells.purgeTheWicked.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#rapture"] = spells.rapture.icon
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
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "discipline" then
			talents = specCache.discipline.talents
			TRB.Data.barConstructedForSpec = "discipline"
			ConstructResourceBar(specCache.discipline.settings)
		end
	elseif specId == 2 then
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
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.holy)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.holy)

		local lookup = TRB.Data.lookup or {}
		lookup["#apotheosis"] = spells.apotheosis.icon
		lookup["#coh"] = spells.circleOfHealing.icon
		lookup["#circleOfHealing"] = spells.circleOfHealing.icon
		lookup["#flashHeal"] = spells.flashHeal.icon
		lookup["#ha"] = spells.harmoniousApparatus.icon
		lookup["#harmoniousApparatus"] = spells.harmoniousApparatus.icon
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
		lookup["#pom"] = spells.prayerOfMending.icon
		lookup["#prayerOfMending"] = spells.prayerOfMending.icon
		lookup["#renew"] = spells.renew.icon
		lookup["#smite"] = spells.smite.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#sol"] = spells.surgeOfLight.icon
		lookup["#surgeOfLight"] = spells.surgeOfLight.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#sacredReverence"] = spells.sacredReverence.icon
		lookup["#sf"] = spells.shadowfiend.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "holy" then
			talents = specCache.holy.talents
			TRB.Data.barConstructedForSpec = "holy"
			ConstructResourceBar(specCache.holy.settings)
		end
	elseif specId == 3 then
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

		TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.shadow)
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
		lookup["#mindbender"] = spells.mindbender.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
		lookup["#sf"] = spells.shadowfiend.icon
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
		lookup["#mm"] = spells.mindMelt.icon
		lookup["#mindMelt"] = spells.mindMelt.icon
		lookup["#ys"] = spells.idolOfYoggSaron.icon
		lookup["#idolOfYoggSaron"] = spells.idolOfYoggSaron.icon
		lookup["#tfb"] = spells.thingFromBeyond.icon
		lookup["#thingFromBeyond"] = spells.thingFromBeyond.icon
		lookup["#md"] = spells.massDispel.icon
		lookup["#massDispel"] = spells.massDispel.icon
		lookup["#cthun"] = spells.idolOfCthun.icon
		lookup["#idolOfCthun"] = spells.idolOfCthun.icon
		lookup["#loi"] = spells.idolOfCthun.icon
		lookup["#swd"] = spells.deathspeaker.icon
		lookup["#halo"] = spells.halo.icon
		lookup["#shadowWordDeath"] = spells.deathspeaker.icon
		lookup["#deathspeaker"] = spells.deathspeaker.icon
		lookup["#deathsTorment"] = spells.deathsTorment.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "shadow" then
			talents = specCache.shadow.talents
			TRB.Data.barConstructedForSpec = "shadow"
			ConstructResourceBar(specCache.shadow.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	TRB.Functions.Class:EventRegistration()
end

resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	local specId = GetSpecialization() or 0
	if classIndexId == 5 then
		if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Options:PortForwardSettings()

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
					TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
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

		if TRB.Details.addonData.loaded and specId > 0 then
			if not TRB.Details.addonData.optionsPanel then
				TRB.Details.addonData.optionsPanel = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.priest.discipline = TRB.Functions.LibSharedMedia:ValidateLsmValues("Discipline Priest", TRB.Data.settings.priest.discipline)
						TRB.Data.settings.priest.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues("Holy Priest", TRB.Data.settings.priest.holy)
						TRB.Data.settings.priest.shadow = TRB.Functions.LibSharedMedia:ValidateLsmValues("Shadow Priest", TRB.Data.settings.priest.shadow)
						
						FillSpellData_Discipline()
						FillSpellData_Holy()
						FillSpellData_Shadow()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()
						TRB.Options.Priest.ConstructOptionsPanel(specCache)
						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end
						TRB.Functions.Class:EventRegistration()
						TRB.Functions.News:Init()
					end)
				end)
			end

			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
				SwitchSpec()
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "priest"
	local specId = GetSpecialization()
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	if specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		TRB.Data.character.specName = "discipline"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)

		local bootsItemLink = GetInventoryItemLink("player", 8)
		local trinket1ItemLink = GetInventoryItemLink("player", 13)
		local trinket2ItemLink = GetInventoryItemLink("player", 14)

		local alchemyStone = false
		local conjuredChillglobe = false
		local conjuredChillglobeMana = 0
		local imbuedFrostweaveSlippers = false
		
		if bootsItemLink ~= nil then
			imbuedFrostweaveSlippers = TRB.Functions.Item:DoesItemLinkMatchId(bootsItemLink, spells.imbuedFrostweaveSlippers.itemId)
		end

		if trinket1ItemLink ~= nil then
			for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.attributes.itemIds) do
				if alchemyStone == false then
					alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, spells.alchemistStone.attributes.itemIds[x])
				else
					break
				end
			end

			if alchemyStone == false then
				conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
			end
		end

		if alchemyStone == false and trinket2ItemLink ~= nil then
			for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.attributes.itemIds) do
				if alchemyStone == false then
					alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, spells.alchemistStone.attributes.itemIds[x])
				else
					break
				end
			end
		end

		if conjuredChillglobe == false and trinket2ItemLink ~= nil then
			conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
		end

		TRB.Data.character.items.alchemyStone = alchemyStone
		TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
		TRB.Data.character.items.conjuredChillglobe.mana = conjuredChillglobeMana
		TRB.Data.character.items.imbuedFrostweaveSlippers = imbuedFrostweaveSlippers

		if talents:IsTalentActive(spells.mindbender) then
			snapshots[spells.shadowfiend.id].spell = spells.mindbender
		else
			snapshots[spells.shadowfiend.id].spell = spells.shadowfiend
		end
		
		local totalPowerWordCharges = 0
		
		if talents:IsTalentActive(spells.powerWordRadiance) and TRB.Data.settings.priest.discipline.colors.comboPoints.powerWordRadianceEnabled then
			totalPowerWordCharges = totalPowerWordCharges + 1
			if talents:IsTalentActive(spells.lightsPromise) then
				totalPowerWordCharges = totalPowerWordCharges + 1
			end
		end

		TRB.Data.character.maxResource2 = totalPowerWordCharges
		TRB.Functions.Bar:SetPosition(TRB.Data.settings.priest.discipline, TRB.Frames.barContainerFrame)
	elseif specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		TRB.Data.character.specName = "holy"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)

		local bootsItemLink = GetInventoryItemLink("player", 8)
		local trinket1ItemLink = GetInventoryItemLink("player", 13)
		local trinket2ItemLink = GetInventoryItemLink("player", 14)

		local alchemyStone = false
		local conjuredChillglobe = false
		local conjuredChillglobeMana = ""
		local imbuedFrostweaveSlippers = false
		
		if bootsItemLink ~= nil then
			imbuedFrostweaveSlippers = TRB.Functions.Item:DoesItemLinkMatchId(bootsItemLink, spells.imbuedFrostweaveSlippers.itemId)
		end
					
		if trinket1ItemLink ~= nil then
			for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.attributes.itemIds) do
				if alchemyStone == false then
					alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, spells.alchemistStone.attributes.itemIds[x])
				else
					break
				end
			end

			if alchemyStone == false then
				conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
			end
		end

		if alchemyStone == false and trinket2ItemLink ~= nil then
			for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.attributes.itemIds) do
				if alchemyStone == false then
					alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, spells.alchemistStone.attributes.itemIds[x])
				else
					break
				end
			end
		end

		if conjuredChillglobe == false and trinket2ItemLink ~= nil then
			conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
		end

		TRB.Data.character.items.alchemyStone = alchemyStone
		TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
		TRB.Data.character.items.conjuredChillglobe.mana = conjuredChillglobeMana
		TRB.Data.character.items.imbuedFrostweaveSlippers = imbuedFrostweaveSlippers

		local totalHolyWordCharges = 0
		
		if talents:IsTalentActive(spells.holyWordSerenity) and TRB.Data.settings.priest.holy.colors.comboPoints.holyWordSerenityEnabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
			if talents:IsTalentActive(spells.miracleWorker) then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end
		end
		
		if talents:IsTalentActive(spells.holyWordSanctify) and TRB.Data.settings.priest.holy.colors.comboPoints.holyWordSanctifyEnabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
			if talents:IsTalentActive(spells.miracleWorker) then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end
		end
		
		if talents:IsTalentActive(spells.holyWordChastise) and TRB.Data.settings.priest.holy.colors.comboPoints.holyWordChastiseEnabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
		end

		TRB.Data.character.maxResource2 = totalHolyWordCharges
		TRB.Functions.Bar:SetPosition(TRB.Data.settings.priest.holy, TRB.Frames.barContainerFrame)
	elseif specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		TRB.Data.character.specName = "shadow"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Resource)

		TRB.Data.character.devouringPlagueThreshold = -spells.devouringPlague:GetPrimaryResourceCost()
		
		if talents:IsTalentActive(spells.mindbender) then
			snapshots[spells.shadowfiend.id].spell = spells.mindbender
		else
			snapshots[spells.shadowfiend.id].spell = spells.shadowfiend
		end
		
		if talents:IsTalentActive(spells.mindSpike) then
			snapshots[spells.surgeOfInsanity.id].spell = spells.mindSpikeInsanity
		else
			snapshots[spells.surgeOfInsanity.id].spell = spells.mindFlayInsanity
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	local specId = GetSpecialization()
	local specSettings
	if specId == 1 and TRB.Data.settings.core.enabled.priest.discipline == true then
		specSettings = TRB.Data.settings.priest.discipline
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
	elseif specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
		specSettings = TRB.Data.settings.priest.holy
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
	elseif specId == 3 and TRB.Data.settings.core.enabled.priest.shadow == true then
		specSettings = TRB.Data.settings.priest.shadow
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Resource
		TRB.Data.resourceFactor = 100
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
	else
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then
		TRB.Functions.BarText:IsTtdActive(specSettings)
		TRB.Functions.Class:CheckCharacter()

		TRB.Functions.BarText:CreateBarTextFrames(specSettings)
		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
		TRB.Frames.barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		TRB.Frames.barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = true
	else
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		TRB.Frames.barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		TRB.Frames.barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = false
		TRB.Frames.barContainerFrame:Hide()
	end
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Class:HideResourceBar(force)
	local specId = GetSpecialization()
	local affectingCombat = UnitAffectingCombat("player")
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if specId == 1 then
		if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not TRB.Data.settings.priest.discipline.displayBar.dragonriding) or 
			((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.priest.discipline.displayBar.alwaysShow) and (
					(not TRB.Data.settings.priest.discipline.displayBar.notZeroShow) or
					(TRB.Data.settings.priest.discipline.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.priest.discipline.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 2 then
		if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not TRB.Data.settings.priest.holy.displayBar.dragonriding) or 
			((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.priest.holy.displayBar.alwaysShow) and (
					(not TRB.Data.settings.priest.holy.displayBar.notZeroShow) or
					(TRB.Data.settings.priest.holy.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.priest.holy.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 3 then
		if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not TRB.Data.settings.priest.shadow.displayBar.dragonriding) or 
			((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.priest.shadow.displayBar.alwaysShow) and (
					(not TRB.Data.settings.priest.shadow.displayBar.notZeroShow) or
					(TRB.Data.settings.priest.shadow.displayBar.notZeroShow and snapshotData.attributes.resource == 0)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.priest.shadow.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed, isFriend)
	if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
		return false
	end

	if guid ~= nil and guid ~= "" then
		local currentTime = GetTime()
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		local targets = targetData.targets
		
		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid, isFriend)
		end
		if isFriend then
			targets[guid].isFriend = true
		end
		targets[guid].lastUpdate = currentTime
		return true
	end
	return false
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end
	local specId = GetSpecialization()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local spells = spellsData.spells
	local settings = nil
	if specId == 1 then
		settings = TRB.Data.settings.priest.discipline
	elseif specId == 2 then
		settings = TRB.Data.settings.priest.holy
	elseif specId == 3 then
		settings = TRB.Data.settings.priest.shadow
	else
		return false
	end

	if specId == 1 or specId == 2 then
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
			local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfFrozenFocusTicks" then
			local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfFrozenFocusTime" then
			local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionCooldown" then
			if snapshots[spells.aeratedManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		elseif var == "$potionCooldownSeconds" then
			if snapshots[spells.aeratedManaPotionRank1.id].cooldown:IsUnusable() then
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
		elseif var == "$sfMana" then
			if snapshots[spells.shadowfiend.id].attributes.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$sfGcds" then
			if snapshots[spells.shadowfiend.id].attributes.remaining.gcds > 0 then
				valid = true
			end
		elseif var == "$sfSwings" then
			if snapshots[spells.shadowfiend.id].attributes.remaining.swings > 0 then
				valid = true
			end
		elseif var == "$sfTime" then
			if snapshots[spells.shadowfiend.id].attributes.remaining.time > 0 then
				valid = true
			end
		end
	end

	if specId == 1 then
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
		elseif var == "$raptureTime" then
			if snapshots[spells.rapture.id].buff.isActive then
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
	elseif specId == 2 then
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
	elseif specId == 3 then
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
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) or
				(((CalculateResourceGain(spells.auspiciousSpirits.resource) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + snapshots[spells.shadowfiend.id].attributes.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0) then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
			local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
			if snapshotData.attributes.resource > 0 or
				((CalculateResourceGain(spells.auspiciousSpirits.resource) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + snapshots[spells.shadowfiend.id].attributes.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$passive" then
			if ((CalculateResourceGain(spells.auspiciousSpirits.resource) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + snapshots[spells.shadowfiend.id].attributes.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0 then
				valid = true
			end
		elseif var == "$mbInsanity" then
			if snapshots[spells.shadowfiend.id].attributes.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$mbGcds" then
			if snapshots[spells.shadowfiend.id].attributes.remaining.gcds > 0 then
				valid = true
			end
		elseif var == "$mbSwings" then
			if snapshots[spells.shadowfiend.id].attributes.remaining.swings > 0 then
				valid = true
			end
		elseif var == "$mbTime" then
			if snapshots[spells.shadowfiend.id].attributes.remaining.time > 0 then
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
			if TRB.Data.settings.priest.shadow.voidTendrilTracker and (talents:IsTalentActive(spells.idolOfCthun) or TRB.Data.character.items.callToTheVoid == true) then
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
			if snapshots[spells.surgeOfInsanity.id].buff.isActive then
				valid = true
			end
		elseif var == "$mfiStacks" then
			if snapshots[spells.surgeOfInsanity.id].buff.isActive then
				valid = true
			end
		elseif var == "$deathspeakerTime" then
			if snapshots[spells.deathspeaker.id].buff.isActive then
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
		elseif var == "$mmTime" then
			if snapshots[spells.mindMelt.id].buff.isActive then
				valid = true
			end
		elseif var == "$mmStacks" then
			if snapshots[spells.mindMelt.id].buff.isActive then
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
		else
			valid = false
		end
	end

	-- Spec Agnostic
	local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	if var == "$swpCount" then
		if snapshotData.targetData.count[spells.shadowWordPain.id] > 0 or (specId == 1 and snapshotData.targetData.count[spells.purgeTheWicked.id] > 0) then
			valid = true
		end
	elseif var == "$swpTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			((target.spells[spells.shadowWordPain.id] ~= nil and
			target.spells[spells.shadowWordPain.id].remainingTime > 0) or
			(specId == 1 and target.spells[spells.purgeTheWicked.id] ~= nil and
			target.spells[spells.purgeTheWicked.id].remainingTime > 0)) then
			valid = true
		end
	end
	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local specId = GetSpecialization()
	local settings = TRB.Data.settings.priest
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	if specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		if TRB.Functions.String:StartsWith(relativeToFrame, "PowerWord_") then
			if TRB.Functions.String:Contains(relativeToFrame, "Radiance") and settings.discipline.colors.comboPoints.powerWordRadianceEnabled and talents:IsTalentActive(spells.powerWordRadiance) then
				if TRB.Functions.String:EndsWith(relativeToFrame, "1") then
					return _G["TwintopResourceBarFrame_ComboPoint_1"]
				elseif TRB.Functions.String:EndsWith(relativeToFrame, "2") and talents:IsTalentActive(spells.lightsPromise) then
					return _G["TwintopResourceBarFrame_ComboPoint_2"]
				end
			end
		end
	elseif specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		if TRB.Functions.String:StartsWith(relativeToFrame, "HolyWord_") then
			if TRB.Functions.String:Contains(relativeToFrame, "Serenity") and settings.holy.colors.comboPoints.holyWordSerenityEnabled and talents:IsTalentActive(spells.holyWordSerenity) then
				if TRB.Functions.String:EndsWith(relativeToFrame, "1") then
					return _G["TwintopResourceBarFrame_ComboPoint_1"]
				elseif TRB.Functions.String:EndsWith(relativeToFrame, "2") and talents:IsTalentActive(spells.miracleWorker) then
					return _G["TwintopResourceBarFrame_ComboPoint_2"]
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
					return _G["TwintopResourceBarFrame_ComboPoint_"..nextHwCount]
				elseif TRB.Functions.String:EndsWith(relativeToFrame, "2") and talents:IsTalentActive(spells.miracleWorker) then
					local nextHwCount = 2
					if settings.holy.colors.comboPoints.holyWordSerenityEnabled and talents:IsTalentActive(spells.holyWordSerenity) then
						nextHwCount = nextHwCount + 1
						if talents:IsTalentActive(spells.miracleWorker) then
							nextHwCount = nextHwCount + 1
						end
					end
					return _G["TwintopResourceBarFrame_ComboPoint_"..nextHwCount]
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
				return _G["TwintopResourceBarFrame_ComboPoint_"..nextHwCount]
			end
		end
	elseif specId == 3 then
	end
	return nil
end

--HACK to fix FPS
local updateRateLimit = 0
local updateMemory = 0
local highMemory = 0
local currentMemory = 0

function TRB.Functions.Class:TriggerResourceBarUpdates()
	local specId = GetSpecialization()
	if (specId ~= 1 and specId ~= 2 and specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	local currentTime = GetTime()

	if updateRateLimit + 0.05 < currentTime then
		updateRateLimit = currentTime
		UpdateResourceBar()
	end

	--TODO #339: Remove commented out to do memory load testing
	--[[if updateMemory + 5 < currentTime then
		updateMemory = currentTime
		UpdateAddOnMemoryUsage()
		currentMemory = GetAddOnMemoryUsage("TwintopInsanityBar")
		print(string.format("%.2f (%.2f)", currentMemory, highMemory))
		if currentMemory > highMemory then
			highMemory = currentMemory
		end
	end]]
end