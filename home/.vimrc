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
set relativenumber
set numberwidth=1

nnoremap j gj
nnoremap k gk
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
inoremap <C-j> <Esc>
inoremap <C-e> <C-o>$

let g:loaded_matchparen=1

hi NonText ctermfg=0
hi LineNr ctermfg=8
set fillchars+=eob:\ 
