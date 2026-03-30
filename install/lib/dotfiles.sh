#!/bin/bash
# =============================================================================
# dotfiles.sh — Dotfile linking and shell/directory setup functions
# Sourced by bootstrap.sh; expects DRY_RUN, DOTFILES_DIR, STOW_PROFILE,
# and KEYBOARD_LAYOUT to be set.
# =============================================================================

setup_stow() {
    section "Dotfiles (stow)"
    command -v stow &>/dev/null || yay -S --needed --noconfirm stow

    info "Linking dotfiles..."
    # shellcheck disable=SC2046
    if $DRY_RUN; then
        echo "  [DRY-RUN] stow -d $DOTFILES_DIR -t $HOME $(tr '\n' ' ' < "$STOW_PROFILE")"
    else
        stow -d "$DOTFILES_DIR" -t "$HOME" $(tr '\n' ' ' < "$STOW_PROFILE")
        success "Dotfiles linked"
        apply_keyboard_layout
    fi
}

# Patch the Hyprland input config to use the configured keyboard layout.
apply_keyboard_layout() {
    local input_conf="$HOME/.config/hypr/functionality/input.conf"

    if [[ ! -f "$input_conf" ]]; then
        warn "Hyprland input.conf not found at $input_conf — skipping keyboard layout patch"
        return
    fi

    if [[ -z "$KEYBOARD_LAYOUT" ]]; then
        warn "KEYBOARD_LAYOUT is not set — leaving input.conf unchanged"
        return
    fi

    sed -i "s/^\(\s*kb_layout\s*=\s*\).*/\1$KEYBOARD_LAYOUT/" "$input_conf"
    success "Keyboard layout set to '$KEYBOARD_LAYOUT' in input.conf"
}

setup_directories() {
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/projects"
    success "Directories created"
}

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
