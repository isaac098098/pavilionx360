require('onedark').setup{
    style = 'darker'
}
require('onedark').load()

-- Highlight groups colors

-- base16-tommorow-night

-- vim.cmd('colorscheme base16-tomorrow-night')
-- vim.cmd('highlight NvimTreeEndOfBuffer guifg=#1d1f21')
-- vim.cmd('highlight NvimTreeWinSeparator guibg=#1a1b1d guifg=#1a1b1d')
-- vim.cmd('highlight NvimTreeNormal guibg=#1a1b1d')
-- vim.cmd('highlight NvimTreeStatusLine guibg=#1a1b1d')
-- vim.cmd('highlight NvimTreeStatusLineNC guibg=#1a1b1d')
-- vim.cmd('highlight EndOfBuffer guifg=#1d1f21')

-- toggleterm
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1a1b1d', fg = '#ffffff' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#1d1f21', fg = '#ffffff' })
--
-- bufferline
-- vim.cmd('highlight BufferLineOffsetSeparator guifg=#1A1B1D guibg=#1A1B1D')

-- onedark-darker

local colors = {
    bg1 = '#282c34',
    bg_d = '#181b20',
    fg = '#a0a8b7',
    orange = '#cc9057',
    purple = '#bf68d9',
    green = '#8ebd6b'
}

local TelescopeColor = {
    TelescopeMatching = { fg = colors.orange },
    TelescopeSelection = { fg = colors.fg, bg = colors.bg1, bold = true },
    TelescopePromptPrefix = { bg = colors.bg1 },
    TelescopePromptNormal = { bg = colors.bg1 },
    TelescopeResultsNormal = { bg = colors.bg_d },
    TelescopePreviewNormal = { bg = colors.bg_d },
    TelescopePromptBorder = { bg = colors.bg1, fg = colors.bg1 },
    TelescopeResultsBorder = { bg = colors.bg_d, fg = colors.bg_d },
    TelescopePreviewBorder = { bg = colors.bg_d, fg = colors.bg_d },
    TelescopePromptTitle = { bg = colors.purple, fg = colors.bg_d },
    TelescopeResultsTitle = { fg = colors.bg_d },
    TelescopePreviewTitle = { bg = colors.green, fg = colors.bg_d },
}

for hl, col in pairs(TelescopeColor) do
	vim.api.nvim_set_hl(0, hl, col)
end

vim.cmd('highlight NvimTreeEndOfBuffer guifg=#181b20')
vim.cmd('highlight NvimTreeWinSeparator guibg=#181b20 guifg=#181b20')
vim.cmd('highlight NvimTreeNormal guibg=#181b20')
vim.cmd('highlight NvimTreeNormalFloat guibg=#181b20')
vim.cmd('highlight NvimTreeStatusLine guibg=#181b20')
vim.cmd('highlight NvimTreeStatusLineNC guibg=#181b20')
vim.cmd('highlight EndOfBuffer guifg=#1f2329')

-- toggleterm
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#282c34', fg = '#a0a8b7' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#282c34', fg = '#a0a8b7' })

