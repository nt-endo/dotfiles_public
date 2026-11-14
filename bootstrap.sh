#!/bin/bash
# Set up this repository's dotfiles on macOS. Safe to rerun.
set -u

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
SKIP_BREW=0
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --skip-brew) SKIP_BREW=1 ;;
    --dry-run) DRY_RUN=1 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

link_file() {
  src="$DOTFILES/$1"
  dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi

  run mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
    run mv "$dst" "$backup"
  fi
  run ln -s "$src" "$dst"
}

if [ "$SKIP_BREW" -eq 0 ]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' 'Homebrew is required. Install it from https://brew.sh and rerun.' >&2
    exit 1
  fi
  run brew bundle --file="$DOTFILES/Brewfile" --no-upgrade
fi

link_file zsh/.zshrc "$HOME/.zshrc"
link_file zsh/.zshenv "$HOME/.zshenv"
link_file git/.gitconfig "$HOME/.gitconfig"
link_file tmux/.tmux.conf "$HOME/.tmux.conf"
link_file nvim "$HOME/.config/nvim"
link_file ghostty/config "$HOME/.config/ghostty/config"

printf '%s\n' \
  'Dotfiles installed.' \
  'Put secrets and machine-specific shell settings in ~/.zshrc.local.' \
  'Put Git identity in ~/.gitconfig.local. See README.md for placeholders.'
