<#
.SYNOPSIS
	Stages one flavor of the addon into a clean directory and zips it for release.

.DESCRIPTION
	The repository holds every flavor (game lineage) side by side under Flavors\. A release artifact
	must contain Core, the shared libraries and media, exactly one flavor, and that flavor's TOC at
	the addon root. This script builds that tree under <OutDir>\<Flavor>\TwintopInsanityBar and zips
	it as <OutDir>\TwintopInsanityBar-[<flavor>-]<version>-<releaseType>.zip.

	Runs on Windows PowerShell 5.1 and PowerShell 7 (GitHub-hosted runners included).

.PARAMETER Flavor
	Flavor folder name under Flavors\ (case-insensitive): mainline or forever.

.PARAMETER Version
	Overrides the TOC's "## Version:" in the staged copy (e.g. from a release tag).

.PARAMETER ReleaseType
	Overrides "## X-ReleaseType:" (release, beta, alpha).

.PARAMETER ReleaseDate
	Overrides "## X-ReleaseDate:" (yyyy-MM-dd). Defaults to today when -Version is given.

.PARAMETER TocSuffix
	When the client selects TOC files by suffix (TwintopInsanityBar_<Suffix>.toc), also write the
	flavor TOC under that name next to the plain one.

.PARAMETER OutDir
	Output root. Defaults to <repo>\dist.

.PARAMETER NoZip
	Stage only; skip creating the archive.
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory = $true)][string]$Flavor,
	[string]$Version = "",
	[string]$ReleaseType = "",
	[string]$ReleaseDate = "",
	[string]$TocSuffix = "",
	[string]$OutDir = "",
	[switch]$NoZip
)

$ErrorActionPreference = "Stop"
# $PSScriptRoot is not populated inside param() defaults on Windows PowerShell 5.1 when run with -File.
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$addonName = "TwintopInsanityBar"

# Resolve the flavor folder case-insensitively so "forever" finds "Forever".
$flavorDir = Get-ChildItem -Path (Join-Path $root "Flavors") -Directory | Where-Object { $_.Name -ieq $Flavor } | Select-Object -First 1
if ($null -eq $flavorDir) { throw "Unknown flavor '$Flavor'. Available: " + ((Get-ChildItem (Join-Path $root "Flavors") -Directory | ForEach-Object Name) -join ", ") }
$flavorName = $flavorDir.Name
$flavorId = $flavorName.ToLowerInvariant()

# The mainline TOC lives at the repository root so the checkout works in place as a retail install;
# every other flavor keeps its TOC inside its own folder.
$tocSource = if ($flavorId -eq "mainline") { Join-Path $root "$addonName.toc" } else { Join-Path $flavorDir.FullName "$addonName.toc" }
if (-not (Test-Path $tocSource)) { throw "Flavor TOC not found: $tocSource" }

if ($OutDir -eq "") { $OutDir = Join-Path $root "dist" }
$stageRoot = Join-Path $OutDir $flavorName
$stageDir = Join-Path $stageRoot $addonName
if (Test-Path $stageRoot) { Remove-Item -Recurse -Force $stageRoot }
New-Item -ItemType Directory -Force -Path $stageDir | Out-Null

# Include list, not an exclude list: anything not named here never ships.
$includeDirs = @("Core", "Libs", "Images", "Sounds", "StatusBars")
$includeFiles = @("LICENSE", "README.md")

foreach ($dir in $includeDirs) {
	$src = Join-Path $root $dir
	if (Test-Path $src) { Copy-Item -Recurse -Force $src (Join-Path $stageDir $dir) }
}
foreach ($file in $includeFiles) {
	$src = Join-Path $root $file
	if (Test-Path $src) { Copy-Item -Force $src (Join-Path $stageDir $file) }
}
$flavorsStage = Join-Path $stageDir "Flavors"
New-Item -ItemType Directory -Force -Path $flavorsStage | Out-Null
Copy-Item -Recurse -Force $flavorDir.FullName (Join-Path $flavorsStage $flavorName)
# A flavor folder may carry its own TOC copy; the addon root is the only place the client reads it.
Remove-Item -Force (Join-Path (Join-Path $flavorsStage $flavorName) "$addonName.toc") -ErrorAction SilentlyContinue

# Read + stamp the TOC (BOM + CRLF preserved).
$tocBytes = [System.IO.File]::ReadAllBytes($tocSource)
$hasBom = $tocBytes.Length -ge 3 -and $tocBytes[0] -eq 0xEF -and $tocBytes[1] -eq 0xBB -and $tocBytes[2] -eq 0xBF
$tocText = [System.Text.Encoding]::UTF8.GetString($tocBytes)
if ($hasBom -and $tocText.Length -gt 0 -and [int]$tocText[0] -eq 0xFEFF) { $tocText = $tocText.Substring(1) }

function Get-TocField([string]$text, [string]$field) {
	$m = [regex]::Match($text, "(?m)^## " + [regex]::Escape($field) + ":\s*(.*?)\s*$")
	if ($m.Success) { return $m.Groups[1].Value } else { return "" }
}
function Set-TocField([string]$text, [string]$field, [string]$value) {
	$pattern = "(?m)^(## " + [regex]::Escape($field) + ":\s*)(.*?)(\s*)$"
	if ([regex]::IsMatch($text, $pattern)) {
		return [regex]::Replace($text, $pattern, { param($m) $m.Groups[1].Value + $value }, 1)
	}
	return $text
}

if ($Version -ne "") {
	$tocText = Set-TocField $tocText "Version" $Version
	if ($ReleaseDate -eq "") { $ReleaseDate = (Get-Date).ToString("yyyy-MM-dd") }
}
if ($ReleaseType -ne "") { $tocText = Set-TocField $tocText "X-ReleaseType" $ReleaseType }
if ($ReleaseDate -ne "") { $tocText = Set-TocField $tocText "X-ReleaseDate" $ReleaseDate }

$tocFlavor = Get-TocField $tocText "X-Flavor"
if ($tocFlavor -ne "" -and $tocFlavor -ne $flavorId) { throw "TOC X-Flavor '$tocFlavor' does not match staged flavor '$flavorId'" }
$finalVersion = Get-TocField $tocText "Version"
$finalReleaseType = Get-TocField $tocText "X-ReleaseType"
if ($finalReleaseType -eq "") { $finalReleaseType = "release" }

$utf8Bom = New-Object System.Text.UTF8Encoding($true)
$tocOut = $tocText -replace "`r?`n", "`r`n"
[System.IO.File]::WriteAllText((Join-Path $stageDir "$addonName.toc"), $tocOut, $utf8Bom)
if ($TocSuffix -ne "") {
	[System.IO.File]::WriteAllText((Join-Path $stageDir ("{0}_{1}.toc" -f $addonName, $TocSuffix)), $tocOut, $utf8Bom)
}

Write-Host ("Staged {0} ({1} {2}) at {3}" -f $flavorName, $finalVersion, $finalReleaseType, $stageDir)

if ($NoZip) { exit 0 }

$flavorTag = if ($flavorId -eq "mainline") { "" } else { "$flavorId-" }
$zipName = "{0}-{1}{2}-{3}.zip" -f $addonName, $flavorTag, $finalVersion, $finalReleaseType
$zipPath = Join-Path $OutDir $zipName
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }

# Build the archive entry by entry with forward-slash names so every extractor (including macOS)
# reproduces the folder tree; Compress-Archive on Windows PowerShell 5.1 writes backslashes.
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($zipPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
	$prefixLen = $stageRoot.TrimEnd("\", "/").Length + 1
	Get-ChildItem -Path $stageDir -Recurse -File | Sort-Object FullName | ForEach-Object {
		$entryName = $_.FullName.Substring($prefixLen) -replace "\\", "/"
		[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $entryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
	}
}
finally {
	$zip.Dispose()
}

Write-Host ("Wrote {0} ({1:N0} bytes)" -f $zipPath, (Get-Item $zipPath).Length)
# Emit the path last on its own line so callers (CI) can capture it.
Write-Output $zipPath
