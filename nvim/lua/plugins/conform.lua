return {
  {
    'stevearc/conform.nvim',
    enabled = false,  -- disabled in favor of ruff lsp's built in (still mapped to <leader>c)
    opts = {
      lsp_format = 'never',
      -- Conform will run multiple formatters sequentially
      formatters_by_ft = {
        python = { "isort", "black" },
      }
    },
  }
}
