set tabstop=4
set shiftwidth=4
set smartindent
set noexpandtab
set list lcs=tab:\ \ 
set number
set splitbelow
set splitright
set ignorecase
set smartcase
set incsearch
set hlsearch
set scrolloff=8
set mouse=a
command W w
command Q q
command WQ wq
command Wq wq
command CQ cq
command Cq cq
map Y y$
filetype plugin indent on
syntax on

set background=light
silent! colorscheme solarized

autocmd BufNewFile,BufRead *.pryrc set syntax=ruby
autocmd BufNewFile,BufRead *.pryrc source $HOME/.vim/indent/ruby.vim

" Jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let g:markdown_recommended_style = 0
let g:python_recommended_style = 0

" vim-gitgutter
let g:gitgutter_enabled = 1
highlight! link SignColumn LineNr
set updatetime=100
