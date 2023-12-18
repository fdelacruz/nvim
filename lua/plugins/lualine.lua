local lsp = {
  function()
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
      return "LSP Inactive"
    end

    local formatters = require("conform").list_formatters()

    local buf_client_names = {}
    local buf_formatters = {}

    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        table.insert(buf_client_names, client.name)
      end
    end

    -- add formatter
    for _, formatter in pairs(formatters) do
      table.insert(buf_formatters, formatter.name)
    end

    vim.list_extend(buf_client_names, buf_formatters)

    local unique_client_names = table.concat(buf_client_names, ", ")
    local language_servers = string.format("[%s]", unique_client_names)

    return language_servers
  end,
  color = { gui = "bold" },
}

local icons = require("lazyvim.config").icons

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_x = {
        lsp,
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
        },
      },
      lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        "progress",
      },
    },
  },
}
