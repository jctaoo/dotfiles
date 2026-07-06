return function(wezterm, config)
  local smart_ssh = wezterm.plugin.require("https://github.com/DavidRR-F/smart_ssh.wezterm")
  smart_ssh.apply_to_config(config)

  -- Spawn ssh session in new tab
  table.insert(config.keys, { key = "s", mods = "CTRL|ALT", action = smart_ssh.tab() })
  -- Spawn ssh session in horizontal window
  table.insert(config.keys, { key = "d", mods = "CTRL|ALT", action = smart_ssh.hsplit() })
  -- Spawn ssh session in vertical window
  table.insert(config.keys, { key = "d", mods = "CTRL|SHIFT|ALT", action = smart_ssh.vsplit() })

  local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
  smart_splits.apply_to_config(config, {
    -- the default config is here, if you'd like to use the default keys,
    -- you can omit this configuration table parameter and just use
    -- smart_splits.apply_to_config(config)

    -- directional keys to use in order of: left, down, up, right
    direction_keys = { 'h', 'j', 'k', 'l' },
    -- if you want to use separate direction keys for move vs. resize, you
    -- can also do this:
    -- direction_keys = {
    --  move = { 'h', 'j', 'k', 'l' },
    --  resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
    -- },
    -- modifier keys to combine with direction_keys
    modifiers = {
      move = 'CTRL',       -- modifier to use for pane movement, e.g. CTRL+h to move left
      resize = 'CTRL|ALT', -- modifier to use for pane resize, e.g. META+h to resize to the left
    },
    -- log level to use: info, warn, error
    log_level = 'info',
  })
end
