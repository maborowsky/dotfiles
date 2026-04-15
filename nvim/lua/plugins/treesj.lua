return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    { "<leader>j", function() require('treesj').toggle() end, desc = "TreesJ Split" },
  },
}
