local Util = require("lazyvim.util")

local hide_in_width = function()
  return vim.o.columns > 80
end

local lsp = {
  function()
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
      return ""
    end

    local buf_client_names = {}

    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        table.insert(buf_client_names, client.name)
      end
    end

    local unique_client_names = table.concat(buf_client_names)
    local language_servers = string.format("lsp: %s", unique_client_names)

    return language_servers
  end,
  color = { gui = "bold" },
  cond = hide_in_width,
}

local function env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch("([^/]+)") do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

local python_env = {
  function()
    if vim.bo.filetype == "python" then
      local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
      if venv then
        return string.format("ⓔ ", env_cleanup(venv))
      end
    end
    return ""
  end,
  color = { fg = "green" },
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_c = {
        Util.lualine.root_dir(),
        -- "diagnostics",
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { Util.lualine.pretty_path() },
        python_env,
        lsp,
      },
      lualine_y = {
        "location",
      },
      lualine_z = {
        "progress",
      },
    },
  },
}
