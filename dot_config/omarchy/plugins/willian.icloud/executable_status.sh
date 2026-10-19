#!/usr/bin/bash
set -u

config="${HOME}/.config/rclone/icloud-drive.conf"
google_config="${HOME}/.config/rclone/google-drive.conf"

probe() {
  local name="$1" service="$2"
  shift 2
  if [[ ! -f "$config" ]]; then
    printf '%s=not configured\n' "$name"
    return
  fi
  local output
  if output=$(timeout 20 rclone --config "$config" lsd "$@" --max-depth 1 2>&1); then
    if systemctl --user is-active --quiet "$service"; then
      printf '%s=online\n' "$name"
    else
      printf '%s=not mounted\n' "$name"
    fi
  elif [[ "$output" == *"Missing X-APPLE-WEBAUTH-TOKEN"* || "$output" == *"requestPCS("* ]]; then
    printf '%s=web approval needed\n' "$name"
  elif [[ "$output" == *"Invalid global session"* ]]; then
    printf '%s=login needed\n' "$name"
  elif ! systemctl --user is-active --quiet "$service"; then
    printf '%s=not mounted\n' "$name"
  elif [[ "$output" == *"deadline exceeded"* || "$output" == *"connection refused"* || "$output" == *"no such host"* ]]; then
    printf '%s=offline\n' "$name"
  else
    printf '%s=error\n' "$name"
  fi
}

probe drive rclone-icloud-drive.service icloud-drive:
probe photos rclone-icloud-photos.service icloud-drive:PrimarySync --iclouddrive-service=photos

probe_google() {
  if [[ ! -f "$google_config" ]]; then
    printf 'google=not configured\n'
    return
  fi
  local output
  if output=$(timeout 20 rclone --config "$google_config" about google-drive: 2>&1); then
    if systemctl --user is-active --quiet rclone-google-drive.service; then
      printf 'google=online\n'
    else
      printf 'google=not mounted\n'
    fi
  elif [[ "$output" == *"invalid_grant"* || "$output" == *"Unauthorized"* || "$output" == *"token expired"* || "$output" == *"couldn't fetch token"* ]]; then
    printf 'google=login needed\n'
  elif [[ "$output" == *"deadline exceeded"* || "$output" == *"connection refused"* || "$output" == *"no such host"* || "$output" == *"network is unreachable"* ]]; then
    printf 'google=offline\n'
  elif ! systemctl --user is-active --quiet rclone-google-drive.service; then
    printf 'google=not mounted\n'
  else
    printf 'google=error\n'
  fi
}

probe_google
