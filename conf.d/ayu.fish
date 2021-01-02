set --query ayu_path || set --local ayu_path $__fish_config_dir
switch $ayu_variant
    case light
        source $ayu_path/conf.d/ayu-light.fish && enable_ayu_theme_light
    case dark
        source $ayu_path/conf.d/ayu-dark.fish && enable_ayu_theme_dark
    case mirage
        source $ayu_path/conf.d/ayu-mirage.fish && enable_ayu_theme_mirage
end

function _ayu_save_current_theme
    set --query ayu_path || set --local ayu_path $__fish_config_dir
    set --local previous_theme_file $__fish_config_dir/functions/_ayu_restore_previous_theme.fish
    
    test -e $previous_theme_file && command rm -f $previous_theme_file
    touch $previous_theme_file

    echo 'function _ayu_restore_previous_theme' > $previous_theme_file
    set color_variables (set --names | grep fish_color)
    for color_name in $color_variables
        set --local color_value $$color_name
        printf "\tset --universal $color_name $color_value\n" >> $previous_theme_file
    end
    echo 'end' >> $previous_theme_file
end

function _ayu_install --on-event ayu_install
    echo '_ayu_save_current_theme'
    _ayu_save_current_theme
end

function _ayu_uninstall --on-event ayu_uninstall
    functions --erase enable_ayu_theme_light
    functions --erase enable_ayu_theme_dark
    functions --erase enable_ayu_theme_mirage

    set --local previous_theme_file $__fish_config_dir/functions/_ayu_restore_previous_theme.fish
    source $previous_theme_file && _ayu_restore_previous_theme
    command rm -f $previous_theme_file
    functions --erase _ayu_restore_previous_theme
    set --erase ayu_variant
end
