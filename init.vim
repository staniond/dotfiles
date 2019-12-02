"vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "see deoplete github for dependencies needed to install
Plug 'deoplete-plugins/deoplete-jedi'

call plug#end()

"deoplete
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave * silent! pclose!

"theme
colorscheme gruvbox
set background=dark

"vanilla nvim
set number
set relativenumber
set updatetime=250 "gitgutter update
set noshowmode
syntax on
filetype plugin on

