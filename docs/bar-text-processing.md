# TwintopInsanityBar Bar Text Processing System

This document provides a detailed diagram of how bar text processing works in the TwintopInsanityBar addon.

## High-Level Overview

```mermaid
flowchart TB
    subgraph "📝 Bar Text Settings"
        BTS[("displayText.barText[]<br/>• enabled<br/>• text<br/>• font settings<br/>• position")]
    end

    subgraph "💾 Data Sources"
        LU[("TRB.Data.lookup<br/>Formatted strings<br/>$insanity → '|cFF00FF00150|r'")]
        LL[("TRB.Data.lookupLogic<br/>Raw values<br/>$insanity → 150")]
        BTV[("barTextVariables<br/>• icons[]<br/>• values[]<br/>• pipe[]<br/>• percent[]")]
    end

    subgraph "🖼️ Frame Infrastructure"
        TF[("TRB.Frames.textFrames[]<br/>• frame<br/>• frame.font (FontString)")]
    end

    BTS --> URBT["UpdateResourceBarText()"]
    LU --> URBT
    LL --> URBT
    BTV --> URBT
    URBT --> TF
```

## Complete Processing Flow

```mermaid
flowchart TB
    subgraph "🔄 Update Entry Point"
        START["UpdateResourceBarText(settings, refreshText)"] --> RLDB["RefreshLookupDataBase(settings)"]
        RLDB -->|"Stats, health, GCD"| LU1[("lookup")]
        RLDB -->|"Raw values"| LL1[("lookupLogic")]
        START --> RLD["TRB.Functions.RefreshLookupData()"]
        RLD -->|"Spec variables"| LU1
        RLD -->|"Spec raw values"| LL1
    end

    subgraph "📋 Per-Entry Processing"
        START --> LOOP["For each barText[i] where enabled=true"]
        LOOP --> GBTF["GetBarTextFrame(relativeToFrame)"]
        GBTF -->|"frame, isEnabled, isVisible"| VIS{"isVisible?"}
        VIS -->|"No"| SKIP["Skip this entry"]
        VIS -->|"Yes"| GRT["GetReturnText(barText.text)"]
    end

    subgraph "🌲 Conditional Tree Processing"
        GRT --> GFBTTC["GetFromBarTextTreeCache(text)"]
        GFBTTC -->|"Cache miss"| CBT["CreateBarTextTree(text)"]
        CBT --> SLS["ScanForLogicSymbols(text)"]
        SLS -->|"Tokenize { } [ ] operators"| TREE[("Parsed Tree<br/>• symbols[]<br/>• barText[]<br/>• logic blocks")]
        GFBTTC -->|"Cache hit"| TREE
        TREE --> RIVFBT["RemoveInvalidVariablesFromBarText(tree)"]
    end

    subgraph "⚖️ Conditional Evaluation"
        RIVFBT --> FOREACH["For each logic block"]
        FOREACH --> GETVAR["Get logicVariables[]"]
        GETVAR --> IVFS["IsValidVariableForSpec(var)"]
        IVFS -->|"Invalid"| INVALID["Mark block INVALID"]
        IVFS -->|"Valid"| GETRAW["Get lookupLogic[var]"]
        GETRAW --> BUILD["Build evaluable string"]
        BUILD -->|"! → not<br/>& → and<br/>|| → or"| EVAL["loadstring('return (...)')()"]
        EVAL -->|"true"| TRUE["Return trueResult branch"]
        EVAL -->|"false"| FALSE["Return falseResult branch"]
        TRUE --> RECURSE["Recurse into child barText[]"]
        FALSE --> RECURSE
        INVALID --> RECURSE
    end

    subgraph "🔤 Token Replacement"
        RIVFBT -->|"Processed text"| GFBTC["GetFromBarTextCache(text)"]
        GFBTC -->|"Cache miss"| ABTC["AddToBarTextCache(text)"]
        ABTC --> SCAN["Scan for # $ | % tokens"]
        SCAN --> MATCH["Match against barTextVariables"]
        MATCH --> FORMAT["Build stringFormat with %s placeholders"]
        FORMAT --> CACHE[("Cache Entry<br/>• cleanedText<br/>• stringFormat<br/>• variables[]")]
        GFBTC -->|"Cache hit"| CACHE
    end

    subgraph "🎨 Final Rendering"
        CACHE --> MAPPING["Build mapping[] from lookup[var]"]
        MAPPING --> SPRINTF["string.format(stringFormat, unpack(mapping))"]
        SPRINTF --> SETTEXT["textFrame.font:SetText(result)"]
    end

    RECURSE --> GFBTC
```

## Frame Resolution: `GetBarTextFrame()`

```mermaid
flowchart TB
    subgraph "📍 Frame Reference Resolution"
        INPUT["relativeToFrame string<br/>e.g., 'Resource', 'ComboPoint1'"]
        INPUT --> STRIP["Strip underscores"]
        STRIP --> MATCH{"Match frame type"}
        
        MATCH -->|"'Resource' or 'ResourceBar'"| PRI["barGroups.primary:GetNode(1):GetResourceFrame()"]
        MATCH -->|"'HealthBar'"| HEALTH["barGroups.health:GetNode(1):GetResourceFrame()"]
        MATCH -->|"'ManaBar'"| MANA["barGroups.mana:GetNode(1):GetResourceFrame()"]
        MATCH -->|"'ComboPointN'"| CP["Extract N<br/>barGroups.secondary:GetNode(N):GetResourceFrame()"]
        MATCH -->|"'UIParent'"| UI["UIParent frame<br/>(always valid, always visible)"]
        MATCH -->|"No match"| GLOBAL["_G['TwintopResourceBarFrame_'..name]"]
        
        PRI --> RETURN["Return (frame, isEnabled, isVisible)"]
        HEALTH --> RETURN
        MANA --> RETURN
        CP --> RETURN
        UI --> RETURN
        GLOBAL --> RETURN
    end
```

## Variable Validation: `IsValidVariableForSpec()`

```mermaid
flowchart TB
    subgraph "✅ Variable Validation Flow"
        VAR["Input: '$variableName'"]
        VAR --> BASE["IsValidVariableBase(var)"]
        
        BASE --> BASEMATCH{"Is base variable?"}
        BASEMATCH -->|"Yes"| BASEVALID["Return true"]
        BASEMATCH -->|"No"| SPEC["Spec-specific check"]
        
        subgraph "📊 Base Variables (Always Valid)"
            BASEVARS["$crit, $critPercent, $critRating<br/>$mastery, $masteryPercent, $masteryRating<br/>$haste, $hastePercent, $hasteRating<br/>$vers, $versatility, $versRating, $dVers<br/>$gcd<br/>$int, $intellect, $agi, $str, $stam"]
        end
        
        BASE --> BASEVARS
        
        SPEC --> SPECID{"Check specId"}
        SPECID -->|"Shadow (3)"| SHADOW["Check Shadow variables"]
        SPECID -->|"Discipline (1)"| DISC["Check Discipline variables"]
        SPECID -->|"Holy (2)"| HOLY["Check Holy variables"]
        
        SHADOW --> SHADOWCHECK{"Variable type?"}
        SHADOWCHECK -->|"$insanity, $mana"| ALWAYS["Always valid"]
        SHADOWCHECK -->|"$vfTime"| CONDITIONAL["Valid if buff active<br/>Check snapshotData"]
        SHADOWCHECK -->|"Unknown"| NOTFOUND["Return false"]
        
        ALWAYS --> RAWVAL["Return lookupLogic[var]"]
        CONDITIONAL --> RAWVAL
    end
```

## Conditional Logic Tokenization: `ScanForLogicSymbols()`

```mermaid
flowchart TB
    subgraph "🔍 Symbol Scanning"
        INPUT["Input: '{$insanity > 50}[High][Low]'"]
        INPUT --> ITER["Iterate character by character"]
        
        ITER --> DETECT{"Detect symbol type"}
        
        DETECT -->|"{"| LBRACE["Logic block start<br/>level++"]
        DETECT -->|"}"| RBRACE["Logic block end<br/>level--"]
        DETECT -->|"["| LBRACKET["Result block start"]
        DETECT -->|"]"| RBRACKET["Result block end"]
        DETECT -->|"$"| DOLLAR["Variable marker"]
        DETECT -->|"||"| OR["OR operator"]
        DETECT -->|"&"| AND["AND operator"]
        DETECT -->|"!"| NOT["NOT operator"]
        DETECT -->|"==, ~=, >=, <=, >, <"| COMPARE["Comparison operator"]
        DETECT -->|"+, -, *, /"| MATH["Math operator"]
        DETECT -->|"(, )"| PAREN["Parenthesis<br/>parenLevel++/--"]
        
        LBRACE --> SYMBOLS
        RBRACE --> SYMBOLS
        LBRACKET --> SYMBOLS
        RBRACKET --> SYMBOLS
        DOLLAR --> SYMBOLS
        OR --> SYMBOLS
        AND --> SYMBOLS
        NOT --> SYMBOLS
        COMPARE --> SYMBOLS
        MATH --> SYMBOLS
        PAREN --> SYMBOLS
        
        SYMBOLS[("symbols[]<br/>• symbol<br/>• position<br/>• level<br/>• parenLevel")]
    end
```

## Conditional Tree Structure

```mermaid
flowchart TB
    subgraph "🌲 Parsed Tree Structure"
        ROOT["CreateBarTextTree() result"]
        ROOT --> SYMBOLS2[("symbols[]<br/>Tokenized positions")]
        ROOT --> BARTEXT["barText[]"]
        
        BARTEXT --> PLAIN["'plain text string'"]
        BARTEXT --> LOGIC["Logic Block Object"]
        
        LOGIC --> LOGICSTR["logic: 'condition expression'"]
        LOGIC --> LOGICVARS["logicVariables[]"]
        LOGIC --> PROCESSED["processedLogicStrings[]<br/>(evaluation cache)"]
        LOGIC --> TRUE2["trueResult: { barText: [...] }"]
        LOGIC --> FALSE2["falseResult: { barText: [...] }"]
        
        LOGICVARS --> VARENTRY["{ variable, beforeVar,<br/>prevSymbol, nextSymbol }"]
        
        TRUE2 -->|"Recursive"| BARTEXT
        FALSE2 -->|"Recursive"| BARTEXT
    end
```

## Token Types and Replacement

```mermaid
flowchart LR
    subgraph "🏷️ Token Types"
        DOLLAR["$ Variable<br/>$mana, $insanity"]
        HASH["# Icon<br/>#casting, #spell_12345_"]
        PIPE["|| Pipe<br/>||n (newline)<br/>||c, ||r (color)"]
        PERCENT["%% Percent<br/>%% → literal %"]
    end

    subgraph "🔄 Replacement Process"
        DOLLAR -->|"lookup[$mana]"| DOLLAROUT["'|cFF0000FF5000|r'"]
        HASH -->|"GetSpellInfo / barTextVariables.icons"| HASHOUT["'|Tpath/icon.blp:0|t'"]
        PIPE -->|"Direct replacement"| PIPEOUT["'\\n' or '|c' / '|r'"]
        PERCENT -->|"Direct replacement"| PERCENTOUT["'%'"]
    end
```

## Cache Structure

```mermaid
flowchart TB
    subgraph "💾 Caching Layers"
        INPUT2["Raw bar text string"]
        
        INPUT2 --> TREECACHE{"barTextTree cache?"}
        TREECACHE -->|"Miss"| PARSETREE["Parse with CreateBarTextTree()"]
        PARSETREE --> STORETREE["Store in TRB.Data.cache.barTextTree[text]"]
        TREECACHE -->|"Hit"| USETREE["Use cached tree"]
        
        STORETREE --> EVALUATE["Evaluate conditionals"]
        USETREE --> EVALUATE
        
        EVALUATE --> PROCESSED2["Processed text (conditionals resolved)"]
        
        PROCESSED2 --> TEXTCACHE{"barText cache?"}
        TEXTCACHE -->|"Miss"| PARSETEXT["Parse with AddToBarTextCache()"]
        PARSETEXT --> STORETEXT["Store in TRB.Data.cache.barText[text]"]
        TEXTCACHE -->|"Hit"| USETEXT["Use cached format"]
        
        STORETEXT --> CACHEENTRY
        USETEXT --> CACHEENTRY
        
        CACHEENTRY[("Cache Entry<br/>• cleanedText<br/>• stringFormat<br/>• variables[]")]
        
        CACHEENTRY --> FORMAT["string.format(stringFormat, ...)"]
    end
```

## Bar Text Settings Structure

```mermaid
classDiagram
    class DisplayText {
        +default: DefaultSettings
        +barText: DisplayTextEntry[]
    }
    
    class DefaultSettings {
        +fontFace: string
        +fontFaceName: string
        +fontJustifyHorizontal: string
        +fontSize: number
        +color: string
    }
    
    class DisplayTextEntry {
        +enabled: boolean
        +name: string
        +text: string
        +guid: string
        +fontFace: string
        +fontFaceName: string
        +fontJustifyHorizontal: string
        +fontJustifyHorizontalName: string
        +fontSize: number
        +color: string
        +useDefaultFontFace: boolean
        +useDefaultFontSize: boolean
        +useDefaultFontColor: boolean
        +position: Position
    }
    
    class Position {
        +xPos: number
        +yPos: number
        +relativeTo: string
        +relativeToName: string
        +relativeToFrame: string
        +relativeToFrameName: string
    }
    
    DisplayText --> DefaultSettings
    DisplayText --> DisplayTextEntry
    DisplayTextEntry --> Position
```

## Text Frame Creation

```mermaid
sequenceDiagram
    participant SwitchSpec
    participant CreateBarTextFrames
    participant GetBarTextFrame
    participant WoW API
    participant textFrames

    SwitchSpec->>CreateBarTextFrames: CreateBarTextFrames(classId, specId)
    
    loop For each barText entry
        CreateBarTextFrames->>GetBarTextFrame: GetBarTextFrame(relativeToFrame)
        GetBarTextFrame-->>CreateBarTextFrames: (frame, isEnabled, isVisible)
        
        alt Frame found
            CreateBarTextFrames->>WoW API: CreateFrame("Frame", name, parentFrame)
            WoW API-->>CreateBarTextFrames: newFrame
            CreateBarTextFrames->>WoW API: newFrame:CreateFontString(nil, "BACKGROUND")
            WoW API-->>CreateBarTextFrames: fontString
            CreateBarTextFrames->>textFrames: Store {frame, frame.font}
        else Frame not found
            CreateBarTextFrames->>WoW API: _G["TwintopResourceBarFrame_"..name]
            WoW API-->>CreateBarTextFrames: globalFrame (or nil)
        end
    end
```

## Key Function Reference

| Function | File | Purpose |
|----------|------|---------|
| `UpdateResourceBarText()` | Functions/BarText.lua | Main entry point, orchestrates full update |
| `RefreshLookupDataBase()` | Functions/BarText.lua | Populates base stats in lookup tables |
| `GetReturnText()` | Functions/BarText.lua | Processes conditionals and returns final text |
| `CreateBarTextTree()` | Functions/BarText.lua | Parses text into conditional tree structure |
| `ScanForLogicSymbols()` | Functions/BarText.lua | Tokenizes symbols for parsing |
| `RemoveInvalidVariablesFromBarText()` | Functions/BarText.lua | Evaluates conditionals, returns processed text |
| `AddToBarTextCache()` | Functions/BarText.lua | Tokenizes variables, creates format string |
| `GetFromBarTextCache()` | Functions/BarText.lua | Retrieves cached parse result |
| `GetFromBarTextTreeCache()` | Functions/BarText.lua | Retrieves cached tree structure |
| `IsValidVariableForSpec()` | ClassModules/*.lua | Validates variable for current spec |
| `IsValidVariableBase()` | Functions/BarText.lua | Validates common base variables |
| `GetBarTextFrame()` | ClassModules/*.lua | Resolves frame reference to actual Frame |
| `CreateBarTextFrames()` | Functions/BarText.lua | Creates text frame infrastructure |

## Data Store Summary

| Store | Location | Purpose |
|-------|----------|---------|
| `TRB.Data.lookup` | Global | Formatted colored strings for display |
| `TRB.Data.lookupLogic` | Global | Raw numeric values for conditional evaluation |
| `TRB.Data.barTextVariables` | Global | Valid variable definitions per spec |
| `TRB.Data.cache.barText` | Global | Cached parsed text with format strings |
| `TRB.Data.cache.barTextTree` | Global | Cached conditional tree structures |
| `TRB.Data.cache.symbols` | Global | Cached tokenized symbol positions |
| `TRB.Frames.textFrames` | Global | Array of text Frame objects |
| `settings.displayText.barText` | Spec settings | User-configured bar text entries |
