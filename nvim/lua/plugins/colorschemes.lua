return {
  --Plug 'junegunn/seoul256.vim'
  { 'jnurmine/Zenburn' },
  { 'nightsense/snow' },
  { 'tyrannicaltoucan/vim-deep-space' },
  -- { 'ryuta69/elly.vim'
  -- { {
  --    "kyazdani42/blue-moon",
  --    config = function()
  --      vim.opt.termguicolors = true
  --      -- vim.cmd "colorscheme blue-moon"
  --    end
  -- } },
  { 'folke/tokyonight.nvim' },
  { "rose-pine/neovim", name = "rose-pine" },
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
              Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
              PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
              PmenuSbar = { bg = theme.ui.bg_m1 },
              PmenuThumb = { bg = theme.ui.bg_p2 },

              -- Popular plugins that open floats will link to NormalFloat by default;
              -- set their background accordingly if you wish to keep them dark and borderless
              LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

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
}
