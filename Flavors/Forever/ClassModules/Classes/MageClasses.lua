local _, TRB = ...
local L = TRB.Localization

-- Mage (World of Warcraft: Forever): Mana, with Arcane Blast's stacks on the secondary bar.

---@class TRB.Classes.Forever.Mage.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public arcaneBlast TRB.Classes.SpellBase
---@field public arcaneMissiles TRB.Classes.SpellBase
---@field public blizzard TRB.Classes.SpellBase
---@field public evocation TRB.Classes.SpellBase

---Adds the Mage's channeled abilities and Arcane Blast to a new spell set.
---@param spells TRB.Classes.Forever.Mage.GeneralSpells
local function FillSpells(spells)
	-- Each cast adds a stack; later casts keep the first one's expiry.
	spells.arcaneBlast = TRB.Classes.SpellBase:New({
		id = 400574,
		rankIds = { 400574, 1239696, 1239697, 1239699, 1239700 },
		isTalent = true,
		duration = 18,
		maxStacks = 4,
		refreshOnStack = false,
	})
	-- Ranks 1 and 2 fire three and four missiles; every later rank fires five.
	local fiveMissiles = { mode = "fixedCount", baseDuration = 5, tickCount = 5, firstTickAtStart = false }
	spells.arcaneMissiles = TRB.Classes.SpellBase:New({
		id = 5143,
		rankIds = { 5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345 },
		baseline = true,
		rankTickProfiles = {
			{ mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
			{ mode = "fixedCount", baseDuration = 4, tickCount = 4, firstTickAtStart = false },
			fiveMissiles, fiveMissiles, fiveMissiles, fiveMissiles, fiveMissiles, fiveMissiles,
		},
	})
	spells.blizzard = TRB.Classes.SpellBase:New({
		id = 10,
		rankIds = { 10, 6141, 8427, 10185, 10186, 10187 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 8, tickCount = 8, firstTickAtStart = false },
	})
	spells.evocation = TRB.Classes.SpellBase:New({
		id = 12051,
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 8, tickCount = 8, firstTickAtStart = false },
	})
end

---The Arcane Blast bar text values, appended to the mana archetype's.
---@return table[]
local function BarTextValues()
	return {
		{ variable = "$arcaneBlastStacks", description = L["ForeverMageBarTextVariable_arcaneBlastStacks"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$arcaneBlastStacksMax", description = L["ForeverMageBarTextVariable_arcaneBlastStacksMax"], printInSettings = true, color = false, logicType = "number" },
		{ variable = "$arcaneBlastTime", description = L["ForeverMageBarTextVariable_arcaneBlastTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
	}
end

TRB.Forever.Templates.Classes:DefineClass("mage", {
	general = {
		archetype = "mana",
		spells = FillSpells,
		icons = { "arcaneBlast" },
		buffs = { "arcaneBlast" },
		barTextValues = BarTextValues,
		secondary = {
			buff = "arcaneBlast",
			resourceType = "ArcaneBlast",
			name = L["ResourceMageArcaneBlast"],
			colorsHeader = L["ForeverMageArcaneBlastColorsHeader"],
			nodeLabels = { L["ForeverMageArcaneBlast1"], L["ForeverMageArcaneBlast2"], L["ForeverMageArcaneBlast3"], L["ForeverMageArcaneBlast4"] },
			maxNodes = 4,
			-- Arcane Charges' colors.
			colors = {
				border = { color = "FF00AAFF" },
				background = { color = "66000000" },
				base = { color = "FF1A1AFA", color2 = "FF1A1AFA", gradientDirection = "disabled" },
				penultimate = { color = "FFFF9900", color2 = "FFFF9900", gradientDirection = "disabled" },
				final = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled" },
				sameColor = false,
			},
			audioCueSource = {
				id = "arcaneBlast",
				label = L["ForeverMageAudioCueSourceArcaneBlast"],
				description = L["ForeverMageAudioCueSourceArcaneBlastDescription"],
				sliderLabel = L["ForeverMageArcaneBlastThresholdSliderTitle"],
				defaultName = L["ForeverMageAudioCueArcaneBlastDefaultName"],
				min = 0,
				max = 4,
				step = 1,
				decimals = 0,
				compare = "atLeast",
				requiresCombat = true,
				defaultCues = {
					{
						id = "arcaneBlastThreshold1",
						name = L["ForeverMageAudioArcaneBlastThreshold1"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 2,
					},
					{
						id = "arcaneBlastThreshold2",
						name = L["ForeverMageAudioArcaneBlastThreshold2"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 4,
					},
				},
			},
		},
	},
})

TRB.Classes.SpecDescriptor:DeclareForClass("mage", { rangedAttack = true })
