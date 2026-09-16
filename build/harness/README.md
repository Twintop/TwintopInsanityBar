# Smoke-load harness

Loads the addon the way the client would -- every file of a TOC (and its XML includes) in order --
under a permissive stub of the WoW API, using a plain Lua 5.1 interpreter. It catches what a static
checker cannot: load-order errors, nil indexing at file scope, and errors in the settings bootstrap
(`ADDON_LOADED`), for every class and for every flavor, without launching the game.

It is deliberately shallow past the bootstrap: frames, libraries and Blizzard APIs are stubs, so the
deferred UI construction eventually hits a stub it cannot emulate. Those show up as `TIMER ERROR` lines
and are informational; `ERROR`, `SYNTAX` and `EVENT ERROR` lines are real.

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

`build/smoke.ps1` runs the load + `ADDON_LOADED` check for every class of both flavors and fails on
any real error; CI runs the same thing.
