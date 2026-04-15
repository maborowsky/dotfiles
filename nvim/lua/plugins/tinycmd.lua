return {
  {
      "rachartier/tiny-cmdline.nvim",
      config = function()
          vim.o.cmdheight = 0
          require("tiny-cmdline").setup()
      end,
  },
}
