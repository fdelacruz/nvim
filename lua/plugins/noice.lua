return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "msg_show",
        kind = "echo",
      },
      opts = {
        skip = true,
      },
    })
    return vim.tbl_deep_extend("force", opts, {
      lsp = {
        progress = {
          enabled = false,
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    })
  end,
}
