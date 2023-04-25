-- Plugin specification for neovim. 
-- Plugins managed by the Packer plugin managar
-- Load by calling `require(plugins)` in the main init.lua config file

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'

	use 'navarasu/onedark.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use {
        "windwp/nvim-autopairs",
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }


    use {
        "williamboman/mason.nvim",
        run = ":MasonUpdate" -- :MasonUpdate updates registry contents
    }

    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip'
    }

end)
