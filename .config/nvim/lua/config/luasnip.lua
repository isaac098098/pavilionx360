local ls = require("luasnip")

--load and reaload snippets
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/plugins/luasnip/"})
vim.keymap.set('n', '<localleader>u', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/plugins/luasnip/"})<CR>')

--save and compile
--vim.keymap.set({"i","s"}, "jk", function() ls.expand_or_jump() vim.api.nvim_command('write') end, {silent = true})

-- Keymaps

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex" },
    callback = function()
        -- Keymaps for expanding and jumping in snippets
        vim.cmd[[
        imap <silent><expr> jk luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : 'jk'
        smap <silent><expr> jk luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : 'jk'

        imap <silent><expr> wq luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : 'wq'
        smap <silent><expr> wq  luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : 'wq'

        " Cycle forward through choice nodes
        imap <silent><expr> <C-j> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-j>'
        smap <silent><expr> <C-j> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-j>'
        imap <silent><expr> <C-k> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-k>'
        smap <silent><expr> <C-k> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-k>'
        ]]
    end
})

ls.config.set_config{
    -- Enable autotriggered snippets
    keep_roots = true, --Link children
    exit_roots = true, --Link children
    enable_autosnippets = true,
    link_children = true,
    updateevents = "TextChanged,TextChangedI", -- Update snippets as you type

    -- Use Tab (or some other key if you prefer) to trigger visual selection
    store_selection_keys = "<C-c>",
}
