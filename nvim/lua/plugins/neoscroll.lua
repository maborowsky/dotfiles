return {
  "karb94/neoscroll.nvim",
  opts = {
    duration_multiplier = 0.5,   -- Global duration multiplier
  },
  config = function()
    -- removed <c-f>, <c-b>
    require('neoscroll').setup({
      mappings = {
        '<C-u>', '<C-d>',
        '<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
      },
    })
  end
}
