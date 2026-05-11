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
        "<leader>goi",
        "<CMD>Octo issue list<CR>",
        desc = "Issues",
      },
      {
        "<leader>gop",
        "<CMD>Octo pr list<CR>",
        desc = "Pull requests",
      },
      {
        "<leader>god",
        "<CMD>Octo discussion list<CR>",
        desc = "Discussions",
      },
      {
        "<leader>gon",
        "<CMD>Octo notification list<CR>",
        desc = "Notifications",
      },
      {
        "<leader>gos",
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
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- TODO: add in desc for which key
      require('gitsigns').setup({
        signs_staged_enable = true,
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
              gitsigns.nav_hunk('next', { target = 'all' })
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev', { target = 'all' })
            end
          end)

          -- Actions
          map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset hunk' })

          map('v', '<leader>ghs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Stage selection' })

          map('v', '<leader>ghr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Reset selection' })

          map('n', '<leader>ghS', gitsigns.stage_buffer,  { desc = 'Stage buffer' })
          map('n', '<leader>ghR', gitsigns.reset_buffer,  { desc = 'Reset buffer' })

          map('n', '<leader>ghb', function()
            gitsigns.blame_line({ full = true })
          end, { desc = 'Blame line' })

          map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Diff against index' })

          map('n', '<leader>ghD', function()
            gitsigns.diffthis('~')
          end, { desc = 'Diff against last commit' })

          map('n', '<leader>ghQ', function() gitsigns.setqflist('all') end, { desc = 'Quickfix all hunks' })
          map('n', '<leader>ghq', gitsigns.setqflist, { desc = 'Quickfix buffer hunks' })

          -- Toggles
          -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          -- map('n', '<leader>tw', gitsigns.toggle_word_diff)

          -- Text object
          map({'o', 'x'}, 'ih', gitsigns.select_hunk)
        end
      })
    end,
    keys = {
      {
        '<leader>ghp',
        function() require('gitsigns').preview_hunk() end,
        desc = "Preview hunk",
      },
      {
        '<leader>ghi',
        function() require('gitsigns').preview_hunk_inline() end,
        desc = "Preview hunk inline",
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    enabled=false,
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
      file_tree = {
        width = 0.3, -- Width of the file tree window
        filename_first = true, -- Show filename before directory path (Snacks backend only)
      },
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
