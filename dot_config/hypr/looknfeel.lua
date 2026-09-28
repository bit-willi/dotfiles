-- Use roughly one-quarter of Omarchy's default window gaps (5px inner, 10px outer).
hl.config({
  general = {
    gaps_in = 1,
    gaps_out = {
      top = 0,
      right = 2,
      bottom = 2,
      left = 2,
    },
  },
})

-- Hide the border when only one visible tiled window occupies the workspace.
-- Hyprland restores the normal border automatically when another tile appears.
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
o.window({ float = false, workspace = "w[tv1]" }, {
  border_size = 0,
})
