-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Open vertical split + terminal
vim.api.nvim_create_user_command("VST", function()
  vim.cmd("vsplit | terminal")
end, {})
