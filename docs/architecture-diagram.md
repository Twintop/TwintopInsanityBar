# TwintopInsanityBar Architecture Diagram

This document illustrates the system architecture of the TwintopInsanityBar addon using Shadow Priest as the example specialization.

## System Overview

```mermaid
flowchart TB
    subgraph "🔄 Initialization Flow"
        A["🎮 PLAYER_SPECIALIZATION_CHANGED<br/>or Addon Load"] --> B["SwitchSpec()"]
        B --> C["FillSpellData_Shadow()"]
        B --> D["LoadFromSpecializationCache()"]
        B --> E["Assign RefreshLookupData_Shadow<br/>to TRB.Functions.RefreshLookupData"]
        B --> F["EventRegistration()"]
        F --> G["Character:EventRegistration()"]
        G --> H["📡 Register WoW Events"]
        G --> I["Enable timerFrame OnUpdate"]
        B --> J["ConstructResourceBar()"]
        J --> K["Create Threshold Frames"]
        J --> L["Bar:ConstructBarGroups()"]
    end

    subgraph "� Registries (Load-Time)"
        REG1[("specRegistry<br/>compositeKey → entry<br/>e.g. 'priest_shadow'")]
        REG2[("specRegistryByIds<br/>[classId][specId] → entry")]
        REG3[("barTextVariablesRegistry<br/>compositeKey → FillBarTextVariables()")]
    end

    subgraph "💾 Data Stores"
        DS1[("snapshotData<br/>• attributes.resource<br/>• attributes.mana<br/>• snapshots[spellId].buff<br/>• casting")]
        DS2[("lookup<br/>• $insanity → '|cFF..150|r'<br/>• $vfTime → '|cFF..12.5|r'")]
        DS3[("lookupLogic<br/>• $insanity → 150<br/>• $vfTime → 12.5")]
        DS4[("specCache['priest_shadow']<br/>• talents<br/>• settings<br/>• spellsData<br/>• barTextVariables")]
        DS5[("barGroups<br/>• primary (Insanity)<br/>• mana<br/>• health")]
    end

    subgraph "📡 WoW Event Handlers"
        EV1["UNIT_POWER_UPDATE"] --> UP1["UpdateResourceValues()"]
        UP1 -->|"Write Insanity"| DS1
        EV2["UNIT_AURA"] --> AU1["AuraUpdateEvent()"]
        AU1 -->|"Update buffs/debuffs"| DS1
        EV3["UNIT_SPELLCAST_*"] --> SC1["SpellCastEvent()"]
        SC1 --> SC2["Class:SpellCast()"]
        SC2 -->|"Track casting"| DS1
        EV4["PLAYER_REGEN_*"] --> CB1["Combat State Change"]
        CB1 --> VIS["Bar Visibility Check"]
    end

    subgraph "⏱️ Timer Update Cycle (~0.05s)"
        TF["timerFrame:onUpdate()"] --> TR["TriggerResourceBarUpdates()"]
        TR --> UR["UpdateResourceBar()"]
        UR --> US["UpdateSnapshot_Shadow()"]
        US -->|"Refresh buff timers"| DS1
        UR --> HRB["HideResourceBar()"]
        HRB -->|"Check isTracking"| DS1
        UR --> UBC["Update Bar Value & Thresholds"]
        UR --> URBT["BarText:UpdateResourceBarText()"]
    end

    subgraph "🔁 Lookup Data Refresh"
        URBT --> RLDB["RefreshLookupDataBase()"]
        RLDB -->|"Stats, Health, GCD"| DS2
        RLDB -->|"Raw values"| DS3
        URBT --> RLD["RefreshLookupData_Shadow()"]
        RLD -->|"Read resource, buffs"| DS1
        RLD -->|"Formatted strings"| DS2
        RLD -->|"Raw numbers"| DS3
    end

    subgraph "🎨 Bar Rendering"
        UBC --> BN["BarNode:SetValue()"]
        BN --> RF["ResourceFrame visual update"]
        UBC --> TH["Threshold:AdjustDisplay()"]
        TH --> THF["Threshold line visibility"]
    end

    subgraph "📝 Bar Text Rendering"
        URBT --> PT["Parse Bar Text Strings"]
        PT -->|"Replace $variables"| DS2
        PT -->|"Evaluate conditionals"| DS3
        PT --> TFR["Update textFrames"]
    end

    %% Cross-subgraph connections
    D --> DS4
    DS4 -->|"Load snapshotData"| DS1
    L --> DS5
    HRB -->|"Show/Hide"| DS5
    REG3 -.->|"Populates barTextVariables<br/>via EnsureSpecCache()"| DS4
```

## Options Infrastructure

```mermaid
flowchart TB
    subgraph "🔧 Options Panel Initialization"
        OI["ConstructOptionsPanel()"] --> RACNE["RegisterAllClassSpecNavEntries()"]
        RACNE --> ACS[("ALL_CLASS_SPECS<br/>13 classes × specs<br/>sorted alphabetically")]
        ACS --> RCH["RegisterClassHeader(classKey)"]
        ACS --> RSP["RegisterSpecPanel(classKey,<br/>compositeKey, label, nil, builder)"]
        RSP -->|"panel = nil<br/>(lazy)"| NAV[("navEntries[]<br/>• classKey<br/>• compositeKey<br/>• builder")]
    end

    subgraph "🖱️ First Click (Lazy Load)"
        CLICK["User clicks spec in nav"] --> SC2["SelectCategory(compositeKey)"]
        SC2 --> CHECK{"entry.panel == nil<br/>and entry.builder?"}
        CHECK -->|"Yes"| BUILD["builder() →<br/>BuildClassPanels(classKey)"]
        BUILD --> ENSURE["EnsureSpecCache(compositeKey)"]
        ENSURE --> ENSSET["EnsureSpecSettings(className)"]
        ENSSET -->|"Load defaults if needed"| SETS[("TRB.Data.settings")]
        ENSURE --> NEWSC["SpecCache:New()"]
        ENSURE -->|"Invoke"| REG3B[("barTextVariablesRegistry<br/>[compositeKey]()")]
        REG3B --> BTV["Populate barTextVariables"]
        BUILD --> PANEL["Construct options panel"]
        CHECK -->|"No (cached)"| SHOW["Show existing panel"]
    end

    subgraph "🛡️ Live Preview Guards"
        CALLBACK["Options panel callback"] --> IEAS{"IsEditingActiveSpec(classId, specId)?"}
        IEAS -->|"Yes"| UPDATE["TriggerResourceBarUpdates()<br/>ApplyBarGroupsLayout()<br/>etc."]
        IEAS -->|"No"| SKIP["Save setting only,<br/>skip bar update"]
    end
```

## Bar Text Variables Provenance

```mermaid
flowchart TB
    subgraph "📋 Registration (Load-Time)"
        CLS["ClassModules/Classes/*Classes.lua"] --> FBV["FillBarTextVariables()"]
        FBV --> REG["barTextVariablesRegistry[compositeKey]<br/>= FillBarTextVariables"]
    end

    subgraph "🔧 FillBarTextVariables() Implementation"
        FBV2["FillBarTextVariables(specCacheEntry)"] --> GCI["GetCommonIcons(additionalIcons)"]
        FBV2 --> GCV["GetCommonValues(additionalValues)"]
        GCI --> ICONS["~3 base icons + spec-specific"]
        GCV --> VALUES["~30 base values + spec-specific"]
        ICONS --> STORE["specCacheEntry.barTextVariables.icons"]
        VALUES --> STORE2["specCacheEntry.barTextVariables.values"]
    end

    subgraph "📌 Invocation Points"
        INV1["SwitchSpec → FillSpellData_[Spec]()"] -->|"Active spec"| FBV2
        INV2["EnsureSpecCache(compositeKey)"] -->|"Cross-class editing"| FBV2
    end
```

## Key Data Flow Loops

| Loop | Path | Purpose |
|------|------|---------|
| **Event → Snapshot** | `UNIT_POWER_UPDATE` → `UpdateResourceValues()` → `snapshotData` | Captures Insanity changes from WoW API |
| **Snapshot → Lookup** | `RefreshLookupData_Shadow()` reads `snapshotData` → writes to `lookup` + `lookupLogic` | Transforms raw data into formatted bar text variables |
| **Timer → Full Cycle** | `timerFrame:onUpdate` → `TriggerResourceBarUpdates` → `UpdateResourceBar` → back to waiting | Continuous polling drives all UI updates |
| **Lookup → Bar Text** | `lookup` table → `UpdateResourceBarText()` → `textFrames` | Replaces `$insanity` with colored value strings |

## Data Store Descriptions

### `TRB.Data.specRegistry`
Canonical registry of all 40 supported specializations, populated at load time in `Init.lua`:
- Keys are composite keys: `"priest_shadow"`, `"warrior_arms"`, etc.
- Values are `SpecRegistryEntry` objects: `{ classId, specId, className, specName, compositeKey }`

### `TRB.Data.specRegistryByIds`
Same registry indexed by numeric IDs:
- `specRegistryByIds[classId][specId]` → `SpecRegistryEntry`

### `TRB.Data.barTextVariablesRegistry`
Maps composite keys to `FillBarTextVariables()` functions:
- Populated at load time by each `ClassModules/Classes/*Classes.lua`
- Consumed by `EnsureSpecCache()` to lazily populate bar text variables for non-active specs

### `TRB.Data.snapshotData`
The central state object containing all tracked information:
- `attributes.resource` - Current Insanity value (raw from API)
- `attributes.resourceModified` - Normalized resource value for display
- `attributes.mana` / `attributes.manaMax` - Mana tracking for Shadow
- `snapshots[spellId].buff` - Buff/debuff state per spell
- `casting` - Current spellcast information

### `TRB.Data.lookup`
String-formatted values for bar text display:
- Keys like `$insanity`, `$vfTime`, `$mana`
- Values are color-formatted strings: `"|cFF00FF00150|r"`

### `TRB.Data.lookupLogic`
Raw numeric values for conditional evaluation:
- Same keys as `lookup`
- Values are raw numbers: `150`, `12.5`

### `TRB.Data.specCache`
Per-specialization cached data, keyed by composite key (e.g., `"priest_shadow"`):
- `talents` - Current talent configuration
- `settings` - Merged user settings
- `spellsData` - Spell definitions and tracking
- `snapshotData` - Spec-specific snapshot reference
- `barTextVariables` - `{ icons = {}, values = {} }` for bar text editor

Created eagerly for all specs of the active class in `SwitchSpec()`, and lazily for other classes via `EnsureSpecCache()`.

### `TRB.Data.character`
Character identity and state:
- `classId` / `specId` - Numeric IDs
- `className` / `specName` - String identifiers
- `compositeKey` - `"className_specName"` composite key for specCache lookups
- `inCombat`, `maxResource`, `resourceType`, etc.

### `TRB.Frames.barGroups`
OOP-based bar frame hierarchy:
- `primary` - Main resource bar (Insanity)
- `mana` - Secondary mana bar
- `health` - Health bar

## Event Registration

When Shadow Priest is active, these WoW events are registered:

| Event | Handler | Updates |
|-------|---------|---------|
| `UNIT_POWER_UPDATE` | `UpdateResourceValues()` | `snapshotData.attributes.resource` |
| `UNIT_AURA` | `AuraUpdateEvent()` | Buff/debuff snapshots |
| `UNIT_SPELLCAST_START/STOP/SUCCEEDED` | `SpellCastEvent()` | `snapshotData.casting` |
| `PLAYER_REGEN_DISABLED/ENABLED` | Combat state handler | Bar visibility |
| `COMBAT_LOG_EVENT_UNFILTERED` | Combat log parser | DoT tracking, damage events |

## Update Cycle

The addon uses a hybrid event-driven + polling architecture:

1. **Event-Driven**: WoW events immediately update `snapshotData`
2. **Polling**: `timerFrame:onUpdate()` runs every ~0.05s to refresh the UI
3. **Lookup Refresh**: Each update cycle regenerates `lookup` and `lookupLogic` tables
4. **Bar Rendering**: Bar values and text are updated from the lookup tables

This ensures the UI stays responsive while avoiding excessive event handler complexity.
