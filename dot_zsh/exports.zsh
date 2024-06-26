# general exports
export PROJECT_HOME=$HOME/workspace
export EDITOR=$HOME/.bin/editor
export VISUAL=$HOME/.bin/editor
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"
export MAKEFLAGS="-j4 -l5"

if [ -f "$(which nproc)" ]; then
	export MAKEFLAGS="-j$(nproc) -l5"
else
	export MAKERANGE="-j5 -l5"
fi

export GPGKEY=0x7357E344D6C3C795
export LESS='-F -g -i -M -R -S -w -X -z-4'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
#export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh

export PATH="$HOME/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.emacs.d/bin:/home/$USER/.local/bin/"

export WORKSPACE="$HOME/workspace"
export RISCV_PATH="/opt/riscv/"
export RISCV64_PATH="/opt/riscv64/"

if [[ -d $RISCV_PATH ]]; then
	export PATH="$RISCV_PATH/bin:$PATH"
fi

if [[ -d $RISCV64_PATH ]]; then
	export PATH="$RISCV64_PATH/bin:$PATH"
fi

### Plugins

# zsh prompt
ZSH_GIT_PROMPT_SHOW_STASH=1
source $HOME/.zsh/prompt.zsh

# Go path
export GOPATH=$HOME/workspace/go
export PATH="$GOPATH/bin:$PATH"

## Autoenv
export AUTOENV_FILE_ENTER=".hi"
export AUTOENV_FILE_LEAVE=".bye"

## Tmux
# autostart tmux
# from: https://github.com/zpm-zsh/tmux/blob/master/tmux.plugin.zsh

# Make sure we are not sshing to this shell or running within an i3 session
IS_DWM=$(ps aux | grep dwm)
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$I3SOCK" ] || [ -n "$IS_DWM" ]; then
	export TMUX_AUTOSTART="false"
else
	export TMUX_AUTOSTART="true"
fi

if [ -f "$HOME/.env-secrets" ]; then
	source "$HOME/.env-secrets"
fi

if [ -f "$HOME/.poetry/bin/poetry" ]; then
	export PATH="$HOME/.poetry/bin:${PATH}"
fi

export GITLINE_REPO_INDICATOR='${reset}ᚴ'
export GITLINE_BRANCH='[${blue}${branch}${reset}]'
export SLIMLINE_RIGHT_PROMPT_SECTIONS="execution_time git vi_mode exit_status"

export ORGANIZE_CONFIG=$HOME/.config/organize-tool/config.yaml
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export HTML_TIDY="$HOME/.config/tidyrc"

# smooth scrooling on firefox
export MOZ_USE_XINPUT2=1
export XDG_CONFIG_HOME=$HOME/.config

if [[ -d "$HOME/workspace/quartus/quartus" ]]; then
	export QSYS_ROOTDIR="$WORKSPACE/quartus/quartus/sopc_builder/bin"
	export PATH="$PATH:$WORKSPACE/quartus/quartus/bin"
fi

if [[ -d "/opt/xilinx/Vivado/2021.2/bin" ]]; then
	export PATH="$PATH:/opt/xilinx/Vivado/2021.2/bin"
fi

if [[ ${OSTYPE} == darwin* ]]; then
	source $HOME/.zsh/osx.zsh
else
	source $HOME/.zsh/linux.zsh
fi

# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'
source $HOME/.zsh/fzf-theme.zsh

if [[ -d "/opt/crosstool-ng/bin/" ]]; then
	export PATH="$PATH:/opt/crosstool-ng/bin"
fi

if [[ -d "$HOME/.local/bin/" ]]; then
	export PATH="$PATH:$HOME/.local/bin/"
fi

# Disabling automatic widget re-binding
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# cargo
if [[ -f "$HOME/.cargo/env" ]]; then
	source $HOME/.cargo/env
fi

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=$HOME/.cache/heroku/autocomplete/zsh_setup &&
	test -f $HEROKU_AC_ZSH_SETUP_PATH &&
	source $HEROKU_AC_ZSH_SETUP_PATH

# helper functions
vv() {
	findOutput=$(find . | ag -v '(vendor|node_modules|phpintel|debugbar|cache|.git/)' | peco)
	if [ ! -z "$findOutput" ]
	then
		echo $findOutput
		editor $findOutput
	fi
}

watch() {
	echo "---- Running watch ----"
	echo "Path to monitor '$0' \nCommand to run '$2'"
	find . $0 2> /dev/null | grep -v '^.$' | entr sh -c $2
}

watchfile() {
	local git immediate
	declare -a args
	while (( $# > 0 )) && [[ $1 != -- ]]; do
		case "$1" in
			--git)
				git=yes
				;;
			-i)
				immediate=yes
				;;
			*)
				args+=("$1")
				;;
		esac
		shift
	done
	shift
	if (( $# == 0 )); then
		echo >&2 "usage: watchfile [-i] FILE... -- CMD..."
		return 1
	fi
	if [[ $immediate ]]; then
		"$@"
	fi
	_wait() {
		if [[ $git ]]; then
			find . -mindepth 1 -name .git -prune -o -execdir git check-ignore -q {} \; -prune -o -print0 | xargs -x0 inotifywait -e modify -e attrib -e close_write -rq
		else
			inotifywait -e modify -e attrib -e close_write --exclude '\.git' -rq "${args[@]}"
		fi
	}
	while _wait "${args[@]}"; do
		echo >&2 ">> Executing ${*@Q}"
		"$@"
	done
}

man() {
	GROFF_NO_SGR=1 \
	LESS_TERMCAP_md=$'\e[1;32m' \
	LESS_TERMCAP_me=$'\e[22;39m' \
	LESS_TERMCAP_so=$'\e[1;37;44m' \
	LESS_TERMCAP_se=$'\e[22;39;49m' \
	LESS_TERMCAP_us=$'\e[3;33m' \
	LESS_TERMCAP_ue=$'\e[23;39m' \
	command man "$@"
}

mkcd() {
	mkdir -p "$1" && cd "$1"
}

open() {
	xdg-open "$1" &>/dev/null
}

# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

# opam configuration
[[ ! -r /home/willian/.opam/opam-init/init.zsh ]] || source /home/willian/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# asdf configuration
. /opt/asdf-vm/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
