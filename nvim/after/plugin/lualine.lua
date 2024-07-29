local lualine = require("lualine")
local lazy_status = require("lazy.status")     -- to configure lazy pending updates count

-- configure lualine with modified theme
lualine.setup({
    options = {
        theme = 'melange',
    },
    sections = {
        lualine_x = {
            {
                lazy_status.updates,
                cond = lazy_status.has_updates,
                -- color = { fg = "#ff9e64" },
            },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
        },
    },
})
