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

      dap.adapters.codelldb = {
        type    = 'server',
        port    = "${port}",
        executable = {
          command = vim.fn.stdpath("data")
                    .. "/mason/packages/codelldb/extension/adapter/codelldb.exe",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name    = "Launch CodenameGame3D",
          type    = "codelldb",
          request = "launch",
          program = "${workspaceFolder}/build/CodenameGame3D.exe",
          cwd     = "${workspaceFolder}/build",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- key-maps
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue)
      map("n", "<F10>", dap.step_over)
      map("n", "<F11>", dap.step_into)
      map("n", "<F12>", dap.step_out)
      map("n", "<Leader>b", dap.toggle_breakpoint)
      map("n", "<Leader>B", function()
        dap.set_breakpoint(vim.fn.input "Cond > ")
      end)

      -- auto-open/close UI
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end
    end,
  },
}

