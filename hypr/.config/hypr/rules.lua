-- Ignore maximize requests. kitty persists "window-state": "maximized" in
-- ~/.cache/kitty/main.json and replays it on launch, covering tiled neighbours.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
-- hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })

hl.window_rule({
  match = { class = "^(floating-picker)$" },
  float = true,
  size = { "monitor_w * 0.7", "monitor_h * 0.55" },
  center = true,
})
