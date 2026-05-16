-- =============================================================================
--  core/keymaps.lua  –  skróty klawiszowe
-- =============================================================================

vim.g.mapleader      = " "   -- <Space> jako leader
vim.g.maplocalleader = " "

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- ── Ogólne ──────────────────────────────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<cr>",  "Zapisz")
map("n", "<leader>q", "<cmd>q<cr>",  "Zamknij")
map("n", "<Esc>",     "<cmd>noh<cr>","Wyczyść podświetlenie")

-- ── Nawigacja po oknach ─────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", "Okno lewo")
map("n", "<C-l>", "<C-w>l", "Okno prawo")
map("n", "<C-j>", "<C-w>j", "Okno dół")
map("n", "<C-k>", "<C-w>k", "Okno góra")

-- ── Podział okien ───────────────────────────────────────────────────────────
map("n", "<leader>sv", "<cmd>vsplit<cr>", "Podziel pionowo")
map("n", "<leader>sh", "<cmd>split<cr>",  "Podziel poziomo")

-- ── Bufory ──────────────────────────────────────────────────────────────────
map("n", "<S-l>", "<cmd>bnext<cr>",     "Następny bufor")
map("n", "<S-h>", "<cmd>bprevious<cr>", "Poprzedni bufor")
map("n", "<leader>x", "<cmd>bdelete<cr>","Zamknij bufor")

-- ── Przesuwanie linii (tryb wizualny) ───────────────────────────────────────
map("v", "J", ":m '>+1<cr>gv=gv", "Przesuń linię w dół")
map("v", "K", ":m '<-2<cr>gv=gv", "Przesuń linię w górę")

-- ── Zachowanie schowka przy wklejaniu ───────────────────────────────────────
map("v", "p", '"_dP', "Wklej bez nadpisania schowka")

-- ── LSP (aktywne gdy serwer podłączony) ─────────────────────────────────────
map("n", "gd",         vim.lsp.buf.definition,      "Przejdź do definicji")
map("n", "gD",         vim.lsp.buf.declaration,     "Przejdź do deklaracji")
map("n", "gr",         vim.lsp.buf.references,      "Referencje")
map("n", "K",          vim.lsp.buf.hover,           "Dokumentacja (hover)")
map("n", "<leader>rn", vim.lsp.buf.rename,          "Zmień nazwę")
map("n", "<leader>ca", vim.lsp.buf.code_action,     "Code action")
map("n", "<leader>f",  vim.lsp.buf.format,          "Formatuj plik")
map("n", "[d",         vim.diagnostic.goto_prev,    "Poprzedni błąd")
map("n", "]d",         vim.diagnostic.goto_next,    "Następny błąd")
map("n", "<leader>e",  vim.diagnostic.open_float,   "Pokaż błąd")

-- ── Telescope ───────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  "Szukaj plików")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   "Szukaj tekstu (grep)")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     "Lista buforów")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   "Pomoc")
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", "Diagnostyka LSP")

-- ── Drzewo plików ────────────────────────────────────────────────────────────
map("n", "<leader>t", "<cmd>NvimTreeToggle<cr>", "Drzewo plików")

-- ── Terminal ─────────────────────────────────────────────────────────────────
map("n", "<leader>T", "<cmd>terminal<cr>", "Otwórz terminal")
map("t", "<Esc>",     "<C-\\><C-n>",       "Wyjdź z trybu terminala")

-- ── Kompilacja / uruchamianie (C/C++) ───────────────────────────────────────
map("n", "<leader>cc", "<cmd>!gcc -Wall -Wextra -o %:r %<cr>",       "Kompiluj (gcc)")
map("n", "<leader>cx", "<cmd>!g++ -Wall -Wextra -std=c++17 -o %:r %<cr>", "Kompiluj (g++)")
map("n", "<leader>cr", "<cmd>!./%:r<cr>",                             "Uruchom")
