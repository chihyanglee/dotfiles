hl.config({
  input = {
    kb_layout = "us",
    kb_options = "caps:ctrl_modifier",
    follow_mouse = 1,
    sensitivity = 0,

    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      disable_while_typing = false,
      clickfinger_behavior = true,
    },
  },
})

-- Touchpad-only pointer tuning.
--
-- libinput's default "adaptive" profile decelerates hard at low speed, which
-- makes fine positioning feel dead: the cursor barely responds until the
-- finger crosses a velocity threshold. "flat" drops the curve entirely, so a
-- slow nudge and a fast swipe share one constant gain.
--
-- The pad itself is fine -- it reports 31 units/mm, fuzz 0, ~115 reports/sec.
-- sensitivity range -1.0 .. 1.0, 0 = libinput default.
hl.device({
  name = "elan0672:00-04f3:3187-touchpad",
  accel_profile = "flat",
  sensitivity = 0.8,
})
