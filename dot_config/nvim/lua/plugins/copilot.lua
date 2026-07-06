-- Reference: https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/completion/copilot-lua-cmp/init.lua

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function copilot_action(action)
  local copilot = require "copilot.suggestion"
  return function()
    if copilot.is_visible() then
      copilot[action]()
      return true -- doesn't run the next command
    end
  end
end

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  dependencies = {
    -- for next-edit-suggestions
    { "copilotlsp-nvim/copilot-lsp" },
  },
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = false, -- 禁用默认快捷键，改由下面配置的补全引擎（Tab键）接管
      },
    },
    nes = {
      enabled = false,
      auto_trigger = true,
      keymap = {
        accept_and_goto = "<C-i>",
        accept = "<Tab>",
        dismiss = "<Esc>",
      },
    },
    server_opts_overrides = vim.fn.has "win32" == 1 and {
      cmd_env = {
        XDG_CONFIG_HOME = vim.fn.expand "$LOCALAPPDATA",
      },
    } or nil,
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {},
    },
    {
      "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "zbirenbaum/copilot.lua" },
      opts = function(_, opts)
        local cmp, copilot = require "cmp", require "copilot.suggestion"
        local snip_status_ok, luasnip = pcall(require, "luasnip")
        if not snip_status_ok then return end

        if not opts.mapping then opts.mapping = {} end
        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" })

        opts.mapping["<C-X>"] = cmp.mapping(copilot_action "next")
        opts.mapping["<C-Z>"] = cmp.mapping(copilot_action "prev")
        opts.mapping["<C-Right>"] = cmp.mapping(copilot_action "accept_word")
        opts.mapping["<C-L>"] = cmp.mapping(copilot_action "accept_word")
        opts.mapping["<C-Down>"] = cmp.mapping(copilot_action "accept_line")
        opts.mapping["<C-J>"] = cmp.mapping(copilot_action "accept_line")
        opts.mapping["<C-e>"] = cmp.mapping(copilot_action "dismiss")
      end,
    },
    {
      "saghen/blink.cmp",
      optional = true,
      opts = function(_, opts)
        if not opts.keymap then opts.keymap = {} end

        opts.keymap["<Tab>"] = {
          copilot_action "accept",
          "select_next",
          "snippet_forward",
          function(cmp)
            if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          end,
          "fallback",
        }
        opts.keymap["<C-X>"] = { copilot_action "next" }
        opts.keymap["<C-Z>"] = { copilot_action "prev" }
        opts.keymap["<C-Right>"] = { copilot_action "accept_word" }
        opts.keymap["<C-L>"] = { copilot_action "accept_word" }
        opts.keymap["<C-Down>"] = { copilot_action "accept_line" }
        opts.keymap["<C-J>"] = { copilot_action "accept_line", "select_next", "fallback" }
        opts.keymap["<C-e>"] = { copilot_action "dismiss" }
      end,
    },
  },
}
