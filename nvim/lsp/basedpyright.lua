--@type vim.lsp.Config
return {
    settings = {
        basedpyright = {
            analysis = {
                autoFormatStrings = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",  -- "off", "basic", "standard", "strict", "recommended", "all"
                -- include = {"~/src/torchweb/tests/conftest.py"},
            },
            python = {
                venvPath = "~/src/torchweb/venv-dev/",
            }
        }
    }
}
