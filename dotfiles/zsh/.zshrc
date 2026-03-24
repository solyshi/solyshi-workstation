# ==============================================================================
# XDG Base Directories
# ==============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# ==============================================================================
# Toolchain — XDG-conform paths
# ==============================================================================
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"

# ==============================================================================
# PATH
# ==============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
export PATH="$SDKMAN_DIR/candidates/java/current/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# ==============================================================================
# Oh My Zsh
# ==============================================================================
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
)

source "$ZSH/oh-my-zsh.sh"

# ==============================================================================
# History
# ==============================================================================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_STATE_HOME/zsh/history"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# ==============================================================================
# Zsh behaviour
# ==============================================================================
setopt AUTO_CD
setopt CORRECT

# ==============================================================================
# Aliases — Modern Navigation (eza & zoxide)
# ==============================================================================
if command -v eza > /dev/null; then
  # Standard Listenansicht (wie dein ll)
  alias ll="eza -l --icons --group-directories-first --git"
  # Alles anzeigen inkl. versteckter Dateien (wie dein la)
  alias la="eza -la --icons --group-directories-first --git"
  # Nur Verzeichnisse anzeigen
  alias ld="eza -lD --icons"
  # Tree-View (extrem nützlich für Projekte!)
  alias lt="eza --tree --level=2 --icons"
else
  alias ll="ls -la"
  alias la="ls -A"
fi

alias cls="clear"

# ==============================================================================
# Zoxide Integration & Smart Jump
# ==============================================================================
eval "$(zoxide init zsh)"

# Die "Jump & Peek" Funktion: 
# Jumps into folder and executes 'll' immediately
z() {
  if [ "$#" -eq 0 ]; then
    __zoxide_z
  else
    __zoxide_z "$@" && ll
  fi
}

# ==============================================================================
# Aliases — Git
# ==============================================================================
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gP="git pull"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gb="git branch"

# ==============================================================================
# Aliases — System
# ==============================================================================
alias update="yay -Syu"
alias cleanup="yay -Sc"

# ==============================================================================
# Aliases — Tmux
# ==============================================================================
alias tl="tmux list-sessions"

# ==============================================================================
# Keybindings
# ==============================================================================
bindkey -s '^f' 'tmux-sessionizer\n'

# ==============================================================================
# SDKMAN Init
# ==============================================================================
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# ==============================================================================
# Powerlevel10k
# ==============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# Autostart — Fastfetch (only interactive, outside of tmux, first shell layer)
# ==============================================================================
if [[ -o interactive && -z "$TMUX" && "$SHLVL" -eq 1 ]]; then
  fastfetch
fi

# ==============================================================================
# p10k Instant Prompt — has to be on bottom
# ==============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

