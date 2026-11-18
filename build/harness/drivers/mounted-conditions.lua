-- Checks the Mounted visibility conditions against the states the Live probe read, and the Steady Flight split: each old
-- tick becomes a pair that evaluates exactly as before, once per save and in old imports, with presets still linked.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
end

function hooks.afterLoad(ctx)
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local G = desktop
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
	end
	local function try(label, fn)
		local ok, result = xpcall(fn, function(e) return debug.traceback(tostring(e), 2) end)
		if not ok then
			errors = errors + 1
			print("DRIVER ERROR " .. label .. "\n    " .. tostring(result):gsub("\n", "\n    "))
			return nil
		end
		return result
	end

	local Table = TRB.Functions.Table
	local BarVisibility = TRB.Functions.BarVisibility
	local Context = TRB.Classes.BarVisibilityContext
	local character = TRB.Data.character
	local canSkyride = TRB.Flavor.skyriding ~= nil
	local canFly = TRB.Flavor.IsFlyingMountActive ~= nil

	-- The game state the stubs report. Live's mount 1 is Ashes of Belo'ren (type 424) and mount 2 a ground mount (type
	-- 230); TBC reads the same two as Swift Blue Gryphon's and Brown Horse's auras.
	local MOUNTS = { flying = { id = 1, mountType = 424, spellId = 32242 }, ground = { id = 2, mountType = 230, spellId = 458 } }
	local state = {}
	local flyableReads = 0
	G.IsMounted = function() return state.mounted == true end
	G.IsFlying = function() return state.flying == true end
	G.IsFlyableArea = function()
		flyableReads = flyableReads + 1
		return state.flyable == true
	end
	if canSkyride then
		G.C_PlayerInfo.GetGlidingInfo = function() return state.gliding == true, state.canGlide == true, 0 end
	end
	G.C_MountJournal.GetMountIDs = function() return { MOUNTS.flying.id, MOUNTS.ground.id } end
	G.C_MountJournal.GetMountInfoByID = function(id)
		local mount = state.mounted and MOUNTS[state.mount or ""] or nil
		return "Mount", 0, 0, mount ~= nil and mount.id == id
	end
	G.C_MountJournal.GetMountInfoExtraByID = function(id)
		return nil, "", "", false, id == MOUNTS.flying.id and MOUNTS.flying.mountType or MOUNTS.ground.mountType
	end
	G.C_UnitAuras.GetBuffDataByIndex = function(unit, index)
		local mount = state.mounted and MOUNTS[state.mount or ""] or nil
		if unit == "player" and index == 1 and mount ~= nil then
			return { spellId = mount.spellId }
		end
		return nil
	end
	local mountReads = 0
	local readFlyingMount = TRB.Flavor.IsFlyingMountActive
	if readFlyingMount ~= nil then
		TRB.Flavor.IsFlyingMountActive = function()
			mountReads = mountReads + 1
			return readFlyingMount()
		end
	end

	---Mounts up (or not) in the given state, through the same path a login or loading screen takes, and reads the context.
	---@param s table
	---@return TRB.Classes.BarVisibilityContext
	local function Apply(s)
		state = s
		-- Off first, so the read sees a fresh mount, as a mount event would.
		character.isMounted = false
		TRB.Functions.Character:CheckCharacter()
		return Context:FillFromGameState(Context:New({}), false)
	end

	-- Predicates across the probe's states. Fields: Mounted (Any), Ground Mount, Skyriding, Skyriding (Flying Only), Steady
	-- Flight, and Steady Flight (Flying Only).
	local FIELDS = { "isMountedAny", "isMountedGround", "isSkyriding", "isSkyridingFlying", "isSteadyFlight", "isSteadyFlightFlying" }
	local function S(name, mounted, canGlide, flying, gliding, flyable, mount, expected)
		return { name = name, mounted = mounted, canGlide = canGlide, flying = flying, gliding = gliding, flyable = flyable, mount = mount, expected = expected }
	end
	local states
	if canSkyride then
		states = {
			S("skyriding style, flying mount, ground", true, true, false, false, true, "flying", { true, true, true, false, false, false }),
			S("skyriding style, flying mount, air", true, true, true, true, true, "flying", { true, false, true, true, false, false }),
			S("steady style, flying mount, ground", true, false, false, false, true, "flying", { true, true, false, false, true, false }),
			S("steady style, flying mount, air", true, false, true, false, true, "flying", { true, false, false, false, true, true }),
			S("steady style, ground mount", true, false, false, false, true, "ground", { true, true, false, false, false, false }),
			S("skyriding style, ground mount", true, false, false, false, true, "ground", { true, true, false, false, false, false }),
			S("no-fly subzone, ground mount", true, false, false, false, false, "ground", { true, true, false, false, false, false }),
			S("no-fly subzone, flying mount, steady style", true, false, false, false, false, "flying", { true, true, false, false, false, false }),
			S("not mounted", false, false, false, false, true, nil, { false, false, false, false, false, false }),
		}
	elseif canFly then
		states = {
			S("Outland, flying mount, ground", true, false, false, false, true, "flying", { true, true, false, false, true, false }),
			S("Outland, flying mount, air", true, false, true, false, true, "flying", { true, false, false, false, true, true }),
			S("Outland, ground mount", true, false, false, false, true, "ground", { true, true, false, false, false, false }),
			S("Azeroth, flying mount", true, false, false, false, false, "flying", { true, true, false, false, false, false }),
			S("not mounted", false, false, false, false, true, nil, { false, false, false, false, false, false }),
		}
	else
		states = {
			S("ground mount", true, false, false, false, false, "ground", { true, true, false, false, false, false }),
			S("mounted and flying", true, false, true, false, true, "flying", { true, false, false, false, false, true }),
			S("not mounted", false, false, false, false, false, nil, { false, false, false, false, false, false }),
		}
	end
	for _, s in ipairs(states) do
		local context = try("FillFromGameState " .. s.name, function() return Apply(s) end)
		if context ~= nil then
			local wrong = {}
			for i, field in ipairs(FIELDS) do
				if context[field] ~= s.expected[i] then
					wrong[#wrong + 1] = field .. "=" .. tostring(context[field])
				end
			end
			check(s.name .. ": the six Mounted conditions read as expected" .. (#wrong > 0 and (" (" .. table.concat(wrong, ", ") .. ")") or ""), #wrong == 0)
			check(s.name .. ": the Hide list's Steady Flight matches the Show list's", context.isMountedFlying == context.isSteadyFlight)
		end
	end

	if not canFly then
		flyableReads = 0
		try("FillFromGameState without flying", function() return Apply(S("flying", true, false, true, false, true, "flying", {})) end)
		check("a flavor without flying never reads a flying mount", character.isFlyingMount == false)
		check("and never calls IsFlyableArea", flyableReads == 0)
		return errors
	end

	-- The mount list is scanned when the mount changes, never while it stays the same.
	Apply(S("flying", true, false, false, false, true, "flying", {}))
	local readsAfterMount = mountReads
	try("CheckCharacter while mounted", function()
		TRB.Functions.Character:CheckCharacter()
		TRB.Functions.Character:CheckCharacter()
	end)
	check("the flying mount is read once per mount, not on every character check", readsAfterMount > 0 and mountReads == readsAfterMount)
	state = {}
	TRB.Functions.Character:CheckCharacter()
	check("dismounting clears the flying mount without a read", character.isFlyingMount == false and mountReads == readsAfterMount)

	-- The split is exactly equivalent: before it, both Steady Flight conditions meant mounted and flying.
	local Settings = TRB.Functions.Settings
	local SHOW_KEYS = { "isSteadyFlight", "isSteadyFlightFlying", "isSkyridingFlying", "isSkyriding", "isMountedGround" }
	local HIDE_KEYS = { "isMountedFlying", "isSteadyFlightFlying", "isSkyridingFlying", "isSteadyFlight", "isMountedGround" }
	local function Subsets(keys)
		local all = {}
		for mask = 0, 2 ^ #keys - 1 do
			local subset = {}
			for i, key in ipairs(keys) do
				if math.floor(mask / 2 ^ (i - 1)) % 2 == 1 then
					subset[key] = true
				end
			end
			all[#all + 1] = subset
		end
		return all
	end
	local showSets, hideSets = Subsets(SHOW_KEYS), Subsets(HIDE_KEYS)
	local splitShow, splitHide = {}, {}
	for i = 1, #showSets do
		local wrapper = { core = { displayBar = { primary = { conditions = Table:DeepCopy(showSets[i]), hideConditions = Table:DeepCopy(hideSets[i]) } } } }
		Settings:SplitSteadyFlightTicks(wrapper)
		splitShow[i] = wrapper.core.displayBar.primary.conditions
		splitHide[i] = wrapper.core.displayBar.primary.hideConditions
	end
	local mismatches, compared = 0, 0
	local glideValues = canSkyride and { false, true } or { false }
	for _, mounted in ipairs({ false, true }) do
		for _, canGlide in ipairs(glideValues) do
			for _, flying in ipairs({ false, true }) do
				for _, gliding in ipairs(glideValues) do
					for _, flyable in ipairs({ false, true }) do
						for _, mount in ipairs({ "flying", "ground" }) do
							local newContext = Apply(S("", mounted, canGlide, flying, gliding, flyable, mount, {}))
							local oldContext = Table:DeepCopy(newContext)
							setmetatable(oldContext, Context)
							local old = newContext.isMountedAny and flying
							oldContext.isSteadyFlight, oldContext.isSteadyFlightFlying, oldContext.isMountedFlying = old, old, old
							for i = 1, #showSets do
								compared = compared + 1
								if BarVisibility:MatchesShowConditions(oldContext, showSets[i]) ~= BarVisibility:MatchesShowConditions(newContext, splitShow[i]) then
									mismatches = mismatches + 1
								end
								local oldHidden = BarVisibility:ShouldForceHideBar(oldContext, { visibilitySettings = { hideConditions = hideSets[i] } })
								local newHidden = BarVisibility:ShouldForceHideBar(newContext, { visibilitySettings = { hideConditions = splitHide[i] } })
								if oldHidden ~= newHidden then
									mismatches = mismatches + 1
								end
							end
						end
					end
				end
			end
		end
	end
	check(string.format("every split Show and Hide tick set evaluates as before in every state (%d compared)", compared), mismatches == 0)
	local tbcSplit = { core = { displayBar = { primary = { conditions = { isSteadyFlight = true } } } } }
	Settings:SplitSteadyFlightTicks(tbcSplit)
	local split = tbcSplit.core.displayBar.primary.conditions
	if canSkyride then
		check("Live splits Steady Flight into both Flying Only conditions", split.isSteadyFlight == false and split.isSkyridingFlying == true and split.isSteadyFlightFlying == true)
	else
		check("TBC splits Steady Flight into Steady Flight (Flying Only) alone", split.isSteadyFlight == false and split.isSkyridingFlying == nil and split.isSteadyFlightFlying == true)
	end

	-- Once per save: an existing save from before the split, with a preset and a stored profile.
	local checks = TRB.Data.settings.manualUpdateChecks
	check("a fresh install starts with the split done", type(checks) == "table" and type(checks.steadyFlightSplit) == "table" and checks.steadyFlightSplit.done == true)
	local saved = Table:DeepCopy(TRB.Data.settings)
	saved.manualUpdateChecks.steadyFlightSplit = nil
	local classEntry = TRB.Data.classRegistryOrder[1]
	for _, entry in ipairs(TRB.Data.classRegistryOrder) do
		if entry.classId == ctx.classId then
			classEntry = entry
		end
	end
	local className, specName = classEntry.className, classEntry.specs[1].specName
	local PRESET = "trb-driver-steady"
	saved.core.visibilityPresets = saved.core.visibilityPresets or {}
	-- Complete hide conditions, as saves hold them, so the old backfill steps leave the bars and the preset equal.
	local presetHide = Settings:LoadDefaultBarVisibilityHideConditions()
	presetHide.isMountedFlying = true
	saved.core.visibilityPresets[PRESET] = {
		guid = PRESET, name = "Driver", profileKey = "standard", alwaysShow = false, smooth = false,
		activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0,
		conditions = { isSteadyFlight = true, inCombat = true }, hideConditions = presetHide,
	}
	local function OldEntry(presetId)
		local entry = { presetId = presetId }
		BarVisibility:CopyPresetFields(saved.core.visibilityPresets[PRESET], entry)
		return entry
	end
	saved[className] = saved[className] or {}
	saved[className][specName] = saved[className][specName] or {}
	local piece = saved[className][specName]
	piece.displayBar = piece.displayBar or {}
	piece.displayBar.primary = OldEntry(PRESET)
	piece.displayBar.driverUnlinked = { conditions = { isSteadyFlightFlying = true }, hideConditions = {} }
	saved.core.displayBar = saved.core.displayBar or {}
	saved.core.displayBar.driverGlobal = { conditions = {}, hideConditions = { isSteadyFlightFlying = true } }
	if canSkyride then
		saved.core.displayBar.skyridingSpeed = saved.core.displayBar.skyridingSpeed or {}
		saved.core.displayBar.skyridingSpeed.conditions = { isSteadyFlight = true }
	end
	saved.profiles = saved.profiles or {}
	saved.profiles.list = saved.profiles.list or {}
	saved.profiles.list.DriverStored = { [className] = { [specName] = { displayBar = { primary = { conditions = { isSteadyFlight = true }, hideConditions = {} } } } } }

	local live = TRB.Flavor.GetSavedVariables()
	TRB.Flavor.SetSavedVariables(saved)
	try("PortForwardSettings on a save from before the split", function() TRB.Flavor.PortForwardSettings() end)
	local preset = saved.core.visibilityPresets[PRESET]
	local pairKeys = canSkyride and { "isSkyridingFlying", "isSteadyFlightFlying" } or { "isSteadyFlightFlying" }
	local function HasPair(conditions, oldKey)
		if type(conditions) ~= "table" or conditions[oldKey] == true then
			return false
		end
		for _, key in ipairs(pairKeys) do
			if conditions[key] ~= true then
				return false
			end
		end
		return canSkyride or conditions.isSkyridingFlying ~= true
	end
	check("the save is marked split", type(saved.manualUpdateChecks.steadyFlightSplit) == "table" and saved.manualUpdateChecks.steadyFlightSplit.done == true)
	check("a preset's Show and Hide ticks are split", HasPair(preset.conditions, "isSteadyFlight") and preset.conditions.inCombat == true and HasPair(preset.hideConditions, "isMountedFlying"))
	check("a specialization's bar is split", HasPair(piece.displayBar.primary.conditions, "isSteadyFlight") and HasPair(piece.displayBar.primary.hideConditions, "isMountedFlying"))
	check("a Flying Only tick gains its pair", HasPair(piece.displayBar.driverUnlinked.conditions, "isSteadyFlight"))
	check("Global Options' bars are split", HasPair(saved.core.displayBar.driverGlobal.hideConditions, "isMountedFlying"))
	check("a stored profile is split", HasPair(saved.profiles.list.DriverStored[className][specName].displayBar.primary.conditions, "isSteadyFlight"))
	check("a bar linked to a preset stays linked", piece.displayBar.primary.presetId == PRESET)
	check("and still matches it exactly", BarVisibility:GetPresetSignature(piece.displayBar.primary, "standard") == BarVisibility:GetPresetSignature(preset, "standard"))
	if canSkyride then
		local skyriding = saved.core.displayBar.skyridingSpeed.conditions
		check("the Skyriding bars, which read their own Skyriding, are left alone", skyriding.isSteadyFlight == true and skyriding.isSkyridingFlying ~= true)
	end

	-- A tick made after the split keeps its meaning at the next login.
	piece.displayBar.driverUnlinked.conditions = { isSteadyFlight = true }
	piece.displayBar.driverUnlinked.hideConditions = { isSteadyFlightFlying = true }
	try("PortForwardSettings at the next login", function() TRB.Flavor.PortForwardSettings() end)
	local after = piece.displayBar.driverUnlinked
	check("the split runs once: a new Steady Flight tick stays as made", after.conditions.isSteadyFlight == true and after.conditions.isSteadyFlightFlying ~= true)
	check("and so does a new Steady Flight (Flying Only) tick", after.hideConditions.isSteadyFlightFlying == true and after.hideConditions.isSkyridingFlying ~= true)
	local profile = { [className] = { [specName] = Table:DeepCopy(piece) } }
	try("PortForwardSettings on a stored profile", function() TRB.Flavor.PortForwardSettings(profile) end)
	local stored = profile[className][specName].displayBar.driverUnlinked
	check("a stored profile's port-forward never splits again", stored.conditions.isSteadyFlight == true and stored.conditions.isSteadyFlightFlying ~= true)
	TRB.Flavor.SetSavedVariables(live)

	-- Imports: an export from before the split has its ticks split; a current one keeps them.
	local store = {}
	G.C_EncodingUtil = {
		SerializeJSON = function(value)
			store[#store + 1] = Table:DeepCopy(value)
			return tostring(#store)
		end,
		DeserializeJSON = function(text) return Table:DeepCopy(store[tonumber(text)]) end,
		CompressString = function(text) return text end,
		DecompressString = function(text) return text end,
		EncodeBase64 = function(text) return text end,
		DecodeBase64 = function(text) return text end,
	}
	if rawget(G.Enum, "CompressionMethod") == nil then
		rawset(G.Enum, "CompressionMethod", { Deflate = 0 })
	end
	local function Encode(configuration)
		store[#store + 1] = configuration
		return "!TRBv2!" .. tostring(#store)
	end
	local oldPiece = { displayBar = { primary = { conditions = { isSteadyFlight = true }, hideConditions = { isMountedFlying = true } } } }
	local oldExport = { flavor = TRB.Flavor.id, profiles = { list = { Imported = { [className] = { [specName] = oldPiece } } } } }
	local ok, decoded = TRB.Functions.IO:DecodeExportString(Encode(oldExport))
	local importedPrimary = ok and decoded.profiles.list.Imported[className][specName].displayBar.primary or nil
	check("an export from before the split is split on import", importedPrimary ~= nil and HasPair(importedPrimary.conditions, "isSteadyFlight") and HasPair(importedPrimary.hideConditions, "isMountedFlying"))
	local newExport = { flavor = TRB.Flavor.id, visibilityRevision = 1, profiles = { list = { Imported = { [className] = { [specName] = Table:DeepCopy(oldPiece) } } } } }
	ok, decoded = TRB.Functions.IO:DecodeExportString(Encode(newExport))
	importedPrimary = ok and decoded.profiles.list.Imported[className][specName].displayBar.primary or nil
	check("a current export keeps its ticks", importedPrimary ~= nil and importedPrimary.conditions.isSteadyFlight == true and importedPrimary.conditions.isSteadyFlightFlying ~= true)
	check("and its revision never reaches the settings", ok and decoded.visibilityRevision == nil)
	local coreName = TRB.Functions.Profiles:ResolveCoreProfileName()
	local exported = try("ExportCoreProfile", function() return TRB.Functions.IO:ExportCoreProfile(coreName) end)
	check("exports carry the revision", exported ~= nil and store[#store] ~= nil and store[#store].visibilityRevision == 1)

	return errors
end

return hooks
