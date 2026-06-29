local worktree_cache = {}
local function worktree_marker()
  local cwd = vim.fn.getcwd()
  local cached = worktree_cache[cwd]
  if cached ~= nil then return cached end
  local git_dir = vim.fn.systemlist({ 'git', 'rev-parse', '--git-dir' })[1] or ''
  local common_dir = vim.fn.systemlist({ 'git', 'rev-parse', '--git-common-dir' })[1] or ''
  local marker = ''
  if vim.v.shell_error == 0 and git_dir ~= '' and git_dir ~= common_dir then
    local name = git_dir:match('worktrees/([^/]+)') or ''
    -- Swap the glyph below to change the worktree marker. Candidates:
    --
    --   󰐆
    --   󰐅
    --   󰹩
    --   󱏒
    --   󰐆
    marker = '󰐅 ' .. name
  end
  worktree_cache[cwd] = marker
  return marker
end
vim.api.nvim_create_autocmd({ 'DirChanged', 'VimEnter' }, {
  callback = function() worktree_cache = {} end,
})

-- Show Claude stats OR LSP status, never both, depending on the focused window.
-- The Claude terminal (snacks provider) has filetype 'snacks_terminal', which is
-- in ignore_focus -> lualine won't recompute on its own when it's focused. So we
-- flip a global from an autocmd and force a refresh.
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'TermEnter', 'BufEnter' }, {
  callback = function()
    vim.g.claude_window_focused = vim.bo.filetype == 'snacks_terminal'
      and vim.api.nvim_buf_get_name(0):lower():find('claude', 1, true) ~= nil
    pcall(function() require('lualine').refresh() end)
  end,
})

-- Claude status: shown only while a Claude session is connected to this nvim.
-- Rich data (model / context% / cost) comes from a JSON snapshot written by the
-- statusLine command in ~/.claude/statusline.sh, keyed by sha256(cwd).
local function claude_status()
  local ok, cc = pcall(require, 'claudecode')
  if not ok or not cc.is_claude_connected() then return '' end
  local path = vim.fn.expand('~/.claude/statusline/') .. vim.fn.sha256(vim.fn.getcwd()) .. '.json'
  local f = io.open(path, 'r')
  if not f then return '󰚩' end
  local content = f:read('*a')
  f:close()
  local ok2, data = pcall(vim.fn.json_decode, content)
  if not ok2 or type(data) ~= 'table' then return '󰚩' end
  -- Guard against stale snapshots: connected but data hasn't refreshed in a
  -- while (idle session, or a leftover file from a crashed run) -> bare icon.
  if type(data.ts) == 'number' and (os.time() - data.ts) > 300 then return '󰚩' end
  local parts = { '󰚩' }
  if data.model and data.model ~= '' and data.model ~= 'null' then table.insert(parts, data.model) end
  if data.effort and data.effort ~= '' then table.insert(parts, '󰓅 ' .. data.effort) end
  -- '%%' because lualine passes this into 'statusline', where bare '%' is special
  if data.pct and data.pct ~= '' then table.insert(parts, data.pct .. '%%') end
  if data.cost and data.cost ~= '' then table.insert(parts, data.cost) end
  return table.concat(parts, ' ')
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          globalstatus = true,
          icons_enabled = true,
          theme = 'auto',
          -- Should probably make a local variable for this, but a filetype needs to be in both to work properly
          ignore_focus = {
            "toggleterm",
            "lspinfo",
            "fugitive",
            "snacks_picker_input",
            "NvimTree",
            "snacks_terminal",
          },
          -- disabled_filetypes = {
          --   "toggleterm",
          --   "lspinfo",
          --   "fugitive",
          --   "snacks_picker_input",
          --   "NvimTree",
          --   "snacks_terminal",
          -- },
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = { {
            'mode',
            fmt = function(str) return str:sub(1,1) end,
            -- separator = { left = '' },
            -- right_padding = 2,
          } },
          lualine_b = {
            {
              'branch',
              fmt = function(str)
                return string.gsub(str, "michael/", "m/")
              end,
              cond = function() return worktree_marker() == '' end,
            },
            {
              worktree_marker,
              cond = function() return worktree_marker() ~= '' end,
              -- color = { fg = '#98c379', gui = 'bold' },
            },
            {
              function() return '⇋ ' .. (vim.b.minidiff_ref or '') end,
              cond = function() return vim.b.minidiff_ref ~= nil end,
              -- color = { fg = '#e5c07b', gui = 'bold' },
            },
          },
          lualine_c = {
            {
              'filename',
              path = 1,                -- 0: Just the filename
                                       -- 1: Relative path
                                       -- 2: Absolute path
                                       -- 3: Absolute path, with tilde as the home directory
                                       -- 4: Filename and parent dir, with tilde as the home directory
            },

          },
          lualine_x = {
            {
              ' | '
            },
            {
              claude_status,
              cond = function() return vim.g.claude_window_focused and claude_status() ~= '' end,
              -- color = { fg = '#d97757', gui = 'bold' },
            },
            -- {
            --   'tabs',
            --   tab_max_length = 40,
            --   mode = 1,
            --   path = 1,
            --   use_mode_colors = true,
            -- },
            --
            {
              'lsp_status',
              cond = function() return not vim.g.claude_window_focused end,
              icon = '', -- f013
              symbols = {
                -- Standard unicode symbols to cycle through for LSP progress:
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                -- Standard unicode symbol for when LSP is done:
                done = '✓',
                -- Delimiter inserted between LSP names:
                separator = ' ',
              },
              -- List of LSP names to ignore (e.g., `null-ls`):
              ignore_lsp = {},
            },
          },
          -- lualine_y = { 'filetype', 'progress' },
          lualine_y = {
            {
              -- not sure this should be in y, maybe its X
              function() return '󰍹 ' .. vim.env.ZMX_SESSION end,
              cond = function() return vim.env.ZMX_SESSION ~= nil and vim.env.ZMX_SESSION ~= '' end,
            },
            'progress',
          },
          lualine_z = {
            { 'location', left_padding = 2 },
          },
        }
      }
    end
  },
} -- end return
