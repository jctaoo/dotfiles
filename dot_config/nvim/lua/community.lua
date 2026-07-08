-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	-- Themes and looks
	{ import = "astrocommunity.colorscheme.catppuccin" },
	-- Lanugage Packs
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.cpp" },
	{ import = "astrocommunity.pack.toml" },
	{ import = "astrocommunity.pack.python.base" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.prettier" },
	{ import = "astrocommunity.pack.rust" },
	-- 自动保存插件
	{ import = "astrocommunity.editing-support.auto-save-nvim" },
	-- Remove bg (using toggle keyboard <leader>uT)
	{ import = "astrocommunity.color.transparent-nvim" },
	-- VSCode 支持
	{ import = "astrocommunity.recipes.vscode" },
	-- Motion
	{ import = "astrocommunity.motion.flash-nvim" },
	{ import = "astrocommunity.motion.mini-move" },
	-- Search and replace
	{ import = "astrocommunity.search.grug-far-nvim" },
	-- Yazi integration
	{ import = "astrocommunity.file-explorer.yazi-nvim" },
}
