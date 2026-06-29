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
  {
    'nvim-mini/mini.ai',
    version = false,
    config = function()
      require('mini.ai').setup({
        -- These conflict with defaults, see :h MiniAi-default-an-in
        mappings = {
          around_next = 'aN',
          inside_next = 'iN',
          around_last = 'aL',
          inside_last = 'iL',
        }
      })
    end,
  },
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
  {
    'nvim-mini/mini.input',
    version = false,
    enabled = false, -- switched back to tiny-cmdline
    config = function()
      -- `setup()` creates the global `MiniInput` table used below
      require('mini.input').setup()

      -- Build `MiniInput.get()` options for an editor-centered floating prompt.
      -- `prompt` is rendered inline (e.g. ": " or "lua ") via `include_prompt`,
      -- so the border title is blanked to avoid showing it twice.
      local function make_opts(prompt, parser, completion)
        local highlight_parser = MiniInput.gen_highlight.treesitter(parser)
        local highlight = function(state)
          state = highlight_parser(state) or state
          return MiniInput.default_highlight(state) or state
        end
        return {
          prompt = prompt,
          scope = 'editor',
          completion = completion,
          handlers = {
            view = MiniInput.gen_view.floatwin({
              style = 'MM',
              to_chunks = function(state, max_width)
                return MiniInput.state_to_chunks(state, max_width, { include_prompt = true })
              end,
              adjust_config = function(_, config)
                local width = math.floor(vim.o.columns * 0.5)
                config.width = width
                config.col = math.floor((vim.o.columns - width) / 2)
                config.border = 'rounded'
                config.title = '' -- prompt is shown inline instead
                return config
              end,
            }),
            highlight = highlight,
          },
        }
      end

      -- `:` — run input as an Ex command
      local cmdline_opts = make_opts(':', 'vim', 'cmdline')
      vim.keymap.set('n', ':', function()
        local cmd = MiniInput.get(cmdline_opts)
        if cmd ~= nil then vim.cmd(cmd) end
      end)

      -- `<C-:>` — run input as Lua
      local lua_opts = make_opts('lua', 'lua', 'lua')
      vim.keymap.set('n', '<C-:>', function()
        local cmd = MiniInput.get(lua_opts)
        if cmd ~= nil then vim.cmd('lua ' .. cmd) end
      end)
    end,
  },

  {
    'nvim-mini/mini.colors',
    version = false,
    config = function()
      require('mini.colors').setup()
    end,
  },

  {
    'nvim-mini/mini.jump',
    enabled = false,
    version = false,
    config = function()
      require('mini.jump').setup()
    end,
  },

  {
    'nvim-mini/mini.jump2d',
    enabled = false,  -- Using flash.nvim for 2d jumping
    version = false,
    config = function()
      require('mini.jump2d').setup()
    end,
  },

}



