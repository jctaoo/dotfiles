-- Previewing markdown, latext, typst files in just neovim

return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- 官方特别警告：请务必保持 lazy = false，否则会导致首次打开文件时渲染严重卡顿
  ft = function()
    local plugin = require("lazy.core.config").spec.plugins["markview.nvim"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    return opts.preview and opts.preview.filetypes or { "markdown", "quarto", "rmd" }
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  specs = {
    {
      "AstroNvim/astrocore",
      optional = true,
      ---@type AstroCoreOpts
      opts = {
        -- 1. 自动注入和管理底层 Treesitter 依赖
        treesitter = {
          ensure_installed = { "markdown", "markdown_inline", "html", "latex", "typst" },
        },
        -- 2. 严格遵循 AstroNvim 规范的快捷键配置
        mappings = {
          n = { -- Normal 模式下的快捷键
            -- 注册二级菜单组的名称，这样按下 <leader> 后，Which-Key 菜单会高亮显示 "m - Markdown"
            ["<leader>m"] = { name = "Markdown Related" },

            -- 在 m 菜单下绑定快捷键，Which-Key 面板将完美显示 "Toggle Rich-text Preview"
            ["<leader>mv"] = { "<cmd>Markview toggle<cr>", desc = "Toggle Rich-text Preview" },
            ["<leader>ms"] = { "<cmd>Markview splitToggle<cr>", desc = "Toggle Split Preview" },
          },
        },
      },
    },
  },
  ---@type markview.config
  opts = {
    preview = {
      filetypes = { "markdown", "quarto", "rmd", "typst", "tex" },
      ignored_buftypes = { "nofile" },
      -- 混合动态渲染模式：光标所在行自动显示源码，光标移走后变回富文本态，完美匹配 AstroNvim 的丝滑编辑体验
      hybrid_modes = { "n" },
      headings = { shift_width = 0 },
    },
    markdown = {
      code_blocks = { enable = true, style = "block", pad_amount = 2 },
      tables = { enable = true },
    },
    html = { enable = true },
    latex = { enable = true },
    typst = { enable = true },
  },
}
