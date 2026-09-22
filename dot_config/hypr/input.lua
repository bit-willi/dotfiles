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

-- macOS-style touchpad shortcuts.
-- Four fingers down toggles the scratchpad.
hl.gesture({ fingers = 4, direction = "down", action = "special", workspace_name = "scratchpad" })

-- Pinching with two fingers gives a live magnifier centered at the cursor.
hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 2.0, mode = "live" })
