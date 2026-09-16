<#
.SYNOPSIS
	Fails when Core\ contains class-, spec- or flavor-specific knowledge.

.DESCRIPTION
	Core is the game-lineage-agnostic half of the addon. Everything it knows about classes, specs,
	resources and class bar types must come from the flavor manifest or from spec descriptors the
	flavor's class modules declare. This lint scans Core\**\*.lua (comment lines and doc comments
	stripped) for:
	  * class name tokens (deathknight, druid, priest, ... in any casing, as whole words)
	  * literal class/spec id comparisons (classId == 11, specId ~= 2, ...)
	  * settings-tree class keys (settings.druid, .feral, ...)
	and prints every hit. It exits 1 when there are hits, so CI keeps Core clean once it is.

.PARAMETER Root
	Repository root. Defaults to the parent of this script's folder.

.PARAMETER Allow
	Path to an allow-list file: one regex per line matched against "relative/path:line". Empty by default.
#>
[CmdletBinding()]
param(
	[string]$Root = "",
	[string]$Allow = ""
)

$ErrorActionPreference = "Stop"
# $PSScriptRoot is not populated inside param() defaults on Windows PowerShell 5.1 when run with -File.
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if ($Root -eq "") { $Root = Split-Path -Parent $scriptDir }
$coreDir = Join-Path $Root "Core"
if (-not (Test-Path $coreDir)) { throw "Core directory not found at $coreDir" }

$classTokens = "deathknight|demonhunter|druid|evoker|hunter|mage|monk|paladin|priest|rogue|shaman|warlock|warrior"
$patterns = @(
	@{ Name = "class token";        Regex = "(?i)(?<![A-Za-z0-9_])(" + $classTokens + ")(?![A-Za-z0-9_])" },
	# 0 is "not set yet", not a class or spec id, so comparisons against it are allowed.
	@{ Name = "literal id compare"; Regex = "(?:classId|specId)\s*(?:==|~=)\s*(?!0\b)\d+" },
	@{ Name = "literal id compare"; Regex = "(?<!\d)(?!0\b)\d+\s*(?:==|~=)\s*(?:TRB\.Data\.character\.)?(?:classId|specId)\b" }
)

$allowRules = @()
if ($Allow -and (Test-Path $Allow)) {
	$allowRules = Get-Content $Allow | Where-Object { $_ -and -not $_.StartsWith("#") }
}

$hits = @()
# Localization files hold user-facing text keyed by class modules, not logic, so they are exempt.
Get-ChildItem -Path $coreDir -Recurse -Filter *.lua | Where-Object { $_.FullName -notmatch "[\\/]Core[\\/]Localization[\\/]" } | ForEach-Object {
	$file = $_
	$rel = $file.FullName.Substring($Root.Length).TrimStart("\", "/") -replace "\\", "/"
	$lineNo = 0
	foreach ($line in [System.IO.File]::ReadLines($file.FullName)) {
		$lineNo++
		# Strip comments: whole-line comments, doc comments and trailing "--" comments (crude but
		# sufficient; string literals containing "--" are rare in this code base).
		$code = $line -replace "--.*$", ""
		if ($code.Trim().Length -eq 0) { continue }
		foreach ($p in $patterns) {
			if ($code -match $p.Regex) {
				$key = "${rel}:${lineNo}"
				$allowed = $false
				foreach ($rule in $allowRules) { if ($key -match $rule) { $allowed = $true; break } }
				if (-not $allowed) {
					$hits += [pscustomobject]@{ Location = $key; Kind = $p.Name; Text = $line.Trim() }
				}
				break
			}
		}
	}
}

if ($hits.Count -eq 0) {
	Write-Host "lint-core: Core is clean (no class/spec/flavor-specific references)."
	exit 0
}

Write-Host ("lint-core: {0} class/spec-specific reference(s) in Core:" -f $hits.Count)
$hits | ForEach-Object { Write-Host ("  {0}  [{1}]  {2}" -f $_.Location, $_.Kind, $_.Text) }
$byFile = $hits | Group-Object { ($_.Location -split ":")[0] } | Sort-Object Count -Descending
Write-Host ""
Write-Host "By file:"
$byFile | ForEach-Object { Write-Host ("  {0,4}  {1}" -f $_.Count, $_.Name) }
exit 1
