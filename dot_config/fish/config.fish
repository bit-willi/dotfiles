if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings

    source $HOME/.config/fish/aliases.fish
    source /etc/grc.fish

    set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"

    source $HOME/.local/share/nvim/lazy/fzf/shell/key-bindings.fish

    source $HOME/.asdf/asdf.fish
end
