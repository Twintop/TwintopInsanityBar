<#
.SYNOPSIS
	Runs the LuaLS type check over the addon and fails on any diagnostic missing from the baseline.

.DESCRIPTION
	Copies every tracked Lua file into a temporary folder with build\luals\config.json as its .luarc.json
	(the --configpath switch drops workspace.library, so the config has to sit inside the checked folder),
	runs lua-language-server --check, and compares Error, Warning, and Information diagnostics against
	build\luals\baseline.json. The baseline matches on file, code, and message with a count, not line numbers,
	so unrelated edits that move a known warning don't fail the check. Hints are ignored.

.PARAMETER LuaLS
	The lua-language-server executable. Defaults to the one on the PATH, then the newest sumneko.lua VS Code extension.

.PARAMETER WowApi
	The Annotations\Core folder of Ketho's WoW API annotations. Defaults to the newest ketho.wow-api VS Code extension.

.PARAMETER UpdateBaseline
	Writes the current diagnostics as the new baseline instead of comparing.
#>
[CmdletBinding()]
param(
	[string]$LuaLS = "",
	[string]$WowApi = "",
	[switch]$UpdateBaseline
)

$ErrorActionPreference = "Stop"
# CI shows only the calling line for a script error, so name the failing line here.
trap {
	Write-Host "luals: $($_.Exception.Message)"
	Write-Host $_.InvocationInfo.PositionMessage
	exit 1
}
$scriptDir =if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$root = Split-Path -Parent $scriptDir
$configPath = Join-Path $scriptDir "luals/config.json"
$baselinePath = Join-Path $scriptDir "luals/baseline.json"
$extensions = Join-Path $HOME ".vscode/extensions"

if ($LuaLS -eq "") {
	$onPath = Get-Command "lua-language-server" -ErrorAction SilentlyContinue
	if ($null -ne $onPath) {
		$LuaLS = $onPath.Source
	} elseif (Test-Path $extensions) {
		$found = Get-ChildItem $extensions -Directory -Filter "sumneko.lua-*" | Sort-Object Name -Descending | ForEach-Object {
			Get-ChildItem (Join-Path $_.FullName "server/bin") -File -Filter "lua-language-server*" -ErrorAction SilentlyContinue
		} | Select-Object -First 1
		if ($null -ne $found) { $LuaLS = $found.FullName }
	}
}
if ($LuaLS -eq "" -or -not (Test-Path $LuaLS)) {
	throw "lua-language-server not found. Install it or pass -LuaLS <path to lua-language-server>."
}

if ($WowApi -eq "" -and (Test-Path $extensions)) {
	$found = Get-ChildItem $extensions -Directory -Filter "ketho.wow-api-*" | Sort-Object Name -Descending | Select-Object -First 1
	if ($null -ne $found) { $WowApi = Join-Path $found.FullName "Annotations/Core" }
}
if ($WowApi -eq "" -or -not (Test-Path $WowApi)) {
	throw "WoW API annotations not found. Pass -WowApi <path to vscode-wow-api's Annotations/Core>."
}
$WowApi = (Resolve-Path $WowApi).Path

# A folder name with no "--" in it: LuaLS mangles such paths given to --check.
$work = Join-Path ([IO.Path]::GetTempPath()) ("trbluals" + [Guid]::NewGuid().ToString("N").Substring(0, 8))
$checkName = "TwintopInsanityBar"
$checkDir = Join-Path $work $checkName
New-Item -ItemType Directory -Path $checkDir | Out-Null

try {
	Push-Location $root
	$files = git ls-files "*.lua"
	Pop-Location
	if ($LASTEXITCODE -ne 0 -or $files.Count -eq 0) { throw "git ls-files found no Lua files." }
	foreach ($file in $files) {
		$target = Join-Path $checkDir $file
		New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
		Copy-Item -LiteralPath (Join-Path $root $file) -Destination $target
	}

	$config = Get-Content $configPath -Raw | ConvertFrom-Json
	$config.workspace | Add-Member -NotePropertyName library -NotePropertyValue @($WowApi) -Force
	# No byte order mark, which Windows PowerShell's Set-Content would add.
	[IO.File]::WriteAllText((Join-Path $checkDir ".luarc.json"), ($config | ConvertTo-Json -Depth 10))

	$outPath = Join-Path $work "check.json"
	Push-Location $work
	try {
		& $LuaLS "--check=$checkName" "--checklevel=Information" "--logpath=$(Join-Path $work 'log')" "--check_out_path=$outPath" | Out-Null
	} finally {
		Pop-Location
	}
	if (-not (Test-Path $outPath)) { throw "lua-language-server wrote no results to $outPath." }

	# Diagnostic URIs are file:/// URIs of the copy; reduce them to repository-relative paths.
	$prefix = ([Uri](Resolve-Path $checkDir).Path).AbsoluteUri.TrimEnd("/") + "/"
	$results = Get-Content $outPath -Raw | ConvertFrom-Json
	$current = @()
	foreach ($property in $results.PSObject.Properties) {
		$uri = [Uri]::UnescapeDataString($property.Name)
		$unescapedPrefix = [Uri]::UnescapeDataString($prefix)
		$file = if ($uri.StartsWith($unescapedPrefix, [StringComparison]::OrdinalIgnoreCase)) { $uri.Substring($unescapedPrefix.Length) } else { $uri }
		foreach ($diagnostic in $property.Value) {
			if ($diagnostic.severity -gt 3) { continue }
			$current += [pscustomobject]@{
				file = $file
				line = $diagnostic.range.start.line + 1
				code = [string]$diagnostic.code
				message = ([string]$diagnostic.message).Replace($checkDir, "").Replace("\", "/")
			}
		}
	}
} finally {
	Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}

$currentCounts = @{}
foreach ($d in $current) {
	$key = "$($d.file)|$($d.code)|$($d.message)"
	$currentCounts[$key] = 1 + ($currentCounts[$key] -as [int])
}

if ($UpdateBaseline) {
	$entries = $currentCounts.Keys | Sort-Object | ForEach-Object {
		$parts = $_ -split "\|", 3
		[ordered]@{ file = $parts[0]; code = $parts[1]; message = $parts[2]; count = $currentCounts[$_] }
	}
	$json = if ($null -eq $entries) { "[]" } else { ConvertTo-Json @($entries) -Depth 5 }
	[IO.File]::WriteAllText($baselinePath, ($json -replace "`r?`n", "`r`n") + "`r`n")
	Write-Host "luals: baseline written with $($current.Count) diagnostic(s)."
	exit 0
}

$baselineCounts = @{}
if (Test-Path $baselinePath) {
	foreach ($entry in @(Get-Content $baselinePath -Raw | ConvertFrom-Json)) {
		if ($null -eq $entry) { continue }
		$baselineCounts["$($entry.file)|$($entry.code)|$($entry.message)"] = [int]$entry.count
	}
}

$new = @()
foreach ($key in $currentCounts.Keys) {
	$extra = $currentCounts[$key] - ($baselineCounts[$key] -as [int])
	if ($extra -gt 0) {
		$new += $current | Where-Object { "$($_.file)|$($_.code)|$($_.message)" -eq $key }
	}
}
$fixed = ($baselineCounts.Keys | Where-Object { $baselineCounts[$_] -gt ($currentCounts[$_] -as [int]) }).Count

if ($new.Count -gt 0) {
	Write-Host "luals: diagnostics not in the baseline (every occurrence of each is listed):"
	foreach ($d in ($new | Sort-Object file, line)) {
		Write-Host ("  {0}:{1}  [{2}] {3}" -f $d.file, $d.line, $d.code, $d.message)
	}
	exit 1
}

if ($fixed -gt 0) {
	Write-Host "luals: $fixed baseline entr$(if ($fixed -eq 1) { 'y is' } else { 'ies are' }) fixed; run with -UpdateBaseline to lower the baseline."
}
Write-Host "luals: $($current.Count) diagnostic(s), none new against the baseline."
exit 0
