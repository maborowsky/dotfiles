return {
    {
        "nvim-neorg/neorg",
        dependencies = { "luarocks.nvim" },
        lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*",
        config = true,
        opts = {
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        },
    },
}
