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

    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""

    echo ""
    info "Your public key — add this to GitHub (Settings → SSH Keys):"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    read -rp "  Press Enter once the key is added to GitHub..."

    local attempts=0
    while (( attempts < 3 )); do
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            success "SSH connection to GitHub verified"
            return
        fi
        (( attempts++ ))
        warn "Connection failed (attempt $attempts/3)"
        (( attempts < 3 )) && read -rp "  Press Enter to retry, or Ctrl+C to abort..."
    done
    warn "SSH verification failed — continuing anyway"
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

    info "Follow the device code flow to authenticate (no browser required)..."
    gh auth login --git-protocol ssh

    if gh auth status &>/dev/null; then
        success "GitHub CLI authenticated"
    else
        warn "GitHub CLI authentication could not be verified — continuing"
    fi
}

setup_identity() {
    confirm "Generate SSH key and connect to GitHub?" && setup_ssh
    confirm "Configure git user name and email?"      && setup_git_identity
    confirm "Authenticate GitHub CLI (device code)?"  && setup_gh_auth
}
