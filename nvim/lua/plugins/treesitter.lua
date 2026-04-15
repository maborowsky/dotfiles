-- on main branch, treesitter isn't started automatically
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  callback = function(event)
    -- make sure nvim-treesitter is loaded
    local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')

    -- no nvim-treesitter, maybe fresh install
    if not ok then return end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then return end

    -- only proceed if the parser can be loaded
    if not vim.treesitter.language.add(lang) then return end

    nvim_treesitter.install({ lang }):await(function(err)
      if err then
        vim.notify('Treesitter install error for ft: ' .. ft .. ' err: ' .. err)
        return
      end

      pcall(vim.treesitter.start, event.buf)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end)
  end,
})


return {
  {
    enabled = true,
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      local ts_cfg = require("nvim-treesitter.config")

      local ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "javascript",
        "jsdoc",
        "json",
        --"jsonnet",
        -- "json5", -- https://json5.org
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "terraform",
        "tmux",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zig",
        "zsh",
      }
      local installed = ts_cfg.get_installed()
      local to_install = vim
        .iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(installed, parser)
        end)
        :totable()

      if #to_install > 0 then
        ts.install(to_install)
      end

      local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        desc = "Enable TreeSitter highlighting and indentation",
        callback = function(ev)
          local ft = ev.match
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then return end

          -- only start if the parser can be loaded (whitelist by availability)
          if not vim.treesitter.language.add(lang) then return end

          local buf = ev.buf
          pcall(vim.treesitter.start, buf, lang)

          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end, -- end config
    -- Master branch config
    -- config = function ()
    --   local configs = require("nvim-treesitter.configs")
    --   configs.setup({
    --     ensure_insalled = {
    --       'bash',
    --       'css',
    --       'html',
    --       'javascript',
    --       'json',
    --       'jsonc',
    --       'lua',
    --       'regex',
    --       'typescript',
    --       'python',
    --       'yaml',
    --     },
    --     auto_install = true,
    --     highlight = {
    --       enable = true,
    --     },
    --     indent = {
    --       enable = true,
    --       disable = {"python"}
    --     },
    --     incremental_selection = {
    --       enable = true,
    --       keymaps = {
    --         init_selection = '<CR>',
    --         scope_incremental = '<CR>',
    --         node_incremental = '<TAB>',
    --         node_decremental = '<S-TAB>',
    --       },
    --     },
    --     move = {
    --       enable = true,
    --       set_jumps = true, -- whether to set jumps in the jumplist
    --       goto_next_start = {
    --         [']m'] = '@function.outer',
    --         [']]'] = '@class.outer',
    --       },
    --       goto_next_end = {
    --         [']M'] = '@function.outer',
    --         [']['] = '@class.outer',
    --       },
    --       goto_previous_start = {
    --         ['[m'] = '@function.outer',
    --         ['[['] = '@class.outer',
    --       },
    --       goto_previous_end = {
    --         ['[M'] = '@function.outer',
    --         ['[]'] = '@class.outer',
    --       },
    --     },
    --   })
    -- end,  -- end config
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    enabled=false,
    branch = "main",
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
    keys = {
      {
        "am",
        mode = { "x", "o" },
        function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,
      },
      {
        "im",
        mode = { "x", "o" },
        function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,
      },
    },
  },
}
