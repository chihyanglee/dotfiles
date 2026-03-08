# eza (ls replacement)
alias ls='eza --group-directories-first'
alias ll='eza -l --group-directories-first --no-user --time-style=relative'
alias la='eza -la --group-directories-first --no-user --time-style=relative'
alias lt='eza -T --level=2 --group-directories-first'

# bat (cat replacement)
alias cat='bat --paging=never --style=plain'
alias catn='bat --paging=never'

# ripgrep
alias rg='rg --smart-case'

# dust (du replacement)
alias du='dust'

# duf (df replacement)
alias df='duf'

# procs (ps replacement)
alias ps='procs'

# btop (htop replacement)
alias top='btop'

# safety
alias rm='rm -I'
alias mv='mv -i'
alias cp='cp -i'
