
script.on_event(defines.events.on_player_created, function(event)
    Ly.log("events.on_player_created triggered")

    --Ly.setContext(CONST.CONTEXT.ON_PLAYER_CREATED)
    --Ly.setPlayerIndex(Ly.getPlayerIndexFromTable(game.connected_players, event.name))

    -- initGuiRoots()
end)