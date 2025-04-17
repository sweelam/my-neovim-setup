-- ~/.config/nvim/lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- your customizations here
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files by default
      },
    },
  },
}
