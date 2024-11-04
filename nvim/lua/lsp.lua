-- A lot of this is from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua


-- Setup language servers.
local lspconfig = require('lspconfig')
local telescope_builtin = require('telescope.builtin')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- diagnostic on d conflicts with (eventual) debug. gotta figure out
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys after the language server
-- attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(event)
    local opts = { buffer = event.buf }
    -- Sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    --  Goto definition. To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Find references for the word under your cursor.
    map('gr', telescope_builtin.lsp_references, '[G]oto [R]eferences')

    vim.keymap.set('n', 'gt', telescope_builtin.lsp_type_definitions, opts)

    map('gk', vim.lsp.buf.hover, 'Hover')
    --vim.keymap.set('n', 'gk', vim.lsp.buf.hover, opts)

    map('gK', vim.lsp.buf.signature_help, 'Signature Help')
    --vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', telescope_builtin.lsp_implementations, '[G]oto [I]mplementation')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', telescope_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')

    -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wl', function()

    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})





----------------------------
-- Language server setup
----------------------------
local capabilities = require('blink.cmp').get_lsp_capabilities()

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
})

-- JSON (formatting by Prettier via conform)
lspconfig.jsonls.setup({
  capabilities = capabilities,
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

--------------------------------------------------------------------------------
-- PYTHON ----------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Jedi (installed via pipx)
require 'lspconfig'.jedi_language_server.setup({
  capabiliites = capabilities,
})

-- Ruff
-- https://docs.astral.sh/ruff/editors/setup/#neovim
-- NOTE: see link for logging if needed
require('lspconfig').ruff.setup({
  capabiliites = capabilities,
  init_options = {
    settings = {
      -- Ruff language server settings go here
    }
  }
})

-- Handler for both together
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

------------------------------------------------------------------------
------------------------------------------------------------------------
-- OLD stuff (in git history too but easier to see here)
------------------------------------------------------------------------
------------------------------------------------------------------------

------------------------------------------------------------------------
-- CMP -----------------------------------------------------------------
------------------------------------------------------------------------
-- nvim-cmp supports additional completion capabilities
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()



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
------------------------------------------------------------------------
------------------------------------------------------------------------



------------------------------------------------------------------------
-- Old pylsp setup -----------------------------------------------------
------------------------------------------------------------------------
-- pylsp setup
-- Change the pylsp.configurationSources setting (in the value passed in from your client) to ['flake8'] in order to use the flake8 configuration instead.
-- require 'lspconfig'.pylsp.setup({
--   --capabilities = capabilities,
--   --capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--   settings = {
--     pylsp = {
--       configuationSources = { 'flake8' },
--       plugins = {
--         jedi = {
--           -- TODO: could be used to import pytest stuff
--           -- auto_import_modules
--           -- extra_paths
--           follow_imports = true,
--         },
--         jedi_completion = {
--           enabled = true,
--           include_params = true,
--         },
--         flake8 = {
--           enabled = true,
--         },
--         pycodestyle = {
--           enabled = false,
--         },
--         mccabe = {
--           enabled = false,
--         },
--         pyflakes = {
--           enabled = false,
--         },
--         black = {
--           enabled = true,
--         },
--         mypy = {
--           enabled = true,
--           live_mode = true,
--         },
--         pylsp_mypy = { enabled = true },
--         isort = {
--           enabled = true,
--         },
--       }
--     }
--   }
-- })
------------------------------------------------------------------------
------------------------------------------------------------------------
