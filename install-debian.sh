#!/usr/bin/env bash
set -euo pipefail

# Detect the distribution codename for third-party apt repos.
# Some Debian/Ubuntu derivatives use their own codenames that third-party
# repos (e.g. debian.griffo.io) do not ship a suite for. Map them to the
# corresponding upstream codename.
# - Standard Debian (bookworm/trixie/forky/sid) passes through unchanged.
# - Standard Ubuntu (jammy/noble/questing/resolute) passes through unchanged.
# - Derivatives that diverge from upstream codenames are remapped below.
CODENAME=$(lsb_release -sc 2>/dev/null)
case "$CODENAME" in
  crimson)   CODENAME="trixie"   ;; # Deepin v25 — Debian base not officially disclosed; trixie is the closest match
  beige)     CODENAME="bookworm" ;; # Deepin v23 — based on Debian 12
  apricot)   CODENAME="bullseye" ;; # Deepin v20.x — based on Debian 11
esac

echo "==> Updating system..."
sudo apt update || true
sudo apt upgrade -y || true

echo "==> Removing old p7zip packages that conflict with new 7zip..."
sudo apt remove -y p7zip-full p7zip 2>/dev/null || true

echo "==> Installing apt packages..."
sudo apt install -y \
  build-essential \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  bat \
  fd-find \
  fzf \
  ripgrep \
  zoxide \
  trash-cli \
  less \
  git \
  jq \
  neovim \
  openssh-client \
  btop \
  chafa \
  imagemagick \
  libheif-dev \
  libimage-exiftool-perl \
  7zip \
  unzip \
  fonts-noto-color-emoji \
  curl \
  wget \
  gnupg

echo "==> Fixing bat -> batcat naming on Debian/Ubuntu..."
# The `bat` apt package installs the binary as `batcat` on Debian/Ubuntu
# due to a name clash with bacula-console-qt. Use dpkg-divert to redirect
# batcat → bat so that tools (yazi, fzf, etc.) find the `bat` command.
# https://github.com/sharkdp/bat/issues/982
# https://github.com/sharkdp/bat/issues/2455
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  sudo dpkg-divert --rename --divert /usr/bin/bat /usr/bin/batcat
  echo "  diverted batcat → bat."
else
  echo "  already a-ok, skipping."
fi

echo "==> Installing starship..."
if command -v starship >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsS https://starship.rs/install.sh | sh -s -- -y
fi

echo "==> Installing eza..."
if command -v eza >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update && sudo apt install -y eza
fi

echo "==> Installing github-cli..."
if command -v gh >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  (type -p wget >/dev/null || sudo apt install wget -y) && \
    sudo mkdir -p -m 755 /etc/apt/keyrings && \
    sudo rm -f /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    sudo mkdir -p -m 755 /etc/apt/sources.list.d && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt update && sudo apt install -y gh
fi

echo "==> Installing git-delta..."
if command -v delta >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  DELTA_VER=$(curl -fsS https://api.github.com/repos/dandavison/delta/releases/latest | jq -r '.tag_name')
  if [ -z "$DELTA_VER" ] || [ "$DELTA_VER" = "null" ]; then
    echo "  ERROR: failed to fetch delta version from GitHub API (rate limited?)" >&2
    exit 1
  fi
  echo "  downloading delta ${DELTA_VER}..."
  wget --show-progress "https://github.com/dandavison/delta/releases/download/${DELTA_VER}/git-delta_${DELTA_VER#v}_amd64.deb" -O /tmp/git-delta.deb
  sudo apt install -y /tmp/git-delta.deb
  sudo apt install --fix-broken -y
  rm -f /tmp/git-delta.deb
fi

echo "==> Installing lazygit..."
if command -v lazygit >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  LAZYGIT_VER=$(curl -fsS https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.tag_name')
  if [ -z "$LAZYGIT_VER" ] || [ "$LAZYGIT_VER" = "null" ]; then
    echo "  ERROR: failed to fetch lazygit version from GitHub API (rate limited?)" >&2
    exit 1
  fi
  echo "  downloading lazygit ${LAZYGIT_VER}..."
  curl -fSL --progress-bar -o /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VER}/lazygit_${LAZYGIT_VER#v}_linux_x86_64.tar.gz"
  sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit && rm /tmp/lazygit.tar.gz
fi

echo "==> Installing uv..."
if command -v uv >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"

echo "==> Installing yazi..."
if command -v yazi >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  sudo install -d -m 0755 /etc/apt/keyrings
  sudo rm -f /etc/apt/keyrings/debian.griffo.io.gpg
  curl -fsSL https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/debian.griffo.io.gpg
  echo "deb [signed-by=/etc/apt/keyrings/debian.griffo.io.gpg] https://debian.griffo.io/apt $CODENAME main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list > /dev/null
  sudo chmod 644 /etc/apt/keyrings/debian.griffo.io.gpg /etc/apt/sources.list.d/debian.griffo.io.list
  sudo apt update && sudo apt install -y yazi
fi

echo "==> Installing fnm..."
if command -v fnm >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

echo "==> Installing fastfetch..."
if command -v fastfetch >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  FASTFETCH_VER=$(curl -fsS https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r '.tag_name')
  if [ -z "$FASTFETCH_VER" ] || [ "$FASTFETCH_VER" = "null" ]; then
    echo "  ERROR: failed to fetch fastfetch version from GitHub API (rate limited?)" >&2
    exit 1
  fi
  echo "  downloading fastfetch ${FASTFETCH_VER}..."
  wget --show-progress "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VER}/fastfetch-linux-amd64.tar.gz" -O /tmp/fastfetch.tar.gz
  tar xf /tmp/fastfetch.tar.gz -C /tmp && sudo mv /tmp/fastfetch-linux-amd64/usr/bin/fastfetch /usr/local/bin/ && rm -rf /tmp/fastfetch*
fi

echo "==> Installing glow..."
if command -v glow >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo chmod 644 /etc/apt/keyrings/charm.gpg /etc/apt/sources.list.d/charm.list
  sudo apt update && sudo apt install -y glow
fi

echo "==> Installing opencode..."
if command -v opencode >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsSL https://opencode.ai/install | bash
  export PATH="$HOME/.opencode/bin:$PATH"
fi

echo "==> Installing wezterm..."
if command -v wezterm >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/wezterm-fury.gpg
  echo "deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt update && sudo apt install -y wezterm
fi

echo "==> Installing fonts..."
mkdir -p ~/.local/share/fonts
MONASPACE_VER=$(curl -fsS https://api.github.com/repos/githubnext/monaspace/releases/latest | jq -r '.tag_name')
if [ -z "$MONASPACE_VER" ] || [ "$MONASPACE_VER" = "null" ]; then
  echo "  ERROR: failed to fetch monaspace version from GitHub API (rate limited?)" >&2
  exit 1
fi
echo "  downloading monaspace ${MONASPACE_VER}..."
wget --show-progress -O /tmp/monaspace.zip "https://github.com/githubnext/monaspace/releases/download/${MONASPACE_VER}/monaspace-nerdfonts-${MONASPACE_VER}.zip"
unzip -o /tmp/monaspace.zip "NerdFonts/*/*.otf" -d /tmp/monaspace-fonts/
mv /tmp/monaspace-fonts/NerdFonts/*/*.otf ~/.local/share/fonts/
rm -rf /tmp/monaspace.zip /tmp/monaspace-fonts/
wget --show-progress -O /tmp/juliamono.tar.gz "https://github.com/cormullion/juliamono/releases/latest/download/JuliaMono-ttf.tar.gz"
tar xf /tmp/juliamono.tar.gz -C ~/.local/share/fonts/ && rm /tmp/juliamono.tar.gz
wget --show-progress -O ~/.local/share/fonts/LXGWWenKaiMonoScreen.ttf "https://github.com/lxgw/LxgwWenKai-Screen/releases/latest/download/LXGWWenKaiMonoScreen.ttf"
fc-cache -fv

echo "==> Done! Log out and back in, then launch WezTerm."
