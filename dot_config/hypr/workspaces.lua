-- Keep workspaces tied to their physical display when both monitors are active.
-- HDMI is the primary work area; the laptop panel hosts workspaces 6 through 10.
for workspace = 1, 5 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "HDMI-A-1", persistent = true })
end

for workspace = 6, 10 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "eDP-1", persistent = true })
end
