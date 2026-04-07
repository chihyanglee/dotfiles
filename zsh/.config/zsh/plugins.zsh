# Powerlevel10k — load immediately (needed before prompt draws)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# zsh-autosuggestions — turbo deferred
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# zsh-syntax-highlighting — turbo deferred, must load after autosuggestions
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# zsh-completions — extra completion definitions
zinit ice wait lucid blockf atpull"zinit creinstall -q ."
zinit light zsh-users/zsh-completions

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi
