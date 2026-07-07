if (
    $env:WEZTERM_AUTO_FASTFETCH -eq "1" -and
    -not $env:FASTFETCH_RAN_ON_STARTUP -and
    (Get-Command fastfetch -ErrorAction SilentlyContinue) -and
    $env:TERM_PROGRAM -eq "WezTerm" -and
    (Get-Command wezterm -ErrorAction SilentlyContinue)
) {
    $env:FASTFETCH_RAN_ON_STARTUP = "1"

    $panes = wezterm cli list --format json 2>$null | ConvertFrom-Json
    $current = $panes | Where-Object { $_.pane_id -eq [int]$env:WEZTERM_PANE }
    $count = ($panes | Where-Object { $_.tab_id -eq $current.tab_id }).Count
    if ($count -eq 1) {
        fastfetch
    }
}