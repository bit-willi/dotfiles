SHELL := /usr/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: apply diff install-android-emulator install-deps install-homearchy install-rootless-docker mount-cloud unmount-cloud

install-deps:
	@command -v omarchy >/dev/null || { echo "Omarchy is required." >&2; exit 1; }
	mapfile -t packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$$/d' "$(CURDIR)/omarchy_packages")
	official=()
	aur=()
	for package in "$${packages[@]}"; do
		if pacman -Si "$$package" >/dev/null 2>&1; then
			official+=("$$package")
		else
			aur+=("$$package")
		fi
	done
	(($${#official[@]} == 0)) || omarchy pkg add "$${official[@]}"
	(($${#aur[@]} == 0)) || yay -S --needed --noconfirm "$${aur[@]}"
	git lfs install
	"$(CURDIR)/dot_local/bin/executable_android-emulator" --create-only
	"$(CURDIR)/scripts/ensure-rootless-docker"
	"$(CURDIR)/scripts/ensure-homearchy"
	omarchy bar move omarchy.indicators --section right --after omarchy.agents
	omarchy bar move omarchy.system-update --section right --after omarchy.indicators
	omarchy bar move omarchy.weather --section right --after omarchy.system-update
	omarchy bar move omarchy.keyboard-layout --section right --after omarchy.weather
	omarchy bar move omarchy.clock --section right --after omarchy.power
	"$(CURDIR)/scripts/ensure-anchored-bar-popups"
	omarchy restart shell
	sudo install -Dm0644 "$(CURDIR)/etc/keyd/laptop.conf" /etc/keyd/laptop.conf
	sudo install -Dm0644 "$(CURDIR)/etc/systemd/logind.conf.d/90-ac-lid-lock.conf" /etc/systemd/logind.conf.d/90-ac-lid-lock.conf
	sudo install -Dm0755 "$(CURDIR)/usr/local/libexec/reset-touchpad-i2c" /usr/local/libexec/reset-touchpad-i2c
	sudo install -Dm0644 "$(CURDIR)/etc/systemd/system/reset-touchpad-i2c.service" /etc/systemd/system/reset-touchpad-i2c.service
	install -Dm0644 "$(CURDIR)/dot_config/systemd/user/easyeffects.service" "$$HOME/.config/systemd/user/easyeffects.service"
	install -Dm0644 "$(CURDIR)/dot_config/systemd/user/rclone-google-drive.service" "$$HOME/.config/systemd/user/rclone-google-drive.service"
	install -Dm0644 "$(CURDIR)/dot_config/systemd/user/rclone-icloud-drive.service" "$$HOME/.config/systemd/user/rclone-icloud-drive.service"
	install -Dm0644 "$(CURDIR)/dot_config/systemd/user/rclone-icloud-photos.service" "$$HOME/.config/systemd/user/rclone-icloud-photos.service"
	sudo systemctl daemon-reload
	sudo systemctl enable --now reset-touchpad-i2c.service
	sudo systemctl enable keyd
	sudo systemctl restart keyd
	systemctl --user daemon-reload
	systemctl --user enable --now easyeffects.service
	systemctl --user enable rclone-google-drive.service
	systemctl --user enable rclone-icloud-drive.service
	systemctl --user enable rclone-icloud-photos.service
	echo "Installed packages and activated keyd, touchpad recovery, EasyEffects, and cloud startup."

install-homearchy:
	"$(CURDIR)/scripts/ensure-homearchy"

install-android-emulator:
	"$(CURDIR)/scripts/install-android-emulator"

install-rootless-docker:
	"$(CURDIR)/scripts/ensure-rootless-docker"

mount-cloud:
	@command -v rclone >/dev/null || { echo "rclone is required." >&2; exit 1; }
	mkdir -p "$$HOME/Cloud/GoogleDrive" "$$HOME/Cloud/iCloudDrive"
	systemctl --user daemon-reload
	for remote in google-drive icloud-drive; do
		service="rclone-$${remote}.service"
		config="$$HOME/.config/rclone/$${remote}.conf"
		if [[ -f "$$config" ]] && rclone --config "$$config" listremotes | grep -Fxq "$${remote}:"; then
			systemctl --user enable --now "$$service"
			echo "Mounted $${remote}."
		else
			echo "Skipped $${remote}: remote is not configured yet."
		fi
	done
	if [[ -f "$$HOME/.config/rclone/icloud-drive.conf" ]]; then
		systemctl --user enable --now rclone-icloud-photos.service
		echo "Mounted iCloud Photos."
	fi

unmount-cloud:
	-systemctl --user disable --now rclone-google-drive.service rclone-icloud-drive.service rclone-icloud-photos.service

apply: CHEZMOI_ACTION := apply
diff: CHEZMOI_ACTION := diff

apply diff:
	@command -v bw >/dev/null || { echo "Bitwarden CLI (bw) is required." >&2; exit 1; }
	command -v jq >/dev/null || { echo "jq is required." >&2; exit 1; }
	command -v chezmoi >/dev/null || { echo "chezmoi is required." >&2; exit 1; }
	status="$$(bw status | jq -r '.status')"
	case "$$status" in
		unlocked)
			session="$${BW_SESSION:-}"
			;;
		locked)
			session="$$(bw unlock --raw)"
			;;
		unauthenticated)
			session="$$(bw login --raw)"
			;;
		*)
			echo "Unexpected Bitwarden status: $$status" >&2
			exit 1
			;;
	esac
	test -n "$$session" || { echo "Bitwarden did not return a session." >&2; exit 1; }
	export BW_SESSION="$$session"
	bw sync >/dev/null
	config="$$(mktemp)"
	trap 'rm -f "$$config"' EXIT
	chmod 600 "$$config"
	chezmoi --source "$(CURDIR)" execute-template < .chezmoi.yaml.tmpl > "$$config"
	chezmoi --config "$$config" --config-format yaml --source "$(CURDIR)" $(CHEZMOI_ACTION)
	if [[ "$(CHEZMOI_ACTION)" == "apply" ]]; then
		mkdir -p "$$HOME/Pictures/screenshots"
		omarchy toggle idle allow-idle >/dev/null
		"$(CURDIR)/scripts/ensure-google-drive"
		"$(CURDIR)/scripts/ensure-icloud-drive"
		if tmux list-sessions >/dev/null 2>&1; then
			tmux source-file "$$HOME/.config/tmux/tmux.conf"
			echo "Reloaded the running tmux server."
		fi
	fi
