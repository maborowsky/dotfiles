--@type vim.lsp.Config
return {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
        },
    },
}
