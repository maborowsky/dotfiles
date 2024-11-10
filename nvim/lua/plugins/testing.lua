return {
  -----------------------------------------------------------------------------
  -- DAP ----------------------------------------------------------------------
  -----------------------------------------------------------------------------
  {
    'mfussenegger/nvim-dap',
  },
  {
    'mfussenegger/nvim-dap-python',
    config = function()
      -- loading lazily on dPt
      require("dap-python").setup("") -- TODO!

      -- TODO: move to remap.lua
      -- from: https://github.com/brunobmello25/skeleton.nvim/blob/main/lua/skeleton/plugins/dap.lua
      vim.keymap.set("n", "<F9>", '<cmd>lua require"dap".continue()<CR>', { desc = "DAP continue" })
      vim.keymap.set("n", "<F10>", '<cmd>lua require"dap".step_into()<CR>', { desc = "DAP step into" })
      vim.keymap.set("n", "<F11>", '<cmd>lua require"dap".step_over()<CR>', { desc = "DAP step over" })
      vim.keymap.set("n", "<F12>", '<cmd>lua require"dap".step_out()<CR>', { desc = "DAP step out" })

      vim.keymap.set("n", "<leader>de", '<cmd>lua require"dapui".eval()<CR>', { desc = "DAP eval" })

      vim.keymap.set(
        "n",
        "<leader>db",
        '<cmd>lua require"dap".toggle_breakpoint()<CR>',
        { desc = "DAP toggle breakpoint" }
      )
      vim.keymap.set(
        "n",
        "<leader>dc",
        '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
        { desc = "DAP set breakpoint with condition" }
      )
    end,
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
    },
  },
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  --NEOTEST--------------------------------------------------------------------
  -----------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      })
    end,
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = "" -- TODO
        }
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          -- if LazyVim.has("trouble.nvim") then
          --   require("trouble").open({ mode = "quickfix", focus = false })
          -- else
          --   vim.cmd("copen")
          -- end
          vim.cmd("copen")
        end,
      },
    },
    keys = {
      {"<leader>t", "", desc = "+test"},
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Run with DAP -- testing" },
    },
  },
  {
    "nvim-neotest/neotest-python",
  },
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
}
