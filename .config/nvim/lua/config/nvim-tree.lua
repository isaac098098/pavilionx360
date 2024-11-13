vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

function parent()
    local api = require('nvim-tree.api')
    api.tree.open()
    local node = api.tree.get_node_under_cursor()
    if node and node.parent then
        api.tree.change_root_to_node(node.parent)
    end
    api.tree.find_file({ focus = true })
end

-- Keybindigns
vim.keymap.set('n','<C-n>','<cmd>NvimTreeToggle<CR>')
-- vim.keymap.set('n','<leader>e','<cmd>NvimTreeFocus<CR>')
vim.api.nvim_set_keymap('n','<leader>e',':lua parent()<CR>', { noremap = true, silent = true })
vim.keymap.set('n','<localleader>tf','<cmd>NvimTreeFindFile<CR>')

local function attach(bufnr)
    local api = require 'nvim-tree.api'

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    -- Other keybindigns
    vim.keymap.set('n', '<C-p>', api.tree.change_root_to_parent, opts('Up'))
end

require("nvim-tree").setup {
    disable_netrw = true,
    on_attach = attach,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    -- open_on_tab  = true,
    update_focused_file = {
        enable = true,
        update_root = false,
    },
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 25,
        preserve_window_proportions = true,
    },
    renderer = {
        root_folder_label = false,
        highlight_git = true,
        group_empty = true,
        indent_markers = { enable = false},
        icons = {
            glyphs = {
                default = "󰈚",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                },
                git = { unmerged = "" },
            },
        },
    },
    filters = {
        dotfiles = false,
    },
}
