#!/bin/bash
# =============================================================================
# identity.sh — SSH key generation, git identity, GitHub CLI auth
# Sourced by bootstrap.sh; expects DRY_RUN to be set.
# =============================================================================

setup_ssh() {
    section "SSH Key"

    if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
        success "SSH key already exists at ~/.ssh/id_ed25519"
        return
    fi

    local email
    read -rp "  Email for SSH key: " email
    [[ -z "$email" ]] && error "Email required for SSH key generation"

    if $DRY_RUN; then
        echo "  [DRY-RUN] ssh-keygen -t ed25519 -C \"$email\" -f ~/.ssh/id_ed25519"
        return
    fi

    command -v ssh-keygen &>/dev/null || sudo pacman -S --needed --noconfirm openssh

    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
    success "SSH key generated — GitHub CLI will upload it in the next step"
}

setup_git_identity() {
    section "Git Identity"

    local current_name current_email
    current_name=$(git config --global user.name 2>/dev/null)
    current_email=$(git config --global user.email 2>/dev/null)

    if [[ -n "$current_name" && -n "$current_email" ]]; then
        success "Git identity already set: $current_name <$current_email>"
        return
    fi

    local name email
    read -rp "  Full name: " name
    read -rp "  Email: " email
    [[ -z "$name" ]]  && error "Name is required"
    [[ -z "$email" ]] && error "Email is required"

    if $DRY_RUN; then
        echo "  [DRY-RUN] git config --global user.name \"$name\""
        echo "  [DRY-RUN] git config --global user.email \"$email\""
        return
    fi

    git config --global user.name "$name"
    git config --global user.email "$email"
    success "Git identity set: $name <$email>"
}

setup_gh_auth() {
    section "GitHub CLI"

    if gh auth status &>/dev/null; then
        success "GitHub CLI already authenticated"
        return
    fi

    if $DRY_RUN; then
        echo "  [DRY-RUN] gh auth login --git-protocol ssh"
        return
    fi

    command -v gh &>/dev/null || sudo pacman -S --needed --noconfirm github-cli

    info "Device code flow — when prompted, choose to upload your SSH key to GitHub."
    gh auth login --git-protocol ssh

    if gh auth status &>/dev/null; then
        success "GitHub CLI authenticated"
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            success "SSH connection to GitHub verified"
        else
            warn "SSH not yet verified — key upload may need a moment to propagate"
        fi
    else
        warn "GitHub CLI authentication could not be verified — continuing"
    fi
}

setup_identity() {
    confirm "Generate SSH key and connect to GitHub?" && setup_ssh
    confirm "Configure git user name and email?"      && setup_git_identity
    confirm "Authenticate GitHub CLI (device code)?"  && setup_gh_auth
}
