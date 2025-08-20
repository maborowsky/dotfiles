-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 155
config.initial_rows = 37

-- vim.o.opt
-- or, changing the font size and color scheme.
-- config.font = wezterm.font("Berkeley Mono Trial")
-- config.font = wezterm.font("RobotoMono Nerd Font")
-- config.font = wezterm.font("InputMonoNarrow")
config.font = wezterm.font("Terminess Nerd Font Mono")
config.font_size = 19
config.color_scheme = 'Kanagawa (Gogh)'


config.leader = {
  key = 'b',
  mods = 'CTRL',
  timeout_milliseconds = 2000,
}
-- config.unix_domains = {
--   {
--     name = 'torch',
--   },
-- }

config.keys = {
  -- Attach to muxer
  {
    key = 'a',
    mods = 'LEADER',
    action = act.AttachDomain 'local',
  },
  -- Detach from muxer
  {
    key = 'd',
    mods = 'LEADER',
    action = act.DetachDomain { DomainName = 'local' },
  },
  -- Show list of workspaces
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
  },
}




-- Finally, return the configuration to wezterm:
return config
