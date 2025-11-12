return {
  {
    "zerochae/endpoint.nvim",
    dependencies = {
      -- Choose one or more pickers (all optional):
      -- "nvim-telescope/telescope.nvim", -- For telescope picker
      "folke/snacks.nvim",            -- For snacks picker
      -- "stevearc/dressing.nvim",       -- Enhances vim.ui.select with telescope backend
      -- vim.ui.select picker works without dependencies
    },
    cmd = { "Endpoint", "EndpointRefresh" },
    config = function()
      require("endpoint").setup()
    end,
  }
}
