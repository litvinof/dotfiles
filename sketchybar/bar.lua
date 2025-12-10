local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    height = 38,
    --
    y_offset = 4,
    blur_radius=20,
    margin = 5,
    corner_radius=20,
    color = 0x20000000,
    border_color = 0x20FFFFFF,
    border_width = 1,
    shadow = {
        drawing = true,
        color = 0x80000000,
        distance = 8,
        angle = 270,
    },

    --
    -- color = colors.bar.bg,
    padding_right = 5,
    padding_left = 5,
    -- background = {
    --     corner_radius = 9,
    --     border_width = 2,
    --     border_color = colors.bar.bg,
    -- },
})


-- isketchybar --bar position=top \
--            height=32 \
--            blur_radius=40 \
--            y_offset=4 \
--            margin=12 \
--            corner_radius=12 \
--            padding_left=0 \
--            padding_right=0 \
--            color=0x20000000 \
--            border_color=0x20FFFFFF \
--            border_width=1 \
--            shadow=on \
--            shadow.color=0x80000000 \
--            shadow.distance=8 \
--            shadow.angle=270
