local _, TRB = ...

TRB.Functions = TRB.Functions or {}

---@class TRB.Functions.Profiles
TRB.Functions.Profiles = {}

-- The hard-coded name of the profile created on first-load migration.
TRB.Functions.Profiles.DEFAULT_NAME = "Default"

-- Per-profile schema version. Bumped by future migrations when
-- PortForwardCoreSettings / PortForwardSpecSettings semantics change.
TRB.Functions.Profiles.CURRENT_VERSION = 1

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
---then augments it with the **current character's class** data only. Other
---classes' data will be merged in when those characters log in for the first
---time after this release ships.
---
---Also wires profiles.default.core = "Default" (if unset) and
---profiles.default[currentClass][spec] = "Default" for the current class's
---specs (if unset), and ensures profiles.character[key] exists.
---
---Idempotent: safe to call on every login.
function TRB.Functions.Profiles:SeedFromLegacy()
	self:EnsureStructure()
	local p = TRB.Data.settings.profiles
	local className = self:GetCurrentClassName()

	-- Create the Default profile if it doesn't exist.
	if p.list[self.DEFAULT_NAME] == nil then
		p.list[self.DEFAULT_NAME] = {
			__version = self.CURRENT_VERSION,
		}
	end
	---@type table<string, any>
	local profile = p.list[self.DEFAULT_NAME]

	-- Copy `core` in once. `core` is class-agnostic so seeding from the first
	-- character to log in is fine; later characters will see the profile already
	-- has it and skip.
	if profile.core == nil and TRB.Data.settings.core ~= nil then
		profile.core = TRB.Functions.Table:DeepCopy(TRB.Data.settings.core)
	end

	-- Seed the current class's data if the profile doesn't already have it.
	-- We don't touch other classes because TRB.Data.settings[otherClass] is
	-- just empty stubs on this character — there's nothing meaningful to copy.
	if className ~= nil and profile[className] == nil then
		local classPiece = TRB.Data.settings[className]
		if type(classPiece) == "table" then
			profile[className] = TRB.Functions.Table:DeepCopy(classPiece)
		end
	end

	-- Wire profiles.default.core if unset.
	if p.default.core == nil then
		p.default.core = self.DEFAULT_NAME
	end

	-- Wire profiles.default[currentClass][spec] for the current class only.
	-- Other classes will populate themselves on their own logins. Existing
	-- entries are preserved so admin / future UI changes aren't stomped.
	if className ~= nil then
		p.default[className] = p.default[className] or {}
		for _, specName in ipairs(self:GetSpecsForClass(className)) do
			if p.default[className][specName] == nil then
				p.default[className][specName] = self.DEFAULT_NAME
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

---Runs port-forward migrations against every stored profile, guarded by
---per-profile __version. Each profile is shaped like a top-level settings
---table (optional `core` + class/spec keys), so we call PortForwardSettings
---against the profile table directly and let the full migration pipeline
---run against it.
function TRB.Functions.Profiles:PortForwardAll()
	self:EnsureStructure()
	local Settings = TRB.Functions.Settings
	if Settings == nil or Settings.PortForwardSettings == nil then
		return
	end
	self:IterateAll(function(_, profile)
		local version = profile.__version or 0
		if version >= self.CURRENT_VERSION then
			return
		end
		Settings:PortForwardSettings(profile)
		profile.__version = self.CURRENT_VERSION
	end)
end

---Drops the resolved profile pieces in place over `TRB.Data.settings.core` and
---`TRB.Data.settings[currentClass][spec]`, preserving the identity of those
---tables (and every nested sub-table that already exists). Other code may have
---captured references into these tables before this point — most notably
---`FillSpecializationCacheSettings` does `specCache.settings.bars = spec.bars`
---and `colors = { bar = spec.colors.bar, bars = spec.colors.bars, ... }`, and
---various bar-construction paths cache references to leaf tables. Replacing
---the top-level reference would orphan all of those, which is exactly how the
---Holy Priest Lightweaver bar broke.
---
---Only the current character's class is touched — other classes' top-level
---settings entries are empty stubs on this character and irrelevant.
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

	local className = self:GetCurrentClassName()
	if className == nil then
		return
	end
	local classPiece = TRB.Data.settings[className]
	if type(classPiece) ~= "table" then
		return
	end
	for _, specName in ipairs(self:GetSpecsForClass(className)) do
		if type(classPiece[specName]) == "table" then
			local specPiece = self:GetResolvedSpecPiece(className, specName)
			if specPiece ~= nil then
				TRB.Functions.Table:DeepMergeInto(classPiece[specName], specPiece)
			end
		end
	end
end

---Writes the live TRB.Data.settings.core and TRB.Data.settings[currentClass][spec]
---back to the resolved active profile pieces for this character. Called at
---PLAYER_LOGOUT so user edits (which today land in TRB.Data.settings) persist
---into the correct profile. Only the current character's class is flushed —
---other classes' entries are empty stubs on this character.
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

	local className = self:GetCurrentClassName()
	if className == nil then
		return
	end
	local classPiece = TRB.Data.settings[className]
	if type(classPiece) ~= "table" then
		return
	end
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
		Profiles:FlushActive()
	end
end)
