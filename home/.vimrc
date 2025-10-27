syntax off
filetype plugin on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set breakindent
set linebreak
set autoindent
set smartindent
set number
" set relativenumber
set numberwidth=1

nnoremap j gj
nnoremap k gk
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
inoremap <C-j> <Esc>
inoremap <C-e> <C-o>$

hi NonText ctermfg=0

" relative line numbers
" hi LineNr ctermfg=7
" hi LineNrAbove ctermfg=7
" hi LineNrBelow ctermfg=7

" normal line numbers
set cursorline
set cursorlineopt=number
hi LineNr ctermfg=7
hi CursorLineNr ctermfg=15 cterm=none

hi Visual ctermfg=0 ctermbg=4
hi ErrorMsg ctermfg=4 ctermbg=none
hi WarningMsg ctermfg=4 ctermbg=none
hi Question ctermfg=4 ctermbg=none

let g:loaded_matchparen=1

set fillchars+=eob:\ 
