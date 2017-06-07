typeset -U path
path=($HOME/.rvm/bin ./scripts $HOME/bin $HOME/Android/Sdk/platform-tools /usr/local/heroku/bin $path[@])
export EDITOR="vim"
export NVM_DIR="/home/dan/.nvm"
export ANDROID_HOME="/home/dan/Android/Sdk"
export ANDROID_NDK="/home/dan/workspace/android-ndk-r12"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Load NVM and AVN
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"

# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
