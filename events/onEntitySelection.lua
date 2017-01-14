
script.on_event({ defines.events.onEntitySelection }, function(event)

    global.isSelectedEntity = true

    LyDevGUI.gui.varsRoot.selection.caption = {"txt.mod.selection.selected" }

    local tableStr = LyDevGUI.options.guiPosVars .."." .. LyDevGUI.gui.varsRootName

    Ly.log("onEntitySelection - update player labels")
    -- update player labels

    if(LyDevGUI.options.showSelectedVars) then
        updateLabels(
            tableStr,
            LyDevGUI.SELECTED_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.SELECTED_FIELDS
        )
    end

    if(LyDevGUI.options.showProtoVars) then
        updateLabels(
            tableStr,
            LyDevGUI.PROTO_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.PROTO_FIELDS
        )
    end

    if (LyDevGUI.options.showStackVars and
            event.player.selected.type == "item-entity" and
            event.player.selected.name == "item-on-ground") then

        updateLabels(
            tableStr,
            LyDevGUI.STACK_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.STACK_FIELDS
        )
    end
end)