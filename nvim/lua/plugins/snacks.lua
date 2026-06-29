local function pick_worktrees()
  Snacks.picker.pick({
    source = "worktrees",
    title = "Git Worktrees",
    finder = function()
      local out = vim.fn.systemlist("git worktree list --porcelain")
      if vim.v.shell_error ~= 0 then
        vim.notify("Not in a git repository", vim.log.levels.ERROR)
        return {}
      end
      local items, cur = {}, {}
      local function flush()
        if cur.path then
          local label = cur.branch or cur.head or "(detached)"
          cur.text = string.format("%-40s %s", label, cur.path)
          table.insert(items, cur)
        end
        cur = {}
      end
      for _, line in ipairs(out) do
        if line:match("^worktree ") then
          flush()
          cur.path = line:sub(10)
        elseif line:match("^branch ") then
          cur.branch = line:sub(8):gsub("^refs/heads/", "")
        elseif line:match("^HEAD ") then
          cur.head = line:sub(6, 13)
        elseif line == "detached" then
          cur.detached = true
        end
      end
      flush()
      return items
    end,
    format = "text",
    confirm = function(picker, item)
      picker:close()
      if item and item.path then
        vim.cmd.tcd(item.path)
        vim.cmd.edit(item.path)
      end
    end,
  })
end

return {
  {
    enabled=true,
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        row = math.max(2, math.floor(vim.o.lines / 5)),
        preset = {
          header = "            ▀" .. string.rep(" ", 7 + 6) .. "\n         █▀█▄█▀█▀█▀█" .. string.rep(" ", 6),
          keys = {
            { icon = " ", key = "f", desc = "Find File",     action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File",      action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text",     action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files",  action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config",        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "z", desc = "Edit ~/.zshrc",        action = ":e ~/.zshrc" },
            { icon = " ", key = "G", desc = "Edit Ghostty config",  action = ":e ~/.config/ghostty/config" },
            { icon = " ", key = "k", desc = "Edit Kitty config",    action = ":e ~/.config/kitty/kitty.conf" },
            { icon = " ", key = "L", desc = "Lazy",          action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit",          action = ":qa" },
          },
        },
        sections = {
          -- { section = "header", padding = 1, indent = 20 }, -- ~1/3 of default dashboard width (60)
          { section = "header", padding = 2, align = "right" },
          { section = "keys", gap = 0, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, limit = 5 },
          { icon = " ", title = "Projects",     section = "projects",     indent = 2, padding = 1, limit = 5 },
          { section = "startup" },
        },
      },
      explorer = {
        enabled = true,
     },
      gitbrowse = { enabled = true }, -- i think this is just there by default?
      image = { enabled = true },
      indent = {
        enabled = false,
        hl = "SnacksIndent",
        only_scope = true,
        only_current = false, -- only show indent guides in the current window
        scope = {
          only_current = true, -- only show scope in the current window
          -- hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
          enabled = true,

        },
      },
      input = {
        enabled = true,
        icon = " ",
        icon_hl = "SnacksInputIcon",
        icon_pos = "left",
        prompt_pos = "title",
        win = { style = "input" },
        expand = true,
        position = "float",
      },
      picker = {
        enabled = true,
        formatters = {
          file = {
            filename_first = true, -- Displays 'filename.lua  path/to/' instead of 'path/to/filename.lua'
          },
        },
        -- file = {
        --   --- * left: truncate the beginning of the path
        --   --- * center: truncate the middle of the path
        --   --- * right: truncate the end of the path
        --   ---@type "left"|"center"|"right"
        --   truncate = "left",
        -- },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".worktrees" },
          },
          files = { exclude = { ".worktrees" } },
          grep = { exclude = { ".worktrees" } },
          smart = { exclude = { ".worktrees" } },
          grep_buffers = { exclude = { ".worktrees" } },
          lines = { exclude = { ".worktrees" } },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "minimal",
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },  -- trying out neoscroll
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    terminal = {
      -- trying to disable double tap for esc but it's not working
      -- keys = {
      --   term_normal = {
      --     "<esc>",
      --     "<C-\\><C-n>",
      --     mode = "t",
      --   },
      -- },
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files({ layout = "vscode" }) end, desc = "Find Files" },
      { "<leader>f*", function() Snacks.picker.files({ pattern = vim.fn.getreg("+") }) end, desc = "Find File in Clipboard" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>fp", function() Snacks.picker.pickers() end, desc = "Pickers" },
      { "<leader>fP", function() Snacks.picker.projects() end, desc = "Projects" },
      -- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fz", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },

      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Log (line)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Diff (hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Log (file)" },
      { "<leader>gw", pick_worktrees, desc = "Worktrees" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      {
        "<leader>s*",
        function()
          Snacks.picker.grep_word({search = vim.fn.getreg("*")})
        end,
        desc = "Grep for word in * register",
        mode = { "n", "x" }
      },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      -- { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      -- { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      -- { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- Lsp --
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      -- currently conflicting with default map of grn for rename
      { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function()
        Snacks.picker.lsp_symbols({layout = {preset = "vscode", preview = "main"}})
      end, desc = "LSP Symbols" },
      { "<leader>sn", function()
        Snacks.picker.lsp_symbols({layout = {preset = "dropdown", preview = "main"}})
      end, desc = "Jump to LSP symbol" },
      -- st for "testing" lol change this to default if its good
      --   https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#lsp_symbols
      { "<leader>st", function()
        Snacks.picker.lsp_symbols({
          layout = {preset = "dropdown", preview = "main"},
          filter = {
            default = {
              "Class",
              "Method",
              "Function",
            },
          },
        })
      end, desc = "LSP Symbols -- functions" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "]w", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[w", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
  },
}
