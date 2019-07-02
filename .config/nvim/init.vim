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
Plug 'iCyMind/NeoSolarized'
Plug 'junegunn/seoul256.vim'
Plug 'jnurmine/Zenburn'
Plug 'nightsense/snow'
Plug 'vim-airline/vim-airline-themes'

" Languages
Plug 'pangloss/vim-javascript'

" Javascript/HTML/CSS
Plug 'ternjs/tern_for_vim', { 'for': ['html', 'javascript'], 'do': 'npm install' } " Requires 'npm  install' in '~/.vim/plugged/tern_for_vim'
Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript'] }
Plug 'sidorares/node-vim-debugger', { 'for': ['javascript'] }

" Lisp
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme', 'racket'] }
" Plug 'tpope/vim-fireplace'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fuzzy Find
Plug 'ctrlpvim/ctrlp.vim'

" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Python
Plug 'deoplete-plugins/deoplete-jedi', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}


" Debugging
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'idanarye/vim-vebugger'

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
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
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

" vim-jedi
let g:jedi#completions_enabled = 0
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "<leader>k"
let g:jedi#usages_command = "<leader>u"

" Neosnippet
let g:neosnippet#enable_completed_snippet = 1
imap <C-s>     <Plug>(neosnippet_expand_or_jump)
smap <C-s>     <Plug>(neosnippet_expand_or_jump)
xmap <C-s>     <Plug>(neosnippet_expand_target)
" SuperTab like snippets' behavior.
imap <expr><TAB>
\ pumvisible() ? "\<C-n>" :
\ neosnippet#expandable_or_jumpable() ?
\   "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
\ 
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Vebugger
let g:vebugger_leader='<Leader>d'

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
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp\|build\|coverage\|__pycache__$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$\|.pyc$'
  \ }

" Easy Align
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
set updatetime=200

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" Ale
nmap ]l :lnext<CR>
nmap [l :lprevious<CR>
let g:ale_sign_column_always = 1
let g:ale_virtualenv_dir_names = ['venv']
let g:ale_linters = { 'python': ['pycodestyle'] }
" let g:ale_python_pycodestyle_options = '--max-line-length=120 --ignore=E121,E122,E123,E124,E126,E127,E128,E131,E201,E203,E221,E225,E226,E231,E241,E265,E302,E303,E305,E402,E501,W391,W503 --statistics pyadmin/'
let g:ale_python_pycodestyle_options = '--max-line-length=120 --ignore=E121,E122,E123,E124,E126,E127,E128,E131,E201,E203,E221,E225,E226,E231,E241,E265,E302,E303,E305,E402,E501,W391,W503 --statistics'


" Vimade
let g:vimade = {}
let g:vimade.fadelevel = 0.83

" Neoterm
" 3<leader>tl will clear neoterm-3.
" nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size=100
let g:neoterm_fixedsize=1
" let g:neoterm_eof = "\r"
let g:neoterm_autoscroll=1
nnoremap <leader>t :T
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python in neovim
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

nnoremap <Leader>w :wa<CR>| " Save all buffers

" Remove toolbar in gVim
set guioptions-=T

set nocompatible
syntax on
filetype plugin indent on

set backspace=indent,eol,start

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu

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

set previewheight=20

" 4 "space" indents
" set tabstop=4
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
inoremap jk <Esc>
inoremap <S-Space> <Esc>

" Save from insert mode
inoremap :w <Esc>:w
inoremap :W <Esc>:w

" show Status line
set laststatus=2

" Mouse support
set mouse=a

" highlight search matches
set hlsearch

set autoread

map <F1> :Startify<CR>
map <F2> :e $MYVIMRC<CR>
map <F3> :TernDef<CR>

map <F5> :T !!<CR>
map <F6> :Ttoggle<CR>

autocmd FileType javascript nmap <F9> :T npm start<CR>
autocmd FileType javascript nmap <F10> :T npm test  %<CR>
autocmd FileType python nmap <F9> :T ./run.py<CR>
autocmd FileType python nmap <F10> :exec(open(''%').read())<CR>

" Easy movement mappings
"noremap H ^
"noremap L $
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

" Highlight ES6 template strings
hi link javaScriptTemplateDelim String
hi link javaScriptTemplateVar Text
hi link javaScriptTemplateString String

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

