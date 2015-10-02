# Load ZSH
[[ -s "$HOME/.dotfiles/zsh/config" ]] && source "$HOME/.dotfiles/zsh/config"

# Load NVM
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
