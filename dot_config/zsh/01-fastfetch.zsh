# based on WEZTERM_AUTO_FASTFETCH or IS_WSL(boolean) and not in vim
if [[ -o interactive ]] && [[ -z "$VIM" ]] && [[ -z "$NVIM" ]]; then
    if [[ "$WEZTERM_AUTO_FASTFETCH" == "1" ]] || [[ "$IS_WSL" == "true" ]]; then
        if (( $+commands[fastfetch] )); then
            fastfetch
        fi
    fi
fi

