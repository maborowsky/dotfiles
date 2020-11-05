" ====================================================================
" Make sure to:
" 1. source this file somewhere at the bottom of your config.
" 2. disable any statusline plugins, as they will override this.
" ====================================================================

" Do not show mode under the statusline since the statusline itself changes
" color depending on mode
" set termguicolors
set noshowmode

set laststatus=2
" ~~~~ Statusline configuration ~~~~
" ':help statusline' is your friend!
function! RedrawModeColors(mode) " {{{
  " " Normal mode
  " if a:mode == 'n'
  "   hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
  "   hi MyStatuslineFilename ctermfg=4 cterm=none ctermbg=0
  "   hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=4
  " " Insert mode
  " elseif a:mode == 'i'
  "   hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
  "   hi MyStatuslineFilename ctermfg=1 cterm=none ctermbg=0
  "   hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=1
  " " Replace mode
  " elseif a:mode == 'R'
  "   hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
  "   hi MyStatuslineFilename ctermfg=3 cterm=none ctermbg=0
  "   hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=3
  " " Visual mode
  " elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
  "   hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
  "   hi MyStatuslineFilename ctermfg=5 cterm=none ctermbg=0
  "   hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=5
  " " Command mode
  " elseif a:mode == 'c'
  "   hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
  "   hi MyStatuslineFilename ctermfg=6 cterm=none ctermbg=0
  "   hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=6
  " " Terminal mode
  " elseif a:mode == 't'
  "   hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
  "   hi MyStatuslineFilename ctermfg=1 cterm=none ctermbg=0
  "   hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=1
  " endif
  " " Return empty string so as not to display anything in the statusline
  " return ''
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
   elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
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
    if a:modified == 1
        hi MyStatuslineModifiedBody guibg=#3B4252 cterm=bold guifg=#BF616A
    else
        hi MyStatuslineModifiedBody guibg=#3B4252 cterm=bold guifg=#4C566A
    endif
    return '●'
endfunction
" }}}
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
" set statusline+=%#MyStatuslineAccentBody#\ 
set statusline+=%#MyStatuslineAccentBody#-\ 
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
" Line and Column
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

" Setup the colors
" hi StatusLine          ctermfg=5     ctermbg=NONE     cterm=NONE
" hi StatusLineNC        ctermfg=8     ctermbg=NONE     cterm=bold

" hi MyStatuslineSeparator ctermfg=0 cterm=NONE ctermbg=NONE

" hi MyStatuslineModified ctermfg=0 cterm=NONE ctermbg=NONE

" hi MyStatuslineFiletype ctermbg=NONE cterm=NONE ctermfg=0
" hi MyStatuslineFiletypeBody ctermfg=5 cterm=italic ctermbg=0

" hi MyStatuslinePercentage ctermfg=0 cterm=NONE ctermbg=NONE
" hi MyStatuslinePercentageBody ctermbg=0 cterm=none ctermfg=6

" hi MyStatuslineLineCol ctermfg=0 cterm=NONE ctermbg=NONE
" hi MyStatuslineLineColBody ctermbg=0 cterm=none ctermfg=2
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


