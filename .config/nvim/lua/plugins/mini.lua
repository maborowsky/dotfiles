return {
  -- {
  --   'echasnovski/mini.nvim',
  --   version = false,
  --   config = function()
  --     require('mini.starter').setup()
  --   end,
  -- },
  -- Trying out alpha instead of starter
  -- {
  --   'echasnovski/mini.starter',
  --   version = false,
  --   config = function()
  --     require('mini.starter').setup()
  --   end,
  -- },
  -- Moving back to bufdelete, seems to work better with toggleterm, could be wrong
  -- {
  --   'echasnovski/mini.bufremove',
  --   version = false,
  --  config = function()
  --     require('mini.bufremove').setup()
  --   end,
  -- },
  {
    'echasnovski/mini.indentscope',
    version = false,
    config = function()
      require('mini.indentscope').setup()
    end,
  },
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
}
