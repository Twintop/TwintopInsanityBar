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
	    its classes declare, the bar types it registers, the snapshot attributes its descriptors point
	    Core at, its shapeshift form condition keys and form names, and its threshold categories. The
	    resource types and bar types of Core's own bars (coreResourceTypes, RegisterBuiltInTypes) are Core's.
	  * literal spell ids (id = 372608, spellId == 61304, GCD_SPELL = 61304, [372608] = ..., C_Spell.X(61304))
	It also fails when a flavor declares a resourceType that neither its Resources.lua nor Core names.
	It prints every hit and exits 1 when there are any, so CI keeps Core clean once it is. A line whose
	comment reads "lint-core: allow (<reason>)" is skipped, for a word that only collides with flavor vocabulary.

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
# Descriptors and bar group configurations: the only files whose *Attribute values name snapshot attributes.
$classFiles = $flavorFiles | Where-Object { $_.FullName -match "[\\/]ClassModules[\\/](Classes|Templates)[\\/]" }

# The text between the braces of every "<name> = { ... }" table in a file.
function Get-TableBodies([string]$text, [string]$name) {
	$bodies = @()
	foreach ($m in [regex]::Matches($text, "(?<!\w)" + [regex]::Escape($name) + "\s*=\s*\{")) {
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

# Case-sensitive, like the identifiers it holds.
$vocabulary = [hashtable]::new()
# Per flavor, the resourceType tokens its files declare (with where) and the ones its Resources.lua names.
$declaredTypes = @{}
$namedTypes = @{}
foreach ($file in $flavorFiles) {
	$text = [System.IO.File]::ReadAllText($file.FullName)
	$flavor = ($file.FullName.Substring($flavorsDir.Length).TrimStart("\", "/") -split "[\\/]")[0]
	if (-not $declaredTypes.ContainsKey($flavor)) { $declaredTypes[$flavor] = @(); $namedTypes[$flavor] = [hashtable]::new() }
	foreach ($m in [regex]::Matches($text, 'resourceType\s*=\s*"(\w+)"')) {
		$vocabulary[$m.Groups[1].Value] = $true
		$line = ($text.Substring(0, $m.Index) -split "`n").Count
		$declaredTypes[$flavor] += [pscustomobject]@{ Token = $m.Groups[1].Value; Location = ($file.FullName.Substring($Root.Length).TrimStart("\", "/") -replace "\\", "/") + ":" + $line }
	}
	foreach ($body in (Get-TableBodies $text "resourceTypes")) {
		foreach ($key in (Get-TopLevelKeys $body)) { $vocabulary[$key] = $true; $namedTypes[$flavor][$key] = $true }
	}
	foreach ($body in (Get-TableBodies $text "visibilityConditions")) {
		foreach ($m in [regex]::Matches($body, 'key\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
		foreach ($forms in (Get-TableBodies $body "forms")) { foreach ($key in (Get-TopLevelKeys $forms)) { $vocabulary[$key] = $true } }
	}
	foreach ($m in [regex]::Matches($text, 'defaultForm\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
	foreach ($m in [regex]::Matches($text, 'BarTypeDefinition:New\(\{\s*key\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
	foreach ($body in (Get-TableBodies $text "thresholdCategories")) { foreach ($key in (Get-TopLevelKeys $body)) { $vocabulary[$key] = $true } }
}
# Snapshot attributes a descriptor or bar group configuration names for Core to read (thresholdValueAttribute, ...).
foreach ($file in $classFiles) {
	foreach ($m in [regex]::Matches([System.IO.File]::ReadAllText($file.FullName), '\w*Attribute\s*=\s*"(\w+)"')) { $vocabulary[$m.Groups[1].Value] = $true }
}
$coreTypes = [hashtable]::new()
foreach ($file in $coreFiles) {
	$text = [System.IO.File]::ReadAllText($file.FullName)
	foreach ($m in [regex]::Matches($text, 'resourceType\s*=\s*"(\w+)"')) { $coreTypes[$m.Groups[1].Value] = $true }
	foreach ($body in (Get-TableBodies $text "coreResourceTypes")) { foreach ($key in (Get-TopLevelKeys $body)) { $coreTypes[$key] = $true } }
	foreach ($m in [regex]::Matches($text, 'BarTypeDefinition:New\(\{\s*key\s*=\s*"(\w+)"')) { $coreTypes[$m.Groups[1].Value] = $true }
}
foreach ($key in @($coreTypes.Keys)) { $vocabulary.Remove($key) }

$classTokens = "deathknight|demonhunter|druid|evoker|hunter|mage|monk|paladin|priest|rogue|shaman|warlock|warrior"
$patterns = @(
	@{ Name = "class token";        Regex = "(?i)(?<![A-Za-z0-9_])(" + $classTokens + ")(?![A-Za-z0-9_])" },
	# 0 is "not set yet", not a class or spec id, so comparisons against it are allowed.
	@{ Name = "literal id compare"; Regex = "(?i)(?:classId|specId)\s*(?:==|~=)\s*(?!0\b)\d+" },
	@{ Name = "literal id compare"; Regex = "(?i)(?<!\d)(?!0\b)\d+\s*(?:==|~=)\s*(?:TRB\.Data\.character\.)?(?:classId|specId)\b" },
	@{ Name = "literal spell id";   Regex = "(?i)\b(?:\w*spell)?id\s*(?:=|==|~=)\s*\d{3,}" },
	@{ Name = "literal spell id";   Regex = "(?i)\b\w*(?:spell|buff|debuff|talent|aura)\w*\s*(?:=|==|~=)\s*\d{4,}" },
	@{ Name = "literal spell id";   Regex = "\[\s*\d{4,}\s*\]\s*=" },
	@{ Name = "literal spell id";   Regex = "(?:\b(?:C_Spell|C_SpellBook|C_UnitAuras)\.\w+|\b(?:IsPlayerSpell|IsSpellKnown\w*|GetSpell\w*|FindSpell\w*))\(\s*\d{3,}" }
)
if ($vocabulary.Count -gt 0) {
	$words = ($vocabulary.Keys | Sort-Object | ForEach-Object { [regex]::Escape($_) }) -join "|"
	# Case-sensitive, since the tokens are identifiers. Enums are stripped first: Core's power type map names every Enum.PowerType member.
	$patterns += @{ Name = "flavor vocabulary"; Regex = '(?-i)"(?:' + $words + ')"|''(?:' + $words + ')''|(?<![\w.:])(?:' + $words + ')\s*=(?!=)|\.(?:' + $words + ')\b'; StripEnums = $true }
}

$allowRules = @()
if ($Allow -and (Test-Path $Allow)) {
	$allowRules = Get-Content $Allow | Where-Object { $_ -and -not $_.StartsWith("#") }
}

$hits = @()
foreach ($flavor in $declaredTypes.Keys) {
	foreach ($declared in $declaredTypes[$flavor]) {
		if (-not $namedTypes[$flavor].ContainsKey($declared.Token) -and -not $coreTypes.ContainsKey($declared.Token)) {
			$hits += [pscustomobject]@{ Location = $declared.Location; Kind = "unnamed resource type"; Text = $declared.Token + " has no Flavors/" + $flavor + "/Resources.lua entry" }
		}
	}
}
$coreFiles | ForEach-Object {
	$file = $_
	$rel = $file.FullName.Substring($Root.Length).TrimStart("\", "/") -replace "\\", "/"
	$lineNo = 0
	foreach ($line in [System.IO.File]::ReadLines($file.FullName)) {
		$lineNo++
		if ($line -match "--\s*lint-core:\s*allow\b") { continue }
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
