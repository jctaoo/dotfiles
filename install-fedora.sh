#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system..."
sudo dnf upgrade --refresh -y

echo "==> Installing dnf packages..."
sudo dnf install -y \
  dnf-plugins-core \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  bat \
  eza \
  fd-find \
  fzf \
  ripgrep \
  zoxide \
  trash-cli \
  less \
  git \
  gh \
  git-delta \
  jq \
  neovim \
  openssh \
  btop \
  fastfetch \
  chafa \
  glow \
  ImageMagick \
  libheif \
  perl-Image-ExifTool \
  7zip \
  unzip \
  google-noto-emoji-fonts \
  uv \
  curl \
  wget

export PATH="$HOME/.local/bin:$PATH"

echo "==> Installing starship..."
if command -v starship >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  sudo dnf copr enable atim/starship -y
  sudo dnf install -y starship
fi

echo "==> Installing yazi..."
if command -v yazi >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  sudo dnf copr enable lihaohong/yazi -y
  sudo dnf install -y yazi
fi

echo "==> Installing lazygit..."
if command -v lazygit >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  sudo dnf copr enable dejan/lazygit -y
  sudo dnf install -y lazygit
fi

echo "==> Installing fnm..."
if command -v fnm >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.local/share/fnm:$PATH"
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
  sudo dnf copr enable wezfurlong/wezterm-nightly -y
  sudo dnf install -y wezterm
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
