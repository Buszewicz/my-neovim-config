-- =============================================================================
--  core/options.lua  –  ustawienia edytora
-- =============================================================================

local opt = vim.opt

-- Numeracja linii
opt.number         = true
opt.relativenumber = true

-- Wcięcia (C-style: 4 spacje)
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true

-- Wyszukiwanie
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = false
opt.incsearch      = true

-- Wygląd
opt.termguicolors  = true
opt.signcolumn     = "yes"
opt.cursorline     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.colorcolumn    = "100"

-- Zachowanie
opt.mouse          = "a"
opt.clipboard      = "unnamedplus"   -- współdzielony schowek z systemem
opt.undofile       = true            -- trwałe cofanie zmian
opt.swapfile       = false
opt.backup         = false
opt.updatetime     = 250

-- Podział okien
opt.splitbelow     = true
opt.splitright     = true

-- Uzupełnianie
opt.completeopt    = { "menuone", "noselect" }

-- Fold (składanie kodu) – zx/zo/zc
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldenable     = false           -- otwarte przy starcie
