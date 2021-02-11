#!/usr/bin/env bash
set -euo pipefail

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "Not a darwin platform. Skipping."
	exit 0
fi

# mostly from: https://github.com/mathiasbynens/dotfiles/blob/main/.macos

echo "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "Save to disk and not in iCloud by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Quit printer app when jobs are completed"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "Finder: show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Set to check daily instead of weekly"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "Set default clock format"
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm:ss a"

echo "Set Default Finder Location to Home Folder"
defaults write com.apple.finder NewWindowTarget -string "PfLo" &&
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

echo "Killing Finder.."
killall Finder

echo "Killing SystemUIServer"
killall SystemUIServer

if [ "${CI:-0}" = "1" ]; then
	echo "Skipping sudo required commands"
	exit 0
fi

echo "Build Locate Database"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

echo "Enable firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

echo "Set Clock Using Network Time"
sudo systemsetup setusingnetworktime on

echo "Killing SystemUIServer"
killall SystemUIServer
