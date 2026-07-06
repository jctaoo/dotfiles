# ==========================================
# 语法高亮
# ==========================================
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  
  # ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'       # 正确的命令显示加粗绿
  # ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'   # 错误的命令显示加粗红
fi
