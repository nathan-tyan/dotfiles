fish_config theme choose "Just a Touch"

set --global fish_greeting

set --local local_config "$__fish_config_dir/local.fish"
if test -e $local_config
    source $local_config
end

starship init fish | source
