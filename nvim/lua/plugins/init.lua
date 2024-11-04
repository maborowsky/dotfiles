return {

  -- Dependencies
  { 'nvim-tree/nvim-web-devicons' },


  -- Movement
  { 'wellle/targets.vim' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },

  -- Tab, Buffer, Window management
  { 'famiu/bufdelete.nvim' },


  -- Interface
  { 'stevearc/dressing.nvim' },
  {
    -- Circles
    "projekt0n/circles.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
      require("circles").setup({
        icons = { empty = '', filled = '', lsp_prefix = '' },
        lsp = true,
      })
    end
  },
  { 'rcarriga/nvim-notify' },

  -- Misc
  { 'kshenoy/vim-signature' },
  { 'tpope/vim-sleuth' },
  { '907th/vim-auto-save' },
  -- { 'petobens/poet-v' },

  -- Python
  -- is this working well anymore?
  {
    'Vimjas/vim-python-pep8-indent',
    enabled=false,
  },
  -- {
  --   -- Auto F string
  --   "chrisgrieser/nvim-puppeteer",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- },
  {
    'AckslD/swenv.nvim',
    config = function()
      require('swenv').setup({
        -- Path passed to `get_venvs`.
        -- venvs_path = vim.fn.expand('~/venvs'),
        venvs_path = vim.fn.expand('~/workspace/maven/api/.venv'),
      })
      vim.keymap.set('n', 'fv', '<cmd>lua require(\'swenv.api\').pick_venv()<cr>', {noremap = true})
    end,
    opts = {
      venvs_path = vim.fn.expand('~/workspace/maven/api/.venv'),
    },
  },


  -- LSP
  -- config in lsp.lua
  { 'neovim/nvim-lspconfig' },
  {
  -- LSP progress bar
    enabled = false, -- trying out vigoux/notifier.nvim
    'j-hui/fidget.nvim',
    -- config = function()
    --   require('fidget').setup()
    -- end
  },

  -- Autocomplete and snippets
  -- { 'hrsh7th/nvim-cmp' },  -- Autocompletion plugin
  -- { 'hrsh7th/cmp-nvim-lsp' },
  -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  -- {
  --   'saadparwaiz1/cmp_luasnip',
  --   dependencies = {"rafamadriz/friendly-snippets"},
  --   build = "make install_jsregexp",
  --   config = function()
  --     require("luasnip/loaders/from_vscode").lazy_load()
  --   end
  -- },
  -- { 'L3MON4D3/LuaSnip' },  -- Snippets plugin
  { 'rafamadriz/friendly-snippets' },
  -- { 'hrsh7th/cmp-path' },







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

