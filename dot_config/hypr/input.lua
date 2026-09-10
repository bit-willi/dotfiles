-- US layout with Right Alt as Compose (Right Alt, comma, c produces cedilla).
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_options = "compose:ralt",
    numlock_by_default = false,
    touchpad = {
      natural_scroll = true,
    },
  },
})

-- Swipe horizontally with three fingers to change workspaces.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
