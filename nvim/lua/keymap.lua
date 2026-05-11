-------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Keymaps
-- Ideas:
--     - sgd -- search gd -- search for the name (or references) of the function i'm currnely in using treesitter
--     - gq -> go to definition and close current buffer
-- Good bindings
--     <leader>r is open now that <leader>rn -> grn
--     - <c-n> <c-p>   -- this gets mapped with some plugins so prob not actually
--                      - might be good for scrolling in normal mode and when no popup is available
--     <leader>[ and <leader>]
-------------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- IN TESTING:
-- -----------------------------------------------------------------------------

vim.keymap.set("n", "<c-;>", "<Esc>:lua ", {noremap = true, desc = ":lua"})

-- "window" management
-- mini misc -- "zoom()" could be similiar but does it in a floating window
vim.keymap.set("n", "<leader>wf", "<cmd>tab split<cr>", {noremap = true, desc = "Tab fullscreen"}) -- fullscreen
vim.keymap.set("n", "<leader>wc", "<cmd>tabclose<cr>", {noremap = true, desc = "Tab close"})

-- TODO:
-- noremap! <c-a> <home>
-- noremap! <expr> <c-e> pumvisible() ? '<c-e>' : '<end>'

-- auto-chains
vim.keymap.set(
  "n",
  "<leader>z",
  function() require('auto-chains').set_marks() end,
  {noremap = true, desc = "auto chains"}
)

-- This was annoying me
vim.keymap.set("v", "\"*Y", "\"*y", {noremap = true, desc = "Tab close"})

-- Options Keybinds
local function toggle_option(option)
  if option == false then option = true else option = false end
end
vim.keymap.set("n", "<leader>oa", ":AutoSaveToggle<cr>")  -- not options i guess but it fits
vim.keymap.set(
  "n",
  "<leader>ou",
  function() toggle_option(vim.g.diagnostic_enable_underline) end,
  { noremap = false }
)

-----------------------------------------------------------------------------
-- Cutting and pasting
-----------------------------------------------------------------------------
-- Only in visual mode
-- "_dp shifts the cursor back at the end of a line, so c -> <c-r> works better
vim.keymap.set("v", "<leader>p", "\"_c<C-r><C-o>+<Esc>")

vim.keymap.set({"n", "v"}, "_d", "\"_d")
vim.keymap.set({"n", "v"}, "_c", "\"_c")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- Term
local relative_filepath = vim.fn.expand("%:.")
local function toggleterm_test_cmd()
  local count = vim.v.count
  -- not sure what 12 is doing at the end
  require('toggleterm').exec("bin/run-tests.sh " .. vim.fn.expand("%:."), count)
end

-- local test_cmd = ":TermExec cmd='make test target=" .. relative_filepath .. "'<CR>"
-- vim.keymap.set("n", "<F5>", test_test_cmd)
vim.keymap.set({"n", "v", "o", "t", "i"}, "<C-t>", toggleterm_test_cmd)

-- Go To Unit test file
local unit_test_filepath = 'appointments/pytests/unit/' .. string.sub(relative_filepath, 14)
vim.keymap.set("n", "<leader>tu", function()
  vim.cmd.edit(unit_test_filepath)
end, {noremap = true})

-- Go to a file that's in the + register
vim.keymap.set("n", "g+", function()
  vim.cmd.edit(vim.fn.getreg("+"))
end, {noremap = true})


-- Undotree
vim.keymap.set("n", "<leader>u", function() require("undotree").open() end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- remap jk to escape in insert mode
-- inoremap <silent> jk <Esc>
vim.keymap.set("i", "jk", "<Esc>", {noremap = true, silent = true})

vim.keymap.set("n", "<esc>", ":noh<return><esc>", {noremap = true, silent = true})

-- vim.keymap.set("n", "<Leader>w", ":wa<CR>", {noremap = true, desc = "Save all buffers"})

-- NOTE: my ideal would be to have <c-e> open to the file but also toggle
-- vim.keymap.set({"n", "i", "v"}, "<c-e>", function() require('snacks').explorer() end, {noremap = true, desc = "Snacks explorer", silent = true})
-- vim.keymap.set({"n", "i", "v"}, "<c-f>", function() require('snacks').explorer.reveal() end, {noremap = true, desc = "Snacks explorer", silent = true})
vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", {noremap = true, silent = true, desc = "Toggle nvim-tree"})
vim.keymap.set("n", "<C-f>", ":NvimTreeFindFile<CR>", {noremap = true, silent = true, desc = "Reveal current file in nvim-tree"})




-- Easy movement mappings
--noremap H ^
--noremap L $
-- noremap mode is 'nvo'
-- vim.keymap.set({"n", "v", "o"}, "J", "}", {noremap = true})
-- vim.keymap.set({"n", "v", "o"}, "K", "{", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "J", "6j", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "K", "6k", {noremap = true})
-- I've been using the above forever but <C-j>/<C-k> don't interfere with other maps so lets try
vim.keymap.set({"n", "v", "o"}, "<C-j>", "6j", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "<C-k>", "6k", {noremap = true})


-- vim.keymap.set("n", "<leader>G", "<cmd>G<cr>", {})
local _fugitive_last_press = 0
vim.keymap.set("n", "<C-g>", function()
  local now = vim.uv.now()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fugitive" then
      if (now - _fugitive_last_press) < 300 then
        vim.api.nvim_win_close(win, false)
      else
        vim.api.nvim_win_call(win, function() vim.cmd("e") end)
      end
      _fugitive_last_press = now
      return
    end
  end
  _fugitive_last_press = now
  vim.cmd("G")
end, {})
-- vim.keymap.set("n", "<leader>gg", "<cmd>G<cr>", {})
vim.keymap.set("n", "<leader>gt", "<cmd>tab G<cr>", {})


-- Python hosts
vim.g.python2_host_prog = 'python2'
vim.g.python3_host_prog = 'python3'

-- movement in cmdline
vim.keymap.set("c", "<C-a>", "<Home>", {noremap = true})
vim.keymap.set("c", "<C-e>", "<End>", {noremap = true})
-- :cnoremap <C-A> <Home>
-- :cnoremap <C-F> <Right>
-- :cnoremap <C-B> <Left>
-- :cnoremap <Esc>b <S-Left>
-- :cnoremap <Esc>f <S-Right>


-- Notes
function _G.noteOpen()
  -- TODO: change to obsidian path and note
  local note_dir = '~/notes/tickets/'
  local git_branch = vim.trim(vim.fn.system('git branch --show-current'))
  local note_path = note_dir .. git_branch:gsub("/", "_") .. '.md'
  vim.keymap.set('n', '<leader>;', '<cmd>e '.. note_path .. '<CR>', {noremap = true})
end
vim.api.nvim_command([[
  autocmd BufEnter * lua _G.noteOpen()
]])

-- Buffers
--   See ideas at: https://www.lazyvim.org/keymaps#bufferlinenvim
vim.keymap.set('n', '<leader>q', function() require('snacks').bufdelete() end, {noremap = true})
vim.keymap.set('n', '<leader>Q', "<cmd>bd<cr>", {noremap = true})
--vim.keymap.set('n', '<leader>b', "<cmd>:bprev<cr>", {noremap = true})
vim.keymap.set('n', '<leader>n', "<cmd>:bnext<cr>", {noremap = true})
vim.keymap.set('n', ']b', "<cmd>:BufferLineCycleNext<cr>", {noremap = true})
vim.keymap.set('n', '[b', "<cmd>:BufferLineCyclePrev<cr>", {noremap = true})
vim.keymap.set('n', ']n', "<cmd>:BufferLineCycleNext<cr>", {noremap = true})
vim.keymap.set('n', '[n', "<cmd>:BufferLineCyclePrev<cr>", {noremap = true})
vim.keymap.set('n', ']t', "<cmd>:tabnext<cr>", {noremap = true})
vim.keymap.set('n', '[t', "<cmd>:tabprevous<cr>", {noremap = true})
-- nmap <leader>k :BufferPrevious<CR>
-- nmap <leader>j :BufferNext<CR>
vim.keymap.set('n', '<leader>bb', "<cmd>BufferLinePick<cr>", {noremap = true})
vim.keymap.set('n', '<leader>bp', "<cmd>BufferLineTogglePin<cr>", {noremap = true})
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMoveNext<cr>', {noremap = true})
vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineMovePrev<cr>', {noremap = true})

-- Map bufferline numbers. Second param `true` is for absolute buffer num
for i = 1, 9 do
  local lhs = '<leader>' .. i
  local rhs = ':lua require("bufferline").go_to_buffer(' .. i .. ', true)<CR>'
  vim.keymap.set('n', lhs, rhs, {noremap = true})
end
vim.keymap.set('n', '<leader>0', '<Cmd>BufferLineGoToBuffer -1<CR>', {noremap = true})


---------------------------------
-- Term
---------------------------------

-- <leader>t? or <c-t>
--Set trim_spaces=false for sending to REPLs for whitespace-sensitive languages like python. (For python, you probably want to start ipython with ipython --no-autoindent.)
-- local trim_spaces = true
-- vim.keymap.set("v", "<space>s", function()
--     require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
-- end)
-- For use as an operator map:
-- Send motion to terminal
vim.keymap.set("n", [[<leader><c-\>]], function()
  set_opfunc(function(motion_type)
    require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
  end)
  vim.api.nvim_feedkeys("g@", "n", false)
end)
-- Double the command to send line to terminal
vim.keymap.set("n", [[<leader><c-\><c-\>]], function()
  set_opfunc(function(motion_type)
    require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
  end)
  vim.api.nvim_feedkeys("g@_", "n", false)
end)
-- Send whole file
--vim.keymap.set("n", [[<leader><leader><c-\>]], function()
--  set_opfunc(function(motion_type)
--    require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
--  end)
--  vim.api.nvim_feedkeys("ggg@G''", "n", false)
--end)

vim.keymap.set({"n", "v", "o", "t", "i"}, "<F4>", "<esc>:TermExec cmd='!!'<CR>")
vim.keymap.set({"n", "v", "o", "t", "i"}, "<F5>", "<esc>:ToggleTerm direction=horizontal<CR>")
vim.keymap.set({"n", "v", "o", "t", "i"}, "<F6>", "<esc>:ToggleTerm direction=float<CR>")
-- vim.keymap.set({"n", "v", "o"}, "<F7>", ":TermExec cmd='dklog api' name='Api Logs'<CR>")
-- vim.keymap.set({"n", "v", "o"}, "<F8>", ":TermExec cmd='dklog admin' name='Admin Logs'<CR>")
-- <c-\> is set in toggleterm plugin spec
-- vim.keymap.set({"n", "v", "o", "t", "i"}, "<c-/>", "<esc>:ToggleTerm direction=vertical<CR>")
-- exe v:count1 . "ToggleTerm"

vim.keymap.set({"n", "v", "o", "t"}, "<c-/>", '<Cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
vim.keymap.set("i", "<c-/>", '<Esc><Cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

------------------------------------------------------------------
------------------------------------------------------------------



-- vim.keymap.set({"n", "v", "o"}, "<F1>", ":Alpha<CR>")
vim.keymap.set({"n", "v", "o"}, "<F2>", ":e $MYVIMRC<CR>")


------------------------------------------------------------------
-- Buffers like tabs -------------------------------------------------------
------------------------------------------------------------------
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("i", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("i", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("i", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("i", "<C-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-Q>", ":q<cr>")

-- Resizing
-- NOTE: these only work for horizontal, as it's using winheight
-- NOTE: these are kinda dumb anyway
--vim.keymap.set("n", "<Leader>+", ":exe \"resize " .. (vim.fn.winheight(0) * 3/2) .. "<CR>", {silent = true})
--vim.keymap.set("n", "<Leader>-", ":exe \"resize " .. (vim.fn.winheight(0) * 2/3) .. "<CR>", {silent = true})
-- vim.keymap.set("n", "<Leader>=", "<C-w>=")
-------------------------------------------------------------------------------



------------------------------------------------------------------
-- LSP -----------------------------------------------------------
------------------------------------------------------------------
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- diagnostic on d conflicts with (eventual) debug. gotta figure out
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)

-- Default LSP rename binding is grn
-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc = "[R]e[n]ame"})

vim.keymap.set('n', 'gk', function() vim.lsp.buf.hover({ buffer = 'rounded' }) end, {desc = "Hover"})
vim.keymap.set('n', 'gK', function() vim.lsp.buf.signature_help({ buffer = 'rounded' }) end, {desc = "Signature Help"})


vim.keymap.set('n', '<leader>c', function() vim.lsp.buf.format { async = true } end, {desc = "Format"})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



------------------------------------------------------------------
-- Git -----------------------------------------------------------
------------------------------------------------------------------
-- There isn't a nice way to pass in `-s` for snacks
vim.keymap.set('n', '<leader>gu', function()
  local state = require('unified.state')
  if state.is_active() then
    require('unified.command').reset()
  else
    require('unified.command').run('-s HEAD')
  end
end, {desc = "Unified diff toggle (vs HEAD)"})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
