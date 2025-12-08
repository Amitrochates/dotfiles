# ---------------------------------------------------------------
#  ZSH Configuration (Oh My Zsh + Powerlevel10k + Plugins)
# ---------------------------------------------------------------

# If Zsh is not your default shell, bail early
[ -z "$ZSH_VERSION" ] && return

# -------------------------
# Oh My Zsh base directory
# -------------------------
export ZSH="$HOME/.oh-my-zsh"

# -------------------------
# Powerlevel10k Theme
# -------------------------
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load Powerlevel10k instant prompt (recommended by P10k)
# Speeds up shell loading
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------
# Oh My Zsh Plugins
# -------------------------
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"       # Loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -------------------------
# FZF Init (if installed)
# -------------------------fzf
# fzf installs its own completion + keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -------------------------
# PATH Additions (safe minimal defaults)
# -------------------------
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------
# Load your custom functions, aliases, and scripts
# ---------------------------------------------------------------
# This will source: ~/dotfiles/zsh/.zsh/index.zsh (via symlink to ~/.zsh)
if [ -f "$HOME/.zsh/functions/index.zsh" ]; then
  source "$HOME/.zsh/functions/index.zsh"
fi

# ---------------------------------------------------------------
# Powerlevel10k configuration (optional)
# If your .p10k.zsh exists, load it
# ---------------------------------------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

