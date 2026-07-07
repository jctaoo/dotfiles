#!/usr/bin/env bash
set -euo pipefail

# Alpine does not enable community repo by default.
# Detect current Alpine version and enable community if missing.
if ! grep -q '^http.*/community$' /etc/apk/repositories 2>/dev/null; then
  echo "==> Enabling community repository..."
  ALPINE_VER=$(cut -d'.' -f1,2 /etc/alpine-release)
  echo "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VER}/community" | sudo tee -a /etc/apk/repositories > /dev/null
fi

echo "==> Updating system..."
sudo apk update
sudo apk upgrade

echo "==> Installing apk packages..."
sudo apk add \
  build-base \
  shadow \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  bat \
  fd \
  fzf \
  ripgrep \
  zoxide \
  trash-cli \
  less \
  git \
  jq \
  neovim \
  openssh \
  btop \
  chafa \
  imagemagick \
  libheif \
  exiftool \
  7zip \
  unzip \
  curl \
  wget \
  eza \
  github-cli

echo "==> Installing starship..."
if command -v starship >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

echo "==> Installing git-delta..."
if command -v delta >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  DELTA_VER=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d'"' -f4)
  DELTA_DIR=$(mktemp -d)
  wget "https://github.com/dandavison/delta/releases/download/${DELTA_VER}/delta-${DELTA_VER}-x86_64-unknown-linux-musl.tar.gz" -O "$DELTA_DIR/delta.tar.gz"
  sudo tar xf "$DELTA_DIR/delta.tar.gz" -C /usr/local/bin --strip-components=1 "$(tar tf "$DELTA_DIR/delta.tar.gz" | head -1)delta"
  rm -rf "$DELTA_DIR"
fi

echo "==> Installing lazygit..."
if command -v lazygit >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  LAZYGIT_VER=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d'"' -f4)
  LAZYGIT_DIR=$(mktemp -d)
  wget "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VER}/lazygit_${LAZYGIT_VER#v}_Linux_x86_64.tar.gz" -O "$LAZYGIT_DIR/lazygit.tar.gz"
  sudo tar xf "$LAZYGIT_DIR/lazygit.tar.gz" -C /usr/local/bin lazygit
  rm -rf "$LAZYGIT_DIR"
fi

echo "==> Installing yazi..."
if command -v yazi >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  YAZI_DIR=$(mktemp -d)
  wget "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip" -O "$YAZI_DIR/yazi.zip"
  unzip -o "$YAZI_DIR/yazi.zip" -d "$YAZI_DIR"
  sudo cp "$YAZI_DIR/yazi-x86_64-unknown-linux-musl/ya" /usr/local/bin/
  sudo cp "$YAZI_DIR/yazi-x86_64-unknown-linux-musl/yazi" /usr/local/bin/
  rm -rf "$YAZI_DIR"
fi

echo "==> Installing fastfetch..."
if command -v fastfetch >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  FASTFETCH_VER=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep tag_name | cut -d'"' -f4)
  FASTFETCH_DIR=$(mktemp -d)
  wget "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VER}/fastfetch-linux-amd64.tar.gz" -O "$FASTFETCH_DIR/fastfetch.tar.gz"
  tar xf "$FASTFETCH_DIR/fastfetch.tar.gz" -C "$FASTFETCH_DIR"
  sudo mv "$FASTFETCH_DIR"/fastfetch-linux-amd64/usr/bin/fastfetch /usr/local/bin/
  rm -rf "$FASTFETCH_DIR"
fi

echo "==> Installing glow..."
if command -v glow >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  GLOW_VER=$(curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest | grep tag_name | cut -d'"' -f4)
  GLOW_DIR=$(mktemp -d)
  wget "https://github.com/charmbracelet/glow/releases/download/${GLOW_VER}/glow_${GLOW_VER#v}_Linux_x86_64.tar.gz" -O "$GLOW_DIR/glow.tar.gz"
  sudo tar xf "$GLOW_DIR/glow.tar.gz" -C /usr/local/bin "glow"
  rm -rf "$GLOW_DIR"
fi

echo "==> Installing uv..."
if command -v uv >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"

echo "==> Installing fnm..."
if command -v fnm >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsSL https://fnm.vercel.app/install | bash
fi

echo "==> Installing opencode..."
if command -v opencode >/dev/null 2>&1; then
  echo "  already installed, skipping."
else
  curl -fsSL https://opencode.ai/install | bash
fi

echo "==> Done! Log out and back in."
