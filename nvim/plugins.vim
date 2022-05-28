call plug#begin()
" File searching 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'natebosch/vim-lsc'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" General utilities. [Autocomplete, cheat SHITS and etc].
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'jbyuki/venn.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" Appearance
Plug 'kdheepak/vim-one'
Plug 'itchyny/lightline.vim' 
Plug 'bluz71/vim-moonfly-colors'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
Plug 'owickstrom/vim-colors-paramount'

" Go(lang)
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Dart/Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

call plug#end()
