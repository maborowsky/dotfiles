return {
  {
    "coder/claudecode.nvim",
    -- "snirt/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    init = function()
      vim.api.nvim_create_user_command("ClaudeAgents", function()
        Snacks.terminal.toggle("claude agents", {
          win = {
            position = "float",
            width = 0.9,
            height = 0.9,
            border = "rounded",
            title = " Claude Background Agents ",
            title_pos = "center",
          },
        })
      end, { desc = "Toggle Claude background agents overview" })
    end,
    opts = {
      focus_after_send = false,
      open_in_new_tab = false,
      hide_terminal_in_new_tab = true,
      terminal = {
        -- provider = "native",
        provider = "snacks",
        split_width_percentage = 0.40,
        -- Optional: shrink (or widen) the terminal while a diff is open. Defaults to
      -- split_width_percentage when unset, preserving today's behavior.
      diff_split_width_percentage = nil, -- e.g. 0.20 to give diffs more room
      }
      ,
      -- Diff behavior
      diff_opts = {
        layout = "unified", -- single-buffer inline diff (no side-by-side)
        split_side = "right",
        split_width_percentage = 0.4,
        auto_close_on_accept = true,
        -- auto_close_on_accept = true, -- Close diff windows after accepting
        -- vertical_split = true, -- Use vertical splits for diffs
        keep_terminal_focus = true, -- Keep focus on Claude terminal
        auto_resize_terminal = false, -- resizes garble Claude's TUI (stale scrollback); testing off
      },
    },
    keys = {
      { "<c-enter>", "<cmd>ClaudeCode<cr>", mode = {"n", "t"}, desc = "Toggle Claude" },
      -- { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>a", group = "Claude" },
      -- { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>ag", "<cmd>ClaudeAgents<cr>", desc = "Background agents overview" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      {
        "<leader>ap",
        function()
          vim.cmd("enew")
          vim.cmd("put +")
          vim.bo.buftype = "nofile"
          vim.bo.filetype = "markdown"
        end,
        desc = "Paste /copy into scratch buffer",
      },
      {
        "<leader>ac",
        function()
          local path = "/tmp/claude-" .. vim.uv.getuid() .. "/response.md"
          if vim.fn.filereadable(path) == 0 then
            vim.notify("No /copy output at " .. path, vim.log.levels.WARN)
            return
          end
          local win = Snacks.win({
            file = path,
            width = 0.8,
            height = 0.8,
            border = "rounded",
            title = " Claude /copy ",
            title_pos = "center",
            wo = { wrap = true },
          })
          -- /copy rewrites the file in place; reload if the buffer is stale
          vim.api.nvim_buf_call(win.buf, function()
            vim.cmd("silent! checktime")
          end)
        end,
        desc = "Open /copy output in float",
      },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      -- Multi-session
      { "<leader>an", "<cmd>ClaudeCodeNew<cr>", desc = "New session" },
      { "<leader>al", "<cmd>ClaudeCodeSessions<cr>", desc = "List sessions" },
    },
  },
}
