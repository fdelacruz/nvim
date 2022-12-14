local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  L = {
    name = "Rust",
    h = { "<cmd>RustToggleInlayHints<CR>", "Toggle Hints" },
    r = { "<cmd>RustRunnables<CR>", "Runnables" },
    -- r = { "<cmd>lua _CARGO_RUN()<CR>", "Cargo Run" },
    t = { "<cmd>lua _CARGO_TEST()<CR>", "Cargo Test" },
    m = { "<cmd>RustExpandMacro<CR>", "Expand Macro" },
    c = { "<cmd>RustOpenCargo<CR>", "Open Cargo" },
    p = { "<cmd>RustParentModule<CR>", "Parent Module" },
    -- j = { "<cmd>RustJoinLines<CR>", "Join Lines" },
    -- s = { "<cmd>RustStartStandaloneServerForBuffer<CR>", "Start Server Buf" },
    d = { "<cmd>RustDebuggables<CR>", "Debuggables" },
    v = { "<cmd>RustViewCrateGraph<CR>", "View Crate Graph" },
    R = {
      "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<CR>",
      "Reload Workspace",
    },
    -- S = { "<cmd>RustSSR<CR>", "SSR" },
    o = { "<cmd>RustOpenExternalDocs<CR>", "Open External Docs" },
    -- h = { "<cmd>RustSetInlayHints<CR>", "Enable Hints" },
    -- H = { "<cmd>RustDisableInlayHints<CR>", "Disable Hints" },
    -- a = { "<cmd>RustHoverActions<CR>", "Hover Actions" },
    -- a = { "<cmd>RustHoverRange<CR>", "Hover Range" },
    -- j = { "<cmd>RustMoveItemDown<CR>", "Move Item Down" },
    -- k = { "<cmd>RustMoveItemUp<CR>", "Move Item Up" },
  },
}

which_key.register(mappings, opts)

local notify_filter = vim.notify
vim.notify = function(msg, ...)
  if msg:match "message with no corresponding" then
    return
  end

  notify_filter(msg, ...)
end

vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })
