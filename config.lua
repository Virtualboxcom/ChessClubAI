--// CONFIG.LUA - Modern Dark Pro

local Config = {}

-------------------------------------------------
-- CORE
-------------------------------------------------
Config.DebugMode = true
Config.Version = "3.0 Modern Dark Pro"

-------------------------------------------------
-- UI SETTINGS (65% FOCUS)
-------------------------------------------------
Config.UI = {
    Enabled = true,

    Name = "ChessClub AI",

    Size = {
        Width = 360,
        Height = 235
    },

    Position = UDim2.new(0.05,0,0.22,0),

    CornerRadius = 12,

    RefreshRate = 0.08,

    AnimationSpeed = 0.12,

    Draggable = true,

    ShowFPS = true,

    SafeReExecute = true,

    Shadow = true,

    Theme = {
        Background = Color3.fromRGB(20,20,24),
        Header = Color3.fromRGB(30,30,36),
        Surface = Color3.fromRGB(38,38,46),

        Accent = Color3.fromRGB(0,170,120),
        AccentDark = Color3.fromRGB(0,130,90),

        Text = Color3.fromRGB(245,245,245),
        SubText = Color3.fromRGB(170,170,175),

        Success = Color3.fromRGB(50,190,90),
        Warning = Color3.fromRGB(255,185,0),
        Danger = Color3.fromRGB(220,60,60),

        Border = Color3.fromRGB(50,50,58)
    }
}

-------------------------------------------------
-- ENGINE SETTINGS (35%)
-------------------------------------------------
Config.Engine = {
    Enabled = true,

    Depth = 4,

    ThinkDelay = 0.15,

    MaxCalculationTime = 1.2,

    UseAlphaBeta = true,

    EnablePositionEvaluation = true,

    EnableMoveOrdering = true,

    EnableTransposition = false,

    AutoMove = false,

    Difficulty = "Advanced",

    PieceValues = {
        Pawn = 100,
        Knight = 320,
        Bishop = 330,
        Rook = 500,
        Queen = 900,
        King = 20000
    }
}

-------------------------------------------------
-- DEBUG
-------------------------------------------------
Config.Logging = {
    PrintToConsole = true,
    ShowDebugPanel = true
}

-------------------------------------------------
-- STATUS TEXT
-------------------------------------------------
Config.StatusText = {
    Loading = "Initializing...",
    Idle = "Ready",
    Thinking = "Analyzing position...",
    Waiting = "Waiting turn...",
    Error = "System Error",
    Match = "Match Detected"
}

return Config
