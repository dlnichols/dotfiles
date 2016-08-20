typeset -U path
path=($HOME/bin $HOME/.rvm/bin $HOME/Android/Sdk/platform-tools /usr/local/heroku/bin $path[@])
export EDITOR="vim"
#export IRULE_TEST_BUILDER_LOCAL=true
export NVM_DIR="/home/dan/.nvm"
export ANDROID_HOME="/home/dan/Android/Sdk"
export ANDROID_NDK="/home/dan/workspace/android-ndk-r12"

# Load NVM and AVN
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"

# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
