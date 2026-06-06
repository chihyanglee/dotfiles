-- Hyprland Lua config (migrated from hyprlang)
-- Load order: env, monitors, input, animations, rules, autostart, keybinds, theme

local config_dir = os.getenv("HOME") .. "/.config/hypr"

local function load(name)
    dofile(config_dir .. "/" .. name .. ".lua")
end

load("env")
load("monitors")
load("input")
load("animations")
load("rules")
load("autostart")
load("keybinds")

-- Basic look
hl.config({
    general = {
        gaps_in     = 6,
        gaps_out    = 10,
        border_size = 2,
        layout      = "dwindle",
    },

    dwindle = {
        preserve_split = true,
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size    = 6,
            passes  = 2,
        },
    },

    misc = {
        disable_hyprland_logo     = true,
        disable_splash_rendering  = true,
    },
})

-- Matugen-generated theme (border + shadow colors)
local theme_path = config_dir .. "/theme.lua"
local theme_file = io.open(theme_path, "r")
if theme_file then
    theme_file:close()
    dofile(theme_path)
end
