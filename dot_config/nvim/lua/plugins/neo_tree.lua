return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        -- 当 visible 为 false 时，被过滤的项会完全隐藏
        -- 当 visible 为 true 时，被过滤的项会以变暗/半透明的形式显示出来
        visible = false,

        -- 设置为 false，表示“不隐藏” dot 开始的文件和文件夹（默认直接正常显示）
        hide_dotfiles = false,

        -- 设置为 true，表示“需要隐藏”被 .gitignore 忽略的文件/文件夹
        hide_gitignored = true,

        -- 强制不显示的项目。虽然我们显示了 dotfiles，但通常你不会想看到庞大的 .git 文件夹本身
        never_show = {
          ".git",
          ".DS_Store", -- For macos
        },

        -- 你也可以在这里指定特定名称的文件进行隐藏（哪怕它不是 dotfile 或没被 gitignore）
        hide_by_name = {
          -- "node_modules", 
        },
      },
    },
  },
}
