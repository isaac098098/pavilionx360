-- Vim

-- Filetypes
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

-- Tabs andd indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.linebreak = true

-- Line numbering
vim.opt.number = false
-- vim.opt.numberwidth = 1

-- Highlighting
vim.cmd('let loaded_matchparen=1')

-- Keybindings

vim.g.mapleader = ' '
vim.g.localleader = '\\'

-- Normal mode
vim.keymap.set('n','j','gj')
vim.keymap.set('n','k','gk')
vim.keymap.set('n','t','gt')
vim.keymap.set('n','T','gT')
vim.cmd('nnoremap <CR> :write<CR>')

-- Visual mode
vim.keymap.set('v','oi','<Esc>')

-- Select mode
vim.keymap.set('s','oi','<Esc>')

-- Insert mode
vim.keymap.set('i','oi','<Esc>')

--Plugins
require("config.lazy")

-- Colorschemes
vim.cmd('colorscheme base16-tomorrow-night')
vim.cmd('highlight NvimTreeEndOfBuffer guifg=#1d1f21')
vim.cmd('highlight NvimTreeWinSeparator guibg=#1a1b1d guifg=#1a1b1d')
vim.cmd('highlight NvimTreeNormal guibg=#1a1b1d')
vim.cmd('highlight NvimTreeStatusLine guibg=#1a1b1d')
vim.cmd('highlight NvimTreeStatusLineNC guibg=#1a1b1d')
vim.cmd('highlight EndOfBuffer guifg=#1d1f21')

--toggleterm
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1a1b1d', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#1d1f21', fg = '#ffffff' })

-- bufferline
vim.cmd('highlight BufferLineOffsetSeparator guifg=#1A1B1D guibg=#1A1B1D')
