# Required Packages & Fonts

This file lists the software and fonts that are expected to be installed before applying this chezmoi configuration.

The dotfiles assume these tools are available on `PATH`. Optional convenience tools are not guarded at runtime, so missing binaries will cause errors or broken features.

---

## Core

| Package | Used by | Install notes |
|---------|---------|---------------|
| `chezmoi` | dotfiles management | <https://chezmoi.io/install/> |
| `git` | chezmoi, git config, lazygit | usually pre-installed |
| `zsh` | shell | set as login shell with `chsh -s $(command -v zsh)` |

## Terminal

| Package | Used by | Install notes |
|---------|---------|---------------|
| `wezterm` | terminal emulator | <https://wezfurlong.org/wezterm/installation.html> |
| `starship` | shell prompt | `curl -sS https://starship.rs/install.sh \| sh` |

## Editor

| Package | Used by | Install notes |
|---------|---------|---------------|
| `neovim` | editor, chezmoi merge/edit | `nvim` must be on `PATH` |
| `delta` | git pager, chezmoi diff | <https://dandavison.github.io/delta/installation.html> |

## Shell / CLI essentials

| Package | Used by | Install notes |
|---------|---------|---------------|
| `fzf` | fuzzy finder | `pacman -S fzf`, `brew install fzf`, etc. |
| `fd` | `fzf` file list | package name may be `fd-find` on Debian/Ubuntu |
| `bat` | `fzf` preview, `cat` alias | package name may be `bat` or `batcat` |
| `eza` | `fzf` directory preview | `pacman -S eza`, `brew install eza` |
| `zoxide` | `z` / `zi` navigation, `yazi` integration | `pacman -S zoxide`, `brew install zoxide` |
| `yazi` | terminal file manager | <https://yazi-rs.github.io/docs/installation> |
| `lazygit` | `lg` alias | `pacman -S lazygit`, `brew install lazygit` |
| `trash-cli` | `trash`, `trm`, `trr` aliases | provides `trash-put`, `trash-restore` |
| `opencode` | `opencode` alias | <https://opencode.ai> |

### Extra utilities used by aliases

| Package | Used by | Install notes |
|---------|---------|---------------|
| `file` | `cat` alias (file type detection) | usually pre-installed |
| `imagemagick` | `cat` alias (image preview) | provides `magick` |
| `chafa` | `cat` alias (image preview in terminal) | `pacman -S chafa`, `brew install chafa` |

## Git tooling

| Package | Used by | Install notes |
|---------|---------|---------------|
| `delta` | git pager | see Editor section |
| `lazygit` | TUI git client | see Shell / CLI essentials |

## System monitoring / info

| Package | Used by | Install notes |
|---------|---------|---------------|
| `btop` | system resource monitor | `pacman -S btop`, `brew install bop` |
| `fastfetch` | system info | `pacman -S fastfetch`, `brew install fastfetch` |

## Programming languages / runtimes

| Package | Used by | Install notes |
|---------|---------|---------------|
| `uv` | Python runner, Starship python module | <https://docs.astral.sh/uv/getting-started/installation/> |
| `Node.js` / `npm` | AstroNvim / Neovim plugins | required by some LSPs/formatters loaded by AstroNvim |

## Distro-specific helpers

| Distro | Package | Used by | Install notes |
|--------|---------|---------|---------------|
| Arch | `pacman-contrib` | `super-clean` script | provides `paccache` |
| Arch | `yay` | `super-clean` script | AUR helper |

## Fonts

The WezTerm configuration uses the following font stack. Install the ones you need for your platform and language coverage.

| Font | Purpose | Where to get |
|------|---------|--------------|
| `Monaspace Argon NF` | Primary monospace font (Nerd Font) | <https://monaspace.githubnext.com/> |
| `PingFang SC` | CJK fallback (macOS system font) | pre-installed on macOS |
| `LXGW WenKai Mono Screen` | CJK / aesthetic fallback | <https://github.com/lxgw/LxgwWenKai> |
| `JuliaMono` | Math / Unicode fallback | <https://juliamono.netlify.app/> |
| `Noto Color Emoji` | Emoji | <https://fonts.google.com/noto/specimen/Noto+Color+Emoji> |

> If a font is missing, WezTerm will fall back to system defaults, but the intended appearance may be lost.

## Optional / theme extras

| Item | Used by | Notes |
|------|---------|-------|
| `Catppuccin Mocha` bat theme | `bat` dark theme | install via `bat` theme directory |
| `GitHub` bat theme | `bat` light theme | install via `bat` theme directory |

## Quick install commands

### Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S --needed chezmoi git zsh neovim wezterm starship fzf fd bat eza zoxide yazi lazygit trash-cli file imagemagick chafa btop fastfetch pacman-contrib
# yay (AUR helper) — install manually from https://github.com/Jguer/yay
# uv — install manually from https://docs.astral.sh/uv/
```

### macOS (Homebrew)

```bash
brew install chezmoi git zsh neovim wezterm starship fzf fd bat eza zoxide yazi lazygit trash-cli imagemagick chafa btop fastfetch uv
```

### Windows (scoop / winget)

```powershell
# scoop
scoop install chezmoi git zsh neovim wezterm starship fzf fd bat eza zoxide yazi lazygit trash-cli imagemagick chafa btop fastfetch uv

# or winget (package names may vary)
winget install Microsoft.PowerShell wezterm.wezterm Starship.Starship fzf sharkdp.bat eza-community.eza sxyazi.yazi jesseduffield.lazygit uutils.coreutils Fastfetch-cli.Fastfetch Astral.Uv
```

> On Windows, `zsh` and some Unix-centric tools are typically used inside WSL, MSYS2, or Git Bash rather than native Windows.
