local Util = require("lazyvim.util")
local icons = LazyVim.config.icons

local mode_map = {
  ["n"] = "NORMAL",
  ["i"] = "INSERT",
  ["R"] = "REPLACE ",
  ["c"] = "COMMAND",
  ["v"] = "VISUAL",
  ["V"] = "VIS-LN",
  [""] = "VIS-BLK ",
  ["s"] = "SELECT",
  ["S"] = "SEL-LN",
  [""] = "SEL-BLK",
  ["t"] = "TERMINAL",
  ["Rv"] = "VIR-REP",
  ["rm"] = "- More -",
  ["r"] = "- Hit-Enter -",
  ["r?"] = "- Confirm -",
  ["cv"] = "VIM Ex Mode",
  ["ce"] = "NORMAL Ex Mode",
  ["!"] = "Shell Running",
  ["ic"] = "Insert mode completion |compl-generic|",
  ["no"] = "OPERATOR-PENDING",
  ["nov"] = "OPERATOR-PENDING",
  ["noV"] = "OPERATOR-PENDING",
  ["noCTRL-V"] = "OPERATOR-PENDING",
  ["niI"] = "INSERT (NORMAL)",
  ["niR"] = "REPLACE (NORMAL)",
  ["niV"] = "VIRTUAL-REPLACE (NORMAL)",
  ["ix"] = "INSERT",
  ["Rc"] = "REPLACE",
  ["Rx"] = "REPLACE",
}

local mode = {
  function()
    return mode_map[vim.api.nvim_get_mode().mode] or "__"
  end,
}

local hide_in_width = function()
  return vim.o.columns > 80
end

-- Cache-friendly LSP client names for the current buffer.
local lsp = {
  function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return ""
    end

    local names = {}
    for _, client in ipairs(clients) do
      if client.name ~= "null-ls" and client.name ~= "none-ls" then
        names[#names + 1] = client.name
      end
    end

    return table.concat(names, ", ")
  end,
  color = { fg = "#081633", gui = "bold" },
  cond = hide_in_width,
}

-- Keep only the last path segment of a virtualenv path.
local function env_cleanup(venv)
  return venv:match("([^/]+)/?$") or venv
end

local python_env = {
  function()
    if vim.bo.filetype ~= "python" then
      return ""
    end

    local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
    if not venv or venv == "" then
      return ""
    end

    return env_cleanup(venv)
  end,
  color = { fg = "#f9e2af", gui = "bold" },
  cond = hide_in_width,
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    -- Defer setting the real statusline until lualine loads (LazyVim pattern).
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: avoid lualine's own (slower) require indirection.
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { mode },
        lualine_c = {
          Util.lualine.root_dir(),
          {
            Util.lualine.pretty_path(),
            cond = hide_in_width,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            cond = hide_in_width,
          },
          python_env,
        },
        lualine_x = {
          -- stylua: ignore
          {
            function()
              if not package.loaded["noice"] then
                return ""
              end
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Statement") }
            end,
          },
          -- stylua: ignore
          {
            function()
              if not package.loaded["noice"] then
                return ""
              end
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Constant") }
            end,
          },
          -- stylua: ignore
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = function()
              return { fg = Snacks.util.color("Debug") }
            end,
          },
          -- stylua: ignore
          {
            function()
              local ok, mod = pcall(require, "sidekick.status")
              if not ok then
                return ""
              end
              local status = mod.cli()
              return " " .. (#status > 1 and #status or "")
            end,
            cond = function()
              local ok, mod = pcall(require, "sidekick.status")
              return ok and #mod.cli() > 0
            end,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
          },
          lsp,
          { "filetype", icon_only = true, separator = "", padding = { left = 0, right = 1 } },
        },
        lualine_y = {
          { "encoding", padding = { left = 1, right = 0 } },
          {
            "fileformat",
            symbols = {
              unix = "[unix]",
              dos = "[dos]",
              mac = "[mac]",
            },
            padding = { left = 1, right = 0 },
          },
          "location",
        },
        lualine_z = {
          "progress",
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }
  end,
}