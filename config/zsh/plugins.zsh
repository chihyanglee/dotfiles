# Plugin directory
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh"

# zsh-autosuggestions
if [[ -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ]]; then
  source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# zsh-syntax-highlighting
# MUST be loaded near the end of .zshrc or plugins
if [[ -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]]; then
  source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

