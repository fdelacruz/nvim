return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      ["javascript"] = { "prettier" },
      ["javascriptreact"] = { "prettier" },
      ["python"] = { "ruff_organize_imports", "ruff_format" },
      ["html"] = { "prettier" },
      ["htmldjango"] = { "djlint" },
    },
  },
}
