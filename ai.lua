local M = {}

function M.start(modules)
    local config = modules.config
    local state = modules.state

    state.aiLoaded = true
    state.aiRunning = true

    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Sunfish = localPlayer:WaitForChild("PlayerScripts").AI:WaitForChild("Sunfish")
    local ChessLocalUI = localPlayer:WaitForChild("PlayerScripts"):WaitForChild("ChessLocalUI")

    local GetBestMove, PlayMove

    -- Ultra robust function finder
    local function getFunction(funcName, moduleName)
        for i = 1, 30 do
            for _, f in ipairs(getgc(true)) do
                if typeof(f) == "function" then
                    local info = debug.getinfo(f)
                    if info.name == funcName and string.find(info.source, moduleName, 1, true) then
                        if funcName == "GetBestMove" then 
                            GetBestMove = f 
                        elseif funcName == "PlayMove" then 
                            PlayMove = f 
                        end
                        return true
                    end
                end
            end
            task.wait(0.1)
        end
        return false
    end

    getFunction("GetBestMove", "Sunfish")
    getFunction("PlayMove", "ChessLocalUI")

    -- ====================== NUCLEAR TIMING ======================
    local function getNuclearWait(moveCount, clockText)
        local base = config.CLOCK_WAIT_MAPPING[clockText] or {min = 3, max = 8}

        if moveCount <= 12 then
            return math.random(135, 265) / 100
        elseif moveCount <= 30 then
            return math.random(base.min * 155, base.max * 195) / 100
        else
            return math.random(220, 520) / 100   -- endgame sangat teliti
        end
    end

    -- ====================== NUCLEAR AI CORE ======================
    local function startNuclearAI(board)
        local boardLoaded = false
        local gameEnded = false
        local moveCount = 0
        local isLocalWhite = localPlayer.Name == board.WhitePlayer.Value
        local clockLabel = board:FindFirstChild("Clock", true):FindFirstChild("WhiteTime") or board:FindFirstChild("Clock", true):FindFirstChild("BlackTime")

        local function isMyTurn()
            return (localPlayer.Name == board.WhitePlayer.Value) == board.WhiteToPlay.Value
        end

        local function evaluateBestMove(fen, depth)
            local bestMove = nil
            local bestScore = -math.huge

            for i = 1, state.multiPVCount do
                local result = GetBestMove(nil, fen, depth * state.searchTimeMultiplier)
                
                if result and result ~= "" then
                    local score = tonumber(string.match(result, "(%-?%d+%.?%d*)")) or 0
                    
                    -- Contempt factor (kurangi suka remis)
                    if score > 0 then score = score + state.contemptFactor end
                    if score < 0 then score = score - state.contemptFactor end

                    if score > bestScore then
                        bestScore = score
                        bestMove = result
                    end
                end
                task.wait(0.025)
            end
            return bestMove, bestScore
        end

        local function gameLoop()
            task.wait(2.5)

            while not gameEnded and state.aiRunning do
                if boardLoaded and isMyTurn() then
                    local fen = board.FEN.Value
                    if fen and fen ~= "" then

                        -- Dynamic Nuclear Depth
                        local depth = state.baseDepth
                        if moveCount >= 15 then depth += 3 end
                        if moveCount >= 32 then depth += 4 end
                        if moveCount >= 50 then depth += 2 end
                        depth = math.clamp(depth, 11, state.maxDepth)

                        local bestMove, score = evaluateBestMove(fen, depth)

                        if bestMove and bestMove ~= "" then
                            local waitTime = getNuclearWait(moveCount, clockLabel.ContentText)
                            task.wait(waitTime)

                            PlayMove(bestMove)
                            moveCount += 1

                            -- Update history & transposition
                            table.insert(state.moveHistory, bestMove)
                            if #state.moveHistory > 50 then table.remove(state.moveHistory, 1) end

                            print(`[CHESS AI NUCLEAR] Move #{moveCount} | Depth: {depth} | Score: {score}`)
                        end
                    end
                end
                task.wait(0.08) -- super responsif
            end
        end

        boardLoaded = true
        print("☢️ CHESS AI NUCLEAR MODE ACTIVATED - Depth up to 20 | 5-PV")

        state.aiThread = coroutine.create(gameLoop)
        coroutine.resume(state.aiThread)

        ReplicatedStorage.Chess.EndGameEvent.OnClientEvent:Once(function()
            gameEnded = true
            print("[CHESS AI NUCLEAR] Game selesai.")
        end)
    end

    -- Main Connection
    ReplicatedStorage.Chess.StartGameEvent.OnClientEvent:Connect(function(board)
        if board and (localPlayer.Name == board.WhitePlayer.Value or localPlayer.Name == board.BlackPlayer.Value) then
            startNuclearAI(board)
        end
    end)

    state.gameConnected = true
end

return M
