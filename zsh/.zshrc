# Native Zsh completion, including Git completion when `_git` is available.
autoload -Uz compinit
compinit

# Show the current Git branch and staged/unstaged changes in the prompt.
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' formats ' %F{244}(%b%c%u)%f'
add-zsh-hook precmd vcs_info

autoload -Uz colors && colors
setopt prompt_subst
PROMPT='%F{178}%n%f%F{186}@%f%F{187}%m%f %F{226}%1~%f${vcs_info_msg_0_} %F{185}%#%f '

alias gitlog='git log --oneline --decorate --graph --color | less -R'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gp='git push -u origin HEAD'
alias gl='git pull'
alias gco='git checkout'
alias gs='git status'
alias gm='git merge'
alias gf='git fetch'

# Secrets and machine-specific settings belong here, never in this repository.
[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
