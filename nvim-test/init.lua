print("test app")

require("config.lazy")
require("mason").setup()

local util = require("lspconfig.util")
local path = util.path -- helper for path.join

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    local cwd  = vim.fn.getcwd()
    -- 1) find the directory that contains misc/nvim.lua
    local root = util.root_pattern("misc/nvim.lua")(cwd)
    if not root then
      return
    end

    -- 2) build the full filename
    local conf_file = path.join(root, "misc", "nvim.lua")
    -- 3) make sure it exists
    if vim.fn.filereadable(conf_file) == 1 then
      print("▶ Loading per-project config: " .. conf_file)
      dofile(conf_file)
    end
  end,
})

vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
