local lualine = require("lualine")
local lazy_status = require("lazy.status")     -- to configure lazy pending updates count

-- configure lualine with modified theme
lualine.setup({
    options = {
        -- theme = 'melange',
        theme = 'auto',
        icons_enabled = true,
        jomponent_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    },
    sections = {
        lualine_a = {
            {
                'mode',
                fmt = function(str)
                    return str:sub(1, 1) -- shorten mode to first letter
                end,
            },
        },
        lualine_c = {
            {
                'filename',
                file_status = true, -- displays file status (readonly status, modified status)
                path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = {
            {
                lazy_status.updates,
                cond = lazy_status.has_updates,
                -- color = { fg = "#ff9e64" },
            },
            { "encoding" },
            -- { "fileformat" },
            { "filetype" },
        },
    },

})
