" setting the leader key
let mapleader = " "

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

" setting tabs
:set expandtab
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2

" Remap 'jk' to Escape in insert mode
inoremap jk <Esc>

" Remap 'jkf' to Escape in insert mode
vnoremap jkf <Esc>

" making life easier
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap n nzzzv
nnoremap N Nzzzv

cabbrev ex Explore
cabbrev sex Sexplore
cabbrev vex Vexplore

" custom commands
command Open Texplore

" function to comment/uncomment code blocks
function! ToggleComment() range
    " Prompt for comment symbol
    let l:symbol = input('Enter comment symbol: ')
    if empty(l:symbol)
        return
    endif

    " Add a space after the symbol
    let l:symbol = l:symbol . ' '

    " Check if first line starts with the symbol
    let l:first_line = getline(a:firstline)
    let l:is_commented = (l:first_line[0:len(l:symbol)-1] ==# l:symbol)

    " Apply to all lines in selection
    for l:line_num in range(a:firstline, a:lastline)
        let l:line = getline(l:line_num)
        if l:is_commented
            " Remove comment if present
            if l:line[0:len(l:symbol)-1] ==# l:symbol
                call setline(l:line_num, l:line[len(l:symbol):])
            endif
        else
            " Add comment
            call setline(l:line_num, l:symbol . l:line)
        endif
    endfor
endfunction

" Map the function to <leader>/ in visual mode
vnoremap <leader>/ :call ToggleComment()<CR>
