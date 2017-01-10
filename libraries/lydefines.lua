
CONST = {
    INFO = {
        NAME = "LyDevGUI",
        VERSION = "0.1.2"
    },
    CONTEXT = {
        ON_PLAYER_CREATE = 1,
        ON_TICK = 2,
    }
}

-- after this CONST is read only
CONST = Ly.protectConstants(CONST)