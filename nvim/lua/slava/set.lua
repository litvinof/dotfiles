vim.opt.guicursor = ""
vim.wo.wrap = false
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.showtabline = 1

vim.opt.smartindent = true

vim.opt.swapfile = false 
vim.opt.backup = false 
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true 

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes" 
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = false

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_user_command("Cppath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_augroup("SearchHighlight", {})
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = {"/", "?"}, -- when entering search
  callback = function()
    vim.o.hlsearch = true
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = {"/", "?"}, -- when leaving search
  callback = function()
    vim.o.hlsearch = false
  end,
})
