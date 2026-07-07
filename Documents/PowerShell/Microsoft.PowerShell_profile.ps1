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

# OSC7 Configure
$prompt = ""
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

# -------------------------------------------------------------------
# 📦 eza 快捷命令配置
# -------------------------------------------------------------------
if (Get-Command eza -ErrorAction SilentlyContinue) {
    # 移除 PowerShell 自带的 ls 别名
    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue

    # 覆盖默认行为，支持自动传递参数 ($args)
    function ls  { eza --icons --group-directories-first $args }
    function ll  { eza -l --icons --group-directories-first --header $args }
    function la  { eza -a --icons --group-directories-first $args }
    function lla { eza -la --icons --group-directories-first --header $args }

    # lx: 列表模式 + 显示 Git 状态（在 Git 仓库中非常实用！）
    function lx  { eza -lbhHigUmuSa --icons --group-directories-first --git $args }

    # 快捷排序别名（带表头）
    function lsize { eza -la --sort=size --icons --header $args }
    function ldate { eza -la --sort=modified --icons --header $args }
    
    # 树状图查看
    function lt  { eza --tree --icons --level=2 $args }
    function ltt { eza --tree --icons $args }
}

# -------------------------------------------------------------------
# bat 配置 (代替 cat 增强终端体验)
# -------------------------------------------------------------------

# 1. 检查 bat 是否安装，并配置别名
if (Get-Command bat -ErrorAction SilentlyContinue) {
    # 移除 PowerShell 自带的 cat (Get-Content) 别名
    if (Get-Alias cat -ErrorAction SilentlyContinue) {
        Remove-Item alias:cat -Force
    }
    # 将 cat 重新绑定到 bat
    Set-Alias cat bat
}

# 2. 设置环境变量
if (Get-Command bat -ErrorAction SilentlyContinue) {
    # 设置默认主题
    $env:BAT_THEME = "TwoDark"
    
    # 改变其默认行为（行号、Git状态、文件头）
    $env:BAT_STYLE = "numbers,changes,header"
}

# ==============================================================================
# Aliases & Functions: macOS 'open' command clone for Windows pwsh
# ==============================================================================

function Invoke-MacStyleOpen {
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$Target = "."
    )
    $LiteralPath = Convert-Path -LiteralPath $Target -ErrorAction SilentlyContinue
    if ($LiteralPath) {
        Start-Process $LiteralPath
    } else {
        Start-Process $Target
    }
}
Set-Alias open Invoke-MacStyleOpen

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# fnm node
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

# yazi
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
