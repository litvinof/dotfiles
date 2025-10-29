-- vim.keymap.set("n", "<leader>h", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", { desc = "Open telecope buffers" })
vim.keymap.set("n", "<leader>h", function()
    require('telescope.builtin').buffers({
        sort_mru = true,
        sort_lastused = true,
        default_selection_index = 1,
    })
end, { desc = "Open telescope buffers" })
