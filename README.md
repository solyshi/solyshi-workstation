# solyshi-workstation

Personal dotfiles and system configuration for an Arch Linux workstation running Hyprland on Wayland.
Managed with GNU Stow, structured for reproducibility and easy bootstrap on a fresh install.

---

## Table of Contents

- [System](#system)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Theming](#theming)
- [Components](#components)
  - [Hyprland](#hyprland)
  - [Neovim](#neovim)
  - [Tmux](#tmux)
  - [Zsh](#zsh)
- [Roadmap](#roadmap)

---

## System

| Component     | Choice                 |
|---------------|------------------------|
| OS            | Arch Linux             |
| Kernel        | linux-lts              |
| WM            | Hyprland (Wayland)     |
| Bar           | Waybar                 |
| Terminal      | Kitty                  |
| Shell         | Zsh + Powerlevel10k    |
| Editor        | Neovim                 |
| Launcher      | Rofi (wayland)         |
| Notifications | Mako                   |
| Browser       | Qutebrowser            |
| File Manager  | Dolphin                |
| Music         | Spotify + Spicetify    |
| Theming       | matugen (Material You) |
| Dotfile Mgmt  | GNU Stow               |

---

## Repository Structure

```
solyshi-workstation/
├── dotfiles/
│   ├── hypr/         # Hyprland config (split into appearance, keybinds, rules, scripts)
│   ├── waybar/       # Bar config, styles, launch script
│   ├── kitty/        # Terminal colors and config
│   ├── nvim/         # Neovim config (lazy.nvim, LSP, plugins)
│   ├── zsh/          # .zshrc, .zprofile, p10k
│   ├── tmux/         # tmux config with TPM
│   ├── rofi/         # Launcher theme and powermenu
│   ├── mako/         # Notification daemon config
│   ├── matugen/      # Color generation templates for all apps
│   ├── qutebrowser/  # Browser config and colors
│   ├── spicetify/    # Spotify theming
│   ├── theme/        # Wallpaper picker and apply script
│   ├── emacs/        # Emacs config (secondary editor)
│   └── scripts/      # Utility scripts (tmux-sessionizer, etc.)
├── install/
│   └── bootstrap.sh  # Interactive bootstrap script with dry-run support
├── packages/
│   ├── 01-base.txt
│   ├── 02-desktop.txt
│   ├── 03-dev.txt
│   └── 04-apps.txt
└── profiles/
    └── desktop.stow  # Stow profile for desktop setup
```

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/Chri1899/solyshi-workstation.git ~/solyshi-workstation
cd ~/solyshi-workstation
```

### 2. Run the bootstrap script

The script supports an interactive menu and a dry-run mode to preview changes before applying.

```bash
bash install/bootstrap.sh
```

Available options:

- Dry-run mode — preview all actions without applying them
- Interactive package group selection (base, desktop, dev, apps)
- Automatic stow of dotfiles

### 3. Apply dotfiles manually (optional)

To stow individual packages without the bootstrap script:

```bash
cd ~/solyshi-workstation
stow -d ~/solyshi-workstation/dotfiles -t ~ $(cat ~/solyshi-workstation/profiles/desktop.stow)
OR
stow -d dotfiles -t ~ hypr kitty nvim zsh tmux waybar rofi mako matugen
```

---

## Theming

Colors are generated with [matugen](https://github.com/InioX/matugen) based on the current wallpaper using Material You color extraction.

Templates are provided for:

| App         | Template file                             |
|-------------|-------------------------------------------|
| Hyprland    | `matugen/templates/hyprland-colors.conf`  |
| Kitty       | `matugen/templates/kitty-colors.conf`     |
| Waybar      | `matugen/templates/waybar-colors.css`     |
| Rofi        | `matugen/templates/rofi-colors.rasi`      |
| Mako        | `matugen/templates/mako-colors`           |
| Qutebrowser | `matugen/templates/qute-colors.py`        |
| Spicetify   | `matugen/templates/spicetify-color.ini`   |
| Vesktop     | `matugen/templates/vesktop-colors.css`    |

To regenerate colors from a wallpaper:

```bash
matugen image /path/to/wallpaper.jpg
```

The wallpaper picker at `dotfiles/theme/.config/theme/wallpaper-picker.sh` handles switching wallpapers and triggering color regeneration automatically.

---

## Components

### Hyprland

Config is split into logical files, all sourced from `hyprland.conf`:

```
hypr/
├── hyprland.conf
├── appearance/
│   ├── colors.conf
│   ├── general.conf
│   ├── layouts.conf
│   ├── monitors.conf
│   └── theme.conf
├── functionallity/
│   ├── autostart.conf
│   ├── input.conf
│   └── programs.conf
├── keybinds/
│   ├── apps.conf
│   ├── main.conf
│   ├── media.conf
│   └── navigation.conf
├── rules/
│   ├── layerrules.conf
│   └── windowrules.conf
└── scripts/
    ├── toggle-scratch-btop.sh
    └── toggle-scratch-term.sh
```

### Neovim

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)

| Category   | Plugin(s)                  |
|------------|----------------------------|
| LSP        | nvim-lspconfig, Mason      |
| Completion | blink-cmp                  |
| Syntax     | Treesitter                 |
| Git        | Neogit, Gitsigns, Diffview |
| Navigation | FZF                        |
| Formatting | Conform                    |
| Java       | nvim-java                  |

### Tmux

Plugin manager: TPM

| Plugin         | Purpose                         |
|----------------|---------------------------------|
| tmux-resurrect | Persist sessions across reboots |
| tmux-continuum | Automatic session saving        |

Session management via the `tmux-sessionizer` script, bound to a keybind in Hyprland.

### Zsh

- Prompt: Powerlevel10k
- History: XDG-compliant location
- Navigation: `zoxide` (smart `cd`), `eza` (modern `ls`)
- Plugins: syntax highlighting, autosuggestions, completions
- Colored man pages, sensible `setopt` defaults

---

## Roadmap

- [ ] Keybind cheatsheet (floating Kitty window + glow + Markdown)
- [ ] Rofi theme polish
- [ ] Lockscreen setup (hyprlock + hypridle)
- [ ] Vim-Tmux-Navigator integration
- [ ] Zsh cleanup pass
- [ ] Offline documentation (Zeal + dasht)
- [ ] cheat.sh integration (curl or Neovim plugin)
- [ ] Properly integrate overseer task runner in nvim for every possible stack I use
- [ ] Unified documentation language throughout the repo 
- [ ] Replace neovim rust_analyzer with rustaceanvim eventually
- [ ] Extend Waybar with more useful modules
- [ ] Replace some UI packages with Quickshell eventually
