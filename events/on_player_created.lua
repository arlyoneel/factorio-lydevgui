
script.on_event(defines.events.on_player_created, function(event)
    Ly.log("events.on_player_created fired")

    Ly.setContext(CONST.CONTEXT.ON_PLAYER_CREATED)
    Ly.setPlayerIndex(event.player_index)

    Ly.log(Ly.stringConcat(2, "on_player_created - Ly.setContext() value=", CONST.CONTEXT.ON_PLAYER_CREATED))
    Ly.log(Ly.stringConcat(2, "on_player_created - Ly.setPlayerIndex() value=", event.player_index))

    -- prepare guiRootString to check if exist
    local guiMainRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosMain) .. "." .. LyDevGUI.gui.mainRootName
    local guiVarsRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosVars) .. "." .. LyDevGUI.gui.varsRootName
    local guiOptsRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosOpts) .. "." .. LyDevGUI.gui.optsRootName

    Ly.log(Ly.stringConcat(2, "on_player_created - guiMainRootStr=", guiMainRootStr))
    Ly.log(Ly.stringConcat(2, "on_player_created - guiVarsRootStr=", guiVarsRootStr))
    Ly.log(Ly.stringConcat(2, "on_player_created - guiOptsRootStr=", guiOptsRootStr))

    if(Ly.getDynVar(guiMainRootStr) == nil) then
        -- if not, i obtain the selected pos in guiPosOpts game.player...gui.POS (parent of guiOptsRootStr)
        local guiPosMain = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosMain))
        local guiPosVars = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosVars))
        local guiPosOpts = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosOpts))

        -- add main child objects
        guiPosMain.add{ type="table", colspan=4, name=LyDevGUI.gui.mainRootName }
        guiPosVars.add{ type="table", colspan=2, name=LyDevGUI.gui.varsRootName }
        guiPosOpts.add{ type="flow",  name=LyDevGUI.gui.optsRootName }

        -- table roots
        local mainRoot = Ly.getDynVar(guiMainRootStr)
        local varsRoot = Ly.getDynVar(guiVarsRootStr)
        local optsRoot = Ly.getDynVar(guiOptsRootStr)

        -- add GUIobjects to table(s)

        -- options and title
        mainRoot.add{ type = "button", name = "showOptions", caption = "..." }
        mainRoot.add{ type = "label", name="modInfo",
            caption= Ly.stringConcat(3, CONST.INFO.MOD_NAME," v", CONST.INFO.MOD_VERSION)
        }
        mainRoot.add { type = "label", name = "sep0", caption = " - " }
        mainRoot.add { type = "label", name = "selection", caption = {"txt.mod.selection.nothing"} }

        LyDevGUI.gui.mainRoot = mainRoot;
        LyDevGUI.gui.varsRoot = varsRoot;
        LyDevGUI.gui.optsRoot = optsRoot;
    end

    -- refresh labels
    -- refresh labels
    game.raise_event(events.onPlayerPositionChange, {
        player = Ly.getPlayer(),
    })
    game.raise_event(events.onEmptySelection, {
        player = Ly.getPlayer(),
    })
end)