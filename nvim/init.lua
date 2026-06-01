-------------------------------------------------
-- Michael Borowsky
--
-- TODO:
--     - :)
-------------------------------------------------

vim.g.mapleader = ' '

vim.g['&t_8f'] = "<Esc>[38;2;%lu;%lu;%lum"
vim.g['&t_8b'] = "<Esc>[48;2;%lu;%lu;%lum"

require("config.lazy")
require('keymap')
require('lsp')
require('autocmds')
-- require('auto-chains')


-- Nvim 0.12 built in undotree
-- has to be after Lazy setup
vim.cmd.packadd ('nvim.undotree')
-- vim.cmd.packadd ('nvim.difftool') -- git config calls -c packadd difftool


-- Moving to vim.pack testing
-- vim.pack.add({
--     'https://github.com/tpope/vim-fugitive'
-- })



-- TODO: move to a colors file
-- vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticWarn" })

vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })       



-- Experimental UI2: floating cmdline and messages
vim.o.cmdheight = 0
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = { height = 0.5 },
	},
})


-- Neovide config
if vim.g.neovide then
    require('neovide_config')
end

-- Load options after plugins
require('options')
