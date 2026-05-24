--// AI.LUA - Modular Chess Engine

local AIModule = {}

local RunService =
    game:GetService("RunService")

-------------------------------------------------
-- PIECE VALUES
-------------------------------------------------
local PieceValues = {
    Pawn = 100,
    Knight = 320,
    Bishop = 330,
    Rook = 500,
    Queen = 900,
    King = 20000
}

-------------------------------------------------
-- POSITION EVALUATION
-------------------------------------------------
local function EvaluateBoard(board)

    local score = 0

    if not board then
        return 0
    end

    for _, piece in ipairs(
        board:GetDescendants()
    ) do

        if piece:IsA("Model") then

            local value =
                PieceValues[piece.Name]

            if value then

                local owner =
                    piece:GetAttribute(
                        "Color"
                    )

                if owner == "White" then
                    score += value
                else
                    score -= value
                end
            end
        end
    end

    return score
end

-------------------------------------------------
-- MOVE ORDERING
-------------------------------------------------
local function OrderMoves(moves)

    table.sort(
        moves,
        function(a,b)
            return
                (a.Score or 0)
                >
                (b.Score or 0)
        end
    )

    return moves
end

-------------------------------------------------
-- MINIMAX
-------------------------------------------------
local function Minimax(
    board,
    depth,
    alpha,
    beta,
    maximizing
)

    if depth <= 0 then
        return EvaluateBoard(board)
    end

    local pseudoMoves = {}

    if #pseudoMoves == 0 then
        return EvaluateBoard(board)
    end

    pseudoMoves =
        OrderMoves(pseudoMoves)

    if maximizing then

        local maxEval =
            -math.huge

        for _, move in ipairs(
            pseudoMoves
        ) do

            local eval =
                Minimax(
                    board,
                    depth - 1,
                    alpha,
                    beta,
                    false
                )

            maxEval =
                math.max(
                    maxEval,
                    eval
                )

            alpha =
                math.max(
                    alpha,
                    eval
                )

            if beta <= alpha then
                break
            end
        end

        return maxEval
    end

    local minEval =
        math.huge

    for _, move in ipairs(
        pseudoMoves
    ) do

        local eval =
            Minimax(
                board,
                depth - 1,
                alpha,
                beta,
                true
            )

        minEval =
            math.min(
                minEval,
                eval
            )

        beta =
            math.min(
                beta,
                eval
            )

        if beta <= alpha then
            break
        end
    end

    return minEval
end

-------------------------------------------------
-- START ENGINE
-------------------------------------------------
function AIModule.Start(
    State,
    Config
)

    local running = false

    RunService.Heartbeat:Connect(
        function()

        if running then
            return
        end

        if not State.AutoMove
        then
            return
        end

        if not State.IsMyTurn
        then
            return
        end

        running = true

        task.spawn(function()

            pcall(function()

                State.EngineThinking =
                    true

                State.Status =
                    "Analyzing..."

                task.wait(
                    Config.Engine
                    .ThinkDelay
                )

                local board =
                    workspace:
                    FindFirstChild(
                        "Board"
                    )

                local score =
                    Minimax(
                        board,
                        Config.Engine
                            .Depth,
                        -math.huge,
                        math.huge,
                        true
                    )

                State.Status =
                    "Eval: "
                    .. tostring(score)

                State.EngineThinking =
                    false
            end)

            running = false
        end)
    end)
end

return AIModule
