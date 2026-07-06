return function(wezterm, config)
	local mux = wezterm.mux
	local function update_status(window)
		-- 这里也是状态栏的时间的展示
		local date = wezterm.strftime("%m/%d %H:%M:%S")
		local hour = tonumber(wezterm.strftime("%H"))

		local time_emoji
		if hour >= 6 and hour < 12 then
			time_emoji = "🌅"
		elseif hour >= 12 and hour < 18 then
			time_emoji = "🌞"
		else
			time_emoji = "🌙"
		end

		-- workspace
		local ws_name = (window:active_workspace() or "?")

		window:set_right_status(wezterm.format({
			-- 这里调整右边状态栏的样式
			{ Attribute = { Italic = true } },
			{ Attribute = { Underline = "Single" } },
			{ Text = string.format("WS:%s | %s %s", ws_name, time_emoji, date) },
		}))
	end

	wezterm.on("update-status", function(window, pane)
		update_status(window)
	end)
end
