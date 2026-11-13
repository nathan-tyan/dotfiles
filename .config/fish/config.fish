fish_config theme choose "Just a Touch"

set --global fish_greeting

fish_add_path --global ~/.local/bin

set --local local_config "$__fish_config_dir/local.fish"
if test -e $local_config
    source $local_config
end

starship init fish | source
