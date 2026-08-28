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

Clone this branch, enter its directory, and apply it:

```bash
git clone --branch omarchy https://github.com/bit-willi/dotfiles.git
cd dotfiles
make install-deps
make apply
```

`make install-deps` installs chezmoi, the Bitwarden CLI, jq, and keyd through
Omarchy. It also installs `etc/keyd/laptop.conf`, enables the keyd service, and
configures lid close on AC power to lock without suspending. Reboot once after
installing to activate the logind policy.

`make apply` asks for the Bitwarden master password once, exports the returned
session only inside the Make process, and uses it for the full chezmoi apply.

Review changes before applying:

```bash
make diff
make apply
```

Private SSH material is never stored in Git. The templates retrieve existing
Bitwarden attachments during `chezmoi apply`.
