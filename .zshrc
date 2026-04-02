HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY PROMPT_SUBST

autoload -Uz compinit vcs_info
compinit -d "$HOME/.zcompdump"

precmd() { vcs_info }

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' (%b%c%u)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%c%u)'

PROMPT='%F{green}%n@%m %F{blue}%~%f${vcs_info_msg_0_} %# '

[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"
eval "$(sheldon source)"
