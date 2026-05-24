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

    -- Robust function finder
    local function getFunction(funcName, moduleName)
        for i = 1, 25 do
            for _, f in ipairs(getgc(true)) do
                if typeof(f) == "function" then
                    local info = debug.getinfo(f)
                    if info.name == funcName and string.find(info.source, moduleName) then
                        if funcName == "GetBestMove" then GetBestMove = f
                        elseif funcName == "PlayMove" then PlayMove = f end
                        return
                    end
                end
            end
            task.wait(0.08)
        end
    end

    getFunction("GetBestMove", "Sunfish")
    getFunction("PlayMove", "ChessLocalUI")

    -- ====================== EXTREME TIMING SYSTEM ======================
    local function getExtremeWait(moveCount, clockText)
        local base = config.CLOCK_WAIT_MAPPING[clockText] or {min = 2.5, max = 6}

        if moveCount <= 10 then
            return math.random(140, 280) / 100  -- opening cepat tapi natural
        elseif moveCount <= 25 then
            return math.random(base.min * 140, base.max * 165) / 100
        else
            return math.random(180, 420) / 100  -- endgame sangat akurat
        end
    end

    -- ====================== MAIN EXTREME AI LOOP ======================
    local function startExtremeAI(board)
        local boardLoaded = false
        local gameEnded = false
        local moveCount = 0
        local isLocalWhite = localPlayer.Name == board.WhitePlayer.Value
        local clockLabel = board.Clock.MainBody.SurfaceGui[isLocalWhite and "WhiteTime" or "BlackTime"]

        local function isMyTurn()
            return (localPlayer.Name == board.WhitePlayer.Value) == board.WhiteToPlay.Value
        end

        local function gameLoop()
            task.wait(2.8)

            while not gameEnded and state.aiRunning do
                if boardLoaded and isMyTurn() then
                    local fen = board.FEN.Value
                    if fen and fen ~= "" then

                        -- === DYNAMIC EXTREME DEPTH ===
                        local depth = state.baseDepth
                        if moveCount > 18 then depth = depth + 3 end
                        if moveCount > 35 then depth = depth + 4 end
                        depth = math.clamp(depth, 9, state.maxDepth)

                        -- Multi-PV Simulation (mencari beberapa pilihan terbaik)
                        local bestMove = nil
                        local bestScore = -math.huge

                        for i = 1, state.multiPVCount do
                            local moveData = GetBestMove(nil, fen, depth * state.searchTimeMultiplier)

                            if moveData and moveData ~= "" then
                                -- Simulasi evaluasi sederhana
                                local score = tonumber(string.match(moveData, "(%-?%d+%.?%d*)")) or 0
                                if score > bestScore then
                                    bestScore = score
                                    bestMove = moveData
                                end
                            end
                            task.wait(0.03)
                        end

                        if bestMove and bestMove ~= "" then
                            local waitTime = getExtremeWait(moveCount, clockLabel.ContentText)
                            task.wait(waitTime)

                            PlayMove(bestMove)
                            moveCount += 1

                            -- History
                            table.insert(state.moveHistory, bestMove)
                            if #state.moveHistory > 40 then table.remove(state.moveHistory, 1) end

                            print(`[CHESS AI EXTREME] Move #{moveCount} | Depth: {depth} | Score: {bestScore}`)
                        end
                    end
                end
                task.wait(0.12) -- sangat responsif
            end
        end

        boardLoaded = true
        print("🚀 CHESS AI EXTREME MODE ACTIVATED - Depth up to 16 | Multi-PV")

        state.aiThread = coroutine.create(gameLoop)
        coroutine.resume(state.aiThread)

        -- Game End Handler
        ReplicatedStorage.Chess.EndGameEvent.OnClientEvent:Once(function()
            gameEnded = true
            print("[CHESS AI EXTREME] Game finished.")
        end)
    end

    -- Main Listener
    ReplicatedStorage.Chess.StartGameEvent.OnClientEvent:Connect(function(board)
        if board and (localPlayer.Name == board.WhitePlayer.Value or localPlayer.Name == board.BlackPlayer.Value) then
            startExtremeAI(board)
        end
    end)

    state.gameConnected = true
end

return M
