<#
.SYNOPSIS
	Runs the harness's check drivers for both flavors and fails on any FAIL or error.

.DESCRIPTION
	options-tabs builds every options tab for every class and runs the Textures tab checks; it runs once per flavor.
	media-pickup checks that fonts, textures, and sounds that aren't loaded draw the default and are picked up live;
	it runs once per class.
	colors checks color conversion, color curves, class colors, and VertexColor animations; it runs once per flavor.
	threshold-behavior checks the threshold line cooldown tracker; it runs once per class.
	range-checks checks that range checks stay on after a loading screen, a talent change, and a specialization change;
	it runs once per class. See build\harness\README.md.

.PARAMETER Lua
	Lua 5.1 interpreter to use. Defaults to "lua5.1" on the PATH.

.PARAMETER Driver
	Restrict to one driver (options-tabs, media-pickup, colors, threshold-behavior, range-checks). Default: all.

.PARAMETER Flavor
	Restrict to one flavor (mainline, forever). Default: all.

.PARAMETER AddonDir
	The addon checkout to load. Defaults to this repository; point it at another checkout to run these drivers there.
#>
[CmdletBinding()]
param(
	[string]$Lua = "lua5.1",
	[string]$Driver = "",
	[string]$Flavor = "",
	[string]$AddonDir = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$harness = Join-Path $scriptDir "harness\load.lua"
if ($AddonDir -eq "") { $AddonDir = $root }

if ($null -eq (Get-Command $Lua -ErrorAction SilentlyContinue)) {
	throw "Lua interpreter '$Lua' not found. Install Lua 5.1 or pass -Lua <path>."
}

$drivers = @(
	[pscustomobject]@{ Name = "options-tabs"; EveryClass = $false },
	[pscustomobject]@{ Name = "media-pickup"; EveryClass = $true },
	[pscustomobject]@{ Name = "colors"; EveryClass = $false },
	[pscustomobject]@{ Name = "threshold-behavior"; EveryClass = $true },
	[pscustomobject]@{ Name = "range-checks"; EveryClass = $true }
)
$known = $drivers | ForEach-Object { $_.Name }
if ($Driver -ne "" -and $known -notcontains $Driver) {
	throw "Unknown driver '$Driver'. Valid: $($known -join ', ')."
}

# Flavor -> TOC path (relative to the addon) and the class ids its manifest declares.
$flavors = @()
Get-ChildItem (Join-Path $AddonDir "Flavors") -Directory | ForEach-Object {
	$name = $_.Name
	$id = $name.ToLowerInvariant()
	if ($Flavor -ne "" -and $Flavor.ToLowerInvariant() -ne $id) { return }
	$toc = if ($id -eq "mainline") { "TwintopInsanityBar.toc" } else { "Flavors/$name/TwintopInsanityBar.toc" }
	$manifest = Get-Content (Join-Path $_.FullName "Manifest.lua") -Raw
	$classIds = [regex]::Matches($manifest, "classId\s*=\s*(\d+)") | ForEach-Object { [int]$_.Groups[1].Value } | Sort-Object -Unique
	$flavors += [pscustomobject]@{ Name = $name; Toc = $toc; ClassIds = $classIds }
}
if ($flavors.Count -eq 0) {
	throw "Unknown flavor '$Flavor'. Valid: mainline, forever."
}

$failed = $false
foreach ($d in $drivers) {
	if ($Driver -ne "" -and $Driver -ne $d.Name) { continue }
	$env:TRB_DRIVER = Join-Path $scriptDir "harness\drivers\$($d.Name).lua"
	try {
		foreach ($f in $flavors) {
			# options-tabs builds every class's panels from one login, so any class does.
			$classIds = if ($d.EveryClass) { $f.ClassIds } else { @($f.ClassIds[0]) }
			foreach ($classId in $classIds) {
				$output = & $Lua $harness $AddonDir $f.Toc $classId "ADDON_LOADED,PLAYER_LOGIN,PLAYER_ENTERING_WORLD" 2>&1 | Out-String
				$lines = $output -split "`r?`n"
				$pass = ($lines | Where-Object { $_ -match "^PASS " }).Count
				$fail = ($lines | Where-Object { $_ -match "^FAIL " }).Count
				$errors = $lines | Where-Object { $_ -match "^(ERROR|SYNTAX|EVENT ERROR|DRIVER ERROR|TAB ERROR)" }
				$summary = ($lines | Where-Object { $_ -match "^TABDRIVER " }) -join ""
				if ($fail -gt 0 -or $errors.Count -gt 0 -or $pass -eq 0) {
					$failed = $true
					Write-Host ("FAIL  {0,-12} {1,-9} class {2,2}: {3} passed, {4} failed {5}" -f $d.Name, $f.Name, $classId, $pass, $fail, $summary)
					# Each FAIL, and each real error with its traceback; the stubs' TIMER ERROR tracebacks are informational.
					$shown = 0
					$inError = $false
					foreach ($line in $lines) {
						if ($line -match "^(ERROR|SYNTAX|EVENT ERROR|DRIVER ERROR|TAB ERROR)") {
							$inError = $true
						} elseif ($line -notmatch "^\s") {
							$inError = $false
						}
						if (($inError -or $line -match "^FAIL ") -and $shown -lt 30) {
							Write-Host "    $line"
							$shown++
						}
					}
				} else {
					Write-Host ("ok    {0,-12} {1,-9} class {2,2}: {3} passed {4}" -f $d.Name, $f.Name, $classId, $pass, $summary)
				}
			}
		}
	} finally {
		Remove-Item Env:TRB_DRIVER -ErrorAction SilentlyContinue
	}
}

if ($failed) { exit 1 }
Write-Host "drivers: every check passed."
exit 0
