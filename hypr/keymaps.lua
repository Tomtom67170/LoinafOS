-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi --show drun"


local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + code:36", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
--hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
--hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
--hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f - -o - | wl-copy -t image/png"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("$HOME/.config/hypr/lock.sh"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("discord --opaque-bg --enable-features=UseOzonePlatform --ozone-platform=wayland"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("$HOME/.config/hypr/logout.sh"), {locked = true})
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle"}))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({workspace = "special"}))
hl.bind(mainMod .. " + G", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("flatpak run fr.loinaf.loinafsuper"))


-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i - 1 -- 10 maps to key 0
    hl.bind(mainMod .. " + code:1" .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + code:1" .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + code:1" .. key,     hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind("ALT + TAB", hl.dsp.focus({workspace = "previous"}))

-- Example special workspace (scratchpad)
--hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
--hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
