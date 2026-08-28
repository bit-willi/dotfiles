SHELL := /usr/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: apply diff install-deps

install-deps:
	@command -v omarchy >/dev/null || { echo "Omarchy is required." >&2; exit 1; }
	omarchy pkg add chezmoi bitwarden-cli jq keyd easyeffects tor proxychains-ng librewolf
	sudo install -Dm0644 "$(CURDIR)/etc/keyd/laptop.conf" /etc/keyd/laptop.conf
	sudo install -Dm0644 "$(CURDIR)/etc/systemd/logind.conf.d/90-ac-lid-lock.conf" /etc/systemd/logind.conf.d/90-ac-lid-lock.conf
	sudo install -Dm0755 "$(CURDIR)/usr/local/libexec/reset-touchpad-i2c" /usr/local/libexec/reset-touchpad-i2c
	sudo install -Dm0644 "$(CURDIR)/etc/systemd/system/reset-touchpad-i2c.service" /etc/systemd/system/reset-touchpad-i2c.service
	sudo systemctl daemon-reload
	sudo systemctl enable --now reset-touchpad-i2c.service
	sudo systemctl enable keyd
	sudo systemctl restart keyd
	echo "Installed dependencies and activated keyd and the touchpad recovery service."

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
	config="$$(mktemp)"
	trap 'rm -f "$$config"' EXIT
	chmod 600 "$$config"
	chezmoi --source "$(CURDIR)" execute-template < .chezmoi.yaml.tmpl > "$$config"
	chezmoi --config "$$config" --config-format yaml --source "$(CURDIR)" $(CHEZMOI_ACTION)
	if [[ "$(CHEZMOI_ACTION)" == "apply" ]]; then
		omarchy toggle idle allow-idle >/dev/null
		if tmux list-sessions >/dev/null 2>&1; then
			tmux source-file "$$HOME/.config/tmux/tmux.conf"
			echo "Reloaded the running tmux server."
		fi
	fi
