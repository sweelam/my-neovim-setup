return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({
      -- Default icon size is typically around 1
      -- You can increase it to make icons larger
      default = true,
      strict = true,
      override_by_filename = {
        [".gitignore"] = {
          icon = "",
          color = "#f1502f",
          name = "Gitignore",
        },
      },
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#81e043",
          name = "Log",
        },
      },
      -- The most important part for adjusting icon size:
      override = {
        default_icon = {
          icon = "",
          color = "#6d8086",
          name = "Default",
          -- Increase icon size by setting a larger font size
          font_size = 18, -- Adjust this value as needed
        },
      },
    })
  end,
}
