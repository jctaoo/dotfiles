# Include ./commands as path
$env:PATH = "$PSScriptRoot\commands;$env:PATH"

# Config scripts
Get-ChildItem "$PSScriptRoot\configs\*.ps1" | Sort-Object Name | ForEach-Object {
    . $_.FullName
}

# Modules 
Import-Module -Name Microsoft.WinGet.CommandNotFound

if (Get-Module -ListAvailable -Name Microsoft.WinGet.Client) {
    Import-Module Microsoft.WinGet.Client
} else {
    Write-Host "Microsoft.WinGet.Client 模块未安装，winget 补全功能将不可用。" -ForegroundColor Yellow
}
