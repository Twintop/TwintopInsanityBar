<#
.SYNOPSIS
	Compares every bar text change through a scripted scenario between a git ref and this checkout.

.DESCRIPTION
	Checks the ref out to a temporary worktree, then logs in once per specialization of every class in each flavor on
	both trees, with the current harness and its bartext-render driver, and diffs the text each bar text string shows
	after every frame of the scenario. Fails when any login differs. See build\harness\README.md.

.PARAMETER Lua
	Lua 5.1 interpreter to use. Defaults to "lua5.1" on the PATH.

.PARAMETER Ref
	The git ref to compare against. Default: main.

.PARAMETER Saved
	A WoW SavedVariables file to log in with. Default: none, a fresh install.

.PARAMETER Flavor
	Restrict to one flavor (mainline, forever, classic, tbc). Default: all.

.PARAMETER SaveEntriesOnly
	Skip the driver's own bar text entries, so only the save's entries show and their unused variables stay unused.
#>
[CmdletBinding()]
param(
	[string]$Lua = "lua5.1",
	[string]$Ref = "main",
	[string]$Saved = "",
	[string]$Flavor = "",
	[switch]$SaveEntriesOnly
)

$ErrorActionPreference = "Stop"
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$harness = Join-Path $scriptDir "harness\load.lua"
$driver = Join-Path $scriptDir "harness\drivers\bartext-render.lua"

if ($null -eq (Get-Command $Lua -ErrorAction SilentlyContinue)) {
	throw "Lua interpreter '$Lua' not found. Install Lua 5.1 or pass -Lua <path>."
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
	throw "Unknown flavor '$Flavor'. Valid: mainline, forever, classic, tbc."
}

$work = Join-Path ([System.IO.Path]::GetTempPath()) ("trb-render-compare-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
$refDir = Join-Path $work "ref"
$outDir = Join-Path $work "renders"
New-Item -ItemType Directory -Force $outDir | Out-Null
& git -C $root worktree add --detach --quiet $refDir $Ref
if ($LASTEXITCODE -ne 0) {
	throw "Could not check out '$Ref' to $refDir."
}

$failed = $false
try {
	$saveName = if ($Saved -eq "") { "fresh" } else { "saved" }
	$savePath = if ($Saved -eq "") { "" } else { (Resolve-Path $Saved).Path }
	$events = "ADDON_LOADED,PLAYER_LOGIN,PLAYER_ENTERING_WORLD"
	foreach ($f in $flavors) {
		$changes = 0
		$differing = @()
		$missing = @()
		foreach ($login in $f.Logins) {
			$renders = @{}
			foreach ($tree in @(@("ref", $refDir), @("work", $root))) {
				$out = Join-Path $outDir ("{0}_{1}_{2}_{3}_{4}.txt" -f $tree[0], $saveName, $f.Name, $login.ClassId, $login.SpecId)
				$env:TRB_DRIVER = $driver
				$env:TRB_SAVED = $savePath
				$env:TRB_SPEC = [string]$login.SpecId
				$env:TRB_RENDER_OUT = $out
				$env:TRB_RENDER_SAVE_ONLY = if ($SaveEntriesOnly) { "1" } else { "" }
				try {
					& $Lua $harness $tree[1] $f.Toc $login.ClassId $events *> "$out.log"
				} finally {
					Remove-Item Env:TRB_DRIVER, Env:TRB_SAVED, Env:TRB_SPEC, Env:TRB_RENDER_OUT, Env:TRB_RENDER_SAVE_ONLY -ErrorAction SilentlyContinue
				}
				# The comma keeps an empty file's empty array from unrolling to $null, which would read as no output.
				$renders[$tree[0]] = if (Test-Path $out) { , @(Get-Content $out) } else { $null }
			}
			$label = "class {0} spec {1}" -f $login.ClassId, $login.SpecId
			if ($null -eq $renders["ref"] -or $null -eq $renders["work"]) {
				$missing += $label
				continue
			}
			$changes += $renders["ref"].Count
			if (($renders["ref"] -join "`n") -ne ($renders["work"] -join "`n")) {
				$first = 0
				while ($first -lt [Math]::Max($renders["ref"].Count, $renders["work"].Count) -and $renders["ref"][$first] -eq $renders["work"][$first]) { $first++ }
				$differing += "$label`: $Ref=$($renders['ref'][$first]) | work=$($renders['work'][$first])"
			}
		}
		$state = if ($differing.Count -eq 0 -and $missing.Count -eq 0) { "ok  " } else { "FAIL"; $failed = $true }
		Write-Host ("{0}  {1,-9} {2,-9} logins={3} lines={4} differing={5} noOutput={6}" -f $state, $saveName, $f.Name, $f.Logins.Count, $changes, $differing.Count, $missing.Count)
		$differing | Select-Object -First 5 | ForEach-Object { Write-Host "    $_" }
		$missing | Select-Object -First 3 | ForEach-Object { Write-Host "    no render written: $_ (logs in $outDir)" }
	}
} finally {
	& git -C $root worktree remove --force $refDir | Out-Null
	if (-not $failed) {
		Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
	}
}

if ($failed) {
	Write-Host "render-compare: differences found; outputs kept in $work."
	exit 1
}
Write-Host "render-compare: every login matches $Ref."
exit 0
