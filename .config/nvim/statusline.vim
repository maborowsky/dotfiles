" ====================================================================
" Make sure to:
" 1. source this file somewhere at the bottom of your config.
" 2. disable any statusline plugins, as they will override this.
" ====================================================================
" TODO: switch insert mode color with visual

" Do not show mode under the statusline since the statusline itself changes
" color depending on mode
set noshowmode

set laststatus=2



" ~~~~ Statusline configuration ~~~~
" ':help statusline' is your friend!
" For truecolor: `https://github.com/elenapan/dotfiles/issues/85`
"                   - Follow the advice about entering '' (typed w/ <C-v><C-v>) instead of '^V'
function! RedrawModeColors(mode) " {{{
  " Normal mode
  if a:mode == 'n'
    hi MyStatuslineAccent guifg=#4C566A cterm=NONE guibg=#2E3440
    hi MyStatuslineFilename guifg=#81A1C1 cterm=none guibg=#3B4252
    hi MyStatuslineAccentBody guibg=#4C566A cterm=NONE guifg=#81A1C1
  " Insert mode
  elseif a:mode == 'i'
    hi MyStatuslineAccent guifg=#4C566A cterm=NONE guibg=#2E3440
    hi MyStatuslineFilename guifg=#BF616A cterm=none guibg=#3B4252
    hi MyStatuslineAccentBody guibg=#4C566A cterm=NONE guifg=#BF616A
  " Replace mode
  elseif a:mode == 'R'
    hi MyStatuslineAccent guifg=#4C566A cterm=NONE guibg=#2E3440
    hi MyStatuslineFilename guifg=#EBCB8B cterm=none guibg=#3B4252
    hi MyStatuslineAccentBody guibg=#4C566A cterm=NONE guifg=#EBCB8B
  " Visual mode
  elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V' || a:mode == "\<C-v>"
    hi MyStatuslineAccent guifg=#4C566A cterm=NONE guibg=#2E3440
    hi MyStatuslineFilename guifg=#B48EAD cterm=none guibg=#3B4252
    hi MyStatuslineAccentBody guibg=#4C566A cterm=NONE guifg=#B48EAD
  " Command mode
  elseif a:mode == 'c'
    hi MyStatuslineAccent guifg=#4C566A cterm=NONE guibg=#2E3440
    hi MyStatuslineFilename guifg=#88C0D0 cterm=none guibg=#3B4252
    hi MyStatuslineAccentBody guibg=#4C566A cterm=NONE guifg=#88C0D0
  " Terminal mode
  elseif a:mode == 't'
    hi MyStatuslineAccent guifg=#4C566A cterm=NONE guibg=#2E3440
    hi MyStatuslineFilename guifg=#BF616A cterm=none guibg=#3B4252
    hi MyStatuslineAccentBody guibg=#4C566A cterm=NONE guifg=#BF616A
  endif
  " Return empty string so as not to display anything in the statusline
  return ''
endfunction
" }}}

function! SetModifiedSymbol(modified) " {{{
    " TODO: currently changes color if file is modified - > change to
    " something more practical
    if a:modified == 1
        hi MyStatuslineModifiedBody guibg=#3B4252 cterm=bold guifg=#BF616A
    else
        hi MyStatuslineModifiedBody guibg=#3B4252 cterm=bold guifg=#4C566A
    endif
    return '●'
endfunction

function! SetFiletype(filetype) " {{{
  if a:filetype == ''
      return '-'
  else
      return a:filetype
  endif
endfunction
" }}}

" Statusbar items
" ====================================================================

" This will not be displayed, but the function RedrawModeColors will be
" called every time the mode changes, thus updating the colors used for the
" components.
set statusline=%{RedrawModeColors(mode())}
" Left side items
" =======================
set statusline+=%#MyStatuslineAccent#
set statusline+=%#MyStatuslineAccentBody#\ 
" Requires lightline and lightline mode_map from init.vim
" TODO: redo this w/o lightline (see line 160)
" set statusline+=%#MyStatuslineAccentBody#%{lightline#mode()}\ 
" Filename
set statusline+=%#MyStatuslineFilename#\ %.20f
set statusline+=%#MyStatuslineSeparator#\ 
" Modified status
set statusline+=%#MyStatuslineModified#
set statusline+=%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}
set statusline+=%#MyStatuslineModified#
" Right side items
" =======================
set statusline+=%=

set statusline+=%#MyStatuslineLineCol#
set statusline+=%#MyStatuslineLineColBody#
set statusline+=%(\ %{fugitive#head()}\ %)
function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
        return printf('+%d ~%d -%d', a, m, r)
    endfunction
set statusline+=\|\ %{GitStatus()}
set statusline+=\ %#MyStatuslineLineCol#

set statusline+=\ 

set statusline+=%#MyStatuslineLineCol#
set statusline+=%#MyStatuslineLineColBody#%2l
set statusline+=\/%#MyStatuslineLineColBody#%2c
set statusline+=%#MyStatuslineLineCol#
" Padding
set statusline+=\ 
" Current scroll percentage and total lines of the file
set statusline+=%#MyStatuslinePercentage#
set statusline+=%#MyStatuslinePercentageBody#%P
set statusline+=\/\%#MyStatuslinePercentageBody#%L
set statusline+=%#MyStatuslinePercentage#
" Padding
set statusline+=\ 
" Filetype
set statusline+=%#MyStatuslineFiletype#
set statusline+=%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}
set statusline+=%#MyStatuslineFiletype#

hi StatusLine          guifg=#B48EAD     guibg=#2E3440     cterm=NONE
hi StatusLineNC        guifg=#4C566A     guibg=#2E3440     cterm=bold

hi MyStatuslineSeparator guifg=#3B4252 cterm=NONE guibg=#2E3440

hi MyStatuslineModified guifg=#3B4252 cterm=NONE guibg=#2E3440

hi MyStatuslineFiletype guibg=#2E3440 cterm=NONE guifg=#3B4252
hi MyStatuslineFiletypeBody guifg=#B48EAD cterm=italic guibg=#3B4252

hi MyStatuslinePercentage guifg=#3B4252 cterm=NONE guibg=#2E3440
hi MyStatuslinePercentageBody guibg=#3B4252 cterm=none guifg=#88C0D0

hi MyStatuslineLineCol guifg=#3B4252 cterm=NONE guibg=#2E3440
hi MyStatuslineLineColBody guibg=#3B4252 cterm=none guifg=#A3BE8C













" From lightline setup, have to port

" let g:lightline.component = {
"     \ 'mode': '%{lightline#mode()}',
"     \ 'absolutepath': '%F',
"     \ 'relativepath': '%f',
"     \ 'filename': '%t',
"     \ 'modified': '%M',
"     \ 'bufnum': '%n',
"     \ 'paste': '%{&paste?"PASTE":""}',
"     \ 'readonly': '%R',
"     \ 'charvalue': '%b',
"     \ 'charvaluehex': '%B',
"     \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
"     \ 'fileformat': '%{&ff}',
"     \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
"     \ 'percent': '%3p%%',
"     \ 'percentwin': '%P',
"     \ 'spell': '%{&spell?&spelllang:""}',
"     \ 'lineinfo': '%3l:%-2v',
"     \ 'line': '%l',
"     \ 'column': '%c',
"     \ 'close': '%999X X ',
"     \ 'winnr': '%{winnr()}',
"     \ 'sep1': '-'
"     \}

" "   Only working in kitty term :(
"     " \ 'sep1': ''

" let g:lightline.mode_map = {
"     \ 'n' : 'N',
"     \ 'i' : 'I',
"     \ 'R' : 'R',
"     \ 'v' : 'V',
"     \ 'V' : 'L',
"     \ "\<C-v>": 'B',
"     \ 'c' : 'C',
"     \ 's' : 'S',
"     \ 'S' : 'S-LINE',
"     \ "\<C-s>": 'S-BLOCK',
"     \ 't': 'T',
"     \ }

