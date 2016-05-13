typeset -U path
path=($path[@] ~/bin ~/.rvm/bin ~/Android/Sdk/platform-tools)
export EDITOR="vim"
export IRULE_TEST_BUILDER_LOCAL=true

# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load NVM
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
    export GPG_AGENT_INFO
else
    eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
fi
