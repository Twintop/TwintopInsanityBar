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
| `drivers\options-tabs.lua` | `drivers.ps1` | Builds every options tab for every class, then runs the Textures tab checks from #861 and #584, and checks which cooldown options each threshold line's icon override offers, which specs show the Threshold Line Behavior section, Hide while on cooldown's window on Global Options, and each line's Cooldown Tracking and While on Cooldown dropdowns and grayed-out options, including While on Cooldown on a line hidden while Unusable. Prints `PASS`, `FAIL`, and `TAB ERROR` lines. |
| `drivers\media-pickup.lua` | `drivers.ps1` | Checks that fonts, textures, and sounds that aren't loaded draw or play the default, are picked up live (after combat, with a Druid form's spec), and are never written into settings. |
| `drivers\colors.lua` | `drivers.ps1` | Checks color conversion, color curves (including through `UnitPowerPercent`), class colors, and VertexColor animations against the client's behavior. |
| `drivers\threshold-behavior.lua` | `drivers.ps1` | Checks the threshold line cooldown tracker: every cooldown line has a snapshot, only events naming a tracked spell read cooldowns, the `isOnGCD` start/GCD/reduction/end rules, the end widget, charge spells and their recharges, the icon swipe with each icon cooldown option, and Threshold Line Behavior: tracking settings and Use Global, which lines stay tracked (enabled, On Cooldown indicators, Druid forms), the tick's untracked lines, and Hide while on cooldown: which window a line follows, hiding until it with plain times, the alpha with secret times, charge lines hiding only at 0 charges, and the alpha after a reset. Live Druids run as Feral with every talent learned. |
| `drivers\range-checks.lua` | `drivers.ps1` | Checks that the live specialization's range checks, and no others, stay on through the `SwitchSpec` re-runs after a loading screen, a talent change, and a specialization change, for every specialization, and after a change away from a disabled one. Also checks that turning Use Global threshold colors on, Global Options' out-of-range boxes, an options refresh on a disabled specialization, and another specialization's settings for a shapeshift form turn them on or keep them off as needed. |
| `drivers\bartext-fonts.lua` | `font-compare.ps1` | Writes the font each bar text string gets at login to `TRB_FONT_OUT`. `TRB_SPEC` picks the specialization index, and `TRB_REGISTER_SAVED_MEDIA=1` registers every name the save uses at its saved path, as if all its media loaded. |

`drivers.ps1 -AddonDir <checkout>` runs the current drivers against another checkout, such as a
`git worktree` of an older commit, to show a check fails without the fix it covers.

`font-edge-save.lua <in> <out> [case]` rewrites a save's bar text and default fonts into the edge cases
`font-compare.ps1 -EdgeCases` uses: without a case they cycle through a nil name, an empty name, a name
without a file, and the untouched pick; with case 1, 2, or 3, every font but the first takes that case.
