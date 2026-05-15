return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options ={
        -- diagnostics = "nvim_lsp",
        -- --- count is an integer representing total count of errors
        -- --- level is a string "error" | "warning"
        -- --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
        -- --- this should return a string
        -- --- Don't get too fancy as this function will be executed a lot
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --   local icon = level:match("error") and " " or " "
        --   return " " .. icon .. count
        -- end,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        show_duplicate_prefix = true,
        -- numbers = "ordinal",
        numbers = function(opts)
          return string.format('%s', opts.raise(opts.ordinal))
        end,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        -- highlights = {
        --   buffer_selected = {
        --       bg = palette.bg3,
        --   },
        -- },
        offsets = {
          {
            filetype = "nvim-tree",
            text = "nvim-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_picker_list",
            text = "Snacks picker list",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    }
  }
}

