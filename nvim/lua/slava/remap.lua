vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)
-- Format only visually selected text
vim.keymap.set("v", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end)

-- TODO: get more idea about "quick fix" navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })                   -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })                 -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })                    -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })               -- close current split window

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Go to next buffer" })                    --  go to next tab
vim.keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Go to previous buffer" })                --  go to previous tab



-- open neogit
vim.keymap.set("n", "<leader>g", "<cmd>Neogit kind=vsplit<CR>")
-- open diffview
vim.keymap.set("n", "<leader>d", "<cmd>DiffviewFileHistory<CR>")


vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/dotfiles/mf<CR>")

-- Function to put the visually selected text into the search bar
local function put_visual_selection_in_search_bar()
    -- Save the current register contents
    local saved_reg = vim.fn.getreg('"')
    local saved_regtype = vim.fn.getregtype('"')

    -- Yank the visual selection into the unnamed register
    vim.cmd('normal! ""y')

    -- Get the selected text
    local text = vim.fn.getreg('"')

    -- Restore the old register contents
    vim.fn.setreg('"', saved_reg, saved_regtype)

    -- Remove newlines and escape special chars
    text = text:gsub("\n", "\\n")
    text = vim.fn.escape(text, [[\/]])

    if text == nil or text == '' then
        print("No visual selection")
        return
    end

    -- Feed '/' + text into command line without executing
    vim.api.nvim_feedkeys('/' .. text, 'n', false)
end

-- Create command and optional keymap
vim.api.nvim_create_user_command('SearchPromptVisual', put_visual_selection_in_search_bar, {})
vim.keymap.set('v', '<leader>a', put_visual_selection_in_search_bar, { noremap = true, silent = true })
