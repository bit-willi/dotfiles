#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/ansi"
. "$DIR/minimalcheck.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
	SYNCMAIL_PLIST="$HOME/Library/LaunchAgents/com.syncmail.plist"
	if [ -f "$SYNCMAIL_PLIST" ]; then
		ansi --green "Loading syncmail.plist..."
		(launchctl list | grep --silent syncmail) && launchctl unload "$SYNCMAIL_PLIST"
		launchctl load -w "$SYNCMAIL_PLIST"
	else
		ansi --yellow "Skipping launchctl of syncmail.plist"
	fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# ask sudo upfront
	sudo -v

	sudo systemctl enable pcscd

	ansi --green "Setting up UFW service"
	sudo systemctl enable ufw.service
	sudo systemctl restart ufw.service
	sudo ufw enable

	mkdir -p "$HOME/.config/systemd/user/"

	if [ -f "$HOME/.config/systemd/user/syncmail.service" ]; then
		systemctl --user enable syncmail.service
		systemctl --user enable syncmail.timer
	fi

	ansi --green "Setting up redshift"
	systemctl --user enable redshift-gtk.service
	systemctl --user restart redshift-gtk.service

	ansi --green "Setting up NetworkManager"
	sudo systemctl enable NetworkManager
	sudo systemctl restart NetworkManager

	sleep 3 # wait for network

	ansi --green "Setting up NTP"
	sudo systemctl enable ntpd
	sudo systemctl restart ntpd
	sudo timedatectl set-ntp 1

	ansi --green "Starting pipewire"
	systemctl enable --user pipewire-pulse.service
	systemctl start --user pipewire-pulse.service

	ansi --green "Setting up greenclip"
	systemctl --user enable greenclip.service
	systemctl --user restart greenclip.service

	ansi --green "Setting up battery notifier"
	systemctl --user enable battery-notifier.timer
	systemctl --user restart battery-notifier.timer

	ansi --green "Setting up zram"
	sudo sh -c "echo 'ALGORITHM=zstd' > /etc/default/zramd"
	sudo sh -c "echo 'MAX_SIZE=4096' >> /etc/default/zramd"
	sudo systemctl enable --now zramd

	ansi --green "Setting up syncthing"
	systemctl --user start syncthing.service

	ansi --green "Setting up tlp"
	sudo systemctl start tlp.service
fi
