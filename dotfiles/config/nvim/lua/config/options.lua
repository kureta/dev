-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use traditional vim clipboard setup
vim.o.clipboard = ""

-- Set swap, undo, and backup files and their locations
vim.o.directory = vim.fn.stdpath("data") .. "/swap//"
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup//"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15
