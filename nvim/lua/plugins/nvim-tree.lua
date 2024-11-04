return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    config = function()
      local circles = require('circles')

      local function on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', '<C-e>', '', { buffer = bufnr })
        vim.keymap.del('n', '<C-e>', { buffer = bufnr })
      end

      require'nvim-tree'.setup({
        on_attach = on_attach,
        update_cwd = true,
        renderer = {
          icons = {
            glyphs = circles.get_nvimtree_glyphs(),
          },
          highlight_opened_files = 'all', -- highlight name and icon
          add_trailing = true, -- append a trailing slash to folder names
        },
        update_focused_file = {
          update_root = {
            enable = false,
          },
          enable = true, -- do I need <c-f> with this?
          update_cwd = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
              enable = true,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
      })
    end -- end config
  },
} -- end return
