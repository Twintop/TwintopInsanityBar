# Developer setup and build tooling

Everything here is repeatable on a fresh machine. Only PowerShell (5.1 or 7, both ship with or are one
install away on Windows) is required; a Lua 5.1 interpreter is optional and only needed for the
offline smoke tests.

## 1. Get the code where the clients can see it

**Mainline (retail) — no setup.** Clone straight into the retail client's AddOns folder; the root
`TwintopInsanityBar.toc` references `Flavors\Mainline\...` directly, so the checkout *is* the addon:

```
cd "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns"
git clone https://github.com/Twintop/TwintopInsanityBar.git
```

**World of Warcraft: Forever — one command.** The beta client installs as `_classic_beta_` next to
`_retail_`. Point it at the same checkout:

```
cd "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\TwintopInsanityBar"
.\build\dev-link.ps1 -Flavor forever -AddOnsPath "C:\Program Files (x86)\World of Warcraft\_classic_beta_\Interface\AddOns"
```

This creates `<AddOns>\TwintopInsanityBar` as a real folder holding directory junctions (`mklink /J`,
no administrator rights) back to the checkout's `Core`, `Libs`, `Images`, `Sounds`, `StatusBars` and
`Flavors`, plus a *copy* of `Flavors\Forever\TwintopInsanityBar.toc`. Edits in the checkout are live in
both clients. Re-run the command after changing the Forever TOC (it is the only copied file); it is
safe to re-run any time. `-Remove` takes the linked folder away again without touching the checkout.
`-TocSuffix <Suffix>` also writes `TwintopInsanityBar_<Suffix>.toc`, but Forever needs no suffix: the
plain TOC is the one it reads (see the client facts below).

**Forever client facts (1.60.1 beta).** The TOC interface number is 16001. `WOW_PROJECT_ID` is
`WOW_PROJECT_MAINLINE` on purpose, so the flavor gates tell the clients apart by interface number (1.x is
Forever, 10.x+ is retail), the way AceDB does. The client's TOC game type is `camelot` and retail's is
`standard`: the mainline TOC carries `## AllowLoadGameType: standard`, so a mainline build dropped into
the Forever client (an addon manager that files Forever under retail, say) never loads there. The
Forever TOC deliberately has no `camelot` line, because Blizzard has said that token will change.
Writing saved variables is broken on the beta; settings changes do not survive a reload, and neither
do probe results, which is why `/trbprobe` opens a copy window instead.

The two clients register different API surfaces from the same binary, so neither can be inferred from
the other. On Forever the global `GetSpecialization` is absent (retail still has it), while the globals
`GetSpecializationInfoForClassID` and `GetSpecializationInfoByID` exist on both; `C_SpecializationInfo`
carries `GetSpecialization`, `GetSpecializationInfo`, `GetActiveSpecGroup`, and the PvP talent calls on
both, and nothing else that Core needs. Core therefore reads the spec index through
`TRB.Flavor.GetSpecializationIndex()` and spec names and icons through the shared globals. The smoke
harness stubs `C_SpecializationInfo` strictly to the documented live namespace and removes Forever's
absent globals for a 1.x TOC, so a leftover call fails offline.

Every Forever class has exactly one specialization, named after the class (ids 1482 to 1491 in the
manifest), and its Vanilla talent trees are one `CamelotCombat` trait tree per class, readable through
`C_ClassTalents.GetActiveConfigID()` and `C_Traits`. `UnitPower` and `UnitHealth` for the player are secret
even out of combat. Characters have a surname (`UnitName("player")` is "First Last") and realms still exist
on the beta.

You can keep the checkout anywhere else instead (e.g. `C:\dev\TwintopInsanityBar`) and link *both*
clients with `dev-link.ps1 -Flavor mainline ...` and `-Flavor forever ...`; nothing depends on the
checkout living inside `_retail_`.

## 2. Optional: Lua 5.1 for the offline smoke tests

`smoke.ps1` and the harness under `harness\` load every flavor for every class under a stubbed WoW
API and catch load-order and bootstrap errors without launching the game. They need a Lua 5.1
interpreter; nothing else. Windows: download the LuaBinaries `lua-5.1.5_Win64_bin.zip`
(sourceforge.net/projects/luabinaries), unzip it anywhere and pass the path:

```
.\build\smoke.ps1 -Lua "C:\tools\lua\lua5.1.exe"
```

With `lua5.1` on the PATH the `-Lua` argument can be dropped. See `harness\README.md` for the
saved-variables replay and golden-snapshot options used to verify refactors.

## 3. Everyday commands

| Task | Command |
| --- | --- |
| Check that Core has no class/spec leakage | `.\build\lint-core.ps1` |
| Smoke-load both flavors for every class | `.\build\smoke.ps1 -Lua <lua5.1>` |
| Build a release zip locally (into `dist\`) | `.\build\stage.ps1 -Flavor mainline` / `-Flavor forever` |
| Same, stamping a version | `.\build\stage.ps1 -Flavor mainline -Version 12.1.0.11 -ReleaseType beta01` |
| Link / unlink a client | `.\build\dev-link.ps1 -Flavor <f> -AddOnsPath <path> [-Remove]` |
| Record Forever client facts (beta) | junction or copy `build\forever-probe\TRBForeverProbe` into the Forever AddOns folder, `/trbprobe` in game, Ctrl+A and Ctrl+C in the window that opens |

## 4. Releasing

Before tagging, stamp `## Version:` and `## X-ReleaseDate:` in the flavor's TOC and add the release's
section to the top of `Flavors\<Flavor>\News.lua`; the packager rewrites neither. Then push a tag. The
workflow in `.github\workflows\release.yml` lints, syntax-checks, smoke-loads, stages the flavor with
`stage.ps1` as a workflow artifact, and hands the checkout to the BigWigs packager, which builds the
zip, creates the GitHub release with it attached, and uploads to every addon site whose token secret
exists (`CF_API_KEY`, `WAGO_API_TOKEN`, `WOWI_API_TOKEN`):

- `12.1.0.11-release`, `12.1.0.11-beta01`, `12.1.0.11-alpha03` — mainline
- `forever-1.60.1.0-release` — World of Warcraft: Forever

Both tags may point at the same commit. A tag containing `alpha` or `beta` is a pre-release on every
site. The changelog everywhere (GitHub release body, CurseForge, Wago, WoWInterface) is the newest
`# <version>` section of that flavor's `News.lua`, extracted into `CHANGELOG.md` by the workflow with
`(#NNN)` links pointed at GitHub issues and `(tab:...)` links flattened to text; touch up the site copy
by hand if it reads oddly.

The packager only reads the TOC at the repository root and the ids in its `X-Curse-Project-ID` /
`X-WoWI-ID` / `X-Wago-ID` lines, so the workflow copies `Flavors\Forever\TwintopInsanityBar.toc` into
place for a Forever tag and selects `.pkgmeta-forever` (which ignores `Flavors\Mainline`) instead of
`.pkgmeta` (which ignores `Flavors\Forever`). CurseForge and Wago have a Forever game version and the
packager maps the `16xxx` interface number to it; WoWInterface has none, and the packager skips that
upload with a warning.

**Dry run.** Run the workflow by hand (workflow_dispatch) with a flavor: the packager builds the zip
with `-d` (no uploads, no GitHub release) and the zip is attached to the run as the `packager-<flavor>`
artifact. Locally it needs bash, `zip`, `jq`, and pandoc, which WSL has (`sudo apt install zip jq
pandoc`); clone the packager and run `release.sh -d -m .pkgmeta` from the checkout root. Output lands in
`.release\`, which is git-ignored.
