-- main init.lua for neovim config

-- load neovim options
require('options')

-- load neovim plugins
require('plugins')
require('lualine').setup(require('config.lualine'))
require('nvim-autopairs').setup({})
require('nvim-treesitter.configs').setup(require('config.treesitter'))
require('mason').setup()

-- load lsp config
require'lspconfig'.pylsp.setup{}

-- load neovim colorscheme
require('onedark').load()

