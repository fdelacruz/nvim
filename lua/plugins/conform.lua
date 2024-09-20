return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      ["javascript"] = { "eslint" },
      ["javascriptreact"] = { "prettier" },
      ["python"] = { "black" },
    },
  },
}
