return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap. when defining your own, no keybinds will be assigned automatically.
      keymap = 'default',
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      -- nerd_font_variant = 'normal',
      nerd_font_variant = 'mono',

      -- experimental auto-brackets support
      accept = { auto_brackets = { enabled = true } },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },

      windows = {
        autocomplete = { border = 'rounded' },
      }
    },
  },
  { 'hrsh7th/nvim-cmp', enabled = false },
}

-- CMP plugins
  -- -- Autocomplete and snippets
  -- { 'hrsh7th/nvim-cmp' },  -- Autocompletion plugin
  -- { 'hrsh7th/cmp-nvim-lsp' },
  -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  -- {
  --   'saadparwaiz1/cmp_luasnip',
  --   dependencies = {"rafamadriz/friendly-snippets"},
  --   build = "make install_jsregexp",
  --   config = function()
  --     require("luasnip/loaders/from_vscode").lazy_load()
  --   end
  -- },
  -- { 'L3MON4D3/LuaSnip' },  -- Snippets plugin
  -- { 'rafamadriz/friendly-snippets' },
  -- { 'hrsh7th/cmp-path' },
