# This file only store simple alias, if you want to add more complex alias, please use 20-alias.zsh instead.

# ----------------------------------------------------------------------------
# Debian/Ubuntu 的 apt 包名重命名兼容（bat → batcat, fd → fdfind）
# 仅当原生 binary 缺失且改名后的 binary 存在时设置 alias
# ----------------------------------------------------------------------------
if (( $+commands[batcat] )) && ! (( $+commands[bat] )); then
    alias bat='batcat'
fi

if (( $+commands[fdfind] )) && ! (( $+commands[fd] )); then
    alias fd='fdfind'
fi

