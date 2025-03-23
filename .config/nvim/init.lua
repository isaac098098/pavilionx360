-- Vim

-- Filetypes
vim.cmd('filetype plugin on')
-- vim.cmd('filetype indent on')

-- Tabs andd indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.linebreak = true

-- Line numbering
vim.opt.number = false
vim.opt.numberwidth = 1

-- Highlighting
vim.cmd('let loaded_matchparen=1')
-- vim.api.nvim_create_autocmd('Filetype', {
--     pattern = '*',
--     callback = function()
--         vim.treesitter.stop()
--     end
-- })
-- vim.cmd('syntax off')

-- Keybindings

vim.g.mapleader = ' '
vim.g.localleader = '\\'

-- Normal mode
vim.keymap.set('n','j','gj')
vim.keymap.set('n','k','gk')
vim.keymap.set('n','rt','gt')
vim.keymap.set('n','T','gT')
vim.cmd('nnoremap <CR> :write<CR>')

-- Visual mode
vim.keymap.set('v','<C-j>','<Esc>')

-- Select mode
vim.keymap.set('s','<C-j>','<Esc>')

-- Insert mode
vim.keymap.set('i','<C-j>','<Esc>')
vim.keymap.set('i','<C-e>','<C-o>$')

--Plugins
require("config.lazy")

-- Colorschemes

-- Transparent background

vim.cmd('highlight Normal ctermbg=none guibg=none')
vim.cmd('highlight NonText ctermbg=none guibg=none')

-- nord

-- bufferline
vim.cmd('highlight BufferLineOffsetSeparator guifg=#3B4252 guibg=#3B4252')
vim.cmd('highlight BufferLineSeparator guifg=#222730 guibg=#222730')
vim.cmd('highlight BufferLineFill guibg=#222730 guifg=#222730')

-- vimtex
vim.cmd('highlight VimTeXInfo guifg=#81A1C1')
