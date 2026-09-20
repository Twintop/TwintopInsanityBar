local _, TRB = ...
TRB.Classes = TRB.Classes or {}

-- Spec descriptors: the capabilities a specialization declares to Core.
--
-- Core never names a class or a spec. Where shared code has to behave differently for one spec
-- (a stepped secondary bar, a talent-gated bar, settings borrowed from a sibling spec for Druid
-- forms, an extra field to export), the spec's class module declares that trait here and Core
-- reads the trait. Descriptors are declared in the flavor's Classes stage (they load before Core's
-- Functions, so declaring code must not call into TRB.Functions at load time) and attached to the
-- spec's registry entry as `descriptor`.

---@class TRB.Classes.SpecDescriptor.Secondary
---@field minMaxMode "discrete"|"stepped"|"resource"|nil # Node ranges: discrete = each node 0..1 (default); stepped = node i spans i-1..i and all nodes get the same raw (possibly secret) value; resource = node 1 spans 0..maxResource2Value (a true bar), other nodes 0..1
---@field sharedFrom string? # compositeKey of the spec whose comboPoints dimensions, textures and colors this spec's secondary bar borrows (Druid non-Feral specs borrow Feral's)
---@field IsSharedActive fun(activeSpecSettings: table?): boolean # With sharedFrom: whether the borrowing applies right now (reads the ACTIVE spec's saved settings)
---@field exportable boolean? # Always include the secondary bar in exports even when the spec's bar group config declares no secondary
---@field thresholdDecimals integer? # Decimal places custom thresholds may target on the secondary bar (fragment-scaled resources)

---@class TRB.Classes.SpecDescriptor.Forms
---@field IsBarEligibleForLayout fun(barKey: string, activeSpecSettings: table?): boolean? # Whether a form-dependent bar (secondary, mana, ...) is eligible to show given the current shapeshift form; nil = no opinion
---@field exportDisplayBarKeys string[]? # Spec displayBar flags that travel with bar display exports (e.g. enableFormSwitching)

---@class TRB.Classes.SpecDescriptor.AnchorFrame
---@field label string # Localized name shown in the bar text "relative to" dropdown
---@field frame string # Frame key the entry resolves to (e.g. "ComboPoint_3", "EnrageBar")

---@class TRB.Classes.SpecDescriptor
---@field manaBar boolean? # The spec shows a mana bar / mana bar text, so mana precision options apply
---@field secondary TRB.Classes.SpecDescriptor.Secondary?
---@field forms TRB.Classes.SpecDescriptor.Forms? # Declared by every spec of a class whose display follows shapeshift forms
---@field talentGatedBars table<string, string>? # barKey -> key in spellsData.spells whose talent must be active for the bar to show
---@field barTextAnchorFrames TRB.Classes.SpecDescriptor.AnchorFrame[]? # Extra "relative to" anchor frames offered by the bar text editor (between the primary bar and the health bar entries)
---@field exportExtras string[]? # Extra top-level spec settings keys exported with the Font & Text section
---@field customBars string[]? # Custom bar keys always included in exports, in addition to the bar group config's
---@field empowerCastbar boolean? # The spec casts empowered spells, so the castbar options show empower level colors
---@field secondaryTransitionOnFullAuraUpdate string? # snapshotData.attributes key stamped with GetTime() on a full UNIT_AURA update (a spec whose secondary resource resets on such updates)
---@field slashCommands table<string, fun(subcommand: string?)>? # Extra /trb sub-commands the spec module handles
---@field useGlobalDefaults table<string, boolean>? # "Use global settings" toggles seeded differently from the shipped defaults (key -> value), for a spec whose layout the global options cannot describe

TRB.Classes.SpecDescriptor = {}

---Declares (or extends) the descriptor of one spec. Later declarations merge over earlier ones so a
---class-wide trait (e.g. forms) can be declared once for every spec and refined per spec.
---@param compositeKey string # e.g. "priest_shadow"
---@param descriptor TRB.Classes.SpecDescriptor
---@return TRB.Classes.SpecDescriptor
function TRB.Classes.SpecDescriptor:Declare(compositeKey, descriptor)
	local entry = TRB.Data.specRegistry[compositeKey]
	assert(entry ~= nil, "TwintopInsanityBar: SpecDescriptor:Declare for unknown spec '" .. tostring(compositeKey) .. "'")
	entry.descriptor = entry.descriptor or {}
	for key, value in pairs(descriptor) do
		entry.descriptor[key] = value
	end
	return entry.descriptor
end

---Declares a trait for every spec of a class.
---@param className string # all-lowercase class key, e.g. "druid"
---@param descriptor TRB.Classes.SpecDescriptor
function TRB.Classes.SpecDescriptor:DeclareForClass(className, descriptor)
	local classEntry = TRB.Data.classRegistry[className]
	assert(classEntry ~= nil, "TwintopInsanityBar: SpecDescriptor:DeclareForClass for unknown class '" .. tostring(className) .. "'")
	for _, specEntry in ipairs(classEntry.specs) do
		self:Declare(specEntry.compositeKey, descriptor)
	end
end

---Descriptor of a spec by ids, or nil when the spec declared none.
---@param classId integer?
---@param specId integer?
---@return TRB.Classes.SpecDescriptor?
function TRB.Classes.SpecDescriptor:Get(classId, specId)
	if classId == nil or specId == nil then
		return nil
	end
	local byClass = TRB.Data.specRegistryByIds[classId]
	local entry = byClass and byClass[specId]
	return entry and entry.descriptor or nil
end

---Descriptor of a spec by composite key, or nil.
---@param compositeKey string?
---@return TRB.Classes.SpecDescriptor?
function TRB.Classes.SpecDescriptor:GetByKey(compositeKey)
	local entry = compositeKey and TRB.Data.specRegistry[compositeKey]
	return entry and entry.descriptor or nil
end

---Descriptor of the character's active spec, or nil.
---@return TRB.Classes.SpecDescriptor?
function TRB.Classes.SpecDescriptor:GetActive()
	local character = TRB.Data.character
	if character == nil then
		return nil
	end
	return self:Get(character.classId, character.specId)
end
