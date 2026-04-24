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
