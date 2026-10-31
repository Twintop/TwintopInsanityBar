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

---@class TRB.Flavor.StatDefinition
---@field public key string # snapshotData.attributes / .formatted key, e.g. "haste"
---@field public variables string[] # Bar text variables; the first is listed in the options, the rest are aliases
---@field public descriptionKey string # Localization key of the options description
---@field public refresh "primary"|"secondary" # Refresh bucket; TRB.Flavor.statEvents says which events invalidate each
---@field public read fun(): number? # Live value; may be secret, nil renders empty
---@field public format "percent"|"number" # percent rounds to the secondary precision; number uses short notation
---@field public integer boolean? # Whole number: options logic type INTEGER
---@field public secret boolean? # May hold a secret, so display only (default: the flavor's secretValues)

---@class TRB.Flavor.TalentRank
---@field public currentRank integer
---@field public maxRank integer
---@field public subTreeActive boolean? # Hero talents only: whether the talent's sub tree is the active one

---@class TRB.Flavor.StatEvents
---@field public primary string[] # Events that invalidate the primary bucket; UNIT_ events register for the player
---@field public secondary string[]

---@class TRB.Flavor.Skyriding
---@field public speedCaps { default: TRB.Flavor.SkyridingSpeedCap, dragonIsles: TRB.Flavor.SkyridingSpeedCap }
---@field public dragonIslesMapIds integer[] # UiMap ids whose maps and child maps use the Dragon Isles speed caps

---@class TRB.Flavor.SkyridingSpeedCap
---@field public max number # The Speed bar's maximum, in yards per second
---@field public passive number # The fastest speed without abilities, in yards per second, where the Speed bar draws its line

---Spell IDs the combat log swing tracker reads, on a flavor without Blizzard's swing timer. Every rank is listed.
---@class TRB.Flavor.SwingSpells
---@field public meleeResets integer[] # A successful cast restarts the main hand swing: on-next-swing attacks, Slam, ranged shots
---@field public rangedShots integer[] # A successful cast starts the Ranged Swing bar: Auto Shot, Shoot, Throw
---@field public castsKeepSwing integer[] # A cast that doesn't pause the melee swing while it casts

---@class TRB.Flavor
---@field public id string # Flavor identifier; must equal the TOC's X-Flavor field
---@field public nameKey string # Localization key of the flavor's display name
---@field public classNamespace string # Key under TRB.Classes holding the flavor's class modules, since flavors share class names
---@field public savedVariablesName string # Global declared by the TOC's SavedVariables line
---@field public gcdSpellId integer? # Dummy spell whose cooldown is the global cooldown; defaults to retail's 61304
---@field public unavailableVisibilityConditions table<string, boolean>? # Bar visibility condition keys the client can never satisfy (no flying, say); dropped from the options and the defaults
---@field public swingTimers boolean? # The Main Hand, Off Hand, and Ranged Swing bars exist
---@field public blizzardSwingTimer boolean? # The client has Blizzard's swing timer: it fires PLAYER_SWING and draws bars this addon can hide. Without it, swings come from the combat log and `swingSpells` (default false)
---@field public swingSpells TRB.Flavor.SwingSpells? # Required with swingTimers when blizzardSwingTimer is off
---@field public skyriding TRB.Flavor.Skyriding? # The client has skyriding, so the Skyriding bars exist
---@field public totemElements boolean? # Totem slots are the four elements (1 Fire, 2 Earth, 3 Water, 4 Air), so the Totems bar shows four fixed element nodes (default false)
---@field public specOwnedTotems boolean? # Each spec owns its Totems bar outright, so Global Options has none for specs to follow (default false)
---@field public IsClientMatch fun(): boolean
---@field public GetSpecializationIndex fun(): integer? # Active specialization index in specs[] order, or nil when the client reports none
---@field public classes TRB.Flavor.ClassEntry[]
---@field public stats TRB.Flavor.StatDefinition[] # Bar text stat variables (Flavors\<Flavor>\Stats.lua)
---@field public statEvents TRB.Flavor.StatEvents
---@field public PortForwardSettings (fun(settings: table?))? # Saved-variable migrations, if the flavor has any
---@field public DefaultManualUpdateChecks (fun(): table)? # Seed for settings.manualUpdateChecks
---@field public OnBarTextSeeded (fun(settings: table, className: string))? # Hook after a class receives fresh default bar text
---@field public RunManualUpdateChecks (fun(settings: table, classEntry: TRB.Data.ClassRegistryEntry): table)? # One-shot per-class manual migrations run right after the saved variables are merged
---@field public ShowMidnightBarTextResetMessage (fun(className: string))? # Mainline-only chat notice for its bar text reset
---@field public ResolveSpellRankId (fun(spell: TRB.Classes.SpellBase): integer?)? # The rank of a `rankIds` spell to hand the client API; flavors without ranked spells leave it unset and get the spell's `id`
---@field public ReadTalentRanks (fun(): table<integer, TRB.Flavor.TalentRank>)? # Every talent's rank keyed by spell ID; defaults to the active trait config's trees
---@field public pvpTalents boolean? # The client has PvP talents (default true)
---@field public talentEvents string[]? # Events besides TRAIT_CONFIG_UPDATED meaning the player's talents changed, which re-run SwitchSpec
---@field public cooldownManager boolean? # The client has Blizzard's Cooldown Manager, so it can feed tracking and anchor bars (default true)
---@field public playerAuras boolean? # The player's aura data is never secret, so custom indicators and Buff Alerts can follow a buff by spell ID (default false)
---@field public secretValues boolean? # The client hands out secret values, so bar text marks the variables that may hold one (default true)
---@field public DefaultCastbarTickProfiles (fun(): table<integer, TRB.Classes.Settings.CastbarTickProfile>)? # Channel tick profiles for every class (racials, consumables), keyed by spell ID; a fresh table per call, which the spec's own profiles overlay
---@field public newsContent string? # Markdown changelog shown by the News window's flavor tab; Core\News.lua holds the Core tab's
---@field public coreNewsLabel string? # The flavor's name in Core\News.lua titles, such as "Live"; the Core tab titles each section with that release alone and drops sections without it. Unset shows every title as written

assert(type(TRB.Flavor) == "table", "TwintopInsanityBar: no flavor manifest loaded before Core. Check the TOC.")
assert(type(TRB.Flavor.id) == "string" and TRB.Flavor.id ~= "", "TwintopInsanityBar: flavor manifest has no id.")
assert(type(TRB.Flavor.savedVariablesName) == "string", "TwintopInsanityBar: flavor manifest has no savedVariablesName.")
assert(type(TRB.Flavor.classNamespace) == "string" and TRB.Flavor.classNamespace ~= "", "TwintopInsanityBar: flavor manifest has no classNamespace.")
assert(type(TRB.Flavor.classes) == "table", "TwintopInsanityBar: flavor manifest has no classes.")
assert(type(TRB.Flavor.GetSpecializationIndex) == "function", "TwintopInsanityBar: flavor manifest has no GetSpecializationIndex.")
assert(type(TRB.Flavor.stats) == "table", "TwintopInsanityBar: flavor has no stats (Stats.lua must load after Manifest.lua).")
assert(type(TRB.Flavor.statEvents) == "table" and type(TRB.Flavor.statEvents.primary) == "table" and type(TRB.Flavor.statEvents.secondary) == "table", "TwintopInsanityBar: flavor statEvents needs primary and secondary event lists.")

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

TRB.Classes = TRB.Classes or {}
TRB.Classes[TRB.Flavor.classNamespace] = TRB.Classes[TRB.Flavor.classNamespace] or {}

---Returns a class's module (its spell sets and BarGroupsFactory), or nil when the class has none.
---@param classModuleName string # e.g. "DeathKnight"
---@return table?
function TRB.Flavor.GetClassModule(classModuleName)
	return TRB.Classes[TRB.Flavor.classNamespace][classModuleName]
end

if TRB.Flavor.gcdSpellId == nil then
	TRB.Flavor.gcdSpellId = 61304
end
if TRB.Flavor.unavailableVisibilityConditions == nil then
	TRB.Flavor.unavailableVisibilityConditions = {}
end
if TRB.Flavor.swingTimers == nil then
	TRB.Flavor.swingTimers = false
end
if TRB.Flavor.blizzardSwingTimer == nil then
	TRB.Flavor.blizzardSwingTimer = false
end
if TRB.Flavor.totemElements == nil then
	TRB.Flavor.totemElements = false
end
if TRB.Flavor.specOwnedTotems == nil then
	TRB.Flavor.specOwnedTotems = false
end
assert(not TRB.Flavor.swingTimers or TRB.Flavor.blizzardSwingTimer or type(TRB.Flavor.swingSpells) == "table", "TwintopInsanityBar: a flavor with swing timers but no Blizzard swing timer needs swingSpells.")
if TRB.Flavor.thresholdsRequireKnown == nil then
	TRB.Flavor.thresholdsRequireKnown = false
end
if TRB.Flavor.pvpTalents == nil then
	TRB.Flavor.pvpTalents = true
end
if TRB.Flavor.talentEvents == nil then
	TRB.Flavor.talentEvents = {}
end
if TRB.Flavor.cooldownManager == nil then
	TRB.Flavor.cooldownManager = true
end
if TRB.Flavor.playerAuras == nil then
	TRB.Flavor.playerAuras = false
end
if TRB.Flavor.secretValues == nil then
	TRB.Flavor.secretValues = true
end

-- Trait-tree talents (retail and Forever); a flavor with another talent system replaces it.
if TRB.Flavor.ReadTalentRanks == nil then
	---@return table<integer, TRB.Flavor.TalentRank>
	function TRB.Flavor.ReadTalentRanks()
		local ranks = {}
		local configId = C_ClassTalents.GetActiveConfigID()
		if configId == nil then
			return ranks
		end
		local configInfo = C_Traits.GetConfigInfo(configId)
		if configInfo == nil then
			return ranks
		end
		for _, treeId in pairs(configInfo.treeIDs) do
			local nodes = C_Traits.GetTreeNodes(treeId)
			for _, nodeId in pairs(nodes) do
				local node = C_Traits.GetNodeInfo(configId, nodeId)
				local entryId = nil

				if node.activeEntry ~= nil then
					entryId = node.activeEntry.entryID
				elseif node.nextEntry ~= nil then
					entryId = node.nextEntry.entryID
				elseif node.entryIDs ~= nil then
					entryId = node.entryIDs[1]
				end

				if entryId ~= nil then
					local entryInfo = C_Traits.GetEntryInfo(configId, entryId)
					if entryInfo.definitionID ~= nil then
						local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
						if definitionInfo ~= nil then
							local spellId = definitionInfo.spellID or definitionInfo.overriddenSpellID
							if spellId ~= nil then
								ranks[spellId] = { currentRank = node.currentRank, maxRank = node.maxRanks, subTreeActive = node.subTreeActive }
							end
						end
					end
				end
			end
		end
		return ranks
	end
end

-- Placeholder rank resolution: a flavor with ranked spells (Forever and Classic) replaces it.
if TRB.Flavor.ResolveSpellRankId == nil then
	---@param spell TRB.Classes.SpellBase
	---@return integer
	function TRB.Flavor.ResolveSpellRankId(spell)
		return spell.id
	end
end

if TRB.Flavor.DefaultCastbarTickProfiles == nil then
	---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
	function TRB.Flavor.DefaultCastbarTickProfiles()
		return {}
	end
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

-- Stat definitions by refresh bucket, and the events that invalidate each bucket. Character reads the
-- buckets on those events; BarText declares and exposes the variables.
---@type table<string, TRB.Flavor.StatDefinition[]>
TRB.Data.statsByBucket = { primary = {}, secondary = {} }

---@type table<string, string[]> # event -> buckets it invalidates
TRB.Data.statEventBuckets = {}

do
	for _, stat in ipairs(TRB.Flavor.stats) do
		assert(type(stat.key) == "string" and type(stat.variables) == "table" and type(stat.read) == "function" and TRB.Data.statsByBucket[stat.refresh] ~= nil,
			"TwintopInsanityBar: malformed stat definition '" .. tostring(stat.key) .. "'")
		if stat.secret == nil then
			stat.secret = TRB.Flavor.secretValues
		end
		table.insert(TRB.Data.statsByBucket[stat.refresh], stat)
	end
	for bucket, events in pairs(TRB.Flavor.statEvents) do
		for _, event in ipairs(events) do
			TRB.Data.statEventBuckets[event] = TRB.Data.statEventBuckets[event] or {}
			table.insert(TRB.Data.statEventBuckets[event], bucket)
		end
	end
end
