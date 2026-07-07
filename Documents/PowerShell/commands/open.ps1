#!/usr/bin/env pwsh
# open.ps1 — Windows 'open' (PowerShell)
# Behaviour like macOS open: launch file/dir/URL with system default handler.
# Non-blocking (detached) using Start-Process.
#
# Usage: open <file|dir|url> [...]

param(
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Targets
)

function Show-Usage {
    @"
Usage: open <file|dir|url> [...]
       open -Help | -h | --help | -?

Opens each target with the system default handler, detached (non-blocking).

Exit codes:
  0   all targets opened successfully
  1   one or more targets failed to open
  2   usage error
"@
    exit 2
}

if ($Help) { Show-Usage }

# Separate option-like args from actual targets
$remaining = [System.Collections.Generic.List[string]]::new()
$endOfOptions = $false

foreach ($arg in $Targets) {
    if ($endOfOptions) { $remaining.Add($arg); continue }

    switch -Regex ($arg) {
        '^--$'        { $endOfOptions = $true; continue }
        '^-([h?]|-$|-help)$' { Show-Usage }
        '^-.*'        {
            Write-Error "open: invalid option -- $arg"
            Show-Usage
        }
        default       { $remaining.Add($arg) }
    }
}

if ($remaining.Count -eq 0) {
    Write-Error 'open: missing operand'
    Show-Usage
}

function Open-Target {
    param([string]$Path)

    $isUrl = $Path -match '^https?://|^ftp://|^mailto:'

    if (-not $isUrl -and -not (Test-Path -LiteralPath $Path)) {
        Write-Error "open: $Path : No such file or directory"
        return $false
    }

    try {
        if ($isUrl) {
            Start-Process -FilePath $Path
        } else {
            $resolved = Resolve-Path -LiteralPath $Path -ErrorAction Stop
            Start-Process -FilePath $resolved.Path
        }
        return $true
    } catch {
        Write-Error "open: failed to open $Path : $_"
        return $false
    }
}

$exitCode = 0
foreach ($target in $remaining) {
    if (-not (Open-Target $target)) { $exitCode = 1 }
}
exit $exitCode
