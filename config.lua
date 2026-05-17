local config = {}

config.CLOCK_WAIT_MAPPING = {
    ["∞"] = {min = 4, max = 8},
    ["1:00"] = {min = 0.5, max = 2},
    ["3:00"] = {min = 2, max = 4},
    ["10:00"] = {min = 3.5, max = 7},
}

config.ICON_IMAGE = "http://www.roblox.com/asset/?id=95384848753847"

config.COLORS = {
    on = {background = Color3.fromRGB(255, 170, 0), text = Color3.fromRGB(22, 16, 12)},
    off = {background = Color3.fromRGB(22, 16, 12), text = Color3.fromRGB(255, 170, 0)}
}

return config
