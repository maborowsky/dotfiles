local opt = vim.opt

-- " Save from insert mode
-- " inoremap :w <Esc>:w
-- " inoremap :W <Esc>:w


-- Don't show mode
-- set noshowmode

opt.showtabline = 2

opt.termguicolors = true

vim.o.cmdheight = 0
vim.o.laststatus = 3
opt.spell = true

--Decrease update time
opt.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Tabs
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = true

opt.nu = true
--vim.o.nu = 'rnu'
opt.relativenumber = true

-- Mouse support -- default 'nvi'
-- vim.o.mouse='nvi'


opt.scrolloff = 8
-- Always show at least one line left/right of the cursor.
-- set sidescrolloff=5

-- opt.colorcolumn = "88"

-- Git settings
-- default: 'internal,filler,closeoff'
vim.opt.diffopt = {'internal' ,'filler', 'closeoff', 'indent-heuristic'}


-- tab completion
vim.o.wildmode='longest:full,full'

vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true

-- vim.o.previewheight=20


-- Highlight folds
vim.wo.foldtext = 'v:lua.vim.treesitter.foldtext()'


-- Treesitter folding
vim.opt.foldmethod='expr'
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
vim.opt.foldenable = false


--  Autosave
vim.g.auto_save = 1
vim.g.auto_save_events = {"InsertLeave", "TextChanged"}

-- Diagnostics
-- vim.diagnostic.config({ virtual_text = true })
vim.diagnostic.config({
  virtual_text = true, 
  -- virtual_lines = true,
  -- virtual_lines = { current_line = true },
})

-- Python
vim.g.python_indent = {
  closed_paren_align_last_line = false,
  open_paren = "shiftwidth()",
  continue = "shiftwidth()",
  nested_paren = "shiftwidth()",
}


-- disable netrw because we are using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Terminal scrollback
vim.o.scrollback=100000
