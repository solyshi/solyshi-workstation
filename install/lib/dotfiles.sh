#!/bin/bash
# =============================================================================
# dotfiles.sh — Dotfile linking and shell/directory setup
# Sourced by bootstrap.sh; expects DRY_RUN, DOTFILES_DIR, STOW_PROFILE,
# REPO_DIR, and KEYBOARD_LAYOUT to be set.
# =============================================================================

setup_stow() {
    section "Dotfiles (stow)"
    command -v stow &>/dev/null || yay -S --needed --noconfirm stow

    # 'scripts' lives at repo root, not in dotfiles/ — handled by the second stow call below
    local packages
    packages=$(grep -v '^scripts$' "$STOW_PROFILE" | tr '\n' ' ')

    if $DRY_RUN; then
        echo "  [DRY-RUN] stow --no-folding -d $DOTFILES_DIR -t $HOME $packages"
        return
    fi

    # Back up conflicting files so stow can create symlinks cleanly
    while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        find "$DOTFILES_DIR/$pkg" -type f 2>/dev/null | while IFS= read -r src; do
            local rel="${src#"$DOTFILES_DIR/$pkg/"}"
            local dst="$HOME/$rel"
            if [[ -e "$dst" && ! -L "$dst" ]]; then
                warn "Backing up $dst → ${dst}.bak"
                mv "$dst" "${dst}.bak"
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

setup_omz() {
    section "Oh My Zsh"
    local omz_dir="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"

    if [[ -d "$omz_dir" ]]; then
        success "Oh My Zsh already installed at $omz_dir"
    else
        info "Cloning Oh My Zsh..."
        if $DRY_RUN; then
            echo "  [DRY-RUN] git clone oh-my-zsh → $omz_dir"
        else
            git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
        fi
    fi

    local custom="$omz_dir/custom"

    # Powerlevel10k theme
    if [[ ! -d "$custom/themes/powerlevel10k" ]]; then
        info "Cloning Powerlevel10k theme..."
        if $DRY_RUN; then
            echo "  [DRY-RUN] git clone powerlevel10k → $custom/themes/powerlevel10k"
        else
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$custom/themes/powerlevel10k"
        fi
    fi

    # zsh-autosuggestions plugin
    if [[ ! -d "$custom/plugins/zsh-autosuggestions" ]]; then
        info "Cloning zsh-autosuggestions..."
        $DRY_RUN || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$custom/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting plugin
    if [[ ! -d "$custom/plugins/zsh-syntax-highlighting" ]]; then
        info "Cloning zsh-syntax-highlighting..."
        $DRY_RUN || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom/plugins/zsh-syntax-highlighting"
    fi

    success "Oh My Zsh ready"
}

setup_shell() {
    section "Shell"
    setup_omz
    if [[ "$SHELL" == *"zsh"* ]]; then
        success "Zsh already active"
        return
    fi
    info "Setting Zsh as default shell..."
    chsh -s /bin/zsh
    success "Zsh set — takes effect on next login"
}
