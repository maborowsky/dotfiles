return {

  -- Dependencies
  { 'nvim-tree/nvim-web-devicons' },


  -- Movement
  { 'wellle/targets.vim' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },

  -- Tab, Buffer, Window management
  -- { 'famiu/bufdelete.nvim' },


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
  -- { 'rcarriga/nvim-notify' },

  -- Misc
  { 'tpope/vim-sleuth' },

  -- Python
  -- {
  --   -- Auto F string
  --   "chrisgrieser/nvim-puppeteer",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- },

  -- TODO: replace treesitter with snacks
  -- {
  --   'AckslD/swenv.nvim',
  --   config = function()
  --     require('swenv').setup({
  --       -- Path passed to `get_venvs`.
  --       -- venvs_path = vim.fn.expand('~/venvs'),
  --     })
  --     vim.keymap.set('n', 'fv', '<cmd>lua require(\'swenv.api\').pick_venv()<cr>', {noremap = true})
  --   end,
  --   -- opts = {
  --   --   venvs_path = vim.fn.expand(''),
  --   -- },
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

