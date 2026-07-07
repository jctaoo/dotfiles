$fileExe = Get-Command file.exe -ErrorAction SilentlyContinue
if (-not $fileExe) {
    $fileExe = Get-Command "$env:ProgramFiles\Git\usr\bin\file.exe" -ErrorAction SilentlyContinue
}

# -------------------------------------------------------------------
# eza (现代化 ls 替代品) 配置
# -------------------------------------------------------------------
if (Get-Command eza -ErrorAction SilentlyContinue) {
    # 基础替换
    function ls { eza --icons=always --group-directories-first $args }
    # Remove alias
    if (Get-Alias ls -ErrorAction SilentlyContinue) {
        Remove-Item alias:ls -Force
    }

    # ll: 列表模式（包含权限、大小、修改时间等）
    function ll { eza -l --icons=always --group-directories-first --header $args }

    # la: 显示所有文件（包含隐藏文件）
    function la { eza -la --icons=always --group-directories-first --header $args }

    # lx: 列表模式 + 显示 Git 状态（在 Git 仓库中非常实用！）
    function lx { eza -lbhHigUmuSa --icons=always --group-directories-first --git $args }

    # lt: 树状图查看（替代 tree 命令）
    function lt { eza --tree --icons=always --level=2 $args }
    function ltt { eza --tree --icons=always $args } # 不限层级的完整树

    # 快捷排序别名
    function lsize { eza -la --sort=size --icons=always --header $args }  # 按文件大小排序
    function ldate { eza -la --sort=modified --icons=always --header $args } # 按修改时间排序
}

# -------------------------------------------------------------------
# bat 配置 (代替 cat 增强终端体验)
# -------------------------------------------------------------------
if (Get-Command bat -ErrorAction SilentlyContinue) {
    # 设置默认主题（可通过 bat --list-themes 查看所有主题）
    $env:BAT_THEME = "auto"
    $env:BAT_THEME_DARK = "Catppuccin Mocha"
    $env:BAT_THEME_LIGHT = "GitHub"

    # 改变其默认行为（样式包含：行号、Git状态、文件头）
    $env:BAT_STYLE = "numbers,changes,header"
}

# -------------------------------------------------------------------
# cat 函数 (智能 cat：优先 bat，支持图片预览)
# -------------------------------------------------------------------
function cat {
    if (Get-Command bat -ErrorAction SilentlyContinue) {
        $bat_command = "bat"
    }
    else {
        Microsoft.PowerShell.Management\Get-Content @args
        return
    }

    # 不是单个文件时直接透传
    if ($args.Count -ne 1 -or -not (Test-Path -LiteralPath $args[0] -PathType Leaf)) {
        & $bat_command @args
        return
    }

    $file = $args[0]
    if (-not $fileExe) {
        & $bat_command @args
        return
    }
    $mime = & $fileExe --brief --mime-type $file 2>$null

    # 图片预览
    if ($mime -like "image/*") {
        if (Get-Command magick -ErrorAction SilentlyContinue) {
            Write-Host "Displaying image using ImageMagick's sixel output:"
            magick $file sixel:-
        }
        elseif (Get-Command chafa -ErrorAction SilentlyContinue) {
            Write-Host "Displaying image using chafa:"
            chafa $file
        }
        else {
            Write-Error "Neither 'magick' nor 'chafa' is installed. Cannot display image."
        }
        return
    }

    & $bat_command @args
}
# 移除 PowerShell 自带的 cat (Get-Content) 别名
if (Get-Alias cat -ErrorAction SilentlyContinue) {
    Remove-Item alias:cat -Force
}

# --------------------------------------------------------------------
# LazyGit 配置
# --------------------------------------------------------------------
if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    # alias lg to lazygit
    function lg { lazygit $args }
}

# ---------------------------------------------------------------------
# yazi 配置
# ---------------------------------------------------------------------
# if yazi not found, warn user
if (-not (Get-Command yazi -ErrorAction SilentlyContinue)) {
    Write-Warning "Warning: yazi not found. Please install yazi to use the functions like 'y' and 'trash'."
}
else {
    if ($fileExe) {
        $env:YAZI_FILE_ONE = $fileExe.Source
    }
}
function y {
    $tmp = (New-TemporaryFile).FullName

    try {
        if ($args.Count -eq 0) {
            yazi.exe --cwd-file="$tmp"
        }
        elseif ($args.Count -eq 1) {
            if (Test-Path -LiteralPath $args[0] -PathType Container) {
                yazi.exe $args[0] --cwd-file="$tmp"
            }
            else {
                $query = $args[0]
                $result = zoxide query $query 2>$null
                
                if ($result) {
                    yazi.exe $result --cwd-file="$tmp"
                }
                else {
                    Write-Warning "No matching directory found for query: $query"
                    return
                }
            }
        }
        else {
            yazi.exe @args --cwd-file="$tmp"
        }

        if (Test-Path -LiteralPath $tmp) {
            $cwd = Get-Content -Path $tmp -Encoding UTF8 -ErrorAction SilentlyContinue
            if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
                Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
            }
        }
    }
    finally {
        if (Test-Path -LiteralPath $tmp) {
            Remove-Item -Path $tmp -Force
        }
    }
}

#----------------------------------------------------------------------
# opencode settings
#----------------------------------------------------------------------
$opencodeCommand = Get-Command -Name opencode -CommandType Application -ErrorAction SilentlyContinue
if ($opencodeCommand) {
    $env:OPENCODE_ENABLE_EXA = "1"
    function opencode {
        & $opencodeCommand.Source @args
        Write-Host -NoNewline "`e]104`a`e]110`a`e]111`a`e]112`a"
    }
}