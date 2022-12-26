call plug#begin()
" File searching 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'natebosch/vim-lsc'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" General utilities. [Autocomplete, cheat SHITS and etc].
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'jbyuki/venn.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'Raimondi/delimitMate'

Plug 'ms-jpq/coq_nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Appearance
Plug 'kdheepak/vim-one'
Plug 'itchyny/lightline.vim' 
Plug 'bluz71/vim-moonfly-colors'
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
Plug 'owickstrom/vim-colors-paramount'
" color schemes 
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'davidosomething/vim-colors-meh' " meh - let g:meh_pandoc_enabled = 1
Plug 'sainnhe/gruvbox-material'
Plug 'folke/tokyonight.nvim'
Plug 'jonstoler/werewolf.vim'
Plug 'axvr/photon.vim'
Plug 'projekt0n/github-nvim-theme'

" Rust
Plug 'rust-lang/rust.vim'

" Go(lang)
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Dart/Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

call plug#end()

" Rust plugin customization
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

