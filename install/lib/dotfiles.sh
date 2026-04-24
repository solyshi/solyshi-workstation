#!/bin/bash
# =============================================================================
# dotfiles.sh — Dotfile linking and shell/directory setup
# Sourced by bootstrap.sh; expects DRY_RUN, DOTFILES_DIR, STOW_PROFILE,
# REPO_DIR, and KEYBOARD_LAYOUT to be set.
# =============================================================================

setup_stow() {
    section "Dotfiles (stow)"
    command -v stow &>/dev/null || yay -S --needed --noconfirm stow

    local packages
    packages=$(tr '\n' ' ' < "$STOW_PROFILE")

    if $DRY_RUN; then
        echo "  [DRY-RUN] stow --no-folding -d $DOTFILES_DIR -t $HOME $packages"
        return
    fi

    # Detect conflicts (existing non-symlink files at stow target paths)
    while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        find "$DOTFILES_DIR/$pkg" -type f 2>/dev/null | while IFS= read -r src; do
            local rel="${src#"$DOTFILES_DIR/$pkg/"}"
            local dst="$HOME/$rel"
            if [[ -e "$dst" && ! -L "$dst" ]]; then
                warn "Conflict: $dst exists and is not a symlink — skipping"
            fi
        done
    done < "$STOW_PROFILE"

    info "Linking dotfiles..."
    # shellcheck disable=SC2086
    stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" $packages
    stow --no-folding -d "$REPO_DIR" -t "$HOME" scripts
    success "Dotfiles linked"

    if confirm "Also stow emacs config?"; then
        if [[ -d "$DOTFILES_DIR/emacs" ]]; then
            stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" emacs
            success "Emacs config linked"
        else
            warn "dotfiles/emacs not found — skipping"
        fi
    fi

    apply_keyboard_layout
}

apply_keyboard_layout() {
    local input_conf="$HOME/.config/hypr/functionality/input.conf"

    if [[ ! -f "$input_conf" ]]; then
        warn "Hyprland input.conf not found — skipping keyboard layout patch"
        return
    fi

    if [[ -z "$KEYBOARD_LAYOUT" ]]; then
        warn "KEYBOARD_LAYOUT not set — leaving input.conf unchanged"
        return
    fi

    sed -i "s/^\(\s*kb_layout\s*=\s*\).*/\1$KEYBOARD_LAYOUT/" "$input_conf"
    success "Keyboard layout set to '$KEYBOARD_LAYOUT'"
}

setup_directories() {
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/projects"
    xdg-user-dirs-update
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
