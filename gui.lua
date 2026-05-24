local M = {}

function M.init(modules)
    local state = modules.state
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Hapus GUI lama jika ada
    if playerGui:FindFirstChild("ChessAINuclearGUI") then
        playerGui.ChessAINuclearGUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ChessAINuclearGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 170, 0, 85)
    frame.Position = UDim2.new(0, 15, 0, 15)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = "♟️ Nuclear AI"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.88, 0, 0, 38)
    toggleBtn.Position = UDim2.new(0.06, 0, 0, 38)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    toggleBtn.Text = "AI OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamSemibold
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 15)
    statusLabel.Position = UDim2.new(0, 0, 1, 2)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Ready"
    statusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = frame

    -- Toggle Logic
    local aiEnabled = false

    local function updateUI()
        if aiEnabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            toggleBtn.Text = "AI ON"
            statusLabel.Text = "Status: Active"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            toggleBtn.Text = "AI OFF"
            statusLabel.Text = "Status: Inactive"
        end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        aiEnabled = not aiEnabled
        state.aiRunning = aiEnabled
        updateUI()

        if aiEnabled then
            print("✅ Nuclear AI → ON")
        else
            print("⛔ Nuclear AI → OFF")
        end
    end)

    updateUI()
    print("🛠️ Simple Nuclear GUI Loaded")
end

return M
