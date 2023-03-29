-- Plugin specification for neovim. 
-- Plugins managed by the Packer plugin managar
-- Load by calling `require(plugins)` in the main init.lua config file

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

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

end)
