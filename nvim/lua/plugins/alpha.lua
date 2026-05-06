return {
  {
    'goolord/alpha-nvim',
    dependencies = {
      'nvim-mini/mini.icons',
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      local theta = require('alpha.themes.theta')
      local dashboard = require('alpha.themes.dashboard')

      vim.list_extend(theta.buttons.val, {
        { type = 'padding', val = 1 },
        dashboard.button('z', '  Edit ~/.zshrc',       '<cmd>e ~/.zshrc<CR>'),
        dashboard.button('g', '  Edit Ghostty config', '<cmd>e ~/.config/ghostty/config<CR>'),
      })

      require('alpha').setup(theta.config)
    end
  },
}
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

