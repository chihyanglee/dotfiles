hl.on("hyprland.start", function()
  -- Tell systemd a graphical session exists. Without this graphical-session.target
  -- never activates, and any user service bound to it (hypridle, hyprpolkitagent, …)
  -- silently never starts even after `systemctl --user enable`. Must come first so
  -- the target is up before anything below depends on it.
  hl.exec_cmd("systemctl --user start hyprland-session.target")

  -- Export GTK dark theme to systemd so xdg-desktop-portal-gtk picks it up
  hl.exec_cmd("systemctl --user import-environment GTK_THEME && systemctl --user restart xdg-desktop-portal-gtk")

  -- Notifications
  hl.exec_cmd("uwsm app -- mako")

  -- Wallpaper daemon
  hl.exec_cmd("uwsm app -- awww-daemon")

  -- EWW widgets
  hl.exec_cmd("uwsm app -- sh -c 'pkill eww || true; eww daemon; sleep 1; eww open bar'")

  -- Input method
  hl.exec_cmd("uwsm app -- fcitx5")
end)

hl.on("hyprland.shutdown", function()
  -- os.execute blocks, unlike hl.exec_cmd, so the teardown actually finishes
  -- before Hyprland exits. PropagatesStopTo brings graphical-session.target down
  -- with it, giving session services an ordered shutdown.
  os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)
