
script.on_event(defines.events.on_player_created, function(event)
    Ly.log("events.on_player_created fired")

    Ly.setContext(CONST.CONTEXT.ON_PLAYER_CREATED)
    Ly.setPlayerIndex(event.player_index)

    initGuiRoots()
end)