# Homebrew works on both Apple Silicon and Intel Macs.
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)

if [ -r "$ZSH/oh-my-zsh.sh" ]; then
  ZSH_THEME_GIT_PROMPT_PREFIX=" %F{244}("
  ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
  ZSH_THEME_GIT_PROMPT_DIRTY="%F{160}*%f"
  ZSH_THEME_GIT_PROMPT_CLEAN=""
  source "$ZSH/oh-my-zsh.sh"
fi

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

autoload -Uz colors && colors
PROMPT='%F{178}%n%f%F{186}@%f%F{187}%m%f %F{226}%1~%f %F{224}$(git_prompt_info)%f %F{185}%#%f '

export PATH="$HOME/.local/bin:$PATH"

# Secrets and machine-specific settings belong here, never in this repository.
[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
