local icloud_vault = "/Users/michaelborowsky/Library/Mobile Documents/iCloud~md~obsidian/Documents/iCloud obsidian vault"
return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  -- lazy = true,
  lazy = false,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre " .. icloud_vault .. "/*.md",
  --   "BufNewFile " .. icloud_vault .. "/*.md",
  -- },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    ui = { enable = false }, -- using render-markdown.nvim instead
    workspaces = {
      {
        name = "personal",
        path = icloud_vault,
      },
    },
    templates = {
      folder = "templates",
    },
  },
  mappings = {
    -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- ["<leader>ch"] = {
    --   action = function()
    --     return require("obsidian").util.toggle_checkbox()
    --   end,
    --   opts = { buffer = true },
    -- },
    -- Toggle check-boxes.
    ["<leader>oc"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
    -- Smart action depending on context, either follow link or toggle checkbox.
    -- ["<cr>"] = {
    --   action = function()
    --     return require("obsidian").util.smart_action()
    --   end,
    --   opts = { buffer = true, expr = true },
    -- },
  },
  keys = {
    { "ot", "<cmd>ObsidianToday<cr>", desc = "[O]bsidian [T]oday" },
    { "on", "<cmd>ObsidianNew<cr>", desc = "[O]bsidian [N]ew" },
  },
}
