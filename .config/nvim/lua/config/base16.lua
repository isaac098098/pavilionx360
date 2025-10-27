-- vim.cmd('colorscheme base16-tomorrow-night')

require('base16-colorscheme').setup({
    base00 = '#1E1A1B', base01 = '#2A2425', base02 = '#343031', base03 = '#E5B191',
    base04 = '#1E1A1B', base05 = '#F6EBEB', base06 = '#1E1A1B', base07 = '#E5B191',
    base08 = '#F6EBEB', base09 = '#AC6B38', base0A = '#E5B191', base0B = '#AC6B38',
    base0C = '#B6B297', base0D = '#F6EBEB', base0E = '#E5E0E0', base0F = '#B6B294',
})

-- NvimTree

vim.cmd('highlight NvimTreeNormal guibg=#1E1A1B')
vim.cmd('highlight NvimTreeEndOfBuffer guifg=#1E1A1B')
vim.cmd('highlight NvimTreeWinSeparator guibg=#1E1A1B guifg=#1E1A1B')
vim.cmd('highlight NvimTreeStatusLine guifg=#1E1A1B guibg=#1E1A1B')
vim.cmd('highlight NvimTreeStatusLineNC guifg=#1E1A1B guibg=#1E1A1B')

-- Nvim

vim.cmd('highlight EndOfBuffer guifg=#1B181A')
vim.cmd('highlight Normal ctermbg=none guibg=none')
vim.cmd('highlight NormalNC ctermbg=none guibg=none')
vim.cmd('highlight ModeMsg guifg=#F6EBEB')

-- TabLine

vim.cmd('highligh TabLineSel guifg=#1F1A1C guibg=#E5B191')
vim.cmd('highligh TabLine guifg=#F6EBEB guibg=#1F1A1C')
vim.cmd('highligh TabLineFill guibg=#1F1A1C')

-- Relative line numbers
-- vim.cmd('highlight LineNr guifg=#C5C8C6 guibg=none')
-- vim.cmd('highlight LineNrAbove guifg=#373B41 guibg=none')
-- vim.cmd('highlight LineNrBelow guifg=#373B41 guibg=none')

-- Normal line numbers
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.cmd('highlight LineNr guifg=#3D3337 guibg=none')
vim.api.nvim_set_hl(0, "CursorLineNr", { underline = false, fg = "#F6EBEB", bg = "none" })
