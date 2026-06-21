return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      -- Add escape key mapping for terminal mode
      { "<Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
    },

    opts = {
      direction = "float",
      -- ... other options
    },

    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
