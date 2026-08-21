param([switch]$Release)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()
function Fail([string]$Message) { $failures.Add($Message) }
$strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
Get-ChildItem -LiteralPath $root -Recurse -File |
  Where-Object { $_.Extension -in '.md','.qmd','.yml','.yaml','.html','.css','.scss','.js' -and $_.FullName -notmatch '[\\/](_site|\.quarto)[\\/]' } |
  ForEach-Object {
    $path = $_.FullName
    try { [void]$strictUtf8.GetString([System.IO.File]::ReadAllBytes($path)) }
    catch { Fail "Invalid UTF-8: $path" }
  }
Get-ChildItem -LiteralPath $root -Recurse -File -Include '*.md','*.qmd' |
  Where-Object { $_.Extension -in '.md','.qmd' -and $_.FullName -notmatch '[\\/](_site|\.quarto|templates)[\\/]' } |
  ForEach-Object {
    $source = $_
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $source.FullName
    foreach ($match in [regex]::Matches($text, '!?' + '\[[^\]]*\]\(([^)#]+)(?:#[^)]+)?\)')) {
      $target = $match.Groups[1].Value
      if ($target -match '^(https?:|mailto:|/|\{)') { continue }
      $resolved = Join-Path $source.DirectoryName ([uri]::UnescapeDataString($target))
      if (-not (Test-Path -LiteralPath $resolved)) { Fail "Broken local link in $($source.FullName): $target" }
    }
  }
$records = Get-ChildItem -LiteralPath (Join-Path $root 'publications') -Directory | ForEach-Object { Join-Path $_.FullName 'index.qmd' } | Where-Object { Test-Path $_ }
foreach ($record in $records) {
  $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $record
  foreach ($field in 'title','slug','type','status','date','year','image','image-alt','description','languages','subjects','publisher','license','canonical-url','repository-url') {
    if ($text -notmatch "(?m)^$([regex]::Escape($field)):\s*\S") { Fail "Publication metadata '$field' is missing or blank in $record" }
  }
  if ($text -notmatch '(?m)^image-alt:\s*"?\S.{10,}') { Fail "Publication cover alt text is too short in $record" }
}
if ($Release) {
  if ((Get-Content -Raw -Encoding UTF8 (Join-Path $root '_quarto.yml')) -notmatch 'https://publications\.diversity\.org\.in') { Fail 'Production site URL is not configured.' }
  if ((Get-Content -Raw -Encoding UTF8 (Join-Path $root 'CNAME')).Trim() -ne 'publications.diversity.org.in') { Fail 'CNAME does not match the production domain.' }
}
if ($failures.Count) {
  $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
  throw "Validation failed with $($failures.Count) error(s)."
}
Write-Host "Portal validation passed$(if($Release){' for release'})."
