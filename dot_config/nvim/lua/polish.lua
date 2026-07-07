-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
local function setup_smart_comment_newline()
  -- 创建一个独立的自动命令组
  local group = vim.api.nvim_create_augroup("SmartCommentNewline", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "*",
    desc = "Disable auto-comment on newline by default",
    callback = function(args)
      -- 移除 o (o/O 自动注释)
      vim.opt_local.formatoptions:remove { "o" }
    end,
  })
end

local function setup_reset_terminal_palette()
  local group = vim.api.nvim_create_augroup("ResetTerminalPalette", { clear = true })

  local function apply()
    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    local seq = ""
    if hl.fg then seq = seq .. string.format("\027]10;#%06x\007", hl.fg) end
    if hl.bg then seq = seq .. string.format("\027]11;#%06x\007", hl.bg) end

    vim.fn.chansend(vim.v.stderr, seq)

    vim.env.DELTA_FEATURES = "+" .. vim.o.background .. "-bg"
  end

  local function reset()
    io.stdout:write "\27]104\7\27]110\7\27]111\7\27]112\7"
    io.stdout:flush()
  end

  -- 进入 / 切主题 → 同步 Normal 色给终端
  vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = group,
    desc = "Sync nvim Normal colors to terminal",
    callback = apply,
  })

  -- Ctrl-Z 挂起 → 复位终端调色板
  vim.api.nvim_create_autocmd("VimSuspend", {
    group = group,
    desc = "Reset terminal OSC palette on suspend",
    callback = reset,
  })

  -- fg 恢复
  vim.api.nvim_create_autocmd("VimResume", {
    group = group,
    desc = "Resume from suspend and do nothing by now",
    callback = function() end,
  })

  -- 退出 → 复位
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    desc = "Reset terminal OSC palette on exit",
    callback = reset,
  })
end

local function patch_vim_ui_open()
  local original_open = vim.ui.open

  vim.ui.open = function(path, opt)
    path = vim.fs.normalize(path):gsub("\\", "/")
    opt = vim.tbl_extend("force", opt or {}, {
      cmd = { "bash", "open" },
    })
    return original_open(path, opt)
  end
end

-- thas hello
local function setup_word_check()
  vim.opt.spelllang = { "en_us", "cjk" }
  vim.opt.spelloptions:append { "camel" }

  vim.opt.spell = true
end

-- Configure for github copilot plugin
local function setup_copilot_auth()
  local copilot_auth_group = vim.api.nvim_create_augroup("CopilotPolishAuth", { clear = true })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = copilot_auth_group,
    once = true,
    callback = function()
      vim.defer_fn(function() pcall(vim.cmd, "Copilot auth") end, 1000)
    end,
  })
end

patch_vim_ui_open()

if vim.g.vscode then return end

-- Terminal specified
setup_reset_terminal_palette()
setup_smart_comment_newline()
setup_word_check()
setup_copilot_auth()
