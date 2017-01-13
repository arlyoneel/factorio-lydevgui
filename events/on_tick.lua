
script.on_event(defines.events.on_tick, function(event)

    if(event.tick % CONST.ON_TICK.GUI_TICKS_UPDATE == 0) then

        Ly.setContext(CONST.CONTEXT.ON_TICK)

        for i, currentPlayer in pairs(game.connected_players) do
            -- store current working player index for functions calls
            Ly.setPlayerIndex(currentPlayer.index)

            -- --------------------------------------------------------------
            -- Custom event trigger
            -- --------------------------------------------------------------
            if (nil ~= currentPlayer.selected and
                    currentPlayer.selected ~= Ly.lastSelection[currentPlayer.index] ) then
                global.isSelectedEntity = true

                -- Event onSelectionChange
                game.raise_event(events.onSelectionChange, {
                    player = currentPlayer,
                })
                -- Event onEntitySelection
                game.raise_event(events.onEntitySelection, {
                    player = currentPlayer,
                })

            elseif (nil == currentPlayer.selected and
                    nil ~= Ly.lastSelection[currentPlayer.index] ) then

                global.isSelectedEntity = false;

                -- Event onEmptySelection
                game.raise_event(events.onEmptySelection, {
                    player = currentPlayer,
                })
                -- Event onSelectionChange
                game.raise_event(events.onSelectionChange, {
                    player = currentPlayer,
                })

            end

            if( Ly.lastSelection[currentPlayer.index] == nil or
                currentPlayer.position.x ~= Ly.lastSelection[currentPlayer.index].position.x or
                currentPlayer.position.y ~= Ly.lastSelection[currentPlayer.index].position.y ) then
                -- Event onPlayerPositionMove
                game.raise_event(events.onPlayerPositionChange, {
                    player = currentPlayer,
                })
            end


            -- store current player status
            Ly.lastSelection[currentPlayer.index] = currentPlayer.selected
        end
    end
end)

