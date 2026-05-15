-- Tree-style buffer history. Tracks which buffer "opened" which.
--
-- Usage:
--   require('buftree').setup()
--   :lua require('buftree').toggle()

local M = {}

M.nodes = {}      -- [bufnr] = { parent, children, name, alive }
M.roots = {}      -- ordered list of root bufnrs
M.last_normal = nil  -- last normal buffer entered, used when current is e.g. a picker

local function is_normal(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return false end
  local bt = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
  return bt == ''
end

local function display_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then return '[No Name #' .. bufnr .. ']' end
  return vim.fn.fnamemodify(name, ':~:.')
end

local function ensure_node(bufnr)
  if M.nodes[bufnr] then return M.nodes[bufnr] end
  M.nodes[bufnr] = {
    parent = nil,
    children = {},
    name = display_name(bufnr),
    alive = vim.api.nvim_buf_is_valid(bufnr),
  }
  return M.nodes[bufnr]
end

local function record_add(bufnr)
  if M.nodes[bufnr] then return end  -- already tracked

  local cur = vim.api.nvim_get_current_buf()
  local parent
  if cur ~= bufnr and is_normal(cur) then
    parent = cur
  elseif M.last_normal and M.last_normal ~= bufnr and vim.api.nvim_buf_is_valid(M.last_normal) then
    parent = M.last_normal
  end

  local node = ensure_node(bufnr)
  node.parent = parent
  if parent then
    local p = ensure_node(parent)
    table.insert(p.children, bufnr)
  else
    table.insert(M.roots, bufnr)
  end
end

local function record_delete(bufnr)
  local node = M.nodes[bufnr]
  if not node then return end
  node.alive = false
  -- keep structure; user can prune with 'x'
end

-- ---------- Rendering ----------

local TREE_BUF = nil
local TREE_WIN = nil
M.line_to_buf = {}

local function render_node(bufnr, depth, lines, visited)
  if visited[bufnr] then return end  -- guard against cycles
  visited[bufnr] = true

  local node = M.nodes[bufnr]
  if not node then return end

  local prefix = string.rep('  ', depth)
  local marker = node.alive and '●' or '○'
  local current = (bufnr == vim.api.nvim_get_current_buf()) and ' ◀' or ''
  table.insert(lines, prefix .. marker .. ' ' .. node.name .. current)
  table.insert(M.line_to_buf, bufnr)

  for _, child in ipairs(node.children) do
    render_node(child, depth + 1, lines, visited)
  end
end

local function render()
  if not TREE_BUF or not vim.api.nvim_buf_is_valid(TREE_BUF) then return end
  local lines = {}
  M.line_to_buf = {}
  local visited = {}
  for _, root in ipairs(M.roots) do
    render_node(root, 0, lines, visited)
  end
  if #lines == 0 then lines = { '(no buffers tracked yet)' } end

  vim.api.nvim_set_option_value('modifiable', true, { buf = TREE_BUF })
  vim.api.nvim_buf_set_lines(TREE_BUF, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = TREE_BUF })
end

local function buf_under_cursor()
  if not TREE_WIN or not vim.api.nvim_win_is_valid(TREE_WIN) then return nil end
  local row = vim.api.nvim_win_get_cursor(TREE_WIN)[1]
  return M.line_to_buf[row]
end

local function prune(bufnr)
  local node = M.nodes[bufnr]
  if not node then return end
  for _, child in ipairs(node.children) do prune(child) end
  if node.parent and M.nodes[node.parent] then
    local siblings = M.nodes[node.parent].children
    for i, b in ipairs(siblings) do
      if b == bufnr then table.remove(siblings, i); break end
    end
  else
    for i, b in ipairs(M.roots) do
      if b == bufnr then table.remove(M.roots, i); break end
    end
  end
  M.nodes[bufnr] = nil
end

function M.open()
  if TREE_WIN and vim.api.nvim_win_is_valid(TREE_WIN) then
    vim.api.nvim_set_current_win(TREE_WIN)
    return
  end

  vim.cmd('topleft 40vsplit')
  TREE_WIN = vim.api.nvim_get_current_win()

  if not TREE_BUF or not vim.api.nvim_buf_is_valid(TREE_BUF) then
    TREE_BUF = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(TREE_BUF, 'buftree://tree')
    vim.api.nvim_set_option_value('buftype', 'nofile', { buf = TREE_BUF })
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = TREE_BUF })
    vim.api.nvim_set_option_value('swapfile', false, { buf = TREE_BUF })
    vim.api.nvim_set_option_value('filetype', 'buftree', { buf = TREE_BUF })

    local map = function(lhs, fn)
      vim.keymap.set('n', lhs, fn, { buffer = TREE_BUF, silent = true, nowait = true })
    end
    map('<CR>', function()
      local b = buf_under_cursor()
      if b and vim.api.nvim_buf_is_valid(b) then
        -- jump to the previous window so we don't replace the tree
        vim.cmd('wincmd p')
        vim.api.nvim_set_current_buf(b)
      end
    end)
    map('d', function()
      local b = buf_under_cursor()
      if b and vim.api.nvim_buf_is_valid(b) then
        pcall(vim.cmd, 'bdelete ' .. b)
        render()
      end
    end)
    map('x', function()
      local b = buf_under_cursor()
      if b then prune(b); render() end
    end)
    map('q', function() M.close() end)
    map('r', render)
  end

  vim.api.nvim_win_set_buf(TREE_WIN, TREE_BUF)
  render()
end

function M.close()
  if TREE_WIN and vim.api.nvim_win_is_valid(TREE_WIN) then
    vim.api.nvim_win_close(TREE_WIN, true)
  end
  TREE_WIN = nil
end

function M.toggle()
  if TREE_WIN and vim.api.nvim_win_is_valid(TREE_WIN) then
    M.close()
  else
    M.open()
  end
end

-- ---------- Setup ----------

function M.setup()
  local group = vim.api.nvim_create_augroup('Buftree', { clear = true })

  -- Seed with already-loaded buffers as roots so we don't start empty.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and is_normal(buf) then
      ensure_node(buf)
      if not M.nodes[buf].parent then
        local already_root = false
        for _, r in ipairs(M.roots) do if r == buf then already_root = true; break end end
        if not already_root then table.insert(M.roots, buf) end
      end
    end
  end

  vim.api.nvim_create_autocmd('BufAdd', {
    group = group,
    callback = function(args)
      if is_normal(args.buf) then
        vim.schedule(function() record_add(args.buf); render() end)
      end
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(args)
      if is_normal(args.buf) then M.last_normal = args.buf end
      render()
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args) record_delete(args.buf); render() end,
  })
end

return M
