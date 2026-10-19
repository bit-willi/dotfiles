#!/usr/bin/bash
set -euo pipefail

config="${HOME}/.config/rclone/icloud-drive.conf"
item="rclone-icloud-drive"

if [[ ! -f "$config" ]] || ! command -v bw >/dev/null || ! command -v jq >/dev/null; then
  echo "The iCloud config, Bitwarden CLI, or jq is unavailable."
  exit 1
fi

vault_status=$(bw status 2>/dev/null | jq -r '.status // ""') || vault_status=""
case "$vault_status" in
  locked)
    echo "Unlock Bitwarden to save the current iCloud login."
    if session=$(bw unlock --raw); then
      export BW_SESSION="$session"
    else
      # A revoked Bitwarden login can look locked until unlock contacts the server.
      vault_status=$(bw status 2>/dev/null | jq -r '.status // ""') || vault_status=""
      if [[ "$vault_status" != "unauthenticated" ]]; then
        echo "Bitwarden unlock failed; the iCloud mount remains available."
        exit 1
      fi
      echo "The Bitwarden login expired. Sign in again to save the iCloud login."
      session=$(bw login --raw) || exit 1
      export BW_SESSION="$session"
    fi
    ;;
  unauthenticated)
    echo "Sign in to Bitwarden to save the current iCloud login."
    session=$(bw login --raw) || exit 1
    export BW_SESSION="$session"
    ;;
  unlocked)
    if [[ -z "${BW_SESSION:-}" ]]; then
      session=$(bw unlock --raw) || exit 1
      export BW_SESSION="$session"
    fi
    ;;
  *)
    echo "Could not determine Bitwarden login status."
    exit 1
    ;;
esac

if ! bw sync >/dev/null; then
  echo "Bitwarden sync failed; the local iCloud login is unchanged."
  exit 1
fi

item_id=$(bw list items --search "$item" |
  jq -r --arg name "$item" '[.[] | select(.name == $name) | .id] |
    if length == 0 then "" elif length == 1 then .[0] else error("Multiple matching iCloud items") end') || {
  echo "Could not safely identify the iCloud Bitwarden item."
  exit 1
}

if [[ -z "$item_id" ]]; then
  echo "Creating a separate secure note for rclone's iCloud session."
  item_id=$(bw get template item |
    jq --arg name "$item" --rawfile rclone_config "$config" \
      '.name = $name | .type = 2 | .secureNote.type = 0 | .notes = $rclone_config' |
    bw encode | bw create item | jq -r '.id // empty') || {
    echo "Bitwarden could not create the iCloud session note."
    exit 1
  }
  if [[ -z "$item_id" ]]; then
    echo "Bitwarden did not return an item ID."
    exit 1
  fi
else
  if ! bw get item "$item_id" |
    jq --rawfile rclone_config "$config" '.notes = $rclone_config' |
    bw encode |
    bw edit item "$item_id" >/dev/null; then
    echo "Bitwarden could not update the iCloud session note."
    exit 1
  fi
fi

if ! bw sync >/dev/null; then
  echo "Bitwarden did not confirm the saved iCloud login."
  exit 1
fi
if ! bw get item "$item_id" | jq -rj '.notes // ""' | cmp -s "$config" -; then
  echo "Bitwarden did not confirm the saved iCloud login."
  exit 1
fi

echo "Current iCloud login saved to Bitwarden."
