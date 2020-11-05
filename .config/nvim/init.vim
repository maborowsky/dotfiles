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
" Plug 'iCyMind/NeoSolarized'
" Plug 'junegunn/seoul256.vim'
" Plug 'jnurmine/Zenburn'
Plug 'arcticicestudio/nord-vim'
Plug 'nightsense/snow'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'ryuta69/elly.vim'

" Javascript/HTML/CSS
Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript'] }

" Lisp
Plug 'junegunn/rainbow_parentheses.vim', { 'for': ['clojure', 'scheme', 'racket'] }
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme', 'racket'] }
" Plug 'tpope/vim-fireplace'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Searching
" Requires FZF to be installed via homebrew!
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Language Server
Plug 'neovim/nvim-lspconfig' " Defaults for built in lsp (neovim > 0.5)
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'


" Interface
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mhinz/vim-startify'
Plug 'TaDaa/vimade'
" Plug 'RRethy/vim-illuminate'
" nvim-web-devicons needed for barbar
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

" Movement
Plug 'junegunn/vim-slash'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Misc
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth'
Plug 'kassio/neoterm'
Plug 'junegunn/vim-peekaboo'
Plug 'janko/vim-test'
Plug '907th/vim-auto-save'

call plug#end()

" Fugitive
command! Gpushu Gpush -u origin HEAD


" NERDTree
map <C-e> :NERDTreeToggle<CR>
" map <C-f> :NERDTreeFind<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeDirArrowExpandable="▶"
let NERDTreeDirArrowCollapsible="▼"
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1


" FZF
" nnoremap <silent> <C-p> :call fzf#vim#gitfiles('', {'options': '--prompt ""'})<CR>
" nnoremap <silent> <C-i> :call fzf#vim#files('.', {'options': '--prompt ""'})<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <C-i> :Files --reverse<CR>
nnoremap <silent> <leader>i :Buffers<CR>
nnoremap <leader>rg :Rg 
let g:fzf_preview_window = 'right:40%'

" close w/ escape
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c> " Close

" prevent <C-j> and <C-k> from moving windows while fzf is up
autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>
"TODO: do the above for insert mode in terminal so you can use <C-j/k> for 

let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!migrations/**' --glob '!build/**' --glob '!.node_modules/**' --glob '!.idea'"
let $FZF_DEFAULT_OPTS=' --color=dark --margin=1,4 --reverse'
" let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:0,prompt:0,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4'
let g:fzf_layout = {'up':'40%', 'window': { 'width': 0.7, 'height': 0.7,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' }}

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


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
nmap <leader>rs <Plug>(neoterm-repl-send)
nmap <leader>rrs <Plug>(neoterm-repl-send-line)
" Send selected contents in visual mode.
xmap <leader>rs <Plug>(neoterm-repl-send)
 

" vim-test
let test#strategy = 'neoterm'
nmap <leader>t :TestFile<CR>


" Autosave
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged"]


" Treesitteer
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "python",
  highlight = { enable = true },
  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
  },
}
EOF
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


" -- Colorscheme --------------------------------
set background=dark

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

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
" colorscheme snow
" let g:airline_theme='snow_dark'

" -- Deep Space --
" colorscheme deep-space
" let g:airline_theme='deep_space'

" -- Nord --
colorscheme nord
let g:airline_theme='nord'
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

autocmd FileType javascript nmap <F9> :T npm start<CR>
autocmd FileType javascript nmap <F10> :T npm test  %<CR>
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
" Now done in barbar

" Move to the next or previous buffer
" nmap <leader>b :bprevious<CR>
" nmap <leader>n :bnext<CR>
" nmap <leader>j :bnext<CR>
" nmap <leader>k :bprev<CR>
" " nnoremap ]b :bnext<cr>
" " nnoremap [b :bprev<cr>
" nnoremap gb :bprev<cr>
" nnoremap gn :bnext<cr>
" nnoremap gj :bnext<cr>
" nnoremap gk :bprev<cr>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
" nmap <leader>q :bp <BAR> bd #<CR>

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

" barbar
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
nnoremap gb :BufferPrevious<CR>
nnoremap gn :BufferNext<CR>
nnoremap gk :BufferPrevious<CR>
nnoremap gj :BufferNext<CR>

set showtabline=2

source ~/.config/nvim/statusline.vim


" LSP
" https://nathansmith.io/posts/neovim-lsp
lua <<EOF
require'nvim_lsp'.jedi_language_server.setup{}
EOF

" lua require'nvim_lsp'.pyright.setup{}
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>


if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

