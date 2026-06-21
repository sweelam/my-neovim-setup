return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      -- Optional: configure notify settings
      background_colour = "#000000",
      timeout = 3000,
    })
    vim.notify = require("notify")
  end,
}
