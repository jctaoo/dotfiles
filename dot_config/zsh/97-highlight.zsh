# ==========================================
# 语法高亮
# ==========================================
: "${ZSH_PLUGIN_PREFIX:=}"
local syntax_highlighting_path="${ZSH_PLUGIN_PREFIX}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [ -n "$ZSH_PLUGIN_PREFIX" ] && [ -f "$syntax_highlighting_path" ]; then
    source "$syntax_highlighting_path"

    # ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'       # 正确的命令显示加粗绿
    # ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'   # 错误的命令显示加粗红
fi
