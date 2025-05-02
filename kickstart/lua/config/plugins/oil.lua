return {
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<M-h>'] = 'action.select_split',
        },
        view_options = {
          show_hidden = true,
        },
      }
      vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })
      vim.keymap.set('n', '<space>-', require('oil').toggle_float, { desc = 'Toggle float' })
    end,
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
