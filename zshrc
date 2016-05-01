# Load ZSH (only for interactive shells)
[[ -s "$HOME/.dotfiles/zsh/config" ]] && source "$HOME/.dotfiles/zsh/config"


export NVM_DIR="/home/dan/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
