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
    marker = '⑂ ' .. name
  end
  worktree_cache[cwd] = marker
  return marker
end
vim.api.nvim_create_autocmd({ 'DirChanged', 'VimEnter' }, {
  callback = function() worktree_cache = {} end,
})

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
            },
            {
              function() return '⇋ ' .. (vim.b.minidiff_ref or '') end,
              cond = function() return vim.b.minidiff_ref ~= nil end,
              color = { fg = '#e5c07b', gui = 'bold' },
            },
            {
              worktree_marker,
              cond = function() return worktree_marker() ~= '' end,
              color = { fg = '#98c379', gui = 'bold' },
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
          lualine_y = { 'progress' },
          lualine_z = {
            { 'location', left_padding = 2 },
          },
        }
      }
    end
  },
} -- end return
