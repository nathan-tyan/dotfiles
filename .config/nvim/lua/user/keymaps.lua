vim.g.mapleader = ','
vim.g.maplocalleader = ','

local default_opts = { noremap = true, silent = true }
local map = vim.keymap.set

map('n', '<leader>r', '<cmd>source $MYVIMRC<cr>', default_opts)

map('n', '<leader>y', '"+yy', opts)
map('n', '<leader>p', '"+p', opts)
map('v', '<leader>y', '"+y', opts)
map('v', '<leader>p', '"+p', opts)
