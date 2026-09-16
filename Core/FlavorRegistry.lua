local addonName, TRB = ...

-- Builds the class/spec registries from the flavor manifest (Flavors\<Flavor>\Manifest.lua), which is
-- the only file allowed to enumerate classes and specs. This is the first Core file to load, so the
-- localization layer and Init.lua can both derive their class/spec facts from the registry instead of
-- carrying their own copies.

---@class TRB.Flavor.SpecEntry
---@field public specId integer
---@field public specName string
---@field public specGlobalId integer?
---@field public resources table<string, number>?

---@class TRB.Flavor.ClassEntry
---@field public classId integer
---@field public className string
---@field public classToken string
---@field public classModuleName string
---@field public specs TRB.Flavor.SpecEntry[]

---@class TRB.Flavor
---@field public id string # Flavor identifier; must equal the TOC's X-Flavor field
---@field public nameKey string # Localization key of the flavor's display name
---@field public savedVariablesName string # Global declared by the TOC's SavedVariables line
---@field public IsClientMatch fun(): boolean
---@field public classes TRB.Flavor.ClassEntry[]
---@field public PortForwardSettings (fun(settings: table?))? # Saved-variable migrations, if the flavor has any
---@field public DefaultManualUpdateChecks (fun(): table)? # Seed for settings.manualUpdateChecks
---@field public OnBarTextSeeded (fun(settings: table, className: string))? # Hook after a class receives fresh default bar text
---@field public RunManualUpdateChecks (fun(settings: table, classEntry: TRB.Data.ClassRegistryEntry): table)? # One-shot per-class manual migrations run right after the saved variables are merged
---@field public ShowMidnightBarTextResetMessage (fun(className: string))? # Mainline-only chat notice for its bar text reset
---@field public newsContent string? # Markdown changelog shown by the News window

assert(type(TRB.Flavor) == "table", "TwintopInsanityBar: no flavor manifest loaded before Core. Check the TOC.")
assert(type(TRB.Flavor.id) == "string" and TRB.Flavor.id ~= "", "TwintopInsanityBar: flavor manifest has no id.")
assert(type(TRB.Flavor.savedVariablesName) == "string", "TwintopInsanityBar: flavor manifest has no savedVariablesName.")
assert(type(TRB.Flavor.classes) == "table", "TwintopInsanityBar: flavor manifest has no classes.")

do
	local tocFlavor = C_AddOns.GetAddOnMetadata(addonName, "X-Flavor")
	if tocFlavor ~= nil and tocFlavor ~= TRB.Flavor.id then
		print(string.format("|cFFFF8800TRB:|r Packaging error: the TOC declares flavor '%s' but the loaded manifest is '%s'.", tostring(tocFlavor), tostring(TRB.Flavor.id)))
	end
end

---Returns the flavor's saved variables table, or nil before the first login on a fresh install.
---@return table?
function TRB.Flavor.GetSavedVariables()
	return _G[TRB.Flavor.savedVariablesName]
end

---Replaces the flavor's saved variables table.
---@param value table?
function TRB.Flavor.SetSavedVariables(value)
	_G[TRB.Flavor.savedVariablesName] = value
end

-- Working data root. Init.lua fills in the rest.
TRB.Data = TRB.Data or {}

-- Canonical registry of all supported class/spec combinations.
-- Each entry maps a compositeKey ("className_specName") to its identifiers.
---@class TRB.Data.SpecRegistryEntry
---@field public classId number
---@field public specId number
---@field public specGlobalId number? -- global specialization ID, e.g. 258 for Shadow
---@field public className string   -- all-lowercase, e.g. "deathknight"
---@field public classToken string  -- uppercase WoW class file token, e.g. "DEATHKNIGHT"
---@field public classModuleName string -- PascalCase addon module key, e.g. "DeathKnight"
---@field public specName string    -- camelCase, e.g. "beastMastery"
---@field public specNameLower string -- all-lowercase convenience form, e.g. "beastmastery"
---@field public specNameUpper string -- uppercase convenience form, e.g. "BEASTMASTERY"
---@field public specLocaleKey string -- localization key of the spec name, e.g. "HunterBeastMastery"
---@field public compositeKey string -- "className_specName", e.g. "deathknight_frost"
---@field public resources table<string, number> -- per-resource maximums declared by the manifest
---@field public descriptor TRB.Classes.SpecDescriptor? -- capabilities declared by the class module

---@class TRB.Data.ClassRegistryEntry
---@field public classId number
---@field public className string   -- all-lowercase settings key, e.g. "deathknight"
---@field public classToken string  -- uppercase WoW class file token, e.g. "DEATHKNIGHT"
---@field public classModuleName string -- PascalCase addon module/options key, e.g. "DeathKnight"
---@field public specs TRB.Data.SpecRegistryEntry[]

---@type TRB.Data.ClassRegistryEntry[]
TRB.Data.classRegistryOrder = {}

---@type table<string, TRB.Data.ClassRegistryEntry>
TRB.Data.classRegistry = {}

---@type table<number, TRB.Data.ClassRegistryEntry>
TRB.Data.classRegistryByIds = {}

---@type table<string, TRB.Data.ClassRegistryEntry>
TRB.Data.classRegistryByTokens = {}

---@type TRB.Data.SpecRegistryEntry[]
TRB.Data.specRegistryOrder = {}

---@type table<string, TRB.Data.SpecRegistryEntry>
TRB.Data.specRegistry = {}

---@type table<number, table<number, TRB.Data.SpecRegistryEntry>>
TRB.Data.specRegistryByIds = {}

-- Per-spec maximum primary resource values, keyed by class -> spec -> resource token -> max. Shared by
-- the class options panels (default maxResource / overcap config) and the custom-threshold form
-- sub-targets (e.g. Druid's per-form primary thresholds), so the numbers are never duplicated.
-- Populated from each spec's manifest `resources` table.
---@type table<string, table<string, table<string, number>>>
TRB.Data.maxResource = {}

do
	---@param classDef TRB.Flavor.ClassEntry
	local function regClass(classDef)
		local classId = classDef.classId
		local className = classDef.className
		local classToken = classDef.classToken
		local classModuleName = classDef.classModuleName
		assert(type(classId) == "number" and type(className) == "string" and type(classToken) == "string" and type(classModuleName) == "string",
			"TwintopInsanityBar: malformed class entry in flavor manifest")

		local classEntry = {
			classId = classId,
			className = className,
			classToken = classToken,
			classModuleName = classModuleName,
			specs = {},
		}

		TRB.Data.classRegistry[className] = classEntry
		TRB.Data.classRegistryByIds[classId] = classEntry
		TRB.Data.classRegistryByTokens[classToken] = classEntry
		table.insert(TRB.Data.classRegistryOrder, classEntry)

		if not TRB.Data.specRegistryByIds[classId] then
			TRB.Data.specRegistryByIds[classId] = {}
		end

		for _, spec in ipairs(classDef.specs or {}) do
			local specId = spec.specId
			local specName = spec.specName
			assert(type(specId) == "number" and type(specName) == "string", "TwintopInsanityBar: malformed spec entry in flavor manifest for " .. className)
			local compositeKey = className .. "_" .. specName
			local resources = spec.resources or {}
			local entry = {
				classId = classId,
				specId = specId,
				specGlobalId = spec.specGlobalId,
				className = className,
				classToken = classToken,
				classModuleName = classModuleName,
				specName = specName,
				specNameLower = string.lower(specName),
				specNameUpper = string.upper(specName),
				specLocaleKey = classModuleName .. string.upper(string.sub(specName, 1, 1)) .. string.sub(specName, 2),
				compositeKey = compositeKey,
				resources = resources,
			}
			TRB.Data.specRegistry[compositeKey] = entry
			TRB.Data.specRegistryByIds[classId][specId] = entry
			table.insert(classEntry.specs, entry)
			table.insert(TRB.Data.specRegistryOrder, entry)

			if next(resources) ~= nil then
				TRB.Data.maxResource[className] = TRB.Data.maxResource[className] or {}
				TRB.Data.maxResource[className][specName] = resources
			end
		end
	end

	for _, classDef in ipairs(TRB.Flavor.classes) do
		regClass(classDef)
	end
end
