return {
  {
    "ibhagwan/fzf-lua",
    enabled=false,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {
      defaults = {
        formatter = "path.filename_first",
      },
    },
    ---@diagnostic enable: missing-fields
  },
}
