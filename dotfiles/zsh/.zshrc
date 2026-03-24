# Autostart Fastfetch
if [[ -o interactive && -z "$TMUX" && "$SHLVL" -eq 1 ]]; then
    fastfetch
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================
# XDG Base Directories
# =============================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# =============================
# Toolchain Relocations
# =============================
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"

# =============================
# PATH
# =============================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
export PATH="$SDKMAN_DIR/candidates/java/current/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# =============================
# ALIASES
# =============================
alias cls="clear"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gP="git pull"

# =============================
# Oh My Zsh Relocation
# =============================
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# =============================
# SDKMAN Init
# =============================
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# =============================
# Keybindings
# =============================

# CTRL+F for Tmux-Sessionizer
bindkey -s '^f' 'tmux-sessionizer\n'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
