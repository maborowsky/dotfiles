return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    -- This is currently hardcoded for each lsp as we set it up
  },
}



-- old config
    -- config = function(_, opts)
    --   local lspconfig = require('lspconfig')
    --   local capabilities = require('blink.cmp').get_lsp_capabilities()
    --
    --   -- JSON (formatting by Prettier via conform)
    --   lspconfig.jsonls.setup({
    --     capabilities = capabilities,
    --   })
    --
    --   -- YAML
    --   lspconfig.yamlls.setup {
    --     capabilities = capabilities,
    --     settings = {
    --       yaml = {
    --         schemas = {
    --           -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
    --           -- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
    --           -- ["/path/from/root/of/project"] = "/.github/workflows/*",
    --         },
    --       },
    --     }
    --   }
    --
    --   -- Typescript
    --   lspconfig.ts_ls.setup{}
    --
    --   -- Python
    --   -- lspconfig.pylsp.setup({
    --   --   -- cmd = {"pylsp", "-vvv", "--log-file", "/tmp/lsp.log"},
    --   --   capabilities = capabilities,
    --   --   settings = {
    --   --     pylsp = {
    --   --       -- configuationSources = { 'flake8' },
    --   --       plugins = {
    --   --         jedi = {
    --   --           -- TODO: could be used to import pytest stuff
    --   --           -- auto_import_modules
    --   --           -- extra_paths
    --   --           follow_imports = true,
    --   --         },
    --   --         jedi_completion = {
    --   --           enabled = true,
    --   --           include_params = true,
    --   --         },
    --   --         ruff = {
    --   --           enabled = true,
    --   --         },
    --   --         flake8 = { enabled = false },
    --   --         pycodestyle = { enabled = false },
    --   --         mccabe = { enabled = false },
    --   --         pyflakes = { enabled = false },
    --   --         black = {
    --   --           enabled = true,
    --   --         },
    --   --         mypy = {
    --   --           enabled = true,
    --   --           live_mode = true,
    --   --         },
    --   --         -- pylsp_mypy = { enabled = true },
    --   --         isort = {
    --   --           enabled = true,
    --   --         },
    --   --       }
    --   --     }
    --   --   }
    --   -- })
    --
    --   -- for server, config in pairs(opts.servers) do
    --   --   -- passing config.capabilities to blink.cmp merges with the capabilities in your
    --   --   -- `opts[server].capabilities, if you've defined it
    --   --   config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
    --   --   lspconfig[server].setup(config)
    --   -- end
    -- end
