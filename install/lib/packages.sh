#!/bin/bash
# =============================================================================
# packages.sh — Package installation functions
# Sourced by bootstrap.sh; expects DRY_RUN, PACKAGES_DIR to be set.
# =============================================================================

# Read packages from file and install via yay.
# Comments (#) and empty lines are ignored.
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

install_desktop() {
    section "02 — Desktop Environment"
    install_from_file "$PACKAGES_DIR/02-desktop.txt"
    setup_sddm
    success "Desktop installed"
}

install_dev() {
    section "03 — Dev Environment"
    # Exclude sdkman-bin from the list — handled separately
    local tmpfile
    tmpfile=$(mktemp)
    grep -v "sdkman-bin" "$PACKAGES_DIR/03-dev.txt" > "$tmpfile"
    install_from_file "$tmpfile"
    rm "$tmpfile"

    if confirm "Set up Rust toolchain (stable + src)?"; then
        setup_rust
    fi

    if confirm "Set up SDKMAN? (Java, Gradle, Maven)"; then
        setup_sdkman
    fi
    success "Dev environment installed"
}

install_apps() {
    section "04 — Applications"
    install_from_file "$PACKAGES_DIR/04-apps.txt"
    setup_spicetify
    success "Applications installed"
}
