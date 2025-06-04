FROM archlinux/archlinux:latest

MAINTAINER Ben Mezger <me@benmezger.nl>

# Update system and install base packages
RUN pacman -Syu --noconfirm
RUN pacman -S sudo git file awk gcc base-devel reflector make curl wget tar gzip \
    which systemd systemd-sysvcompat go python python-pip --noconfirm

# Setup mirrors
RUN reflector --latest 5 \
        --save "/etc/pacman.d/mirrorlist" \
        --sort rate \
        --protocol https \
        --verbose

# Create user and setup sudo
RUN useradd -ms /bin/bash archie
RUN usermod -aG wheel archie
RUN echo 'archie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create necessary directories
RUN mkdir -p /home/archie/.local/share/chezmoi
RUN mkdir -p /home/archie/.config/notes
RUN mkdir -p /home/archie/.gnupg
RUN mkdir -p /home/archie/.ssh

USER archie
WORKDIR /home/archie/dotfiles

# Copy dotfiles with correct ownership
COPY --chown=archie:archie . /home/archie/dotfiles

ENTRYPOINT ["bash", "docker-entrypoint.sh"]
