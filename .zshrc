# Set up the prompt

source ~/.zsh/git-prompt.sh
fpath=(~/.zsh $fpath)

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCONFLICTSTATE=yes
GIT_PS1_HIDE_IF_PWD_IGNORED=yes

setopt prompt_subst; PROMPT='%F{green}%n@%m %F{blue}%~%F{white}$(__git_ps1 " (%s)")%f %# '

# history
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt histignorealldups sharehistory

autoload -Uz colors && colors

# Use modern completion system
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# Alias definitions.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

eval "$(sheldon source)"
eval "$(opam env)"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/kiri/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
