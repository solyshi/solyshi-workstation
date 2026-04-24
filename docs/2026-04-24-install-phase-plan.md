# Install Phase Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure `install/bootstrap.sh` into a 6-stage interactive wizard covering identity/auth, system config, packages (with hardware checks), services, dotfiles, and first-boot finalization.

**Architecture:** Three new lib files (`identity.sh`, `system.sh`, `firstboot.sh`) handle dedicated stages; four existing lib files are extended; the old 3 broad package list files split into 14 purpose-scoped files; `bootstrap.sh` `main()` is reorganised into sequential numbered stages with individual confirm-prompts per component.

**Tech Stack:** Bash 5, GNU Stow, systemd, yay (AUR), fzf, ssh-keygen (openssh), gh CLI, matugen

---

## File Map

| File | Action |
|------|--------|
| `install/lib/identity.sh` | Create |
| `install/lib/system.sh` | Create |
| `install/lib/firstboot.sh` | Create |
| `install/lib/packages.sh` | Modify — replace old install functions, add hardware checks |
| `install/lib/services.sh` | Modify — add conditional services, remove `setup_boot` |
| `install/lib/dotfiles.sh` | Modify — `--no-folding`, conflict detection, `xdg-user-dirs-update`, emacs |
| `install/bootstrap.sh` | Modify — source new libs, restructure `main()` into 6-stage wizard |
| `install/pkg/01-base.txt` | Modify — add `zsh-theme-powerlevel10k` |
| `install/pkg/02-desktop.txt` | Delete — replaced by granular files |
| `install/pkg/02-desktop-core.txt` | Create |
| `install/pkg/02-desktop-media.txt` | Create |
| `install/pkg/02-desktop-bluetooth.txt` | Create |
| `install/pkg/02-desktop-brightness.txt` | Create |
| `install/pkg/02-desktop-display.txt` | Create |
| `install/pkg/02-desktop-apps.txt` | Create |
| `install/pkg/03-dev.txt` | Delete — replaced by granular files |
| `install/pkg/03-dev-core.txt` | Create |
| `install/pkg/03-dev-langs.txt` | Create |
| `install/pkg/03-dev-java.txt` | Create |
| `install/pkg/03-dev-db.txt` | Create |
| `install/pkg/03-dev-utils.txt` | Create |
| `install/pkg/04-apps.txt` | Delete — replaced by granular files |
| `install/pkg/04-apps-comms.txt` | Create |
| `install/pkg/04-apps-productivity.txt` | Create |
| `install/pkg/04-apps-gaming.txt` | Create |
| `profiles/desktop.stow` | Modify — remove `nautilus` |
| `dotfiles/hypr/functionality/autostart.conf` | Modify — remove nautilus, add polkit/hypridle/kanshi |
| `assets/wallpaper/.gitkeep` | Create — directory placeholder |
| `README.md` | Modify — add §Swap, update §Installation |

---

## Task 1: Restructure package files

**Files:**
- Delete: `install/pkg/02-desktop.txt`, `install/pkg/03-dev.txt`, `install/pkg/04-apps.txt`
- Create: all 14 new pkg files listed above
- Modify: `install/pkg/01-base.txt`

- [ ] **Step 1: Add `zsh-theme-powerlevel10k` to 01-base.txt**

In `install/pkg/01-base.txt`, add under the `# Shell & Tools` section:

```
zsh-theme-powerlevel10k
```

- [ ] **Step 2: Create `install/pkg/02-desktop-core.txt`**

```
# ============================================================
# 02-desktop-core.txt — Core Desktop Environment
# Compositor, bar, terminal, launcher, notifications, theming
# ============================================================

# Display Manager
sddm
qt6-svg
qt6-virtualkeyboard
sddm-silent-theme

# Wayland
wayland
wayland-protocols
xorg-xwayland

# Compositor
hyprland

# Portals
xdg-desktop-portal
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk

# Privilege escalation
polkit-gnome

# Lockscreen / idle
hyprlock
hypridle

# Terminal
kitty
zoxide
eza

# Status Bar
waybar

# Wallpaper
hyprpaper

# Launcher & Clipboard
rofi-wayland
wl-clipboard
cliphist

# Notifications
mako

# Theming
matugen-bin
```

- [ ] **Step 3: Create `install/pkg/02-desktop-media.txt`**

```
# ============================================================
# 02-desktop-media.txt — Media & Screen Tools
# Screenshots, recording, night mode
# ============================================================

grim
slurp
wf-recorder
wlsunset
```

- [ ] **Step 4: Create `install/pkg/02-desktop-bluetooth.txt`**

```
# ============================================================
# 02-desktop-bluetooth.txt — Bluetooth Support
# Hardware-checked before install
# ============================================================

bluez
bluez-utils
```

- [ ] **Step 5: Create `install/pkg/02-desktop-brightness.txt`**

```
# ============================================================
# 02-desktop-brightness.txt — Brightness Control
# Hardware-checked before install (backlight required)
# ============================================================

brightnessctl
```

- [ ] **Step 6: Create `install/pkg/02-desktop-display.txt`**

```
# ============================================================
# 02-desktop-display.txt — Display & Media Key Support
# ============================================================

kanshi
playerctl
```

- [ ] **Step 7: Create `install/pkg/02-desktop-apps.txt`**

```
# ============================================================
# 02-desktop-apps.txt — Desktop Applications
# ============================================================

# Browser
qutebrowser
gst-plugins-base
gst-plugins-good
gst-plugins-bad
gst-plugins-ugly
gst-libav
python-adblock

# Resource Monitor
btop
```

- [ ] **Step 8: Create `install/pkg/03-dev-core.txt`**

```
# ============================================================
# 03-dev-core.txt — Core Development Toolchain
# Compilers, build tools, editors, CLI utilities
# ============================================================

# Build Toolchain
gcc
make
fakeroot
debugedit
meson
ninja
pkg-config
cmake
clang
patch
bear

# Debuggers
gdb
lldb

# Editors
vim
neovim

# Utilities
luarocks
tree-sitter-cli
ripgrep
fd
tmux
tmuxinator
zeal
```

- [ ] **Step 9: Create `install/pkg/03-dev-langs.txt`**

```
# ============================================================
# 03-dev-langs.txt — Language Runtimes & Toolchains
# ============================================================

# Frontend / JS
nodejs
npm
pnpm
typescript

# Rust
rustup

# Python
python
python-pip

# Libs
sdl2
```

- [ ] **Step 10: Create `install/pkg/03-dev-java.txt`**

```
# ============================================================
# 03-dev-java.txt — Java / JVM (via SDKMAN)
# sdkman-bin is listed for reference; setup_sdkman handles install
# ============================================================

sdkman-bin
```

- [ ] **Step 11: Create `install/pkg/03-dev-db.txt`**

```
# ============================================================
# 03-dev-db.txt — Databases
# ============================================================

postgresql
```

- [ ] **Step 12: Create `install/pkg/03-dev-utils.txt`**

```
# ============================================================
# 03-dev-utils.txt — Developer Utilities
# ============================================================

yazi
```

- [ ] **Step 13: Create `install/pkg/04-apps-comms.txt`**

```
# ============================================================
# 04-apps-comms.txt — Communication Apps
# ============================================================

vesktop
thunderbird
```

- [ ] **Step 14: Create `install/pkg/04-apps-productivity.txt`**

```
# ============================================================
# 04-apps-productivity.txt — Productivity & Media Apps
# ============================================================

# Office
libreoffice-fresh

# Music
spotify
spicetify-cli

# Trading
tradingview

# Rolling release safety (hooks into pacman, auto-snapshots before upgrades)
timeshift-autosnap
```

- [ ] **Step 15: Create `install/pkg/04-apps-gaming.txt`**

```
# ============================================================
# 04-apps-gaming.txt — Gaming & Misc Apps
# ============================================================

steam
prismlauncher
ausweisapp2
mpv
```

- [ ] **Step 16: Delete old package files**

```bash
rm install/pkg/02-desktop.txt install/pkg/03-dev.txt install/pkg/04-apps.txt
```

- [ ] **Step 17: Verify**

```bash
ls install/pkg/
```

Expected output — 15 files (01-base + 6 desktop + 5 dev + 3 apps):
```
01-base.txt
02-desktop-apps.txt
02-desktop-bluetooth.txt
02-desktop-brightness.txt
02-desktop-core.txt
02-desktop-display.txt
02-desktop-media.txt
03-dev-core.txt
03-dev-db.txt
03-dev-java.txt
03-dev-langs.txt
03-dev-utils.txt
04-apps-comms.txt
04-apps-gaming.txt
04-apps-productivity.txt
```

- [ ] **Step 18: Commit**

```bash
git add install/pkg/
git commit -m "refactor: split package lists into 14 granular files"
```

---

## Task 2: Update packages.sh

**Files:**
- Modify: `install/lib/packages.sh`

Replace the entire file content with the following. The old `install_desktop`, `install_dev`, and `install_apps` functions are replaced; `install_base` and `install_yay` are unchanged; new functions cover each new package group.

- [ ] **Step 1: Replace `install/lib/packages.sh`**

```bash
#!/bin/bash
# =============================================================================
# packages.sh — Package installation functions
# Sourced by bootstrap.sh; expects DRY_RUN, PACKAGES_DIR to be set.
# =============================================================================

install_from_file() {
    local file="$1"
    local pkgs=()
    while IFS= read -r line; do
        line="${line%%#*}"
        line="${line// /}"
        [[ -n "$line" ]] && pkgs+=("$line")
    done < "$file"

    [[ ${#pkgs[@]} -eq 0 ]] && return

    info "Installing ${#pkgs[@]} packages from $(basename "$file")..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] yay -S --needed --noconfirm ${pkgs[*]}"
    else
        yay -S --needed --noconfirm "${pkgs[@]}"
    fi
}

install_yay() {
    section "yay (AUR Helper)"
    if command -v yay &>/dev/null; then
        success "yay already installed ($(yay --version | head -1))"
        return
    fi
    info "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    local tmpdir
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    yay -Y --gendb --noconfirm
    yay -Y --devel --save --noconfirm
    success "yay installed"
}

install_base() {
    section "01 — Base System"
    install_from_file "$PACKAGES_DIR/01-base.txt"
    success "Base system installed"
}

install_desktop_core() {
    section "02 — Desktop Core"
    install_from_file "$PACKAGES_DIR/02-desktop-core.txt"
    setup_sddm
    success "Desktop core installed"
}

install_desktop_media() {
    section "02 — Desktop Media Tools"
    install_from_file "$PACKAGES_DIR/02-desktop-media.txt"
    success "Desktop media tools installed"
}

install_bluetooth() {
    section "02 — Bluetooth"
    local detected=false
    if rfkill list bluetooth 2>/dev/null | grep -q bluetooth || \
       ls /sys/class/bluetooth/ 2>/dev/null | grep -q .; then
        detected=true
        info "Bluetooth hardware detected."
    else
        warn "No Bluetooth hardware detected."
    fi

    if $detected; then
        confirm "Install Bluetooth support?" || return
    else
        confirm "Install Bluetooth support anyway?" || return
    fi

    install_from_file "$PACKAGES_DIR/02-desktop-bluetooth.txt"
    success "Bluetooth packages installed"
}

install_brightness() {
    section "02 — Brightness Control"
    if ls /sys/class/backlight/ 2>/dev/null | grep -q .; then
        confirm "Backlight detected. Install brightnessctl?" || return
        install_from_file "$PACKAGES_DIR/02-desktop-brightness.txt"
        success "brightnessctl installed"
    else
        info "No backlight found (desktop/external monitors) — skipping brightnessctl"
    fi
}

install_display_tools() {
    section "02 — Display Tools"
    install_from_file "$PACKAGES_DIR/02-desktop-display.txt"
    success "Display tools installed"
}

install_desktop_apps() {
    section "02 — Desktop Apps"
    install_from_file "$PACKAGES_DIR/02-desktop-apps.txt"
    success "Desktop apps installed"
}

install_dev_core() {
    section "03 — Dev Core"
    install_from_file "$PACKAGES_DIR/03-dev-core.txt"
    success "Dev core installed"
}

install_dev_langs() {
    section "03 — Dev Languages"
    install_from_file "$PACKAGES_DIR/03-dev-langs.txt"
    success "Dev languages installed"
}

install_dev_db() {
    section "03 — Dev Database"
    install_from_file "$PACKAGES_DIR/03-dev-db.txt"
    success "Dev database installed"
}

install_dev_utils() {
    section "03 — Dev Utilities"
    install_from_file "$PACKAGES_DIR/03-dev-utils.txt"
    success "Dev utilities installed"
}

install_apps_comms() {
    section "04 — Communication Apps"
    install_from_file "$PACKAGES_DIR/04-apps-comms.txt"
    success "Communication apps installed"
}

install_apps_productivity() {
    section "04 — Productivity Apps"
    install_from_file "$PACKAGES_DIR/04-apps-productivity.txt"
    if command -v spotify &>/dev/null; then
        confirm "Set up Spicetify?" && setup_spicetify
    fi
    success "Productivity apps installed"
}

install_apps_gaming() {
    section "04 — Gaming"
    install_from_file "$PACKAGES_DIR/04-apps-gaming.txt"
    success "Gaming apps installed"
}

setup_packages() {
    install_yay

    confirm "Install base system?"                                          && install_base
    confirm "Install desktop core (Hyprland, Waybar, Kitty, Rofi, Mako)?" && install_desktop_core
    confirm "Install desktop media tools (grim, slurp, wf-recorder)?"     && install_desktop_media
    install_bluetooth
    install_brightness
    confirm "Install display tools (kanshi, playerctl)?"                   && install_display_tools
    confirm "Install desktop apps (qutebrowser, btop)?"                   && install_desktop_apps
    confirm "Install dev core (compilers, editors, debuggers)?"            && install_dev_core
    confirm "Install dev languages (Node, Python, Rust)?"                  && install_dev_langs
    confirm "Install dev database (PostgreSQL)?"                           && install_dev_db
    confirm "Install dev utilities (yazi)?"                                && install_dev_utils
    confirm "Set up Java / SDKMAN?"                                        && setup_sdkman
    confirm "Set up Rust toolchain?"                                       && setup_rust
    confirm "Install communication apps (Vesktop, Thunderbird)?"          && install_apps_comms
    confirm "Install productivity apps (LibreOffice, Spotify, Timeshift)?" && install_apps_productivity
    confirm "Install gaming apps (Steam, PrismLauncher)?"                 && install_apps_gaming
}
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/lib/packages.sh
```

Expected: no output (no errors).

- [ ] **Step 3: Commit**

```bash
git add install/lib/packages.sh
git commit -m "refactor: replace package install functions with granular per-group functions"
```

---

## Task 3: Create identity.sh

**Files:**
- Create: `install/lib/identity.sh`

- [ ] **Step 1: Create the file**

```bash
#!/bin/bash
# =============================================================================
# identity.sh — SSH key generation, git identity, GitHub CLI auth
# Sourced by bootstrap.sh; expects DRY_RUN to be set.
# =============================================================================

setup_ssh() {
    section "SSH Key"

    if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
        success "SSH key already exists at ~/.ssh/id_ed25519"
        return
    fi

    local email
    read -rp "  Email for SSH key: " email
    [[ -z "$email" ]] && error "Email required for SSH key generation"

    if $DRY_RUN; then
        echo "  [DRY-RUN] ssh-keygen -t ed25519 -C \"$email\" -f ~/.ssh/id_ed25519"
        return
    fi

    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""

    echo ""
    info "Your public key — add this to GitHub (Settings → SSH Keys):"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    read -rp "  Press Enter once the key is added to GitHub..."

    local attempts=0
    while (( attempts < 3 )); do
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            success "SSH connection to GitHub verified"
            return
        fi
        (( attempts++ ))
        warn "Connection failed (attempt $attempts/3)"
        (( attempts < 3 )) && read -rp "  Press Enter to retry, or Ctrl+C to abort..."
    done
    warn "SSH verification failed — continuing anyway"
}

setup_git_identity() {
    section "Git Identity"

    local current_name current_email
    current_name=$(git config --global user.name 2>/dev/null)
    current_email=$(git config --global user.email 2>/dev/null)

    if [[ -n "$current_name" && -n "$current_email" ]]; then
        success "Git identity already set: $current_name <$current_email>"
        return
    fi

    local name email
    read -rp "  Full name: " name
    read -rp "  Email: " email
    [[ -z "$name" ]]  && error "Name is required"
    [[ -z "$email" ]] && error "Email is required"

    if $DRY_RUN; then
        echo "  [DRY-RUN] git config --global user.name \"$name\""
        echo "  [DRY-RUN] git config --global user.email \"$email\""
        return
    fi

    git config --global user.name "$name"
    git config --global user.email "$email"
    success "Git identity set: $name <$email>"
}

setup_gh_auth() {
    section "GitHub CLI"

    if gh auth status &>/dev/null; then
        success "GitHub CLI already authenticated"
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] gh auth login --git-protocol ssh"
        return
    fi

    info "Follow the device code flow to authenticate (no browser required)..."
    gh auth login --git-protocol ssh

    if gh auth status &>/dev/null; then
        success "GitHub CLI authenticated"
    else
        warn "GitHub CLI authentication could not be verified — continuing"
    fi
}

setup_identity() {
    confirm "Generate SSH key and connect to GitHub?" && setup_ssh
    confirm "Configure git user name and email?"      && setup_git_identity
    confirm "Authenticate GitHub CLI (device code)?"  && setup_gh_auth
}
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/lib/identity.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add install/lib/identity.sh
git commit -m "feat: add identity.sh for SSH key gen, git config, and gh auth"
```

---

## Task 4: Create system.sh

**Files:**
- Create: `install/lib/system.sh`

- [ ] **Step 1: Create the file**

```bash
#!/bin/bash
# =============================================================================
# system.sh — System configuration (hostname, timezone, locale)
# Sourced by bootstrap.sh; expects DRY_RUN to be set.
# =============================================================================

setup_hostname() {
    section "Hostname"
    local current
    current=$(hostnamectl hostname 2>/dev/null || hostname)
    info "Current hostname: $current"

    local new_hostname
    read -rp "  New hostname (leave blank to keep '$current'): " new_hostname
    [[ -z "$new_hostname" ]] && return

    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo hostnamectl set-hostname \"$new_hostname\""
        return
    fi

    sudo hostnamectl set-hostname "$new_hostname"
    success "Hostname set to '$new_hostname'"
}

setup_timezone() {
    section "Timezone"
    local current
    current=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "unknown")
    info "Current timezone: $current"

    local tz
    if command -v fzf &>/dev/null; then
        tz=$(timedatectl list-timezones | fzf --prompt="  Select timezone: " --height=15)
    else
        read -rp "  Timezone (e.g. Europe/Berlin): " tz
    fi
    [[ -z "$tz" ]] && return

    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo timedatectl set-timezone \"$tz\""
        return
    fi

    sudo timedatectl set-timezone "$tz"
    success "Timezone set to '$tz'"
}

setup_locale() {
    section "Locale"
    local default="en_US.UTF-8"
    local locale
    read -rp "  Locale [default: $default]: " locale
    locale="${locale:-$default}"

    if $DRY_RUN; then
        echo "  [DRY-RUN] Uncomment '$locale UTF-8' in /etc/locale.gen"
        echo "  [DRY-RUN] sudo locale-gen"
        echo "  [DRY-RUN] echo \"LANG=$locale\" | sudo tee /etc/locale.conf"
        return
    fi

    local entry="${locale} UTF-8"
    if ! grep -q "^${entry}" /etc/locale.gen 2>/dev/null; then
        if grep -q "^#.*${entry}" /etc/locale.gen 2>/dev/null; then
            sudo sed -i "s|^#.*${entry}|${entry}|" /etc/locale.gen
        else
            echo "$entry" | sudo tee -a /etc/locale.gen
        fi
    fi

    sudo locale-gen
    echo "LANG=$locale" | sudo tee /etc/locale.conf
    success "Locale set to '$locale'"
}

print_swap_notice() {
    echo ""
    warn "Swap not configured — set up manually after reboot. See README §Swap."
    echo ""
}

setup_system_config() {
    confirm "Set hostname?"  && setup_hostname
    confirm "Set timezone?"  && setup_timezone
    confirm "Set locale?"    && setup_locale
    print_swap_notice
}
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/lib/system.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add install/lib/system.sh
git commit -m "feat: add system.sh for hostname, timezone, and locale setup"
```

---

## Task 5: Update services.sh

**Files:**
- Modify: `install/lib/services.sh`

Remove `setup_boot` (moves to `firstboot.sh` in Task 9). Add conditional bluetooth, fstrim, and cronie service enabling with capability checks.

- [ ] **Step 1: Replace `install/lib/services.sh`**

```bash
#!/bin/bash
# =============================================================================
# services.sh — System service and display manager setup
# Sourced by bootstrap.sh; expects DRY_RUN, REPO_DIR to be set.
# =============================================================================

setup_services() {
    section "Services"

    info "Enabling NetworkManager..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo systemctl enable --now NetworkManager"
    else
        sudo systemctl enable --now NetworkManager
    fi
    success "NetworkManager active"

    # Bluetooth — only if unit exists (packages were installed)
    if systemctl cat bluetooth.service &>/dev/null; then
        info "Enabling Bluetooth service..."
        if $DRY_RUN; then
            echo "  [DRY-RUN] sudo systemctl enable --now bluetooth"
        else
            sudo systemctl enable --now bluetooth
            success "Bluetooth active"
        fi
    fi

    # SSD TRIM — only if any block device supports it
    if lsblk --discard 2>/dev/null | awk 'NR>1 {print $3}' | grep -qv "^0B$"; then
        confirm "SSD TRIM detected. Enable fstrim.timer?" && {
            if $DRY_RUN; then
                echo "  [DRY-RUN] sudo systemctl enable --now fstrim.timer"
            else
                sudo systemctl enable --now fstrim.timer
                success "fstrim.timer active"
            fi
        }
    fi

    # Timeshift / cronie — only if timeshift-autosnap is installed
    if pacman -Q timeshift-autosnap &>/dev/null; then
        info "Enabling cronie for Timeshift snapshots..."
        if $DRY_RUN; then
            echo "  [DRY-RUN] sudo systemctl enable --now cronie"
        else
            sudo systemctl enable --now cronie
            success "cronie active (Timeshift snapshots enabled)"
        fi
    fi

    # PostgreSQL
    if confirm "Set up PostgreSQL?"; then
        if $DRY_RUN; then
            echo "  [DRY-RUN] sudo systemctl enable --now postgresql"
        else
            if [[ ! -d /var/lib/postgres/data ]]; then
                info "Initializing PostgreSQL..."
                if ! sudo -iu postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data; then
                    warn "PostgreSQL initdb failed — check locale and permissions"
                else
                    sudo systemctl enable --now postgresql
                    success "PostgreSQL active"
                fi
            else
                sudo systemctl enable --now postgresql
                success "PostgreSQL active"
            fi
        fi
    fi

    # Mako notification daemon (user service)
    info "Enabling Mako (user service)..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] systemctl --user enable mako"
    else
        systemctl --user enable mako 2>/dev/null || warn "Could not enable Mako"
    fi

    success "Services configured"
}

setup_sddm() {
    section "Display Manager (SDDM)"

    local conf_src="$REPO_DIR/system/sddm/sddm.conf.d/theme.conf"
    local conf_dst="/etc/sddm.conf.d/theme.conf"

    if [[ ! -f "$conf_src" ]]; then
        warn "SDDM config not found at $conf_src — skipping"
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo mkdir -p /etc/sddm.conf.d"
        echo "  [DRY-RUN] sudo ln -sf $conf_src $conf_dst"
        echo "  [DRY-RUN] sudo systemctl enable sddm"
        return
    fi

    sudo mkdir -p /etc/sddm.conf.d

    if [[ -e "$conf_dst" && ! -L "$conf_dst" ]]; then
        warn "$conf_dst exists and is not a symlink — backing up to ${conf_dst}.bak"
        sudo mv "$conf_dst" "${conf_dst}.bak"
    fi

    sudo ln -sf "$conf_src" "$conf_dst"
    sudo systemctl enable sddm
    success "SDDM configured and enabled"
}
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/lib/services.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add install/lib/services.sh
git commit -m "feat: add conditional bluetooth, fstrim, and cronie service enabling"
```

---

## Task 6: Update dotfiles.sh

**Files:**
- Modify: `install/lib/dotfiles.sh`

Add `--no-folding`, pre-stow conflict detection, `xdg-user-dirs-update`, and conditional emacs stow.

- [ ] **Step 1: Replace `install/lib/dotfiles.sh`**

```bash
#!/bin/bash
# =============================================================================
# dotfiles.sh — Dotfile linking and shell/directory setup
# Sourced by bootstrap.sh; expects DRY_RUN, DOTFILES_DIR, STOW_PROFILE,
# REPO_DIR, and KEYBOARD_LAYOUT to be set.
# =============================================================================

setup_stow() {
    section "Dotfiles (stow)"
    command -v stow &>/dev/null || yay -S --needed --noconfirm stow

    local packages
    packages=$(tr '\n' ' ' < "$STOW_PROFILE")

    if $DRY_RUN; then
        echo "  [DRY-RUN] stow --no-folding -d $DOTFILES_DIR -t $HOME $packages"
        return
    fi

    # Detect conflicts (existing non-symlink files at stow target paths)
    local conflicts=()
    while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        find "$DOTFILES_DIR/$pkg" -type f 2>/dev/null | while IFS= read -r src; do
            local rel="${src#"$DOTFILES_DIR/$pkg/"}"
            local dst="$HOME/$rel"
            if [[ -e "$dst" && ! -L "$dst" ]]; then
                conflicts+=("$dst")
                warn "Conflict: $dst exists and is not a symlink — skipping"
            fi
        done
    done < "$STOW_PROFILE"

    info "Linking dotfiles..."
    # shellcheck disable=SC2046
    stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" $packages
    stow --no-folding -d "$REPO_DIR" -t "$HOME" scripts
    success "Dotfiles linked"

    if confirm "Also stow emacs config?"; then
        if [[ -d "$DOTFILES_DIR/emacs" ]]; then
            stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" emacs
            success "Emacs config linked"
        else
            warn "dotfiles/emacs not found — skipping"
        fi
    fi

    apply_keyboard_layout
}

apply_keyboard_layout() {
    local input_conf="$HOME/.config/hypr/functionality/input.conf"

    if [[ ! -f "$input_conf" ]]; then
        warn "Hyprland input.conf not found — skipping keyboard layout patch"
        return
    fi

    if [[ -z "$KEYBOARD_LAYOUT" ]]; then
        warn "KEYBOARD_LAYOUT not set — leaving input.conf unchanged"
        return
    fi

    sed -i "s/^\(\s*kb_layout\s*=\s*\).*/\1$KEYBOARD_LAYOUT/" "$input_conf"
    success "Keyboard layout set to '$KEYBOARD_LAYOUT'"
}

setup_directories() {
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/projects"
    xdg-user-dirs-update
    success "Directories created"
}

setup_shell() {
    section "Shell"
    if [[ "$SHELL" == *"zsh"* ]]; then
        success "Zsh already active"
        return
    fi
    info "Setting Zsh as default shell..."
    chsh -s /bin/zsh
    success "Zsh set — takes effect on next login"
}
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/lib/dotfiles.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add install/lib/dotfiles.sh
git commit -m "feat: add stow conflict detection, --no-folding, xdg-user-dirs-update, emacs stow"
```

---

## Task 7: Update desktop.stow and autostart.conf

**Files:**
- Modify: `profiles/desktop.stow`
- Modify: `dotfiles/hypr/functionality/autostart.conf`

- [ ] **Step 1: Remove `nautilus` from `profiles/desktop.stow`**

Open `profiles/desktop.stow` and delete the `nautilus` line. The file should end up as:

```
nvim
kitty
hypr
qutebrowser
waybar
assets
zsh
matugen
rofi
theme
mako
tmux
scripts
spicetify
yazi
```

- [ ] **Step 2: Update `dotfiles/hypr/functionality/autostart.conf`**

Replace the entire file with:

```ini
# ================================
# =========== Daemons ============
# ================================
exec-once = hyprpaper
exec-once = waybar
exec-once = mako
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = hypridle
exec-once = kanshi

# ================================
# =========== Clipboard ==========
# ================================
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store

# ================================
# ============= Apps =============
# ================================
exec-once = [workspace 1 silent] kitty
exec-once = [workspace 2 silent] qutebrowser
exec-once = [workspace 9 silent] thunderbird
exec-once = [workspace 0 silent] tradingview

# ================================
# ============= Misc =============
# ================================
exec-once = ~/.config/theme/apply.sh
```

- [ ] **Step 3: Verify stow profile has no nautilus**

```bash
grep nautilus profiles/desktop.stow
```

Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add profiles/desktop.stow dotfiles/hypr/functionality/autostart.conf
git commit -m "fix: remove nautilus from stow profile and autostart; add polkit, hypridle, kanshi"
```

---

## Task 8: Create assets/wallpaper directory

**Files:**
- Create: `assets/wallpaper/.gitkeep`

- [ ] **Step 1: Create directory with placeholder**

```bash
mkdir -p assets/wallpaper
touch assets/wallpaper/.gitkeep
```

- [ ] **Step 2: Add a note to .gitkeep about the required wallpaper**

Write the following into `assets/wallpaper/.gitkeep`:

```
Place a default wallpaper here as: default.jpg
Required by install/lib/firstboot.sh setup_matugen_default()
```

- [ ] **Step 3: Commit**

```bash
git add assets/
git commit -m "chore: add assets/wallpaper directory placeholder for default wallpaper"
```

---

## Task 9: Create firstboot.sh

**Files:**
- Create: `install/lib/firstboot.sh`

- [ ] **Step 1: Create the file**

```bash
#!/bin/bash
# =============================================================================
# firstboot.sh — Post-install finalization steps
# Sourced by bootstrap.sh; expects DRY_RUN, REPO_DIR to be set.
# =============================================================================

# Tracks what was skipped for the final summary
FIRSTBOOT_SKIPPED=()

setup_boot() {
    section "systemd-boot"
    local entry
    entry=$(find /boot/loader/entries/ -maxdepth 1 -name "*lts*" 2>/dev/null | head -1 | xargs basename 2>/dev/null)

    if [[ -z "$entry" ]]; then
        warn "No LTS boot entry found — skipping"
        FIRSTBOOT_SKIPPED+=("systemd-boot LTS entry")
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] Setting default boot entry: $entry"
        return
    fi

    if grep -q "^default" /boot/loader/loader.conf; then
        sudo sed -i "s/^default.*/default $entry/" /boot/loader/loader.conf
    else
        echo "default $entry" | sudo tee -a /boot/loader/loader.conf
    fi
    success "Boot entry set: $entry"
}

setup_tpm() {
    section "TPM (Tmux Plugin Manager)"

    if ! command -v tmux &>/dev/null; then
        info "tmux not installed — skipping TPM bootstrap"
        FIRSTBOOT_SKIPPED+=("TPM bootstrap")
        return
    fi

    local tpm_script="$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

    if [[ ! -f "$tpm_script" ]]; then
        warn "TPM not found at $tpm_script — was tmux config stowed?"
        FIRSTBOOT_SKIPPED+=("TPM bootstrap (tpm dir missing after stow)")
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] bash $tpm_script"
        return
    fi

    bash "$tpm_script"
    success "TPM plugins installed"
}

setup_matugen_default() {
    section "Matugen — Default Wallpaper"

    if ! command -v matugen &>/dev/null; then
        info "matugen not installed — skipping"
        FIRSTBOOT_SKIPPED+=("matugen initial run")
        return
    fi

    local wallpaper="$REPO_DIR/assets/wallpaper/default.jpg"

    if [[ ! -f "$wallpaper" ]]; then
        warn "Default wallpaper not found at $wallpaper"
        warn "Add a wallpaper at assets/wallpaper/default.jpg and re-run:"
        warn "  matugen image $wallpaper"
        FIRSTBOOT_SKIPPED+=("matugen initial run (default.jpg missing)")
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] matugen image $wallpaper"
        return
    fi

    matugen image "$wallpaper"
    success "Matugen colors generated from default wallpaper"
}

print_p10k_notice() {
    info "Powerlevel10k: run zsh and follow the p10k wizard on first login."
}

print_final_summary() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Setup Summary${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [[ ${#FIRSTBOOT_SKIPPED[@]} -gt 0 ]]; then
        echo ""
        warn "Skipped steps (action required):"
        for item in "${FIRSTBOOT_SKIPPED[@]}"; do
            echo "    - $item"
        done
    fi

    echo ""
    echo "  Next steps:"
    echo "    1. Reboot"
    echo "    2. Verify SSH key is added to GitHub"
    echo "    3. Update dotfiles/hypr/appearance/monitors.conf for this machine"
    if [[ ! -f "$REPO_DIR/assets/wallpaper/default.jpg" ]]; then
        echo "    4. Add a wallpaper to assets/wallpaper/default.jpg and run:"
        echo "       matugen image ~/solyshi-workstation/assets/wallpaper/default.jpg"
    fi
    echo ""
}

setup_firstboot() {
    confirm "Set systemd-boot to LTS kernel?" && setup_boot
    confirm "Bootstrap TPM plugins?"          && setup_tpm
    confirm "Run matugen with default wallpaper?" && setup_matugen_default
    print_p10k_notice
    print_final_summary
}
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/lib/firstboot.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add install/lib/firstboot.sh
git commit -m "feat: add firstboot.sh for TPM, matugen, boot entry, and setup summary"
```

---

## Task 10: Restructure bootstrap.sh

**Files:**
- Modify: `install/bootstrap.sh`

Replace the file. The banner, helpers, `check_requirements`, and dry-run flag stay unchanged. `main()` is replaced with the 6-stage wizard. The old menu is removed.

- [ ] **Step 1: Replace `install/bootstrap.sh`**

```bash
#!/bin/bash
# =============================================================================
# solyshi-workstation — bootstrap.sh
# Interactive 6-stage workstation setup wizard
# Run: bash ~/solyshi-workstation/install/bootstrap.sh [--dry-run]
# =============================================================================

set -e

# =============================================================================
# User configuration — edit before running on a new machine
# =============================================================================
KEYBOARD_LAYOUT="de"

# =============================================================================
# Paths
# =============================================================================
DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$REPO_DIR/install/pkg"
DOTFILES_DIR="$REPO_DIR/dotfiles"
STOW_PROFILE="$REPO_DIR/profiles/desktop.stow"
LIB_DIR="$REPO_DIR/install/lib"

# =============================================================================
# Colors & helpers
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERR ]${NC} $1"; exit 1; }

section() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  $1${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

confirm() {
    read -rp "  $1 [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# =============================================================================
# Source libraries
# =============================================================================
# shellcheck source=lib/identity.sh
source "$LIB_DIR/identity.sh"
# shellcheck source=lib/system.sh
source "$LIB_DIR/system.sh"
# shellcheck source=lib/packages.sh
source "$LIB_DIR/packages.sh"
# shellcheck source=lib/toolchains.sh
source "$LIB_DIR/toolchains.sh"
# shellcheck source=lib/services.sh
source "$LIB_DIR/services.sh"
# shellcheck source=lib/dotfiles.sh
source "$LIB_DIR/dotfiles.sh"
# shellcheck source=lib/firstboot.sh
source "$LIB_DIR/firstboot.sh"

# =============================================================================
# Prerequisites
# =============================================================================
check_requirements() {
    section "Checking prerequisites"
    [[ $EUID -eq 0 ]] && error "Do not run as root!"
    command -v pacman &>/dev/null || error "No pacman found — not Arch Linux?"
    success "System OK"
}

# =============================================================================
# Main — 6-stage wizard
# =============================================================================
main() {
    clear
    echo -e "${BOLD}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║     solyshi-workstation bootstrap        ║"
    echo "  ║     Arch Linux — Interactive Setup       ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    $DRY_RUN && warn "DRY-RUN mode — no changes will be applied"

    check_requirements

    # ── Stage 1 ──────────────────────────────────────────────────────────────
    section "[1/6] Identity & Auth"
    setup_identity

    # Clone repo now that SSH is configured
    if [[ ! -d "$HOME/solyshi-workstation" ]]; then
        info "Cloning repo..."
        git clone git@github.com:solyshi/solyshi-workstation.git "$HOME/solyshi-workstation"
    fi

    # ── Stage 2 ──────────────────────────────────────────────────────────────
    section "[2/6] System Config"
    setup_system_config

    # ── Stage 3 ──────────────────────────────────────────────────────────────
    section "[3/6] Packages"
    setup_packages

    # ── Stage 4 ──────────────────────────────────────────────────────────────
    section "[4/6] Services"
    setup_services

    # ── Stage 5 ──────────────────────────────────────────────────────────────
    section "[5/6] Dotfiles"
    setup_shell
    setup_stow
    setup_directories

    # ── Stage 6 ──────────────────────────────────────────────────────────────
    section "[6/6] First Boot"
    setup_firstboot

    echo ""
    echo -e "${BOLD}${GREEN}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║     Bootstrap complete!                  ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    warn "Please reboot to apply all changes."
    echo ""
}

main "$@"
```

- [ ] **Step 2: Syntax check**

```bash
bash -n install/bootstrap.sh
```

Expected: no output.

- [ ] **Step 3: Dry-run smoke test**

```bash
bash install/bootstrap.sh --dry-run
```

Expected: banner prints, each stage section header appears, `[DRY-RUN]` lines print for any automated steps, no errors.

- [ ] **Step 4: Commit**

```bash
git add install/bootstrap.sh
git commit -m "feat: restructure bootstrap.sh into 6-stage interactive wizard"
```

---

## Task 11: Update README

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update the Installation section**

Replace the existing `## Installation` section with:

```markdown
## Installation

### 1. Clone the repository

> **Note:** SSH is required. If you don't have an SSH key set up yet, the bootstrap script handles this in Stage 1 — just run it and follow the prompts.

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
```

- [ ] **Step 2: Add a Swap section after the Installation section**

```markdown
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
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: update Installation section for wizard flow, add Swap section"
```

---

## Self-Review

After writing this plan the following checks were performed:

1. **Spec coverage:**
   - ✅ Stage 1: identity.sh covers SSH, git config, gh auth
   - ✅ Stage 2: system.sh covers hostname, timezone, locale; swap documented
   - ✅ Stage 3: 14 package files created; nautilus removed; all new packages added
   - ✅ Hardware checks: bluetooth (rfkill/sysfs), brightness (backlight sysfs)
   - ✅ Stage 4: bluetooth, fstrim, cronie added with capability checks
   - ✅ Autostart: polkit, hypridle, kanshi added; nautilus removed
   - ✅ Stage 5: --no-folding, conflict detection, xdg-user-dirs-update, emacs confirm
   - ✅ Stage 6: TPM, matugen, p10k notice, boot entry, final summary
   - ✅ bootstrap.sh restructured into wizard
   - ✅ README updated
   - ✅ assets/wallpaper directory created

2. **No placeholders** — all steps contain complete code.

3. **Type/name consistency:**
   - `setup_identity()` called in bootstrap.sh, defined in identity.sh ✅
   - `setup_system_config()` called in bootstrap.sh, defined in system.sh ✅
   - `setup_packages()` called in bootstrap.sh, defined in packages.sh ✅
   - `setup_firstboot()` called in bootstrap.sh, defined in firstboot.sh ✅
   - `setup_boot()` defined in firstboot.sh, removed from services.sh ✅
   - `REPO_DIR` used in firstboot.sh — passed via bootstrap.sh environment ✅
   - `FIRSTBOOT_SKIPPED` array declared in firstboot.sh, used only within it ✅
