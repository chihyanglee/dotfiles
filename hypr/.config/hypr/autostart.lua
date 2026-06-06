hl.on("hyprland.start", function()
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
