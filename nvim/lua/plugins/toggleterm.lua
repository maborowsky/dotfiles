local function detect_root()
  for _, c in ipairs(vim.lsp.get_clients()) do
    if c.root_dir and c.root_dir ~= '' then return c.root_dir end
  end
  if vim.fs and vim.fs.root then
    local r = vim.fs.root(0, {
      '.git', 'package.json', 'pyproject.toml', 'go.mod', 'Cargo.toml', 'deno.json',
    })
    if r then return r end
  end
  return vim.fn.getcwd()
end

-- Computed lazily on first terminal spawn so LSP has had a chance to attach.
local cached_prefix
local function project_prefix()
  if cached_prefix then return cached_prefix end
  local root = detect_root()
  local slug = vim.fn.fnamemodify(root, ':t')
  local hash = vim.fn.sha256(root):sub(1, 6)
  cached_prefix = string.format('nvim.%s-%s.', slug, hash)
  return cached_prefix
end

local zmx_available = vim.fn.executable('zmx') == 1 and vim.env.ZMX_SESSION == nil

return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "float" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        elseif term.direction == "horizontal" then
          return 15
        else
          return 20
        end
      end,
      -- open_mapping omitted; the keymap below routes <count><C-\> through
      -- Terminal:new() with a per-slot `zmx a <count>` cmd. toggleterm's
      -- shell opt resolves once with no term context, so it can't differentiate
      -- slots on its own.
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_mode = true,
      direction = "vertical",
      windbar = { enabled = true },
      float_opts = {
        border = 'curved',
      },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)
      local tt = require('toggleterm.terminal')

      local function toggle_slot(count)
        local existing = tt.get(count)
        if existing then
          existing:toggle()
          return
        end
        local cmd = vim.o.shell
        if zmx_available then
          vim.env.ZMX_SESSION_PREFIX = project_prefix()
          cmd = string.format('zmx a %d', count)
        end
        tt.Terminal:new({
          cmd = cmd,
          count = count,
          direction = opts.direction,
        }):toggle()
      end

      vim.keymap.set('n', [[<C-\>]], function()
        toggle_slot(vim.v.count > 0 and vim.v.count or 1)
      end, { desc = 'Toggle zmx terminal (count = slot)' })

      vim.keymap.set({ 't', 'i' }, [[<C-\>]], function()
        toggle_slot(vim.b.toggle_number or 1)
      end, { desc = 'Toggle current zmx terminal' })

      -- Reflow: kill the zmx client so toggleterm respawns it at the current
      -- window size. The zmx daemon persists, so reattach replays a fresh
      -- snapshot — equivalent to detach/reattach by hand.
      vim.api.nvim_create_user_command('ZmxReflow', function()
        local id = vim.b.toggle_number or 1
        local term = tt.get(id)
        if not term then
          vim.notify('No toggleterm #' .. id, vim.log.levels.WARN)
          return
        end
        term:shutdown()
        vim.defer_fn(function() toggle_slot(id) end, 50)
      end, { desc = 'Detach/reattach zmx session at current size' })

      if zmx_available then
        vim.keymap.set('n', '<leader>tr', '<cmd>ZmxReflow<cr>',
          { desc = 'Reflow zmx terminal' })
      end
    end,
  },
} -- end return