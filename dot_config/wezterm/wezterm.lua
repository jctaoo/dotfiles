local wezterm = require("wezterm")
local utils = require("utils")
local plugins = require("plugins")

local config = wezterm.config_builder()

config.set_environment_variables = {
	-- see .zshrc or $PROFILE in windows
	WEZTERM_AUTO_FASTFETCH = "1",
}

local wsl_domains = wezterm.default_wsl_domains()
for idx, dom in pairs(wsl_domains) do
	-- TODO: configure wsl domains
end
config.wsl_domains = wsl_domains

-- Appearance
config.adjust_window_size_when_changing_font_size = false
config.window_background_opacity = utils.is_windows() and 0 or 0.8
config.text_background_opacity = 1
config.win32_system_backdrop = "Mica"
config.macos_window_background_blur = 30
config.initial_cols = 120
config.initial_rows = 28
config.window_decorations = utils.get_system() == "macos" and "INTEGRATED_BUTTONS | RESIZE" or "TITLE | RESIZE"
if utils.get_system() == "macos" then
	config.integrated_title_button_style = "MacOsNative"
	config.window_padding = {
		top = 4,
		left = 2,
		right = 2,
		bottom = 2,
	}
else
	config.window_padding = {
		top = 2,
		left = 2,
		right = 2,
		bottom = 2,
	}
end
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 52
config.show_new_tab_button_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.color_scheme = utils.color_scheme_for_appearance()
-- config.default_prog = { "pwsh.exe", "-NoLogo" }

if utils.is_windows() then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
else
	config.default_prog = { "/bin/zsh", "-l" }
end

config.inactive_pane_hsb = {
	saturation = 0.5, -- 降低饱和度
	brightness = 0.5, -- 调暗亮度，数值越小越暗
}
wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current_appearance = window:get_appearance()
	local scheme = utils.color_scheme_for_appearance(current_appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

-- Font
local function default_font(weight, italic)
	local fallbacks = { { family = "Monaspace Argon NF", weight = weight, italic = italic } }

	if utils.get_system() == "macos" then
		table.insert(fallbacks, { family = "PingFang SC", weight = weight, italic = italic })
	else
		table.insert(fallbacks, { family = "LXGW WenKai Mono Screen", weight = weight, italic = italic })
	end

	table.insert(fallbacks, { family = "JuliaMono", weight = weight, italic = italic })
	table.insert(fallbacks, { family = "Noto Color Emoji", weight = weight, italic = italic })
	return wezterm.font_with_fallback(fallbacks)
end
config.font = default_font("Bold", false)
config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = default_font("ExtraBold", false),
	},
	{
		intensity = "Bold",
		italic = true,
		font = default_font("ExtraBold", true),
	},
}
config.font_size = 11
config.line_height = 1.2
config.cell_width = 1

-- Status
require("status")(wezterm, config)

-- Tabs
require("tabs")(wezterm, config)

-- Keybindings
require("keybindings")(wezterm, config)

-- Workspace
require("workspace")(wezterm, config)

-- Hyperlink
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://www.github.com/$1/$3",
})

-- Plugins
require("plugins")(wezterm, config)

return config
