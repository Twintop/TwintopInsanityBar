<#
.SYNOPSIS
	Fails when a locale file gains a string anywhere but its end.

.DESCRIPTION
	Translators work from the tail of each locale file, so a new string goes after every existing one, and a
	changed string is removed where it was and added again at the end. This compares each locale file
	(Core\Localization\xxXX.lua) with where the branch left its base, and fails when an added line has an
	original string line still after it: an addition in the middle, or a string edited in place. Removals are
	fine anywhere. Lines after the last string, such as a locale block's closing "end", don't count.

.PARAMETER Base
	The ref the change is measured from, compared at its merge base with HEAD. Defaults to origin/<the pull
	request's base branch> on GitHub, otherwise origin/main. A stacked branch passes the branch below it.

.PARAMETER Root
	Repository root. Defaults to the parent of this script's folder.
#>
[CmdletBinding()]
param(
	[string]$Base = "",
	[string]$Root = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if ($Root -eq "") { $Root = Split-Path -Parent $scriptDir }
if ($Base -eq "") {
	$Base = if ($env:GITHUB_BASE_REF) { "origin/$($env:GITHUB_BASE_REF)" } else { "origin/main" }
}

Push-Location $Root
try {
	$mergeBase = (git merge-base $Base HEAD 2>$null)
	if ($LASTEXITCODE -ne 0 -or -not $mergeBase) { throw "No merge base between $Base and HEAD. Fetch $Base, or pass -Base." }
	$mergeBase = $mergeBase.Trim()

	$stringLine = '^\s*L\['
	$problems = @()
	$checked = 0
	$files = Get-ChildItem -Path (Join-Path $Root "Core/Localization") -Filter *.lua | Where-Object { $_.Name -cmatch '^[a-z]{2}[A-Z]{2}\.lua$' }
	foreach ($file in $files) {
		$rel = "Core/Localization/$($file.Name)"
		$baseText = git show "${mergeBase}:$rel" 2>$null
		if ($LASTEXITCODE -ne 0) { continue }
		$checked++
		$baseLines = @($baseText)

		# Each hunk as old start/count and new start/count, with its added lines.
		$hunks = @()
		$current = $null
		foreach ($line in (git diff -U0 --no-color --no-ext-diff $mergeBase -- $rel)) {
			if ($line -match '^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@') {
				$current = [pscustomobject]@{
					OldStart = [int]$Matches[1]; OldCount = if ($Matches[2] -ne $null) { [int]$Matches[2] } else { 1 }
					NewStart = [int]$Matches[3]; Added = @()
				}
				$hunks += $current
			} elseif ($current -ne $null -and $line.StartsWith("+") -and -not $line.StartsWith("+++")) {
				$current.Added += $line.Substring(1)
			}
		}

		$removed = @{}
		foreach ($hunk in $hunks) {
			for ($i = 0; $i -lt $hunk.OldCount; $i++) { $removed[$hunk.OldStart + $i] = $true }
		}
		foreach ($hunk in $hunks) {
			if ($hunk.Added.Count -eq 0) { continue }
			# Base lines after the hunk, 1-based; a pure insertion goes after OldStart.
			$after = if ($hunk.OldCount -eq 0) { $hunk.OldStart + 1 } else { $hunk.OldStart + $hunk.OldCount }
			$survivor = $null
			for ($n = $after; $n -le $baseLines.Count; $n++) {
				if (-not $removed[$n] -and $baseLines[$n - 1] -match $stringLine) { $survivor = $n; break }
			}
			if ($survivor -eq $null) { continue }
			for ($i = 0; $i -lt $hunk.Added.Count; $i++) {
				if ($hunk.Added[$i] -match $stringLine) {
					$text = $hunk.Added[$i].Trim()
					if ($text.Length -gt 90) { $text = $text.Substring(0, 90) + "..." }
					$problems += "${rel}:$($hunk.NewStart + $i): added before existing strings (first is old line ${survivor}): $text"
				}
			}
		}
	}
} finally {
	Pop-Location
}

if ($problems.Count -gt 0) {
	Write-Host "locale-check: strings must be added at the end of a locale file; a changed string is removed and added again there."
	$problems | ForEach-Object { Write-Host "  $_" }
	exit 1
}
Write-Host "locale-check: $checked locale file(s) only add strings at the end, against $Base."
