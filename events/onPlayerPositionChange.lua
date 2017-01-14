script.on_event({ defines.events.onPlayerPositionChange }, function(event)
    -- Ly.log("event onPlayerPositionChange fired")
    local tableStr = LyDevGUI.options.guiPosVars .."." .. LyDevGUI.gui.varsRootName

    if(LyDevGUI.options.showPlayerVars) then
        updateLabels(tableStr,
            LyDevGUI.PLAYER_FIELDS,
            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
        )
        if(event.player.character ~= nil) then
            updateLabels(tableStr,
                LyDevGUI.CHARACTER_FIELDS,
                LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
            )
        end
    elseif(LyDevGUI.options.showPlayerVars and LyDevGUI.options.showVarsWOValues) then
        destroyLabels(
            tableStr,
            LyDevGUI.PLAYER_FIELDS
        )
        destroyLabels(
            tableStr,
            LyDevGUI.CHARACTER_FIELDS
        )
    end
end)

