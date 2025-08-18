vim.cmd('colorscheme base16-tomorrow-night')

-- TabLine

vim.cmd('highligh TabLineSel guifg=#1D1F21 guibg=#F0C674')
vim.cmd('highligh TabLine guifg=#C5C8C6 guibg=#282A2E')
vim.cmd('highligh TabLineFill guibg=#282A2E')

-- StatusLine

vim.cmd('highlight StatusLine guibg=#1D1F21')
vim.opt.laststatus = 0

-- ModeMsg

vim.cmd('highlight ModeMsg guifg=#F0C674 guibg=#282A2E')
vim.cmd('highlight LineNr guifg=#C5C8C6 guibg=none')
vim.cmd('highlight LineNrAbove guifg=#373B41 guibg=none')
vim.cmd('highlight LineNrBelow guifg=#373B41 guibg=none')

-- Nvim

-- Relative line numbers
vim.cmd('highlight LineNr guifg=#C5C8C6')
vim.cmd('highlight LineNrAbove guifg=#373B41')
vim.cmd('highlight LineNrBelow guifg=#373B41')

-- Normal line numbers
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.cmd('highlight LineNr guifg=#373B41')
vim.api.nvim_set_hl(0, "CursorLineNr", { underline = false, fg = "#C5C8C6" })
