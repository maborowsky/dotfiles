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
require('remap')
-- require('auto-chains')

-- Enabled LSPs
vim.lsp.enable('pylsp')
vim.lsp.enable('ty')
-- vim.lsp.enable("basedpyright")
-- vim.lsp.enable("ruff")

-- TODO: move to a colors file
-- vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticWarn" })


-- not working
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})



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
