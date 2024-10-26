-- using c-t to open terminal in the current directory
-- using c-i to open terminal in the home directory
-- get nvim-tree width

function get_nvim_tree_width()
    -- Get all the windows in the current tab
    local windows = vim.api.nvim_tabpage_list_wins(0)

    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        if ft == 'NvimTree' then
            return vim.api.nvim_win_get_width(win)
        end
    end

    return -1 -- Return 1 if nvim-tree is not open
end

-- open terminal in current directory

function cwd_term()
    local dir = vim.fn.expand('%:p:h')
    local terminal = require('toggleterm.terminal').Terminal:new({
        cmd = 'bash',
        dir = dir,
        direction = 'float',
        start_in_insert = true,
        float_opts = {
            border = 'rounded',
            width = vim.o.columns - get_nvim_tree_width() - 3,
            height = 10,
            col = vim.o.columns - get_nvim_tree_width(),
            row = vim.o.lines - 10,
        },
    }):toggle()
end

vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>lua cwd_term()<CR>', { noremap = true, silent = true })

require("toggleterm").setup{
    -- size can be a number or function which is passed the current terminal
    direction = 'float',
    open_mapping = '<C-y>', -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
    -- on_close = fun(t: Terminal), -- function to run when the terminal closes
    hide_numbers = true, -- hide the number column in toggleterm buffers
    on_open = function(term)
        vim.cmd('hi MsgArea guifg=#1d1f21')
        vim.cmd('hi ModeMsg guifg=#1d1f21')
    end,
    on_close = function(term)
        vim.cmd('hi MsgArea guifg=#c5c8c6')
        vim.cmd('hi ModeMsg guifg=#b5bd68')
    end,
    autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shading_factor = '-10',
    shading_ratio = '0',
    highlights = {
        -- highlights which map to a highlight group name and a table of it's values
        -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
        Normal = {
            guibg = "#1a1b1d",
        },
        NormalFloat = {
            guibg = "#17181A",
        },
        FloatBorder = {
            guifg = "#17181A",
            guibg = "#17181A",
        },
        MsgArea = {
            guifg = "#1d1f21",
            guibg = "#1d1f21",
        },
    },
    start_in_insert = true,
    insert_mappings = false,
    persist_size = true,
    persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
    -- Change the default shell. Can be a string or a function returning a string
    shell = vim.o.shell,
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
    float_opts = {
        border = 'rounded',
        width = vim.o.columns - get_nvim_tree_width() - 3,
        height = 10,
        col = vim.o.columns - get_nvim_tree_width(),
        row = vim.o.lines - 10,
    },
}
