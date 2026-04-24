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

install_apps_system() {
    section "04 — System Tools"
    install_from_file "$PACKAGES_DIR/04-apps-system.txt"
    success "System tools installed"
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
    confirm "Install productivity apps (LibreOffice, Spotify)?"            && install_apps_productivity
    confirm "Install gaming apps (Steam, PrismLauncher)?"                 && install_apps_gaming
    confirm "Install Timeshift (auto-snapshot pacman hook for rolling-release safety)?" && install_apps_system
}
