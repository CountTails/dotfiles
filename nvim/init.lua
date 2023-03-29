-- main init.lua for neovim config

-- load neovim options
require('options')

-- load neovim plugins
require('plugins')
require('lualine').setup(require('config.lualine'))
require('nvim-autopairs')

-- load neovim colorscheme
require('onedark').load()

