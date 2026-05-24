--// STATE.LUA - Modern State Manager

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local State = {}

-------------------------------------------------
-- BASE STATE
-------------------------------------------------
State.Enabled = true
State.AutoMove = false

State.Status = "Initializing..."

State.CurrentMatch = nil
State.MyColor = nil
State.IsMyTurn = false

State.LastMove = nil
State.EngineThinking = false

State.MoveHistory = {}

State.FPS = 0
State.LastUpdate = tick()

-------------------------------------------------
-- INTERNAL HELPERS
-------------------------------------------------
function State:SetStatus(text)
    self.Status = tostring(text)
end

function State:SetTurn(value)
    self.IsMyTurn = value
end

function State:SetMatch(match)
    self.CurrentMatch = match
end

function State:SetColor(color)
    self.MyColor = color
end

-------------------------------------------------
-- MATCH DETECTION
-------------------------------------------------
function State:FindMatch()

    local folders = {
        workspace:FindFirstChild("ChessMatches"),
        workspace:FindFirstChild("Matches"),
        workspace:FindFirstChild("Games"),
        workspace:FindFirstChild("ChessGames")
    }

    for _, folder in ipairs(folders) do

        if folder then

            for _, match in ipairs(folder:GetChildren()) do

                local p1 =
                    match:GetAttribute("Player1")

                local p2 =
                    match:GetAttribute("Player2")

                if p1 == LocalPlayer.Name
                    or p2 == LocalPlayer.Name
                then

                    self.CurrentMatch = match

                    self.MyColor =
                        (p1 == LocalPlayer.Name)
                        and "White"
                        or "Black"

                    self.Status =
                        "Match Found"

                    return match
                end
            end
        end
    end

    return nil
end

-------------------------------------------------
-- TURN UPDATE
-------------------------------------------------
function State:UpdateTurn()

    if not self.CurrentMatch
    then
        self:FindMatch()
    end

    if not self.CurrentMatch then
        self.IsMyTurn = false
        self.Status = "Waiting Match"
        return
    end

    local ok, err =
        pcall(function()

            local turn =
                self.CurrentMatch:GetAttribute(
                    "Turn"
                )

            self.IsMyTurn =
                turn == self.MyColor

            if self.IsMyTurn then
                self.Status =
                    "Your Turn"
            else
                self.Status =
                    "Opponent Turn"
            end
        end)

    if not ok then
        self.Status =
            "Match Sync Failed"
        warn(err)
    end
end

-------------------------------------------------
-- MOVE HISTORY
-------------------------------------------------
function State:AddMove(move)

    table.insert(
        self.MoveHistory,
        move
    )

    self.LastMove = move
end

-------------------------------------------------
-- FPS TRACKER
-------------------------------------------------
task.spawn(function()

    local frames = 0
    local lastTick = tick()

    while task.wait() do

        frames += 1

        if tick() - lastTick >= 1 then

            State.FPS = frames

            frames = 0
            lastTick = tick()
        end
    end
end)

-------------------------------------------------
-- AUTO LOOP
-------------------------------------------------
task.spawn(function()

    while task.wait(0.15) do
        pcall(function()
            State:UpdateTurn()
        end)
    end
end)

return State
