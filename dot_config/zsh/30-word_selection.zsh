# Redefine the "word" in zsh
autoload -Uz select-word-style
select-word-style bash

bindkey "^[[1;5D" backward-word  # 修复 Ctrl + 左箭头
bindkey "^[[1;5C" forward-word   # 修复 Ctrl + 右箭头
