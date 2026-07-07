: "${ZSH_PLUGIN_PREFIX:=}"

# Detect zsh plugin installation prefix based on OS / distro.
# Plugins are expected to live under this directory as:
#   ${ZSH_PLUGIN_PREFIX}/zsh-autosuggestions/zsh-autosuggestions.zsh
#   ${ZSH_PLUGIN_PREFIX}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

local candidate_prefixes=()

case "$(uname -s)" in
    Darwin)
        candidate_prefixes=(
            "/opt/homebrew/share"
            "/usr/local/share"
        )
        ;;
    Linux)
        local distro=""
        if [ -r /etc/os-release ]; then
            distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
        fi

        case "$distro" in
            arch|manjaro|endeavouros|alpine)
                candidate_prefixes=(
                    "/usr/share/zsh/plugins"
                )
                ;;
            *)
                candidate_prefixes=(
                    "/usr/share"
                )
                ;;
        esac
        ;;
    MINGW*|MSYS*|CYGWIN*)
        # Git Bash / MSYS2: oh-my-zsh custom plugins is the most common layout
        candidate_prefixes=(
            "${HOME}/.oh-my-zsh/custom/plugins"
            "/usr/share/zsh/plugins"
            "/usr/share"
        )
        ;;
esac

for prefix in "${candidate_prefixes[@]}"; do
    if [ -d "${prefix}/zsh-autosuggestions" ] || [ -d "${prefix}/zsh-syntax-highlighting" ]; then
        ZSH_PLUGIN_PREFIX="$prefix"
        break
    fi
done

export ZSH_PLUGIN_PREFIX
