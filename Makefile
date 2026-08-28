SHELL := /usr/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: apply diff

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
	if [[ "$(CHEZMOI_ACTION)" == "apply" ]] && tmux list-sessions >/dev/null 2>&1; then
		tmux source-file "$$HOME/.config/tmux/tmux.conf"
		echo "Reloaded the running tmux server."
	fi
