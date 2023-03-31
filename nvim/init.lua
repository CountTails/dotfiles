-- main init.lua for neovim config

-- load neovim options
require('options')

-- load neovim plugins
require('plugins')
require('lualine').setup(require('config.lualine'))
require('nvim-autopairs').setup({})
require('nvim-treesitter.configs').setup(require('config.treesitter'))
require('mason').setup()
require('cmp').setup(require('config.cmp'))

-- load lsp config
require'lspconfig'.pylsp.setup{
    capabilities = require('cmp_nvim_lsp').default_capabilities()
}

-- load neovim colorscheme
require('onedark').load()

