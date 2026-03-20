#!/bin/bash
# =============================================================================
# solyshi-workstation — bootstrap.sh
# Interaktive Neuinstallation der Workstation
# Ausführen: bash ~/solyshi-workstation/install/bootstrap.sh
# =============================================================================


set -e

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$REPO_DIR/packages"
DOTFILES_DIR="$REPO_DIR/dotfiles"
STOW_PROFILE="$REPO_DIR/profiles/desktop.stow"

# =============================================================================
# Farben & Hilfsfunktionen
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
# Pakete aus Datei lesen und via yay installieren
# Kommentare (#) und Leerzeilen werden ignoriert
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

    info "Installiere ${#pkgs[@]} Pakete aus $(basename "$file")..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] yay -S --needed --noconfirm ${pkgs[*]}"
    else
        yay -S --needed --noconfirm "${pkgs[@]}"
    fi
}

# =============================================================================
# Vorbedingungen
# =============================================================================
check_requirements() {
    section "Vorbedingungen prüfen"
    [[ $EUID -eq 0 ]] && error "Nicht als root ausführen!"
    command -v pacman &>/dev/null || error "Kein pacman gefunden — kein Arch Linux?"
    success "System OK"
}

# =============================================================================
# yay installieren (falls noch nicht vorhanden)
# =============================================================================
install_yay() {
    section "yay (AUR Helper)"
    if command -v yay &>/dev/null; then
        success "yay bereits installiert ($(yay --version | head -1))"
        return
    fi
    info "Installiere yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    local tmpdir
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    yay -Y --gendb --noconfirm
    yay -Y --devel --save --noconfirm
    success "yay installiert"
}

# =============================================================================
# Pakete installieren
# =============================================================================
install_base() {
    section "01 — Base System"
    install_from_file "$PACKAGES_DIR/01-base.txt"
    success "Base System installiert"
}

install_desktop() {
    section "02 — Desktop Environment"
    install_from_file "$PACKAGES_DIR/02-desktop.txt"
    success "Desktop installiert"
}

install_dev() {
    section "03 — Dev Environment"
    # sdkman-bin aus der Liste heraushalten — wird separat behandelt
    local tmpfile
    tmpfile=$(mktemp)
    grep -v "sdkman-bin" "$PACKAGES_DIR/03-dev.txt" > "$tmpfile"
    install_from_file "$tmpfile"
    rm "$tmpfile"

    if confirm "SDKMAN einrichten? (Java, Gradle, Maven)"; then
        setup_sdkman
    fi
    success "Dev Environment installiert"
}

install_apps() {
    section "04 — Anwendungen"
    install_from_file "$PACKAGES_DIR/04-apps.txt"
    success "Anwendungen installiert"
}

# =============================================================================
# SDKMAN Setup
# =============================================================================
setup_sdkman() {
    section "SDKMAN"
    local sdkman_dir="${XDG_DATA_HOME:-$HOME/.local/share}/sdkman"

    if [[ -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
        success "SDKMAN bereits installiert"
    else
        info "Installiere SDKMAN nach $sdkman_dir..."
        export SDKMAN_DIR="$sdkman_dir"
        curl -s "https://get.sdkman.io" | bash

        # Pfad-Fix: SDKMAN legt manchmal .sdkman/ Unterverzeichnis an
        if [[ -d "$sdkman_dir/.sdkman" && ! -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
            warn "SDKMAN Pfad-Fix anwenden..."
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
        info "Installiere Java 21 (Temurin)..."
        sdk install java 21.0.9-tem || warn "Java 21 bereits installiert"

        if confirm "Java 25 ebenfalls installieren?"; then
            sdk install java 25.0.0-tem || warn "Java 25 bereits installiert"
        fi

        info "Installiere Gradle..."
        sdk install gradle || warn "Gradle bereits installiert"

        if confirm "Maven installieren?"; then
            sdk install maven || warn "Maven bereits installiert"
        fi
    fi

    success "SDKMAN eingerichtet"
}

# =============================================================================
# Dotfiles via stow verlinken
# =============================================================================
setup_stow() {
    section "Dotfiles (stow)"
    command -v stow &>/dev/null || yay -S --needed --noconfirm stow

    info "Verlinke Dotfiles..."
    # shellcheck disable=SC2046
    stow -d "$DOTFILES_DIR" -t "$HOME" $(tr '\n' ' ' < "$STOW_PROFILE")

    success "Dotfiles verlinkt"
}

# =============================================================================
# Services aktivieren
# =============================================================================
setup_services() {
    section "Services"
    info "NetworkManager aktivieren..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo systemctl enable --now NetworkManager"
    else
        sudo systemctl enable --now NetworkManager
    fi
    success "NetworkManager aktiv"

    if confirm "PostgreSQL einrichten?"; then
        if $DRY_RUN; then
            echo "  [DRY-RUN] sudo systemctl enable --now postgresql"
        else
            if [[ ! -d /var/lib/postgres/data ]]; then
                info "PostgreSQL initialisieren..."
                sudo -iu postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data
            fi
            sudo systemctl enable --now postgresql
            success "PostgreSQL aktiv"
        fi
    fi

    info "Mako (User-Service) aktivieren..."
    if $DRY_RUN; then
        echo "  [DRY-RUN] systemctl --user enable mako"
    else
        systemctl --user enable mako 2>/dev/null || warn "Mako konnte nicht aktiviert werden"
    fi
    success "Services eingerichtet"
}

# =============================================================================
# systemd-boot auf LTS setzen
# =============================================================================
setup_boot() {
    section "systemd-boot"
    local entry
    entry=$(find /boot/loader/entries/ -maxdepth 1 -name "*lts*" 2>/dev/null | head -1 | xargs basename 2>/dev/null)

    if [[ -z "$entry" ]]; then
        warn "Kein LTS Boot-Eintrag gefunden — überspringe"
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] Boot-Eintrag setzen: $entry"
        return
    fi

    if grep -q "^default" /boot/loader/loader.conf; then
        sudo sed -i "s/^default.*/default $entry/" /boot/loader/loader.conf
    else
        echo "default $entry" | sudo tee -a /boot/loader/loader.conf
    fi
    success "Boot-Eintrag gesetzt: $entry"
}

# =============================================================================
# Verzeichnisse anlegen
# =============================================================================
setup_directories() {
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/projects"
    success "Verzeichnisse angelegt"
}

# =============================================================================
# Shell auf Zsh setzen
# =============================================================================
setup_shell() {
    section "Shell"
    if [[ "$SHELL" == *"zsh"* ]]; then
        success "Zsh bereits aktiv"
        return
    fi
    info "Setze Zsh als Standard-Shell..."
    chsh -s /bin/zsh
    success "Zsh gesetzt — gilt ab nächstem Login"
}

# =============================================================================
# Hauptmenü
# =============================================================================
main() {
    clear
    echo -e "${BOLD}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║     solyshi-workstation bootstrap        ║"
    echo "  ║     Arch Linux — Interaktive Installation║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"

    check_requirements

    # Repo clonen falls noch nicht vorhanden
    if [[ ! -d "$HOME/solyshi-workstation" ]]; then
        info "Repo clonen..."
        git clone git@github.com:Chri1899/solyshi-workstation.git "$HOME/solyshi-workstation"
    fi

    install_yay

    echo ""
    echo -e "  ${BOLD}Was soll installiert werden?${NC}"
    echo ""
    echo "  [1] Nur Dotfiles verlinken"
    echo "  [2] Base System + Dotfiles"
    echo "  [3] Base + Desktop + Dotfiles"
    echo "  [4] Base + Desktop + Dev + Dotfiles"
    echo "  [5] Alles (inkl. Apps, Services, Boot)"
    echo "  [6] Individuell auswählen"
    echo "  [q] Abbrechen"
    echo ""
    read -rp "  Auswahl: " choice

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
            confirm "Base System installieren?"   && install_base
            confirm "Desktop installieren?"        && install_desktop
            confirm "Dev Environment installieren?" && install_dev
            confirm "Anwendungen installieren?"    && install_apps
            setup_shell
            confirm "Dotfiles verlinken?"          && setup_stow
            confirm "Services einrichten?"         && setup_services
            confirm "systemd-boot auf LTS setzen?" && setup_boot
            setup_directories
            ;;
        q|Q)
            echo "  Abgebrochen."
            exit 0
            ;;
        *)
            error "Ungültige Auswahl"
            ;;
    esac

    echo ""
    echo -e "${BOLD}${GREEN}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║     Bootstrap abgeschlossen!             ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    warn "Bitte neu starten um alle Änderungen zu übernehmen."
    echo ""
}

main "$@"
