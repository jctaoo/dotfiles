#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system..."
yay -Syu --noconfirm

echo "==> Installing packages..."
yay -S --noconfirm --needed \
  base \
  base-devel \
  pacman-contrib \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  starship \
  chezmoi \
  wezterm \
  bat \
  eza \
  fd \
  fzf \
  ripgrep \
  zoxide \
  yazi \
  trash-cli \
  less \
  git \
  github-cli \
  git-delta \
  lazygit \
  neovim \
  fnm \
  uv \
  jq \
  openssh \
  btop \
  fastfetch \
  chafa \
  glow \
  imagemagick \
  libheif \
  perl-image-exiftool \
  7zip \
  unzip \
  noto-fonts-emoji \
  otf-monaspace-nerdfonts \
  ttf-juliamono \
  ttf-lxgw-wenkai-screen \
  opencode

echo "==> Done! Log out and back in."
