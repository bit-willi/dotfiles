# Dotfiles for Omarchy

Minimal, additive personal configuration for an Omarchy installation, managed
with [chezmoi](https://www.chezmoi.io/).

This branch intentionally does not manage Omarchy's Hyprland, shell, theme, or
package configuration. Omarchy remains responsible for those defaults while
this repository starts with only:

- Existing Fish configuration from the original dotfiles
- Existing tmux configuration, TPM, gitmux, and session helpers
- SSH config and Ed25519 keypair, restored from Bitwarden attachments

## Bootstrap

Install or unlock the Bitwarden CLI first, then expose the session to chezmoi:

```fish
set -gx BW_SESSION (bw unlock --raw)
chezmoi init --apply --branch omarchy https://github.com/bit-willi/dotfiles.git
```

Review changes before future applies:

```fish
chezmoi diff
chezmoi apply --dry-run --verbose
chezmoi apply
```

Private SSH material is never stored in Git. The templates retrieve existing
Bitwarden attachments during `chezmoi apply`.
