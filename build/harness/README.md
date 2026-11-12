# Smoke-load harness

Loads the addon the way the client would -- every file of a TOC (and its XML includes) in order --
under a permissive stub of the WoW API, using a plain Lua 5.1 interpreter. It catches what a static
checker cannot: load-order errors, nil indexing at file scope, and errors in the settings bootstrap
(`ADDON_LOADED`), for every class and for every flavor, without launching the game.

It is deliberately shallow past the bootstrap: frames, libraries and Blizzard APIs are stubs, so the
deferred UI construction eventually hits a stub it cannot emulate. Those show up as `TIMER ERROR` lines
and are informational; `ERROR`, `SYNTAX` and `EVENT ERROR` lines are real. The color APIs are the
exception: `ColorMixin`, the ColorUtil helpers, `C_ColorUtil`, and color and numeric curves (also through
`UnitPowerPercent` and `UnitHealthPercent`) behave like the client's, minus secret values, and class colors
are white.

## Requirements

A Lua 5.1 interpreter on the PATH as `lua5.1` (Windows: the LuaBinaries `lua5.1.exe`; Ubuntu:
`apt install lua5.1`). Nothing else.

## Usage

```
lua5.1 build/harness/load.lua <addonDir> <tocRelPath> [classId] [events]

# mainline, as a Priest, through the settings bootstrap
lua5.1 build/harness/load.lua . TwintopInsanityBar.toc 5 ADDON_LOADED

# forever, as a Rogue, through first-time setup (expect TIMER ERROR lines from the UI stubs)
lua5.1 build/harness/load.lua . Flavors/Forever/TwintopInsanityBar.toc 4 ADDON_LOADED,PLAYER_LOGIN,PLAYER_ENTERING_WORLD
```

`classId` is the WoW class id (1 Warrior ... 13 Evoker); the stubs answer `UnitClass` with it so the
matching class module is the one that registers. `events` is a comma-separated list fired in order
after all files load (`ADDON_LOADED`, `PLAYER_LOGIN`, `PLAYER_ENTERING_WORLD`, `PLAYER_LOGOUT`, ...);
`C_Timer.After` callbacks queued by a handler run right after it.

Environment variables:

- `TRB_SAVED=<file>`: a WoW SavedVariables file to load before the addon (the second-login path:
  migrations, merge, seeding). Your real `WTF\Account\<name>\SavedVariables\TwintopInsanityBar.lua`
  works as-is.
- `TRB_DUMP_SAVED=<file>`: after the events, write the addon's saved-variables global as a loadable
  file (fire `PLAYER_LOGOUT` so the addon assigns it first). Feed it back with `TRB_SAVED` to simulate
  the next login.
- `TRB_SNAPSHOT=<file>`: after the events, write a deterministic dump of the merged settings, the
  class/spec registries, the bar type registry (with its default dimensions/colors) and every class
  options module's `LoadDefaultSettings(true)` output. Diffing two snapshots is how a refactor proves
  it changed no defaults.
- `TRB_DRIVER=<file>`: a driver, below.

`build/smoke.ps1` runs the load + `ADDON_LOADED` check for every class of both flavors and fails on
any real error; CI runs the same thing.

## Drivers

A driver is a Lua file returning hook functions, each called with a context table (`TRB`, `stubs`,
`addonName`, `addonDir`, `tocRel`, `classId`, `harnessDir`):

- `afterInstall`, after the stubs install and before the addon's files load;
- `afterLoad`, after the files load and before the events;
- `afterEvents`, after the events. A number it returns counts as that many failures.

A hook that errors prints `DRIVER ERROR` and fails the run. `drivers\parity.lua` holds the client
behavior a driver needs past smoke-loading: Forever's project id, template children, positional
`string.format`, and `HoldDeferredSetup`, which holds the 1s deferred setup until the driver fires
`TRB_RELEASE_DEFERRED`, as the game runs it after `PLAYER_LOGIN`.

| Driver | Run by | What it does |
| --- | --- | --- |
| `drivers\options-tabs.lua` | `drivers.ps1` | Builds every options tab for every class, then runs the Textures tab checks from #861 and #584, and checks which cooldown options each threshold line's icon override offers, which specs show the Threshold Line Behavior section, Hide while on cooldown's window on Global Options, and each line's Cooldown Tracking and While on Cooldown dropdowns and grayed-out options, including While on Cooldown on a line hidden while Unusable, Hide with no valid target on Global Options, which lines offer With No Valid Target and the Behavior Override header, no out-of-range options for a spell with no range, and Reset Global Bar Text before its Bar Text tab is built. Prints `PASS`, `FAIL`, and `TAB ERROR` lines. |
| `drivers\media-pickup.lua` | `drivers.ps1` | Checks that fonts, textures, and sounds that aren't loaded draw or play the default, are picked up live (after combat, with a Druid form's spec), and are never written into settings. |
| `drivers\colors.lua` | `drivers.ps1` | Checks color conversion, color curves (including through `UnitPowerPercent`), class colors, and VertexColor animations against the client's behavior. |
| `drivers\threshold-behavior.lua` | `drivers.ps1` | Checks the threshold line cooldown tracker: every cooldown line has a snapshot, only events naming a tracked spell read cooldowns, the `isOnGCD` start/GCD/reduction/end rules, the end widget, charge spells and their recharges, the icon swipe with each icon cooldown option, and Threshold Line Behavior: tracking settings and Use Global, which lines stay tracked (enabled, On Cooldown indicators, Druid forms), the tick's untracked lines, and Hide while on cooldown: which window a line follows, hiding until it with plain times, the alpha with secret times, charge lines hiding only at 0 charges, and the alpha after a reset, and Hide with no valid target: the resolution rules, in and out of combat, the lines that never hide, a custom line, and a spec whose lines can't be cast on enemies. A draw that errors fails its check. Live Druids run as Feral with every talent learned. |
| `drivers\range-checks.lua` | `drivers.ps1` | Checks that the live specialization's range checks, and no others, stay on through the `SwitchSpec` re-runs after a loading screen, a talent change (and Classic's and TBC's `PLAYER_TALENT_UPDATE`), and a specialization change, for every specialization, and after a change away from a disabled one. Also checks that turning Use Global threshold colors on, Global Options' out-of-range boxes, an options refresh on a disabled specialization, and another specialization's settings for a shapeshift form turn them on or keep them off as needed, hiding lines with no valid target included. Also checks the range cache: one API read per target with no target, range events stored without one, turning off only this addon's range checks, spells with no range, and a spellbook change (a new rank, or a spell that now has a range). The Threshold Line Behavior Use Global box turns them on too. |
| `drivers\aura-conditions.lua` | `drivers.ps1` | Checks custom Color Indicators and Buff Alerts that follow a buff by spell ID. On Classic and TBC: `UNIT_AURA` keeps them current (any rank, every copy, harmful auras ignored, full updates, and a re-read when `UNIT_AURA` comes back on), unfollowed auras cost no reads, a Buff Alert plays once per gain, and the options add, re-point, and remove indicators and point a Buff Alert through the spell ID prompt, which accepts only an ID some spell has. On the other flavors: no menu offers them, and nothing reads an aura even with one set up. |
| `drivers\swing-timers.lua` | `drivers.ps1` | Checks the swing timer bars. On Classic and TBC, with no `PLAYER_SWING`: the combat log starts each hand's swing at its weapon speed, skips extra attacks, and applies parry haste; attack speed changes rescale a swing; a cast pauses both hands and its success restarts Main Hand while auto attacking; Slam's cast doesn't pause; next-swing attacks restart Main Hand; ranged shots start Ranged at `UnitRangedDamage`'s speed; the events register only while a bar needs them; and no tab offers Hide Blizzard swing timers. On Forever: `PLAYER_SWING` drives the bars and the option stays. |
| `drivers\classic-overcap.lua` | `drivers.ps1` | Checks Classic's and TBC's Overcap indicators: they sit in the Color Indicator priority list (and an older save's gradient-list Overcap moves there), turn on at the threshold only in combat (through Only In Combat, on by default; turned off, out of combat too) and outside Stealth, follow a relative offset, switch the resource text to its overcap color, and build no color curves; the options list them with the other indicators and have no gradient section. On the other flavors Overcap stays a gradient indicator. |
| `drivers\indicator-copies.lua` | `drivers.ps1` | Checks built-in Color Indicator copies and deletions: a deleted built-in stays out through the settings reconcile and a login's merge, copies are recovered into their built-in's list, and a merging profile piece clears both. The options' Add Built-in buttons list every built-in sorted by label, add a copy or restore a deleted built-in's own key, delete after a confirmation, and place gradient rows correctly after either list grows or shrinks. For every specialization, the real update paints a built-in and its copy on different elements, paints the copy alone once the built-in is deleted, and curves each gradient element with the top Overcap copy that targets it. |
| `drivers\indicator-modifiers.lua` | `drivers.ps1` | Checks Color Indicator modifiers and the Edit menu: Not Active flips built-ins, copies, and custom rows, a custom source that can't be read stays off, and a built-in condition left unset counts as not met. Only In Combat keeps a row off out of combat, with or without Not Active, and in combat leaves it as is. Turning off a modifier a built-in has on by default saves false, which a login keeps, and Change Source onto that built-in saves its default modifiers as false for a row that had none. On every specialization's panel, the Edit menu lists Change Source (every built-in, sorted by label, with the row's own picked), Not Active, and Only In Combat, each of which saves on the row and marks its label; gradient rows offer Change Source and Only In Combat but never Not Active, and threshold rows offer Not Active unless Static, and Only In Combat always. A gradient's Only In Combat gates its curve on the spec's own bars and the shared bars, and copies take their built-in's default modifiers they leave unset. Switching an original built-in makes it a copy in place with its color, targets, and modifiers, a copy re-points under its key, and picking a deleted original restores its key, keeping only the row's targets through a login. For every specialization, the real update honors Not Active on a built-in and on its copy, and Only In Combat on a built-in; every built-in and gradient seeded with Only In Combat paints only in combat, until it is turned off. |
| `drivers\bartext-conformance.lua` | `drivers.ps1` | Checks that the bar text engine (`RenderBarTextEntry`) renders exactly what the legacy resolver (`GetReturnText`) does, for every bar text in the loaded settings and save plus a list of edge cases (every operator spelling, broken braces, nesting, the conditional cap, percent signs, and icons), under seeded draws of logic values, shown values, validator answers, and secrets. It also checks that an unforced render skips when nothing it shows changed, and shows any change the legacy resolver does. `TRB_CONFORMANCE_DRAWS` sets the draws per text (default 48). |
| `drivers\inner-fire.lua` | `drivers.ps1` | Checks Forever Priest's Inner Fire: a cast of any rank tracks 20 charges for 10 minutes, every physical `UNIT_COMBAT` `WOUND` without an ABSORB, BLOCK, or RESIST flag spends one (swings, thrown hits, and partial absorbs, with the amount secret), while fully absorbed, magic, avoided, healing, and secret hits, and combat text alone, spend none. A loading screen (once the spell set loads) and leaving combat copy the aura's charges and time, except in combat lockdown, while auras are restricted, or from a secret aura; with no rank's aura up, tracking ends. It ends on the last charge, at 10 minutes, and on death; a recast restarts it, and Improved Inner Fire adds charges. Also checks its bar text and bare checks; its Color Indicator, listed by default with no targets, which the real update paints while Inner Fire is up (or down, with Not Active); and that `/trb innerfire` rejects an argument, prints a cast's charges and one line per hit, and ignores heals. On the Classic and TBC Priest, the charges and time come from the aura instead: a gained, updated, removed, or fully updated aura of any rank reads once after a short delay, other auras and hits taken read nothing, a read that misses the aura still follows its next update, and a loading screen reads it once the spell set loads. The same bar text and Color Indicator apply, and there is no `/trb innerfire`. Every other class and flavor offers no Inner Fire bar text. |
| `drivers\slice-and-dice.lua` | `drivers.ps1` | Checks the Forever, Classic, and TBC Rogue's Slice and Dice: a cast of either rank tracks 6 seconds plus 3 per combo point the cache held when it was sent (or, with no send seen, when it succeeded), Improved Slice and Dice lengthens it by 15, 30, or 45%, and on TBC two Netherblade pieces add 3 seconds before that percentage. Other finishers, sends for another cast, and secret sends start nothing. A recast replaces it, and it ends when its time runs out and on death. Also checks `$sliceAndDiceTime` and its bare check; the Active and Ending Color Indicators, listed after Stealth in that order on the Energy bar's fill, with Active set to Not Active and Only In Combat and Ending at 2 GCDs, which the real update paints as Active while Slice and Dice is down in combat, nothing out of combat or with plenty left, and Ending inside its GCD or time window (and Active while up, without its modifiers). Every other class offers no Slice and Dice bar text. |
| `drivers\brews.lua` | `drivers.ps1` | Checks the Live Brewmaster's Brews bar: each talented, enabled brew gets a node per charge in the configured order, Endless Draught adds Celestial Brew's and Celestial Infusion's second, and a talent change, an enable box, or a reorder remaps the nodes and their bar text anchors. Charges are counted from casts and the plain recharging and no-charges flags with the game's count secret: Purifying Brew's 1 second lockout doesn't read as no charges, a refill restores every charge, and a recharge no cast was seen for reads as one charge. Also checks each brew's `Time` and `Charges` variables and bare checks; that the real update draws a full node per ready charge, binds a recharging node's fill once per duration object, and rebinds on a reduction; a Color Indicator aimed at one brew's border coloring that brew's nodes alone; and the default bar text, one entry per charge on anchors the editor offers. Every other class and flavor has no Brews bar. |
| `drivers\arcane-blast.lua` | `drivers.ps1` | Checks the Forever and TBC Mage's Arcane Blast bar: one node per stack (4 on Forever, 3 on TBC), named the Arcane Blast Bar, with Arcane Charges' colors, its nodes as bar text anchors, and an Arcane Blast Stacks audio counter seeded with two cues that are off. The bar stays hidden until the Arcane Blast talent is taken on Forever, or the spell is learned on TBC, which lays the bars out once, a frame after `SPELLS_CHANGED` on TBC; dropping it hides the bar again, and knowing the spell without the talent keeps it hidden on Forever. A cast of any rank adds a stack up to the cap; Forever keeps the first cast's 18 second expiry and TBC restarts its 8 seconds. The stacks end when the timer runs out, on death, and start over at one when a cast lands after they ran out but before a tick. Also checks the bar text, its bare checks, the real update's node fill, and the value fed to the audio counter. The Forever and TBC Rogue keep their combo point anchor labels and counter with no gate, the Classic Mage has no secondary bar, and every other class and flavor offers no Arcane Blast bar text. |
| `drivers\spell-data.lua` | `drivers.ps1` | Checks that every filled specialization's `spellsById` lists each spell once under each of its ids and ranks, and only spells in its spell set, after login and after each `SwitchSpec` re-run: a specialization change, two loading screens, a talent change, and Classic's and TBC's `PLAYER_TALENT_UPDATE`, for every specialization. Each step also checks that the specialization's own spell data was filled again. |
| `drivers\bartext-fonts.lua` | `font-compare.ps1` | Writes the font each bar text string gets at login to `TRB_FONT_OUT`. `TRB_SPEC` picks the specialization index, and `TRB_REGISTER_SAVED_MEDIA=1` registers every name the save uses at its saved path, as if all its media loaded. |
| `drivers\bartext-render.lua` | `render-compare.ps1` | Plays a fixed scenario through the real 20Hz tick, every frame's OnUpdate, and the real event handlers, and writes each bar text string's text whenever it changes to `TRB_RENDER_OUT`. It adds screen entries for speed, the cast bars, the GCD, the pet, a totem, and combat time on top of the save's own, and sets the GCD bar to Always Show. The scenario: idle, a power change, moving, stopping, a speed change with no movement event, combat, a cast and its GCD, a pet, a totem, a target's cast, and leaving combat. `TRB_SPEC` picks the specialization index, and `TRB_RENDER_SAVE_ONLY=1` skips the added entries. |

`drivers.ps1 -AddonDir <checkout>` runs the current drivers against another checkout, such as a
`git worktree` of an older commit, to show a check fails without the fix it covers.

`font-edge-save.lua <in> <out> [case]` rewrites a save's bar text and default fonts into the edge cases
`font-compare.ps1 -EdgeCases` uses: without a case they cycle through a nil name, an empty name, a name
without a file, and the untouched pick; with case 1, 2, or 3, every font but the first takes that case.

`render-compare.ps1 [-Ref <ref>] [-Saved <file>]` runs the bartext-render scenario for every specialization of every class on the ref (default `main`) and this checkout, and fails on any difference in what bar text shows. `-SaveEntriesOnly` leaves
out the driver's own entries, for a change that skips work for variables nothing shows. Run it for a change that should alter when bar text updates but never what it shows.
