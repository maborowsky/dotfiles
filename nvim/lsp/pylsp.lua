--@type vim.lsp.Config
return {
  cmd = {"pylsp"},
  settings = {
    pylsp = {
      -- configuationSources = { 'flake8' },
      plugins = {
        rope_autoimport = {
          enabled = false,
          completions = { enabled = false, },
          code_actions = { enabled = false, },
        },
        jedi = {
          -- TODO: could be used to import pytest stuff
          -- auto_import_modules
          -- extra_paths
          follow_imports = true,
        },
        jedi_completion = {
          enabled = true,
          include_params = false,
          cache_for = {"langchain", "langchain-core", "torchweb.app.core.dbtypes_v2", "black", "chardet", "numpy"},
          resolve_at_most = 25,
        },
        jedi_symbols = {
          enabled = true,
          include_import_symbols = false
        },
        jedi_type_definition = {
          enabled = true,
        },
        preload = {
          modules = {"langchain", "langchain-core", "torchweb.app.core.dbtypes_v2", "black", "chardet", "numpy"}
        },
        ruff = {
          enabled = true,
        },
        flake8 = { enabled = false },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
        black = {
          enabled = true,
        },
        pylsp_mypy = {
          enabled = true,
          live_mode = false,
          -- doesn't work with live_mode rn: https://github.com/python-lsp/pylsp-mypy
          ["follow-imports"] = "normal",  -- can't be silent w/ dmypy
          -- mypy_command = '/Users/michaelborowsky/src/torchweb/venv-dev/bin/mypy'
          -- mypy_command = '/Users/michaelborowsky/.asdf/shims/mypy'
        },
        -- isort = {
        --   enabled = true,
        -- },
      }
    }
  }
}
