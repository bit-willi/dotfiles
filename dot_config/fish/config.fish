if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings

    export PATH="$HOME/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.emacs.d/bin:/home/$USER/.local/bin/"

    set -U fish_greeting ""

    source $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/git.fish
    source $HOME/.config/fish/exports.fish
    source $HOME/.config/fish/fzf-key-bindings.fish
    source /etc/grc.fish

    set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"

    source /opt/asdf-vm/asdf.fish

    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

    if test -z "$SSH_AGENT_PID"
        eval "$(ssh-agent -c)" >/dev/null
        set -x SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -x SSH_AGENT_PID $SSH_AGENT_PID
    end
end

