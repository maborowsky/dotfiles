return {
  -- {
  --   'echasnovski/mini.nvim',
  --   version = false,
  --   config = function()
  --     require('mini.starter').setup()
  --   end,
  -- },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup()
    end,
    enabled = false,  -- Trying out nvim-autopairs
  },
  {
    'echasnovski/mini.sessions',
    version = false,
    config = function()
      require('mini.sessions').setup()
    end,
  },
  { 'echasnovski/mini.ai', version = false },
  {
    'echasnovski/mini.misc',
    version = false,
    config = function()
      require('mini.misc').setup_termbg_sync()
    end
  },
}
