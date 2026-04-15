return {
  -- {
  --   'nvim-mini/mini.nvim',
  --   version = false,
  --   config = function()
  --     require('mini.starter').setup()
  --   end,
  -- },
  {
    'nvim-mini/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup()
    end,
    enabled = false,  -- Trying out nvim-autopairs
  },
  {
    'nvim-mini/mini.sessions',
    version = false,
    config = function()
      require('mini.sessions').setup()
    end,
  },
  { 'nvim-mini/mini.ai', version = false },
  {
    'nvim-mini/mini.misc',
    version = false,
    config = function()
      require('mini.misc').setup_termbg_sync()
    end
  },
  -- Git
  {
    'nvim-mini/mini.diff',
    enabled = false, -- using gitsigns
    opts = {
      view = {
        -- Visualization style. Possible values are 'sign' and 'number'.
        -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
        style = 'sign',
        -- Signs used for hunks with 'sign' view
        signs = { add = '┃', change = '┃', delete = '┃' },
        wrap_goto = false,
      }
    },
  },
}
