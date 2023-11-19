return {
  pylsp = {
    plugins = {
      pycodestyle = {
        ignore = { "W391", "E501" },
        maxLineLength = 100,
      },
    },
  },
}
