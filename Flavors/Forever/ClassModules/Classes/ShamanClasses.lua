local _, TRB = ...
local L = TRB.Localization

-- Shaman (World of Warcraft: Forever): Mana, with the orbs of Lightning Shield or Water Shield on the secondary bar;
-- there is no Maelstrom in this game.

---@class TRB.Classes.Forever.Shaman.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public lightningShield TRB.Classes.SpellBase
---@field public waterShield TRB.Classes.SpellBase

---Adds the Shaman's elemental shields to a new spell set.
---@param spells TRB.Classes.Forever.Shaman.GeneralSpells
local function FillSpells(spells)
	-- Its snapshot tracks whichever shield is up; a hit taken spends an orb at most once per spendLockout seconds.
	spells.lightningShield = TRB.Classes.SpellBase:New({
		id = 324,
		rankIds = { 324, 325, 905, 945, 8134, 10431, 10432 },
		baseline = true,
		isBuff = true,
		duration = 600,
		maxStacks = 3,
		spendLockout = 3.5,
	})
	-- Also spends an orb when one of the Shaman's own spells crits, seen as the mana it restores.
	spells.waterShield = TRB.Classes.SpellBase:New({
		id = 408510,
		isTalent = true,
		isBuff = true,
	})
end

---The shield bar text values, appended to the mana archetype's.
---@return table[]
local function BarTextValues()
	return {
		{ variable = "$shieldOrbs", description = L["ForeverShamanBarTextVariable_shieldOrbs"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$shieldOrbsMax", description = L["ForeverShamanBarTextVariable_shieldOrbsMax"], printInSettings = true, color = false, logicType = "number" },
		{ variable = "$shieldTime", description = L["ForeverShamanBarTextVariable_shieldTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
	}
end

TRB.Forever.Templates.Classes:DefineClass("shaman", {
	general = {
		archetype = "mana",
		spells = FillSpells,
		icons = { "lightningShield", "waterShield" },
		buffs = { "lightningShield" },
		barTextValues = BarTextValues,
		secondary = {
			buff = "lightningShield",
			resourceType = "ElementalShield",
			name = L["ResourceShamanElementalShield"],
			colorLabels = {
				header = L["ForeverShamanElementalShieldColorsHeader"],
				penultimate = L["ForeverShamanElementalShieldColorPickerPenultimate"],
				final = L["ForeverShamanElementalShieldColorPickerFinal"],
				sameColor = L["ForeverShamanElementalShieldCheckboxUseHighestForAll"],
				sameColorTooltip = string.format(L["ForeverShamanElementalShieldCheckboxUseHighestForAllTooltip"], 3, 2),
				border = L["ForeverShamanElementalShieldColorPickerBorder"],
				background = L["ForeverShamanElementalShieldColorPickerBackground"],
			},
			nodeLabels = { L["ForeverShamanElementalShield1"], L["ForeverShamanElementalShield2"], L["ForeverShamanElementalShield3"] },
			maxNodes = 3,
			colors = {
				border = { color = "FF0070DE" },
				background = { color = "66000000" },
				base = { color = "FF33BBFF", color2 = "FF33BBFF", gradientDirection = "disabled" },
				penultimate = { color = "FF33BBFF", color2 = "FF33BBFF", gradientDirection = "disabled" },
				final = { color = "FF33BBFF", color2 = "FF33BBFF", gradientDirection = "disabled" },
				sameColor = false,
			},
			audioCueSource = {
				id = "elementalShield",
				label = L["ForeverShamanAudioCueSourceElementalShield"],
				description = L["ForeverShamanAudioCueSourceElementalShieldDescription"],
				sliderLabel = L["ForeverShamanElementalShieldThresholdSliderTitle"],
				defaultName = L["ForeverShamanAudioCueElementalShieldDefaultName"],
				min = 0,
				max = 3,
				step = 1,
				decimals = 0,
				compare = "atMost",
				requiresCombat = true,
				defaultCues = {
					{
						id = "elementalShieldThreshold1",
						name = L["ForeverShamanAudioElementalShieldThreshold1"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 1,
					},
					{
						id = "elementalShieldThreshold2",
						name = L["ForeverShamanAudioElementalShieldThreshold2"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 0,
					},
				},
			},
		},
	},
})

TRB.Classes.SpecDescriptor:DeclareForClass("shaman", { totems = { placement = "spec", builtIn = true } })
