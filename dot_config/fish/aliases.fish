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
alias l="eza -l --icons"
alias ll="eza"
alias vhistory="history | peco"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
alias shouldideploytoday="curl -s https://shouldideploy.today/api\?tz\=UTC | jq -r '.message'"
alias vim="nvim"
alias v="nvim"
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
#alias ?='tldr'
alias c=clear
alias sound='pulsemixer'
alias resolv-lock='sudo chattr +i /etc/resolv.conf'
alias resolv-unlock='sudo chattr -i /etc/resolv.conf'
alias dnd-on='pkill -xu $EUID -USR1 dunst'
alias dnd-off='pkill -xu $EUID -USR2 dunst'
alias cl='clear; l'
alias journal='cd ~/.journal'
alias files='pcmanfm'
alias grc='/usr/bin/grc'
alias svn='svn --password=spx@Dev307'

# if eza exist, alias to ls
if type -q eza
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
end

# if nvim exists, aliast to vim
if type -q nvim
    alias vim="nvim"
end

# Awrit dont works under tmux, so i need to spawn a new kitty instance.
function awrit
    kitty sh -c "awrit $argv" 2>/dev/null
end
