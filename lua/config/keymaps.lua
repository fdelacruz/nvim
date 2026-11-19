-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

keymap("n", "-", ":lua require'lir.float'.toggle()<CR>", { noremap = true, silent = true, desc = "Open lir" })
keymap("n", "<leader>;", ":lua Snacks.dashboard()<CR>", { noremap = true, silent = true, desc = "Open Dashboard" })

keymap("n", "P", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)
