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

"""""""""""""""""""""""""""""""""""""""""""""""""
" EXTENSIONS                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""
if has("win32")
    call plug#begin('~/vimfiles/bundle') " Windows
else
    call plug#begin('~/.vim/plugged')   " Linux/Mac
endif

" Colors/Themes
Plug 'iCyMind/NeoSolarized'
Plug 'junegunn/seoul256.vim'
Plug 'jnurmine/Zenburn'
Plug 'morhetz/gruvbox'
Plug 'nightsense/snow'
Plug 'vim-airline/vim-airline-themes'

" Languages
" Plug 'sheerun/vim-polyglot'
" Plug 'guns/vim-clojure-static'
Plug 'pangloss/vim-javascript'

" Javascript/HTML/CSS
Plug 'ternjs/tern_for_vim', { 'for': ['html', 'javascript'], 'do': 'npm install' } " Requires 'npm  install' in '~/.vim/plugged/tern_for_vim'
Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript'] }
Plug 'sidorares/node-vim-debugger', { 'for': ['javascript'] }

" Lisp
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme', 'racket'] }
Plug 'tpope/vim-fireplace'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fuzzy Find
Plug 'ctrlpvim/ctrlp.vim'

" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'

" Interface
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mhinz/vim-startify'
Plug 'TaDaa/vimade'

" Movement
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Linter
Plug 'w0rp/ale'

" Misc
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth'
Plug 'kassio/neoterm'

call plug#end()


" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_smart_case = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" Deoplete jedi
" let g:deoplete#sources#jedi#show_docstring = 0
set completeopt-=preview

" NERDTree
map <C-e> :NERDTreeToggle<CR>
map <C-f> :NERDTreeFind<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeDirArrowExpandable="▶"
let NERDTreeDirArrowCollapsible="▼"

" CtrlP
nnoremap <Leader>p :CtrlP<CR>
nnoremap <Leader>o :CtrlPBuffer<CR>
nnoremap <Leader>i :CtrlPMRU<CR>
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp\|build\|coverage$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

" Easy Align (for some reason "ga" wasn't working as a bind)
xmap ga <Plug>(EasyAlign)| " Visual Mode
nmap ga <Plug>(EasyAlign)| " motion/text object

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
                \ {'z': '~/.zshrc' }
    \ ]
endif

" Gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_async = 1
set updatetime=100

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" Ale
nmap ]l :lnext<CR>
nmap [l :lprevious<CR>
let g:ale_sign_column_always = 1
let g:ale_virtualenv_dir_names = ['venv']
let g:ale_linters = { 'python': ['pycodestyle'] }
let g:ale_python_pycodestyle_options = '--max-line-length=120 --ignore=E121,E122,E123,E124,E126,E127,E128,E131,E201,E203,E221,E225,E226,E231,E241,E265,E302,E303,E305,E402,E501,W391,W503 --statistics pyadmin/'


" Vimade
" let g:VimadeFadeLevel = 0.9 " NOT WORKING, FIX
let g:vimade = {}
let g:vimade.fadelevel = 0.7

" Neoterm
" 3<leader>tl will clear neoterm-3.
" nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size=90
let g:neoterm_fixedsize=1
let g:neoterm_eof = "\r"
nnoremap <leader>t :T
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python in neovim
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Space as leader
let mapleader = "\<Space>"
nnoremap <Leader>w :wa<CR>| " Save all buffers

" Remove toolbar in gVim
set guioptions-=T

set nocompatible
syntax on
filetype plugin indent on

set backspace=indent,eol,start

set number

set showcmd

set foldmethod=syntax
set nofoldenable

" -- Colorscheme --------------------------------
set background=dark
set termguicolors

" -- Neo solarized --
" colorscheme NeoSolarized
" let g:neosolarized_contrast = "normal"
" let g:neosolarized_visibility = "normal"
" let g:neosolarized_vertSplitBgTrans = 1
" hi NERDTreeClosable guifg=gui_red ctermfg=9
" hi NERDTreeOpenable guifg=gui_orange ctermfg=9
" hi NERDTreeExecFile guifg=gui_red ctermfg=1

" -- Seoul 256 --
" let g:seoul256_background = 235 " default: 237, range: 233-239
" let g:airline_theme='zenburn'
" colorscheme seoul256

" -- Snow --
colorscheme snow
let g:airline_theme='snow_dark'
" -----------------------------------------------


" tab completion
set wildmenu
set wildmode=longest:full,full

set splitright

set ignorecase
set smartcase

filetype indent on
filetype plugin on

" 4 "space" indents
" set tabstop=4
" set softtabstop=0 noexpandtab
" set shiftwidth=4
" APPARENTLY THIS IS A THING NOW, TESTING
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" remap jk to escape in insert mode
inoremap jk <Esc>
inoremap <S-Space> <Esc>

" Save from insert mode
inoremap :w <Esc>:w
inoremap :W <Esc>:w
inoremap :x <Esc>:x

" show Status line
set laststatus=2

" Mouse support
set mouse=a

" highlight search matches
set hlsearch

map <F1> :Startify<CR>
map <F2> :e $MYVIMRC<CR>
map <F3> :TernDef<CR>

map <F5> :T !!<CR>
map <F6> :Ttoggle<CR>

autocmd FileType javascript nmap <F9> :T npm start<CR>
autocmd FileType javascript nmap <F10> :T npm test  %<CR>
autocmd FileType python nmap <F9> :T python3  %<CR>
" autocmd FileType python nmap <F10> :T python3 -i  %<CR>
autocmd FileType python nmap <F10> :exec(open(''%').read())<CR>

" Easy movement mappings
noremap H ^
noremap L $
noremap J }
noremap K {

" Move screen
nnoremap zk {zz
nnoremap zj }zz

" terminal normal mode
:tnoremap <Esc> <C-\><C-n>

" Live substition (default in Neovim, can be installed with traces.vim)
if exists('&inccommand')
  set inccommand=split
endif

" Buffers like tabs -------------------------------------------------------
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
nmap <leader>T :enew<cr>

" Move to the next or previous buffer
nmap <leader>n :bnext<CR>
nmap <leader>b :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>

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
nnoremap <C-Q> :q
"--------------------------------------------------------------------------
