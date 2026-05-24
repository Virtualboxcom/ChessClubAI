--// GUI.LUA - Modern Dark Pro

local GuiModule = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

function GuiModule.Create(State, Config)

    if Config.UI.SafeReExecute then
        local old =
            game:GetService("CoreGui"):FindFirstChild("ChessClubModern")

        if old then
            old:Destroy()
        end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ChessClubModern"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)

    if not gui.Parent then
        gui.Parent = player.PlayerGui
    end

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(
        0,
        Config.UI.Size.Width,
        0,
        Config.UI.Size.Height
    )
    Main.Position = Config.UI.Position
    Main.BackgroundColor3 =
        Config.UI.Theme.Background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = Config.UI.Draggable
    Main.Parent = gui

    CreateCorner(Main, 12)

    -------------------------------------------------
    -- HEADER
    -------------------------------------------------
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1,0,0,45)
    Header.BackgroundColor3 =
        Config.UI.Theme.Header
    Header.BorderSizePixel = 0
    Header.Parent = Main

    CreateCorner(Header,12)

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1,-20,1,0)
    Title.Position = UDim2.new(0,15,0,0)
    Title.Text = "♟ CHESS CLUB AI"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 =
        Config.UI.Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment =
        Enum.TextXAlignment.Left
    Title.Parent = Header

    -------------------------------------------------
    -- STATUS
    -------------------------------------------------
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1,-20,0,28)
    Status.Position = UDim2.new(0,10,0,60)
    Status.BackgroundTransparency = 1
    Status.TextColor3 =
        Config.UI.Theme.Text
    Status.TextXAlignment =
        Enum.TextXAlignment.Left
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14
    Status.Text = "Status: Loading"
    Status.Parent = Main

    -------------------------------------------------
    -- ENGINE
    -------------------------------------------------
    local Engine = Instance.new("TextLabel")
    Engine.Size = UDim2.new(1,-20,0,24)
    Engine.Position = UDim2.new(0,10,0,95)
    Engine.BackgroundTransparency = 1
    Engine.Text =
        "Engine Depth: "..Config.Engine.Depth
    Engine.TextColor3 =
        Config.UI.Theme.Warning
    Engine.TextSize = 13
    Engine.Font = Enum.Font.GothamMedium
    Engine.TextXAlignment =
        Enum.TextXAlignment.Left
    Engine.Parent = Main

    -------------------------------------------------
    -- BUTTON
    -------------------------------------------------
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1,-20,0,42)
    Toggle.Position = UDim2.new(0,10,0,135)
    Toggle.BackgroundColor3 =
        Config.UI.Theme.Accent
    Toggle.TextColor3 =
        Config.UI.Theme.Text
    Toggle.Text = "AUTO MOVE : OFF"
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextSize = 14
    Toggle.Parent = Main

    CreateCorner(Toggle,8)

    Toggle.MouseButton1Click:Connect(function()

        State.AutoMove =
            not State.AutoMove

        Toggle.Text =
            State.AutoMove
            and "AUTO MOVE : ON"
            or "AUTO MOVE : OFF"

    end)

    -------------------------------------------------
    -- DEBUG PANEL
    -------------------------------------------------
    local Debug = Instance.new("TextLabel")
    Debug.Size = UDim2.new(1,-20,0,25)
    Debug.Position = UDim2.new(0,10,1,-35)
    Debug.BackgroundTransparency = 1
    Debug.TextColor3 =
        Config.UI.Theme.SubText
    Debug.Text =
        "Debug: Ready"
    Debug.Font = Enum.Font.Gotham
    Debug.TextSize = 11
    Debug.TextXAlignment =
        Enum.TextXAlignment.Left
    Debug.Parent = Main

    -------------------------------------------------
    -- UPDATE LOOP
    -------------------------------------------------
    task.spawn(function()
        while gui.Parent do
            task.wait(Config.UI.RefreshRate)

            Status.Text =
                "Status: "..State.Status

            Debug.Text =
                "Turn: "..
                tostring(State.IsMyTurn)
        end
    end)
end

return GuiModule
