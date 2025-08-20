return {
  {
    enabled=false,
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      builtin_marks = { ".", "<", ">", "^" },
    },
  },
  {
    "fnune/recall.nvim",
    enabled = false,
    version = "*",
    config = function()
      local recall = require("recall")

      recall.setup({})

      vim.keymap.set("n", "<leader>mm", recall.toggle, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>mn", recall.goto_next, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>mp", recall.goto_prev, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>mc", recall.clear, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ml", require("recall.snacks").pick, { noremap = true, silent = true })
    end,
    keys = {
      { "<leader>my", function() recall.toggle() end, desc = "testing this" },
    },
  },
}
