local config = {}

-- Clock settings
config.CLOCK_WAIT_MAPPING = {
    ["∞"] = {min = 4, max = 8},
    ["1:00"] = {min = 0.5, max = 2},
    ["3:00"] = {min = 2, max = 4},
    ["10:00"] = {min = 3.5, max = 7},
}

-- Icon
config.ICON_IMAGE = "rbxassetid://95384848753847"

-- COLORS (PENTING - jangan kurangi)
config.COLORS = {
    on = {
        background = Color3.fromRGB(255, 170, 0),
        text = Color3.fromRGB(22, 16, 12),
        icon = Color3.fromRGB(22, 16, 12),
    },
    off = {
        background = Color3.fromRGB(22, 16, 12),
        text = Color3.fromRGB(255, 170, 0),
        icon = Color3.fromRGB(255, 170, 0)
    }
}

-- Tambahan safety
config.VERSION = "1.0"
config.AI_NAME = "Strong Chess AI"

return config
