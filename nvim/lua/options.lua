-- " Save from insert mode
-- " inoremap :w <Esc>:w
-- " inoremap :W <Esc>:w


-- Don't show mode
-- set noshowmode


vim.opt.showtabline = 2


-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.nu = true
--vim.o.nu = 'rnu'
vim.opt.relativenumber = true

-- Mouse support -- default 'nvi'
-- vim.o.mouse='nvi'


vim.opt.scrolloff = 8
-- Always show at least one line left/right of the cursor.
-- set sidescrolloff=5

vim.o.colorcolumn = "88"

-- Git settings
-- default: 'internal,filler,closeoff'
vim.opt.diffopt = {'internal' ,'filler', 'closeoff', 'indent-heuristic'}


-- tab completion
vim.o.wildmode='longest:full,full'

vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.previewheight=20


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
vim.diagnostic.config({ virtual_text = true })
