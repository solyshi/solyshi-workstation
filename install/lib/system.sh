#!/bin/bash
# =============================================================================
# system.sh — System configuration (hostname, timezone, locale)
# Sourced by bootstrap.sh; expects DRY_RUN to be set.
# =============================================================================

setup_hostname() {
    section "Hostname"
    local current
    current=$(hostnamectl hostname 2>/dev/null || hostname)
    info "Current hostname: $current"

    local new_hostname
    read -rp "  New hostname (leave blank to keep '$current'): " new_hostname
    [[ -z "$new_hostname" ]] && return

    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo hostnamectl set-hostname \"$new_hostname\""
        return
    fi

    sudo hostnamectl set-hostname "$new_hostname"
    success "Hostname set to '$new_hostname'"
}

setup_timezone() {
    section "Timezone"
    local current
    current=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "unknown")
    info "Current timezone: $current"

    local tz
    if command -v fzf &>/dev/null; then
        tz=$(timedatectl list-timezones | fzf --prompt="  Select timezone: " --height=15)
    else
        read -rp "  Timezone (e.g. Europe/Berlin): " tz
    fi
    [[ -z "$tz" ]] && return

    if $DRY_RUN; then
        echo "  [DRY-RUN] sudo timedatectl set-timezone \"$tz\""
        return
    fi

    sudo timedatectl set-timezone "$tz"
    success "Timezone set to '$tz'"
}

setup_locale() {
    section "Locale"
    local default="en_US.UTF-8"
    local locale
    read -rp "  Locale [default: $default]: " locale
    locale="${locale:-$default}"

    if $DRY_RUN; then
        echo "  [DRY-RUN] Uncomment '$locale UTF-8' in /etc/locale.gen"
        echo "  [DRY-RUN] sudo locale-gen"
        echo "  [DRY-RUN] echo \"LANG=$locale\" | sudo tee /etc/locale.conf"
        return
    fi

    local entry="${locale} UTF-8"
    if ! grep -q "^${entry}" /etc/locale.gen 2>/dev/null; then
        if grep -q "^#.*${entry}" /etc/locale.gen 2>/dev/null; then
            sudo sed -i "s|^#.*${entry}|${entry}|" /etc/locale.gen
        else
            echo "$entry" | sudo tee -a /etc/locale.gen
        fi
    fi

    sudo locale-gen
    echo "LANG=$locale" | sudo tee /etc/locale.conf
    success "Locale set to '$locale'"
}

print_swap_notice() {
    echo ""
    warn "Swap not configured — set up manually after reboot. See README §Swap."
    echo ""
}

setup_system_config() {
    confirm "Set hostname?"  && setup_hostname
    confirm "Set timezone?"  && setup_timezone
    confirm "Set locale?"    && setup_locale
    print_swap_notice
}
