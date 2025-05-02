return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        'saghen/blink.cmp',
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      }
    },
    config = function()
      require("blink.cmp").setup({
        cmp_opts = {
          mapping = {
            ["<C-Space>"] = require("cmp").mapping.complete(),
            ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
            ["<Tab>"] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Insert }),
            ["<S-Tab>"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Insert }),
          },
        },
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local util         = require("lspconfig.util")
      require("lspconfig").lua_ls.setup { capatilities = capabilities }
      require("lspconfig").clangd.setup {
        cmd = {
          "clangd",
          "--background-index", -- full project indexing
          "--clang-tidy",       -- optional
          "--completion-style=detailed",
          "--header-insertion=never",
        },
        root_dir = util.root_pattern(
          "compile_commands.json",
          "compile_flags.txt",
          ".git"
        ),
        init_options = {
          compilationDatabaseDirectory = "build",
        },
      }
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
          end
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
            buffer = args.buf, desc = "LSP: Code Actions"
          })
          vim.keymap.set("n", "<leader>ta", require("telescope.builtin").lsp_code_actions, {
            buffer = args.buf, desc = "Telescope: Code Actions"
          })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = args.buf, desc = "LSP: Go to Definition"
          })
          -- references
          vim.keymap.set("n", "gr", vim.lsp.buf.references, {
            buffer = args.buf, desc = "LSP: Find References"
          })
          -- implementation
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
            buffer = args.buf, desc = "LSP: Go to Implementation"
          })
          -- hover
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {
            buffer = args.buf, desc = "LSP: Hover Documentation"
          })
          -- Auto-format ("lint") on save.
          -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
          if not client:supports_method('textDocument/willSaveWaitUntil')
              and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })
    end,
  }
}
