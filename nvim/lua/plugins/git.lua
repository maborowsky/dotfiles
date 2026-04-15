return {
  { 'https://github.com/tpope/vim-fugitive' },
  -- PR review
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      -- or "fzf-lua" or "snacks" or "default"
      picker = "snacks",
      -- bare Octo command opens picker of commands
      enable_builtin = true,
    },
    keys = {
      -- TODO: <leader>o is for options, trying <leader>O
      {
        "<leader>Ghi",
        "<CMD>Octo issue list<CR>",
        desc = "[G]it[hub] [I]ssues",
      },
      {
        "<leader>Ghp",
        "<CMD>Octo pr list<CR>",
        desc = "List [G]it[h]ub [p]ull requests",
      },
      {
        "<leader>Ghd",
        "<CMD>Octo discussion list<CR>",
        desc = "List GitHub Discussions",
      },
      {
        "<leader>Ghn",
        "<CMD>Octo notification list<CR>",
        desc = "List GitHub Notifications",
      },
      {
        "<leader>Ghs",
        function()
          require("octo.utils").create_base_search_command { include_current_repo = true }
        end,
        desc = "Search GitHub",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-telescope/telescope.nvim",
      -- OR "ibhagwan/fzf-lua",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- NOTE: also currently using mini.diff, check mini.lua
  -- Needs "libgit2" -- `brew install libgit2`
  {
    enabled = false,
    'SuperBo/fugit2.nvim',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit',
        dependencies = { 'stevearc/dressing.nvim' }
      }
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    enabled = true, -- currently trying out mini diff
    config = function()
      -- TODO: add in desc for which key
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end)

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)

          map('v', '<leader>hs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)

          map('v', '<leader>hr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)

          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hi', gitsigns.preview_hunk_inline)

          map('n', '<leader>hb', function()
            gitsigns.blame_line({ full = true })
          end)

          map('n', '<leader>hd', gitsigns.diffthis)

          map('n', '<leader>hD', function()
            gitsigns.diffthis('~')
          end)

          map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
          map('n', '<leader>hq', gitsigns.setqflist)

          -- Toggles
          -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          -- map('n', '<leader>tw', gitsigns.toggle_word_diff)

          -- Text object
          map({'o', 'x'}, 'ih', gitsigns.select_hunk)
        end
      })
    end
  },
  {
    'sindrets/diffview.nvim',
    opts = {
      hooks = {
        diff_buf_read = function(bufnr)
          -- Change local options in diff buffers
          vim.opt_local.wrap = true
        end,
      },
    },
  },

  -- Inline diffs
  {
    'axkirillov/unified.nvim',
    opts = {
      -- your configuration comes here
    }
  },

  {
      "NeogitOrg/neogit",
      lazy = true,
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required

        -- Only one of these is needed.
        "sindrets/diffview.nvim",        -- optional
        -- "esmuellert/codediff.nvim",      -- optional
      },
      cmd = "Neogit",
      keys = {
        { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
      },
  }
} -- end return
