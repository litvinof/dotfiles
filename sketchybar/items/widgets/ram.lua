local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "ram_update" for
-- the RAM load data, which is fired every 2.0 seconds.
sbar.exec("killall ram_load >/dev/null; $CONFIG_DIR/helpers/event_providers/ram_load/bin/ram_load ram_update 2.0")

local ram = sbar.add("graph", "widgets.ram", 42, {
    position = "right",
    graph = { color = colors.blue },
    background = {
        color = colors.transparent,
        border_width = 0,
        height = 22,
    },
    icon = {
        string = icons.ram,
        padding_right = 5,
    },
    label = {
        string = "ram ??%",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        align = "right",
        padding_right = 5,
        width = 7,
        y_offset = 4
    },
    -- padding_right = settings.paddings + 6
})

ram:subscribe("ram_update", function(env)
    -- Also available: env.user_load, env.sys_load
    local load = tonumber(env.used_percent)
    ram:push({ load / 100. })

    local color = colors.blue
    if load > 70 then
        if load < 80 then
            color = colors.yellow
        elseif load < 90 then
            color = colors.orange
        else
            color = colors.red
        end
    end

    ram:set({
        graph = { color = color },
        label = "ram " .. env.used_percent .. "%",
    })
end)

ram:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the RAM item
sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
    background = {
        color = colors.bgt,
        corner_radius = 15,
        border_width = 0,
    }
})

-- Background around the cpu item
sbar.add("item", "widgets.ram.padding", {
    position = "right",
    width = settings.group_paddings,
})
