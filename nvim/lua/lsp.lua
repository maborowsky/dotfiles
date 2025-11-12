-- Python
-- vim.lsp.enable('pylsp')
-- vim.lsp.enable("basedpyright")
vim.lsp.enable("ruff")
-- vim.lsp.enable("zuban")
vim.lsp.enable('ty')

-- Lua
vim.lsp.enable('lua_ls')

-- Typescript
vim.lsp.enable('ts_ls')

-- Disable go-to-definition for pylsp
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup('disable_pylsp_definition', { clear = true }),
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client.name == 'pylsp' then
--       client.server_capabilities.definitionProvider = false
--     end
--   end,
-- })
