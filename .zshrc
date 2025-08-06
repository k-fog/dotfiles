setopt no_beep

# alias
alias vim=nvim
alias rm=trash-put
alias clip=clip.exe
alias ls='ls --color=always'
alias open=xdg-open
export LESS='-R'

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups

# prompt
autoload -Uz colors && colors

[ -f ~/.git-completion.sh ] && source ~/.git-completion.sh
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCONFLICTSTATE=yes
GIT_PS1_HIDE_IF_PWD_IGNORED=yes

setopt prompt_subst; PROMPT='%F{white}%n@%m %F{blue}%~%F{white}$(__git_ps1 " (%s)")%f %# '

# keybind
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

eval "$(sheldon source)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
