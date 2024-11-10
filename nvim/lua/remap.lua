-------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Keymaps
-------------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- IN TESTING:
-- -----------------------------------------------------------------------------

-- Options Keybinds
local function toggle_option(option)
  if option == false then option = true else option = false end
end
vim.keymap.set("n", "<leader>oa", ":AutoSaveToggle<cr>")  -- not options i guess but it fits
-- not options i guess but it fits
-- vim.keymap.set("n", "<leader>oa",function()
--   toggle_option(vim.g.diagnostic_enable_underline)
-- end, {noremap = false})

-----------------------------------------------------------------------------
-- Cutting and pasting
-----------------------------------------------------------------------------
-- Only in visual mode
-- "_dp shifts the cursor back at the end of a line, so c -> <c-r> works better
vim.keymap.set("v", "<leader>p", "\"_c<C-r><C-o>+<Esc>")  -- only in visual mode

vim.keymap.set({"n", "v"}, "_d", "\"_d")
vim.keymap.set({"n", "v"}, "_c", "\"_c")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- Term
local relative_filepath = vim.fn.expand("%:.")
local function test_test_cmd ()
  return ":TermExec cmd='make test target=" .. relative_filepath .. "'<CR>"
end
local test_cmd = ":TermExec cmd='make test target=" .. relative_filepath .. "'<CR>"
vim.keymap.set("n", "<F5>", test_test_cmd)

-- Go To Unit test file
local unit_test_filepath = 'appointments/pytests/unit/' .. string.sub(relative_filepath, 14)
vim.keymap.set("n", "<leader>tu", function()
  vim.cmd.edit(unit_test_filepath)
end, {noremap = true})

-- Go to a file that's in the + register
vim.keymap.set("n", "g+", function()
  vim.cmd.edit(vim.fn.getreg("+"))
end, {noremap = true})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- remap jk to escape in insert mode
-- inoremap <silent> jk <Esc>
vim.keymap.set("i", "jk", "<Esc>", {noremap = true, silent = true})

vim.keymap.set("n", "<esc>", ":noh<return><esc>", {noremap = true, silent = true})

vim.keymap.set("n", "<Leader>w", ":wa<CR>", {noremap = true, desc = "Save all buffers"})

vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", {noremap = true, silent = true, desc = "Open nvim-tree"})
--nnoremap <C-f> :NvimTreeFindFile<CR>




-- Easy movement mappings
--noremap H ^
--noremap L $
-- noremap mode is 'nvo'
-- vim.keymap.set({"n", "v", "o"}, "J", "}", {noremap = true})
-- vim.keymap.set({"n", "v", "o"}, "K", "{", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "J", "6j", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "K", "6k", {noremap = true})
-- vim.keymap.set({"n", "v", "o"}, "J", "}", {})
-- vim.keymap.set({"n", "v", "o"}, "K", "{", {})

vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})

-- From vim-unimpaired: https://github.com/tpope/vim-unimpaired
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", {noremap = true})
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", {noremap = true})

vim.keymap.set("n", "<leader>G", "<cmd>G<cr>", {})
vim.keymap.set("n", "<leader>gg", "<cmd>G<cr>", {})
vim.keymap.set("n", "<leader>gt", "<cmd>tab G<cr>", {})


-- Python hosts
vim.g.python2_host_prog = 'python2'
vim.g.python3_host_prog = 'python3'


-- Telescope pickers
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local theme_dropdown = themes.get_dropdown()--{layout_config = {width = 0.8}}
local theme_ivy = themes.get_ivy()

vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<S-h>', function() builtin.buffers(theme_ivy) end, { desc = 'Telescope buffers' })
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<cr>', {noremap = true})
vim.keymap.set('n', 'fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
-- vim.keymap.set('n', '<leader>fg', function()
--   builtin.live_grep({search_dirs = { '' }})
-- end , {noremap = true})
vim.keymap.set('n', '<c-p>', function() builtin.git_files(theme_dropdown) end, {noremap = true})
-- vim.keymap.set('n', 'fa', "<cmd>lua require(\'telescope.builtin').live_grep({search_dirs = { '' }})<cr>", {noremap = true})
vim.keymap.set('n', 'fh', '<cmd>Telescope help_tags<cr>', {noremap = true})
--vim.keymap.set('n', 'ft', '<cmd>Telescope treesitter<cr>', {noremap = true})
vim.keymap.set('n', 'ft', '<cmd>Telescope<cr>', {noremap = true})
vim.keymap.set('n', 'fc', "<cmd>lua require('telescope').extensions.neoclip.default()<CR>", {noremap = true})
vim.keymap.set('n', 'fd', '<cmd>Telescope docker containers<cr>', {noremap = true})
-- vim.keymap.set('n', 'fe', '<cmd>Telescope env<cr>', {noremap = true})
vim.keymap.set('n', 'fp', '<cmd>Telescope projects<cr>', {noremap = true})
vim.keymap.set('n', 'fr', '<cmd>Telescope resume<cr>', {noremap = true})
-- vim.keymap.set('n', 'fr', '<cmd>Telescope registers<cr>', {noremap = true})
vim.keymap.set('n', 'fq', '<cmd>Telescope quickfix<cr>', {noremap = true})
vim.keymap.set('n', 'fm', '<cmd>Telescope make<cr>', {noremap = true})
vim.keymap.set('n', '<leader>m', '<cmd>Telescope marks<cr>', {noremap = true})
vim.keymap.set('n', 'fo', '<cmd>Telescope oldfiles<cr>', {noremap = true})
-- vim.keymap.set('n', '<leader>hm', '<cmd>Telescope harpoon marks<cr>', {noremap = true})
-- sort not working
-- TODO: sort a la `git branch --sort=-committerdate`
-- vim.keymap.set('n', '<leader>gb', "<cmd>:lua require'telescope.builtin'.git_branches({opts='--sort=-committerdate'})<cr>", {noremap = true})
vim.keymap.set('n', '<leader>gb', "<cmd>:lua require'telescope.builtin'.git_branches()<cr>", {noremap = true})
-- git branches --> <c-r> to rename a branch
vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_bcommits<cr>', {noremap = true})
vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>', {noremap = true})
vim.api.nvim_command('autocmd FileType TelescopePrompt imap <buffer> <C-j> <Down>')
vim.api.nvim_command('autocmd FileType TelescopePrompt imap <buffer> <C-k> <Up>')


-- Notes
function _G.noteOpen()
  local note_dir = '~/notes/tickets/'
  local git_branch = vim.trim(vim.fn.system('git branch --show-current'))
  local note_path = note_dir .. git_branch:gsub("/", "_") .. '.norg'
  vim.keymap.set('n', '<leader>;', '<cmd>e '.. note_path .. '<CR>', {noremap = true})
end
vim.api.nvim_command([[
  autocmd BufEnter * lua _G.noteOpen()
]])


-- Buffers
--   See ideas at: https://www.lazyvim.org/keymaps#bufferlinenvim
--vim.keymap.set('n', '<leader>q', "<cmd>:bdelete<cr>", {noremap = true})
vim.keymap.set('n', '<leader>q', "<cmd>:Bdelete<cr>", {noremap = true})
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
vim.keymap.set('n', '<leader>sb', '<cmd>Telescope buffers<cr>', {noremap = true})
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMoveNext<cr>', {noremap = true})
vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineMovePrev<cr>', {noremap = true})

for i = 1, 9 do
  local lhs = '<leader>' .. i
  local rhs = '<Cmd>BufferLineGoToBuffer ' .. i ..'<CR>'
  vim.keymap.set('n', lhs, rhs, {noremap = true})
end
vim.keymap.set('n', '<leader>0', '<Cmd>BufferLineGoToBuffer -1<CR>', {noremap = true})


---------------------------------
-- Term
---------------------------------

-- Maybe use <leader>t?
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

------------------------------------------------------------------
------------------------------------------------------------------



vim.keymap.set({"n", "v", "o"}, "<F1>", ":Alpha<CR>")
vim.keymap.set({"n", "v", "o"}, "<F2>", ":e $MYVIMRC<CR>")

-- Terminal
vim.keymap.set({"n", "v", "o", "t", "i"}, "<F4>", ":TermExec cmd='!!'<CR>")
vim.keymap.set({"n", "v", "o", "t", "i"}, "<F5>", ":ToggleTerm direction=horizontal<CR>")
vim.keymap.set({"n", "v", "o", "t", "i"}, "<F6>", ":ToggleTerm direction=vertical<CR>")
vim.keymap.set({"n", "v", "o"}, "<F7>", ":TermExec cmd='dklog api' name='Api Logs'<CR>")
vim.keymap.set({"n", "v", "o"}, "<F8>", ":TermExec cmd='dklog admin' name='Admin Logs'<CR>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

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
vim.keymap.set("n", "<Leader>=", "<C-w>=")
-------------------------------------------------------------------------------
