local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Search ❭ ") });
end)

vim.keymap.set('v', '<leader>pS', function()
    -- Save current register contents
    local saved_reg = vim.fn.getreg('"')
    local saved_regtype = vim.fn.getregtype('"')

    -- Yank visual selection into unnamed register
    vim.cmd('normal! ""y')
    local text = vim.fn.getreg('"')

    -- Restore old register
    vim.fn.setreg('"', saved_reg, saved_regtype)

    -- Trim and sanitize selection
    text = text:gsub("\n", " "):gsub("^%s+", ""):gsub("%s+$", "")

    if text == nil or text == '' then
        print("No visual selection")
        return
    end

    -- Launch Telescope grep_string with the selected text
    builtin.grep_string({ search = text })
end, { desc = "Global search for selected text" })


require('telescope').setup({
    pickers = {
        find_files = {
            hidden = true,
        }
    },
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".git"
        },
        initial_mode = "insert"
    }
})
