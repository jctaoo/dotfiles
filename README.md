# Chezmoi Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports macOS, Linux (Arch, Debian), and Windows (pwsh).

Terminal stack: zsh + Neovim + WezTerm.

Managed configurations:

- **zsh**: environment variables, aliases, autosuggestions, syntax highlighting
- **Neovim**: Lua config based on AstroNvim
- **WezTerm**: terminal emulator config (recommended terminal, see below)
- **Yazi**: terminal file manager config and plugins
- **Lazygit**: TUI Git client config
- **btop**: system resource monitor config
- **fastfetch**: system info display config
- **glow**: Markdown reader config
- **starship**: cross-shell prompt config
- **opencode**: AI assistant config

---

## TODO

These distros are not yet supported:

- [ ] **NixOS** - needs Nix package management adaptation
- [ ] **Fedora** - needs `dnf` install flow testing
- [ ] **openSUSE** - needs `zypper` install flow testing
- [ ] **Ubuntu LTS** - needs long-term support version compatibility testing
- [ ] **Alpine Linux** - needs `apk` and musl libc adaptation

---

## Quick Start

```bash
# 1. Install yay (if not already installed)
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
cd /tmp/yay-bin && makepkg -si && cd -

# 2. Install all recommended packages from this repo
yay -S --needed - < archpackages.txt

# 3. Install and initialize chezmoi
chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
chezmoi apply

# 4. Set default shell to zsh
chsh -s $(which zsh)

# 5. Log out and back in, launch WezTerm
```

---

## Table of Contents

1. [Recommended Packages](#recommended-packages)
2. [Packages by Category](#packages-by-category)
   - [Base System and Build Tools](#base-system-and-build-tools)
   - [Shell and Terminal Environment](#shell-and-terminal-environment)
   - [Modern CLI Replacements and File Tools](#modern-cli-replacements-and-file-tools)
   - [Development Tools](#development-tools)
   - [System Monitoring and Info](#system-monitoring-and-info)
   - [Media, Documents and Compression](#media-documents-and-compression)
   - [Fonts](#fonts)
   - [Package Managers and AI Assistant](#package-managers-and-ai-assistant)
3. [Recommended Terminal: WezTerm](#recommended-terminal-wezterm)

---

## Recommended Packages

List from `yay -Qe` (explicitly installed packages), organized by category. Install these on a fresh Arch system to match this dotfiles setup.

Full package list in [`archpackages.txt`](./archpackages.txt), install with `yay -S --needed - < archpackages.txt`.

| Category | Packages |
|----------|----------|
| Base System and Build Tools | `base`, `base-devel`, `pacman-contrib` |
| Shell and Terminal Environment | `zsh`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `starship`, `chezmoi`, `wezterm` |
| Modern CLI Replacements and File Tools | `bat`, `eza`, `fd`, `fzf`, `ripgrep`, `zoxide`, `yazi`, `trash-cli`, `less` |
| Development Tools | `git`, `github-cli`, `git-delta`, `lazygit`, `neovim`, `fnm`, `uv`, `jq`, `openssh` |
| System Monitoring and Info | `btop`, `fastfetch` |
| Media, Documents and Compression | `chafa`, `glow`, `imagemagick`, `libheif`, `perl-image-exiftool`, `7zip`, `unzip` |
| Fonts | `noto-fonts-emoji`, `otf-monaspace-nerdfonts`, `ttf-juliamono`, `ttf-lxgw-wenkai-screen` |
| Package Managers and AI Assistant | `yay-bin`, `yay-bin-debug`, `opencode` (`yay-*` must be installed manually first, not in `archpackages.txt`) |

---

## Packages by Category

### Base System and Build Tools

| Package | Description |
|---------|-------------|
| `base` | Arch Linux base system metapackage, includes `filesystem`, `bash`, `coreutils`. |
| `base-devel` | Development toolchain for building AUR packages, includes `make`, `gcc`, `autoconf`, `sudo`. |
| `pacman-contrib` | Additional `pacman` tools like `paccache` (cache cleanup), `checkupdates` (update check). |

### Shell and Terminal Environment

| Package | Description |
|---------|-------------|
| `zsh` | Unix shell, set as default login shell in this config. |
| `zsh-autosuggestions` | Provides gray autosuggestions based on history and completions. |
| `zsh-syntax-highlighting` | Real-time command syntax highlighting, red for invalid, green for valid. |
| `starship` | Cross-shell prompt, displays git, language versions, execution time. |
| `chezmoi` | Core tool for this repo, manages dotfiles across machines. |
| `wezterm` | GPU-accelerated terminal emulator, config managed with this repo, supports tabs, panes, Lua config. |

### Modern CLI Replacements and File Tools

| Package | Description |
|---------|-------------|
| `bat` | `cat` replacement with syntax highlighting, Git diff, line numbers. |
| `eza` | `ls` replacement with color output, tree view, Git status. |
| `fd` | `find` replacement, ignores `.git` and hidden files by default. |
| `fzf` | General fuzzy finder, integrates with shell history, files, git. |
| `ripgrep` (`rg`) | Recursive text search, ignores `.gitignore` files by default. |
| `zoxide` | `cd` replacement, learns history for fast directory jumping. |
| `yazi` | Terminal file manager with async IO, plugins, image preview. |
| `trash-cli` | Moves files to trash, avoids `rm` accidents. |
| `less` | Pager, used by `git`, `bat`, `man`. |

### Development Tools

| Package | Description |
|---------|-------------|
| `git` | Distributed version control, this config includes aliases and delta diff highlighting. |
| `github-cli` (`gh`) | GitHub CLI, handles PRs, Issues, Releases from terminal. |
| `git-delta` | Git diff / blame beautifier with syntax highlighting. |
| `lazygit` | Terminal TUI Git client. |
| `neovim` | Vim editor (v0.12+), this repo includes full Lua config. |
| `fnm` | Fast Node Manager for switching Node.js versions. |
| `uv` | Python package and project manager (replaces `pip` + `venv` + `pip-tools`). |
| `jq` | Command-line JSON processor for parsing and transforming JSON in pipelines. |
| `openssh` | SSH client and server for remote login and Git operations. |

### System Monitoring and Info

| Package | Description |
|---------|-------------|
| `btop` | System resource monitor, displays CPU, memory, disk, network, processes. |
| `fastfetch` | System info display tool (neofetch successor). |

### Media, Documents and Compression

| Package | Description |
|---------|-------------|
| `chafa` | Converts images to ASCII art or Sixel preview in terminal. |
| `glow` | Terminal Markdown reader, supports local files and remote URLs. |
| `imagemagick` | Image processing suite with `convert`, `identify` commands. |
| `libheif` | HEIF/HEIC image format support, enables Yazi to preview iPhone photos. |
| `perl-image-exiftool` | Reads and edits image, audio, video metadata (EXIF). |
| `7zip` | Supports 7z, zip, rar and other compression formats. |
| `unzip` | ZIP extraction tool. |

### Fonts

| Package | Description |
|---------|-------------|
| `noto-fonts-emoji` | Google Noto color emoji font. |
| `otf-monaspace-nerdfonts` | GitHub Monaspace programming font + Nerd Font icon patches. |
| `ttf-juliamono` | Julia language monospace font with ligatures and Unicode support. |
| `ttf-lxgw-wenkai-screen` | LXGW WenKai screen reading edition for Chinese terminal and reading. |

### Package Managers and AI Assistant

| Package | Description |
|---------|-------------|
| `yay-bin` | AUR helper precompiled binary for installing AUR packages. **Must be installed manually first, not in `archpackages.txt`.** |
| `yay-bin-debug` | Debug symbols for `yay-bin`, not needed for regular users. |
| `opencode` | Terminal AI programming assistant, config managed with this repo. |

---

## Recommended Terminal: WezTerm

This dotfiles setup recommends [WezTerm](https://wezfurlong.org/wezterm/) as the terminal emulator:

- GPU-accelerated rendering with OpenGL
- Cross-platform, same Lua config works on Arch Linux, Windows, macOS
- Built-in Workspace, Tab, Pane management, no tmux needed
- Config logic versioned with dotfiles repo in `dot_config/wezterm/`
- Displays Nerd Font and emoji with `otf-monaspace-nerdfonts` and `noto-fonts-emoji`

Install WezTerm:

```bash
sudo pacman -S wezterm
```

Windows:

```powershell
winget install wez.wezterm
```

---

## License

This repo is open source under the MIT License (or retain your own license).
