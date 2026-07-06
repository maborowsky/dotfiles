-- Status column markers for the lines <C-d>/<C-u> would jump to: an arrow
-- in the padding space after the line number (so the column keeps its
-- width) plus a slightly emphasized line number. Approximate when closed
-- folds sit between the cursor and the target (<C-d>/<C-u> count a closed
-- fold as one line).
-- Global function: 'statuscolumn' evaluates it via v:lua on every redraw.
_G.ScrollMarker = function()
  local lnum, cur, scroll = vim.v.lnum, vim.fn.line('.'), vim.wo.scroll
  if lnum ~= cur and lnum == math.min(cur + scroll, vim.fn.line('$')) then
    return '%#ScrollTargetNr#%l%#ScrollTarget#↓%*'
  elseif lnum ~= cur and lnum == math.max(cur - scroll, 1) then
    return '%#ScrollTargetNr#%l%#ScrollTarget#↑%*'
  end
  return '%l '
end

vim.api.nvim_set_hl(0, 'ScrollTarget', { link = 'Special' })
-- LineNr + bold: subtle emphasis that follows the colorscheme (safe to
-- resolve here: plugin/ files are sourced after init.lua, i.e. after the
-- colorscheme has loaded)
local linenr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })
vim.api.nvim_set_hl(0, 'ScrollTargetNr', vim.tbl_extend('force', linenr, { bold = true }))

vim.o.statuscolumn = '%s%=%{%v:lua.ScrollMarker()%}'
