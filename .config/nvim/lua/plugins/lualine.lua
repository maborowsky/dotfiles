return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

      -- local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
      --   return function(str)
      --     local win_width = vim.fn.winwidth(0)
      --     if hide_width and win_width < hide_width then return ''
      --     elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      --        return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
      --     end
      --     return str
      --   end
      -- end
      require('lualine').setup{
        options = {
          disable_filetypes = { "toggleterm" },
          theme  = 'auto',
          -- component_separators = '|',
          -- section_separators = { left = '', right = '' },
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { {
            'mode',
            fmt = function(str) return str:sub(1,1) end,
            -- separator = { left = '' },
            -- right_padding = 2,
          } },
          lualine_b = {
            -- { 'filename', path = 1, shorting_target = 40 },
            { 'filename', path = 1 },
          },
          lualine_c = {
            {
              'branch',
              fmt = function(str)
                return string.gsub(str, "michaelborowsky/", "mb/")
              end,
            }
          },
          lualine_x = {
            -- {
            --   'tabs',
            --   tab_max_length = 40,
            --   mode = 1,
            --   path = 1,
            --   use_mode_colors = true,
            -- }
          },
          -- lualine_y = { 'filetype', 'progress' },
          lualine_y = { 'progress' },
          lualine_z = {
            {
              'location',
              -- separator = { right = '' },
              left_padding = 2,
            },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {},
      }
    end
  },
} -- end return
