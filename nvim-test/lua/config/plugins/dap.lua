return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      { "rcarriga/nvim-dap-ui",            config = true },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    config = function()
      local dap, dapui = require "dap", require "dapui"
      require("nvim-dap-virtual-text").setup {
        highlight_changed_variables = true,
        show_stop_reason = true,
      }

      require("dap").defaults.fallback.force_pause = false -- don't break on all threads
      require("dap").defaults.fallback.focus_thread = true -- auto-focus first stopped thread

      dap.adapters.codelldb = {
        type       = 'server',
        port       = "${port}",
        executable = {
          command = vim.fn.stdpath("data")
              .. "/mason/packages/codelldb/extension/adapter/codelldb.exe",
          args = { "--port", "${port}" },
        },
      }
      -- Highlight for the “stopped” line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { fg = "#000000", bg = "#FFFF00" }) -- black text on yellow

      -- Replace the default arrow with an unobtrusive diamond (optional)
      vim.fn.sign_define("DapStopped", {
        text   = "◆", -- or "▶", "➜", "▸"
        texthl = "DapStoppedLine",
        linehl = "DapStoppedLine",
        numhl  = "DapStoppedLine",
      })
      -- key-maps
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue)
      map("n", "<leader>do", dap.step_over, { desc = "DAP step over" })
      map("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
      map("n", "<leader>du", dap.step_out, { desc = "DAP step out" })
      map("n", "<leader>db", dap.toggle_breakpoint,
        { desc = "DAP toggle breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input "Condition > ")
      end, { desc = "DAP conditional breakpoint" })
      map("n", "<leader>dt", dapui.toggle, { desc = "DAP-UI toggle" })

      -- auto-open/close UI
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end
    end,
  },
}
