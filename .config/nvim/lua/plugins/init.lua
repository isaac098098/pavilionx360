return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('config.lualine')
        end
    },
    {
        --requires nvim-treesitter-cli
        'lervag/vimtex',
        lazy = false,
        init = function()
            require('config.vimtex')
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        version = "*",
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('config.nvim-tree')
        end
    },
    {
        --requires tree-sitter-cli
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('config.nvim-treesitter')
        end
    },
    {
        'RRethy/base16-nvim',
    },
    {
        "L3MON4D3/LuaSnip",
        name = 'luasnip',
        version = "v2.*",
        build = "make install_jsregexp",
        init = function()
            require('config.luasnip')
        end
    },
    {
        'folke/zen-mode.nvim',
        name = 'zen-mode',
        config = function()
            require('config.zen-mode')
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig")
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = { {'L3MON4D3/LuaSnip'}, {'saadparwaiz1/cmp_luasnip'}, {'hrsh7th/cmp-nvim-lsp'} },
        config = function()
            require('config.cmp')
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { {'nvim-treesitter/nvim-treesitter'}, {'nvim-lua/plenary.nvim'} },
        opts = function()
            return require('config.telescope')
        end
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
        opts = function()
            return require('config.toggleterm')
        end
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            return require('config.bufferline')
        end
    },

}
