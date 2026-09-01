local active_border_color = "rgb(076678)"
local inactive_border_color = "rgb(d5c4a1)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },
  decoration = {
    blur = { enabled = false },
  },
  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },
})

-- Override Omarchy's default active/inactive transparency for this theme.
o.window(".*", { opacity = "1 override 1 override 1 override" })
