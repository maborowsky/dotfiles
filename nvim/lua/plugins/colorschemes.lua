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
      -- vim.cmd("colorscheme nightfox")
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
  -- {
  --   -- In between naysayer and kanagawa
  --   -- also same backgrond as terafox
  --   'MikeWelsh801/eye-cancer',
  --   priority = 1000,
  --   dependencies = { 'rebelot/kanagawa.nvim' },
  --   config = function(colors)
  --     local c = require('eye-cancer.pallet') -- colors isn't working
  --     c.bg_brightened = "#1d2d30"
  --     require('eye-cancer').setup({
  --       brighten = false,
  --     -- vim.cmd("colorscheme eye-aids")
  --     })
  --     -- vim.cmd("colorscheme eye-cancer")
  --
  --     -- This is set up weird in https://github.com/MikeWelsh801/eye-cancer.nvim/blob/main/lua/eye-cancer/kana_setup.lua
  --     -- and is hard to overwrite.
  --     vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
  --
  --     -- I think the config of these is messing up some highlighting for snacks picker
  --     -- vim.api.nvim_set_hl(0, "NonText", { fg="#625e5a", bg=none })
  --     -- vim.api.nvim_set_hl(0, "NonText", { fg=c.blue, bg=none })
  --     vim.api.nvim_set_hl(0, "LineNr", { fg=c.dark_grey, bg=none})
  --
  --     -- Snacks picker
  --     vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg=c.blue, bg=none })
  --     vim.api.nvim_set_hl(0, "SnacksPickerBufFlags", { fg=c.dark_grey, bg=none })
  --
  --     -- trying out yellow for this
  --     vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg="#E6B800" })
  --     -- #FFD23F
  --     -- #FFCC33
  --     -- #E6B800
  --     --
  --
  --     -- Purples from chatgpt
  --     purple = "#7A5C9E"
  --     -- #8E6BAF
  --     -- #6C4F82
  --     -- maybe from kanagawa #957fb8
  --
  --     vim.api.nvim_set_hl(0, "ColorColumn", { bg=c.bg_brightened })
  --
  --     -- vim.api.nvim_set_hl(0, "MatchParen", { fg="#659099" })
  --     -- vim.api.nvim_set_hl(0, "MatchParen", { fg=purple })
  --     vim.api.nvim_set_hl(0, "MatchParen", { fg="#957fb8" })
  --   end
  -- },
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
              -- NormalFloat = { bg = "none" },
              -- FloatBorder = { bg = "none" },
              -- FloatTitle = { bg = "none" },

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
      vim.cmd("colorscheme kanagawa")
    end, -- end config
  },
  {
    "webhooked/kanso.nvim",
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
}
