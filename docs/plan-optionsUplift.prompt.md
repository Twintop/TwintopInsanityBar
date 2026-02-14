## Plan: Options System Uplift for Cross-Class Access

**TL;DR**: Refactor the options system to use class-qualified composite keys (`className_specName`, all lowercase), implement per-spec lazy loading of options panels, guard all runtime callbacks against non-active spec editing, and decouple options construction from class module guards. This is the prerequisite uplift work — it doesn't yet expose all 40 specs in the UI, but removes every architectural blocker preventing it.

The work divides into 6 sequential phases. Phases 1–3 can be done incrementally (one class at a time). Phases 4–6 are cross-cutting.

---

### Phase 1: Introduce Composite Key Infrastructure

**Goal**: Create a central registry of all class/spec identifiers and a helper to build composite keys, so every subsystem can use the same key format.

**Step 1.1** — Add a spec registry table to Init.lua. Define `TRB.Data.specRegistry` mapping every `classId`/`specId` combo to `{ classId, specId, className, specName, compositeKey }`. This is the single source of truth for all 40 specs. Populate it statically (no WoW API calls needed — the names are already hardcoded in `GetSpecializationName` in Functions/Character.lua).

**Step 1.2** — Add helper functions to Functions/Character.lua:
- `GetCompositeKey(className, specName)` → returns `className .. "_" .. specName` (e.g., `"deathknight_frost"`)
- `GetCompositeKeyFromIds(classId, specId)` → looks up from specRegistry → returns composite key
- `ParseCompositeKey(compositeKey)` → returns `className, specName`

**Step 1.3** — Normalize `CLASS_IDS` and `SPEC_INDICES` in Options/OptionsFrame.lua to use all-lowercase class keys (`"deathknight"` instead of `"deathKnight"`), or replace them with lookups against the new `specRegistry`.

---

### Phase 2: Migrate Keys to Composite Format

**Goal**: Replace every bare `specName` key with a `className_specName` composite key across the 4 keyed subsystems: controls, nav entries, `barConstructedForSpec`, and `specCache`.

**Step 2.1 — Controls table** (13 ClassModules/Options files): Change all reads/writes of `interfaceSettingsFrameContainer.controls.<specName>` to `controls.<className_specName>`. Each file has a pattern like `controls.discipline or {}` / `controls.discipline = controls` — change to `controls.priest_discipline`. Affects every ClassModules/Options/*.lua file (one per class, ~2–4 lines each for the top-level key, plus every interior reference like `interfaceSettingsFrame.controls.arms`). Also update the write-back in each spec constructor.

**Step 2.2 — Nav entries** in Options/OptionsFrame.lua: Change `RegisterSpecPanel(classKey, specKey, ...)` to store `navEntries[compositeKey]` instead of `navEntries[specKey]`. Update `SelectCategory` to accept composite keys. The `parentKey` (class header) already uses `classKey` which is fine. Update `children` arrays to store composite keys. Update all callers of `RegisterSpecPanel` in each ClassModules/Options/*.lua file to pass composite keys.

**Step 2.3 — `barConstructedForSpec`**: Change from bare specName to composite key everywhere it's set (in every ClassModules/*.lua `SwitchSpec` function, ~13 files) and everywhere it's read (in `SwitchSpec` guards, `SelectCategory` calls in Init.lua and Functions/MinimapButton.lua, `specCache` lookups in Functions/Threshold.lua, Functions/Character.lua, etc.).

**Step 2.4 — `specCache` keys**: Currently keyed by bare specName in each ClassModules/*.lua. Change to composite keys. This affects:
- `specCache` table construction at the top of each class module (e.g., Priest.lua `specCache = { priest_discipline = ..., priest_holy = ..., priest_shadow = ... }`)
- The `TRB.Data.specCache` assignment
- Every `specCache[specName]` read, including `FillSpecializationCacheSettings` in Functions/Character.lua which does `TRB.Data.specCache[specName]`
- The `TRB.Data.specCache[TRB.Data.character.specName]` pattern (~50+ occurrences in Options/OptionsUi.lua) — consider adding a helper like `TRB.Functions.Character:GetActiveSpecCache()` to avoid spreading composite key logic everywhere

**Step 2.5 — `TRB.Data.character.specName`**: This should continue to hold the bare specName for gameplay logic. Add a new field `TRB.Data.character.compositeKey` (set alongside `specName` in `CheckCharacter()`) for options/cache lookups. This avoids the need to change all runtime gameplay code.

---

### Phase 3: Decouple Options Construction from Class Modules

**Goal**: Allow any class's options panels to be built without the class module's runtime code being active.

**Step 3.1 — Remove early-return guards from ClassModules/Options/*.lua**: The line 2 guard (e.g., WarriorOptions.lua `if TRB.Data.character.classId ~= 1 then return end`) prevents options functions from being defined for non-active classes. Remove this guard from all 13 ClassModules/Options/ files. The options files only define functions and default settings — they don't execute gameplay logic at load time, so they're safe to load unconditionally.

**Step 3.2 — Move `ConstructOptionsPanel` invocation out of class modules**: Currently, each class module calls `TRB.Options.[Class].ConstructOptionsPanel(specCache)` inside a `C_Timer.After` block (e.g., Priest.lua). Instead, create a **single orchestrator** (e.g., in Options/Options.lua or a new Options/OptionsInit.lua file) that:
  1. Is called once from the active class module's `C_Timer.After` block (or from Init.lua) after all files have loaded
  2. Calls `TRB.Options:ConstructOptionsPanel()` (the global panels — already exists)
  3. Registers **all 13 class headers** and **all 40 spec nav entries** (with nil panels — just labels and composite keys)
  4. Does NOT build any spec panels yet (lazy loading in Phase 4 handles that)

**Step 3.3 — Keep default settings in their existing files**: The per-spec default settings functions (e.g., `FuryLoadDefaultSettings()` in WarriorOptions.lua) stay exactly where they are. Since the early-return guard is removed in Step 3.1, these functions will now be defined and accessible for all characters regardless of class. The existing pattern where `TRB.Options.Warrior.LoadDefaultSettings` is exposed on the namespace is sufficient — no consolidation needed.

**Step 3.4 — Decouple `specCache` creation for options**: For non-active classes, the options panel needs a `specCache` entry with at minimum:
  - `.settings` — reference to `TRB.Data.settings.className.specName` (available after settings load)
  - `.barTextVariables` — needs `FillSpellData` data

  Create a lightweight `TRB.Functions.Character:EnsureSpecCache(compositeKey)` that lazily creates a minimal specCache entry if one doesn't exist. For `barTextVariables`, the `FillSpellData_[Spec]` methods should be relocated to the corresponding ClassModules/Classes/*.lua files (e.g., `FillSpellData_Fury` moves to WarriorClasses.lua) so they can be called without the class module's runtime guard. Spell info (`C_Spell.GetSpellInfo`) works cross-class — the WoW API doesn't restrict it to the current class.

---

### Phase 4: Implement Per-Spec Lazy Loading

**Goal**: Build each spec's options panel only when the user navigates to it.

**Step 4.1 — Add builder/factory support to OptionsFrame nav entries**: Extend the `NavEntry` type in Options/OptionsFrame.lua with an optional `builder` field (a function). Modify `SelectCategory` so that if `entry.panel == nil` and `entry.builder ~= nil`, it calls `entry.builder()` first, which populates `entry.panel`.

**Step 4.2 — Register all specs with builders, not panels**: In the orchestrator from Step 3.2, register each spec via something like:
```lua
RegisterSpecPanel(classKey, compositeKey, specLabel, nil, function()
    -- build panel on demand
end)
```
The builder function calls the existing per-spec constructor (e.g., `DisciplineConstructOptionsPanel(cache)`), ensures `specCache` exists (Step 3.4), and assigns the resulting panel to `navEntries[compositeKey].panel`.

**Step 4.3 — All specs lazy-loaded**: No specs are eagerly loaded at startup, including the current character's class. Every spec panel is built on first navigation click. This keeps startup fast and uniform.

**Step 4.4 — Handle `RefreshNav` for unbuilt panels**: `RefreshNav` creates nav buttons lazily (only if `button == nil`). This already works — buttons exist in the nav even when panels don't. No changes needed for nav rendering.

---

### Phase 5: Guard Callbacks Against Non-Active Spec Editing

**Goal**: Ensure editing a non-active spec's settings doesn't crash or corrupt the active bar.

**Step 5.1 — Settings writes are already safe**: Options constructors close over a `spec` reference to `TRB.Data.settings.className.specName` at construction time. These writes go to the correct settings table regardless of which spec is active. No changes needed.

**Step 5.2 — Guard live-preview callbacks in OptionsUi.lua**: The ~50+ occurrences of `TRB.Data.specCache[TRB.Data.character.specName].settings` and `TRB.Functions.Class:TriggerResourceBarUpdates()` in Options/OptionsUi.lua callbacks need a guard. Add a helper like `TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId)` that compares the panel's classId/specId against `TRB.Data.character.classId`/`TRB.Data.character.specId`. Only call `ApplyBarGroupsLayout`, `ApplyBarGroupsAppearance`, and `TriggerResourceBarUpdates` if editing the active spec.

**Step 5.3 — Guard `SetPositionXY` in Functions/Bar.lua**: This writes to `controls[TRB.Data.character.specName]` — must be updated to use the composite key. Also add nil-checks since the active spec's panel may not be built yet (lazy loading). Pattern: `if controls[compositeKey] and controls[compositeKey].horizontal then ...`.

**Step 5.4 — Guard MinimapButton controls check**: Functions/MinimapButton.lua checks `controls.global` — this key is fine (no collision), but add nil-safety for the case where global panel hasn't been built yet.

**Step 5.5 — Guard per-class options callbacks**: Several ClassModules/Options files have callbacks that call `TRB.Functions.Class:TriggerResourceBarUpdates()` directly (Druid, Shaman, Monk options files). These need the same `IsEditingActiveSpec` guard from Step 5.2.

---

### Phase 6: Cleanup and Consistency

**Step 6.1 — Update `/trb` slash command**: Init.lua calls `SelectCategory(TRB.Data.barConstructedForSpec)` — already works with composite keys after Phase 2. Verify `/trb move x y` works when the active spec's panel isn't built yet.

**Step 6.2 — Update Import/Export panel**: Options/Options.lua already uses numeric classId/specId for export. The `ConstructImportExportRow` `namePrefix` uses UPPERCASE class names — keep this for frame naming (it's not a key, just a UI identifier). No functional changes needed, but verify composite keys don't break anything.

**Step 6.3 — Update `FillSpecializationCacheSettings`**: Functions/Character.lua does `TRB.Data.specCache[specName]`. Change to accept/use composite keys. Since this is called from options callbacks (e.g., "Use Global" toggle), it must work for both active and non-active specs.

**Step 6.4 — Audit `TRB.Data.character.specName` usage**: Grep for all `character.specName` usage. Gameplay/runtime code should continue using bare `specName`. Options/cache code should use `character.compositeKey` or the composite key derivation helper.

---

### Additional Blockers Identified

1. **`allClassSpecs` table in Options/OptionsUi.lua**: This is a local table mapping class names to spec data, used for iterating over all specs in some generic builders. Must be verified/updated for composite key compatibility.

2. **ShamanOptions Enhancement constructor** reads `TRB.Data.character.maxResource2` at construction time. This will be wrong when building Enhancement Shaman's panel while on a different class. To be handled later — noted as a known issue.

3. **`TRB.Details.addonCategory.specs[specKey]` compat shim** in Options/OptionsFrame.lua: Must be updated to use composite keys.

4. **.toc file**: No changes needed — ClassModules/Options/*.lua files will still be loaded statically, just without the early-return guard. However, if a future phase adds truly dynamic loading (LoadAddOn), the .toc would need splitting.

---

### Verification

- **Post Phase 1**: All helpers produce correct composite keys. `specRegistry` contains all 40 entries (plus global).
- **Post Phase 2**: Existing single-class behavior works identically. Nav, controls, specCache, barConstructedForSpec all use composite keys. No shared-name collisions in any table.
- **Post Phase 3**: ClassModules/Options/*.lua files define their functions for ALL characters. Options orchestrator registers all 13 class headers. Default settings functions remain in their original files and are accessible cross-class.
- **Post Phase 4**: Navigating to any spec builds its panel on first click. No panels are pre-built at startup. No errors when clicking through all specs.
- **Post Phase 5**: Editing a non-active spec's settings saves correctly but doesn't trigger bar updates. `/trb move` doesn't crash when panel isn't built.
- **Post Phase 6**: Full playthrough: log in, open options, navigate every class/spec, change settings, `/reload`, verify settings persisted.

### Decisions

- **Composite key format**: `className_specName`, all lowercase (e.g., `"deathknight_frost"`) — underscore separator chosen over dot to avoid confusion with Lua table path syntax
- **Live preview**: Skip bar updates for non-active specs — simplest and safest approach
- **Lazy granularity**: Per-spec — each of the 40 panels is built independently on first navigation, including the current character's class
- **Casing normalization**: All lowercase to match existing `settings` and `character.className` patterns; `CLASS_IDS`/`SPEC_INDICES` in OptionsFrame.lua will be updated to match
- **`character.specName` preserved**: Bare specName stays for runtime gameplay code; new `character.compositeKey` added for options/cache lookups — minimizes blast radius in class module runtime code
- **Default settings stay in place**: Per-spec functions like `FuryLoadDefaultSettings()` remain in their existing ClassModules/Options/*.lua files; removing the class guard makes them accessible cross-class
- **FillSpellData relocation**: `FillSpellData_[Spec]` methods move to their corresponding ClassModules/Classes/*.lua files (e.g., WarriorClasses.lua) to be available without the class module runtime guard
- **Enhancement maxResource2**: Known issue — reads `TRB.Data.character.maxResource2` at panel construction time, will be wrong for non-Shaman characters. To be handled separately later.
