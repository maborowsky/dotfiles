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
config.font = wezterm.font("InputMonoNarrow")
-- config.font = wezterm.font("Terminess Nerd Font Mono")
config.font_size = 16
config.color_scheme = 'Kanagawa (Gogh)'
config.line_height = 1.2


-- Window Appearance
-- https://wezterm.org/config/lua/config/window_decorations.html
-- other options: INTEGRATED_BUTTONS
-- nightly: MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR, MACOS_FORCE_SQUARE_CORNERS
config.use_fancy_tab_bar = false
config.window_decorations = "MACOS_FORCE_DISABLE_SHADOW|RESIZE"


config.leader = {
  key = 'b',
  mods = 'CTRL',
  timeout_milliseconds = 1000,
}

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
  -- tab navigator
  {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action.ShowTabNavigator
  },
    -- Show launcher
  {
    key = 'P',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ShowLauncher
  },
    -- Vertical pipe (|) -> horizontal split
  {
    key = '\\',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal {
      domain = 'CurrentPaneDomain'
    },
  },
  -- Underscore (_) -> vertical split
  {
    key = '-',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical {
      domain = 'CurrentPaneDomain'
    },
  },
  -- Rename the current tab
  {
    key = 'i',
    mods = 'CMD',
    action = act.PromptInputLine {
      description = 'Enter new tab title',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}



-- Finally, return the configuration to wezterm:
return config
