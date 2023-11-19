return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "W391", "E501" },
            maxLineLength = 100,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = false,
            },
          },
        },
      },
    },
  },
}
