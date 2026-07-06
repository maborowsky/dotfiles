return {
  -- Dependencies
  { 'nvim-tree/nvim-web-devicons' },

  -- Movement
  {
    'wellle/targets.vim',
    enabled = false,  -- I don't think we need this with mini.ai
  },

  -- Interface
  -- {
  --   -- Circles
  --   "projekt0n/circles.nvim",
  --   dependencies = {"nvim-tree/nvim-web-devicons"},
  --   config = function()
  --     require("circles").setup({
  --       icons = { empty = '', filled = '', lsp_prefix = '' },
  --       lsp = true,
  --     })
  --   end
  -- },

} -- end return


















-----------------------------------------------
-----------------------------------------------
-- Disabled for now ---------
-----------------------------------------------
-----------------------------------------------
  -- use {
  --   'krivahtoo/silicon.nvim',
  --   run = './install.sh',
  --   config = function()
  --     require('silicon').setup({
  --       -- font = 'FantasqueSansMono Nerd Font=16',
  --       -- theme = 'Monokai Extended',
  --       output = {
  --         path = "~/screenshots/Pictures/screenshots"
  --       },
  --     })
  --   end
  -- }

  -- -- Pairs
  -- use {
  --   'ZhiyuanLck/smart-pairs',
  --   event = 'InsertEnter',
  --   config = function()
  --     require('pairs'):setup()
  --   end
  -- }

