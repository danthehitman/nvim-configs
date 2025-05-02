return {
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
      local capabilities          = require('blink.cmp').get_lsp_capabilities()
      capabilities.offsetEncoding = { "utf-16" }
      local util                  = require("lspconfig.util")
      require("lspconfig").lua_ls.setup { capatilities = capabilities }
      require("lspconfig").clangd.setup {
        cmd = {
          "clangd",
          "--background-index", -- full project indexing
          "--clang-tidy",       -- optional
          "--completion-style=detailed",
          "--header-insertion=never",
        },
        capabilities = capabilities,
        root_dir = util.root_pattern(
          "compile_commands.json",
          "compile_flags.txt",
          ".git"
        ),
        init_options = {
          compilationDatabaseDirectory = "build",
        },
      }
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
          end
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
