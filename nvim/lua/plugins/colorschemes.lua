return {
  --Plug 'junegunn/seoul256.vim'
  { 'jnurmine/Zenburn' },
  { 'nightsense/snow' },
  -- { 'tyrannicaltoucan/vim-deep-space' },
  -- { 'ryuta69/elly.vim' },
  {
    "kyazdani42/blue-moon",
    config = function()
      -- vim.cmd "colorscheme blue-moon"
    end
  },
  { 'folke/tokyonight.nvim' },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      local palette = require('nightfox.palette').load('nightfox')
      require('nightfox').setup({
        options = {
          transparent = false,     -- Disable setting background
          dim_inactive = false,    -- Non focused panes set to alternative background
        },
        groups = {
          all = {
            WinSeparator    = { fg = palette.fg3, bg = "NONE" },
            InclineNormal   = { bg = palette.bg0, fg = palette.fg1 },
            InclineNormalNC = { bg = palette.bg0, fg = palette.fg3 },
            -- Floats transparent so snacks picker has no seam between border and panel.
            NormalFloat     = { bg = "NONE" },
          },
        },
      })
      vim.cmd("colorscheme nightfox")
      -- vim.cmd("colorscheme terafox")
    end,
  },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "rjshkhr/shadow.nvim",
    priority = 1000,
    config = function()
      -- vim.opt.termguicolors = true
      -- vim.cmd.colorscheme("shadow")
    end,
  },
  {
    -- Jonathan Blow's colorscheme
    'RostislavArts/naysayer.nvim',
    priority = 1000,
    lazy = false,
    -- config = function()
    --   vim.cmd.colorscheme('naysayer')
    -- end,
  },
  {
    'sainnhe/everforest',
    enabled=false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'medium'  -- soft, medium, hard
      -- vim.api.nvim_set_hl(0, "PmenuSel", {})
      -- vim.cmd("colorscheme everforest")
    end
  },
  {
    -- Lua everforest. not sure if it'll be very different
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({})
      -- vim.cmd("colorscheme everforest")
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup({
          compile = false,             -- enable compiling the colorscheme
          undercurl = true,            -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true},
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = false,         -- do not set background color
          dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = "none"
                }
              }
            }
          },
          theme = "wave",              -- Load "wave" theme when 'background' option is not set
          overrides = function(colors)
            local theme = colors.theme
            return {
              NormalFloat = { bg = "none" },
              FloatBorder = { bg = "none" },
              FloatTitle = { bg = "none" },

              -- Save an hlgroup with dark background and dimmed foreground
              -- so that you can use it where your still want darker windows.
              -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
              NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

              -- Dark completion popup menu
              -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
              -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p2 },  -- add `blend = vim.o.pumblend` to enable transparency
              -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
              -- PmenuSbar = { bg = theme.ui.bg_m1 },
              -- PmenuThumb = { bg = theme.ui.bg_p2 },

              -- Popular plugins that open floats will link to NormalFloat by default;
              -- set their background accordingly if you wish to keep them dark and borderless
              -- LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

              -- Highlight between windows
              WinSeparator = { bg = theme.ui.bg, fg = colors.palette.sumiInk6 },

              -- Mini indent
              MiniIndentscopeSymbol = {fg=colors.palette.sumiInk6},
            }
          end,
      })

      -- setup must be called before loading
      -- vim.cmd("colorscheme kanagawa")
    end, -- end config
  },
  {
    "webhooked/kanso.nvim",
    enabled=false,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("kanso-mist")  -- mist is my favorite
    -- end,
  },
  -- {
  --   "mcauley-penney/phobos-anomaly.nvim",
  --   config = function()
  --     -- vim.cmd.colorscheme("phobos-anomaly")
  --   end,
  --   priority = 1000
  -- },
  {
    dir = "~/src/eye-see.nvim",
    config = function()
      -- vim.api.nvim_set_hl(0, "@keyword.return", { fg =  })
      -- vim.cmd.colorscheme("eye-see")
    end,
    priority = 1000
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'darker'
      }
      -- require('onedark').load()
    end
  },
}
