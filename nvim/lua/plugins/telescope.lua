return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require("telescope.actions")
      require('telescope').setup{
        defaults = {
          mappings = {
            i = {},
          },
          pickers = {
            buffers = { sort_lastused = true },
            find_files = { hidden = true },
            git_branches = {
              mappings = {
                i = {
                  ["<c-r>"] = actions.git_rename_branch
                },
                n = {

                },
              }
            },
          }
        },
      } -- end setup

      -- require("telescope").load_extension('harpoon')
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  -- {
  --   'nvim-telescope/telescope-fzf-native.nvim',
  --   build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
  -- },

  -- {
  --   "AckslD/nvim-neoclip.lua",
  --   dependencies = {
  --     {'nvim-telescope/telescope.nvim'},
  --   },
  --   -- config = function() require('neoclip').setup() end
  -- },

  {
    enabled = false,  -- don't use this really but it is cool and useful
    "LinArcX/telescope-env.nvim",
    dependencies = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function() require'telescope'.load_extension('env') end,
    opts={
      -- The path where to search the makefile in the priority order
      -- makefile_priority = { '.', '' },
      -- make_bin = "make", -- Custom makefile binary path, uses system make by def
    },
  },

  {
    "sopa0/telescope-makefile",
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function() require'telescope'.load_extension('make') end
  },

  -- {
  --   'LukasPietzschmann/telescope-tabs',
  --   dependencies = { 'nvim-telescope/telescope.nvim' },
  -- },

  {
    'lpoto/telescope-docker.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  --   config = function()
  --     require("telescope").setup {
  --       extensions = {
  --         -- NOTE: this setup is optional
  --         docker = {
  --           -- These are the default values
  --           theme = "ivy",
  --           binary = "docker", -- in case you want to use podman or something
  --           compose_binary = "docker compose",
  --           buildx_binary = "docker buildx",
  --           machine_binary = "docker-machine",
  --           log_level = vim.log.levels.INFO,
  --           init_term = "tabnew", -- "vsplit new", "split new", ...
  --           -- NOTE: init_term may also be a function that receives
  --           -- a command, a table of env. variables and cwd as input.
  --           -- This is intended only for advanced use, in case you want
  --           -- to send the env. and command to a tmux terminal or floaterm
  --           -- or something other than a built in terminal.
  --         },
  --       },
  --     }
  --     -- Load the docker telescope extension
  --     require("telescope").load_extension "docker"
  --   end
  },

} -- end return
