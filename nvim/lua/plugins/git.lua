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
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next', { target = 'all' })
            end
          end, { desc = 'Next Git [C]hange/hunk' })

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev', { target = 'all' })
            end
          end, { desc = 'Prev Git [C]hange/hunk' })

          -- Text object
          map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })

          -- Toggles
          -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          -- map('n', '<leader>tw', gitsigns.toggle_word_diff)
        end,
      })
    end,
    keys = {
      -- Actions
      { '<leader>ghs', function() require('gitsigns').stage_hunk() end, desc = 'Stage hunk' },
      { '<leader>ghr', function() require('gitsigns').reset_hunk() end, desc = 'Reset hunk' },
      {
        '<leader>ghs',
        function()
          require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        mode = 'v',
        desc = 'Stage selection',
      },
      {
        '<leader>ghr',
        function()
          require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        mode = 'v',
        desc = 'Reset selection',
      },
      { '<leader>ghS', function() require('gitsigns').stage_buffer() end, desc = 'Stage buffer' },
      { '<leader>ghR', function() require('gitsigns').reset_buffer() end, desc = 'Reset buffer' },
      {
        '<leader>ghb',
        function() require('gitsigns').blame_line({ full = true }) end,
        desc = 'Blame line',
      },
      { '<leader>ghd', function() require('gitsigns').diffthis() end, desc = 'Diff against index' },
      {
        '<leader>ghD',
        function() require('gitsigns').diffthis('~') end,
        desc = 'Diff against last commit',
      },
      {
        '<leader>ghQ',
        function() require('gitsigns').setqflist('all') end,
        desc = 'Quickfix all hunks',
      },
      { '<leader>ghq', function() require('gitsigns').setqflist() end, desc = 'Quickfix buffer hunks' },

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
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "unified_tree",
        callback = function()
          vim.opt_local.wrap = false
        end,
      })
    end,
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
      -- kind: tab (default) | floating | split | vsplit | split_above | replace | auto
      -- Set globally via opts = { kind = "floating" }, or per-invocation: :Neogit kind=floating
      keys = {
        { "<leader>gg", "<cmd>Neogit kind=floating<cr>", desc = "Show Neogit UI" }
      },
  },

  {
    "barrettruth/diffs.nvim",
    init = function()
      vim.g.diffs = {
        integrations = {
          fugitive = true,
          neogit = true,
          neojj = false,
          gitsigns = true,
        },
      }
    end,
  },
  {
    'kokusenz/deltaview.nvim',
    opts = {},
  },
} -- end return
