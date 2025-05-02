if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings

    export PATH="$HOME/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.emacs.d/bin:/home/$USER/.local/bin/:$HOME/.asdf/installs/php/$($HOME/.asdf/shims/php -v | head -n 1 | cut -d' ' -f2)/.composer/vendor/bin/"

    set -U fish_greeting ""

    source $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/git.fish
    source $HOME/.config/fish/exports.fish
    source $HOME/.config/fish/fzf-key-bindings.fish
    source $HOME/.config/fish/set-java-home.fish
    source $HOME/.config/fish/asdf.fish
    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
    source /etc/grc.fish

    set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
end

