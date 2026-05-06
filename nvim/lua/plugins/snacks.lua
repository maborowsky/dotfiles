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
        enabled = false,
        sections = {
          {
            section = "terminal",
            -- cmd = "chafa ~/.config/wall.png --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
            cmd = "cbonsai -l -i -L 30",
            height = 27,
            padding = 1,
            gap = 1,
          },
          {
            pane = 2,
            { section = "keys", gap = 1, padding = 10 },
            { section = "startup" },
          },
        },
      },
      explorer = {
        enabled = true,
     },
      gitbrowse = { enabled = true }, -- i think this is just there by default?
      image = { enabled = true },
      indent = {
        enabled = true,
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
        file = {
          --- * left: truncate the beginning of the path
          --- * center: truncate the middle of the path
          --- * right: truncate the end of the path
          ---@type "left"|"center"|"right"
          truncate = "left",
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
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
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>f*", function() Snacks.picker.files({ pattern = vim.fn.getreg("+") }) end, desc = "Find File in Clipboard" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>fp", function() Snacks.picker.pickers() end, desc = "Pickers" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fz", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },

      -- git
      { "<leader>Gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>Gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>GL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>Gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>GS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>Gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>Gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
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
      {
        '<leader>s"',
        function()
          Snacks.picker.grep_word({search = vim.fn.getreg('"')})
        end,
        desc = "Grep for word in \" register",
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
