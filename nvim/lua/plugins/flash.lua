return {
  {
    "folke/flash.nvim",
    enabled = true,
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
        },
      },
      highlight = {
        backdrop = true,
      },
    },
    -- init = function()
    --   -- FlashBackdrop links to Comment by default, which barely dims in most
    --   -- themes. Instead, take Normal's fg and blend it toward the background
    --   -- so non-matched text fades (leap-style). Reapply on theme switch.
    --   local DIM = 0.65 -- fraction blended toward bg: higher = more dimmed
    --
    --   local function blend(fg, bg, amount)
    --     local function split(c) return { (c >> 16) & 0xff, (c >> 8) & 0xff, c & 0xff } end
    --     fg, bg = split(fg), split(bg)
    --     local r = math.floor(fg[1] * (1 - amount) + bg[1] * amount + 0.5)
    --     local g = math.floor(fg[2] * (1 - amount) + bg[2] * amount + 0.5)
    --     local b = math.floor(fg[3] * (1 - amount) + bg[3] * amount + 0.5)
    --     return string.format("#%02x%02x%02x", r, g, b)
    --   end
    --
    --   local function set_backdrop()
    --     local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    --     if not (normal.fg and normal.bg) then return end
    --     vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = blend(normal.fg, normal.bg, DIM) })
    --   end
    --   vim.api.nvim_create_autocmd("ColorScheme", { callback = set_backdrop })
    --   set_backdrop()
    -- end,
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- <c-s> to change toggle when searching (or typing a command lol)
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  }
}
