
script.on_event({ defines.events.onEmptySelection }, function(event)
    Ly.log("event onEmptySelection fired")

    global.isSelectedEntity = false;

    LyDevGUI.gui.varsRoot.selection.caption = {"txt.mod.selection.nothing" }

    local tableStr = LyDevGUI.options.guiPosVars .."." .. LyDevGUI.gui.varsRootName

    if(LyDevGUI.options.showSelectedVars and LyDevGUI.options.showVarsWOValues) then
        updateLabels(
            tableStr,
            LyDevGUI.SELECTED_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
        updateLabels(
            tableStr,
            LyDevGUI.GHOST_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.SELECTED_FIELDS
        )
        destroyLabels(
            tableStr,
            LyDevGUI.GHOST_FIELDS
        )
    end

    if(LyDevGUI.options.showElectricVars and LyDevGUI.options.showVarsWOValues) then
        updateLabels(
            tableStr,
            LyDevGUI.ELECTRIC_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.ELECTRIC_FIELDS
        )
    end

    if(LyDevGUI.options.showVehicleVars and LyDevGUI.options.showVarsWOValues) then
        updateLabels(
            tableStr,
            LyDevGUI.VEHICLE_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.VEHICLE_FIELDS
        )
    end

    if(LyDevGUI.options.showProtoVars and LyDevGUI.options.showVarsWOValues) then
        updateLabels(
            tableStr,
            LyDevGUI.PROTO_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.PROTO_FIELDS
        )
    end

    if (LyDevGUI.options.showStackVars and LyDevGUI.options.showVarsWOValues) then
        updateLabels(
            tableStr,
            LyDevGUI.STACK_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
    else
        destroyLabels(
            tableStr,
            LyDevGUI.STACK_FIELDS
        )
    end

end)