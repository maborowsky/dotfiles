return {
  {
    'b0o/incline.nvim',
    dependencies = { 'SmiteshP/nvim-navic' },
    event = 'BufReadPre',
    config = function()
      local navic = require('nvim-navic')
      navic.setup({
        highlight = false,
        separator = ' › ',
        depth_limit = 3,
        depth_limit_indicator = '…',
        icons = {
          File = ' ', Module = ' ', Namespace = ' ', Package = ' ',
          Class = ' ', Method = ' ', Property = ' ', Field = ' ',
          Constructor = ' ', Enum = ' ', Interface = ' ', Function = ' ',
          Variable = ' ', Constant = ' ', String = ' ', Number = ' ',
          Boolean = ' ', Array = ' ', Object = ' ', Key = ' ',
          Null = ' ', EnumMember = ' ', Struct = ' ', Event = ' ',
          Operator = ' ', TypeParameter = ' ',
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, args.buf)
          end
        end,
      })

      require('incline').setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          -- if filename == '' then filename = '[No Name]' end
          -- local modified = vim.bo[props.buf].modified

          -- local result = {
          --   { filename, gui = modified and 'bold,italic' or 'bold' },
          -- }
          local result = {}

          if props.focused and navic.is_available(props.buf) then
            local location = navic.get_location({}, props.buf)
            if location and location ~= '' then
              table.insert(result, { '  ', group = 'Comment' })
              table.insert(result, { location, group = 'Comment' })
            end
          end

          return result
        end,
      })
    end,
  },
}
