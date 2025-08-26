local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Search ❭ ") });
end)


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
