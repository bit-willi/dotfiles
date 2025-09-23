# ==============================================================================
# Makefile for dotfiles
# ==============================================================================

# Shell to use
SHELL := /usr/bin/env bash

# Sudo prefix
SUDO := sudo

# File locations
PACMAN_BUNDLE_FILE := Pacfile
AUR_BUNDLE_FILE := Aurfile
PY_REQUIREMENTS := scripts/requirements.txt
PACMAN_CONF := /etc/pacman.conf
LOCALE_GEN_CONF := /etc/locale.gen
GEOCLUE_CONF := /etc/geoclue/geoclue.conf
ASOUND_CONF := /etc/asound.conf
UDEV_RULES_DIR := /etc/udev/rules.d
MODULES_LOAD_DIR := /etc/modules-load.d
X11_CONF_DIR := /etc/X11/xorg.conf.d

# System information
USER := $(shell whoami)
HOST_OS := $(shell uname -s)
IS_LINUX := $(filter Linux, $(HOST_OS))

# ==============================================================================
# Main Targets
# ==============================================================================

.PHONY: all
all: install-required-dependencies configure-linux install-extra-dependencies install-pyenv install-git-dependencies install-windevine-ungoogled-chromium enable-user-services enable-grub-btrfs apply

# ==============================================================================
# System Configuration
# ==============================================================================

.PHONY: configure-linux
configure-linux:
ifeq ($(IS_LINUX),Linux)
	@echo "### Configuring Linux System ###"
	$(SUDO) sed -i '/Color$$/s/^#//g' $(PACMAN_CONF)
	$(SUDO) sed -i '/TotalDownload$$/s/^#//g' $(PACMAN_CONF)
	$(SUDO) sed -i '/CheckSpace$$/s/^#//g' $(PACMAN_CONF)
	$(SUDO) sed -i '/VerbosePkgLists$$/s/^#//g' $(PACMAN_CONF)
	$(SUDO) sed -i '/^#\[multilib\]/{N;s/#//g}' $(PACMAN_CONF)
	$(SUDO) timedatectl set-timezone America/Sao_Paulo
	$(SUDO) timedatectl set-ntp 1
	$(SUDO) timedatectl set-local-rtc 0
	$(SUDO) ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
	$(SUDO) sed -i '/en_US.UTF-8$$/s/^#//g' $(LOCALE_GEN_CONF)
	$(SUDO) locale-gen
	$(SUDO) /sbin/sysctl kernel.dmesg_restrict=0
	$(SUDO) cp etc /etc
	echo "kernel.dmesg_restrict=0" | $(SUDO) tee /etc/sysctl.d/99-dmesg.conf
	echo -e "pcm.!default {\n    type pulse\n}\n\nctl.!default {\n    type pulse\n}" | $(SUDO) tee $(ASOUND_CONF)
else
	@echo "Skipping Linux configuration on $(HOST_OS)"
endif

# ==============================================================================
# Dependency Installation
# ==============================================================================

.PHONY: install-required-dependencies
install-required-dependencies:
ifeq ($(IS_LINUX),Linux)
	@echo "### Installing Required Dependencies ###"
	mkdir -p "$(HOME)/.local/share/chezmoi"
	$(SUDO) pacman -S --noconfirm --needed chezmoi bitwarden-cli geoclue
else
	@echo "Skipping required dependencies on $(HOST_OS)"
endif

.PHONY: install-extra-dependencies
install-extra-dependencies:
ifeq ($(IS_LINUX),Linux)
	@echo "### Installing Extra Dependencies ###"
	$(SUDO) pacman -Syyu
	$(SUDO) pacman -S --noconfirm --needed - < "$(PACMAN_BUNDLE_FILE)"
	command -v yay >/dev/null || (git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm && cd - && rm -rf /tmp/yay)
	yay -S --noconfirm --needed - < "$(AUR_BUNDLE_FILE)"
else
	@echo "Skipping extra dependencies on $(HOST_OS)"
endif

.PHONY: install-git-dependencies
install-git-dependencies:
	@echo "### Installing Git Dependencies ###"
	if [ ! -f "/usr/local/bin/notes" ]; then \
		curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | $(SUDO) bash; \
		chown -R "$(USER):$(USER)" "$(HOME)/.config/notes"; \
	fi

.PHONY: install-go-dependencies
install-go-dependencies:
	@echo "### Installing Go Dependencies ###"
	go install github.com/arl/gitmux@latest
	GO111MODULE=on go install golang.org/x/tools/gopls@latest

.PHONY: install-pyenv
install-pyenv:
	@echo "### Installing pyenv and Python versions ###"
	if [ ! -d "$(HOME)/.pyenv" ]; then \
		curl https://pyenv.run | bash; \
		export PATH="$(HOME)/.pyenv/bin:$$PATH"; \
		for version in 3.10.2 3.8.12 3.9.9 3.11.0; do \
			CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s $$version; \
		done; \
	fi
	pip install --upgrade -r $(PY_REQUIREMENTS)

.PHONY: install-windevine-ungoogled-chromium
install-windevine-ungoogled-chromium:
	@echo "### Installing Widevine for Ungoogled Chromium ###"
	if [ ! -d "/usr/lib/chromium/WidevineCdm" ]; then \
		cd /tmp && \
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
		ar x google-chrome-stable_current_amd64.deb && \
		tar -xvf data.tar.xz && \
		$(SUDO) mv opt/google/chrome/WidevineCdm /usr/lib/chromium/ && \
		rm -rf opt data.tar.xz control.tar.xz debian-binary google-chrome-stable_current_amd64.deb; \
	fi

# ==============================================================================
# System Services and Permissions
# ==============================================================================

.PHONY: enable-user-services
enable-user-services:
	@echo "### Enabling User Services ###"
	systemctl --user enable --now gcr-ssh-agent.socket
	systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service
	systemctl --user enable --now xdg-desktop-portal.service xdg-desktop-portal-wlr.service

.PHONY: enable-grub-btrfs
enable-grub-btrfs:
	@echo "### Enabling GRUB BTRFS Service ###"
	$(SUDO) systemctl enable --now grub-btrfsd

.PHONY: fix-permissions
fix-permissions:
	@echo "### Fixing Permissions ###"
	mkdir -p "$(HOME)/.gnupg"
	chown -R "$(USER)" "$(HOME)/.gnupg/"
	chmod 700 "$(HOME)/.gnupg"
	chmod 755 "$(HOME)/.ssh"
	find "$(HOME)/.ssh" -type f -name 'id_*' -exec chmod 600 {} +

# ==============================================================================
# Application Deployment
# ==============================================================================

.PHONY: apply
apply: install-required-dependencies
	@echo "### Applying Dotfiles with Chezmoi ###"
	bw login --check || bw login
	chezmoi apply -v
	$(MAKE) fix-permissions

# ==============================================================================
# Help
# ==============================================================================

.PHONY: help
help:
	@echo "Makefile for dotfiles"
	@echo ""
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  all                           Run all setup tasks"
	@echo "  configure-linux               Configure system settings for Linux"
	@echo "  install-required-dependencies Install essential packages"
	@echo "  install-extra-dependencies    Install packages from Pacman and AUR"
	@echo "  install-git-dependencies      Install dependencies from Git"
	@echo "  install-go-dependencies       Install Go dependencies"
	@echo "  install-pyenv                 Install pyenv and Python versions"
	@echo "  install-windevine-ungoogled-chromium  Install Widevine for Chromium"
	@echo "  enable-user-services          Enable systemd user services"
	@echo "  enable-grub-btrfs             Enable GRUB BTRFS service"
	@echo "  fix-permissions               Fix permissions for GnuPG and SSH"
	@echo "  apply                         Apply dotfiles with chezmoi"
	@echo "  help                          Show this help message"
