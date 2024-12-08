syntax off
set tabstop=4
set shiftwidth=4
set expandtab
set breakindent
set linebreak
set autoindent

nnoremap j gj
nnoremap k gk
vnoremap <S-u> <Esc>
snoremap <S-u> <Esc>
inoremap <S-u> <Esc>
inoremap <C-e> <C-o>$

let g:loaded_matchparen=1

hi NonText ctermfg=0

" autocmd VimEnter * if
    " \ argc() == 0 &&
    " \ bufname("%") == "" |
    " \   exe "normal! `0" |
    " \ endif
