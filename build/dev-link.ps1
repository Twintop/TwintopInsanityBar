<#
.SYNOPSIS
	Links a game client's AddOns folder to this repository for one flavor, for live development.

.DESCRIPTION
	Creates <AddOnsPath>\TwintopInsanityBar as a real folder containing directory junctions
	(mklink /J; no administrator rights needed) back to the repository's Core, Libs, media and Flavors
	folders, plus a copy of the flavor's TOC. Edits in the repository are live in the client; the TOC
	is the only copied file, so re-run this after changing it.

	Because each client gets its own folder with its own TOC, one checkout can serve several clients
	at once (e.g. _retail_ with -Flavor mainline and a Forever install with -Flavor forever). The
	mainline flavor does not strictly need this: the checkout works in place as a retail install.

.PARAMETER Flavor
	Flavor folder name under Flavors\ (case-insensitive): mainline or forever.

.PARAMETER AddOnsPath
	The client's Interface\AddOns folder, e.g. "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns".

.PARAMETER TocSuffix
	Also write the TOC as TwintopInsanityBar_<Suffix>.toc, for clients that select TOCs by suffix.

.PARAMETER Remove
	Remove the linked folder (junctions are unlinked, never followed).

.EXAMPLE
	.\build\dev-link.ps1 -Flavor forever -AddOnsPath "C:\Program Files (x86)\World of Warcraft\_forever_retail_\Interface\AddOns"
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory = $true)][string]$Flavor,
	[Parameter(Mandatory = $true)][string]$AddOnsPath,
	[string]$TocSuffix = "",
	[switch]$Remove
)

$ErrorActionPreference = "Stop"
# $PSScriptRoot is not populated inside param() defaults on Windows PowerShell 5.1 when run with -File.
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$addonName = "TwintopInsanityBar"
$target = Join-Path $AddOnsPath $addonName

if ((Resolve-Path $root).Path.TrimEnd("\") -ieq $target.TrimEnd("\")) {
	throw "The repository already is $target; nothing to link."
}

function Remove-LinkedFolder([string]$path) {
	if (-not (Test-Path $path)) { return }
	# Delete junctions with rmdir so their targets are never touched, then the remaining plain files.
	Get-ChildItem -Path $path -Force | ForEach-Object {
		if ($_.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
			cmd /c rmdir "$($_.FullName)" | Out-Null
		} elseif ($_.PSIsContainer) {
			throw "Refusing to remove $($_.FullName): it is a real folder, not a junction. Remove it by hand if that is intended."
		} else {
			Remove-Item -Force $_.FullName
		}
	}
	cmd /c rmdir "$path" | Out-Null
}

if ($Remove) {
	Remove-LinkedFolder $target
	Write-Host "Removed $target"
	exit 0
}

$flavorDir = Get-ChildItem -Path (Join-Path $root "Flavors") -Directory | Where-Object { $_.Name -ieq $Flavor } | Select-Object -First 1
if ($null -eq $flavorDir) { throw "Unknown flavor '$Flavor'." }
$flavorId = $flavorDir.Name.ToLowerInvariant()
$tocSource = if ($flavorId -eq "mainline") { Join-Path $root "$addonName.toc" } else { Join-Path $flavorDir.FullName "$addonName.toc" }
if (-not (Test-Path $tocSource)) { throw "Flavor TOC not found: $tocSource" }

if (Test-Path $target) {
	$item = Get-Item $target -Force
	if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
		# A whole-repo junction from an earlier setup; replace it with the per-flavor layout.
		cmd /c rmdir "$target" | Out-Null
	} else {
		Remove-LinkedFolder $target
	}
}
New-Item -ItemType Directory -Force -Path $target | Out-Null

# Flavors is linked whole (the TOC only references its own flavor, so the others are inert) which keeps
# the junction list short and lets the TOC use the same Flavors\<Flavor>\... paths as the repository.
$links = @("Core", "Libs", "Images", "Sounds", "StatusBars", "Flavors")
foreach ($name in $links) {
	$src = Join-Path $root $name
	if (-not (Test-Path $src)) { continue }
	cmd /c mklink /J "$(Join-Path $target $name)" "$src" | Out-Null
	if ($LASTEXITCODE -ne 0) { throw "mklink failed for $name" }
}
foreach ($file in @("LICENSE", "README.md")) {
	$src = Join-Path $root $file
	if (Test-Path $src) { Copy-Item -Force $src (Join-Path $target $file) }
}
Copy-Item -Force $tocSource (Join-Path $target "$addonName.toc")
if ($TocSuffix -ne "") {
	Copy-Item -Force $tocSource (Join-Path $target ("{0}_{1}.toc" -f $addonName, $TocSuffix))
}

Write-Host ("Linked {0} ({1}) -> {2}" -f $target, $flavorDir.Name, $root)
Get-ChildItem $target -Force | ForEach-Object {
	$kind = if ($_.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { "junction" } elseif ($_.PSIsContainer) { "folder" } else { "file" }
	Write-Host ("  {0,-8} {1}" -f $kind, $_.Name)
}
