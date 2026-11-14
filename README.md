# Public dotfiles

A small, portable macOS setup for Zsh, Git, Neovim, tmux, and Ghostty.
Everything tracked here is intended to be safe to publish. Authentication,
secrets, machine-specific paths, and personal identity belong in local files.

## Install

Review the files first, then run:

```sh
./bootstrap.sh --dry-run
./bootstrap.sh
```

The installer backs up an existing regular file before creating a symlink. It
does not copy credentials or sign in to services.

## Local-only configuration

Create `~/.zshrc.local` for secrets and per-machine shell settings. It is
sourced at the end of the tracked Zsh configuration and must never be added to
this repository.

```sh
# ~/.zshrc.local (example placeholders only)
export SERVICE_API_KEY="<set-this-locally>"
export PATH="$HOME/path-for-this-machine/bin:$PATH"
```

Create `~/.gitconfig.local` for Git identity. The tracked configuration includes
this file when present:

```ini
[user]
    name = Your Name
    email = you@example.com
```

These are placeholders, not usable identity values. Signing keys and credential
helpers also belong in `~/.gitconfig.local`.

## Checks

Run `./doctor.sh` before committing. It checks tracked and staged paths for
common credential files, literal secret assignments, email addresses other than
the documented placeholder, private keys, and hard-coded home directories.
