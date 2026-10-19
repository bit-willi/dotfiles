#!/usr/bin/bash
set -uo pipefail

config="${HOME}/.config/rclone/icloud-drive.conf"
remote="icloud-drive:"

finish() {
  printf '\nPress Enter to close this terminal.'
  read -r _
}
trap finish EXIT

if [[ ! -f "$config" ]]; then
  echo "iCloud is not configured at $config"
  exit 1
fi

if [[ "${1:-}" == "--save-only" ]]; then
  if ! "${HOME}/.config/omarchy/plugins/willian.icloud/save-auth.sh"; then
    echo "The working iCloud login is still only in the local config."
    exit 1
  fi
  exit 0
fi

echo "Reconnecting iCloud. Enter the code from your trusted Apple device."
if ! rclone --config "$config" config reconnect "$remote"; then
  echo "Apple login did not complete. Check iCloud.com for pending terms or device approval, then retry."
  exit 1
fi

echo "Checking iCloud Drive and Photos…"
if error=$(timeout 30 rclone --config "$config" lsd "$remote" --max-depth 1 2>&1 >/dev/null); then
  :
elif [[ "$error" == *"Missing X-APPLE-WEBAUTH-TOKEN"* || "$error" == *"requestPCS("* ]]; then
  echo "Apple accepted 2FA but did not issue the web-auth cookie."
  echo "Sign in at https://www.icloud.com/ and accept any new terms."
  echo "On your trusted device, enable and approve 'Access iCloud Data on the Web'."
  echo "Then open the cloud panel and choose Reconnect again."
  exit 1
else
  echo "Drive is still inaccessible. Check your connection and retry."
  exit 1
fi
if ! timeout 30 rclone --config "$config" lsd icloud-drive:PrimarySync --iclouddrive-service=photos --max-depth 1 >/dev/null; then
  echo "Photos is still inaccessible. Check iCloud.com and approve web access on your trusted device, then retry."
  exit 1
fi

if systemctl --user restart rclone-icloud-drive.service rclone-icloud-photos.service; then
  echo "Both iCloud mounts are running."
else
  echo "Login worked, but a mount failed to restart; inspect its user journal."
  exit 1
fi

# chezmoi restores this config from Bitwarden, so save the renewed token there.
if ! "${HOME}/.config/omarchy/plugins/willian.icloud/save-auth.sh"; then
  echo "The iCloud mounts work, but the Bitwarden copy still needs updating."
  echo "Middle-click the cloud icon later to retry without another Apple code."
fi

echo "iCloud is ready."
