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
command W w
command Q q
command WQ wq
command Wq wq
filetype plugin indent on
syntax on

set background=light
colorscheme solarized

autocmd BufNewFile,BufRead *.pryrc set syntax=ruby
autocmd BufNewFile,BufRead *.pryrc source $HOME/.vim/indent/ruby.vim
