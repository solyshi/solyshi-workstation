#!/bin/bash
# =============================================================================
# solyshi-workstation — bootstrap.sh
# Interactive 6-stage workstation setup wizard
# Run: bash ~/solyshi-workstation/install/bootstrap.sh [--dry-run]
# =============================================================================

set -uo pipefail

# =============================================================================
# User configuration — edit before running on a new machine
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
