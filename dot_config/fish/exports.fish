export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export EDITOR="$HOME/.bin/editor"
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
export ANDROID_HOME=/opt/android-sdk
export DOCKER_HOST=unix:///run/user/1000/docker.sock
export CHROME_EXECUTABLE=/usr/bin/chromium

# Path
export PATH="$PATH":"$HOME/.pub-cache/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator"

# Env Secrets
source $HOME/.env-secrets

#Pyenv
set -x PYENV_ROOT $HOME/.pyenv
set -x fish_user_paths $PYENV_ROOT/bin $fish_user_paths
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
