return {
  {
    enabled = false, -- trying out vigoux/notifier.nvim
    'rcarriga/nvim-notify',
    config = function ()
      require("notify").setup({
        timeout = 3000,
      })
      vim.notify = require('notify')
    end
  },
}
