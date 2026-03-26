#!/bin/bash
# =============================================================================
# solyshi-workstation — bootstrap.sh
# Interactive workstation reinstallation
# Run: bash ~/solyshi-workstation/install/bootstrap.sh
# =============================================================================


set -e

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$REPO_DIR/packages"
DOTFILES_DIR="$REPO_DIR/dotfiles"
STOW_PROFILE="$REPO_DIR/profiles/desktop.stow"

# =============================================================================
# Colors & helper functions
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
# Read packages from file and install via yay
# Comments (#) and empty lines are ignored
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
# Install yay (if not already present)
# =============================================================================
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

# =============================================================================
# Install packages
# =============================================================================
install_base() {
    section "01 — Base System"
    install_from_file "$PACKAGES_DIR/01-base.txt"
    success "Base system installed"
}

install_desktop() {
    section "02 — Desktop Environment"
    install_from_file "$PACKAGES_DIR/02-desktop.txt"
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

# =============================================================================
# Spicetify
# =============================================================================
setup_spicetify() {
    section "SPICETIFY"

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/App -R

    info "Installing Spicetify Marketplace..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
    success "Spicetify successfully installed"
}

# =============================================================================
# SDKMAN setup
# =============================================================================
setup_sdkman() {
    section "SDKMAN"
    local sdkman_dir="${XDG_DATA_HOME:-$HOME/.local/share}/sdkman"

    if [[ -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
        success "SDKMAN already installed"
    else
        info "Installing SDKMAN to $sdkman_dir..."
        export SDKMAN_DIR="$sdkman_dir"
        curl -s "https://get.sdkman.io" | bash

        # Path fix: SDKMAN sometimes creates a .sdkman/ subdirectory
        if [[ -d "$sdkman_dir/.sdkman" && ! -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
            warn "Applying SDKMAN path fix..."
            mv "$sdkman_dir/.sdkman/"* "$sdkman_dir/" 2>/dev/null || true
            mv "$sdkman_dir/.sdkman/".* "$sdkman_dir/" 2>/dev/null || true
            rm -rf "$sdkman_dir/.sdkman"
        fi
    fi

    # shellcheck disable=SC1090,SC1091
    source "$sdkman_dir/bin/sdkman-init.sh"

    if $DRY_RUN; then
        echo "  [DRY-RUN] sdk install java 21.0.9-tem"
        echo "  [DRY-RUN] sdk install gradle"
    else
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
    fi

    success "SDKMAN set up"
}

# =============================================================================
# Link dotfiles via stow
# =============================================================================
setup_stow() {
    section "Dotfiles (stow)"
    command -v stow &>/dev/null || yay -S --needed --noconfirm stow

    info "Linking dotfiles..."
    # shellcheck disable=SC2046
    stow -d "$DOTFILES_DIR" -t "$HOME" $(tr '\n' ' ' < "$STOW_PROFILE")

    success "Dotfiles linked"
}

# =============================================================================
# Enable services
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

    if confirm "Set up PostgreSQL?"; then
        if $DRY_RUN; then
            echo "  [DRY-RUN] sudo systemctl enable --now postgresql"
        else
            if [[ ! -d /var/lib/postgres/data ]]; then
                info "Initializing PostgreSQL..."
                sudo -iu postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data
            fi
            sudo systemctl enable --now postgresql
            success "PostgreSQL active"
        fi
    fi

    info "Enabling Mako (user service)..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] systemctl --user enable mako"
    else
        systemctl --user enable mako 2>/dev/null || warn "Could not enable Mako"
    fi
    success "Services configured"
}

# =============================================================================
# Set systemd-boot to LTS
# =============================================================================
setup_boot() {
    section "systemd-boot"
    local entry
    entry=$(find /boot/loader/entries/ -maxdepth 1 -name "*lts*" 2>/dev/null | head -1 | xargs basename 2>/dev/null)

    if [[ -z "$entry" ]]; then
        warn "No LTS boot entry found — skipping"
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] Setting boot entry: $entry"
        return
    fi

    if grep -q "^default" /boot/loader/loader.conf; then
        sudo sed -i "s/^default.*/default $entry/" /boot/loader/loader.conf
    else
        echo "default $entry" | sudo tee -a /boot/loader/loader.conf
    fi
    success "Boot entry set: $entry"
}

# =============================================================================
# Create directories
# =============================================================================
setup_directories() {
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/projects"
    success "Directories created"
}

# =============================================================================
# Set shell to Zsh
# =============================================================================
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

# =============================================================================
# Main menu
# =============================================================================
main() {
    clear
    echo -e "${BOLD}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║     solyshi-workstation bootstrap        ║"
    echo "  ║     Arch Linux — Interactive Setup       ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"

    check_requirements

    # Clone repo if not already present
    if [[ ! -d "$HOME/solyshi-workstation" ]]; then
        info "Cloning repo..."
        git clone git@github.com:Chri1899/solyshi-workstation.git "$HOME/solyshi-workstation"
    fi

    install_yay

    echo ""
    echo -e "  ${BOLD}What should be installed?${NC}"
    echo ""
    echo "  [1] Link dotfiles only"
    echo "  [2] Base system + dotfiles"
    echo "  [3] Base + desktop + dotfiles"
    echo "  [4] Base + desktop + dev + dotfiles"
    echo "  [5] Everything (incl. apps, services, boot)"
    echo "  [6] Select individually"
    echo "  [q] Cancel"
    echo ""
    read -rp "  Choice: " choice

    case "$choice" in
        1)
            setup_stow
            setup_directories
            ;;
        2)
            install_base
            setup_shell
            setup_stow
            setup_services
            setup_directories
            ;;
        3)
            install_base
            install_desktop
            setup_shell
            setup_stow
            setup_services
            setup_boot
            setup_directories
            ;;
        4)
            install_base
            install_desktop
            install_dev
            setup_shell
            setup_stow
            setup_services
            setup_boot
            setup_directories
            ;;
        5)
            install_base
            install_desktop
            install_dev
            install_apps
            setup_shell
            setup_stow
            setup_services
            setup_boot
            setup_directories
            ;;
        6)
            confirm "Install base system?"        && install_base
            confirm "Install desktop?"            && install_desktop
            confirm "Install dev environment?"    && install_dev
            confirm "Install applications?"       && install_apps
            setup_shell
            confirm "Link dotfiles?"              && setup_stow
            confirm "Configure services?"         && setup_services
            confirm "Set systemd-boot to LTS?"    && setup_boot
            setup_directories
            ;;
        q|Q)
            echo "  Cancelled."
            exit 0
            ;;
        *)
            error "Invalid choice"
            ;;
    esac

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
