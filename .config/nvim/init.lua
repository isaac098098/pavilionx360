-- Vim

-- Filetypes
vim.cmd('filetype plugin on')
-- vim.cmd('filetype indent on')

-- Tabs andd indentation
vim.opt.tabstop = 4
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
vim.keymap.set('i','<C-p>','<Esc>V"+y:q!<CR>')

--Plugins
require("config.lazy")

-- Colorschemes

-- onedark-darker

-- bufferline
vim.cmd('highlight BufferLineOffsetSeparator guifg=#181B20 guibg=#181B20')
-- vim.cmd('highlight BufferLineFill guibg=#171A1E')
