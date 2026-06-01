return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "helix",  -- classic, modern, or helix
      defaults = {
        -- Most <leader>f/<leader>s/<leader>g bindings live in plugins/snacks.lua keys = {}
        ["<leader>b"] = { name = "+buffers" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+find (files/buffers)" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>go"] = { name = "+github (octo)" },
        ["<leader>s"] = { name = "+search (grep/symbols/vim state)" },
      },
  },
}
}
