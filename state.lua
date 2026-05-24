local state = {
    aiLoaded = false,
    aiRunning = true,
    gameConnected = false,
    thread = nil,

    -- === NUCLEAR SETTINGS ===
    baseDepth = 11,                    -- mulai sangat tinggi
    maxDepth = 20,                     -- ekstrem
    searchTimeMultiplier = 1850,       -- sangat berat
    multiPVCount = 5,                  -- analisis 5 variasi terbaik
    useTransposition = true,
    transpositionTable = {},
    moveHistory = {},
    lastEval = 0,
    contemptFactor = 35,               -- mengurangi drawish behavior
}

return state
