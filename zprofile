# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load NVM
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

typeset -U path
path=($path[@] ~/bin ~/.rvm/bin ~/Android/Adk/platform-tools)

