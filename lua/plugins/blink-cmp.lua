return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      menu = {
        border = "single",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
        },
      },
    })
  end,
}
