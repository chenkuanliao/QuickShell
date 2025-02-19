" Status bar
set laststatus=2

" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1

" turn relative line numbers on
:set relativenumber
:set rnu
:set nu

" setting cursorline
:set cursorline

" Set tab width to 4 columns.
:set tabstop=4

" Remap 'jk' to Escape in insert mode
inoremap jk <Esc>

" making life easier
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap n nzzzv
nnoremap N Nzzzv

" custom commands
command Open Texplore
