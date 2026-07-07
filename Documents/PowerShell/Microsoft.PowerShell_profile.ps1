# Include ./commands as path
$env:PATH = "$PSScriptRoot\commands;$env:PATH"

# Config scripts
Get-ChildItem "$PSScriptRoot\configs\*.ps1" | Sort-Object Name | ForEach-Object {
    . $_.FullName
}

# Modules 
Import-Module -Name Microsoft.WinGet.CommandNotFound
