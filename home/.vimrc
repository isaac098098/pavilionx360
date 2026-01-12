runtime ftplugin/man.vim

let g:loaded_matchparen=1

filetype plugin off
syntax off
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set breakindent
set linebreak
set autoindent
set smartindent
set formatoptions-=cro
" set number
" set relativenumber
" set numberwidth=1
set previewheight=20
" set keywordprg=:Man
set splitright
set makeprg=make
set noruler
set noshowmode
set noshowcmd
set shortmess+=cClWIF
set report=20
set laststatus=0
set completeopt=menu,noselect,menuone
set fillchars+=eob:\ 
set fillchars=vert:\│

nnoremap j gj
nnoremap k gk
nnoremap gp :pclose<CR>
nnoremap co :cwindow<CR>
nnoremap cO :cclose<CR>
nnoremap K <Cmd>silent! vertical Man <cword><CR>
nnoremap mm :silent make all<Bar> redraw!<CR>
nnoremap mr :silent make run <Bar> redraw!<CR>
nnoremap mR :make run<CR>
nnoremap u <Cmd>silent! undo<CR>
nnoremap <C-r> <Cmd>silent! redo<CR>
vnoremap <C-j> <Esc>
vnoremap K <Cmd>silent! vertical Man <cWORD><CR>
snoremap <C-j> <Esc>
inoremap <C-j> <Esc>
inoremap <C-e> <C-o>$

set cursorline
set cursorlineopt=number
set statusline=\ 

" normal line numbers
hi LineNrBelow ctermfg=8
hi LineNr ctermfg=7

" relative line numbers
" hi LineNr ctermfg=15
" hi LineNrAbove ctermfg=8
" hi LineNrBelow ctermfg=8

hi CursorLineNr ctermfg=15 cterm=none
hi Visual ctermfg=0 ctermbg=4
hi ErrorMsg ctermfg=15 ctermbg=none
hi WarningMsg ctermfg=15 ctermbg=none
hi Question ctermfg=15 ctermbg=none
hi NonText ctermfg=0
hi PmenuSel ctermfg=0 ctermbg=4
hi Pmenu ctermfg=15 ctermbg=0
hi PmenuSbar ctermfg=0 ctermbg=0
hi StatusLine ctermfg=0 ctermbg=0 cterm=NONE
hi StatusLineNC ctermfg=0 ctermbg=15
hi VertSplit ctermfg=0 ctermbg=0
hi QuickFixLine ctermfg=0 ctermbg=4
hi TabLineSel ctermfg=0 ctermbg=4
hi TabLine ctermfg=15 ctermbg=0 cterm=NONE
hi TabLineFill ctermfg=0 ctermbg=0

augroup ManClean
  autocmd!
  autocmd FileType man silent! g/^troff:.*/d
augroup END
