-- =============================================================================
--  core/lazy.lua  –  bootstrap lazy.nvim i lista pluginów
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-instalacja lazy.nvim przy pierwszym uruchomieniu
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ── Wygląd ────────────────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({
        flavour          = "mocha",
        integrations     = { treesitter = true, nvimtree = true, telescope = { enabled = true } },
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators   = "",
          component_separators = "│",
        },
        sections = {
          lualine_c = { { "filename", path = 1 } },   -- pełna ścieżka
        },
      })
    end,
  },

  -- Zakładki buforów (pasek u góry)
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = { diagnostics = "nvim_lsp" },
      })
    end,
  },

  -- ── Drzewo plików ─────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        view          = { width = 30 },
        renderer      = { group_empty = true },
        filters       = { dotfiles = false },
        git           = { enable = true },
      })
    end,
  },

  -- ── Treesitter (podświetlanie składni) ────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "bash", "cmake", "make" },
        highlight        = { enable = true },
        indent           = { enable = true },
        incremental_selection = {
          enable  = true,
          keymaps = {
            init_selection    = "<C-space>",
            node_incremental  = "<C-space>",
            node_decremental  = "<bs>",
          },
        },
      })
    end,
  },

  -- ── LSP ───────────────────────────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    build  = ":MasonUpdate",
    config = function() require("mason").setup() end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- clangd = serwer LSP dla C/C++
        ensure_installed = { "clangd" },
        automatic_installation = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig  = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
        },
        -- Wskazówki inlay (typy parametrów) – wymaga Neovim 0.10+
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })
    end,
  },

  -- ── Autouzupełnianie ──────────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible()            then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible()              then cmp.select_prev_item()
            elseif luasnip.jumpable(-1)   then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
          { name = "buffer"   },
          { name = "path"     },
        }),
        formatting = {
          format = function(entry, item)
            local icons = {
              Function = "󰊕", Method = "󰊕", Variable = "󰀫", Constant = "󰏿",
              Class = "󰠱", Struct = "", Interface = "", Module = "",
              Snippet = "", Text = "󰉿", Keyword = "󰌋",
            }
            item.kind = (icons[item.kind] or "") .. " " .. item.kind
            return item
          end,
        },
      })
    end,
  },

  -- ── Telescope (wyszukiwanie) ───────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config   = { preview_width = 0.55 },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ── Formatowanie kodu ─────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c   = { "clang_format" },
          cpp = { "clang_format" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
    end,
  },

  -- ── Użyteczne dodatki ─────────────────────────────────────────────────────

  -- Automatyczne pary nawiasów/cudzysłowów
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      -- Integracja z nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Komentowanie (gcc / gc + ruch)
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },

  -- Podświetlanie par nawiasów kolorami
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({})
    end,
  },

  -- Wskazówki wcięć (pionowe linie)
  {
    "lukas-reineke/indent-blankline.nvim",
    main   = "ibl",
    config = function() require("ibl").setup() end,
  },

  -- Git znaki na marginesie (+, -, ~)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add    = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          vim.keymap.set("n", "]h", gs.next_hunk,  { buffer = bufnr, desc = "Następna zmiana git" })
          vim.keymap.set("n", "[h", gs.prev_hunk,  { buffer = bufnr, desc = "Poprzednia zmiana git" })
          vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Podgląd zmiany" })
          vim.keymap.set("n", "<leader>gb", gs.blame_line,   { buffer = bufnr, desc = "Git blame" })
        end,
      })
    end,
  },

  -- Które-which-key – podpowiedzi skrótów po naciśnięciu <leader>
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    config = function() require("which-key").setup() end,
  },

  -- Szybkie przeskakiwanie (flash.nvim – jak easymotion)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function() require("flash").setup() end,
    keys = {
      { "s",     function() require("flash").jump()   end, desc = "Flash jump",   mode = { "n", "x", "o" } },
      { "S",     function() require("flash").treesitter() end, desc = "Flash Treesitter", mode = { "n" } },
    },
  },

  -- Otaczanie tekstu (ys / cs / ds)
  {
    "kylechui/nvim-surround",
    event  = "VeryLazy",
    config = function() require("nvim-surround").setup() end,
  },

  -- Dashboard startowy
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "                                   ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
            "                                   ",
          },
          center = {
            { action = "Telescope find_files", desc = " Szukaj pliku",    icon = " ", key = "f" },
            { action = "Telescope oldfiles",   desc = " Ostatnie pliki",  icon = "󰄉 ", key = "r" },
            { action = "NvimTreeToggle",       desc = " Drzewo plików",   icon = " ", key = "e" },
            { action = "Lazy",                 desc = " Pluginy (Lazy)",  icon = "󰒲 ", key = "p" },
            { action = "qa",                   desc = " Wyjście",         icon = " ", key = "q" },
          },
          footer = { "Neovim – C/C++ ready 🔧" },
        },
      })
    end,
  },

}, {
  -- Opcje lazy.nvim
  ui = { border = "rounded" },
  checker = { enabled = true, notify = false },  -- automatyczne sprawdzanie aktualizacji
})
