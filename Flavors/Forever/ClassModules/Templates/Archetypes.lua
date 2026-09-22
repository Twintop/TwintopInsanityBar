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
-- This file loads in the flavor's Classes stage, before Core's Functions, so nothing here may call into
-- TRB.Functions at load time.

---@class TRB.Forever.Archetype
---@field public key string # archetype name
---@field public powerType integer # Enum.PowerType of the primary resource
---@field public powerToken string # UNIT_POWER_UPDATE token of the primary resource
---@field public resourceType string # GetSpecConfiguration resourceType / resourceTypeNames key
---@field public nameKey string # localization key of the resource name
---@field public variable string # bar text variable stem (without "$"), e.g. "mana" -> $mana, $manaMax
---@field public defaultMax integer # maxResource before the client reports one
---@field public defaultText "resource"|"mana" # GlobalLoadDefaultBarTextSettings resource type
---@field public isHealerLike boolean # FillSpecializationCacheSettings isHealer flag
---@field public colors TRB.Forever.ArchetypeColors
---@field public secondary TRB.Forever.ArchetypeSecondary?

---@class TRB.Forever.ArchetypeColors
---@field public textCurrent string
---@field public textCasting string
---@field public textPassive string
---@field public barBase string
---@field public barBorder string
---@field public barBackground string

---@class TRB.Forever.ArchetypeSecondary
---@field public powerType integer
---@field public resourceType string
---@field public nameKey string
---@field public variable string # bar text variable stem, e.g. "comboPoints"
---@field public maxNodes integer

---Shared secondary definition for the Energy + Combo Points archetype.
---@type TRB.Forever.ArchetypeSecondary
local comboPointsSecondary = {
	powerType = Enum.PowerType.ComboPoints,
	resourceType = "ComboPoints",
	nameKey = "ResourceComboPoints",
	variable = "comboPoints",
	maxNodes = 5,
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
		isHealerLike = true,
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
		defaultText = "resource",
		isHealerLike = false,
		colors = { textCurrent = "FFFF0000", textCasting = "FFFFFFFF", textPassive = "FFFF8080", barBase = "FFFF0000", barBorder = "FF990000", barBackground = "66000000" },
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
		isHealerLike = false,
		colors = { textCurrent = "FFFFFF00", textCasting = "FFFFFFFF", textPassive = "FFD59900", barBase = "FFFFFF00", barBorder = "FFFFD300", barBackground = "66000000" },
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
		isHealerLike = false,
		colors = { textCurrent = "FFFFFF00", textCasting = "FFFFFFFF", textPassive = "FFD59900", barBase = "FFFFFF00", barBorder = "FFFFD300", barBackground = "66000000" },
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
---@field public spellsClass table # TRB.Classes.<Class>.<Spec>Spells
---@field public specPascal string # e.g. "BeastMastery"
---@field public fillSpells fun(spells: TRB.Classes.SpecializationSpellsBase)? # adds the spec's abilities to a new spell set
---@field public icons string[]? # spell field names offered as #icon bar text variables
---@field public stealth boolean? # spec cares about stealth: $inStealth and stealth-gated thresholds

---How one spec is declared to DefineClass: an archetype key on its own, or a table when the spec
---brings abilities, icons, or stealth along with it.
---@class TRB.Forever.SpecDeclaration
---@field public archetype string
---@field public spells fun(spells: TRB.Classes.SpecializationSpellsBase)?
---@field public icons string[]?
---@field public stealth boolean?

---@type table<string, TRB.Forever.ClassDefinition>
TRB.Forever.Classes = TRB.Forever.Classes or {}

TRB.Forever.Templates.Classes = {}

---Builds the spell-set class for one spec: a SpecializationSpellsBase derivative the spec's own
---spell builder fills, plus the FillBarTextVariables filler the options panel and cross-class views use.
---@param classModule table # TRB.Classes.<Class>
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
		if archetype.secondary ~= nil then
			local secondaryName = L[archetype.secondary.nameKey]
			local secondaryVariable = archetype.secondary.variable
			values[#values + 1] = { variable = "$" .. secondaryVariable, description = string.format(L["ForeverBarTextVariable_secondary"], secondaryName), printInSettings = true, color = false, category = varCategory.RESOURCES }
			values[#values + 1] = { variable = "$" .. secondaryVariable .. "Max", description = string.format(L["ForeverBarTextVariable_secondaryMax"], secondaryName), printInSettings = true, color = false, category = varCategory.RESOURCES }
		end
		if stealth then
			values[#values + 1] = { variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false }
		end
		specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues(values)
	end

	classModule[spec.specPascal .. "Spells"] = spellsClass
	spec.spellsClass = spellsClass
end

---Builds the BarGroupsFactory Core expects on TRB.Classes.<Class>.
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
		if spec.archetype.secondary ~= nil then
			-- Secondary bars are parented to UIParent for independent visibility
			barGroups.secondary = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_ComboPoint", spec.archetype.secondary.maxNodes, false)
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
		if spec.archetype.secondary ~= nil then
			config.secondary = { maxNodes = spec.archetype.secondary.maxNodes, isPrimary = false, resourceType = spec.archetype.secondary.resourceType }
		end
		return config
	end

	classModule.BarGroupsFactory = factory
end

---Declares a class: one archetype per spec. Generates TRB.Classes.<Class> (spell sets, BarGroupsFactory),
---registers the bar text variable fillers and declares the spec descriptors.
---@param className string # lowercase class key, e.g. "priest"
---@param specDeclarations table<string, string|TRB.Forever.SpecDeclaration> # specName -> archetype key or declaration
---@return TRB.Forever.ClassDefinition
function TRB.Forever.Templates.Classes:DefineClass(className, specDeclarations)
	local classEntry = TRB.Data.classRegistry[className]
	assert(classEntry ~= nil, "TwintopInsanityBar: Forever DefineClass for unknown class '" .. tostring(className) .. "'")

	local classModule = TRB.Classes[classEntry.classModuleName] or {}
	TRB.Classes[classEntry.classModuleName] = classModule

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

		---@type TRB.Forever.SpecDefinition
		local spec = {
			entry = entry,
			archetype = archetype,
			specPascal = entry.specLocaleKey:sub(#classEntry.classModuleName + 1),
			spellsClass = nil,
			fillSpells = declaration.spells,
			icons = declaration.icons,
			stealth = declaration.stealth,
		}
		DefineSpellsClass(classModule, spec)
		classDef.specs[entry.specName] = spec
		classDef.specsById[entry.specId] = spec
		classDef.specOrder[#classDef.specOrder + 1] = spec

		TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
		TRB.Data.barTextVariablesRegistry[entry.compositeKey] = spec.spellsClass.FillBarTextVariables

		-- Descriptor: every Forever spec shows mana precision when mana is its resource; combo point
		-- specs export their secondary bar and offer its nodes as bar text anchors.
		local descriptor = { manaBar = archetype.key == "mana" }
		if archetype.secondary ~= nil then
			descriptor.secondary = { exportable = true }
			local anchors = {}
			for i = 1, archetype.secondary.maxNodes do
				anchors[i] = { label = L["ComboPoint" .. i], frame = "ComboPoint_" .. i }
			end
			descriptor.barTextAnchorFrames = anchors
		end
		TRB.Classes.SpecDescriptor:Declare(entry.compositeKey, descriptor)
	end

	DefineBarGroupsFactory(classModule, classDef)
	TRB.Forever.Classes[className] = classDef
	return classDef
end
