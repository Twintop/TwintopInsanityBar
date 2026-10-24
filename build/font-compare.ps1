<#
.SYNOPSIS
	Compares the font every bar text string gets at login between a git ref and this checkout.

.DESCRIPTION
	Checks the ref out to a temporary worktree, then logs in once per specialization of every class in each flavor on
	both trees, with the current harness and its bartext-fonts driver, and diffs what each bar text string was given.
	Every name the save uses is registered at its saved path, as if all its media loaded. Fails when any login differs.
	See build\harness\README.md.

.PARAMETER Lua
	Lua 5.1 interpreter to use. Defaults to "lua5.1" on the PATH.

.PARAMETER Ref
	The git ref to compare against. Default: main.

.PARAMETER Saved
	A WoW SavedVariables file to log in with. Default: none, a fresh install.

.PARAMETER EdgeCases
	Also log in with the save rewritten into each font edge case: a nil name, an empty name, a name without a file,
	and all three mixed. Needs -Saved.

.PARAMETER Flavor
	Restrict to one flavor (mainline, forever). Default: all.
#>
[CmdletBinding()]
param(
	[string]$Lua = "lua5.1",
	[string]$Ref = "main",
	[string]$Saved = "",
	[switch]$EdgeCases,
	[string]$Flavor = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$harness = Join-Path $scriptDir "harness\load.lua"
$driver = Join-Path $scriptDir "harness\drivers\bartext-fonts.lua"
$edgeSave = Join-Path $scriptDir "harness\font-edge-save.lua"

if ($null -eq (Get-Command $Lua -ErrorAction SilentlyContinue)) {
	throw "Lua interpreter '$Lua' not found. Install Lua 5.1 or pass -Lua <path>."
}
if ($EdgeCases -and $Saved -eq "") {
	throw "-EdgeCases rewrites a save, so it needs -Saved <file>."
}
if ($Saved -ne "" -and -not (Test-Path $Saved)) {
	throw "Saved variables file '$Saved' not found."
}
& git -C $root rev-parse --verify --quiet "$Ref^{commit}" | Out-Null
if ($LASTEXITCODE -ne 0) {
	throw "Unknown git ref '$Ref'."
}

# Flavor -> TOC path and, per class id, the specialization ids its manifest declares.
$flavors = @()
Get-ChildItem (Join-Path $root "Flavors") -Directory | ForEach-Object {
	$name = $_.Name
	$id = $name.ToLowerInvariant()
	if ($Flavor -ne "" -and $Flavor.ToLowerInvariant() -ne $id) { return }
	$toc = if ($id -eq "mainline") { "TwintopInsanityBar.toc" } else { "Flavors/$name/TwintopInsanityBar.toc" }
	$manifest = Get-Content (Join-Path $_.FullName "Manifest.lua") -Raw
	$classMatches = [regex]::Matches($manifest, "classId\s*=\s*(\d+)\s*,\s*className")
	$logins = @()
	for ($i = 0; $i -lt $classMatches.Count; $i++) {
		$start = $classMatches[$i].Index
		$end = if ($i + 1 -lt $classMatches.Count) { $classMatches[$i + 1].Index } else { $manifest.Length }
		$classId = [int]$classMatches[$i].Groups[1].Value
		[regex]::Matches($manifest.Substring($start, $end - $start), "specId\s*=\s*(\d+)") | ForEach-Object {
			$logins += [pscustomobject]@{ ClassId = $classId; SpecId = [int]$_.Groups[1].Value }
		}
	}
	$flavors += [pscustomobject]@{ Name = $name; Toc = $toc; Logins = $logins }
}
if ($flavors.Count -eq 0) {
	throw "Unknown flavor '$Flavor'. Valid: mainline, forever."
}

$work = Join-Path ([System.IO.Path]::GetTempPath()) ("trb-font-compare-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
$refDir = Join-Path $work "ref"
$outDir = Join-Path $work "fonts"
New-Item -ItemType Directory -Force $outDir | Out-Null
& git -C $root worktree add --detach --quiet $refDir $Ref
if ($LASTEXITCODE -ne 0) {
	throw "Could not check out '$Ref' to $refDir."
}

$failed = $false
try {
	$saves = @()
	if ($Saved -eq "") {
		$saves += [pscustomobject]@{ Name = "fresh"; Path = "" }
	} else {
		$saves += [pscustomobject]@{ Name = "saved"; Path = (Resolve-Path $Saved).Path }
		if ($EdgeCases) {
			foreach ($case in @(@("mixed", ""), @("nilname", "1"), @("emptyname", "2"), @("nofile", "3"))) {
				$path = Join-Path $work "saved_$($case[0]).lua"
				& $Lua $edgeSave $saves[0].Path $path $case[1] | Out-Null
				if ($LASTEXITCODE -ne 0) { throw "font-edge-save.lua failed for $($case[0])." }
				$saves += [pscustomobject]@{ Name = $case[0]; Path = $path }
			}
		}
	}

	$events = "ADDON_LOADED,PLAYER_LOGIN,PLAYER_ENTERING_WORLD,TRB_RELEASE_DEFERRED"
	foreach ($save in $saves) {
		foreach ($f in $flavors) {
			$strings = 0
			$differing = @()
			$missing = @()
			foreach ($login in $f.Logins) {
				$fonts = @{}
				foreach ($tree in @(@("ref", $refDir), @("work", $root))) {
					$out = Join-Path $outDir ("{0}_{1}_{2}_{3}_{4}.txt" -f $tree[0], $save.Name, $f.Name, $login.ClassId, $login.SpecId)
					$env:TRB_DRIVER = $driver
					$env:TRB_SAVED = $save.Path
					$env:TRB_SPEC = [string]$login.SpecId
					$env:TRB_FONT_OUT = $out
					$env:TRB_REGISTER_SAVED_MEDIA = "1"
					try {
						& $Lua $harness $tree[1] $f.Toc $login.ClassId $events *> "$out.log"
					} finally {
						Remove-Item Env:TRB_DRIVER, Env:TRB_SAVED, Env:TRB_SPEC, Env:TRB_FONT_OUT, Env:TRB_REGISTER_SAVED_MEDIA -ErrorAction SilentlyContinue
					}
					# The comma keeps an empty file's empty array from unrolling to $null, which would read as no output.
					$fonts[$tree[0]] = if (Test-Path $out) { , @(Get-Content $out) } else { $null }
				}
				$label = "class {0} spec {1}" -f $login.ClassId, $login.SpecId
				if ($null -eq $fonts["ref"] -or $null -eq $fonts["work"]) {
					$missing += $label
					continue
				}
				$strings += $fonts["ref"].Count
				if (($fonts["ref"] -join "`n") -ne ($fonts["work"] -join "`n")) {
					$first = 0
					while ($first -lt [Math]::Max($fonts["ref"].Count, $fonts["work"].Count) -and $fonts["ref"][$first] -eq $fonts["work"][$first]) { $first++ }
					$differing += "$label`: $Ref=$($fonts['ref'][$first]) | work=$($fonts['work'][$first])"
				}
			}
			$state = if ($differing.Count -eq 0 -and $missing.Count -eq 0) { "ok  " } else { "FAIL"; $failed = $true }
			Write-Host ("{0}  {1,-9} {2,-9} logins={3} fontStrings={4} differing={5} noOutput={6}" -f $state, $save.Name, $f.Name, $f.Logins.Count, $strings, $differing.Count, $missing.Count)
			$differing | Select-Object -First 3 | ForEach-Object { Write-Host "    $_" }
			$missing | Select-Object -First 3 | ForEach-Object { Write-Host "    no fonts written: $_ (logs in $outDir)" }
		}
	}
} finally {
	& git -C $root worktree remove --force $refDir | Out-Null
	if (-not $failed) {
		Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
	}
}

if ($failed) {
	Write-Host "font-compare: differences found; outputs kept in $work."
	exit 1
}
Write-Host "font-compare: every login matches $Ref."
exit 0
