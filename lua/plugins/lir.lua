return {
  {
    "tamago324/lir.nvim",
    event = "User DirOpened",
    config = function()
      local actions = require("lir.actions")
      local mark_actions = require("lir.mark.actions")
      local clipboard_actions = require("lir.clipboard.actions")
      require("lir").setup({
        show_hidden_files = false,
        ignore = {}, -- { ".DS_Store", "node_modules" } etc.
        devicons = {
          enable = true,
          highlight_dirname = false,
        },
        mappings = {
          ["l"] = actions.edit,
          ["<C-s>"] = actions.split,
          ["<C-v>"] = actions.vsplit,
          ["<C-t>"] = actions.tabedit,

          ["h"] = actions.up,
          ["q"] = actions.quit,

          ["A"] = actions.mkdir,
          ["a"] = actions.newfile,
          ["r"] = actions.rename,
          ["@"] = actions.cd,
          ["Y"] = actions.yank_path,
          ["i"] = actions.toggle_show_hidden,
          ["D"] = actions.delete,

          ["J"] = function()
            mark_actions.toggle_mark()
            vim.cmd("normal! j")
          end,
          ["C"] = clipboard_actions.copy,
          ["X"] = clipboard_actions.cut,
          ["P"] = clipboard_actions.paste,
        },
        float = {
          winblend = 0,
          curdir_window = {
            enable = false,
            highlight_dirname = false,
          },

          -- You can define a function that returns a table to be passed as the third
          -- argument of nvim_open_win().
          win_opts = function()
            local width = math.floor(vim.o.columns * 0.7)
            local height = math.floor(vim.o.lines * 0.7)
            return {
              border = "rounded",
              width = width,
              height = height,
            }
          end,
        },
        get_filters = nil,
        hide_cursor = false,
        on_init = function()
          -- use visual mode
          vim.api.nvim_buf_set_keymap(
            0,
            "x",
            "J",
            ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
            { noremap = true, silent = true }
          )
        end,
      })

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "lir" },
        callback = function()
          -- use visual mode
          vim.api.nvim_buf_set_keymap(
            0,
            "x",
            "J",
            ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
            { noremap = true, silent = true }
          )

          -- echo cwd
          vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
        end,
      })

      -- custom folder icon
      require("nvim-web-devicons").set_icon({
        lir_folder_icon = {
          icon = "",
          color = "#7ebae4",
          name = "LirFolderNode",
        },
      })
    end,
  },
}
