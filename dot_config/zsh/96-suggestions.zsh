# ==========================================
# 原生智能 Tab 补全系统
# ==========================================
# 自动加载并初始化补全模块
autoload -Uz compinit && compinit

# 开启补全菜单选择，允许使用方向键在补全候选菜单中移动
zstyle ':completion:*' menu select

# 大小写不敏感补全（输入小写也可以补全大写，输入错误时自动纠错）
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# 补全缓存，提升大型命令（如 docker/git）的补全响应速度
zstyle ':completion:*' use-cache yes
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# ==========================================
# 智能历史记录提示 zsh-autosuggestions
# ==========================================
: "${ZSH_PLUGIN_PREFIX:=}"
local autosuggestions_path="${ZSH_PLUGIN_PREFIX}/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [ -n "$ZSH_PLUGIN_PREFIX" ] && [ -f "$autosuggestions_path" ]; then
    # 如果历史记录里匹配不到，它会调用 Zsh 的补全引擎，
    # 自动用当前目录下的文件名或命令来生成灰色虚影提示！
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)

    # 【性能优化】防止长命令卡顿
    # 当你粘贴长达几百个字符的命令或代码时，停止实时计算建议，避免终端卡死
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

    source "$autosuggestions_path"

    # 自定义颜色
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

    # 快捷键 —— 快速接受建议
    bindkey '^ ' autosuggest-accept
fi
