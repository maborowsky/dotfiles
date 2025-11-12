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
require('options')
require('keymap')
require('lsp')
-- require('auto-chains')


-- TODO: move to a colors file
-- vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticWarn" })



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

-- Neovide config
if vim.g.neovide then
    require('neovide_config')
end

require('options')
