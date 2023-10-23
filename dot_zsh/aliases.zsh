## aliases

source $HOME/.zsh/git_aliases.zsh

alias init-completion="rm -f $HOME/.zcompdump; compinit"
alias dotfiles="cd ~/dotfiles"
alias fucking='sudo'
alias vi="vim"
alias pip-all="pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
alias lessf="less +F"
alias at="tmux a -t main"
alias r="ranger"
alias cat="bat"
alias bat="cat"
alias network="sudo bandwhich"
alias ll="eza -l --icons"
alias vhistory="history | peco"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
alias shouldideploytoday="curl -s https://shouldideploy.today/api\?tz\=UTC | jq -r '.message'"
alias vim="nvim"
alias v="nvim ."
alias at="tmux a -t 0"
alias i3-brightness-1="xrandr --output eDP-1 --brightness"
alias i3-brightness-2="xrandr --output HDMI-1 --brightness"
# Defaul 7500
alias brightness="sudo vim /sys/class/backlight/intel_backlight/brightness"
alias map="telnet mapscii.me"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias mkdir-date='mkdir $(date +"%Y-%m-%d")'
alias touch-date='touch $(date +"%Y-%m-%d").txt'
alias c='clear'
alias ocaml='rlwrap ocaml'
alias bw-login='export BW_SESSION=$(bw unlock --raw); bw sync'
alias \?='tldr'
alias c=clear
alias sound='pulsemixer'
alias resolv-lock='sudo chattr +i /etc/resolv.conf'
alias resolv-unlock='sudo chattr -i /etc/resolv.conf'
alias dnd-on='pkill -xu $EUID -USR1 dunst'
alias dnd-off='pkill -xu $EUID -USR2 dunst'
alias cl='clear; l'
alias journal='cd ~/.journal'
alias files='pcmanfm'
#alias tmux="TERM=xterm-256color tmux"

# less Colours
if [[ ${PAGER} == 'less' ]]; then
    (( ! ${+LESS_TERMCAP_mb} )) && export LESS_TERMCAP_mb=$'\E[1;31m'   # Begins blinking.
    (( ! ${+LESS_TERMCAP_md} )) && export LESS_TERMCAP_md=$'\E[1;31m'   # Begins bold.
    (( ! ${+LESS_TERMCAP_me} )) && export LESS_TERMCAP_me=$'\E[0m'      # Ends mode.
    (( ! ${+LESS_TERMCAP_se} )) && export LESS_TERMCAP_se=$'\E[0m'      # Ends standout-mode.
    (( ! ${+LESS_TERMCAP_so} )) && export LESS_TERMCAP_so=$'\E[7m'      # Begins standout-mode.
    (( ! ${+LESS_TERMCAP_ue} )) && export LESS_TERMCAP_ue=$'\E[0m'      # Ends underline.
    (( ! ${+LESS_TERMCAP_us} )) && export LESS_TERMCAP_us=$'\E[1;32m'   # Begins underline.
fi

# if eza exist, alias to ls
if (( ${+commands[eza]} )); then
    alias ls='eza'
    alias l='ls'
    alias ll='eza -l --icons'
    alias lll='eza -l | less'
    alias lla='eza -la --icons'
    alias llt='eza -T --icons'
    alias llfu='eza -bghHliS --git'
else
    alias l='ls -1A'         # Lists in one column, hidden files.
    alias ll='ls -lh'        # Lists human readable sizes.
    alias lr='ll -R'         # Lists human readable sizes, recursively.
    alias la='ll -A'         # Lists human readable sizes, hidden files.
    alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
    alias lx='ll -XB'        # Lists sorted by extension (GNU only).
    alias lk='ll -Sr'        # Lists sorted by size, largest last.
    alias lt='ll -tr'        # Lists sorted by date, most recent last.
    alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
    alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
fi

alias sl='ls' # I often screw this up.

if (( $+commands[nvim] )); then
    alias vim="nvim"
fi

if (( $+commands[emacsclient] )); then
    alias e='emacsclient -c -n -a ""'
fi

alias editor='$EDITOR'
alias v='vim'

# Django
alias drunser='python manage.py runserver'
alias dmakemig='python manage.py makemigrations'
alias dmigrate='python manage.py migrate'
alias dshell='python manage.py shell'

if (( $+commands[ggrep] )); then
    export GREP_OPTIONS='-i --color'
    alias ggrep="ggrep $GREP_OPTIONS"
fi

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

if [ -f "$HOME/.emacs.d/bin/doom" ]; then
    alias doom="$HOME/.emacs.d/bin/doom"
fi

if [ -f "$HOME/.config/emacs/bin/doom" ]; then
    alias doom="$HOME/.config/emacs/bin/doom"
fi

dotfiles-update() { cd "$HOME/dotfiles" && ./install.sh; }

if (( $+commands[brew] )); then
    brewfile() {cd $HOME/dotfiles && brew bundle "$1" }
    alias tailf="tail -f"
fi

if [[ $+commands[emacs] && -f "$HOME/workspace/blog/org_to_hugo.el" ]]; then
    blog-gen() {
        cd $HOME/workspace/blog/ && emacs \
            --batch \
            -l ~/.emacs.d/init.el \
            -l $HOME/workspace/blog/org_to_hugo.el \
            --eval "(benmezger/org-roam-export-all)"
    }
fi

if (( $+commands[tmuxinator] )); then
    alias mux="tmuxinator"
    alias m="tmuxinator"
fi


if (( $+commands[gist] )); then
    alias gist="gist -p"
fi

function dotf {
	(cd $HOME/dotfiles && make "$1")
}

alias neomutt="stty discard undef && neomutt"
alias unread="neomutt -f 'notmuch://?query=tag:me and tag:unread'"
alias inbox="neomutt -f 'notmuch://?query=tag:inbox'"
alias me="neomutt -f 'notmuch://?query=tag:me'"
alias archived="neomutt -f 'notmuch://?query=tag:archived'"

if [[ ${OSTYPE} == linux* ]]; then
    alias spotify="/usr/bin/spotify --force-device-scale-factor=1.0 $1"
fi

if (( $+commands[etckeeper] )); then
    alias etcs="sudo etckeeper vcs status"
    alias etca="sudo etckeeper vcs add ."
    alias etcc="sudo etckeeper vcs commit -m"
    alias etcp="sudo etckeeper vcs push origin"
    alias etcl="sudo etckeeper vcs log"
    alias etcpl="sudo etckeeper vcs pull"
fi

if (( $+commands[chezmoi] )); then
    alias cza="chezmoi apply -v"
    alias czadd="chezmoi add -v"
    alias czd="chezmoi diff"
    alias czl="chezmoi git log"
fi

if (( $+commands[pacman] )); then
	alias pac='pacman -S'   # install
	alias pacu='pacman -Syu'    # update, add 'a' to the list of letters to update AUR packages if you use yaourt
	alias pacr='pacman -Rs'   # remove
	alias pacs='pacman -Ss'      # search
	alias paci='pacman -Si'      # info
	alias paclo='pacman -Qdt'    # list orphans
	alias pacro='paclo && sudo pacman -Rns $(pacman -Qtdq)' # remove orphans
	alias pacc='pacman -Scc'    # clean cache
	alias paclf='pacman -Ql'   # list files
	alias pacall='sudo pacman -Syyu'
	alias paci='sudo pacman -S'
	alias pacrdeps='sudo pacman -Rsn'
fi

alias ptrypyenv="poetry env use $(pyenv which python)"
