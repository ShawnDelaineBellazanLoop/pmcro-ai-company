<#
.SYNOPSIS
  Concatenate an entire repo's text files into one .txt snapshot -- for
  pasting into a fresh Claude session, archiving, or diffing against a
  later dump. Declarative per Law 1: repo_path is always a parameter,
  never hardcoded.

.USAGE
  powershell -NoProfile -File dump-repo-to-txt.ps1 -RepoPath "W:\pmcro-ai-company"
  powershell -NoProfile -File dump-repo-to-txt.ps1 -RepoPath "W:\ProjectName" -OutputPath "W:\ProjectName\_dump.txt"

.PARAMS
  -RepoPath     (required) root folder to walk.
  -OutputPath   (optional) defaults to "<RepoPath>\repo-dump.txt".
  -ExcludeDirs  (optional) directory names to skip anywhere in the tree.
  -MaxFileKB    (optional) skip individual files bigger than this (default 512 KB) --
                large lockfiles/binaries blow up the dump without adding value.
#>

param(
    [Parameter(Mandatory = $true)][string]$RepoPath,
    [string]$OutputPath,
    [string[]]$ExcludeDirs = @(".git", ".vs", "node_modules", "bin", "obj", "dist", "build", ".next", "__pycache__"),
    [int]$MaxFileKB = 512
)

$ErrorActionPreference = "Stop"

$RepoPath = (Resolve-Path $RepoPath).Path
if (-not $OutputPath) { $OutputPath = Join-Path $RepoPath "repo-dump.txt" }

# Extensions we know are binary/noise -- skip outright regardless of size.
$binaryExt = @(
    ".exe",".dll",".pdb",".db",".sqlite",".sqlite3",".vsidx",".wsuo",".suo",
    ".png",".jpg",".jpeg",".gif",".ico",".bmp",".zip",".7z",".nupkg",".pfx",
    ".ttf",".woff",".woff2",".eot",".pyc",".class",".so",".dylib"
)

function Test-ExcludedPath($fullName) {
    $segments = $fullName.Substring($RepoPath.Length) -split '[\\/]'
    foreach ($seg in $segments) {
        if ($ExcludeDirs -contains $seg) { return $true }
    }
    return $false
}

$enc = New-Object System.Text.UTF8Encoding($false)
$writer = New-Object System.IO.StreamWriter($OutputPath, $false, $enc)

$writer.WriteLine("# Repo dump: $RepoPath")
$writer.WriteLine("# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$writer.WriteLine("")

$files = Get-ChildItem -Path $RepoPath -Recurse -File |
    Where-Object {
        -not (Test-ExcludedPath $_.FullName) -and
        ($binaryExt -notcontains $_.Extension.ToLower()) -and
        ($_.Length -le ($MaxFileKB * 1KB)) -and
        ($_.FullName -ne $OutputPath)
    } |
    Sort-Object FullName

$count = 0
foreach ($f in $files) {
    $rel = $f.FullName.Substring($RepoPath.Length).TrimStart('\','/')
    $writer.WriteLine("==================================================================")
    $writer.WriteLine("FILE: $rel")
    $writer.WriteLine("==================================================================")
    try {
        $writer.WriteLine([System.IO.File]::ReadAllText($f.FullName))
    } catch {
        $writer.WriteLine("[skipped -- could not read as text: $($_.Exception.Message)]")
    }
    $writer.WriteLine("")
    $count++
}

$writer.Close()
Write-Output "DONE: wrote $count files to $OutputPath"
