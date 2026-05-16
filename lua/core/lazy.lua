-- =============================================================================
--  core/lazy.lua
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "mocha",

        integrations = {
          treesitter = true,
          nvimtree = true,
          telescope = {
            enabled = true,
          },
        },
      })

      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = "",
          component_separators = "│",
        },

        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },
        },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",

    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "thin",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",

    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },

        renderer = {
          group_empty = true,
        },

        filters = {
          dotfiles = false,
        },

        git = {
          enable = true,
        },
      })
    end,
  },

  -- Treesitter
{
  "nvim-treesitter/nvim-treesitter",

  build = ":TSUpdate",

  event = {
    "BufReadPre",
    "BufNewFile",
  },

  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")

    if not ok then
      return
    end

    configs.setup({
      ensure_installed = {
        "c",
        "cpp",
        "lua",
        "vim",
        "bash",
        "cmake",
        "make",
        "python",
        "javascript",
        "typescript",
        "rust",
        "go",
      },

      sync_install = false,

      auto_install = true,

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,

        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
    })
  end,
},

  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",

    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",

    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "pyright",
          "tsserver",
          "rust_analyzer",
          "gopls",
          "lua_ls",
        },

        automatic_installation = true,
      })
    end,
  },
  
-- LSP
{
  "neovim/nvim-lspconfig",

  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },

  config = function()
    local capabilities =
      require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      "clangd",
      "pyright",
      "ts_ls",
      "rust_analyzer",
      "gopls",
      "lua_ls",
    }

    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })

      vim.lsp.enable(server)
    end
  end,
},

  -- Completion
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
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),

          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()

            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()

            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()

            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)

            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),

        formatting = {
          format = function(_, item)
            local icons = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "󰏗",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "󰕘",
              Keyword = "󰌋",
              Snippet = "󰘍",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "󰕘",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰊄",
            }

            item.kind = (icons[item.kind] or "") .. " " .. item.kind
            return item
          end,
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",

          layout_config = {
            preview_width = 0.55,
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",

    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { "clang_format" },
          cpp = { "clang_format" },
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
        },

        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",

    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })

      local cmp_autopairs =
        require("nvim-autopairs.completion.cmp")

      require("cmp").event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",

    config = function()
      require("Comment").setup()
    end,
  },

  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",

    config = function()
      require("rainbow-delimiters.setup").setup({})
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",

    config = function()
      require("ibl").setup()
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("gitsigns").setup({
        signs = {
          add = {
            text = "│",
          },

          change = {
            text = "│",
          },

          delete = {
            text = "_",
          },
        },
      })
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    config = function()
      require("which-key").setup()
    end,
  },

  -- Flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",

    config = function()
      require("flash").setup()
    end,

    keys = {
      {
        "s",

        function()
          require("flash").jump()
        end,

        desc = "Flash jump",
        mode = { "n", "x", "o" },
      },

      {
        "S",

        function()
          require("flash").treesitter()
        end,

        desc = "Flash Treesitter",
        mode = { "n" },
      },
    },
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",

    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("dashboard").setup({
        theme = "doom",

        config = {
          header = {
            "",
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            "",
          },

          center = {
            {
              action = "Telescope find_files",
              desc = "Find file",
              icon = "󰈞 ",
              key = "f",
            },

            {
              action = "Telescope oldfiles",
              desc = "Recent files",
              icon = "󰄉 ",
              key = "r",
            },

            {
              action = "NvimTreeToggle",
              desc = "File explorer",
              icon = "󰙅 ",
              key = "e",
            },

            {
              action = "Lazy",
              desc = "Plugins",
              icon = "󰒲 ",
              key = "p",
            },

            {
              action = "qa",
              desc = "Quit",
              icon = "󰅚 ",
              key = "q",
            },
          },

          footer = {
            "Neovim configured for modern development",
          },
        },
      })
    end,
  },

}, {

  ui = {
    border = "rounded",
  },

  checker = {
    enabled = true,
    notify = false,
  },

})
