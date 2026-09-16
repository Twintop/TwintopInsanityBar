<#
.SYNOPSIS
	Smoke-loads every flavor for every class under the stubbed-API harness and fails on real errors.

.DESCRIPTION
	For each flavor TOC (mainline at the repository root, the others under Flavors\<Flavor>\) and each
	class the flavor's manifest declares, runs build\harness\load.lua through ADDON_LOADED. Load errors,
	syntax errors and errors in the synchronous event handlers fail the run; deferred UI construction that
	outruns the stubs (TIMER ERROR lines) is reported as a count only. See build\harness\README.md.

.PARAMETER Lua
	Lua 5.1 interpreter to use. Defaults to "lua5.1" on the PATH.

.PARAMETER Flavor
	Restrict to one flavor (mainline, forever). Default: all.
#>
[CmdletBinding()]
param(
	[string]$Lua = "lua5.1",
	[string]$Flavor = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$harness = Join-Path $scriptDir "harness\load.lua"

if ($null -eq (Get-Command $Lua -ErrorAction SilentlyContinue)) {
	throw "Lua interpreter '$Lua' not found. Install Lua 5.1 or pass -Lua <path>."
}

# Flavor -> TOC path (relative to the repository) and the class ids its manifest declares.
$flavors = @()
Get-ChildItem (Join-Path $root "Flavors") -Directory | ForEach-Object {
	$name = $_.Name
	$id = $name.ToLowerInvariant()
	if ($Flavor -ne "" -and $Flavor.ToLowerInvariant() -ne $id) { return }
	$toc = if ($id -eq "mainline") { "TwintopInsanityBar.toc" } else { "Flavors/$name/TwintopInsanityBar.toc" }
	$manifest = Get-Content (Join-Path $_.FullName "Manifest.lua") -Raw
	$classIds = [regex]::Matches($manifest, "classId\s*=\s*(\d+)") | ForEach-Object { [int]$_.Groups[1].Value } | Sort-Object -Unique
	$flavors += [pscustomobject]@{ Name = $name; Toc = $toc; ClassIds = $classIds }
}

$failed = $false
foreach ($f in $flavors) {
	foreach ($classId in $f.ClassIds) {
		$output = & $Lua $harness $root $f.Toc $classId "ADDON_LOADED" 2>&1 | Out-String
		$real = ($output -split "`n" | Where-Object { $_ -match "^(ERROR|SYNTAX|EVENT ERROR|SNAPSHOT ERROR)" }).Count
		$timers = ($output -split "`n" | Where-Object { $_ -match "^TIMER ERROR" }).Count
		$loaded = ($output -split "`n" | Where-Object { $_ -match "^Loaded " }) -join ""
		if ($real -gt 0 -or $LASTEXITCODE -ne 0 -and $real -gt 0) {
			$failed = $true
			Write-Host ("FAIL  {0,-9} class {1,2}: {2}" -f $f.Name, $classId, $loaded)
			Write-Host ($output -split "`n" | Where-Object { $_ -match "^(ERROR|SYNTAX|EVENT ERROR)" -or $_ -match "^\s+" } | Select-Object -First 12 | Out-String)
		} else {
			Write-Host ("ok    {0,-9} class {1,2}: {2} (deferred UI stub errors: {3})" -f $f.Name, $classId, $loaded.Trim(), $timers)
		}
	}
}

if ($failed) { exit 1 }
Write-Host "smoke: every flavor loads and bootstraps for every class."

exit 0
