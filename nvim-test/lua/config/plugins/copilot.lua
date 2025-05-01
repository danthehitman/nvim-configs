return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          next = "<C-]>",
          -- prev = "<C-[>",
          dismiss = "<C-\\>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
        -- Enable for anything else you want
      },
    },
  }
}
