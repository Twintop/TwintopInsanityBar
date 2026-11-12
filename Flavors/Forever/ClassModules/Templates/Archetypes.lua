local _, TRB = ...
local L = TRB.Localization

TRB.Classes = TRB.Classes or {}
TRB.Forever = TRB.Forever or {}
TRB.Forever.Templates = TRB.Forever.Templates or {}

-- World of Warcraft: Forever class template, part 1 of 3 (the Classes stage).
--
-- Forever's original class design has 27 specializations but only three resource archetypes, so each
-- class file declares its specs as archetype names and the templates generate everything Core expects
-- from a class module: the spell-set classes with their bar text variables, the BarGroupsFactory, the
-- spec descriptors, the runtime (Runtime.lua) and the options panels (Options.lua). A class that later
-- needs real ability tracking overrides or extends the generated pieces in its own files; the template
-- is the starting point, not a ceiling.
--
-- This file loads in the flavor's Classes stage, before Core's Stage 2 Functions, so of TRB.Functions only the
-- Stage 1 registries (AudioCues) may be called at load time.

---@class TRB.Forever.Archetype
---@field public key string # archetype name
---@field public powerType integer # Enum.PowerType of the primary resource
---@field public powerToken string # UNIT_POWER_UPDATE token of the primary resource
---@field public resourceType string # GetSpecConfiguration resourceType / resourceTypeNames key
---@field public nameKey string # localization key of the resource name
---@field public variable string # bar text variable stem (without "$"), e.g. "mana" -> $mana, $manaMax
---@field public defaultMax integer # maxResource before the client reports one
---@field public resourceFactor integer? # raw UnitPower units per displayed unit; nil means 1
---@field public defaultText "resource"|"mana" # GlobalLoadDefaultBarTextSettings resource type
---@field public colors TRB.Forever.ArchetypeColors
---@field public secondary TRB.Forever.ArchetypeSecondary?
---@field public overcap TRB.Forever.ArchetypeOvercap? # a resource that can overcap: its Overcap indicator and text colors

---The default Overcap indicator color and the locale keys labelling a resource's overcap and over-threshold options.
---@class TRB.Forever.ArchetypeOvercap
---@field public color string
---@field public barNameKey string
---@field public indicatorKey string
---@field public indicatorTooltipKey string
---@field public indicatorColorKey string
---@field public textOverThresholdKey string
---@field public textOverThresholdTooltipKey string
---@field public textOvercapKey string
---@field public textOvercapTooltipKey string

---@class TRB.Forever.ArchetypeColors
---@field public textCurrent string
---@field public textCasting string
---@field public textPassive string
---@field public barBase string
---@field public barBorder string
---@field public barBackground string

---Localized text of a secondary bar's color section.
---@class TRB.Forever.SecondaryColorLabels
---@field public header string
---@field public penultimate string
---@field public final string
---@field public sameColor string # the "use highest color for all" checkbox
---@field public sameColorTooltip string
---@field public border string
---@field public background string

---A secondary bar's nodes, filled by an archetype's power or by the stacks of a buff the spec tracks.
---@class TRB.Forever.ArchetypeSecondary
---@field public resourceType string
---@field public name string # localized bar name
---@field public colorLabels TRB.Forever.SecondaryColorLabels
---@field public nodeLabels string[] # localized bar text anchor label per node
---@field public maxNodes integer
---@field public powerType integer? # the power filling the nodes; nil when a buff's stacks do
---@field public variable string? # bar text variable stem for a power, e.g. "comboPoints"; a buff's come from its class module
---@field public buff string? # spell field name of the spec buff whose stacks fill the nodes; its spell gates the bar
---@field public colors table? # default colors.comboPoints; nil derives them from the archetype
---@field public audioCueSource TRB.Classes.AudioCueCounterSource? # counter the node count feeds; nil means Combo Points

---Shared secondary definition for the Energy + Combo Points archetype.
---@type TRB.Forever.ArchetypeSecondary
local comboPointsSecondary = {
	powerType = Enum.PowerType.ComboPoints,
	resourceType = "ComboPoints",
	name = L["ResourceComboPoints"],
	colorLabels = {
		header = L["ComboPointColorsHeader"],
		penultimate = L["ComboPointColorPickerPenultimate"],
		final = L["ComboPointColorPickerFinal"],
		sameColor = L["ComboPointCheckboxUseHighestForAll"],
		sameColorTooltip = L["ComboPointCheckboxUseHighestForAllTooltip"],
		border = L["ComboPointColorPickerBorder"],
		background = L["ComboPointColorPickerBackground"],
	},
	nodeLabels ={ L["ComboPoint1"], L["ComboPoint2"], L["ComboPoint3"], L["ComboPoint4"], L["ComboPoint5"] },
	variable = "comboPoints",
	maxNodes = 5,
}

---@type TRB.Forever.ArchetypeOvercap
local rageOvercap = {
	color = "FF800000",
	barNameKey = "BarNameRageBar",
	indicatorKey = "WarriorIndicatorBorderOvercap",
	indicatorTooltipKey = "WarriorIndicatorOvercapTooltip",
	indicatorColorKey = "WarriorIndicatorOvercapColor",
	textOverThresholdKey = "WarriorColorPickerThresholdOver",
	textOverThresholdTooltipKey = "WarriorCheckboxThresholdOverTooltip",
	textOvercapKey = "WarriorColorPickerOvercap",
	textOvercapTooltipKey = "WarriorCheckboxThresholdOvercapTooltip",
}

---@type TRB.Forever.ArchetypeOvercap
local energyOvercap = {
	color = "FFFF0000",
	barNameKey = "BarNameEnergyBar",
	indicatorKey = "RogueIndicatorBorderOvercap",
	indicatorTooltipKey = "RogueIndicatorOvercapTooltip",
	indicatorColorKey = "RogueIndicatorOvercapColor",
	textOverThresholdKey = "ColorPickerHaveEnoughEnergyToUseAbilityThreshold",
	textOverThresholdTooltipKey = "CheckboxThresholdOverTooltip",
	textOvercapKey = "RogueColorPickerOvercap",
	textOvercapTooltipKey = "RogueCheckboxThresholdOvercapTooltip",
}

---@type table<string, TRB.Forever.Archetype>
TRB.Forever.Archetypes = {
	mana = {
		key = "mana",
		powerType = Enum.PowerType.Mana,
		powerToken = "MANA",
		resourceType = "Mana",
		nameKey = "ResourceMana",
		variable = "mana",
		defaultMax = 100,
		defaultText = "mana",
		colors = { textCurrent = "FF4D4DFF", textCasting = "FFFFFFFF", textPassive = "FF8080FF", barBase = "FF0000FF", barBorder = "FF000099", barBackground = "66000000" },
	},
	rage = {
		key = "rage",
		powerType = Enum.PowerType.Rage,
		powerToken = "RAGE",
		resourceType = "Rage",
		nameKey = "ResourceRage",
		variable = "rage",
		defaultMax = 100,
		resourceFactor = 10,
		defaultText = "resource",
		colors = { textCurrent = "FFFF0000", textCasting = "FFFFFFFF", textPassive = "FFFF8080", barBase = "FFFF0000", barBorder = "FF990000", barBackground = "66000000" },
		overcap = rageOvercap,
	},
	energy = {
		key = "energy",
		powerType = Enum.PowerType.Energy,
		powerToken = "ENERGY",
		resourceType = "Energy",
		nameKey = "ResourceEnergy",
		variable = "energy",
		defaultMax = 100,
		defaultText = "resource",
		colors = { textCurrent = "FFFFFF00", textCasting = "FFFFFFFF", textPassive = "FFD59900", barBase = "FFFFFF00", barBorder = "FFFFD300", barBackground = "66000000" },
		overcap = energyOvercap,
	},
	energyComboPoints = {
		key = "energyComboPoints",
		powerType = Enum.PowerType.Energy,
		powerToken = "ENERGY",
		resourceType = "Energy",
		nameKey = "ResourceEnergy",
		variable = "energy",
		defaultMax = 100,
		defaultText = "resource",
		colors = { textCurrent = "FFFFFF00", textCasting = "FFFFFFFF", textPassive = "FFD59900", barBase = "FFFFFF00", barBorder = "FFFFD300", barBackground = "66000000" },
		overcap = energyOvercap,
		secondary = comboPointsSecondary,
	},
}

---Per-class template definitions, keyed by lowercase class name. Filled by DefineClass.
---@class TRB.Forever.ClassDefinition
---@field public className string
---@field public classModuleName string
---@field public classId integer
---@field public specs table<string, TRB.Forever.SpecDefinition> # keyed by specName
---@field public specsById table<integer, TRB.Forever.SpecDefinition>
---@field public specOrder TRB.Forever.SpecDefinition[]

---@class TRB.Forever.SpecDefinition
---@field public entry TRB.Data.SpecRegistryEntry
---@field public archetype TRB.Forever.Archetype
---@field public spellsClass table # TRB.Classes.Forever.<Class>.<Spec>Spells
---@field public specPascal string # e.g. "BeastMastery"
---@field public fillSpells fun(spells: TRB.Classes.SpecializationSpellsBase)? # adds the spec's abilities to a new spell set
---@field public icons string[]? # spell field names offered as #icon bar text variables
---@field public stealth boolean? # spec cares about stealth: $inStealth and stealth-gated thresholds
---@field public buffs string[]? # spell field names the class module tracks as buff snapshots
---@field public barTextValues (fun(): table[])? # the class module's own bar text values, listed after the archetype's
---@field public indicators TRB.Forever.SpecIndicator[]? # built-in Color Indicators, listed after Stealth
---@field public secondary TRB.Forever.ArchetypeSecondary? # the spec's own secondary bar, else its archetype's
---@field public secondaryCounterId string? # the audio cue counter the secondary's node count feeds

---A built-in Color Indicator that is on while one of the spec's tracked buffs is active, or only while it is ending.
---@class TRB.Forever.SpecIndicator
---@field public key string # indicatorColors and nodeOrder key
---@field public buff string # spell field name, one of the spec's buffs
---@field public color string # default color
---@field public targets table<string, table<string, boolean>>? # default targets; none when nil
---@field public modifiers TRB.IndicatorModifiers? # default modifiers
---@field public labelKey string # locale key of the row's name in the Add Built-in and Change Source menus
---@field public tooltipKey string
---@field public colorLabelKey string # locale key of the row's label
---@field public endOf TRB.Forever.SpecIndicatorEndOf? # makes the row an ending one, with its own configuration section

---How an ending indicator's window is set: within some GCDs or seconds of the buff ending.
---@class TRB.Forever.SpecIndicatorEndOf
---@field public key string # endOf settings key
---@field public mode string # default mode, "gcd" or "time"
---@field public gcdsMax number # default GCD count
---@field public timeMax number # default seconds
---@field public headerKey string # locale key of the configuration section's header
---@field public gcdRadioKey string
---@field public gcdSliderKey string
---@field public timeRadioKey string
---@field public timeSliderKey string

---How one spec is declared to DefineClass: an archetype key on its own, or a table when the spec
---brings abilities, icons, stealth, buffs, bar text values, indicators, or a secondary bar along with it.
---@class TRB.Forever.SpecDeclaration
---@field public archetype string
---@field public spells fun(spells: TRB.Classes.SpecializationSpellsBase)?
---@field public icons string[]?
---@field public stealth boolean?
---@field public buffs string[]?
---@field public barTextValues (fun(): table[])?
---@field public indicators TRB.Forever.SpecIndicator[]?
---@field public secondary TRB.Forever.ArchetypeSecondary? # a buff-stack secondary bar, for an archetype without one

---@type table<string, TRB.Forever.ClassDefinition>
TRB.Forever.Classes = TRB.Forever.Classes or {}

TRB.Forever.Templates.Classes = {}

---The Combo Points counter for a combo point spec's audio cues, seeded with cues at 3 and 5, both off.
---@return TRB.Classes.AudioCueCounterSource
function TRB.Forever.Templates.Classes:ComboPointAudioCueSource()
	return {
		id = "comboPoints",
		label = L["RogueAudioCueSourceComboPoints"],
		description = L["RogueAudioCueSourceComboPointsDescription"],
		sliderLabel = L["RogueComboPointThresholdSliderTitle"],
		defaultName = L["RogueAudioCueComboPointDefaultName"],
		min = 0,
		max = comboPointsSecondary.maxNodes,
		step = 1,
		decimals = 0,
		compare = "atLeast",
		requiresCombat = true,
		defaultCues = {
			{
				id = "comboPointThreshold1",
				name = L["RogueAudioComboPointThreshold1"],
				enabled = false,
				sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				thresholdValue = 3,
			},
			{
				id = "comboPointThreshold2",
				name = L["RogueAudioComboPointThreshold2"],
				enabled = false,
				sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				thresholdValue = 5,
			},
		},
	}
end

---Channel tick profiles for a spell set, keyed by every rank's spell ID. A spell opts in with a `tickProfile`
---for all ranks, or a `rankTickProfiles` list in `rankIds` order for ranks that tick differently.
---@param spells TRB.Classes.SpecializationSpellsBase
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Forever.Templates.Classes:CastbarTickProfilesFromSpells(spells)
	local profiles = {}
	for _, spell in pairs(spells) do
		local profile = spell.attributes.tickProfile
		local rankProfiles = spell.attributes.rankTickProfiles
		if profile ~= nil or rankProfiles ~= nil then
			for rank, rankId in ipairs(spell.rankIds or { spell.id }) do
				profiles[rankId] = rankProfiles and rankProfiles[rank] or profile
			end
		end
	end
	return profiles
end

---Builds the spell-set class for one spec: a SpecializationSpellsBase derivative the spec's own
---spell builder fills, plus the FillBarTextVariables filler the options panel and cross-class views use.
---@param classModule table # TRB.Classes.Forever.<Class>
---@param spec TRB.Forever.SpecDefinition
local function DefineSpellsClass(classModule, spec)
	local base = TRB.Classes.SpecializationSpellsBase
	local spellsClass = setmetatable({}, { __index = base })
	spellsClass.__index = spellsClass
	local fillSpells = spec.fillSpells

	---Creates the spec's spell set. Empty for a spec that declared no abilities.
	function spellsClass:New()
		local self = setmetatable(base:New(), spellsClass)
		if fillSpells ~= nil then
			fillSpells(self)
		end
		return self
	end

	local archetype = spec.archetype
	local variable = archetype.variable
	local resourceName = L[archetype.nameKey]
	local icons = spec.icons
	local stealth = spec.stealth
	local barTextValues = spec.barTextValues

	---Fills barTextVariables for the options panel display.
	---@param specCacheEntry TRB.Classes.SpecCache
	function spellsClass.FillBarTextVariables(specCacheEntry)
		if getmetatable(specCacheEntry.spellsData.spells) == base then
			specCacheEntry.spellsData.spells = spellsClass:New()
		end
		specCacheEntry.spellsData:FillSpellData()
		local spells = specCacheEntry.spellsData.spells

		local varCategory = TRB.Functions.BarText.VariableCategory
		local iconVariables = {}
		for _, key in ipairs(icons or {}) do
			local spell = spells[key]
			iconVariables[#iconVariables + 1] = { variable = "#" .. key, icon = spell.icon, description = spell.name, printInSettings = true }
		end
		specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons(iconVariables)
		local values = {
			{ variable = "$" .. variable, description = string.format(L["ForeverBarTextVariable_resource"], resourceName), printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
			{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
			{ variable = "$" .. variable .. "Percent", description = string.format(L["ForeverBarTextVariable_resourcePercent"], resourceName), printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
			{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
			{ variable = "$" .. variable .. "Max", description = string.format(L["ForeverBarTextVariable_resourceMax"], resourceName), printInSettings = true, color = false, category = varCategory.RESOURCES },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
			{ variable = "$casting", description = string.format(L["ForeverBarTextVariable_casting"], resourceName), printInSettings = true, color = false, category = varCategory.RESOURCES },
		}
		local secondary = spec.secondary
		if secondary ~= nil and secondary.variable ~= nil then
			local secondaryName = secondary.name
			local secondaryVariable = secondary.variable
			values[#values + 1] = { variable = "$" .. secondaryVariable, description = string.format(L["ForeverBarTextVariable_secondary"], secondaryName), printInSettings = true, color = false, category = varCategory.RESOURCES }
			values[#values + 1] = { variable = "$" .. secondaryVariable .. "Max", description = string.format(L["ForeverBarTextVariable_secondaryMax"], secondaryName), printInSettings = true, color = false, category = varCategory.RESOURCES }
		end
		if stealth then
			values[#values + 1] = { variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false }
		end
		if barTextValues ~= nil then
			for _, entry in ipairs(barTextValues()) do
				values[#values + 1] = entry
			end
		end
		specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues(values)
	end

	---@type TRB.Classes.ThresholdSnowflakes
	spellsClass.thresholdSnowflakes = {
		after = TRB.Classes.ThresholdLine.UnusableWithoutComboPoints,
	}

	classModule[spec.specPascal .. "Spells"] = spellsClass
	spec.spellsClass = spellsClass
end

---Builds the BarGroupsFactory Core expects on TRB.Classes.Forever.<Class>.
---@param classModule table
---@param classDef TRB.Forever.ClassDefinition
local function DefineBarGroupsFactory(classModule, classDef)
	local factory = {}
	factory.__index = factory

	---Creates BarGroup instances for the specified specialization.
	---@param specId integer
	---@return table<string, TRB.Classes.BarGroup>
	function factory:CreateForSpec(specId)
		local spec = classDef.specsById[specId]
		local barGroups = {}
		if spec == nil then
			return barGroups
		end

		barGroups.primary = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame", 1, true)
		if spec.secondary ~= nil then
			-- Secondary bars are parented to UIParent for independent visibility
			barGroups.secondary = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_ComboPoint", spec.secondary.maxNodes, false)
		end
		barGroups.health = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_Health", 1, false)
		return barGroups
	end

	---Gets the bar group configuration for a spec.
	---@param specId integer
	---@return table
	function factory:GetSpecConfiguration(specId)
		local spec = classDef.specsById[specId]
		if spec == nil then
			return {}
		end
		local config = {
			primary = { maxNodes = 1, isPrimary = true, resourceType = spec.archetype.resourceType },
			health = { maxNodes = 1, isPrimary = false, resourceType = "Health" },
		}
		if spec.secondary ~= nil then
			config.secondary = { maxNodes = spec.secondary.maxNodes, isPrimary = false, resourceType = spec.secondary.resourceType }
		end
		return config
	end

	classModule.BarGroupsFactory = factory
end

---Declares a class: one archetype per spec. Generates TRB.Classes.Forever.<Class> (spell sets, BarGroupsFactory),
---registers the bar text variable fillers and declares the spec descriptors.
---@param className string # lowercase class key, e.g. "priest"
---@param specDeclarations table<string, string|TRB.Forever.SpecDeclaration> # specName -> archetype key or declaration
---@return TRB.Forever.ClassDefinition
function TRB.Forever.Templates.Classes:DefineClass(className, specDeclarations)
	local classEntry = TRB.Data.classRegistry[className]
	assert(classEntry ~= nil, "TwintopInsanityBar: Forever DefineClass for unknown class '" .. tostring(className) .. "'")

	local classModule = TRB.Classes.Forever[classEntry.classModuleName] or {}
	TRB.Classes.Forever[classEntry.classModuleName] = classModule

	---@type TRB.Forever.ClassDefinition
	local classDef = {
		className = className,
		classModuleName = classEntry.classModuleName,
		classId = classEntry.classId,
		specs = {},
		specsById = {},
		specOrder = {},
	}

	for _, entry in ipairs(classEntry.specs) do
		local declaration = specDeclarations[entry.specName]
		if type(declaration) == "string" then
			declaration = { archetype = declaration }
		end
		local archetype = declaration ~= nil and TRB.Forever.Archetypes[declaration.archetype] or nil
		assert(archetype ~= nil, "TwintopInsanityBar: Forever DefineClass '" .. className .. "' has no archetype for spec '" .. entry.specName .. "'")

		---@class TRB.Forever.SpecDefinition
		local spec = {
			entry = entry,
			archetype = archetype,
			specPascal = entry.specLocaleKey:sub(#classEntry.classModuleName + 1),
			fillSpells = declaration.spells,
			icons = declaration.icons,
			stealth = declaration.stealth,
			buffs = declaration.buffs,
			barTextValues = declaration.barTextValues,
			indicators = declaration.indicators,
			secondary = declaration.secondary or archetype.secondary,
		}
		-- A buff secondary counts that buff's snapshot, which only a tracked buff has.
		local secondaryBuff = spec.secondary ~= nil and spec.secondary.buff or nil
		if secondaryBuff ~= nil then
			local tracked = false
			for _, buffKey in ipairs(spec.buffs or {}) do
				tracked = tracked or buffKey == secondaryBuff
			end
			assert(tracked, "TwintopInsanityBar: Forever DefineClass '" .. className .. "' spec '" .. entry.specName .. "' fills its secondary bar from '" .. secondaryBuff .. "', which its buffs don't list")
		end
		DefineSpellsClass(classModule, spec)
		classDef.specs[entry.specName] = spec
		classDef.specsById[entry.specId] = spec
		classDef.specOrder[#classDef.specOrder + 1] = spec

		TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
		TRB.Data.barTextVariablesRegistry[entry.compositeKey] = spec.spellsClass.FillBarTextVariables

		local spellsClass = spec.spellsClass
		TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
		TRB.Data.castbarTickProfilesRegistry[entry.compositeKey] = function()
			return self:CastbarTickProfilesFromSpells(spellsClass:New())
		end

		-- Descriptor: every Forever spec shows mana precision when mana is its resource; a spec with a
		-- secondary bar exports it, offers its nodes as bar text anchors, and gets its counter's audio cues.
		local descriptor = { manaBar = archetype.key == "mana" }
		-- Mana specs get the Five Second Rule bar.
		if archetype.key == "mana" and TRB.Flavor.fiveSecondRule ~= nil then
			descriptor.otherBars = { "fiveSecondRule" }
		end
		local secondary = spec.secondary
		if secondary ~= nil then
			descriptor.secondary = { exportable = true }
			local anchors = {}
			for i = 1, secondary.maxNodes do
				anchors[i] = { label = secondary.nodeLabels[i], frame = "ComboPoint_" .. i }
			end
			descriptor.barTextAnchorFrames = { secondary = anchors }
			if secondary.buff ~= nil then
				descriptor.talentGatedBars = { secondary = secondary.buff }
			end
			local counter = secondary.audioCueSource or self:ComboPointAudioCueSource()
			spec.secondaryCounterId = counter.id
			TRB.Functions.AudioCues:Register(entry.compositeKey, { counters = { counter } })
		end
		TRB.Classes.SpecDescriptor:Declare(entry.compositeKey, descriptor)
	end

	DefineBarGroupsFactory(classModule, classDef)
	TRB.Forever.Classes[className] = classDef
	return classDef
end
