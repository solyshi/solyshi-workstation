#!/bin/bash
# =============================================================================
# services.sh — System service and display manager setup functions
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
