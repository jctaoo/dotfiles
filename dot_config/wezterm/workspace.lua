local utils = require('utils')

return function(wezterm, config)
    local is_windows = utils.is_windows()
    local mux = wezterm.mux

    wezterm.GLOBAL.mihomo_pane_id = wezterm.GLOBAL.mihomo_pane_id or nil

    -- default workspace
    local function default_workspace(args)
        local home_dir = is_windows and "D:\\Work" or os.getenv('HOME')

        local tab, build_pane, window = mux.spawn_window {
            workspace = 'default',
            cwd = home_dir,
            args = args and #args > 0 and args or nil,
        }
    end

    wezterm.on('gui-startup', function(cmd)
        local args = {}
        if cmd and cmd.args then
            args = cmd.args
        end

        default_workspace(args)

        mux.set_active_workspace 'default'
    end)
end
