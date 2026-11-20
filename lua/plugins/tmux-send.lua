return {
  "tmux-send",
  name = "tmux-send",
  virtual = true,
  keys = {
    { "<leader>j", desc = "Send abs path+lines to last tmux pane (jump)" },
    { "<leader>J", desc = "Send abs path+lines to last tmux pane (stay)" },
    { "<leader>m", desc = "Send rel path+lines to last tmux pane (jump)" },
    { "<leader>M", desc = "Send rel path+lines to last tmux pane (stay)" },
  },
  config = function()
    local function exit_visual_mode()
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
    end

    local function get_range()
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" or mode == "\22" then
        local a, b = vim.fn.line("v"), vim.fn.line(".")
        return math.min(a, b), math.max(a, b)
      end
      local l = vim.fn.line(".")
      return l, l
    end

    local function in_tmux()
      return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
    end

    local function target_pane_cwd()
      if not in_tmux() then
        return nil
      end
      local out = vim.fn.system({ "tmux", "display-message", "-p", "-t", "!", "#{pane_current_path}" })
      if vim.v.shell_error ~= 0 then
        return nil
      end
      return vim.trim(out)
    end

    local function path_with_lines(relative)
      local file_dir = vim.fn.expand("%:p:h")
      local pane_cwd = target_pane_cwd()
      -- Normalize both sides: strip trailing slashes and resolve symlinks.
      file_dir = vim.fn.resolve(file_dir)
      if pane_cwd then
        pane_cwd = pane_cwd:gsub("/+$", "")
        pane_cwd = vim.fn.resolve(pane_cwd)
      end
      local path
      if pane_cwd and pane_cwd == file_dir then
        -- Same directory as the target pane: send just the filename.
        path = vim.fn.expand("%:t")
      else
        path = vim.fn.expand(relative and "%:." or "%:p")
      end
      local s, e = get_range()
      local ref = s == e and ("%s:%d"):format(path, s) or ("%s:%d-%d"):format(path, s, e)
      return "@" .. ref
    end

    local function send_to_last_pane(text, jump)
      if not in_tmux() then
        vim.notify("tmux-send: not running inside tmux", vim.log.levels.WARN)
        return
      end
      vim.fn.system({ "tmux", "send-keys", "-t", "!", "-l", "--", " " .. text .. " " })
      if vim.v.shell_error ~= 0 then
        vim.notify("tmux-send: failed to send to last pane", vim.log.levels.WARN)
        return
      end
      if jump then
        vim.fn.system({ "tmux", "last-pane" })
        if vim.v.shell_error ~= 0 then
          vim.notify("tmux-send: failed to switch to last pane", vim.log.levels.WARN)
        end
      end
    end

    local specs = {
      { lhs = "<leader>j", relative = false, jump = true, desc = "Send abs path+lines to last tmux pane (jump)" },
      { lhs = "<leader>J", relative = false, jump = false, desc = "Send abs path+lines to last tmux pane (stay)" },
      { lhs = "<leader>m", relative = true, jump = true, desc = "Send rel path+lines to last tmux pane (jump)" },
      { lhs = "<leader>M", relative = true, jump = false, desc = "Send rel path+lines to last tmux pane (stay)" },
    }

    for _, spec in ipairs(specs) do
      vim.keymap.set({ "n", "v" }, spec.lhs, function()
        local text = path_with_lines(spec.relative)
        exit_visual_mode()
        send_to_last_pane(text, spec.jump)
      end, { desc = spec.desc })
    end
  end,
}
