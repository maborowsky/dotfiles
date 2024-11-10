-------------------------------------------------
-- Michael Borowsky
-- 
-- TODO:
--     - :)
-------------------------------------------------

vim.g.mapleader = ' '
--vim.g.maplocalleader = "\\"
 
--if (not fn.has('gui_running')) and (vim.g['&term'] ~= 'screen' and vim.g['&term'] ~= 'tmux') then
--  vim.g['&t_8f'] = "<Esc>[38;2;%lu;%lu;%lum"
--  vim.g['&t_8b'] = "<Esc>[48;2;%lu;%lu;%lum"
--end
vim.g['&t_8f'] = "<Esc>[38;2;%lu;%lu;%lum"
vim.g['&t_8b'] = "<Esc>[48;2;%lu;%lu;%lum"

vim.opt.laststatus = 3
vim.opt.spell = true

--Decrease update time
vim.opt.updatetime = 50
vim.wo.signcolumn = 'yes'


-- disable netrw because we are using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Terminal scrollback
vim.o.scrollback=100000

--require('plugins')
require("config.lazy")
require('lsp')
-- Should options go above plugins??
require('options')
require('remap')


-- hi! link DiagnosticUnnecessary DiagnosticWarn
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticWarn" })


-- Fugitive
-- command! Gpushu Git push -u origin HEAD


-- startify
-- vim.g:startify_use_env = 1
-- vim.g:startify_fortune_use_unicode = 1
-- vim.g:startify_change_to_vcs_root = 0
-- vim.g:startify_change_to_dir = 0
-- vim.g:startify_list_order = [
--     \ ['   Bookmarks:'],
--     \ 'bookmarks',
--     \ ['   Sessions'],
--     \ 'sessions',
--     \ ['   MRU:'],
--     \ 'files',
--     \ ]

-- vim.g:startify_bookmarks = [ {'v': '$MYVIMRC'} ]
-- vim.g:startify_bookmarks += [
--             \ {'k': '~/.config/kitty/kitty.conf' },
--             \ {'l': '~/.config/nvim/lua/lsp.lua' },
--             \ {'p': '~/.config/nvim/lua/plugins.lua' },
--             \ {'s': '~/.config/skhd/skhdrc' },
--             \ {'y': '~/.config/yabai/yabairc' },
--             \ {'z': '~/.zshrc' },
-- \ ]
