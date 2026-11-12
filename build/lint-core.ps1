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
	  * vocabulary only a flavor may name, as a string, a table key, or a field: the resourceType tokens
	    its classes declare, the snapshot attributes its descriptors point Core at, its shapeshift form
	    condition keys, and its threshold categories. The resource types of Core's own bars
	    (coreResourceTypes) are Core's.
	  * literal spell ids (id = 372608, spellId = 61304)
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
$flavorsDir = Join-Path $Root "Flavors"
if (-not (Test-Path $flavorsDir)) { throw "Flavors directory not found at $flavorsDir" }

# Localization files hold user-facing text keyed by class modules, not logic, so they are exempt.
$coreFiles = Get-ChildItem -Path $coreDir -Recurse -Filter *.lua | Where-Object { $_.FullName -notmatch "[\\/]Core[\\/]Localization[\\/]" }
$flavorFiles = Get-ChildItem -Path $flavorsDir -Recurse -Filter *.lua

# The text between the braces of every "<name> = { ... }" table in a file.
function Get-TableBodies([string]$text, [string]$name) {
	$bodies = @()
	foreach ($m in [regex]::Matches($text, "(?<![\w.])" + [regex]::Escape($name) + "\s*=\s*\{")) {
		$depth = 1
		$i = $m.Index + $m.Length
		$start = $i
		while ($i -lt $text.Length -and $depth -gt 0) {
			if ($text[$i] -eq "{") { $depth++ } elseif ($text[$i] -eq "}") { $depth-- }
			$i++
		}
		$bodies += $text.Substring($start, $i - $start - 1)
	}
	return $bodies
}

# The keys a table body assigns at its own level.
function Get-TopLevelKeys([string]$body) {
	$keys = @()
	$depth = 0
	foreach ($m in [regex]::Matches($body, "[{}]|(?<![\w.])([A-Za-z_]\w*)\s*=(?!=)")) {
		if ($m.Value -eq "{") { $depth++ } elseif ($m.Value -eq "}") { $depth-- } elseif ($depth -eq 0) { $keys += $m.Groups[1].Value }
	}
	return $keys
}

$vocabulary = @{}
foreach ($file in $flavorFiles) {
	$text = [System.IO.File]::ReadAllText($file.FullName)
	foreach ($m in [regex]::Matches($text, 'resourceType\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
	# Snapshot attributes a descriptor names for Core to read (thresholdValueAttribute, compressedStacksAttribute, ...).
	foreach ($m in [regex]::Matches($text, '\w*Attribute\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
	foreach ($body in (Get-TableBodies $text "resourceTypes")) { foreach ($key in (Get-TopLevelKeys $body)) { $vocabulary[$key] = $true } }
	foreach ($body in (Get-TableBodies $text "visibilityConditions")) {
		foreach ($m in [regex]::Matches($body, 'key\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
	}
	foreach ($body in (Get-TableBodies $text "thresholdCategories")) { foreach ($key in (Get-TopLevelKeys $body)) { $vocabulary[$key] = $true } }
}
foreach ($file in $coreFiles) {
	$text = [System.IO.File]::ReadAllText($file.FullName)
	foreach ($m in [regex]::Matches($text, 'resourceType\s*=\s*"(\w+)"')) { $vocabulary.Remove($m.Groups[1].Value) }
	foreach ($body in (Get-TableBodies $text "coreResourceTypes")) { foreach ($key in (Get-TopLevelKeys $body)) { $vocabulary.Remove($key) } }
}

$classTokens = "deathknight|demonhunter|druid|evoker|hunter|mage|monk|paladin|priest|rogue|shaman|warlock|warrior"
$patterns = @(
	@{ Name = "class token";        Regex = "(?i)(?<![A-Za-z0-9_])(" + $classTokens + ")(?![A-Za-z0-9_])" },
	# 0 is "not set yet", not a class or spec id, so comparisons against it are allowed.
	@{ Name = "literal id compare"; Regex = "(?i)(?:classId|specId)\s*(?:==|~=)\s*(?!0\b)\d+" },
	@{ Name = "literal id compare"; Regex = "(?i)(?<!\d)(?!0\b)\d+\s*(?:==|~=)\s*(?:TRB\.Data\.character\.)?(?:classId|specId)\b" },
	@{ Name = "literal spell id";   Regex = "(?i)\b(?:\w*spell)?id\s*=\s*\d{3,}" }
)
if ($vocabulary.Count -gt 0) {
	$words = ($vocabulary.Keys | Sort-Object | ForEach-Object { [regex]::Escape($_) }) -join "|"
	# Case-sensitive: the tokens are identifiers. Client enums (Enum.PowerType.Mana) are stripped before matching.
	$patterns += @{ Name = "flavor vocabulary"; Regex = '(?-i)"(?:' + $words + ')"|(?<![\w.:])(?:' + $words + ')\s*=(?!=)|\.(?:' + $words + ')\b'; StripEnums = $true }
}

$allowRules = @()
if ($Allow -and (Test-Path $Allow)) {
	$allowRules = Get-Content $Allow | Where-Object { $_ -and -not $_.StartsWith("#") }
}

$hits = @()
$coreFiles | ForEach-Object {
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
			$subject = if ($p.StripEnums) { $code -replace "Enum\.\w+\.\w+", "" } else { $code }
			if ($subject -cmatch $p.Regex) {
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
	Write-Host ("lint-core: Core is clean (no class/spec/flavor-specific references; {0} flavor vocabulary words checked)." -f $vocabulary.Count)
	exit 0
}

Write-Host ("lint-core: {0} class/spec-specific reference(s) in Core:" -f $hits.Count)
$hits | ForEach-Object { Write-Host ("  {0}  [{1}]  {2}" -f $_.Location, $_.Kind, $_.Text) }
$byFile = $hits | Group-Object { ($_.Location -split ":")[0] } | Sort-Object Count -Descending
Write-Host ""
Write-Host "By file:"
$byFile | ForEach-Object { Write-Host ("  {0,4}  {1}" -f $_.Count, $_.Name) }
exit 1
