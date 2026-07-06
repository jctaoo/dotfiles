return {
  {
    "akinsho/toggleterm.nvim",
    opts = function (_, opts)
      if vim.fn.has("win32") == 1 then
        opts.shell = "pwsh -NoLogo"
      end

      -- Using zsh on Linux and macOS
      if vim.fn.has("win32") == 0 then
        opts.shell = "zsh"
      end
    end
  },
}
