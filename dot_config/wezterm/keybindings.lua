return function(wezterm, config)
    local act = wezterm.action
    config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

    config.keys = {
        { key = "w", mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true } },
        { key = 'm', mods = 'LEADER',       action = wezterm.action.ShowTabNavigator },
        { key = 't', mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },

        -- split
        { key = 'd', mods = 'LEADER',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'd', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'h', mods = 'CTRL',         action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'CTRL',         action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'CTRL',         action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'CTRL',         action = act.ActivatePaneDirection 'Down' },
        { key = 'h', mods = 'CTRL|ALT',     action = act.AdjustPaneSize { 'Left', 2 } },
        { key = 'l', mods = 'CTRL|ALT',     action = act.AdjustPaneSize { 'Right', 2 } },
        { key = 'k', mods = 'CTRL|ALT',     action = act.AdjustPaneSize { 'Up', 2 } },
        { key = 'j', mods = 'CTRL|ALT',     action = act.AdjustPaneSize { 'Down', 2 } },
        { key = 'r', mods = 'LEADER',       action = act.RotatePanes 'Clockwise' },

        -- workspace
        {
            key = "w",
            mods = "ALT|SHIFT",
            action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" },
        },

        -- how to close split?
    }
end
