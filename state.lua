local state = {
    aiLoaded = false,
    aiRunning = true,
    gameConnected = false,
    thread = nil,

    -- EXTREME SETTINGS
    baseDepth = 9,
    maxDepth = 16,
    searchTimeMultiplier = 1250,     -- sangat tinggi
    useMultiPV = true,
    multiPVCount = 3,                -- analisis beberapa variasi terbaik
    moveHistory = {},
    transpositionTable = {},         -- simulasi sederhana
    lastEval = 0,
}

return state
