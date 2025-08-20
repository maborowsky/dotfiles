return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      -- enable_check_bracket_line = false,

      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "snacks_picker_input",
      },
    },
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
}
