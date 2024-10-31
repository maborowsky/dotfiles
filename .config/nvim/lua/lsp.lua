-- -- from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- -- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- -- LSP settings
-- local lspconfig = require 'lspconfig'
-- local on_attach = function(_, bufnr)
--   local opts = { buffer = bufnr }
--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--   -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--   -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--   vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
--   vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
--   vim.keymap.set('n', '<leader>wl', function()
--     vim.inspect(vim.lsp.buf.list_workspace_folders())
--   end, opts)
--   vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
--   vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--   vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--   vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
--   vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
--   vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
-- end




-- Setup language servers.
local lspconfig = require('lspconfig')
local builtin = require('telescope.builtin')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- diagnostic on d/e conflicts with (eventual) debug. gotta figure out
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
    -- vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions({ jump_type = "never" }), opts) -- not working for some reason
    vim.keymap.set('n', '<leader>gd', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="never"})<CR>',
      opts)

    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
    vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    vim.keymap.set('n', 'gk', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})






-- nvim-cmp supports additional completion capabilities
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  -- capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- pylsp setup
-- Change the pylsp.configurationSources setting (in the value passed in from your client) to ['flake8'] in order to use the flake8 configuration instead.
require 'lspconfig'.pylsp.setup({
  --capabilities = capabilities,
  --capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
    pylsp = {
      configuationSources = { 'flake8' },
      plugins = {
        jedi = {
          -- TODO: could be used to import pytest stuff
          -- auto_import_modules
          -- extra_paths
          follow_imports = true,
        },
        jedi_completion = {
          enabled = true,
          include_params = true,
        },
        flake8 = {
          enabled = true,
        },
        pycodestyle = {
          enabled = false,
        },
        mccabe = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
        black = {
          enabled = true,
        },
        mypy = {
          enabled = true,
          live_mode = true,
        },
        pylsp_mypy = { enabled = true },
        isort = {
          enabled = true,
        },
      }
    }
  }
})


-- YAML
require('lspconfig').yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        -- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
        -- ["/path/from/root/of/project"] = "/.github/workflows/*",
      },
    },
  }
}


-- luasnip setup
-- local has_words_before = function()
--   unpack = unpack or table.unpack
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

-- local luasnip = require("luasnip")
-- local cmp = require("cmp")
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = cmp.mapping.preset.insert({
--   ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--   ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--   ['<C-e>'] = cmp.mapping.abort(),
--   ['<C-y>'] = cmp.mapping.confirm({ select = false }),
--   ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--   ['<C-f>'] = cmp.mapping.scroll_docs(4),
--   ['<C-Space>'] = cmp.mapping.complete(),
--   ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--   -- Tab from: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
--   -- ["<Tab>"] = cmp.mapping(function(fallback)
--   --   if cmp.visible() then
--   --     cmp.select_next_item()
--   --   -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
--   --   -- that way you will only jump inside the snippet region
--   --   elseif luasnip.expand_or_jumpable() then
--   --     luasnip.expand_or_jump()
--   --   elseif has_words_before() then
--   --     cmp.complete()
--   --   else
--   --     fallback()
--   --   end
--   -- end, { "i", "s" }),
--   -- ["<S-Tab>"] = cmp.mapping(function(fallback)
--   --   if cmp.visible() then
--   --     cmp.select_prev_item()
--   --   elseif luasnip.jumpable(-1) then
--   --     luasnip.jump(-1)
--   --   else
--   --     fallback()
--   --   end
--   -- end, { "i", "s" }),
-- })

-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp_mappings,
--   preselect = cmp.PreselectMode.None,
--   sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       { name = 'luasnip' },
--       { name = 'nvim_lsp_signature_help' },
--     },
--     {
--       { name = 'buffer' },
--     }),
--   window = {
--     -- completion = cmp.config.window.bordered(),
--     documentation = cmp.config.window.bordered(),
--   }
-- })
