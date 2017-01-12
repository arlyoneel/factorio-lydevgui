require("libraries.loader")


events = defines.events
events.onSelectionChange = script.generate_event_name()
events.onEmptySelection = script.generate_event_name()
events.onEntitySelection = script.generate_event_name()

script.on_init(function()
    if (Ly.lastSelection == nil) then
        Ly.lastSelection = {};
    end
    if ( global.isSelectedEntity == nil ) then
        global.isSelectedEntity = false;
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    Ly.log("events.on_player_created fired")

    Ly.setContext(CONST.CONTEXT.ON_PLAYER_CREATED)
    Ly.setPlayerIndex(event.player_index)

    Ly.log(Ly.stringConcat(2, "on_player_created - Ly.setContext() value=", CONST.CONTEXT.ON_PLAYER_CREATED))
    Ly.log(Ly.stringConcat(2, "on_player_created - Ly.setPlayerIndex() value=", event.player_index))

    -- prepare guiRootString to check if exist
    local guiMainRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosMain) .. "." .. LyDevGUI.gui.mainRootName
    local guiVarsRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosVars) .. "." .. LyDevGUI.gui.varsRootName
    local guiOptsRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosVars) .. "." .. LyDevGUI.gui.optsRootName

    Ly.log(Ly.stringConcat(2, "on_player_created - guiMainRootStr=", guiMainRootStr))
    Ly.log(Ly.stringConcat(2, "on_player_created - guiVarsRootStr=", guiVarsRootStr))

    if(Ly.getDynVar(guiOptsRootStr) == nil) then
        -- if not, i obtain the selected pos in guiPosOpts game.player...gui.POS (parent of guiOptsRootStr)
        local guiPosMain = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosMain))
        local guiPosVars = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosVars))

        -- add child tables
        guiPosMain.add{ type="table", colspan=4, name=LyDevGUI.gui.mainRootName }
        guiPosVars.add{ type="table", colspan=2, name=LyDevGUI.gui.varsRootName }

        -- table roots
        local mainRoot = Ly.getDynVar(guiMainRootStr)
        local varsRoot = Ly.getDynVar(guiVarsRootStr)
        local optsRoot = Ly.getDynVar(guiOptsRootStr)

        -- add GUIobjects to table(s)

        -- options and title
        mainRoot.add{ type = "button", name = "optBtn", caption = "..." }
        mainRoot.add{ type = "label", name="modInfo",
            caption= Ly.stringConcat(3, CONST.INFO.MOD_NAME," v", CONST.INFO.MOD_VERSION)
        }
        mainRoot.add { type = "label", name = "sep0", caption = " - " }
        mainRoot.add { type = "label", name = "selection", caption = {"txt.mod.selection.nothing"} }

        LyDevGUI.gui.mainRoot = mainRoot;
        LyDevGUI.gui.varsRoot = varsRoot;
        LyDevGUI.gui.optsRoot = optsRoot;
    end

end)

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

            -- store current player status
            Ly.lastSelection[currentPlayer.index] = currentPlayer.selected
        end
    end
end)

script.on_event(defines.events.on_gui_click, function(event)

    if (event.element.name == "showPlayerVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showPlayerVars = true;
        else
            LyDevGUI.options.showPlayerVars = false;
        end
    end

    if (event.element.name == "showStackVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showStackVars = true;
        else
            LyDevGUI.options.showStackVars = false;
        end
    end

    if (event.element.name == "showProtoVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showProtoVars = true;
        else
            LyDevGUI.options.showProtoVars = false;
        end
    end

    if (event.element.name == "showSelectedVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showSelectedVars = true;
        else
            LyDevGUI.options.showSelectedVars = false;
        end
    end
end)


-- CUSTOM Event definitions

script.on_event({ events.onSelectionChange }, function(event)
    Ly.log("event onSelectionChange fired")

end)

script.on_event({ events.onEntitySelection }, function(event)
    local guiVarsRoot = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosVars))
    --Ly.print("event onEntitySelection fired")

    LyDevGUI.gui.mainRoot.selection.caption = {"txt.mod.selection.selected" }

    local tableStr = LyDevGUI.options.guiPosVars .."." .. LyDevGUI.gui.varsRootName

    Ly.log("onEntitySelection - update player labels")
    -- update player labels
    updateLabels(tableStr,
        LyDevGUI.PLAYER_FIELDS,
        LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
    )

    if(event.player.character ~= nil) then
        updateLabels(tableStr,
            LyDevGUI.CHARACTER_FIELDS,
            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
        )
    else
        updateLabels(tableStr,
            LyDevGUI.CHARACTER_FIELDS,
            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN,
            {"txt.na"}
        )
    end

    updateLabels(
        tableStr,
        LyDevGUI.SELECTED_FIELDS,
        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
    )

    updateLabels(
        tableStr,
        LyDevGUI.PROTO_FIELDS,
        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
    )

    if (event.player.selected.type == "item-entity" and
            event.player.selected.name == "item-on-ground") then

        if(LyDevGUI.options.showStackVars) then
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

    else
        updateLabels(
            tableStr,
            LyDevGUI.STACK_FIELDS,
            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
            {"txt.na"}
        )
    end

end)

script.on_event({ events.onEmptySelection }, function(event)
    Ly.log("event onEmptySelection fired")
    --Ly.print("event onEmptySelection fired")
    LyDevGUI.gui.mainRoot.selection.caption = {"txt.mod.selection.nothing"}
end)