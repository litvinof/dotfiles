function ColorItBaby(color)
    color = color or "melange"

    -- Enable italics in melange theme
    vim.g.melange_enable_font_variants = {
        bold = true,
        italic = true, -- Enable italics globally
        underline = true,
        undercurl = true,
        strikethrough = true
    }

    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#727272" })

    -- Disable italics for everything except Comment
    local no_italic_groups = {
        "String",
        "@string.special.symbol",
        "@lsp.typemod.variable.globalScope",
        "@markup.italic",
    }

    for _, group in ipairs(no_italic_groups) do
        local hl = vim.api.nvim_get_hl(0, { name = group })
        if next(hl) ~= nil then -- Check if highlight group exists
            hl.italic = false
            vim.api.nvim_set_hl(0, group, hl)
        end
    end
end

ColorItBaby()
