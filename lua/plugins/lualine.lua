return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        "progress",
      },
    },
  },
}
