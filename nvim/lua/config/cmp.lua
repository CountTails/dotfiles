return {
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args) vim.fn["vsnip#anonymous"](args.body) end
    },
    window = {
        completion = require('cmp').config.window.bordered(),
        documentation = require('cmp').config.window.bordered(),
    },
    mapping = require('cmp').mapping.preset.insert({
      ['<C-b>'] = require('cmp').mapping.scroll_docs(-4),
      ['<C-f>'] = require('cmp').mapping.scroll_docs(4),
      ['<C-Space>'] = require('cmp').mapping.complete(),
      ['<C-e>'] = require('cmp').mapping.abort(),
      ['<CR>'] = require('cmp').mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = require('cmp').config.sources({
      { 
          name = 'nvim_lsp' 
      },
      { 
          name = 'vsnip' 
      },
      {
          name = 'path'
      }
    }, 
    {
      { 
          name = 'buffer' 
      }
    })
}
