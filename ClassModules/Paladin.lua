local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 2 then --Only do this if we're on an Paladin!
	local L = TRB.Localization
	TRB.Functions.Class = TRB.Functions.Class or {}
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resource2Frame = TRB.Frames.resource2Frame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame
	
	local talents --[[@as TRB.Classes.Talents]]

	Global_TwintopResourceBar = {}
	TRB.Data.character = {}

	local specCache = {
		holy = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
	}

	local function CalculateManaGain(mana, isPotion)
		if isPotion == nil then
			isPotion = false
		end

		local modifier = 1.0

		if isPotion then
			if TRB.Data.character.items.alchemyStone then
				modifier = modifier * TRB.Data.spells.alchemistStone.manaModifier
			end
		end

		return mana * modifier
	end

	local function FillSpecializationCache()
		-- Holy
		specCache.holy.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				symbolOfHope = 0,
			},
			dots = {
			},
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

		specCache.holy.spells = {
			-- Paladin Class Baseline Abilities

			-- Holy Baseline Abilities
			infusionOfLight = {
				id = 54149,
				name = "",
				icon = "",
				isTalent = false,
				baseline = true
			},

			-- Paladin Class Talents		
			
			-- Holy Spec Talents
			glimmerOfLight = {
				id = 287269,
				spellId = 287280,
				name = "",
				icon = "",
				isTalent = true,
				isDot = true,
				isBuff = true,
				isDebuff = true,
				duration = 30,
				debuffId = 287280,
				buffId = 287280
			},
			blessingOfWinter = {
				id = 388011,
				name = "",
				icon = "",
				hasTicks = true,
				resourcePerTick = 0,
				tickRate = 2,
				manaPercent = 0.01
			},
			daybreak = {
				id = 414170,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 8,
				settingKey = "daybreak",
				isTalent = true,
				manaPercent = 0.008
			},

			-- External mana
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.02,
				ticks = 4,
				tickId = 265144
			},
			innervate = {
				id = 29166,
				name = "",
				icon = "",
				duration = 10
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
			},

			-- Potions
			aeratedManaPotionRank1 = {
				id = 370607,
				itemId = 191384,
				spellId = 370607,
				iconName = "inv_10_alchemy_bottle_shape1_blue",
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 1,
				settingKey = "aeratedManaPotionRank1"
			},
			aeratedManaPotionRank2 = {
				itemId = 191385,
				spellId = 370607,
				iconName = "inv_10_alchemy_bottle_shape1_blue",
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 2,
				settingKey = "aeratedManaPotionRank2"
			},
			aeratedManaPotionRank3 = {
				itemId = 191386,
				spellId = 370607,
				iconName = "inv_10_alchemy_bottle_shape1_blue",
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 3,
				settingKey = "aeratedManaPotionRank3"
			},
			potionOfFrozenFocusRank1 = {
				id = 371033,
				itemId = 191363,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 4,
				settingKey = "potionOfFrozenFocusRank1"
			},
			potionOfFrozenFocusRank2 = {
				itemId = 191364,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 5,
				settingKey = "potionOfFrozenFocusRank2"
			},
			potionOfFrozenFocusRank3 = {
				itemId = 191365,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 6,
				settingKey = "potionOfFrozenFocusRank3"
			},
			potionOfChilledClarity = {
				id = 371052,
				name = "",
				icon = ""
			},

			-- Conjured Chillglobe
			conjuredChillglobe = {
				id = 396391,
				itemId = 194300,
				spellId = 396391,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 7,
				settingKey = "conjuredChillglobe",
				mana = 4830,
				duration = 10,
				ticks = 10
			},

			-- Alchemist Stone
			alchemistStone = {
				id = 17619,
				name = "",
				icon = "",
				manaModifier = 1.4,
				itemIds = {
					171323,
					175941,
					175942,
					175943
				}
			},

			-- Rashok's Molten Heart
			moltenRadiance = {
				id = 409898,
				name = "",
				icon = "",
			}

		}

		specCache.holy.snapshotData.attributes.manaRegen = 0
		specCache.holy.snapshotData.audio = {
			innervateCue = false,
			infusionOfLightCue = false,
			infusionOfLight2Cue = false
		}

		---@type TRB.Classes.Healer.Innervate
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.innervate.id] = TRB.Classes.Healer.Innervate:New(specCache.holy.spells.innervate)
		---@type TRB.Classes.Healer.PotionOfChilledClarity
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(specCache.holy.spells.potionOfChilledClarity)
		---@type TRB.Classes.Healer.ManaTideTotem
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(specCache.holy.spells.manaTideTotem)
		---@type TRB.Classes.Healer.SymbolOfHope
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(specCache.holy.spells.symbolOfHope, CalculateManaGain)
		---@type TRB.Classes.Healer.ChanneledManaPotion
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(specCache.holy.spells.potionOfFrozenFocusRank1, CalculateManaGain)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.aeratedManaPotionRank1)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.conjuredChillglobe)
		---@type TRB.Classes.Healer.MoltenRadiance
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(specCache.holy.spells.moltenRadiance)
		---@type TRB.Classes.Healer.BlessingOfWinter
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(specCache.holy.spells.blessingOfWinter)
		
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.glimmerOfLight.buffId] = TRB.Classes.Snapshot:New(specCache.holy.spells.glimmerOfLight, {
			minRemainingTime = 0,
			maxRemainingTime = 0
		})

		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.daybreak.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.daybreak)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.infusionOfLight.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.infusionOfLight)


		specCache.holy.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Holy()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "paladin", "holy")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)
	end

	local function FillSpellData_Holy()
		Setup_Holy()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.holy.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.holy.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
			
			{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
			{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

			{ variable = "#glimmer", icon = spells.glimmerOfLight.icon, description = spells.glimmerOfLight.name, printInSettings = true },
			{ variable = "#glimmerOfLight", icon = spells.glimmerOfLight.icon, description = spells.glimmerOfLight.name, printInSettings = false },

			{ variable = "#iol", icon = spells.infusionOfLight.icon, description = spells.infusionOfLight.name, printInSettings = true },
			{ variable = "#infusionOfLight", icon = spells.infusionOfLight.icon, description = spells.infusionOfLight.name, printInSettings = false },

			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

			{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
			{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
			{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
			{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
			{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
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

			{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
			{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
			{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["PaladinHolyBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$manaPlusCasting", description = L["PaladinHolyBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$manaPlusPassive", description = L["PaladinHolyBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$manaTotal", description = L["PaladinHolyBarTextVariable_manaTotal"], printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
						
			{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
			{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

			{ variable = "$iolTime", description =   L["PaladinHolyBarTextVariable_iolTime"], printInSettings = true, color = false },
			{ variable = "$iolStacks", description = L["PaladinHolyBarTextVariable_iolStacks"], printInSettings = true, color = false },

			{ variable = "$glimmerCount", description =   L["PaladinHolyBarTextVariable_glimmerCount"], printInSettings = true, color = false },
			{ variable = "$glimmerTime", description =    L["PaladinHolyBarTextVariable_glimmerTime"], printInSettings = true, color = false },
			{ variable = "$glimmerMinTime", description = L["PaladinHolyBarTextVariable_glimmerMinTime"], printInSettings = true, color = false },
			{ variable = "$glimmerMaxTime", description = L["PaladinHolyBarTextVariable_glimmerMaxTime"], printInSettings = true, color = false },


			{ variable = "$bowMana", description = L["PaladinHolyBarTextVariable_bowMana"], printInSettings = true, color = false },
			{ variable = "$bowTime", description = L["PaladinHolyBarTextVariable_bowTime"], printInSettings = true, color = false },
			{ variable = "$bowTicks", description = L["PaladinHolyBarTextVariable_bowTicks"], printInSettings = true, color = false },

			{ variable = "$sohMana", description = L["PaladinHolyBarTextVariable_sohMana"], printInSettings = true, color = false },
			{ variable = "$sohTime", description = L["PaladinHolyBarTextVariable_sohTime"], printInSettings = true, color = false },
			{ variable = "$sohTicks", description = L["PaladinHolyBarTextVariable_sohTicks"], printInSettings = true, color = false },

			{ variable = "$innervateMana", description = L["PaladinHolyBarTextVariable_innervateMana"], printInSettings = true, color = false },
			{ variable = "$innervateTime", description = L["PaladinHolyBarTextVariable_innervateTime"], printInSettings = true, color = false },
			
			{ variable = "$mttMana", description = L["PaladinHolyBarTextVariable_mttMana"], printInSettings = true, color = false },
			{ variable = "$mttTime", description = L["PaladinHolyBarTextVariable_mttTime"], printInSettings = true, color = false },
						
			{ variable = "$mrMana", description = L["PaladinHolyBarTextVariable_mrMana"], printInSettings = true, color = false },
			{ variable = "$mrTime", description = L["PaladinHolyBarTextVariable_mrTime"], printInSettings = true, color = false },

			{ variable = "$channeledMana", description = L["PaladinHolyBarTextVariable_channeledMana"], printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTicks", description = L["PaladinHolyBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = L["PaladinHolyBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
			
			{ variable = "$potionOfChilledClarityMana", description = L["PaladinHolyBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = L["PaladinHolyBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

			{ variable = "$potionCooldown", description = L["PaladinHolyBarTextVariable_potionCooldown"], printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = L["PaladinHolyBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.holy.spells = spells
	end

	local function CalculateAbilityResourceValue(resource, threshold)
		local modifier = 1.0

		return resource * modifier
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		---@type TRB.Classes.TargetData
		local targetData = snapshotData.targetData
		
		if specId == 1 then -- Holy
			targetData:UpdateTrackedSpells(currentTime)
		end
	end

	local function TargetsCleanup(clearAll)
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshotData.targetData
		targetData:Cleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 1 then
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

		if specId == 1 then
			for x = 1, 8 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 6 do
				if TRB.Frames.passiveFrame.thresholds[x] == nil then
					TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
				end

				TRB.Frames.passiveFrame.thresholds[x]:Show()
				TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.passiveFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.paladin.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], TRB.Data.spells.daybreak.settingKey, TRB.Data.settings.paladin.holy)
		end

		TRB.Functions.Class:CheckCharacter()
		TRB.Frames.resource2ContainerFrame:Show()
		TRB.Functions.Bar:Construct(settings)
		TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
	end
	
	local function RefreshLookupData_Holy()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local specSettings = TRB.Data.settings.paladin.holy
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.manaRegen, _ = GetPowerRegen()

		local currentManaColor = specSettings.colors.text.current
		local castingManaColor = specSettings.colors.text.casting

		--$mana
		local manaPrecision = specSettings.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = snapshotData.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		--$glimmerMinTime
		local _glimmerMinTime = snapshots[spells.glimmerOfLight.buffId].attributes.minRemainingTime
		local glimmerMinTime = TRB.Functions.BarText:TimerPrecision(_glimmerMinTime)
		
		--$glimmerMaxTime
		local _glimmerMaxTime = snapshots[spells.glimmerOfLight.buffId].attributes.maxRemainingTime
		local glimmerMaxTime = TRB.Functions.BarText:TimerPrecision(_glimmerMaxTime)

		
		--$glimmerTime
		local _glimmerTime = 0

		if target ~= nil then
			_glimmerTime = target.spells[spells.glimmerOfLight.buffId].remainingTime or 0
		end
		local glimmerTime = TRB.Functions.BarText:TimerPrecision(_glimmerTime)

		--$glimmerCount
		local _glimmerCount = snapshotData.targetData.count[spells.glimmerOfLight.buffId] or 0
		local glimmerCount = string.format("%s", _glimmerCount)
		
		--$iolTime
		local _iolTime = snapshots[spells.infusionOfLight.id].buff:GetRemainingTime(currentTime)
		local iolTime = TRB.Functions.BarText:TimerPrecision(_iolTime)
		--$iolTicks
		local _iolStacks = snapshots[spells.infusionOfLight.id].buff.applications
		local iolStacks = string.format("%.0f", _iolStacks)

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

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana + _bowMana
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

		----------

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
		Global_TwintopResourceBar.glimmerOfLight = {
			count = _glimmerCount,
			targetTime = _glimmerTime,
			minTime = _glimmerMinTime,
			maxTime = _glimmerMaxTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
		lookup["#bow"] = spells.blessingOfWinter.icon
		lookup["#glimmer"] = spells.glimmerOfLight.icon
		lookup["#glimmerOfLight"] = spells.glimmerOfLight.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
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
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
		lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$mrMana"] = mrMana
		lookup["$mrTime"] = mrTime
		lookup["$bowMana"] = bowMana
		lookup["$bowTime"] = bowTime
		lookup["$bowTicks"] = bowTicks
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		lookup["$holyPower"] = snapshotData.attributes.resource2
		lookup["$comboPoints"] = snapshotData.attributes.resource2
		lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$glimmerMinTime"] = glimmerMinTime
		lookup["$glimmerMaxTime"] = glimmerMaxTime
		lookup["$glimmerTime"] = glimmerTime
		lookup["$glimmerCount"] = glimmerCount
		lookup["$iolTime"] = iolTime
		lookup["$iolStacks"] = iolStacks
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
		lookupLogic["$sohMana"] = _sohMana
		lookupLogic["$sohTime"] = _sohTime
		lookupLogic["$sohTicks"] = _sohTicks
		lookupLogic["$innervateMana"] = _innervateMana
		lookupLogic["$innervateTime"] = _innervateTime
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$mrMana"] = _mrMana
		lookupLogic["$mrTime"] = _mrTime
		lookupLogic["$bowMana"] = _bowMana
		lookupLogic["$bowTime"] = _bowTime
		lookupLogic["$bowTicks"] = _bowTicks
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$holyPower"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$glimmerMinTime"] = _glimmerMinTime
		lookupLogic["$glimmerMaxTime"] = _glimmerMaxTime
		lookupLogic["$glimmerTime"] = _glimmerTime
		lookupLogic["$glimmerCount"] = _glimmerCount
		lookupLogic["$iolTime"] = _iolTime
		lookupLogic["$iolStacks"] = _iolStacks
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		TRB.Data.snapshotData.casting.startTime = currentTime
		TRB.Data.snapshotData.casting.resourceRaw = spell.mana
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.mana)
		TRB.Data.snapshotData.casting.spellId = spell.id
		TRB.Data.snapshotData.casting.icon = spell.icon
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function UpdateCastingResourceFinal_Holy()
		-- Do nothing for now
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		-- Do nothing for now
		snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local casting = snapshotData.casting
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						casting.startTime = currentSpellStartTime / 1000
						casting.endTime = currentSpellEndTime / 1000
						casting.resourceRaw = manaCost
						casting.spellId = spellId
						casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Holy()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateGlimmerOfLight()
		local spells = TRB.Data.spells
		local glimmerOfLight = TRB.Data.snapshotData.snapshots[spells.glimmerOfLight.buffId] --[[@as TRB.Classes.Snapshot]]
		local targets = TRB.Data.snapshotData.targetData.targets
		local minRemainingTime = nil
		local maxRemainingTime = nil
		local currentTime = GetTime()
		if TRB.Functions.Table:Length(targets) > 0 then
			for guid, target in pairs(targets) do
				if target.spells[spells.glimmerOfLight.buffId].active and target.spells[spells.glimmerOfLight.buffId].endTime ~= nil then
					local remainingTime = (target.spells[spells.glimmerOfLight.buffId].endTime - currentTime)
					if remainingTime > 0 and remainingTime > (maxRemainingTime or 0) then
						maxRemainingTime = remainingTime
					end
				
					if remainingTime > 0 and remainingTime < (minRemainingTime or 999) then
						minRemainingTime = remainingTime
					end
				end
			end
		end

		glimmerOfLight.attributes.minRemainingTime = minRemainingTime or 0
		glimmerOfLight.attributes.maxRemainingTime = maxRemainingTime or 0
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Holy()
		local currentTime = GetTime()
		UpdateSnapshot()
		UpdateGlimmerOfLight()
		
		local _
		local spells = TRB.Data.spells
		---@type table<integer, TRB.Classes.Snapshot>
		local snapshots = TRB.Data.snapshotData.snapshots
		
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

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
		snapshots[spells.aeratedManaPotionRank1.id].cooldown.startTime, snapshots[spells.aeratedManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
		snapshots[spells.aeratedManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)

		snapshots[spells.conjuredChillglobe.id].cooldown.startTime, snapshots[spells.conjuredChillglobe.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
		snapshots[spells.conjuredChillglobe.id].cooldown:GetRemainingTime(currentTime)
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.paladin
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots

		if specId == 1 then
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

					local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

					if snapshots[spells.infusionOfLight.id].buff.isActive then
						if snapshots[spells.infusionOfLight.id].buff.applications == 1 then
							if specSettings.colors.bar.infusionOfLight.enabled then
								barBorderColor = specSettings.colors.bar.infusionOfLight.color
							end

							if specSettings.audio.infusionOfLight.enabled and not snapshotData.audio.infusionOfLightCue then
								snapshotData.audio.infusionOfLightCue = true
								PlaySoundFile(specSettings.audio.infusionOfLight.sound, coreSettings.audio.channel.channel)
							end
						end

						if snapshots[spells.infusionOfLight.id].buff.applications == 2 then
							if specSettings.colors.bar.infusionOfLight2.enabled then
								barBorderColor = specSettings.colors.bar.infusionOfLight2.color
							end

							if specSettings.audio.infusionOfLight2.enabled and not snapshotData.audio.infusionOfLight2Cue then
								snapshotData.audio.infusionOfLightCue = true
								snapshotData.audio.infusionOfLight2Cue = true
								PlaySoundFile(specSettings.audio.infusionOfLight2.sound, coreSettings.audio.channel.channel)
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

					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshotData.snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshotData.snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

					if talents:IsTalentActive(spells.daybreak) then
						local daybreak = snapshots[spells.daybreak.id]
						local daybreakThresholdColor = specSettings.colors.threshold.over
						if specSettings.thresholds.daybreak.enabled and (not daybreak.cooldown:IsUnusable() or specSettings.thresholds.daybreak.cooldown) then
							local daybreakMana = snapshotData.targetData.count[spells.glimmerOfLight.buffId] * daybreak.spell.manaPercent * TRB.Data.character.maxResource

							if daybreak.cooldown:IsUnusable() then
								daybreakThresholdColor = specSettings.colors.threshold.unusable
							end

							if daybreakMana > 0 and (castingBarValue + daybreakMana) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, (castingBarValue + daybreakMana), TRB.Data.character.maxResource)
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(daybreakThresholdColor, true))
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(daybreakThresholdColor, true))
								resourceFrame.thresholds[8]:Show()

								if specSettings.thresholds.icons.showCooldown and daybreak.cooldown.remaining > 0 then
									resourceFrame.thresholds[8].icon.cooldown:SetCooldown(daybreak.cooldown.startTime, daybreak.cooldown.duration)
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

					local passiveValue, _ = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
							
					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < snapshotData.attributes.resource then --Using a spender
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

					resourceBarColor = specSettings.colors.bar.base

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
					
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

					for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = specSettings.colors.comboPoints.border
						local cpColor = specSettings.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

						if snapshotData.attributes.resource2 >= x then
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = specSettings.colors.comboPoints.penultimate
							elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = specSettings.colors.comboPoints.final
							end
						else
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		end
	end

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local targetData = snapshotData.targetData
		local snapshots = snapshotData.snapshots

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
			
			local settings
			if specId == 1 then
				settings = TRB.Data.settings.paladin.holy
			end

			if entry.destinationGuid == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "holy" then -- Let's check raid effect mana stuff
					if settings.passiveGeneration.symbolOfHope and (entry.spellId == spells.symbolOfHope.tickId or entry.spellId == spells.symbolOfHope.id) then
						local symbolOfHope = snapshotData.snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
						local castByToken = UnitTokenFromGUID(entry.sourceGuid)
						symbolOfHope.buff:Initialize(entry.type, nil, castByToken)
					elseif settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
						local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
						innervate.buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshotData.audio.innervateCue = false
						elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.innervateCue = false
						end
					elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
						local manaTideTotem = snapshotData.snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
						manaTideTotem:Initialize(entry.type)
					elseif entry.spellId == spells.moltenRadiance.id then
						local moltenRadiance = snapshotData.snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
						moltenRadiance.buff:Initialize(entry.type)
					elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
						local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
						blessingOfWinter.buff:Initialize(entry.type)
					end
				end
			end

			if entry.sourceGuid == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "holy" then
					if entry.spellId == spells.potionOfFrozenFocusRank1.spellId or entry.spellId == spells.potionOfFrozenFocusRank2.spellId or entry.spellId == spells.potionOfFrozenFocusRank3.spellId then
						local channeledManaPotion = snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
						channeledManaPotion.buff:Initialize(entry.type)
					elseif entry.spellId == spells.potionOfChilledClarity.id then
						local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
						potionOfChilledClarity.buff:Initialize(entry.type)
					elseif entry.spellId == spells.glimmerOfLight.buffId and bit.band(entry.destinationFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid, true, true) then
							triggerUpdate = targetData:HandleCombatLogBuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.glimmerOfLight.debuffId then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid, true, false) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.daybreak.id then
						if entry.type == "SPELL_AURA_REMOVED" then -- Use this instead of SPELL_CAST_SUCCESS because of delays in triggering the cooldown
							snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.infusionOfLight.id then
						snapshots[spells.infusionOfLight.id].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
							snapshotData.audio.infusionOfLight2Cue = false
						elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.infusionOfLightCue = false
							snapshotData.audio.infusionOfLight2Cue = false
						end
					end
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
			specCache.holy.talents:GetTalents()
			FillSpellData_Holy()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)

			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.glimmerOfLight)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.paladin.holy)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.paladin.holy)

			if TRB.Data.barConstructedForSpec ~= "holy" then
				talents = specCache.holy.talents
				TRB.Data.barConstructedForSpec = "holy"
				ConstructResourceBar(specCache.holy.settings)
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
		if classIndexId == 2 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
						TRB.Options:PortForwardSettings()

						local settings = TRB.Options.Paladin.LoadDefaultSettings(false)

						if TwintopInsanityBarSettings.paladin == nil or
							TwintopInsanityBarSettings.paladin.holy == nil or
							TwintopInsanityBarSettings.paladin.holy.displayText == nil then
							settings.paladin.holy.displayText.barText = TRB.Options.Paladin.HolyLoadDefaultBarTextSimpleSettings()
						end

						TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
						local settings = TRB.Options.Paladin.LoadDefaultSettings(true)
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
							TRB.Data.barConstructedForSpec = nil
							TRB.Data.settings.paladin.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues("Holy Paladin", TRB.Data.settings.paladin.holy)
							
							FillSpellData_Holy()
							
							SwitchSpec()

							TRB.Options.Paladin.ConstructOptionsPanel(specCache)
							
							-- Reconstruct just in case
							if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
								ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
							end
							TRB.Functions.Class:EventRegistration()
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
		local spells = TRB.Data.spells
		local specId = GetSpecialization()
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "paladin"
		TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
		TRB.Data.character.maxResource2 = 1
		local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.paladin.holy
			TRB.Data.character.specName = "holy"
			TRB.Functions.Spell:FillSpellDataManaCost(spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeMana = ""
			
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
				end
			end

			if alchemyStone == false and trinket2ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, spells.alchemistStone.itemIds[x])
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

		end
		
		if settings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.paladin.holy then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.paladin.holy)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.HolyPower
			TRB.Data.resourceFactor = 1
		else -- This should never happen
			TRB.Data.specSupported = false
		end

		if TRB.Data.specSupported then
			TRB.Functions.Class:CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		else -- This should never happen
			targetsTimerFrame:SetScript("OnUpdate", nil)
			timerFrame:SetScript("OnUpdate", nil)
			barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = false
			barContainerFrame:Hide()
		end

		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not TRB.Data.settings.paladin.holy.displayBar.dragonriding) or 
			((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.paladin.holy.displayBar.alwaysShow) and (
						(not TRB.Data.settings.paladin.holy.displayBar.notZeroShow) or
						(TRB.Data.settings.paladin.holy.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.paladin.holy.displayBar.neverShow == true then
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
			local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
			local targets = targetData.targets

			if not targetData:CheckTargetExists(guid) then
				targetData:InitializeTarget(guid)
			end
			if isFriend then
				targets[guid].isFriend = true
			end
			targets[guid].lastUpdate = GetTime()
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
		local spells = TRB.Data.spells
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.paladin.holy
		else
			return false
		end

		if specId == 1 then --Holy
			if var == "$passive" then
				if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
					valid = true
				end
			elseif var == "glimmerCount" then
				if snapshotData.targetData.count[spells.glimmerOfLight.buffId] > 0 then
					valid = true
				end
			elseif var == "glimmerTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitIsFriend("player", "target") and
					target ~= nil and
					((target.spells[spells.glimmerOfLight.buffId] ~= nil and
					target.spells[spells.glimmerOfLight.buffId].remainingTime > 0)) then
					valid = true
				end
			elseif var == "glimmerMinTime" then
				if snapshots[spells.glimmerOfLight.buffId].attributes.minRemainingTime > 0 then
					valid = true
				end
			elseif var == "glimmerMaxTime" then
				if snapshots[spells.glimmerOfLight.buffId].attributes.maxRemainingTime > 0 then
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
			elseif var == "$iolTime" then
				if snapshots[spells.infusionOfLight.id].buff.isActive then
					valid = true
				end
			elseif var == "$iolStacks" then
				if snapshots[spells.infusionOfLight.id].buff.isActive then
					valid = true
				end
			end
		end

		--Spec agnostic
		if var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$resource" or var == "$mana" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$manaTotal" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$regen" then
			if snapshotData.attributes.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$comboPoints" or var == "$holyPower" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$holyPowerMax" then
			valid = true
		end

		return valid
	end

	function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
		local specId = GetSpecialization()
		local settings = TRB.Data.settings.paladin
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if specId == 1 then
		end
		return nil
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if (specId ~= 1) then
			TRB.Functions.Bar:HideResourceBar(true)
			return
		end

		local currentTime = GetTime()

		if updateRateLimit + 0.05 < currentTime then
			updateRateLimit = currentTime
			UpdateResourceBar()
		end
	end
end