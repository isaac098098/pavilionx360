-- nord

vim.cmd('colorscheme nord')

local colors = {
    nord0   = '#2E3440',
    nord1   = '#3B4252',
    nord2   = '#434C5E',
    nord4   = '#D8DEE9',
    nord5   = '#E5E9F0',
    nord6   = '#ECEFF4',
    nord12  = '#D08770',
    nord14  = '#A3BE8C',
    nord15  = '#B48EAD'
}

local TelescopeColor = {
    TelescopeMatching       = { fg = colors.nord15 },
    TelescopeSelection      = { fg = colors.nord5, bg = colors.nord1, bold = true },
    TelescopePromptPrefix   = { bg = colors.nord0, fg = colors.nord0 },
    TelescopePromptBorder   = { bg = colors.nord0, fg = colors.nord0 },
    TelescopePromptTitle    = { bg = colors.nord15, fg = colors.nord0 },
    TelescopePromptNormal   = { bg = colors.nord0 },
    TelescopeResultsNormal  = { bg = colors.nord2 },
    TelescopeResultsBorder  = { bg = colors.nord2, fg = colors.nord2 },
    TelescopeResultsTitle   = { fg = colors.nord2 },
    TelescopePreviewNormal  = { bg = colors.nord1 },
    TelescopePreviewBorder  = { bg = colors.nord1, fg = colors.nord1 },
    TelescopePreviewTitle   = { bg = colors.nord14 , fg = colors.nord0 },
}

for hl, col in pairs(TelescopeColor) do
	vim.api.nvim_set_hl(0, hl, col)
end

-- nvim-tree

vim.cmd('highlight NvimTreeNormal guibg=#3B4252')
vim.cmd('highlight NvimTreeNormalFloat guibg=#3B4252')
vim.cmd('highlight NvimTreeCursorLine guibg=#4C566A')
vim.cmd('highlight NvimTreeEndOfBuffer guifg=#3B4252')
vim.cmd('highlight NvimTreeWinSeparator guibg=#3B4252 guifg=#3B4252')
vim.cmd('highlight StatusLine guifg=#eceff4')
vim.cmd('highlight NvimTreeStatusLine guibg=#3B4252 guifg=#3b4252')
vim.cmd('highlight NvimTreeStatusLineNC guibg=#3B4252 guifg=#3b4252')
vim.cmd('highlight EndOfBuffer guifg=#2E3440')

-- toggleterm
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#3B4252', fg = '#E5E9F0' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#3B4252', fg = '#E5E9F0' })
