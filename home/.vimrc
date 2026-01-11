runtime! ftplugin/man.vim

syntax off
filetype plugin off
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set breakindent
set linebreak
set autoindent
set smartindent
set formatoptions-=cro
set number
" set relativenumber
set numberwidth=1
set previewheight=20
" set keywordprg=:Man
set splitright
set makeprg=make

nnoremap j gj
nnoremap k gk
nnoremap K :vertical Man <cword><CR>
nnoremap gp :pclose<CR>
nnoremap co :cwindow<CR>
nnoremap cO :cclose<CR>
nnoremap mm :silent make all<Bar> redraw!<CR>
nnoremap mr :silent make run <Bar> redraw!<CR>
nnoremap mR :make run<CR>
nnoremap <CR> :write<CR>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
inoremap <C-j> <Esc>
inoremap <C-e> <C-o>$

let g:loaded_matchparen=1

" relative line numbers

" hi LineNr ctermfg=15
" hi LineNrAbove ctermfg=8
" hi LineNrBelow ctermfg=8

" normal line numbers

set cursorline
set cursorlineopt=number
hi LineNr ctermfg=7
hi CursorLineNr ctermfg=15 cterm=none

hi Visual ctermfg=0 ctermbg=4
hi ErrorMsg ctermfg=4 ctermbg=none
hi WarningMsg ctermfg=4 ctermbg=none
hi Question ctermfg=4 ctermbg=none
hi NonText ctermfg=0
hi PmenuSel ctermfg=0 ctermbg=4
hi Pmenu ctermfg=15 ctermbg=0
hi PmenuSbar ctermfg=0 ctermbg=0
hi StatusLine ctermfg=0 ctermbg=15
hi StatusLineNC ctermfg=0 ctermbg=15
hi VertSplit ctermfg=0 ctermbg=0
hi QuickFixLine ctermfg=0 ctermbg=4

set fillchars+=eob:\ 
set fillchars=vert:\│
