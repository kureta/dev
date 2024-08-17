-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- better up/down
map({ "n" }, "<leader>cc", ":CMakeClean<CR>", { desc = "Cmake clean" })
map({ "n" }, "<leader>cb", ":CMakeBuild<CR>", { desc = "Cmake build" })
map({ "n" }, "<leader>cx", ":CMakeRun<CR>", { desc = "Cmake run (execute)" })
