# -------------------------------------------------------------------
# eza (现代化 ls 替代品) 配置
# -------------------------------------------------------------------
if (( $+commands[eza] )); then
    # 基础替换
    alias ls='eza --icons=always --group-directories-first'
    
    # ll: 列表模式（包含权限、大小、修改时间等）
    alias ll='eza -l --icons=always --group-directories-first --header'
    
    # la: 显示所有文件（包含隐藏文件）
    alias la='eza -la --icons=always --group-directories-first --header'
    
    # lx: 列表模式 + 显示 Git 状态（在 Git 仓库中非常实用！）
    alias lx='eza -lbhHigUmuSa --icons=always --group-directories-first --git'
    
    # lt: 树状图查看（替代 tree 命令）
    alias lt='eza --tree --icons=always --level=2'
    alias ltt='eza --tree --icons=always' # 不限层级的完整树
    
    # 快捷排序别名
    alias lsize='eza -la --sort=size --icons=always --header'  # 按文件大小排序
    alias ldate='eza -la --sort=modified --icons=always --header' # 按修改时间排序
fi

# -------------------------------------------------------------------
# bat 配置 (代替 cat 增强终端体验)
# -------------------------------------------------------------------
if (( $+commands[bat] || $+commands[batcat] )); then
    # 设置默认主题（可通过 bat --list-themes 查看所有主题）
    export BAT_THEME="auto"
    export BAT_THEME_DARK="Catppuccin Mocha"
    export BAT_THEME_LIGHT="GitHub"
    
    # 改变其默认行为（样式包含：行号、Git状态、文件头）
    export BAT_STYLE="numbers,changes,header"
fi

cat() {
    local file="$1"

    # 别名设置：用 bat 代替 cat
    # Ubuntu/Debian 系统通过 apt 安装后命令名为 batcat，需要特殊处理
    if (( $+commands[batcat] )); then
        local bat_command="batcat"
    elif (( $+commands[bat] )); then
        local bat_command="bat"
    else
        # 如果 bat 或 batcat 都不存在，则使用原生 cat
        local bat_command="cat"
    fi

    # if not single file
    if [[ $# -ne 1 || ! -f "$file" ]]; then
        "$bat_command" "$@"
        return
    fi

    local mime=$(file --brief --mime-type -b "$file" 2>/dev/null)

    # if is image
    if [[ "$mime" == image/* ]]; then
        # if magick installed
        if (( $+commands[magick] )); then
            echo "Displaying image using ImageMagick's sixel output:"
            magick "$file" sixel:-
        elif (( $+commands[chafa] )); then
            echo "Displaying image using chafa:"
            chafa "$file"
        else
            echo "Error: Neither 'magick' nor 'chafa' is installed. Cannot display image."
            return 1
        fi
        return
    fi

    # run bat command
    "$bat_command" "$@"
}

# --------------------------------------------------------------------
# LazyGit 配置 (with OSC11)
# --------------------------------------------------------------------
if (( $+commands[lazygit] )); then
    lg() {
        local t
        t=$(detectterm 2>/dev/null) || true
        [[ -n "$t" ]] || t=dark

        case "$t" in
            dark) DELTA_FEATURES="+dark-bg" ;;
            light) DELTA_FEATURES="+light-bg" ;;
            *) DELTA_FEATURES="" ;;
        esac

        DELTA_FEATURES="$DELTA_FEATURES" command lazygit "$@"
    }
    alias lazygit="lg"
fi

# ---------------------------------------------------------------------
# yazi 配置
# ---------------------------------------------------------------------
# if yazi not found, warn user
if ! (( $+commands[yazi] )); then
    echo "Warning: yazi not found. Please install yazi to use the functions like 'y' and 'trash'."
fi
y() {
    local tmp cwd target
    tmp=$(mktemp -t "yazi-cwd.XXXXXX") || return 1

    {
        if [[ -n "$1" ]]; then
            if [[ -d "$1" ]]; then
                target="$1"
            else
                target=$(zoxide query "$1" 2>/dev/null)
            fi
        fi

        # 如果 target 为空或者目录不存在，则停在当前目录
        command yazi "${target:-.}" --cwd-file="$tmp"
        
        if [[ -s "$tmp" ]]; then
            cwd=$(<"$tmp")
            [[ "$cwd" != "$PWD" && -d "$cwd" ]] && builtin cd -- "$cwd"
        fi
    } always {
        command rm -f -- "$tmp"
    }
}

#----------------------------------------------------------------------
# trash 配置
# ----------------------------------------------------------------------
trash() {
    local xdg_data="${XDG_DATA_HOME:-$HOME/.local/share}"
    local trash_dir="${xdg_data}/Trash/files"

    if [[ ! -d "$trash_dir" ]]; then
        echo "Error: Trash directory not found at $trash_dir"
        return 1
    fi

    yazi "$trash_dir"
}

# trash-cli: trm
if (( $+commands[trash-put] )); then
    alias trm='trash-put'
fi

# trash-cli: restore
if (( $+commands[trash-restore] )); then
    alias trr='trash-restore'
fi

#----------------------------------------------------------------------
# opencode settings
#----------------------------------------------------------------------
if (( $+commands[opencode] )); then
    export OPENCODE_ENABLE_EXA=1
    opencode() {
        command opencode "$@"
        printf '\e]104\e\e]110\e\e]111\e\e]112\e\'
    }
fi
