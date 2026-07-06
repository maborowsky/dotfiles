-- Formatting copied from: https://github.com/echasnovski/nvim/blob/master/plugin/10_options.lua
local opt = vim.opt


-- General ====================================================================
vim.g.mapleader = ' '
vim.o.mousescroll = 'ver:3,hor:6' -- Customize mouse scroll
vim.o.switchbuf = 'usetab'      -- Use already opened buffers when switching
vim.o.undofile = true           -- Enable persistent undo
vim.o.updatetime = 200


-- UI =========================================================================
vim.o.breakindent = false       -- Indent wrapped lines to match line start
opt.showtabline = 2
opt.termguicolors = true
vim.o.laststatus = 3
vim.o.signcolumn = 'yes'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.number = true
vim.o.relativenumber = false
-- vim.o.winborder = 'shadow'
vim.o.wrap = true
vim.o.conceallevel=1  -- Required for obsidian

-- Folds
-- https://www.reddit.com/r/neovim/comments/1t3aftx/any_good_pluginssetups_for_folds/
vim.o.foldenable = true
vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.wo.foldtext = 'v:lua.vim.treesitter.foldtext()'
vim.o.foldlevelstart = 99
vim.opt.fillchars = {
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldinner = " ",
  foldsep = " ",
}


-- Editing ====================================================================
vim.o.autoindent    = true       -- Use auto indent
vim.o.expandtab     = true       -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j'   -- Improve comment editing
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch     = true       -- Show search matches while typing
vim.o.infercase     = true       -- Infer case in built-in completion
vim.o.virtualedit   = 'block'    -- Allow going past end of line in blockwise mode
vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- Python
vim.g.python_indent = {
  closed_paren_align_last_line = false,
  open_paren = "shiftwidth()",
  continue = "shiftwidth()",
  nested_paren = "shiftwidth()",
}


-- Other ======================================================================

opt.spell = true

opt.scrolloff = 8

-- opt.colorcolumn = "88"

-- Git settings
-- default: 'internal,filler,closeoff'
vim.opt.diffopt = {'internal', 'filler', 'closeoff', 'indent-heuristic', 'algorithm:histogram', 'linematch:60'}

-- tab completion
vim.o.wildmode='longest:full,full'

-- Diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
    source = true,
  },
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
  signs = true,
  severity_sort = true,
  -- virtual_lines = { current_line = true },
  -- Don't update diagnostics when typing
  update_in_insert = false,
})

-- disable netrw because we are using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Terminal scrollback
vim.o.scrollback=100000

-- Forward BEL from :terminal jobs to the outer terminal (so ghostty's tab
-- indicator fires on Claude alerts). Default is 'all', which mutes everything;
-- list every category except 'term' so internal beeps stay silent.
vim.opt.belloff = 'backspace,cursor,complete,copy,ctrlg,error,esc,ex,hangul,insertmode,lang,mess,showmatch,operator,register,shell,spell,wildmode'
vim.opt.visualbell = false

-- Auto-reload buffers when files change on disk (e.g. Claude edits via Bash)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave" }, {
  pattern = "*",
  command = "silent! checktime",
})
