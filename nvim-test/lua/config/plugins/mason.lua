return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- NEW: auto-installer for tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- DAP adapters
        "codelldb", -- LLDB / Rust / C++
        "cpptools", -- MS cppdbg (if you still want it)

        -- LSP servers (examples)
        "clangd",
        "lua-language-server",

        -- Formatters / linters (examples)
        "clang-format",
        "stylua",
      },

      -- run on startup once per day (defaults)
      auto_update = false,
      run_on_start = true,
      start_delay = 3000, -- ms
    },
  },
}
