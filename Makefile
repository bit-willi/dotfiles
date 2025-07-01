SHELL := /usr/bin/env bash

LOGFILE := dotfiles.log
PACMAN_BUNDLE_FILE := Pacfile
AUR_BUNDLE_FILE := Aurfile

DOCKER_COMPOSE := $(shell command -v docker-compose > /dev/null && echo "docker-compose" || echo "docker compose")

host := $(shell uname -s)
arch := $(shell uname -p)

ifeq ($(host),Linux)
	is_linux = 1
else
	is_linux = 0
endif

ifeq ($(shell command -v yay 2> /dev/null),)
	yay_installed = 0
else
	yay_installed = 1
endif

.PHONY: all configure-linux install-git-dependencies install-go-dependencies install-pyenv install-extra-dependencies install-required-dependencies enable-gnome-keyring enable-kanata install-windevine-ungoogled-chromium fix-permissions apply full

all: configure-linux apply

configure-linux:
	@echo "Updating pacman.conf.."
	if [ -f /etc/pacman.conf ]; then \
		sudo sed -i '/Color$$/s/^#//g' /etc/pacman.conf; \
		sudo sed -i '/TotalDownload$$/s/^#//g' /etc/pacman.conf; \
		sudo sed -i '/CheckSpace$$/s/^#//g' /etc/pacman.conf; \
		sudo sed -i '/VerbosePkgLists$$/s/^#//g' /etc/pacman.conf; \
		sudo sed -i '/^#\[multilib\]/{N;s/#//g}' /etc/pacman.conf; \
	else \
		echo "/etc/pacman.conf not found!"; \
	fi

	@echo "Enable timedatectl and set up timezone"
	if command -v timedatectl >/dev/null; then \
		sudo timedatectl set-timezone America/Sao_Paulo; \
		sudo timedatectl set-ntp 1; \
		sudo timedatectl set-local-rtc 0; \
		sudo ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime; \
	else \
		echo "timedatectl not found!"; \
	fi

	@echo "Setup locale"
	if [ -f /etc/locale.gen ]; then \
		sudo sed -i '/en_US.UTF-8$$/s/^#//g' /etc/locale.gen; \
		sudo locale-gen; \
	else \
		echo "/etc/locale.gen not found!"; \
	fi

	@echo "Enable non-root access to dmesg"
	if [ -x /sbin/sysctl ]; then \
		sudo /sbin/sysctl kernel.dmesg_restrict=0; \
		grep -q '^kernel.dmesg_restrict=0' /etc/sysctl.d/99-dmesg.conf 2>/dev/null || \
			echo kernel.dmesg_restrict=0 | sudo tee -a /etc/sysctl.d/99-dmesg.conf; \
	else \
		echo "/sbin/sysctl not found!"; \
	fi

	@echo "Updating geoclue.conf.."
	redshift_line="\n[redshift]\nallowed=true\nsystem=false\nusers=\n"
	if [ -f /etc/geoclue/geoclue.conf ]; then \
		grep -qF "[redshift]" "/etc/geoclue/geoclue.conf" || echo -e "$$redshift_line" | sudo tee -a "/etc/geoclue/geoclue.conf"; \
	else \
		echo "/etc/geoclue/geoclue.conf not found!"; \
	fi

install-git-dependencies:
	if [ ! -f "/usr/local/bin/notes" ]; then \
		curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | sudo bash; \
		chown -R "$$(whoami):$$(whoami)" "$$HOME/.config/notes"; \
	fi

install-go-dependencies:
	@echo "Installing gitmux.."
	go install github.com/arl/gitmux@latest

	@echo "Installing gopls.."
	GO111MODULE=on go install golang.org/x/tools/gopls@latest

install-pyenv:
	if [ ! -d "$$HOME/.pyenv" ]; then \
		curl https://pyenv.run | bash; \
		export PATH="$$HOME/.pyenv/bin:$$PATH"; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.10.2; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.8.12; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.9.9; \
		CFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib" pyenv install -s 3.11.0; \
	fi

	if [ -f scripts/requirements.txt ]; then \
		pip install --upgrade -r scripts/requirements.txt; \
	else \
		echo "scripts/requirements.txt not found!"; \
	fi

install-extra-dependencies: $(PACMAN_BUNDLE_FILE) $(AUR_BUNDLE_FILE)
	if [ "$(is_linux)" -eq 1 ]; then \
		sudo pacman -Syyu; \
		if [ -f "$(PACMAN_BUNDLE_FILE)" ]; then \
			sudo pacman -S --noconfirm --needed - <"$(PACMAN_BUNDLE_FILE)"; \
		else \
			echo "$(PACMAN_BUNDLE_FILE) not found!"; \
		fi; \
		if [ "$(yay_installed)" -eq 0 ]; then \
			git clone https://aur.archlinux.org/yay.git /tmp/yay; \
			(cd /tmp/yay && makepkg -si --noconfirm --needed && rm -rf /tmp/yay); \
		fi; \
		if [ -f "$(AUR_BUNDLE_FILE)" ]; then \
			yay -S --noconfirm --needed - <"$(AUR_BUNDLE_FILE)"; \
		else \
			echo "$(AUR_BUNDLE_FILE) not found!"; \
		fi; \
	else \
		echo "Non-Linux OS not supported for install-extra-dependencies"; \
	fi

install-required-dependencies:
	mkdir -p "$$HOME/.local/share/chezmoi"
	if [ "$(is_linux)" -eq 1 ]; then \
		sudo pacman -S --noconfirm chezmoi bitwarden-cli geoclue; \
	else \
		echo "Non-Linux OS not supported for install-required-dependencies"; \
	fi

enable-gnome-keyring:
	systemctl --user enable gcr-ssh-agent.socket
	systemctl --user start gcr-ssh-agent.socket

enable-grub-btrfs:
	sudo systemctl start grub-btrfsd
	sudo systemctl enable grub-btrfsd

enable-kanata:
	sudo usermod -aG input "$$(whoami)"
	echo 'KERNEL=="uinput", MODE="0660", GROUP="input"' | sudo tee /etc/udev/rules.d/99-uinput.rules
	sudo modprobe uinput
	echo uinput | sudo tee /etc/modules-load.d/uinput.conf

enable-touchpad-libinput:
	sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
	Section "InputClass"
	Identifier "touchpad"
	MatchIsTouchpad "on"
	Driver "libinput"
	Option "Tapping" "on"
	Option "NaturalScrolling" "on"
	Option "ScrollMethod" "twofinger"
	EndSection
	EOF

install-windevine-ungoogled-chromium:
	if [ ! -d "/usr/lib/chromium/WidevineCdm" ]; then \
		cd /tmp && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
		ar x /tmp/google-chrome-stable_current_amd64.deb && \
		tar -xvf /tmp/data.tar.xz -C /tmp 2>/dev/null && \
		sudo rm -rf /usr/lib/chromium/WidevineCdm/ && \
		sudo mv /tmp/opt/google/chrome/WidevineCdm/ /usr/lib/chromium/ && \
		rm -f /tmp/google-chrome-stable_current_amd64.deb /tmp/data.tar.xz; \
	fi

fix-permissions:
	@echo "Fixing GnuPG permissions"
	mkdir -p "$$HOME/.gnupg"
	chown -R "$$(whoami)" "$$HOME/.gnupg/"
	chmod -R 700 "$$HOME/.gnupg"

	chmod 755 "$$HOME/.ssh"
	[ -f "$$HOME/.ssh/id_ed25519" ] && chmod 600 "$$HOME/.ssh/id_ed25519"
	[ -f "$$HOME/.ssh/id_ed25519.pub" ] && chmod 600 "$$HOME/.ssh/id_ed25519.pub"

apply: install-required-dependencies
	bw login || true
	chezmoi apply -v
	$(MAKE) fix-permissions

docker-setup-run:
	$(DOCKER_COMPOSE) build
	$(DOCKER_COMPOSE) up

full: install-required-dependencies configure-linux install-extra-dependencies install-pyenv install-git-dependencies install-windevine-ungoogled-chromium enable-gnome-keyring enable-grub-btrfs apply
