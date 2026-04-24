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
| Display Manager | SDDM (Silent theme)    |
| Notifications | Mako                   |
| Browser       | Qutebrowser            |
| File Manager  | Nautilus               |
| Music         | Spotify + Spicetify    |
| Theming       | matugen (Material You) |
| Dotfile Mgmt  | GNU Stow               |

---

## Repository Structure
```
solyshi-workstation/
├── dotfiles/
│   ├── hypr/                   # Hyprland config (split into appearance, keybinds, rules, scripts)
│   ├── waybar/                 # Bar config, styles, launch script
│   ├── yazi/                   # TUI File Browser configs 
│   ├── kitty/                  # Terminal colors and config
│   ├── nvim/                   # Neovim config (lazy.nvim, LSP, plugins)
│   ├── zsh/                    # .zshrc, .zprofile, p10k
│   ├── tmux/                   # tmux config with TPM
│   ├── rofi/                   # Launcher theme and powermenu
│   ├── mako/                   # Notification daemon config
│   ├── matugen/                # Color generation templates for all apps
│   ├── qutebrowser/            # Browser config and colors
│   ├── spicetify/              # Spotify theming
│   ├── theme/                  # Wallpaper picker and apply script
│   ├── emacs/                  # Emacs config (secondary editor)
│   └── nautilus/               # File Browser Configurations
├── install/
│   ├── bootstrap.sh            # Interactive bootstrap script with dry-run support
│   └── lib/
│       ├── packages.sh         # yay, package group installation
│       ├── toolchains.sh       # Rust, SDKMAN, Spicetify setup
│       ├── services.sh         # systemd services, SDDM, boot config
│       └── dotfiles.sh         # stow linking, shell, directories
│   └── packages/
│       ├── 01-base.txt
│       ├── 02-desktop.txt
│       ├── 03-dev.txt
│       └── 04-apps.txt
├── system/
│   └── sddm/
│       └── sddm.conf.d/
│           └── theme.conf      # SDDM theme selection (symlinked to /etc/sddm.conf.d/)
├── scripts/                    # Utility scripts (tmux-sessionizer, etc.)
└── profiles/
    └── desktop.stow  # Stow profile for desktop setup
```

---

## Installation

### 1. Clone the repository

> **Note:** SSH is required. If you don't have an SSH key yet, the bootstrap script handles this in Stage 1 — just run it and follow the prompts.

```bash
git clone git@github.com:solyshi/solyshi-workstation.git ~/solyshi-workstation
cd ~/solyshi-workstation
```

### 2. Configure keyboard layout

Before running the script, set your keyboard layout at the top of `install/bootstrap.sh`:
```bash
KEYBOARD_LAYOUT="de"   # change to e.g. us, fr, gb
```

### 3. Run the bootstrap script

```bash
bash install/bootstrap.sh           # interactive wizard
bash install/bootstrap.sh --dry-run # preview without applying
```

The script runs six stages in order. Each component within a stage is individually confirm-prompted — nothing is installed without your explicit `y`.

| Stage | What it covers |
|-------|---------------|
| 1 — Identity & Auth | SSH key gen, git config, gh auth login |
| 2 — System Config | Hostname, timezone, locale |
| 3 — Packages | Granular package groups with hardware detection |
| 4 — Services | systemd services (NetworkManager, bluetooth, fstrim, etc.) |
| 5 — Dotfiles | GNU Stow linking, XDG directories, keyboard layout |
| 6 — First Boot | TPM plugins, matugen initial run, boot entry, summary |

### 4. Post-install

- Update `dotfiles/hypr/appearance/monitors.conf` for your specific display setup
- Add a default wallpaper at `assets/wallpaper/default.jpg` if you skipped the matugen step
- Reboot

### 5. Apply dotfiles manually (optional)

To stow individual packages without the bootstrap script:
```bash
cd ~/solyshi-workstation
stow --no-folding -d dotfiles -t ~ $(cat profiles/desktop.stow)
```

---

## Swap

Swap is not configured by the bootstrap script — the right choice depends on your hardware.

**Swapfile (recommended for most desktops):**
```bash
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
```

**zram (recommended for low-RAM systems or SSDs you want to protect):**
```bash
yay -S zram-generator
sudo tee /etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0
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
├── functionality/
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

| Category      | Plugin(s)                          |
|---------------|------------------------------------|
| LSP           | nvim-lspconfig, Mason              |
| Completion    | blink-cmp                          |
| Snippets      | LuaSnip, friendly-snippets         |
| Syntax        | Treesitter                         |
| Git           | Neogit, Gitsigns, Diffview         |
| Navigation    | fzf-lua                            |
| Formatting    | Conform                            |
| Java          | nvim-java                          |
| C++/CMake     | cmake-tools.nvim                   |
| File Manager  | ranger.nvim                        |
| UI            | snacks.nvim, slimline.nvim         |
| Editing       | nvim-autopairs, nvim-ts-autotag    |
| Utilities     | todo-comments, undotree, csvview   |
| Tmux          | vim-tmux-navigator                 |

Build/Run philosophy: stack-specific CLI commands via tmux, no unified build abstraction in Neovim.

### Tmux

Plugin manager: TPM

| Plugin                | Purpose                         |
|-----------------------|---------------------------------|
| tmux-resurrect        | Persist sessions across reboots |
| tmux-continuum        | Automatic session saving        |
| vim-tmux-navigator    | Seamless Neovim/tmux navigation |

Session management via the `tmux-sessionizer` script, bound to a keybind in Hyprland.
Workflow: one tmux session per project, window 1 = Neovim, window 2 = build/run terminal.

### Zsh

- Prompt: Powerlevel10k
- History: XDG-compliant location
- Navigation: `zoxide` (smart `cd`), `eza` (modern `ls`)
- Plugins: syntax highlighting, autosuggestions, completions
- Colored man pages, sensible `setopt` defaults

---

### Display Manager

SDDM with the [Silent theme](https://github.com/uiriansan/SilentSDDM) — a minimal, Qt6-native greeter.

The theme config is stored in `system/sddm/sddm.conf.d/theme.conf` and symlinked to `/etc/sddm.conf.d/` during setup.

> **Note:** After running the bootstrap script, activate SDDM manually if not already done:
> ```bash
> sudo systemctl enable --now sddm
> ```

---

## Issue → PR Workflow

1. **Pick issue** — `<leader>gi` → open in Octo → assign yourself
2. **Create branch** — `<ENTER>` -> develop issue
3. **Do the work** — commit as you go with Neogit (`<leader>gg`) or lazygit
4. **Push** — Neogit push menu → `u`
5. **Open PR** — `<leader>gP` in Octo (branch already linked to issue via `gh issue develop`, no `Closes #X` needed)
6. **Merge** — `<leader>gp` → open PR → merge
7. **Clean up**
   ```bash
   git checkout main && git pull
   git branch -d <branch>
   git push origin --delete <branch>
   ```
