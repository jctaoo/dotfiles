local utils = require("utils")

local icons = {
    -- shell / terminal
    powershell = utf8.char(0xf0a0a), -- 󰨊 nf-md-powershell
    terminal = utf8.char(0xf120),    --  nf-fa-terminal
    cmd = utf8.char(0xf17a),         --  nf-fa-windows

    -- remote / ssh
    ssh = utf8.char(0xf084),    --  nf-fa-key
    lock = utf8.char(0xf023),   --  nf-fa-lock
    server = utf8.char(0xf233), --  nf-fa-server
    cloud = utf8.char(0xf0c2),  --  nf-fa-cloud

    -- OS
    windows = utf8.char(0xf17a), --  nf-fa-windows
    linux = utf8.char(0xf17c),   --  nf-fa-linux
    ubuntu = utf8.char(0xf31b),  --  nf-linux-ubuntu
    apple = utf8.char(0xf179),   --  nf-fa-apple

    -- dev tools
    git = utf8.char(0xe702),    --  nf-dev-git
    github = utf8.char(0xf09b), --  nf-fa-github
    vim = utf8.char(0xe62b),    --  nf-custom-vim
    code = utf8.char(0xf121),   --   nf-fa-code

    -- agent
    claude_code = utf8.char(0x273b), -- ✻ U+273B
    opencode = utf8.char(0x25a3),    -- ▣ U
    codex = utf8.char(0x2318),       -- ⌘ U+2318

    -- [1]: https://opencode.ai/brand "OpenCode | Brand"
    -- [2]: https://developers.openai.com/codex/quickstart "Quickstart – Codex | OpenAI Developers"

    -- generic
    desktop = utf8.char(0xf108), --  nf-fa-desktop
    folder = utf8.char(0xf07b),  --  nf-fa-folder
    home = utf8.char(0xf015),    --  nf-fa-home
    grid = utf8.char(0xf00a),    --  nf-fa-th
    plug = utf8.char(0xf1e6),    --  nf-fa-plug
    check = utf8.char(0xf00c),   --  nf-fa-check
    fire = utf8.char(0xf06d),    --  nf-fa-fire
}

local function basename(s)
    if not s or s == "" then
        return ""
    end
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function get_title(tab)
    -- 手动设置过 tab title 的话，优先用手动标题
    if tab.tab_title and #tab.tab_title > 0 then
        return tab.tab_title
    end

    return tab.active_pane.title or ""
end

local function is_wsl(tab)
    local pane = tab.active_pane
    local domain = (pane.domain_name or ""):lower()
    local process = basename(pane.foreground_process_name or ""):lower()
    return process == "wsl.exe" or process == "wslhost.exe" or domain == "wsl" or domain == "wslhost"
end

local function get_icon(tab)
    local pane = tab.active_pane
    local process = basename(pane.foreground_process_name or ""):lower()
    local domain = (pane.domain_name or ""):lower()
    local title = get_title(tab):lower()

    if domain ~= "" and domain ~= "local" then
        return icons.ssh
    end

    if process == "ssh.exe" or title:find("ssh") then
        return icons.ssh
    end

    if process == "pwsh.exe" then
        return icons.powershell
    end

    if process == "powershell.exe" then
        return icons.powershell
    end

    if process == "cmd.exe" then
        return icons.cmd
    end

    if is_wsl(tab) then
        return icons.ubuntu
    end

    if title:find("ubuntu") then
        return icons.ubuntu
    end

    if title:find("nvim") or process:find("nvim") then
        return icons.vim
    end

    if title:find("git") then
        return icons.git
    end

    if title:find("claude") then
        return icons.claude_code
    end

    if title:find("opencode") then
        return icons.opencode
    end

    if title:find("codex") then
        return icons.codex
    end

    return icons.terminal
end

local function get_process_osc1337(pane)
    local process_name = pane.user_vars.WEZTERM_PROG
    if process_name then
        return process_name:match("^(%S+)")
    end
    return nil
end

local function get_pane_cwd(pane)
    local cwd = pane.current_working_dir
    local cwd_path = ""
    if cwd then
        -- normalize path
        cwd_path = cwd.path:gsub("\\", "/"):gsub("/+$", "")
    end
    local cwd_name = basename(cwd_path)
    local project_cwd = cwd_path:match("[^/]+/[^/]+$") or cwd_path:match("[^/]+$") or "/"

    return {
        cwd_name = utils.urldecode(cwd_name),
        project_cwd = utils.urldecode(project_cwd),
        cwd = utils.urldecode(cwd_path)
    }
end

local function get_tab_title(wezterm, tab, is_nvim)
    is_nvim = is_nvim or false

    local pane = tab.active_pane
    local is_wsl_tab = is_wsl(tab)
    local process_name = get_process_osc1337(pane) or pane.foreground_process_name
    local exe = basename(process_name):lower()

    local tab_title_buf = ""

    if is_wsl_tab then
        tab_title_buf = tab_title_buf .. " "
    end

    -- remove file extension
    exe = exe:gsub("%.exe$", "")
    local exe_placeholder = " "
    local display_exe = exe == "" and exe_placeholder or exe

    -- get working directory name
    local cwd_info = get_pane_cwd(pane)
    local cwd_name = cwd_info.cwd_name
    local cwd = cwd_info.cwd
    local project_cwd = cwd_info.project_cwd

    if #cwd_name == 0 then
        tab_title_buf = tab_title_buf .. string.format("%s", pane.title)
    elseif is_nvim then
        local nvim_icon = ""
        tab_title_buf = tab_title_buf .. string.format("%s %s", nvim_icon, project_cwd)
    else
        tab_title_buf = tab_title_buf .. string.format("%s > %s", cwd_name, display_exe)
    end

    return tab_title_buf
end

return function(wezterm, config)
    local wezterm_schemes = wezterm.color.get_builtin_schemes()

    local GLYPH_SEMI_CIRCLE_LEFT = ""
    local GLYPH_SEMI_CIRCLE_RIGHT = ""

    local colors = {
        default = { bg = "#45475a", fg = "#cdd6f4" },
        is_active = { bg = "#45475a", fg = "#FFDD9849" },
        hover = { bg = "#585b70", fg = "#1e1e2e" },
    }

    local cells = {}
    local function push(bg, fg, attribute, text)
        table.insert(cells, { Background = { Color = bg } })
        table.insert(cells, { Foreground = { Color = fg } })
        table.insert(cells, { Attribute = attribute })
        table.insert(cells, { Text = text })
    end

    wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
        local current_theme = utils.color_scheme_for_appearance()
        local scheme = wezterm_schemes[current_theme]
        local theme_bg = scheme.background

        local is_nvim = tab.active_pane.user_vars["IS_NVIM"] == "true"

        cells = {}

        local bg, fg
        if tab.is_active then
            bg, fg = colors.is_active.bg, colors.is_active.fg
        elseif hover then
            bg, fg = colors.hover.bg, colors.hover.fg
        else
            bg, fg = colors.default.bg, colors.default.fg
        end

        local title = get_tab_title(wezterm, tab, is_nvim) or ""
        if #title > max_width then
            title = wezterm.truncate_right(title, max_width)
        end

        local padding = ""
        local top_bottom_pad = " " .. get_icon(tab) .. " "

        push(theme_bg, bg, { Intensity = "Bold" }, top_bottom_pad)
        push(theme_bg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_LEFT)
        push(bg, fg, { Intensity = "Bold" }, padding .. title .. padding)
        push(theme_bg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_RIGHT)

        return cells
    end)
end
