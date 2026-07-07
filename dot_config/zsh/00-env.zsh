# ==============================================================================
# Global Environment Flags
# ==============================================================================
# 检测是否在 WSL 环境，内核包含 Microsoft 或 wsl 即为真
if [[ "$(uname -r)" == *microsoft* ]] || [[ "$(uname -r)" == *wsl* ]]; then
    export IS_WSL=true
else
    export IS_WSL=false
fi

# FNM Node 环境管理器
if [[ -d "$HOME/.local/share/fnm" ]]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
fi
if (( $+commands[fnm] )); then
    eval "$(fnm env --shell zsh)"
fi

# Configure ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

# Configure fzf
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
    
    unset FZF_DEFAULT_OPTS
    # export FZF_DEFAULT_OPTS="--height 100% --layout=reverse"
    export FZF_DEFAULT_OPTS="--height 100%"
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
        --color=fg:-1,bg:-1,hl:4:bold \
        --color=fg+:5:bold,bg+:-1,hl+:5:reverse,pointer:5 \
        --color=info:5,prompt:2,marker:1,spinner:5,header:5 \
        --border=rounded"

    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .node_modules'

    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --theme=ansi --color=always {} | head -500'"

    export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=always {} | head -200'"
fi 
