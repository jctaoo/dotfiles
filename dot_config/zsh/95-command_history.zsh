# ==========================================
# Zsh 历史记录多 Session 共享与持久化配置
# ==========================================

# 1. 配置文件路径和大小限制
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history" # 历史记录保存的文件路径
HISTSIZE=50000              # 当前 Session 内存中最多保存多少条历史
SAVEHIST=50000              # 硬盘文件中最多保存多少条历史

# 2. 开启多 Session 实时同步
setopt SHARE_HISTORY        # 实时共享历史记录。一旦在 A 窗口敲了命令，B 窗口按上键就能搜到
setopt APPEND_HISTORY       # 多个终端同时关闭时，以追加方式写入文件，防止记录互相覆盖

# 3. 历史记录去重与体验优化
setopt HIST_IGNORE_DUPS     # 如果连续敲了多次相同的命令（比如狂敲 ls），只记录一次
setopt HIST_IGNORE_ALL_DUPS # 如果新命令在历史中已存在，则删掉旧的，只保留最新的一条（查历史更干净）
setopt HIST_FIND_NO_DUPS    # 在按上箭头搜索历史时，自动跳过重复的命令
setopt HIST_REDUCE_BLANKS   # 自动删掉命令中多余的空格（比如 `yay  -S` 变成 `yay -S`）

# ==========================================
# 历史命令搜索 (by prefix)
# ==========================================
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

