return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    { "<leader>J", function() require('treesj').toggle() end, desc = "TreesJ Split" },
  },
}
