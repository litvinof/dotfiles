local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 38,
  color = colors.bar.bg,
  padding_right = 5,
  padding_left = 5,
  background = {
    corner_radius = 9,
    border_width = 2,
    border_color = colors.bar.bg,
  },
})
