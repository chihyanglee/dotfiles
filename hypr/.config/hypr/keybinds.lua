-- Modifier
local mod = "SUPER"

---------------------------
-- Application Launch
---------------------------

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty tmux new -As main"))
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("fuzzel"))
hl.bind(
  mod .. " + SHIFT + W",
  hl.dsp.exec_cmd(
    "kitty --class floating-picker -o remember_window_size=no -o initial_window_width=100c -o initial_window_height=30c -e ~/.config/awww/scripts/pick-wallpaper.sh"
  )
)

---------------------------
-- Window Management
---------------------------

hl.bind(mod .. " + Q", hl.dsp.window.close())

-- Upstream advises against a bare exit() — it drops the compositor out from
-- under its clients. hyprshutdown asks them to quit first; fall back to exit()
-- when it isn't installed. This is the pattern from Hyprland's own example config.
hl.bind(
  mod .. " + SHIFT + Q",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Focus
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap window positions
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

-- Layout
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Scratchpad
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special())

-- Mouse window control
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---------------------------
-- Hyprland Controls
---------------------------

hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))

---------------------------
-- Screenshot
---------------------------

hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

---------------------------
-- Audio
---------------------------

local audio_flags = { locked = true, repeating = true }

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
  audio_flags
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"),
  audio_flags
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), audio_flags)

---------------------------
-- Brightness
---------------------------

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), audio_flags)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), audio_flags)

---------------------------
-- Workspaces (1-10)
---------------------------

-- Switch to workspace 1-10, and move the active window to workspace 1-10.
-- Workspace 10 lives on key 0 (common convention).
for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

---------------------------
-- Workspace cycling
---------------------------

-- Cycle workspaces with mouse wheel while holding SUPER
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
