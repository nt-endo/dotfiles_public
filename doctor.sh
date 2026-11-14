#!/bin/bash
# Audit content intended for publication. Exit 1 on any finding.
set -u

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
findings=0

warn() {
  printf 'WARN: %s\n' "$*"
  findings=1
}

scan_file() {
  file="$1"
  display="${file#$DOTFILES/}"

  if grep -Iq . "$file" 2>/dev/null; then
    if grep -nE -- '-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}' "$file" >/dev/null 2>&1; then
      warn "credential-like value in $display"
    fi
    if grep -nE '^[[:space:]]*(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*(KEY|TOKEN|SECRET|PASSWORD)[A-Za-z0-9_]*=[^[:space:]]{8,}' "$file" | grep -vE '<[^>]+>' >/dev/null 2>&1; then
      warn "literal secret assignment in $display"
    fi
    if grep -nE '(/Users/[^/[:space:]]+|/home/[^/[:space:]]+)' "$file" >/dev/null 2>&1; then
      warn "hard-coded home directory in $display"
    fi
    if grep -nE '[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}' "$file" | grep -Fiv 'you@example.com' >/dev/null 2>&1; then
      warn "email address in $display"
    fi
  fi
}

while IFS= read -r -d '' file; do
  scan_file "$file"
done < <(find "$DOTFILES" -type f -not -path "$DOTFILES/.git/*" -not -name doctor.sh -print0)

if git -C "$DOTFILES" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  while IFS= read -r path; do
    case "$path" in
      *auth.json|*credentials*|*secret*|*.pem|*.key|*.p12|*.pfx|*/.env|.env)
        warn "sensitive-looking tracked or staged path: $path" ;;
    esac
  done < <({ git -C "$DOTFILES" ls-files; git -C "$DOTFILES" diff --cached --name-only; } | sort -u)
fi

if [ "$findings" -ne 0 ]; then
  exit 1
fi
printf '%s\n' 'doctor: clean'
