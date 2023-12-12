-- Enable rounded borders in :LspInfo window.
require("lspconfig.ui.windows").default_options.border = "rounded"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {},
  },
}
