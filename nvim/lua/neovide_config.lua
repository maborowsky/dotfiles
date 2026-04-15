-- vim.o.guifont = "Berkeley Mono Trial:h16"
-- vim.o.guifont = "Terminess Nerd Font Mono:h18"
-- vim.o.guifont = "BerkeleyMonoTrial Nerd Font:h16"
-- vim.o.guifont = "Hack Nerd Font Mono:h16"
vim.o.guifont = "Input Mono:h16"
vim.o.background = 'dark'

vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
vim.keymap.set('v', '<D-c>', '"+y') -- Copy
vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode


-- vim.g.neovide_floating_corner_radius = 0.0
vim.g.neovide_remember_window_size = true

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
vim.g.neovide_cursor_short_animation_length = 0.02
