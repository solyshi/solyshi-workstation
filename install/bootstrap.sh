#!/bin/bash
# =============================================================================
# solyshi-workstation — bootstrap.sh
# Interactive workstation reinstallation
# Run: bash ~/solyshi-workstation/install/bootstrap.sh [--dry-run]
# =============================================================================

set -e

# =============================================================================
# User configuration — edit these before running on a new machine
# =============================================================================
# Keyboard layout passed to Hyprland's kb_layout option (e.g. us, de, fr, gb)
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
# Source function libraries
# =============================================================================
# shellcheck source=lib/packages.sh
source "$LIB_DIR/packages.sh"
# shellcheck source=lib/toolchains.sh
source "$LIB_DIR/toolchains.sh"
# shellcheck source=lib/services.sh
source "$LIB_DIR/services.sh"
# shellcheck source=lib/dotfiles.sh
source "$LIB_DIR/dotfiles.sh"

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
        git clone git@github.com:solyshi/solyshi-workstation.git "$HOME/solyshi-workstation"
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
