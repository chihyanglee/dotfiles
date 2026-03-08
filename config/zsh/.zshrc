# instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZDOTDIR="$HOME/.config/zsh"
export PATH="$HOME/.local/bin:$PATH"
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh"

# Keep startup silent and predictable
setopt no_beep

# History (XDG-ish)
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups hist_reduce_blanks share_history

# Load keybinds (Home/End/Delete etc. via terminfo)
[[ -f "$ZDOTDIR/keybinds.zsh" ]] && source "$ZDOTDIR/keybinds.zsh"

# Load aliases if present
[[ -f "$ZDOTDIR/aliases.zsh" ]] && source "$ZDOTDIR/aliases.zsh"

# load plugins
[[ -f "$ZDOTDIR/plugins.zsh" ]] && source "$ZDOTDIR/plugins.zsh"

# theme
if [[ -d "$ZSH_PLUGIN_DIR/powerlevel10k" ]]; then
    source "$ZSH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme"
fi

# p10k
[[ -f "$ZDOTDIR/p10k.zsh" ]] && source "$ZDOTDIR/p10k.zsh"

