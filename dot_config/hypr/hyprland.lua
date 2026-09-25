-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Personal overrides load after Omarchy defaults, so package updates can
-- improve the defaults without rewriting these settings.
require("hypr.monitors")
require("hypr.workspaces")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- pOS drives its dedicated Chromium session through an extension. Keep its
-- automation requests from activating workspace 2 or stealing keyboard focus.
-- Manual pointer focus still works normally.
o.window("chromium", {
  workspace = "2 silent",
  no_initial_focus = true,
  suppress_event = "activate activatefocus",
})
