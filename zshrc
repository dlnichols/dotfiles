# Load ZSH config (only for interactive shells)
[[ -s "$HOME/.dotfiles/zsh/alias" ]] && source "$HOME/.dotfiles/zsh/alias"
[[ -s "$HOME/.dotfiles/zsh/config" ]] && source "$HOME/.dotfiles/zsh/config"
[[ -s "$HOME/.dotfiles/zsh/prompt" ]] && source "$HOME/.dotfiles/zsh/prompt"

# Load AWS Autocompletion
[[ -s "/usr/local/bin/aws_zsh_completer.sh" ]] && source "/usr/local/bin/aws_zsh_completer.sh"

# Load thefuck alias
eval $(thefuck --alias)
