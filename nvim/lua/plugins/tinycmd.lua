return {
  {
      "rachartier/tiny-cmdline.nvim",
      config = function()
          vim.o.cmdheight = 0
          require("tiny-cmdline").setup()

          vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { bg = "none" })
          vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { fg = "none" })
      end,
  },
}
