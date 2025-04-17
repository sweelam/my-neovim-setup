return {
  {
    "catppuccin/nvim",
    name = "mocha",
    priority = 0,
  },
  {
    "shaunsingh/solarized.nvim",
    config = function()
      -- vim.cmd("colorscheme solarized")
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      -- Configure Gruvbox options (optional)
      require("gruvbox").setup({})

      -- Set Gruvbox as the colorscheme
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
