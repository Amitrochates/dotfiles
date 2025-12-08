-----------------------------------------------------------
-- Basic Settings (Lua version of what you used before)
-----------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Tabs/spaces (you can adjust later)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Better search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep some context around cursor
vim.opt.scrolloff = 8

-- Faster update
vim.opt.updatetime = 100

-----------------------------------------------------------
-- Basic Keymaps
-----------------------------------------------------------
local map = vim.keymap.set

-- Space as leader
vim.g.mapleader = " "

-- Quick save
map("n", "<C-s>", "<cmd>w<cr>")

-- Quit
map("n", "<C-q>", "<cmd>q<cr>")
-----------------------------------------------------------
-- Autocmd Examples
-----------------------------------------------------------
-- Restore line numbers if plugins or modes hide them
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = true
  end,
})

