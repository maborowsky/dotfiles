return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_insalled = {
          'bash',
          'css',
          'html',
          'javascript',
          'json',
          'jsonc',
          'lua',
          'regex',
          'typescript',
          'python',
          'yaml',
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = {"python"}
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      })
    end  -- end config
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          swap = {
            enable = true,
            swap_next = {
              ["<leader>right"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>left"] = "@parameter.inner",
            },
          },
        },
      })
    end,
    -- opts = {
    --   textobjects = {
    --     swap = {
    --       enable = true,
    --       swap_next = {
    --         ["<leader>right"] = "@parameter.inner",
    --       },
    --       swap_previous = {
    --         ["<leader>left"] = "@parameter.inner",
    --       },
    --     },
    --   },
    -- },
  },
}
