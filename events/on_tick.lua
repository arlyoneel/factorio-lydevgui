
script.on_event(defines.events.on_tick, function(event)

    if(event.tick % CONST.ON_TICK.GUI_TICKS_UPDATE == 0) then

        Ly.setContext(CONST.CONTEXT.ON_TICK)

        for i, currentPlayer in pairs(game.connected_players) do
            -- store current working player index for functions calls
            Ly.setPlayerIndex(currentPlayer.index)
            initGuiRoots()

            -- --------------------------------------------------------------
            -- Custom event trigger
            -- --------------------------------------------------------------
            if( global.lastPlayerInfo[currentPlayer.index] ~= nil and
                currentPlayer.position ~= nil and
                currentPlayer.position.x ~= nil and (
                currentPlayer.position.x ~= global.lastPlayerInfo[currentPlayer.index].position.x or
                currentPlayer.position.y ~= global.lastPlayerInfo[currentPlayer.index].position.y )) then

                -- Event onPlayerPositionMove
                game.raise_event(events.onPlayerPositionChange, {
                    player = currentPlayer,
                })

            end

            if (nil ~= currentPlayer.selected and
                    currentPlayer.selected ~= global.lastSelection[currentPlayer.index] ) then
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
                    nil ~= global.lastSelection[currentPlayer.index] ) then

                global.isSelectedEntity = false;

                -- Event onSelectionChange
                game.raise_event(events.onSelectionChange, {
                    player = currentPlayer,
                })

                -- Event onEmptySelection
                game.raise_event(events.onEmptySelection, {
                    player = currentPlayer,
                })

            end

            -- store current selected entity
            global.lastSelection[currentPlayer.index] = currentPlayer.selected
            -- player info
            global.lastPlayerInfo[currentPlayer.index] = {
                character = currentPlayer.character,
                position = {
                    x = currentPlayer.position.x,
                    y = currentPlayer.position.y
                }
            }
        end
    end
end)

