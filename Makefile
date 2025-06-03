SHELL := /usr/bin/env bash

LOGFILE := dotfiles.log
PACMAN_BUNDLE_FILE := Pacfile
AUR_BUNDLE_FILE := Aurfile
EXTRA_PKGS := 1

host := $(shell uname -s)
arch := $(shell uname -p)

ifeq ($(host),Darwin)
	is_linux = 0
else
	is_linux = 1

	ifeq ($(shell command -v yay 2> /dev/null),)
		yay_installed = 0
	else
		yay_installed = 1
	endif
endif


ifeq ($(host),Darwin)
all: configure-osx | apply
else
all: configure-linux | apply
endif

configure-linux:
	@echo "Updating pacman.conf.."
	sudo sed -i '/Color$$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/TotalDownload$$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/CheckSpace$$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/VerbosePkgLists$$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/^#\[multilib\]/{N;s/#//g}' /etc/pacman.conf

	@echo "Enable timedatectl and set up timezone"
	sudo timedatectl set-timezone America/Sao_Paulo
	sudo timedatectl set-ntp 1
	sudo timedatectl set-local-rtc 0
	sudo ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

	@echo "Setup locale"
	sudo sed -i '/en_US.UTF-8$$/s/^#//g' /etc/locale.gen
	sudo locale-gen

	@echo "Enable non-root access to dmesg"
	sudo /sbin/sysctl kernel.dmesg_restrict=0
	echo kernel.dmesg_restrict=0 | sudo tee -a /etc/sysctl.d/99-dmesg.conf

	@echo "Updating geoclue.conf.."
	redshift_line="\n[redshift]\nallowed=true\nsystem=false\nusers=\n"

	grep -qF "[redshift]" "/etc/geoclue/geoclue.conf" || echo -e "$(redshift_line)" | sudo tee -a "/etc/geoclue/geoclue.conf"

configure-osx:
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

	@echo "Save to disk and not in iCloud by default"
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	@echo "Quit printer app when jobs are completed"
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

	@echo "Disable the “Are you sure you want to open this application?” dialog"
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	@echo "Trackpad: enable tap to click for this user and for the login screen"
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	@echo "Increase sound quality for Bluetooth headphones/headsets"
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	@echo "Set a blazingly fast keyboard repeat rate"
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 10

	@echo "Require password immediately after sleep or screen saver begins"
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	@echo "Save screenshots to the desktop"
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"

	@echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
	defaults write com.apple.screencapture type -string "png"

	@echo "Finder: show hidden files by default"
	defaults write com.apple.finder AppleShowAllFiles -bool true

	@echo "Finder: show all filename extensions"
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	@echo "Avoid creating .DS_Store files on network or USB volumes"
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	@echo "Set to check daily instead of weekly"
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	@echo "Set default clock format"
	defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm:ss a"

	@echo "Set Default Finder Location to Home Folder"
	defaults write com.apple.finder NewWindowTarget -string "PfLo"
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

	killall Finder
	killall SystemUIServer

	@echo "build locate database"
	sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist || true

	@echo "enable firewall"
	sudo /usr/libexec/applicationfirewall/socketfilterfw --setglobalstate on

	@echo "set clock using network time"
	sudo systemsetup setusingnetworktime on

install-git-dependencies:
	if [[ ! -f "/usr/local/bin/notes" ]]; then \
		curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | sudo bash; \
	fi

install-go-dependencies:
	@echo "Installing gitmux.."
	go install github.com/arl/gitmux@latest

	@echo "Installing gopls.."
	GO111MODULE=on go install golang.org/x/tools/gopls@latest

install-pyenv:
	if [[ "$(host)" == "Darwin" ]]; then \
		export LDFLAGS="-L/usr/local/opt/zlib/lib"; \
	fi

	if [ ! -d "$(HOME)/.pyenv" ]; then \
		curl https://pyenv.run | bash; \
		export PATH="$(HOME)/.pyenv/bin:$$PATH"; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.10.2; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.8.12; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.9.9; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.11.0; \
	fi

	pip install --upgrade -r scripts/requirements.txt


install-extra-dependencies:
	if [[ $(is_linux) -eq 1 ]]; then \
		sudo pacman -Syyu; \
		sudo pacman -S --noconfirm --needed - <"$(PACMAN_BUNDLE_FILE)"; \
		if [ $(yay_installed) -eq 0 ]; then \
			git clone https://aur.archlinux.org/yay.git /tmp/yay; \
			(cd /tmp/yay && makepkg -si --noconfirm --needed && rm -rf /tmp/yay); \
			yay -S --noconfirm --needed - <"$(AUR_BUNDLE_FILE)"; \
		else \
			yay -S --noconfirm --needed - <"$(AUR_BUNDLE_FILE)"; \
		fi; \
	else \
		brew update; \
		brew bundle; \
	fi

install-required-dependencies:
	mkdir -p ~/.local/share/chezmoi
	if [[ $(is_linux) -eq 1 ]]; then \
		sudo pacman -S chezmoi bitwarden-cli geoclue; \
	else \
		brew install chezmoi bitwarden-cli geoclue; \
	fi

enable-gnome-keyring:
	systemctl --user enable gcr-ssh-agent.socket
	systemctl --user start gcr-ssh-agent.socket

enable-kanata:
	sudo usermod -aG input $USER
	echo 'KERNEL=="uinput", MODE="0660", GROUP="input"' | sudo tee /etc/udev/rules.d/99-uinput.rules
	sudo modprobe uinput
	echo uinput | sudo tee /etc/modules-load.d/uinput.conf

install-windevine-ungoogled-chromium:
	if [[ ! -f "/usr/lib/chromium/WidevineCdm" ]]; then \
		cd /tmp && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
		ar x /tmp/google-chrome-stable_current_amd64.deb --output=/tmp && \
		tar -xvf /tmp/data.tar.xz -C /tmp 2>/dev/null && \
		sudo rm -rf /usr/lib/chromium/WidevineCdm/ && \
		sudo mv /tmp/opt/google/chrome/WidevineCdm/ /usr/lib/chromium/ && \
		rm -f /tmp/google-chrome-stable_current_amd64.deb /tmp/data.tar.xz; \
	fi

fix-permissions:
	@echo "Fixing GnuPG permissions"
	mkdir ~/.gnupg 2>/dev/null
	chown -R $(USER) ~/.gnupg/
	chmod -R 700 ~/.gnupg

	chmod 755 $(HOME)/.ssh
	[ -f "$(HOME)/.ssh/id_ed25519" ] && chmod 600 "$(HOME)/.ssh/id_ed25519"
	[ -f "$(HOME)/.ssh/id_ed25519.pub" ] && chmod 600 "$(HOME)/.ssh/id_ed25519.pub"

apply: install-required-dependencies
	bw login || true
	chezmoi apply -v
	$(MAKE) fix-permissions

full: install-required-dependencies configure-linux apply install-extra-dependencies install-pyenv install-git-dependencies install-windevine-ungoogled-chromium enable-gnome-keyring

