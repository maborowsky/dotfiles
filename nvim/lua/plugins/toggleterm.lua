return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "float" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        elseif term.direction == "horizontal" then
          return 15
        else
          return 20
        end
      end,
      open_mapping = [[<c-\>]], -- can I set option to do direction=float
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_mode = true,
      -- direction = "float",
      direction = "vertical",
      windbar = {enabled=true},
      float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'curved',
        -- like `size`, width and height can be a number or function which is passed the current terminal
        -- winblend = 3, -- this is nice but its displaying the characters below too clearly on the cursor blinks
      },
    }
  },
} -- end return
