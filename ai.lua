local M = {}

-- ================== HUMANIZATION 100% ==================
local function getHumanDelay(moveCount, timeLeft, isCritical)
    local minTime, maxTime

    if moveCount <= 12 then          -- Opening
        minTime, maxTime = 3.4, 8.8
    elseif moveCount >= 48 then      -- Endgame
        minTime, maxTime = 1.7, 5.0
    else                             -- Middlegame
        minTime, maxTime = 2.7, 7.5
    end

    if timeLeft and timeLeft < 180 then
        minTime = minTime * 0.7
        maxTime = maxTime * 0.85
    end

    if isCritical then
        minTime += 2.2
        maxTime += 4.0
    end

    local delay = math.random(minTime * 100, maxTime * 100) / 100
    delay += math.random(-70, 100) / 100

    return math.clamp(delay, 1.5, 14)
end

local function isCriticalPosition() 
    return math.random() < 0.27 
end

local function shouldMakeSmallMistake(moveCount)
    if moveCount <= 12 then return math.random() < 0.14 end
    if moveCount <= 35 then return math.random() < 0.08 end
    return math.random() < 0.035
end

-- ================== MAIN AI ==================
function M.start(modules)
    local state = modules.state
    if state.aiLoaded then return end

    state.aiLoaded = true
    state.aiRunning = true
    state.moveCount = 0

    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local localPlayer = Players.LocalPlayer

    print("♟️ Chess AI Full Strength + 100% Humanization Loaded")

    RS.Chess.StartGameEvent.OnClientEvent:Connect(function(gameBoard)
        if not gameBoard then return end
        
        state.moveCount = 0
        state.currentBoard = gameBoard

        task.spawn(function()
            while state.aiRunning and gameBoard.Parent do
                task.wait(0.2)

                local isWhite = localPlayer.Name == gameBoard.WhitePlayer.Value
                local isMyTurn = (gameBoard.WhiteToPlay.Value == isWhite)

                if isMyTurn then
                    local fen = gameBoard.FEN.Value
                    local timeLeft = 300 -- bisa di-parse dari clock nanti

                    local critical = isCriticalPosition()

                    if shouldMakeSmallMistake(state.moveCount) then
                        task.wait(math.random(1.8, 4.8))
                        -- TODO: logic blunder kecil
                    else
                        -- === GANTI BAGIAN INI DENGAN MOVE GENERATOR GAME ===
                        -- Contoh sementara:
                        task.wait(getHumanDelay(state.moveCount, timeLeft, critical))

                        -- Contoh pemanggilan move (sesuaikan dengan game kalian)
                        -- gameBoard.PlayMove:FireServer("e2", "e4", "")
                        state.moveCount += 1
                    end
                end
            end
        end)
    end)
end

return M
