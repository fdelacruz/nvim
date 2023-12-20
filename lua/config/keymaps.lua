-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

keymap("n", "-", ":lua require'lir.float'.toggle()<CR>", { noremap = true, silent = true, desc = "Open lir" })
keymap("n", ";", ":Dashboard<CR>", { noremap = true, silent = true, desc = "Open Dashboard" })
