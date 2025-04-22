set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'rust-lang/rust.vim'
Plugin 'valloric/youcompleteme'
Plugin 'wellle/context.vim'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'luochen1990/rainbow'
Plugin 'kblin/vim-fountain'
Plugin 'vim-voom/voom'

" YouCompleteMe settings
set runtimepath+=~/.vim/bundle/YouCompleteMe/

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
syntax on
set nu
set rnu
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}
if has('termguicolors') && &termguicolors
    let g:jellybeans_overrides['background']['guibg'] = 'none'
endif
colorscheme jellybeans

set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set cursorline
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
    au!
    au FileType python setlocal commentstring=#\ %s
    au FileType Makefile setlocal noexpandtab
    au FileType fountain setlocal spell
    au BufEnter *.sh setlocal tabstop=2
    au BufEnter *.sh setlocal shiftwidth=2
    au BufEnter *.sh setlocal softtabstop=2
augroup END

set list
set listchars=trail:_,tab:\|\ 

let g:rainbow_active=1

let g:ale_echo_msg_format = '%linter%: %s'
set completeopt=menu,menuone,preview,noselect,noinsert
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_virtualtext_cursor=0
let g:ale_completion_enabled=1
let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }
let g:ale_linters = {
\   'rust': ['cargo', 'rls'],
\}
"let g:ale_enabled=0

" Disable Copilot by default
" let g:copilot_enabled = v:false
