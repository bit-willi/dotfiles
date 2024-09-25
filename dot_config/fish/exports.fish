export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
#ASDF python binaries
export PATH="$PATH:$HOME/.asdf/installs/python/3.12.1/bin"
export EDITOR="$HOME/.bin/editor"
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

# Docker rootless
export DOCKER_HOST=unix:///run/user/1000/docker.sock

#Pyenv
set -x PYENV_ROOT $HOME/.pyenv
set -x fish_user_paths $PYENV_ROOT/bin $fish_user_paths
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
