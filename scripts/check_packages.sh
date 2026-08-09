#!/usr/bin/env bash
#
# Validate Pacfile and Aurfile before anything tries to install from them.
#
# install_deps.sh runs `pacman -S --needed - <Pacfile` under `set -e`, and
# pacman aborts the whole transaction on the first unknown name. One package
# that got renamed or moved to the AUR therefore breaks the entire bootstrap,
# and the failure only shows up on a fresh machine -- the last place you want
# to debug it. This makes that failure reproducible on a working machine.
#
# Exits non-zero if any name cannot be installed.

set -euo pipefail

DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
. "$DIR/scripts/base.sh"
. "$DIR/scripts/ansi"

PACFILE="$DIR/Pacfile"
AURFILE="$DIR/Aurfile"

status=0

# --- duplicates -------------------------------------------------------------
check_duplicates() {
	local file="$1" dupes
	dupes=$(grep -v '^[[:space:]]*$' "$file" | sort | uniq -d)
	if [ -n "$dupes" ]; then
		ansi --red "Duplicate entries in $(basename "$file"):"
		echo "$dupes" | sed 's/^/  /'
		status=1
	fi
}

# A package listed in both files gets built from source by the AUR helper even
# though a binary exists in the repos.
check_overlap() {
	local both
	both=$(comm -12 \
		<(grep -v '^[[:space:]]*$' "$PACFILE" | sort) \
		<(grep -v '^[[:space:]]*$' "$AURFILE" | sort))
	if [ -n "$both" ]; then
		ansi --red "Listed in both Pacfile and Aurfile:"
		echo "$both" | sed 's/^/  /'
		status=1
	fi
}

# --- repo packages ----------------------------------------------------------
# `pacman -Si` is the check that matters: it resolves the exact name, which is
# what pacman is handed. `-Sp` also resolves dependencies and reports failures
# for unrelated conflicts, so it produces false positives here.
check_pacfile() {
	local missing=() pkg
	ansi --green "Checking $(wc -l <"$PACFILE") entries in Pacfile"
	while read -r pkg; do
		[ -z "$pkg" ] && continue
		pacman -Si "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
	done <"$PACFILE"

	if [ ${#missing[@]} -gt 0 ]; then
		ansi --red "Not in the official repositories:"
		printf '  %s\n' "${missing[@]}"
		ansi --yellow "Renamed, dropped, or moved to the AUR. A provider may"
		ansi --yellow "still satisfy these, but pin the real name so --noconfirm"
		ansi --yellow "never has to pick between providers."
		status=1
	fi
}

# --- AUR packages -----------------------------------------------------------
check_aurfile() {
	local args found want missing
	isavailable curl || {
		ansi --yellow "curl unavailable, skipping AUR check"
		return
	}
	ansi --green "Checking $(wc -l <"$AURFILE") entries in Aurfile"

	args=$(grep -v '^[[:space:]]*$' "$AURFILE" | sed 's/^/\&arg[]=/' | tr -d '\n')
	if ! curl -sf --max-time 30 \
		"https://aur.archlinux.org/rpc/v5/info?${args#&}" -o /tmp/aur-check.json; then
		ansi --yellow "AUR unreachable, skipping"
		return
	fi

	found=$(python3 -c "
import json
print('\n'.join(r['Name'] for r in json.load(open('/tmp/aur-check.json'))['results']))
" | sort)
	want=$(grep -v '^[[:space:]]*$' "$AURFILE" | sort)
	missing=$(comm -23 <(echo "$want") <(echo "$found"))

	if [ -n "$missing" ]; then
		ansi --red "Not in the AUR:"
		echo "$missing" | sed 's/^/  /'
		ansi --yellow "Usually means the package graduated into the official"
		ansi --yellow "repos -- move it to Pacfile."
		status=1
	fi
}

check_duplicates "$PACFILE"
check_duplicates "$AURFILE"
check_overlap
check_pacfile
check_aurfile

if [ $status -eq 0 ]; then
	ansi --green "Package lists are installable"
else
	ansi --red "Package lists would break a fresh install"
fi

exit $status
