return {
  -- add gruvbox
  { "ray-x/aurora" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aurora",
    },
  },
}
