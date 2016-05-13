# Load ZSH config (only for interactive shells)
[[ -s "$HOME/.dotfiles/zsh/config" ]] && source "$HOME/.dotfiles/zsh/config"

# Load AWS Autocompletion
[[ -s "/usr/local/bin/aws_zsh_completer.sh" ]] && source "/usr/local/bin/aws_zsh_completer.sh"
