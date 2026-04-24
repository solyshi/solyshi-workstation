#!/bin/bash
# =============================================================================
# firstboot.sh — Post-install finalization steps
# Sourced by bootstrap.sh; expects DRY_RUN, REPO_DIR to be set.
# =============================================================================

FIRSTBOOT_SKIPPED=()

setup_boot() {
    section "systemd-boot"

    if [[ ! -d /boot/loader/entries ]]; then
        info "systemd-boot not detected (GRUB or other bootloader in use) — skipping"
        return
    fi

    local entry
    entry=$(find /boot/loader/entries/ -maxdepth 1 -name "*lts*" 2>/dev/null | head -1 | xargs basename 2>/dev/null)

    if [[ -z "$entry" ]]; then
        warn "No LTS boot entry found in /boot/loader/entries/ — skipping"
        warn "If linux-lts was just installed, reboot once and re-run this step manually:"
        warn "  sudo bootctl set-default <entry>.conf"
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

    local tpm_dir="$HOME/.tmux/plugins/tpm"
    local tpm_script="$tpm_dir/scripts/install_plugins.sh"

    if [[ ! -d "$tpm_dir" ]]; then
        info "Cloning TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    if [[ ! -f "$tpm_script" ]]; then
        warn "TPM install script not found at $tpm_script"
        FIRSTBOOT_SKIPPED+=("TPM bootstrap (script missing)")
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
