"""""""""""""""""""""""""""""""""""""""""""""""""
" Michael Borowsky
"
" .vimrc
"
" TODO:
"       - make insert mode <C-k> like <C-j>
"       - z + j = move screen down, cursor stays the same
"           - (currently ctrl-y and ctrl-e)
"""""""""""""""""""""""""""""""""""""""""""""""""

" Space as leader
let mapleader = "\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""
" EXTENSIONS                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""
if has("win32")
    call plug#begin('~/vimfiles/bundle') " Windows
else
    call plug#begin('~/.vim/plugged')   " Linux/Mac
endif

" Colors/Themes
" Plug 'junegunn/seoul256.vim'
" Plug 'jnurmine/Zenburn'
" Plug 'arcticicestudio/nord-vim'
Plug 'shaunsingh/nord.nvim'
" Plug 'nightsense/snow'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'ryuta69/elly.vim'
Plug 'folke/tokyonight.nvim'

" Lisp
" Plug 'junegunn/rainbow_parentheses.vim', { 'for': ['clojure', 'scheme', 'racket'] }
" Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme', 'racket'] }
" Plug 'tpope/vim-fireplace'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Dependencies
Plug 'nvim-lua/plenary.nvim'  " telescope
Plug 'kyazdani42/nvim-web-devicons'  " barbar, nvim-tree, and others

" Searching
Plug 'nvim-telescope/telescope.nvim'
Plug 'AckslD/nvim-neoclip.lua'
" Plug 'lazytanuki-nvim-mapper'

" Language Server
Plug 'neovim/nvim-lspconfig' " Defaults for built in lsp (neovim > 0.5)
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': ':TSUpdate'}  " We recommend updating the parsers on update
" Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'folke/lsp-trouble.nvim'

" Completion
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/vim-vsnip-integ'
" Plug 'hrsh7th/cmp-buffer'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}



" Debugger
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'


" Interface
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'kyazdani42/nvim-tree.lua'
Plug 'mhinz/vim-startify'
Plug 'TaDaa/vimade'
" Plug 'RRethy/vim-illuminate'
Plug 'romgrk/barbar.nvim'
Plug 'datwaft/bubbly.nvim'
Plug 'projekt0n/circles.nvim'

" Movement
" Plug 'junegunn/vim-slash'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Misc
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth'
Plug 'kassio/neoterm'
" Plug 'junegunn/vim-peekaboo'
Plug 'janko/vim-test'
Plug '907th/vim-auto-save'
call plug#end()


" Fugitive
command! Gpushu Gpush -u origin HEAD


" nvim-tree
let g:nvim_tree_auto_close = 1
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
" let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }

" let g:nvim_tree_show_icons = {
"     \ 'git': 1,
"     \ 'folders': 0,
"     \ 'files': 0,
"     \ 'folder_arrows': 0,
"     \ }

" nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <C-e> :NvimTreeToggle<CR>
" nnoremap <leader>r :NvimTreeRefresh<CR>
" nnoremap <leader>n :NvimTreeFindFile<CR>
nnoremap <C-f> :NvimTreeFindFile<CR>


" startify
let g:startify_use_env = 1
let g:startify_fortune_use_unicode = 1
let g:startify_change_to_vcs_root = 0
let g:startify_change_to_dir = 0
let g:startify_list_order = [
    \ ['   Bookmarks:'],
    \ 'bookmarks',
    \ ['   Sessions'],
    \ 'sessions',
    \ ['   MRU:'],
    \ 'files',
    \ ]

let g:startify_bookmarks = [ {'v': '$MYVIMRC'} ]
if !has("win32")
    let g:startify_bookmarks += [
                \ {'z': '~/.zshrc' },
                \ {'p': '~/.zpreztorc' },
                \ {'k': '~/.config/kitty/kitty.conf' }
    \ ]
endif


" Gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_async = 1
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_sign_removed = '–'
" let g:gitgutter_diff_args = '--ignore-space-at-eol'
nmap <silent> ]h :GitGutterNextHunk<CR>
nmap <silent> [h :GitGutterPrevHunk<CR>


" Vimade
let g:vimade = {}
let g:vimade.fadelevel = 0.83
let g:vimade.enablesigns = 1
autocmd FileType NvimTree VimadeBufDisable


" Errors without these two lines
let g:vimade.normalid = ''
let g:vimade.normalncid = ''


" Neoterm
" 3<leader>tl will clear neoterm-3.
" nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
" let g:neoterm_size=100
" let g:neoterm_fixedsize=0
" let g:neoterm_eof = "\r"
let g:neoterm_autoscroll=1
let g:neoterm_keep_term_open=1

" Use gx{text-object} in normal mode
nmap <leader>rss <Plug>(neoterm-repl-send)
nmap <leader>rsp vip<Plug>(neoterm-repl-send)
nmap <leader>rsl <Plug>(neoterm-repl-send-line)
" Send selected contents in visual mode.
xmap <leader>rss <Plug>(neoterm-repl-send)
 

" vim-test
let test#strategy = 'neoterm'
nmap <leader>t :TestFile<CR>


" Autosave
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged"]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python in neovim
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Git settings
set diffopt+=indent-heuristic

" Save all buffers
nnoremap <Leader>w :wa<CR>

set nocompatible
syntax on
filetype plugin indent on

set backspace=indent,eol,start

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu

" Always show at least one line above/below the cursor.
set scrolloff=1
" Always show at least one line left/right of the cursor.
set sidescrolloff=5

set showcmd

" Treesitter folding
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" But... disable for now
set nofoldenable


" Copy/Paste
if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif



" -- Colorscheme --------------------------------
set background=dark
set termguicolors

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" -- Seoul 256 --
" let g:seoul256_background = 235 " default: 237, range: 233-239
" let g:airline_theme='zenburn'
" colorscheme seoul256

" -- Snow --
" colorscheme snow
" let g:airline_theme='snow_dark'

" -- Deep Space --
" colorscheme deep-space
" let g:airline_theme='deep_space'

" -- Nord --
" colorscheme nord

colorscheme tokyonight

" -----------------------------------------------

" tab completion
set wildmenu
set wildmode=longest:full,full

set splitright

set ignorecase
set smartcase

set previewheight=20

" 4 "space" indents
" set softtabstop=0 noexpandtab
" set shiftwidth=4
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" remap jk to escape in insert mode
inoremap <silent> jk <Esc>
nnoremap <silent><esc> :noh<return><esc>

" Save from insert mode
inoremap :w <Esc>:w
inoremap :W <Esc>:w

" show Status line
set laststatus=2

" Don't show mode
set noshowmode

" Mouse support
set mouse=a

" highlight search matches
set hlsearch

set autoread

" qq to record, Q to replay
nnoremap Q @q

map <F1> :Startify<CR>
map <F2> :e $MYVIMRC<CR>

map <F5> :T !!<CR>
map <F6> :vert Ttoggle<CR>

autocmd FileType python nmap <F9> :T ./run.py<CR>
" autocmd FileType python nmap <F10> :exec(open(''%').read())<CR>

" Easy movement mappings
"noremap H ^
"noremap L $
noremap J }
noremap K {

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dp

" terminal normal mode
:tnoremap <Esc> <C-\><C-n>

" Live substition (default in Neovim, can be installed with traces.vim)
if exists('&inccommand')
  set inccommand=split
endif

" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e

" Buffers like tabs -------------------------------------------------------
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" Show all open buffers and their status
nmap <leader>l :ls<CR>

tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-Q> :q<cr>

" Resizing
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <Leader>= <C-w>=
"--------------------------------------------------------------------------

" Debugging ---------------------------------------------------------------
" -------------------------------------------------------------------------


" Shell
set shell=/bin/zsh

" -- barbar ----------------------------
let bufferline = get(g:, 'bufferline', {})

" " Enable/disable icons
" if set to 'numbers', will show buffer index in the tabline
" if set to 'both', will show buffer index and icons in the tabline
" let bufferline.icons = v:true
let bufferline.icons = 'numbers'
" let bufferline.icons = 'both'

nmap <Leader>1 :BufferGoto 1<CR>
nmap <Leader>2 :BufferGoto 2<CR>
nmap <Leader>3 :BufferGoto 3<CR>
nmap <Leader>4 :BufferGoto 4<CR>
nmap <Leader>5 :BufferGoto 5<CR>
nmap <Leader>6 :BufferGoto 6<CR>
nmap <Leader>7 :BufferGoto 7<CR>
nmap <Leader>8 :BufferGoto 8<CR>
nmap <Leader>9 :BufferGoto 9<CR>
nmap <Leader>0 :BufferLast<CR>
nmap g1 :BufferGoto 1<CR>
nmap g2 :BufferGoto 2<CR>
nmap g3 :BufferGoto 3<CR>
nmap g4 :BufferGoto 4<CR>
nmap g5 :BufferGoto 5<CR>
nmap g6 :BufferGoto 6<CR>
nmap g7 :BufferGoto 7<CR>
nmap g8 :BufferGoto 8<CR>
nmap g9 :BufferGoto 9<CR>
nmap g0 :BufferLast<CR>

nnoremap <silent>    <leader>c :BufferClose<CR>
nnoremap <silent>    <leader>q :BufferClose<CR>

nmap <leader>b :BufferPrevious<CR>
nmap <leader>n :BufferNext<CR>
nmap <leader>k :BufferPrevious<CR>
nmap <leader>j :BufferNext<CR>


set showtabline=2

" source ~/.config/nvim/statusline.vim


" LSP
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gk    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> [d    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
" nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

"
" Completion and diagnostics

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Avoid showing message extra message when using completion
" set shortmess+=c

let g:diagnostic_enable_underline = 0






" --------------------------------------------------
" LUA -- eventuall everything will be lua
" --------------------------------------------------
lua << EOF

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


-- LSP
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  --buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  --buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  --buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  --buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
-- local servers = { "pyright"  }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup { on_attach = on_attach }
-- end
 

require'lspconfig'.pyright.setup{
  on_attach=on_attach,
  settings = {       
    python =  {         
        analysis = {           
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',         
      }       
    }     
  }
}




-- Treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    --disable = {"python"}
  }
}


-- Complete/compe/cmp
-- vim.o.completeopt = "menuone,noselect"
-- local cmp = require'cmp'
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--   },
--   sources = {
--     { name = '...' },
--     ...
--   }
-- })

local lsp = nvim_lsp
local coq = require "coq"
lsp.pyright.setup(coq.lsp_ensure_capabilities())

-- Bubbly
-- blue, should eventually revert this and set colors the right way
-- Nord colors
vim.g.bubbly_palette = {
   background = "#2e3440",
   foreground = "#4c566a",
   black = "#3e4249",
   red = "#81a1c1",
   green = "#8fbcbb",
   yellow = "#ebcb8b",
   --blue = "#81a1c1",
   blue = "#5e81ac",
   purple = "#81a1c1",
   cyan = "#81a1c1",
   --white = "#e5e9f0",
   white = "#d8dee9",
   lightgrey = "#d8dee9",
   darkgrey = "#3b4252",
}

vim.g.bubbly_tags = {
   mode = {
      normal = 'N',
      insert = 'I',
      visual = 'V',
      visualblock = 'VB',
      command = 'C',
      terminal = 'T',
      replace = 'R',
      default = '-',
   },
   paste = 'P',
   filetype = {
      noft = 'no ft',
   },
}


-- Telescope and plugins
local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
      },
    },
  }
}

-- Plugin: Neoclip
require('neoclip').setup()
require('telescope').load_extension('neoclip')

map('n', 'ff', '<cmd>Telescope find_files<cr>', {noremap = true})
map('n', 'fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
map('n', 'fb', '<cmd>Telescope buffers<cr>', {noremap = true})
map('n', 'fh', '<cmd>Telescope help_tags<cr>', {noremap = true})
map('n', 'ft', '<cmd>Telescope treesitter<cr>', {noremap = true})
map('n', 'fc', '<cmd>Telescope neoclip<cr>', {noremap = true})
vim.api.nvim_command('autocmd FileType TelescopePrompt imap <buffer> <C-j> <Down>')
vim.api.nvim_command('autocmd FileType TelescopePrompt imap <buffer> <C-k> <Up>')



-- Circles
require("circles").setup() -- doesn't work with barbar if icons are turned on

EOF
" -------------------------------------------------------
