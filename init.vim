"vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'

call plug#end()

set relativenumber
set updatetime=250
set noshowmode
syntax on

colorscheme gruvbox
set background=dark

filetype plugin on

