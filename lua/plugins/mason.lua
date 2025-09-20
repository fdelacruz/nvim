return {
  "mason-org/mason.nvim",
  opts = {
    ui = { border = "rounded" },
    ensure_installed = {
      "ruff",
      "pyright",
      "black",

      "emmet-ls",
      "html-lsp",
      "htmx-lsp",
      "css-lsp",
      "typescript-language-server",
      "eslint-lsp",
      "prettier",
      "jinja-lsp",

      "lua-language-server",
      "stylua",

      "shfmt",
      "shellcheck",

      "taplo",
    },
  },
}
