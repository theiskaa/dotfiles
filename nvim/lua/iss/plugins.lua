vim.cmd = [[packadd packer.nvim]]

return require('packer').startup(function() 
    -- File searching 
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'natebosch/vim-lsc'
    use 'preservim/nerdtree'
    use 'Xuyuanp/nerdtree-git-plugin'

    -- Appearance
    use 'kdheepak/vim-one'
    use 'itchyny/lightline.vim' 
    use 'bluz71/vim-moonfly-colors'
    use 'neovim/nvim-lspconfig'
    use 'mhartington/formatter.nvim'
    use 'owickstrom/vim-colors-paramount'
    -- color schemes 
    use 'joshdick/onedark.vim'
    use 'morhetz/gruvbox'
    use 'davidosomething/vim-colors-meh' " meh - let g:meh_pandoc_enabled = 1
    use 'sainnhe/gruvbox-material'
    use 'folke/tokyonight.nvim'
end)
