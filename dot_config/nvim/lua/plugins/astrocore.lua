-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

local is_win = vim.fn.has "win32" == 1
local pwsh_flags =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      auto_session = {
        {
          event = "VimEnter",
          desc = "Restore directory session on startup",
          nested = true,
          callback = function()
            if vim.fn.argc(-1) == 0 then
              if vim.g.vscode then
                return
              end
              require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            end
          end,
        }
      },
    },
    options = {
      opt = { -- vim.opt.<key>
        shell = is_win and "pwsh" or vim.o.shell,
        shellcmdflag = is_win and pwsh_flags or vim.o.shellcmdflag,
        shellredir = is_win and "-RedirectStandardOutput %s -NoNewWindow -Wait" or vim.o.shellredir,
        shellpipe = is_win and "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode" or vim.o.shellpipe,
        shellquote = "",
        shellxquote = "",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
  },
}
