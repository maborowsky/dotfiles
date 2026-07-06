local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.hl.hl_op()
  end,
})

-- Remove trailing whitespace on save
-- augroup("TrimWhitespace", { clear = true })
-- autocmd("BufWritePre", {
--   group = "TrimWhitespace",
--   pattern = "*",
--   command = [[%s/\s\+$//e]],
-- })

-- Restore cursor position when reopening a file
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
-- Disable conceal for JSON (keep the global default, which markdown uses).
augroup("JsonNoConceal", { clear = true })
autocmd("FileType", {
  group = "JsonNoConceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Disable conceal for daily notes (raw markdown is easier to edit there).
augroup("DailyNotesNoConceal", { clear = true })
autocmd({ "BufReadPost", "BufNewFile" }, {
  group = "DailyNotesNoConceal",
  pattern = { "*/notes/daily/*.md" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- end Claude auto generated:


-- Claude Code is an Ink TUI that redraws with cursor-relative, in-place updates.
-- When a floating window (tinycmd cmdline, notifier, etc.) overlaps the terminal
-- and Claude writes output underneath, Neovim's terminal grid desyncs. :redraw!
-- can't recover it (it faithfully repaints the already-wrong grid); only an
-- app-side full repaint does. We deliver SIGWINCH to the terminal's process
-- group: Node's tty stream emits a 'resize' event, which makes Ink recalculate
-- layout and flush a fresh frame. SIGWINCH carries no input bytes, so it heals
-- the grid without the side effect of sending Ctrl-L (\012), which Claude Code
-- binds to /clear.
local uv = vim.uv or vim.loop

local function is_claude_term(buf)
  return vim.bo[buf].buftype == "terminal"
    and vim.api.nvim_buf_get_name(buf):lower():find("claude", 1, true) ~= nil
end

local function repaint_buf(buf)
  -- Bail if the buffer was wiped between scheduling and running this callback
  -- (vim.schedule defers us, so the terminal can close in the meantime).
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local job = vim.b[buf].terminal_job_id
  local ok, pid = pcall(vim.fn.jobpid, job)
  if ok and type(pid) == "number" and pid > 0 then
    -- Negative pid targets the process group, so SIGWINCH still reaches
    -- claude even if it runs under the shell that termopen spawned.
    pcall(uv.kill, -pid, "sigwinch")
  end
end

local function repaint_claude_terms()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if is_claude_term(buf) then
      repaint_buf(buf)
    end
  end
end

augroup("ClaudeRepaint", { clear = true })
-- CmdlineLeave/WinClosed: a float that overlapped the terminal is gone.
-- WinResized: opening/closing another split (e.g. a toggleterm term) changes
-- Claude's window width, which reflows the vterm grid and desyncs the alt
-- screen. Re-sending SIGWINCH after the layout settles forces a fresh frame.
autocmd({ "CmdlineLeave", "WinClosed", "WinResized", "FocusGained", "VimResized" }, {
  group = "ClaudeRepaint",
  -- Defer so the float is fully gone / the resize has settled before we
  -- ask Claude to repaint. FocusGained/VimResized: the OS window regained
  -- focus or the whole editor resized, either of which can desync the grid.
  callback = function()
    vim.schedule(repaint_claude_terms)
  end,
})

-- Entering a Claude terminal (mouse click or window navigation) can land on a
-- stale frame. Repaint just the entered buffer so plain window switches between
-- non-claude windows send no signal.
autocmd({ "WinEnter", "TermEnter" }, {
  group = "ClaudeRepaint",
  callback = function(ev)
    if is_claude_term(ev.buf) then
      vim.schedule(function() repaint_buf(ev.buf) end)
    end
  end,
})

-- Manual repaint on <C-r> from inside a Claude terminal. Buffer-local so it
-- doesn't shadow <C-r> (shell reverse-search) in non-claude terminals.
local function bind_claude_repaint(buf)
  -- Defer so the terminal buffer name is populated before we test it.
  vim.schedule(function()
    if not (vim.api.nvim_buf_is_valid(buf) and is_claude_term(buf)) then
      return
    end
    if vim.b[buf].claude_repaint_bound then
      return
    end
    vim.b[buf].claude_repaint_bound = true
    vim.keymap.set("t", "<C-r>", function()
      repaint_buf(buf)
    end, { buffer = buf, desc = "Repaint Claude terminal" })
  end)
end

-- TermOpen covers freshly spawned terminals; TermEnter/BufEnter covers
-- (re)entering a claudecode session whose buffer already existed.
autocmd({ "TermOpen", "TermEnter", "BufEnter" }, {
  group = "ClaudeRepaint",
  callback = function(args)
    bind_claude_repaint(args.buf)
  end,
})

-- Refocusing a Claude terminal: heal any grid desync that happened while a
-- float was overlapping it. Deferred so focus settles before the repaint.
autocmd({ "TermEnter", "BufEnter", "WinEnter" }, {
  group = "ClaudeRepaint",
  callback = function(args)
    local buf = args.buf
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) and is_claude_term(buf) then
        repaint_buf(buf)
      end
    end)
  end,
})



-- UI2 styling
vim.api.nvim_create_autocmd("FileType", {
	pattern = "msg",
	callback = function()
		local ui2 = require("vim._core.ui2")
		local win = ui2.wins and ui2.wins.msg
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_set_option_value(
				"winhighlight",
				"Normal:NormalFloat,FloatBorder:FloatBorder",
				{ scope = "local", win = win }
			)
		end
	end,
})

-- ui2 messages in top right
local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
	orig_set_pos(tgt)
	if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
		pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
			relative = "editor",
			anchor = "NE",
			row = 1,
			col = vim.o.columns - 1,
			border = "rounded",
		})
	end
end

