return {
  enabled=false,
  "karb94/neoscroll.nvim",
  opts = {
    duration_multiplier = 0.1,   -- Global duration multiplier
  },
  config = function()
    -- removed <c-f>, <c-b>
    require('neoscroll').setup({
      mappings = {
        '<C-u>', '<C-d>',
        'zt', 'zz', 'zb',
        -- '<C-y>', '<C-e>',
      },
    })
  end
}
