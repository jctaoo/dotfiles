<#
.SYNOPSIS
    Detect terminal light/dark theme via OSC 11 (background color query).

.DESCRIPTION
    Pipe-friendly: the OSC query/answer exchange goes through the console
    (the controlling terminal), while the result is printed to stdout so it
    can be piped (e.g. `pwsh -File detectterm.ps1 | ...`).

    Exit codes:
        0  -> light
        1  -> dark
        2  -> unknown (no console / no OSC 11 response)
#>

[CmdletBinding()]
param(
    [double] $Timeout = 0.6
)

$ErrorActionPreference = 'Stop'

# --- P/Invoke helpers (one-time type compilation) ---
try { [ConsoleDetect]::STD_INPUT_HANDLE | Out-Null } catch {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class ConsoleDetect {
    public const int STD_INPUT_HANDLE  = -10;
    public const int STD_OUTPUT_HANDLE = -11;

    public const uint ENABLE_LINE_INPUT             = 0x0002;
    public const uint ENABLE_ECHO_INPUT             = 0x0004;
    public const uint ENABLE_VIRTUAL_TERMINAL_INPUT = 0x0200;
    public const uint ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool GetConsoleMode(IntPtr h, out uint mode);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool SetConsoleMode(IntPtr h, uint mode);
}
'@ -ErrorAction Stop
}

# --- Functions ---

function Receive-OSCResponse {
    param([double] $Timeout)
    $inHandle  = [ConsoleDetect]::GetStdHandle([ConsoleDetect]::STD_INPUT_HANDLE)
    $outHandle = [ConsoleDetect]::GetStdHandle([ConsoleDetect]::STD_OUTPUT_HANDLE)

    # Ensure VT processing on output handle
    $outMode = 0
    [ConsoleDetect]::GetConsoleMode($outHandle, [ref]$outMode) | Out-Null
    if (($outMode -band [ConsoleDetect]::ENABLE_VIRTUAL_TERMINAL_PROCESSING) -eq 0) {
        [ConsoleDetect]::SetConsoleMode($outHandle, $outMode -bor [ConsoleDetect]::ENABLE_VIRTUAL_TERMINAL_PROCESSING) | Out-Null
    }

    # Save original input mode, then set "raw" (no line input, no echo, enable VT input)
    $oldInMode = 0
    [ConsoleDetect]::GetConsoleMode($inHandle, [ref]$oldInMode) | Out-Null
    $rawMode = ($oldInMode -bor [ConsoleDetect]::ENABLE_VIRTUAL_TERMINAL_INPUT) `
               -band (-bnot ([ConsoleDetect]::ENABLE_LINE_INPUT -bor `
                             [ConsoleDetect]::ENABLE_ECHO_INPUT))
    [ConsoleDetect]::SetConsoleMode($inHandle, $rawMode) | Out-Null

    try {
        # Send OSC 11 query (BEL-terminated, most portable)
        [Console]::Write("`e]11;?`a")

        # Read response with timeout via async I/O
        $stdin = [Console]::OpenStandardInput()
        $buffer = New-Object byte[] 256
        $async = $stdin.BeginRead($buffer, 0, 256, $null, $null)
        if (-not $async.AsyncWaitHandle.WaitOne([int]($Timeout * 1000))) {
            return ''
        }
        $len = $stdin.EndRead($async)
        return [System.Text.Encoding]::UTF8.GetString($buffer, 0, $len)
    }
    finally {
        [ConsoleDetect]::SetConsoleMode($inHandle, $oldInMode) | Out-Null
    }
}


function ConvertFrom-OSCColor {
    param([string] $Response)
    if ($Response -match "rgb:([0-9a-fA-F]{1,4})[:/]([0-9a-fA-F]{1,4})[:/]([0-9a-fA-F]{1,4})") {
        $rHex = $Matches[1]
        $gHex = $Matches[2]
        $bHex = $Matches[3]
        $max = [Math]::Pow(16, $rHex.Length) - 1
        $r = [int]([Convert]::ToInt64($rHex, 16) * 255 / $max)
        $g = [int]([Convert]::ToInt64($gHex, 16) * 255 / $max)
        $b = [int]([Convert]::ToInt64($bHex, 16) * 255 / $max)
        return @( $r, $g, $b )
    }
    return $null
}


function Get-RelativeLuminance {
    param($Rgb)
    $r = $Rgb[0] / 255.0
    $g = $Rgb[1] / 255.0
    $b = $Rgb[2] / 255.0

    function Linearize {
        param([double] $c)
        if ($c -le 0.03928) { return $c / 12.92 }
        return [Math]::Pow(($c + 0.055) / 1.055, 2.4)
    }

    return 0.2126 * (Linearize $r) + 0.7152 * (Linearize $g) + 0.0722 * (Linearize $b)
}


function Get-TerminalTheme {
    param([double] $Timeout)
    $response = Receive-OSCResponse -Timeout $Timeout
    $rgb = ConvertFrom-OSCColor -Response $response
    if (-not $rgb) {
        return @{ Theme = $null; Rgb = $null; Raw = $response }
    }
    $lum = Get-RelativeLuminance -Rgb $rgb
    $theme = if ($lum -gt 0.5) { 'light' } else { 'dark' }
    return @{ Theme = $theme; Rgb = $rgb; Raw = $response }
}


# --- Main ---
function Main {
    param([double] $Timeout)
    if ($env:NO_COLOR) {
        Write-Error "unknown (NO_COLOR is set)"
        exit 2
    }

    $detected = Get-TerminalTheme -Timeout $Timeout
    if (-not $detected.Theme) {
        if ($detected.Raw) {
            Write-Error "unknown (raw: $($detected.Raw))"
        } else {
            Write-Error "unknown (no console / no OSC 11 response)"
        }
        exit 2
    }

    Write-Output $detected.Theme
    if ($detected.Theme -eq 'light') { exit 0 } else { exit 1 }
}

Main -Timeout $Timeout
