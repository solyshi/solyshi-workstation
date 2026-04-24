#!/bin/bash
# =============================================================================
# toolchains.sh — Language toolchain setup functions
# Sourced by bootstrap.sh; expects DRY_RUN to be set.
# =============================================================================

setup_spicetify() {
    section "SPICETIFY"

    local prefs_file="$HOME/.config/spotify/prefs"
    if [[ ! -f "$prefs_file" ]]; then
        warn "Spotify prefs not found — launch Spotify once first, then run manually:"
        warn "  spicetify backup apply"
        warn "  curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh"
        return
    fi

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/App -R

    info "Installing Spicetify Marketplace..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh"
    else
        if ! curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh; then
            warn "Spicetify Marketplace install failed — check network and retry manually"
            return
        fi
        success "Spicetify successfully installed"
    fi
}

setup_rust() {
    section "RUSTUP"

    if ! command -v rustup &>/dev/null; then
        warn "rustup not found. Make sure it's in 03-dev.txt or installed via yay."
        return 1
    fi

    info "Configuring Rust toolchain..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] rustup default stable"
        echo "  [DRY-RUN] rustup component add rust-src"
    else
        if ! rustup default stable; then
            error "Failed to set Rust stable toolchain"
        fi
        if ! rustup component add rust-src; then
            error "Failed to add rust-src component"
        fi
        success "Rust stable toolchain and sources installed"
    fi
}

setup_sdkman() {
    section "SDKMAN"
    local sdkman_dir="$HOME/.sdkman"

    if [[ ! -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
        info "Installing SDKMAN to $sdkman_dir..."
        export SDKMAN_DIR="$sdkman_dir"
        if ! curl -s "https://get.sdkman.io" | bash; then
            error "SDKMAN installation failed"
        fi
    else
        success "SDKMAN already installed at $sdkman_dir"
    fi

    # sdkman-init.sh references vars that may be unset — suspend nounset around it
    set +u
    # shellcheck disable=SC1090,SC1091
    source "$sdkman_dir/bin/sdkman-init.sh" || { set -u; error "Failed to source SDKMAN init script at $sdkman_dir/bin/sdkman-init.sh"; }
    set -u

    if $DRY_RUN; then
        echo "  [DRY-RUN] sdk install java 21.0.9-tem"
        echo "  [DRY-RUN] sdk install gradle"
        return
    fi

    info "Installing Java 21 (Temurin)..."
    sdk install java 21.0.9-tem || warn "Java 21 already installed"

    if confirm "Also install Java 25?"; then
        sdk install java 25.0.0-tem || warn "Java 25 already installed"
    fi

    info "Installing Gradle..."
    sdk install gradle || warn "Gradle already installed"

    if confirm "Install Maven?"; then
        sdk install maven || warn "Maven already installed"
    fi

    success "SDKMAN set up"
}
