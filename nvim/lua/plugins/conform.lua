return {
  {
    'stevearc/conform.nvim',
    opts = {
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
    },
  }
}
