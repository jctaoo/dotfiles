local wezterm = require("wezterm")

local function color_scheme_for_appearance(appearance)
	if not appearance then
		appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
	end
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

local function adaptive_color(light, dark)
	local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
	if appearance:find("Dark") then
		return dark
	else
		return light
	end
end

local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
end

local function urlencode(url)
	if url == nil then
		return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	return url
end

local hex_to_char = function(x)
	return string.char(tonumber(x, 16))
end

local urldecode = function(url)
	if url == nil then
		return
	end
	url = url:gsub("+", " ")
	url = url:gsub("%%(%x%x)", hex_to_char)
	return url
end

local function get_system()
	local target = wezterm.target_triple
	if target:find("windows") then
		return "windows"
	elseif target:find("darwin") then
		return "macos"
	elseif target:find("linux") then
		local f = io.open("/proc/version", "r")
		if f then
			local version = f:read("*a")
			f:close()
			if version:lower():find("microsoft") or version:lower():find("wsl") then
				return "wsl"
			end
		end
		return "linux"
	end
	return "unknown"
end

local function is_wsl()
	return get_system() == "wsl"
end

local function is_unix()
	local sys = get_system()
	return sys == "linux" or sys == "wsl" or sys == "macos"
end

local function is_windows()
	return get_system() == "windows"
end

return {
	color_scheme_for_appearance = color_scheme_for_appearance,
	adaptive_color = adaptive_color,
	urlencode = urlencode,
	urldecode = urldecode,
	get_system = get_system,
	is_wsl = is_wsl,
	is_unix = is_unix,
	is_windows = is_windows,
}
