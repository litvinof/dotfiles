local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

for i = 1, 10, 1 do
    local space = sbar.add("space", "space." .. i, {
        space = i,
        icon = {
            font = { family = settings.font.numbers },
            string = i,
            padding_left = 15,
            padding_right = 8,
            color = colors.white,
            highlight_color = colors.orange,
        },
        label = {
            padding_right = 20,
            color = colors.grey,
            highlight_color = colors.white,
            font = "sketchybar-app-font:Regular:16.0",
            y_offset = 0,
        },
        padding_right = 1,
        padding_left = 1,
        blur_radius = 5,
        background = {
            color = colors.bgt,
            corner_radius = 15,
            border_width = 0,
            height = 26,
        },
        popup = { background = { border_width = 5, border_color = colors.black } }
    })

    spaces[i] = space

    -- Padding space
    sbar.add("space", "space.padding." .. i, {
        space = i,
        script = "",
        width = settings.group_paddings,
    })

    local space_popup = sbar.add("item", {
        position = "popup." .. space.name,
        padding_left = 5,
        padding_right = 0,
        background = {
            drawing = true,
            image = {
                corner_radius = 9,
                scale = 0.2
            }
        }
    })

    space:subscribe("space_change", function(env)
        local selected = env.SELECTED == "true"
        space:set({
            icon = { highlight = selected, },
            label = { highlight = selected },
            -- background = { border_color = selected and colors.orange or colors.bg2, color = selected and colors.oranget or colors.bgt }
            background = { border_width = 0, color = selected and colors.oranget or colors.bgt }
        })
        -- space_bracket:set({
        --     background = { border_color = selected and colors.grey or colors.bg2 }
        -- })
    end)

    space:subscribe("mouse.clicked", function(env)
        if env.BUTTON == "other" then
            space_popup:set({ background = { image = "space." .. env.SID } })
            space:set({ popup = { drawing = "toggle" } })
        else
            local op = (env.BUTTON == "right") and "--destroy" or "--focus"
            sbar.exec("yabai -m space " .. op .. " " .. env.SID)
        end
    end)

    space:subscribe("mouse.exited", function(_)
        space:set({ popup = { drawing = false } })
    end)
end

local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true,
})

local spaces_indicator = sbar.add("item", {
    padding_left = -12,
    padding_right = 0,
    icon = {
        -- padding_left = 8,
        -- color = colors.grey,
        -- string = icons.arrow.right,
        string = nil
    },
    label = {
        width = 0,
        padding_left = 0,
        padding_right = 8,
        string = "Spaces",
        color = colors.bg1,
    },
    background = {
        color = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.bg1, 0.0),
    }
})

space_window_observer:subscribe("space_windows_change", function(env)
    local icon_line = ""
    local no_app = true
    for app, count in pairs(env.INFO.apps) do
        no_app = false
        local lookup = app_icons[app]

        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        icon_line = icon_line .. icon
    end

    if (no_app) then
        icon_line = " —"
    end
    sbar.animate("tanh", 10, function()
        spaces[env.INFO.space]:set({ label = icon_line })
    end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
    local currently_on = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({
        icon = currently_on and icons.switch.off or icons.switch.on
    })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = { alpha = 1.0 },
                border_color = { alpha = 1.0 },
            },
            icon = { color = colors.bg1 },
            label = { width = "dynamic" }
        })
    end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = { alpha = 0.0 },
                border_color = { alpha = 0.0 },
            },
            icon = { color = colors.grey },
            label = { width = 0, }
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)


local notification_checker = sbar.add("item", {
    drawing = false,
    updates = true,
    update_freq = 10,
})

notification_checker:subscribe({ "routine", "system_woke", "space_change" }, function(env)
    for i = 1, 10, 1 do
        local space = spaces[i]

        if not space then
            return
        end

        local notifications = { value = false }
        local sid = i

        local function update_ui()
            local is_selected = space:query().icon.highlight == "on"
            if not is_selected then
                if notifications.value then
                    space:set({
                        background = {
                            border_color = colors.red,
                            border_width = 1,
                            -- color = colors.redt,
                        },
                        -- label = { highlight = true, }
                    })
                else
                    space:set({
                        -- background = { color = colors.bgt, },
                        -- label = { highlight = false, } })
                        border_width = 0,
                    })
                end
            end
        end

        sbar.exec('yabai -m query --windows --space ' .. sid, function(windows)
            if type(windows) ~= "table" then
                update_ui()
                return
            end

            local count = 0
            for _ in pairs(windows) do count = count + 1 end

            if count == 0 then
                update_ui()
                return
            end

            local apps = {}
            local app_set = {}

            for idx, window in pairs(windows) do
                if window.app and not app_set[window.app] then
                    table.insert(apps, window.app)
                    app_set[window.app] = true
                end
            end

            if #apps == 0 then
                update_ui()
                return
            end

            local pending = #apps

            for _, app in ipairs(apps) do
                sbar.exec('lsappinfo info -only StatusLabel "' .. app .. '"', function(status_info)
                    local label_match = status_info:match('"label"="([^"]*)"')
                    if label_match and label_match:match("^%d+$") and tonumber(label_match) > 0 then
                        notifications.value = true
                    end

                    pending = pending - 1
                    if pending == 0 then
                        update_ui()
                    end
                end)
            end
        end)
    end
end)
