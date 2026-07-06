local Snacks = require "snacks"

-- lua/plugins/user.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>fz"] = {
            function() require("snacks").picker.zoxide() end,
            desc = "Zoxide",
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    -- Configure scratch keymaps
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>b."] = {
                function() Snacks.scratch() end,
                desc = "Toggle Scratch Buffer",
              },
              ["<Leader>bS"] = {
                function() Snacks.scratch.select() end,
                desc = "Select Scratch Buffer",
              },
            },
          },
        },
      },
    },
    ---@type snacks.Config
    opts = {
      image = {
        doc = { enabled = true },
      },
      scroll = {},
      -- quickfile = {},
      indent = {
        enabled = true,
        indent = {
          enabled = true,
          char = "│",
          highlight = "SnacksIndent", --@type string|string[] hl group for indent guides
          priority = 100,
          only_scope = false, -- only show indent for the current scope
          only_current = false, -- only show indent in the current window
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = "│",
          underline = false, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
          hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
        },
        chunk = {
          enabled = true,
          priority = 200,
          only_current = true, -- only show chunk in the current window
          hl = "SnacksIndentChunk",
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
    },
  },
}
