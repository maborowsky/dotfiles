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
-- vim.keymap.set({"n", "v", "o"}, "J", "}", {noremap = true})
-- vim.keymap.set({"n", "v", "o"}, "K", "{", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "J", "6j", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "K", "6k", {noremap = true})
-- trying these out
vim.keymap.set({"n", "v", "o"}, "H", "^", {noremap = true})
vim.keymap.set({"n", "v", "o"}, "L", "$", {noremap = true})


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
-- Send motion to terminal
vim.keymap.set("n", [[<leader><c-/>]], function()
  set_opfunc(function(motion_type)
    require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
  end)
  vim.api.nvim_feedkeys("g@", "n", false)
end)
-- Double the command to send line to terminal
vim.keymap.set("n", [[<leader><c-/><c-/>]], function()
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
-- <Esc> drops to normal mode (above). To send a literal <Esc> to the program
-- in the terminal (e.g. Claude Code interrupt/clear), use <S-Esc>.
-- Requires the kitty keyboard protocol so the terminal distinguishes the two
-- (kitty/wezterm/ghostty all support it; nvim 0.10+ enables it automatically).
vim.keymap.set("t", "<S-Esc>", function()
  vim.fn.chansend(vim.b.terminal_job_id, "\27")
end, { desc = "Send <Esc> to terminal" })

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

-- Resize submode: <C-w>r, then tap h/j/k/l repeatedly; any other key exits
-- (shadows the native <C-w>r window-rotate)
vim.keymap.set("n", "<C-w>r", function()
  vim.api.nvim_echo({ { "resize: h/j/k/l (any other key exits)" } }, false, {})
  while true do
    local ok, ch = pcall(vim.fn.getcharstr)
    if not ok then break end
    -- height resizes with no window above/below spill rows into the
    -- cmdline area (cmdheight grows); pin it so tiny-cmdline's 0 survives
    local cmdheight = vim.o.cmdheight
    -- h/j/k/l drag the window's divider in that direction: grow/shrink is
    -- inverted at the right/bottom edge, where the divider is on the other side
    local win = vim.fn.winnr()
    if ch == "h" or ch == "l" then
      local grow = (ch == "l") ~= (vim.fn.winnr("l") == win)
      vim.cmd("vertical resize " .. (grow and "+3" or "-3"))
    elseif ch == "j" or ch == "k" then
      local grow = (ch == "j") ~= (vim.fn.winnr("j") == win)
      vim.cmd("resize " .. (grow and "+2" or "-2"))
    else break end
    if vim.o.cmdheight ~= cmdheight then vim.o.cmdheight = cmdheight end
    vim.cmd("redraw")
  end
  vim.api.nvim_echo({}, false, {})
end, { desc = "[R]esize windows" })

-- Percentage resizes: :Vr 30 → window takes 30% of total width, :Hr 30 → 30% of total height
vim.api.nvim_create_user_command("Vr", function(opts)
  local pct = tonumber(opts.args)
  if not pct or pct <= 0 or pct > 100 then
    print("Usage: [VerticalResize] :Vr {number (%)}")
    return
  end
  vim.cmd("vertical resize " .. math.floor(vim.o.columns * pct / 100))
end, { nargs = 1 })

vim.api.nvim_create_user_command("Hr", function(opts)
  local pct = tonumber(opts.args)
  if not pct or pct <= 0 or pct > 100 then
    print("Usage: [HorizontalResize] :Hr {number (%)}")
    return
  end
  vim.cmd("resize " .. math.floor((vim.o.lines - vim.o.cmdheight) * pct / 100))
end, { nargs = 1 })
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

vim.keymap.set(
  'n',
  '<leader>z',
  function()
    local ui = vim.api.nvim_list_uis()[1]
    local width  = math.floor(ui.width * 0.8)
    local height = math.floor(ui.height * 0.8)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width    = width,
      height   = height,
      row      = math.floor((ui.height - height) / 2),
      col      = math.floor((ui.width  - width)  / 2),
      style    = 'minimal',
      border   = 'rounded',
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.systemlist({ 'zmx', 'list' }))

    -- q to close
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true })
  end,
  { desc = "zmx list" }
)


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
