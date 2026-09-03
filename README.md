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
git clone --branch main https://github.com/bit-willi/dotfiles.git
cd dotfiles
make install-deps
make apply
```

`make install-deps` installs the packages listed in `omarchy_packages`, including
the dotfile tools, LibreWolf, VPN support, Git LFS, gitmux, mkcert, SMART tools,
EasyEffects, Tor, ProxyChains, and a hardware-accelerated Android emulator. The
first setup creates an `omarchy-android` Pixel virtual device; launch it later
with `android-emulator`. It also installs `etc/keyd/laptop.conf`,
enables the keyd service, and configures lid close on AC power to lock without
suspending. Reboot once after installing to activate the logind policy.

To download or restore only the Android SDK, emulator, platform, system image,
and virtual device, run:

```bash
make install-android-emulator
```

Docker runs as a rootless user service using
`unix:///run/user/$UID/docker.sock`. To install or repair only that setup, run:

```bash
make install-rootless-docker
```

The dependency setup also installs and enables Homearchy with only its recursive
grid active globally. `Super+Shift+G` replaces Omarchy's Signal shortcut; the
existing `Super+Shift+F` Nautilus shortcut remains available.

The top bar uses a macOS-style layout: its center is empty, while indicators,
update status, weather, keyboard layout, system controls, and the clock are on
the right. The clock is placed at the far-right edge. The clock and weather
panels are cloned locally so their popups open below the clicked widgets instead
of in the center of the display.

`make apply` asks for the Bitwarden master password once, exports the returned
session only inside the Make process, and uses it for the full chezmoi apply.

Review changes before applying:

```bash
make diff
make apply
```

Private SSH material is never stored in Git. The templates retrieve existing
Bitwarden attachments during `chezmoi apply`.
