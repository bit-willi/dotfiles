alias fucking='sudo'
alias lessf="less +F"
alias at="tmux a -t main"
alias cat="bat"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
alias shouldideploytoday="curl -s https://shouldideploy.today/api\?tz\=UTC | jq -r '.message'"
alias bw-export='export BW_SESSION=$(bw unlock | grep "export BW" |  cut -d"=" -f2 | tr -d "\"")'
alias yz="yazi"

# X11/i3 aliases removed — using Omarchy/Hyprland now

alias map="telnet mapscii.me"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias mkdir-date='mkdir $(date +"%Y-%m-%d")'
alias touch-date='touch $(date +"%Y-%m-%d").txt'
alias bw-login='export BW_SESSION=$(bw unlock --raw); bw sync'
alias c=clear
alias cl='clear; l'
alias files='omarchy launch nautilus'

alias resolv-lock='sudo chattr +i /etc/resolv.conf'
alias resolv-unlock='sudo chattr -i /etc/resolv.conf'
alias dnd='omarchy toggle notification silencing'

# single-monitor alias removed — using Wayland/sway now

alias ta='tmux new-session -A -D -s main'
function mkv2mov
    set input "$argv[1]"
    set output (string replace -r '\.mkv$' '.mov' -- "$input")
    ffmpeg -i "$input" -c:v mpeg4 -qscale:v 2 -c:a pcm_s16le "$output"
end

function ogg2mp2
    set input "$argv[1]"
    set output (string replace -r '\.ogg$' '.mp3' -- "$input")
    ffmpeg -i "$input" -acodec libmp3lame "$output"
end

# if eza exist, alias to ls
if type -q eza
    alias ls='eza'
    alias l='eza'
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
