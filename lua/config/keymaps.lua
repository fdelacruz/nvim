-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

keymap("n", "-", ":lua require'lir.float'.toggle()<CR>", { noremap = true, silent = true, desc = "Open lir" })
keymap("n", ";", ":lua Snacks.dashboard()<CR>", { noremap = true, silent = true, desc = "Open Dashboard" })

keymap("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>", { silent = true, desc = "Navigate Left" })
keymap("n", "<C-j>", ":NvimTmuxNavigateDown<CR>", { silent = true, desc = "Navigate Down" })
keymap("n", "<C-k>", ":NvimTmuxNavigateUp<CR>", { silent = true, desc = "Navigate UP" })
keymap("n", "<C-l>", ":NvimTmuxNavigateRight<CR>", { silent = true, desc = "Navigate Right" })
keymap("n", "<C-\\>", ":NvimTmuxNavigateLastActive<CR>", { silent = true, desc = "Navigate Last Active" })
keymap("n", "<C-Space>", ":NvimTmuxNavigateNext<CR>", { silent = true, desc = "Navigate Next" })
