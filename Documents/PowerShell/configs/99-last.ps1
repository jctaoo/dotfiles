# OSC7 Configure and starship (https://wezterm.org/shell-integration.html#osc-7-on-windows-with-powershell-with-starship)
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}
Invoke-Expression (&starship init powershell)

# configure zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
