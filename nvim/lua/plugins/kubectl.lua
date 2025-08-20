return {
  {
    "ramilito/kubectl.nvim",
    enabled = false,
    config = function()
      require("kubectl").setup()
    end,
  },
}
