local _, TRB = ...

TRB.Functions = TRB.Functions or {}

---@class TRB.Functions.Profiles
TRB.Functions.Profiles = {}

-- The hard-coded name of the profile created on first-load migration.
TRB.Functions.Profiles.DEFAULT_NAME = "Default"

---@type table<string, string>
local PROFILE_CLASS_OPTIONS_KEY = {
	deathknight = "DeathKnight",
	demonhunter = "DemonHunter",
	druid = "Druid",
	evoker = "Evoker",
	hunter = "Hunter",
	mage = "Mage",
	monk = "Monk",
	paladin = "Paladin",
	priest = "Priest",
	rogue = "Rogue",
	shaman = "Shaman",
	warlock = "Warlock",
	warrior = "Warrior",
}

---@return string[]
local function GetSupportedClassNames()
	local out = {}
	local enabled = TRB.Data and TRB.Data.settings
		and TRB.Data.settings.core and TRB.Data.settings.core.enabled
	if type(enabled) == "table" then
		for className, _ in pairs(enabled) do
			out[#out + 1] = className
		end
		return out
	end

	for className, _ in pairs(PROFILE_CLASS_OPTIONS_KEY) do
		out[#out + 1] = className
	end
	return out
end

---@param className string
---@return table?
local function GetDefaultClassSettings(className)
	local optionsKey = PROFILE_CLASS_OPTIONS_KEY[className]
	if optionsKey == nil or TRB.Options == nil then
		return nil
	end

	local classOptions = TRB.Options[optionsKey]
	if type(classOptions) ~= "table" or type(classOptions.LoadDefaultSettings) ~= "function" then
		return nil
	end

	local defaults = classOptions.LoadDefaultSettings(true)
	if type(defaults) ~= "table" or type(defaults[className]) ~= "table" then
		return nil
	end

	return defaults[className]
end

---@return table?
local function GetDefaultCoreSettings()
	if TRB.Functions.Settings == nil or type(TRB.Functions.Settings.LoadDefaultSettings) ~= "function" then
		return nil
	end

	local defaults = TRB.Functions.Settings:LoadDefaultSettings()
	if type(defaults) ~= "table" or type(defaults.core) ~= "table" then
		return nil
	end

	return defaults.core
end

---@return table<string, any>
local function BuildDefaultProfileSeed()
	local seed = {}
	local coreDefaults = GetDefaultCoreSettings()
	if type(coreDefaults) == "table" then
		seed.core = TRB.Functions.Table:DeepCopy(coreDefaults)
	end

	for _, className in ipairs(GetSupportedClassNames()) do
		local classDefaults = GetDefaultClassSettings(className)
		if type(classDefaults) == "table" then
			seed[className] = TRB.Functions.Table:DeepCopy(classDefaults)
		end
	end

	return seed
end

---Returns the lowercase class token ("druid", "priest", etc.) for the current
---character, derived from WoW's UnitClassBase API. Matches the string stored
---in TRB.Data.character.className but doesn't require the class module's
---ADDON_LOADED handler to have run yet. Returns nil if the API is unavailable.
---@return string?
function TRB.Functions.Profiles:GetCurrentClassName()
	local classToken = UnitClassBase and UnitClassBase("player")
	if classToken == nil or classToken == "" then
		return nil
	end
	return string.lower(classToken)
end

---Returns the list of specNames supported for the given class, derived from
---`TRB.Data.settings.core.enabled[className]` which `LoadDefaultSettings`
---populates with every supported spec for every class. Returns an empty
---table if settings aren't loaded yet or the class isn't recognised.
---@param className string
---@return string[]
function TRB.Functions.Profiles:GetSpecsForClass(className)
	local out = {}
	local enabled = TRB.Data and TRB.Data.settings
		and TRB.Data.settings.core and TRB.Data.settings.core.enabled
	if type(enabled) ~= "table" then
		return out
	end
	local specs = enabled[className]
	if type(specs) ~= "table" then
		return out
	end
	for specName, _ in pairs(specs) do
		out[#out + 1] = specName
	end
	return out
end

---Returns the "Name-Realm" key for the current character, or nil if either
---UnitName or GetRealmName is unavailable (e.g. before PLAYER_LOGIN).
---@return string?
function TRB.Functions.Profiles:GetCharacterKey()
	local name = UnitName("player")
	local realm = GetRealmName()
	if name == nil or name == "" or realm == nil or realm == "" then
		return nil
	end
	return name .. "-" .. realm
end

---Ensures TRB.Data.settings.profiles has the expected { list, default, character } shape.
---Idempotent; safe to call repeatedly.
function TRB.Functions.Profiles:EnsureStructure()
	if TRB.Data.settings == nil then
		return
	end
	if TRB.Data.settings.profiles == nil then
		TRB.Data.settings.profiles = {}
	end
	local p = TRB.Data.settings.profiles
	p.list = p.list or {}
	p.default = p.default or {}
	p.character = p.character or {}
end

---Resolves the profile name in use for the `core` scope on the current character,
---falling back to the default-profile entry, then to nil if nothing is configured.
---@return string?
function TRB.Functions.Profiles:ResolveCoreProfileName()
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil then
		return nil
	end

	local key = self:GetCharacterKey()
	if key ~= nil and p.character and p.character[key] and p.character[key].core then
		return p.character[key].core
	end
	if p.default and p.default.core then
		return p.default.core
	end
	return nil
end

---Resolves the profile name in use for a (className, specName) on the current
---character, falling back to the per-spec default, then to nil.
---A character belongs to exactly one class, so profiles.character uses a flat
---specName key — there's no ambiguity between e.g. Priest "holy" and Paladin
---"holy" because the character can only ever be one or the other.
---@param className string
---@param specName string
---@return string?
function TRB.Functions.Profiles:ResolveSpecProfileName(className, specName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil then
		return nil
	end

	local key = self:GetCharacterKey()
	if key ~= nil and p.character and p.character[key] and p.character[key][specName] then
		return p.character[key][specName]
	end
	if p.default and p.default[className] and p.default[className][specName] then
		return p.default[className][specName]
	end
	return nil
end

---Returns true if removing or resetting the current core profile should force
---a reload for this character.
---@param profileName string?
---@return boolean
function TRB.Functions.Profiles:ShouldReloadAfterCoreRemoval(profileName)
	return profileName ~= nil and self:ResolveCoreProfileName() == profileName
end

---Returns true if removing or resetting the given spec piece should force a
---reload for this character.
---@param profileName string?
---@param className string?
---@param specName string?
---@return boolean
function TRB.Functions.Profiles:ShouldReloadAfterSpecRemoval(profileName, className, specName)
	if profileName == nil or className == nil or specName == nil then
		return false
	end

	if profileName == self.DEFAULT_NAME then
		return self:GetCurrentClassName() == className
			and self:ResolveSpecProfileName(className, specName) == profileName
	end

	return self:ResolveSpecProfileName(className, specName) == profileName
end

---Returns true if removing or resetting all spec pieces for `className`
---should force a reload for this character.
---@param profileName string?
---@param className string?
---@return boolean
function TRB.Functions.Profiles:ShouldReloadAfterClassRemoval(profileName, className)
	if profileName == nil or className == nil then
		return false
	end

	if profileName == self.DEFAULT_NAME and self:GetCurrentClassName() ~= className then
		return false
	end

	for _, specName in ipairs(self:GetSpecsForClass(className)) do
		if self:ShouldReloadAfterSpecRemoval(profileName, className, specName) then
			return true
		end
	end

	return false
end

---Returns true if removing or resetting the entire profile should force a
---reload for this character.
---@param profileName string?
---@return boolean
function TRB.Functions.Profiles:ShouldReloadAfterProfileRemoval(profileName)
	if profileName == nil then
		return false
	end

	if self:ShouldReloadAfterCoreRemoval(profileName) then
		return true
	end

	local currentClassName = self:GetCurrentClassName()
	if currentClassName == nil then
		return false
	end

	for _, specName in ipairs(self:GetSpecsForClass(currentClassName)) do
		if self:ResolveSpecProfileName(currentClassName, specName) == profileName then
			return true
		end
	end

	return false
end

---Returns the `core` subtable from the resolved profile for the current character,
---or nil if no profile resolves to a piece that contains `core`.
---@return table?
function TRB.Functions.Profiles:GetResolvedCorePiece()
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		return nil
	end
	local name = self:ResolveCoreProfileName()
	if name == nil then
		return nil
	end
	local profile = p.list[name]
	if profile == nil then
		return nil
	end
	return profile.core
end

---Returns the spec subtable from the resolved profile for the current character,
---or nil if no profile resolves or the resolved profile doesn't include that spec.
---@param className string
---@param specName string
---@return table?
function TRB.Functions.Profiles:GetResolvedSpecPiece(className, specName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		return nil
	end
	local name = self:ResolveSpecProfileName(className, specName)
	if name == nil then
		return nil
	end
	local profile = p.list[name]
	if profile == nil then
		return nil
	end
	if profile[className] == nil then
		return nil
	end
	return profile[className][specName]
end

---Iterates every stored profile, invoking callback(profileName, profile) for each.
---@param callback fun(profileName: string, profile: table)
function TRB.Functions.Profiles:IterateAll(callback)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		return
	end
	for name, profile in pairs(p.list) do
		callback(name, profile)
	end
end

---One-time seed per character: creates profiles.list["Default"] if missing,
---then backfills it so it contains `core` plus all 13 classes / 40 specs.
---The current class is seeded from live runtime settings to preserve legacy
---customizations; all other classes are seeded from their canonical
---`LoadDefaultSettings(true)` factories.
---
---Also wires profiles.default.core = "Default" (if unset) and
---profiles.default[className][spec] = "Default" for every supported spec,
---and ensures profiles.character[key] exists.
---
---Idempotent: safe to call on every login.
function TRB.Functions.Profiles:SeedFromLegacy()
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	local className = self:GetCurrentClassName()
	local defaultSeed = BuildDefaultProfileSeed()

	-- Create the Default profile if it doesn't exist.
	if p.list[self.DEFAULT_NAME] == nil then
		p.list[self.DEFAULT_NAME] = {}
	end
	---@type table<string, any>
	local profile = p.list[self.DEFAULT_NAME]

	-- Copy `core` in once. `core` is class-agnostic so seeding from the first
	-- character to log in is fine; later characters will see the profile already
	-- has it and skip.
	if profile.core == nil then
		if TRB.Data.settings.core ~= nil then
			profile.core = TRB.Functions.Table:DeepCopy(TRB.Data.settings.core)
		elseif type(defaultSeed.core) == "table" then
			profile.core = TRB.Functions.Table:DeepCopy(defaultSeed.core)
		end
	end

	-- Seed every class/spec into the Default profile. The current class comes
	-- from live runtime settings so legacy customizations survive the migration;
	-- other classes come from their canonical default factories.
	for _, seededClassName in ipairs(GetSupportedClassNames()) do
		local sourceClassPiece = defaultSeed[seededClassName]
		local runtimeClassPiece = TRB.Data.settings and TRB.Data.settings[seededClassName]
		if seededClassName == className and type(runtimeClassPiece) == "table" then
			sourceClassPiece = runtimeClassPiece
		end

		if type(sourceClassPiece) == "table" then
			profile[seededClassName] = profile[seededClassName] or {}
			for _, specName in ipairs(self:GetSpecsForClass(seededClassName)) do
				if profile[seededClassName][specName] == nil then
					local specPiece = sourceClassPiece[specName]
					if specPiece == nil and type(defaultSeed[seededClassName]) == "table" then
						specPiece = defaultSeed[seededClassName][specName]
					end
					if type(specPiece) == "table" then
						profile[seededClassName][specName] = TRB.Functions.Table:DeepCopy(specPiece)
					end
				end
			end
		end
	end

	-- Wire profiles.default.core if unset.
	if p.default.core == nil then
		p.default.core = self.DEFAULT_NAME
	end

	-- Wire profiles.default[class][spec] for every supported class/spec.
	-- Existing entries are preserved so UI changes and admin overrides aren't
	-- stomped during subsequent logins.
	for _, seededClassName in ipairs(GetSupportedClassNames()) do
		p.default[seededClassName] = p.default[seededClassName] or {}
		for _, specName in ipairs(self:GetSpecsForClass(seededClassName)) do
			if p.default[seededClassName][specName] == nil then
				p.default[seededClassName][specName] = self.DEFAULT_NAME
			end
		end
	end

	-- Ensure the character override bucket exists so Phase 2 UI has somewhere
	-- to write. No spec assignments are added here (the defaults path above
	-- already resolves correctly without character-level entries).
	local key = self:GetCharacterKey()
	if key ~= nil then
		p.character[key] = p.character[key] or {}
	end
end

---Runs port-forward migrations against every stored profile. Each profile is
---shaped like a top-level settings table (optional `core` + class/spec keys),
---so we call PortForwardSettings against the profile table directly and let
---the full migration pipeline run against it.
function TRB.Functions.Profiles:PortForwardAll()
	self:EnsureStructure()
	local Settings = TRB.Functions.Settings
	if Settings == nil or Settings.PortForwardSettings == nil then
		return
	end
	self:IterateAll(function(_, profile)
		Settings:PortForwardSettings(profile)
	end)
end

---Drops the resolved profile pieces in place over `TRB.Data.settings.core` and
---all resolved class/spec tables. The current class is still merged in place,
---preserving the identity of those tables (and every nested sub-table that
---already exists). Other code may have
---captured references into these tables before this point — most notably
---`FillSpecializationCacheSettings` does `specCache.settings.bars = spec.bars`
---and `colors = { bar = spec.colors.bar, bars = spec.colors.bars, ... }`, and
---various bar-construction paths cache references to leaf tables. Replacing
---the top-level reference would orphan all of those, which is exactly how the
---Holy Priest Lightweaver bar broke.
---
---Non-current classes are first defaulted via `Character:EnsureSpecSettings`
---so runtime tables still receive newly-added default fields before the
---resolved profile overlays on top.
---Must be called AFTER legacy merge has populated TRB.Data.settings and
---AFTER SeedFromLegacy has populated profiles.
function TRB.Functions.Profiles:ApplyToRuntime()
	if TRB.Data.settings == nil then
		return
	end

	local corePiece = self:GetResolvedCorePiece()
	if corePiece ~= nil and type(TRB.Data.settings.core) == "table" then
		TRB.Functions.Table:DeepMergeInto(TRB.Data.settings.core, corePiece)
	end

	local currentClassName = self:GetCurrentClassName()
	for _, className in ipairs(GetSupportedClassNames()) do
		TRB.Data.settings[className] = TRB.Data.settings[className] or {}

		local Character = TRB.Functions.Character
		if Character ~= nil and type(Character.EnsureSpecSettings) == "function" then
			Character:EnsureSpecSettings(className)
		end

		local classPiece = TRB.Data.settings[className]
		if type(classPiece) == "table" then
			for _, specName in ipairs(self:GetSpecsForClass(className)) do
				local specPiece = self:GetResolvedSpecPiece(className, specName)
				if type(specPiece) == "table" then
					if className == currentClassName and type(classPiece[specName]) == "table" then
						TRB.Functions.Table:DeepMergeInto(classPiece[specName], specPiece)
					elseif type(classPiece[specName]) == "table" then
						classPiece[specName] = TRB.Functions.Table:DeepMergeCopy(classPiece[specName], specPiece)
					else
						classPiece[specName] = TRB.Functions.Table:DeepCopy(specPiece)
					end
				end
			end
		end
	end
end

---Writes the live TRB.Data.settings.core and all resolved class/spec pieces
---back to the active profiles for this character. Called at
---PLAYER_LOGOUT so user edits (which today land in TRB.Data.settings) persist
---into the correct profile, including edits made to non-current-class specs.
---
---This is the Phase 1 persistence strategy ("Option A") - a deferred flush.
---Phase 2 will migrate the options UI to WriteThrough so the flush becomes
---a safety net rather than the primary path.
function TRB.Functions.Profiles:FlushActive()
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		return
	end

	local coreName = self:ResolveCoreProfileName()
	if coreName ~= nil and p.list[coreName] ~= nil and TRB.Data.settings.core ~= nil then
		p.list[coreName].core = TRB.Functions.Table:DeepCopy(TRB.Data.settings.core)
	end

	for _, className in ipairs(GetSupportedClassNames()) do
		local classPiece = TRB.Data.settings[className]
		if type(classPiece) == "table" then
			for _, specName in ipairs(self:GetSpecsForClass(className)) do
				local specPiece = classPiece[specName]
				if type(specPiece) == "table" then
					local profileName = self:ResolveSpecProfileName(className, specName)
					if profileName ~= nil and p.list[profileName] ~= nil then
						p.list[profileName][className] = p.list[profileName][className] or {}
						p.list[profileName][className][specName] = TRB.Functions.Table:DeepCopy(specPiece)
					end
				end
			end
		end
	end
end

---Flushes current runtime data to the currently-active profile, then
---suppresses the automatic PLAYER_LOGOUT flush so the upcoming C_UI.Reload()
---doesn't re-flush stale runtime data into the newly-selected profile.
---Call this immediately BEFORE changing the active profile pointer when the
---switch will be followed by a reload.
function TRB.Functions.Profiles:FlushAndSuppressLogout()
	self:FlushActive()
	self:SuppressLogoutFlush()
end

---Suppresses the automatic PLAYER_LOGOUT flush for the next reload/logout.
---Use this after destructive profile operations that should not write the
---current runtime state into the fallback profile.
function TRB.Functions.Profiles:SuppressLogoutFlush()
	self.suppressLogoutFlush = true
end

---Write-through stub used by Phase 2 UI. Persists the given spec or core piece
---from TRB.Data.settings into the resolved active profile immediately, so
---changes made via the options panel survive `/reload` without waiting for
---PLAYER_LOGOUT. Not wired up to UI writers in Phase 1.
---@param scope "core"|"spec"
---@param className string?
---@param specName string?
function TRB.Functions.Profiles:WriteThrough(scope, className, specName)
	if TRB.Data.settings == nil then
		return
	end
	local p = TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		return
	end
	if scope == "core" then
		local name = self:ResolveCoreProfileName()
		if name ~= nil and p.list[name] ~= nil and TRB.Data.settings.core ~= nil then
			p.list[name].core = TRB.Functions.Table:DeepCopy(TRB.Data.settings.core)
		end
	elseif scope == "spec" and className ~= nil and specName ~= nil then
		local name = self:ResolveSpecProfileName(className, specName)
		local runtime = TRB.Data.settings[className] and TRB.Data.settings[className][specName]
		if name ~= nil and p.list[name] ~= nil and type(runtime) == "table" then
			p.list[name][className] = p.list[name][className] or {}
			p.list[name][className][specName] = TRB.Functions.Table:DeepCopy(runtime)
		end
	end
end

-- ============================================================================
-- Phase 2 CRUD API
-- ============================================================================
-- The functions below back the profile management UI. They operate on scope
-- "pieces" of the stored profile table: the `core` slot, or a single
-- `[className][specName]` slot. Operations on one scope never touch another.
--
-- All CRUD functions invalidate the list cache so subsequent dropdown opens
-- see fresh data. They also keep `profiles.character[key]` consistent: if a
-- rename/delete affects a profile that a character is currently pointing at,
-- the character's pointer is updated (rename) or cleared (delete) so the
-- resolver falls back to `profiles.default.*`.

---Checks whether a profile entry exists and contains a spec piece.
---@param profileName string
---@param className string
---@param specName string
---@return boolean
function TRB.Functions.Profiles:ProfileExistsForSpec(profileName, className, specName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or profileName == nil then
		return false
	end
	local entry = p.list[profileName]
	if type(entry) ~= "table" then
		return false
	end
	return type(entry[className]) == "table" and type(entry[className][specName]) == "table"
end

---Checks whether a profile entry exists and contains a core piece.
---@param profileName string
---@return boolean
function TRB.Functions.Profiles:ProfileExistsForCore(profileName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or profileName == nil then
		return false
	end
	local entry = p.list[profileName]
	if type(entry) ~= "table" then
		return false
	end
	return type(entry.core) == "table"
end

---Returns true if the given `profiles.list[name]` entry has no meaningful
---content (no `core`, and no class/spec tables with any entries). Used by
---delete helpers to prune empty wrapper tables.
---@param profileName string
---@return boolean
function TRB.Functions.Profiles:IsListEntryEmpty(profileName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		return true
	end
	local entry = p.list[profileName]
	if type(entry) ~= "table" then
		return true
	end
	if type(entry.core) == "table" then
		return false
	end
	for k, v in pairs(entry) do
		if k ~= "core" and type(v) == "table" then
			for _, _ in pairs(v) do
				return false
			end
		end
	end
	return true
end

---Removes a `profiles.list[name]` entry if it has no remaining scope pieces.
---Safe to call unconditionally after any delete.
---@param profileName string
function TRB.Functions.Profiles:PruneEmptyEntry(profileName)
	if profileName == nil then
		return
	end
	if self:IsListEntryEmpty(profileName) then
		local p = TRB.Data.settings and TRB.Data.settings.profiles
		if p ~= nil and p.list ~= nil then
			p.list[profileName] = nil
		end
	end
end

---Sets the active spec-scope profile for the current character. Writes to
---`profiles.character[key][specName]`.
---@param specName string
---@param profileName string?
function TRB.Functions.Profiles:SetActiveSpecProfile(specName, profileName)
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	local key = self:GetCharacterKey()
	if key == nil or specName == nil then
		return
	end
	p.character[key] = p.character[key] or {}
	p.character[key][specName] = profileName
end

---Sets the active core-scope profile for the current character. Writes to
---`profiles.character[key].core`.
---@param profileName string?
function TRB.Functions.Profiles:SetActiveCoreProfile(profileName)
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	local key = self:GetCharacterKey()
	if key == nil then
		return
	end
	p.character[key] = p.character[key] or {}
	p.character[key].core = profileName
end

---Creates or overwrites the spec piece of a profile with a deep copy of
---`sourcePiece`. Creates the `profiles.list[profileName]` entry and class
---bucket if needed.
---@param profileName string
---@param className string
---@param specName string
---@param sourcePiece table
function TRB.Functions.Profiles:CreateSpecProfile(profileName, className, specName, sourcePiece)
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	if profileName == nil or className == nil or specName == nil or type(sourcePiece) ~= "table" then
		return
	end
	if p.list[profileName] == nil then
		p.list[profileName] = {}
	end
	local entry = p.list[profileName]
	entry[className] = entry[className] or {}
	entry[className][specName] = TRB.Functions.Table:DeepCopy(sourcePiece)
	self:InvalidateCache()
end

---Creates or overwrites the core piece of a profile with a deep copy of
---`sourcePiece`. Creates the `profiles.list[profileName]` entry if needed.
---@param profileName string
---@param sourcePiece table
function TRB.Functions.Profiles:CreateCoreProfile(profileName, sourcePiece)
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	if profileName == nil or type(sourcePiece) ~= "table" then
		return
	end
	if p.list[profileName] == nil then
		p.list[profileName] = {}
	end
	p.list[profileName].core = TRB.Functions.Table:DeepCopy(sourcePiece)
	self:InvalidateCache()
end

---Copies the spec piece from one profile to another. Returns true on success.
---@param srcName string
---@param dstName string
---@param className string
---@param specName string
---@return boolean
function TRB.Functions.Profiles:CopySpecProfile(srcName, dstName, className, specName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil then
		return false
	end
	local exists = self:ProfileExistsForSpec(srcName, className, specName)
	if not exists then
		local resolved = self:ResolveSpecProfileName(className, specName) or self.DEFAULT_NAME
		local hasLive = TRB.Data.settings[className] ~= nil and type(TRB.Data.settings[className][specName]) == "table"
		if resolved == srcName and hasLive then
			self:CreateSpecProfile(srcName, className, specName, TRB.Data.settings[className][specName])
		else
			return false
		end
	end
	local src = p.list[srcName][className][specName]
	self:CreateSpecProfile(dstName, className, specName, src)
	return true
end

---Copies the core piece from one profile to another. Returns true on success.
---@param srcName string
---@param dstName string
---@return boolean
function TRB.Functions.Profiles:CopyCoreProfile(srcName, dstName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil then
		return false
	end
	local exists = self:ProfileExistsForCore(srcName)
	if not exists then
		local resolved = self:ResolveCoreProfileName() or self.DEFAULT_NAME
		local hasLive = type(TRB.Data.settings.core) == "table"
		if resolved == srcName and hasLive then
			self:CreateCoreProfile(srcName, TRB.Data.settings.core)
		else
			return false
		end
	end
	self:CreateCoreProfile(dstName, p.list[srcName].core)
	return true
end

---Renames the spec piece of a profile. Moves `list[oldName][class][spec]` to
---`list[newName][class][spec]`, updates every `character.*[specName] == oldName`
---reference to `newName`, and prunes `list[oldName]` if it has no remaining
---scope pieces. Returns true on success.
---@param oldName string
---@param newName string
---@param className string
---@param specName string
---@return boolean
function TRB.Functions.Profiles:RenameSpecProfile(oldName, newName, className, specName)
	if oldName == nil or newName == nil or oldName == newName then
		return false
	end
	if not self:ProfileExistsForSpec(oldName, className, specName) then
		return false
	end
	local p = TRB.Data.settings.profiles
	local piece = p.list[oldName][className][specName]
	-- Move the piece (not a copy — we're renaming, not duplicating).
	p.list[newName] = p.list[newName] or {}
	p.list[newName][className] = p.list[newName][className] or {}
	p.list[newName][className][specName] = piece
	p.list[oldName][className][specName] = nil
	-- Clean up now-empty class bucket in the old entry.
	if next(p.list[oldName][className]) == nil then
		p.list[oldName][className] = nil
	end
	-- Update every character override pointing at oldName for this spec.
	for _, entry in pairs(p.character) do
		if type(entry) == "table" and entry[specName] == oldName then
			entry[specName] = newName
		end
	end
	-- Update profiles.default[className][specName] if it pointed at oldName.
	if p.default[className] ~= nil and p.default[className][specName] == oldName then
		p.default[className][specName] = newName
	end
	self:PruneEmptyEntry(oldName)
	self:InvalidateCache()
	return true
end

---Renames the core piece of a profile. Moves `list[oldName].core` to
---`list[newName].core`, updates every `character.*.core == oldName` reference,
---and prunes `list[oldName]` if empty. Returns true on success.
---@param oldName string
---@param newName string
---@return boolean
function TRB.Functions.Profiles:RenameCoreProfile(oldName, newName)
	if oldName == nil or newName == nil or oldName == newName then
		return false
	end
	if not self:ProfileExistsForCore(oldName) then
		return false
	end
	local p = TRB.Data.settings.profiles
	p.list[newName] = p.list[newName] or {}
	p.list[newName].core = p.list[oldName].core
	p.list[oldName].core = nil
	for _, entry in pairs(p.character) do
		if type(entry) == "table" and entry.core == oldName then
			entry.core = newName
		end
	end
	if p.default.core == oldName then
		p.default.core = newName
	end
	self:PruneEmptyEntry(oldName)
	self:InvalidateCache()
	return true
end

---Deletes the spec piece of a profile. For non-Default profiles, clears any
---character override that pointed at this profile for that spec and repoints
---any affected profile default back to Default. For the Default profile, this
---resets the spec to the built-in baseline config. Prunes the list entry if
---empty. Returns true on success.
---@param profileName string
---@param className string
---@param specName string
---@return boolean
function TRB.Functions.Profiles:DeleteSpecProfile(profileName, className, specName)
	if profileName == self.DEFAULT_NAME then
		local classDefaults = GetDefaultClassSettings(className)
		if type(classDefaults) ~= "table" or type(classDefaults[specName]) ~= "table" then
			return false
		end
		self:CreateSpecProfile(profileName, className, specName, classDefaults[specName])
		return true
	end

	if not self:ProfileExistsForSpec(profileName, className, specName) then
		return false
	end
	local p = TRB.Data.settings.profiles
	p.list[profileName][className][specName] = nil
	if next(p.list[profileName][className]) == nil then
		p.list[profileName][className] = nil
	end
	if p.default[className] ~= nil and p.default[className][specName] == profileName then
		p.default[className][specName] = self.DEFAULT_NAME
	end
	for _, entry in pairs(p.character) do
		if type(entry) == "table" and entry[specName] == profileName then
			entry[specName] = nil
		end
	end
	self:PruneEmptyEntry(profileName)
	self:InvalidateCache()
	return true
end

---Deletes the core piece of a profile. For non-Default profiles, clears any
---character override pointing at this profile for core and repoints any
---affected profile default back to Default. For the Default profile, this
---resets the core settings to the built-in baseline config. Prunes the list
---entry if empty. Returns true on success.
---@param profileName string
---@return boolean
function TRB.Functions.Profiles:DeleteCoreProfile(profileName)
	if profileName == self.DEFAULT_NAME then
		local coreDefaults = GetDefaultCoreSettings()
		if type(coreDefaults) ~= "table" then
			return false
		end
		self:CreateCoreProfile(profileName, coreDefaults)
		return true
	end

	if not self:ProfileExistsForCore(profileName) then
		return false
	end
	local p = TRB.Data.settings.profiles
	p.list[profileName].core = nil
	if p.default ~= nil and p.default.core == profileName then
		p.default.core = self.DEFAULT_NAME
	end
	for _, entry in pairs(p.character) do
		if type(entry) == "table" and entry.core == profileName then
			entry.core = nil
		end
	end
	self:PruneEmptyEntry(profileName)
	self:InvalidateCache()
	return true
end

---Returns a sorted array of profile names that have a piece for the given
---spec. "Default" is always first (even if it doesn't currently have a piece
---— the first write will create it); remaining names are alphabetical.
---@param className string
---@param specName string
---@return string[]
function TRB.Functions.Profiles:ListSpecProfileNames(className, specName)
	local out = {}
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		out[1] = self.DEFAULT_NAME
		return out
	end
	local seen = {}
	for name, entry in pairs(p.list) do
		if name ~= self.DEFAULT_NAME and type(entry) == "table"
			and type(entry[className]) == "table"
			and type(entry[className][specName]) == "table" then
			out[#out + 1] = name
			seen[name] = true
		end
	end
	table.sort(out, function(a, b) return a:lower() < b:lower() end)
	table.insert(out, 1, self.DEFAULT_NAME)
	return out
end

---Returns a sorted array of profile names that have a core piece. "Default"
---is always first; remaining names are alphabetical.
---@return string[]
function TRB.Functions.Profiles:ListCoreProfileNames()
	local out = {}
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		out[1] = self.DEFAULT_NAME
		return out
	end
	for name, entry in pairs(p.list) do
		if name ~= self.DEFAULT_NAME and type(entry) == "table" and type(entry.core) == "table" then
			out[#out + 1] = name
		end
	end
	table.sort(out, function(a, b) return a:lower() < b:lower() end)
	table.insert(out, 1, self.DEFAULT_NAME)
	return out
end

---Invalidates the per-scope list cache. Call after any CRUD operation.
function TRB.Functions.Profiles:InvalidateCache()
	self.listCache = nil
end

---Returns the cached sorted list of profile names with a piece for the given
---spec, rebuilding the cache if needed.
---@param className string
---@param specName string
---@return string[]
function TRB.Functions.Profiles:GetSpecListFromCache(className, specName)
	self.listCache = self.listCache or { spec = {}, core = nil }
	self.listCache.spec = self.listCache.spec or {}
	self.listCache.spec[className] = self.listCache.spec[className] or {}
	local wasCached = self.listCache.spec[className][specName] ~= nil
	if self.listCache.spec[className][specName] == nil then
		self.listCache.spec[className][specName] = self:ListSpecProfileNames(className, specName)
	end
	local list = self.listCache.spec[className][specName]
	return list
end

---Returns the cached sorted list of profile names with a core piece,
---rebuilding the cache if needed.
---@return string[]
function TRB.Functions.Profiles:GetCoreListFromCache()
	self.listCache = self.listCache or { spec = {}, core = nil }
	local wasCached = self.listCache.core ~= nil
	if self.listCache.core == nil then
		self.listCache.core = self:ListCoreProfileNames()
	end
	return self.listCache.core
end

-- ─────────────────────────────────────────────────────────────────────
-- Bar-wide profile management helpers (used by the Import/Export panel)
-- ─────────────────────────────────────────────────────────────────────

---Returns a sorted array of all profile names present in profiles.list.
---"Default" is always first; remaining names are sorted alphabetically.
---@return string[]
function TRB.Functions.Profiles:GetProfileNames()
	local out = {}
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then
		out[1] = self.DEFAULT_NAME
		return out
	end
	for name, _ in pairs(p.list) do
		if name ~= self.DEFAULT_NAME then
			out[#out + 1] = name
		end
	end
	table.sort(out, function(a, b) return a:lower() < b:lower() end)
	table.insert(out, 1, self.DEFAULT_NAME)
	return out
end

---Returns the total number of class/spec pieces stored in a profile.
---The core ("Global Options") piece is not counted.
---@param profileName string
---@return integer
function TRB.Functions.Profiles:GetProfileSpecCount(profileName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then return 0 end
	local entry = p.list[profileName]
	if type(entry) ~= "table" then return 0 end
	local count = 0
	for k, v in pairs(entry) do
		if k ~= "core" and type(v) == "table" then
			for _, sv in pairs(v) do
				if type(sv) == "table" then
					count = count + 1
				end
			end
		end
	end
	return count
end

---Returns true if the given profile has a core ("Global Options") piece.
---@param profileName string
---@return boolean
function TRB.Functions.Profiles:ProfileHasCore(profileName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then return false end
	local entry = p.list[profileName]
	return type(entry) == "table" and type(entry.core) == "table" and next(entry.core) ~= nil
end

---Deletes ALL scope pieces from the given profile and clears every character
---reference that pointed at it so resolution falls back to `profiles.default`.
---Any affected profile defaults are repointed back to Default. If the profile
---IS "Default", delegates to ResetDefaultProfile.
---@param profileName string
---@return boolean
function TRB.Functions.Profiles:DeleteProfile(profileName)
	if profileName == self.DEFAULT_NAME then
		return self:ResetDefaultProfile()
	end
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or p.list[profileName] == nil then return false end

	-- Clear profiles.default.core reference
	if p.default ~= nil and p.default.core == profileName then
		p.default.core = self.DEFAULT_NAME
	end
	-- Clear profiles.default[className][specName] references
	if p.default ~= nil then
		for className, classEntry in pairs(p.default) do
			if className ~= "core" and type(classEntry) == "table" then
				for specName, resolvedName in pairs(classEntry) do
					if resolvedName == profileName then
						classEntry[specName] = self.DEFAULT_NAME
					end
				end
			end
		end
	end
	-- Clear profiles.character[key].* references
	for _, charEntry in pairs(p.character) do
		if type(charEntry) == "table" then
			for k, v in pairs(charEntry) do
				if v == profileName then
					charEntry[k] = nil
				end
			end
		end
	end
	-- Remove the entire list entry
	p.list[profileName] = nil
	self:InvalidateCache()
	return true
end

---Deletes all spec pieces for a given class from a profile, rewiring
---character references back to `profiles.default`. For the Default profile,
---resets the entire class to the built-in baseline config. Does NOT touch the
---core piece. Prunes the profile entry if it becomes empty.
---@param profileName string
---@param className string
---@return boolean
function TRB.Functions.Profiles:DeleteClassFromProfile(profileName, className)
	if profileName == self.DEFAULT_NAME then
		local classDefaults = GetDefaultClassSettings(className)
		if type(classDefaults) ~= "table" then
			return false
		end
		self:EnsureStructure()
		local p = TRB.Data.settings.profiles
		p.list[profileName] = p.list[profileName] or {}
		p.list[profileName][className] = TRB.Functions.Table:DeepCopy(classDefaults)
		self:InvalidateCache()
		return true
	end

	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or p.list[profileName] == nil then return false end
	local classPiece = p.list[profileName][className]
	if type(classPiece) ~= "table" then return false end
	local specNames = {}
	for specName, _ in pairs(classPiece) do
		specNames[#specNames + 1] = specName
	end
	local didDelete = false
	for _, specName in ipairs(specNames) do
		didDelete = self:DeleteSpecProfile(profileName, className, specName) or didDelete
	end
	self:PruneEmptyEntry(profileName)
	self:InvalidateCache()
	return didDelete
end

---Resets the Default profile to the built-in baseline config.
---@return boolean
function TRB.Functions.Profiles:ResetDefaultProfile()
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	p.list[self.DEFAULT_NAME] = BuildDefaultProfileSeed()
	if p.default.core == nil then
		p.default.core = self.DEFAULT_NAME
	end
	for _, className in ipairs(GetSupportedClassNames()) do
		p.default[className] = p.default[className] or {}
		for _, specName in ipairs(self:GetSpecsForClass(className)) do
			if p.default[className][specName] == nil then
				p.default[className][specName] = self.DEFAULT_NAME
			end
		end
	end
	local key = self:GetCharacterKey()
	if key ~= nil then
		p.character[key] = p.character[key] or {}
	end
	self:InvalidateCache()
	return true
end

---Renames a profile bar-wide: renames the list key and updates every reference
---in profiles.default and profiles.character across all classes and specs.
---Refuses to rename the "Default" profile. Returns true on success.
---@param oldName string
---@param newName string
---@return boolean
function TRB.Functions.Profiles:RenameProfileBarWide(oldName, newName)
	if oldName == nil or newName == nil or oldName == newName then return false end
	if oldName == self.DEFAULT_NAME then return false end
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then return false end
	if p.list[oldName] == nil then return false end
	if p.list[newName] ~= nil then return false end -- destination already exists

	-- Move the list entry
	p.list[newName] = p.list[oldName]
	p.list[oldName] = nil

	-- Update profiles.default.core
	if p.default ~= nil and p.default.core == oldName then
		p.default.core = newName
	end
	-- Update profiles.default[className][specName]
	if p.default ~= nil then
		for className, classEntry in pairs(p.default) do
			if className ~= "core" and type(classEntry) == "table" then
				for specName, resolvedName in pairs(classEntry) do
					if resolvedName == oldName then
						classEntry[specName] = newName
					end
				end
			end
		end
	end
	-- Update profiles.character[key].*
	for _, charEntry in pairs(p.character) do
		if type(charEntry) == "table" then
			for k, v in pairs(charEntry) do
				if v == oldName then
					charEntry[k] = newName
				end
			end
		end
	end
	self:InvalidateCache()
	return true
end

---Creates a full copy of a profile. Deep-copies every piece (core + all
---class/spec pieces) from srcName into dstName. If dstName already exists,
---its pieces are completely overwritten. Returns true on success.
---@param srcName string
---@param dstName string
---@return boolean
function TRB.Functions.Profiles:CopyProfileFull(srcName, dstName)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then return false end
	if p.list[srcName] == nil then return false end
	p.list[dstName] = TRB.Functions.Table:DeepCopy(p.list[srcName])
	self:InvalidateCache()
	return true
end

---Creates a partial copy of a profile, including only the pieces indicated by
---`selection`. `selection.core = true` copies the core piece;
---`selection[className][specName] = true` copies that spec piece.
---Returns true on success.
---@param srcName string
---@param dstName string
---@param selection table # { core = bool, [className] = { [specName] = bool } }
---@return boolean
function TRB.Functions.Profiles:CopyProfileSelection(srcName, dstName, selection)
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil then return false end
	if p.list[srcName] == nil or selection == nil then return false end
	p.list[dstName] = p.list[dstName] or {}
	local src = p.list[srcName]
	local dst = p.list[dstName]
	if selection.core and type(src.core) == "table" then
		dst.core = TRB.Functions.Table:DeepCopy(src.core)
	end
	for className, specSel in pairs(selection) do
		if className ~= "core" and type(specSel) == "table" and type(src[className]) == "table" then
			dst[className] = dst[className] or {}
			for specName, include in pairs(specSel) do
				if include and type(src[className][specName]) == "table" then
					dst[className][specName] = TRB.Functions.Table:DeepCopy(src[className][specName])
				end
			end
		end
	end
	self:InvalidateCache()
	return true
end

-- Event plumbing. The profiles lifecycle is driven by PLAYER_LOGIN (init, after
-- every class module's ADDON_LOADED has populated TRB.Data.settings via the
-- legacy merge) and PLAYER_LOGOUT (flush, before class modules' existing
-- `TwintopInsanityBarSettings = TRB.Data.settings` assignment rides the
-- profiles subtree out to the saved-variables file).
local profilesFrame = CreateFrame("Frame")
profilesFrame:RegisterEvent("PLAYER_LOGIN")
profilesFrame:RegisterEvent("PLAYER_LOGOUT")
profilesFrame:SetScript("OnEvent", function(_, event)
	local Profiles = TRB.Functions.Profiles
	if event == "PLAYER_LOGIN" then
		if TRB.Data == nil or TRB.Data.settings == nil then
			return
		end
		Profiles:EnsureStructure()
		Profiles:SeedFromLegacy()
		Profiles:PortForwardAll()
		Profiles:ApplyToRuntime()
	elseif event == "PLAYER_LOGOUT" then
		if TRB.Data == nil or TRB.Data.settings == nil then
			return
		end
		if not Profiles.suppressLogoutFlush then
			Profiles:FlushActive()
		end
	end
end)
