syntax on
set nu
set rnu
colorscheme jellybeans 

set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set cursorline
filetype indent on
set wildmenu
set showmatch
set incsearch
set hlsearch
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf

augroup configgroup
    autocmd!
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

set list
set listchars=trail:_,tab:\|\ 

let g:ale_echo_msg_format = '%linter%: %s'
"let g:ale_enabled=0
