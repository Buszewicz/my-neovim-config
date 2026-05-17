-- =============================================================================
--  core/keymaps.lua
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- General
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>q", "<cmd>q<cr>", "Quit")
map("n", "<Esc>", "<cmd>noh<cr>", "Clear search highlight")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Focus left window")
map("n", "<C-l>", "<C-w>l", "Focus right window")
map("n", "<C-j>", "<C-w>j", "Focus lower window")
map("n", "<C-k>", "<C-w>k", "Focus upper window")

-- Splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", "Vertical split")
map("n", "<leader>sh", "<cmd>split<cr>", "Horizontal split")

-- Buffers
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<leader>x", "<cmd>bdelete<cr>", "Close buffer")

-- Move selected lines
map("v", "J", ":m '>+1<cr>gv=gv", "Move line down")
map("v", "K", ":m '<-2<cr>gv=gv", "Move line up")

-- Preserve clipboard while pasting
map("v", "p", '"_dP', "Paste without yanking")

-- LSP
map("n", "gd", vim.lsp.buf.definition, "Go to definition")
map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
map("n", "gr", vim.lsp.buf.references, "References")
map("n", "K", vim.lsp.buf.hover, "Hover documentation")
map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
map("n", "<leader>f", vim.lsp.buf.format, "Format file")
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", "Find files")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", "Live grep")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", "Buffers")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", "Help tags")
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", "Diagnostics")

-- File explorer
map("n", "<leader>t", "<cmd>NvimTreeToggle<cr>", "Toggle file explorer")

-- Terminal
map("n", "<leader>T", "<cmd>terminal<cr>", "Open terminal")
map("t", "<Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- Build / Run (C/C++)
map("n", "<leader>cc", "<cmd>!gcc -Wall -Wextra -o %:r %<cr>", "Compile with gcc")
map("n", "<leader>cx", "<cmd>!g++ -Wall -Wextra -std=c++17 -o %:r %<cr>", "Compile with g++")
map("n", "<leader>cr", "<cmd>!./%:r<cr>", "Run executable")

-- My

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
