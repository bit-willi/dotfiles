-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Vim-style window focus. J, K, and L replace Omarchy's split, keybindings,
-- and workspace-layout actions; H was previously unbound.
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + SHIFT + SLASH")
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings")

-- Vim-style window movement, matching Omarchy's Super+Shift+Arrow bindings.
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Enter a repeatable Vim-style resize mode. Exit with Escape, Enter, or R.
o.bind("SUPER + R", "Resize mode", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  o.bind("H", "Shrink window width", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
  o.bind("J", "Grow window height", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
  o.bind("K", "Shrink window height", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
  o.bind("L", "Grow window width", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
  hl.bind("ESCAPE", hl.dsp.submap("reset"))
  hl.bind("RETURN", hl.dsp.submap("reset"))
  hl.bind("R", hl.dsp.submap("reset"))
end)

-- Keep a native Hyprland indicator visible for exactly as long as resize mode.
local resize_indicator
hl.on("keybinds.submap", function(submap)
  if resize_indicator and resize_indicator:is_alive() then
    resize_indicator:dismiss()
  end
  resize_indicator = nil

  if submap == "resize" then
    resize_indicator = hl.notification.create({
      text = "R",
      timeout = 86400000,
      icon = "info",
      color = "rgb(ff9f1c)",
      font_size = 18,
    })
  end
end)
