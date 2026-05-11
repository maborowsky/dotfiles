return {
  -- {
  --   'nvim-mini/mini.nvim',
  --   version = false,
  --   config = function()
  --     require('mini.starter').setup()
  --   end,
  -- },
  {
    'nvim-mini/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup()
    end,
    enabled = false,  -- Trying out nvim-autopairs
  },
  {
    'nvim-mini/mini.sessions',
    version = false,
    config = function()
      require('mini.sessions').setup()

      vim.api.nvim_create_user_command('MiniRestart', function()
        require('mini.sessions').restart()
      end, {})
    end,
  },
  { 'nvim-mini/mini.ai', version = false },
  {
    'nvim-mini/mini.misc',
    version = false,
    config = function()
      require('mini.misc').setup_termbg_sync()
    end
  },
  -- Git
  {
    'nvim-mini/mini.diff',
    config = function()
      require('mini.diff').setup({
        -- Defer to gitsigns visually: blank signs + lowest priority so
        -- gitsigns always wins the signcolumn slot. mini.diff still tracks
        -- hunks internally for the overlay and gh/gH operators.
        view = {
          style = 'sign',
          signs = { add = ' ', change = ' ', delete = ' ' },
          priority = 1,
        },
        mappings = {
          apply = 'gh',
          reset = 'gH',
          textobject = 'gh',
          -- Disable nav — ]c/[c via gitsigns already covers this
          goto_first = '',
          goto_prev  = '',
          goto_next  = '',
          goto_last  = '',
        },
      })

      local function diff_against(ref)
        local buf = vim.api.nvim_get_current_buf()
        local rel = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':.')
        local out = vim.system({ 'git', 'show', ref .. ':./' .. rel }, { text = true }):wait()
        if out.code ~= 0 then
          vim.notify('git show ' .. ref .. ': ' .. (out.stderr or ''), vim.log.levels.ERROR)
          return
        end
        local lines = vim.split(out.stdout, '\n')
        if lines[#lines] == '' then table.remove(lines) end
        require('mini.diff').set_ref_text(buf, lines)
        vim.b[buf].minidiff_ref = ref
        vim.notify('mini.diff: comparing against ' .. ref)
      end

      local function diff_reset()
        local buf = vim.api.nvim_get_current_buf()
        require('mini.diff').disable(buf)
        require('mini.diff').enable(buf)
        vim.b[buf].minidiff_ref = nil
      end

      vim.api.nvim_create_user_command('MiniDiffRef', function(opts)
        diff_against(opts.args ~= '' and opts.args or 'main')
      end, { nargs = '?', desc = 'mini.diff: compare current buffer against given ref' })

      vim.api.nvim_create_user_command('MiniDiffReset', diff_reset,
        { desc = 'mini.diff: restore default reference (git index)' })

      vim.keymap.set('n', '<leader>ghv', function() require('mini.diff').toggle_overlay(0) end,
        { desc = 'Toggle inline overlay (mini.diff)' })
      vim.keymap.set('n', '<leader>ghm', function() diff_against('main') end,
        { desc = 'Diff vs main (mini.diff)' })
      vim.keymap.set('n', '<leader>ghM', diff_reset,
        { desc = 'Reset diff ref to index (mini.diff)' })
    end,
  },
}
