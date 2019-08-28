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

" Javascript/HTML/CSS
Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript'] }

" Lisp
Plug 'junegunn/rainbow_parentheses.vim', { 'for': ['clojure', 'scheme', 'racket'] }
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme', 'racket'] }
" Plug 'tpope/vim-fireplace'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fuzzy Find
" Requires FZF to be installed via homebrew!
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Language Server
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

" Interface
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mhinz/vim-startify'
Plug 'TaDaa/vimade'
" Lightline vs Airline
Plug 'vim-airline/vim-airline'
" Plug 'itchyny/lightline.vim'
" Plug 'mengelbrecht/lightline-bufferline'

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
Plug 'tmhedberg/SimpylFold'
Plug 'janko/vim-test'

call plug#end()

" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#coc#enabled = 1
" Lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" lightline/coc
set showtabline=2
let g:lightline = {
  \     'colorscheme': 'snow_dark',
  \     'active': {
  \       'left': [ [ 'mode' ],
  \                 [ 'gitbranch', 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
  \         },
  \     'component_function': {
  \       'cocstatus': 'coc#status',
  \       'currentfunction': 'CocCurrentFunction',
  \       'gitbranch': 'fugitive#head'
  \      },
  \     'tabline': {'left': [['buffers']], 'right': [['close']]},
  \     'component_expand': {'buffers': 'lightline#bufferline#buffers'},
  \     'component_type': {'buffers': 'tabsel'},
  \ }

let g:lightline#bufferline#show_number  = 2

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
nmap g1 <Plug>lightline#bufferline#go(1)
nmap g2 <Plug>lightline#bufferline#go(2)
nmap g3 <Plug>lightline#bufferline#go(3)
nmap g4 <Plug>lightline#bufferline#go(4)
nmap g5 <Plug>lightline#bufferline#go(5)
nmap g6 <Plug>lightline#bufferline#go(6)
nmap g7 <Plug>lightline#bufferline#go(7)
nmap g8 <Plug>lightline#bufferline#go(8)
nmap g9 <Plug>lightline#bufferline#go(9)
nmap g0 <Plug>lightline#bufferline#go(10)
" lightline-bufferline
" let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
" let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
" let g:lightline.component_type   = {'buffers': 'tabsel'}

" NERDTree
map <C-e> :NERDTreeToggle<CR>
map <C-f> :NERDTreeFind<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeDirArrowExpandable="▶"
let NERDTreeDirArrowCollapsible="▼"

" FZF
nnoremap <silent> <C-p> :GFiles<CR>
" close w/ escape
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c> " Close
" prevent <C-j> and <C-k> from moving windows while fzf is up
autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>

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
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_sign_removed = '–'
let g:gitgutter_diff_args = '--ignore-space-at-eol'
nmap <silent> ]h :GitGutterNextHunk<CR>
nmap <silent> [h :GitGutterPrevHunk<CR>

" Ale
" " let g:ale_python_pycodestyle_options = '--max-line-length=120 --ignore=E121,E122,E123,E124,E126,E127,E128,E131,E201,E203,E221,E225,E226,E231,E241,E265,E302,E303,E305,E402,E501,W391,W503 --statistics pyadmin/'
" let g:ale_python_pycodestyle_options = '--max-line-length=120 --ignore=E121,E122,E123,E124,E126,E127,E128,E131,E201,E203,E221,E225,E226,E231,E241,E265,E302,E303,E305,E402,E501,W391,W503 --statistics'


" Vimade
let g:vimade = {}
let g:vimade.fadelevel = 0.83

" Neoterm
" 3<leader>tl will clear neoterm-3.
" nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
" let g:neoterm_size=100
" let g:neoterm_fixedsize=0
" let g:neoterm_eof = "\r"
let g:neoterm_autoscroll=1
let g:neoterm_keep_term_open=1

" vim-test
let test#strategy = 'neoterm'
let g:lightline#bufferline#filename_modifier = ':t'
nmap <leader>t :TestFile<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python in neovim
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Git settings
set diffopt+=indent-heuristic

" Save all buffers
nnoremap <Leader>w :wa<CR>

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

set foldmethod=manual
set foldlevelstart=99

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
autocmd FileType python nmap <F10> :exec(open(''%').read())<CR>

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

" Highlight ES6 template strings
hi link javaScriptTemplateDelim String
hi link javaScriptTemplateVar Text
hi link javaScriptTemplateString String

" Comment highlighting in json docs
autocmd FileType json syntax match Comment +\/\/.\+$+


" Coc setup ---------------------------------------------------------------
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes


" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'


" Use `[l` and `]l` to navigate diagnostics
" NOTE: currently commented out because of conflict with git
nmap <silent> [l <Plug>(coc-diagnostic-prev)
nmap <silent> ]l <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> ge <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> <leader>k :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)


" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>

" Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" -------------------------------------------------------------------------

" Buffers like tabs -------------------------------------------------------
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" Move to the next or previous buffer
nmap <leader>n :bnext<CR>
nmap <leader>b :bprevious<CR>
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>
nnoremap gb :bprev<cr>
nnoremap gn :bnext<cr>
nnoremap gj :bprev<cr>
nnoremap gk :bnext<cr>

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

" Resizing
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <Leader>= <C-w>=
"--------------------------------------------------------------------------

" Debugging ---------------------------------------------------------------
" -------------------------------------------------------------------------
