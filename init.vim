let g:ale_completion_enabled = 1

"vim-plug - needs installation first
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "see deoplete github for dependencies needed to install
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/deoplete-clangx'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'tell-k/vim-autopep8' "autopep8 needed 
Plug 'dense-analysis/ale' "clang for c, flake8 and pylint for python needed
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'edkolev/tmuxline.vim'

call plug#end()

"deoplete
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave * silent! pclose!

"ale
let g:ale_c_clang_options = '-Wall -pedantic -std=c11'
let g:ale_cpp_clang_options = '-Wall -pedantic -std=c++17'
let g:ale_c_gcc_options = '-Wall -pedantic -std=c11'
let g:ale_cpp_gcc_options = '-Wall -pedantic -std=c++17'

"theme
colorscheme gruvbox
set background=dark

"tmuxline/airline
let g:airline#extensions#tmuxline#enabled = 0

"autopep8
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>

"vanilla nvim
set number
set relativenumber
set updatetime=250 "gitgutter update
set noshowmode
set expandtab
set autoindent
set smartindent
set shiftwidth=4
syntax on
filetype plugin on

