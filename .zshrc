# Path to your oh-my-zsh installation.
export ZSH="/Users/junso/.oh-my-zsh"

#ZSH_THEME="bira"
ZSH_THEME="awesomepanda"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
    zsh-syntax-highlighting
    git-open
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases
# TODO: ranger
alias g-o="git-open"
alias cat=bat
alias ls="exa --icons --all"
alias tree="exa -T --icons --git-ignore --git"
alias top="btm"
alias find="fd"

alias gobeta="$HOME/go/go1.18beta1/bin/go"
alias jc="jctaoo"
alias jctaoo="cd ~/jctaoo"
alias gaa="git add ."
alias gcz="git cz"
alias gacz="gaa && gcz"
alias pstart="pnpm run start"
alias nstart="npm run start"
alias ystart="yarn run start"
alias fs="ranger"
alias clr="clear"
alias lg="lazygit"

function list-alias() {
    echo "jc: jctaoo"
    echo "jctaoo: go to jctaoo folder"
    echo "gacz: go gaa and gcz"
    echo "gcz: do git conventional commits (i.e. git cz)"
    echo "gaa: git add all (i.e. git add .)"
    echo "fs: ranger, The fs manager in terminal."
    echo "clr: clear output of terminal"
    echo "pstart: pnpm run start"
    echo "nstart: npm run start"
    echo "ystart: yarn run start"
    echo "lg: lazygit"
    echo "g-o: git-open"
    echo "cloc"
}

# get ip
function ip() {
    ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2
}

# local server
function serve() {
    echo "Actually, the serve is sfz's alias"
    sfz . --bind $(ip)
}

# proxy
function proxy_off(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "已关闭代理"
}

function proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="http://127.0.0.1:7890"
    export all_proxy="socks5://127.0.0.1:7891"
    export https_proxy=$http_proxy
    echo -e "已开启代理"
}

# Tools/bin
export PATH=$PATH:/Users/junso/Tools/bin/
# flutter and dart
export PATH=$PATH:~/Tools/flutter/bin:~/Tools/flutter/bin/cache/dart-sdk/bin
export PATH="$PATH":"$HOME/.pub-cache/bin"
# protobuf
export PATH=$PATH:~/Tools/protoc/bin
# Golang
export PATH="$PATH:/Users/junso/go/bin"
# For deno
export PATH="/Users/junso/.deno/bin:$PATH"
# for Andoird SDK
export ANDROID_HOME="/Users/junso/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH"

# added by travis gem
[ ! -s /Users/junso/.travis/travis.sh ] || source /Users/junso/.travis/travis.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm (NodeJS)
export PATH=/Users/junso/.fnm:$PATH
eval "$(fnm env --use-on-cd)"
# fnm use 18

# jetbrains apps
export PATH="/Users/junso/Tools/jetbrains_bin:$PATH"

# pkg-config
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
