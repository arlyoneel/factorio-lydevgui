require("library")
require("defines")
require("lydevgui")

script.on_event(defines.events.on_player_created, function(event)

    -- get dynamically position of gui option based LyDevGUI.options.guiPos*
    LyDevGUI.tmp.str.pcGuiVars = "game.players["..event.player_index .. "].gui." .. LyDevGUI.options.guiPosVars
    Ly.log("LyDevGUI.tmp.str.pcGuiVars="..LyDevGUI.tmp.str.pcGuiVars)
    LyDevGUI.tmp.obj.pcGuiVars = LyUtils.getDynVar(LyDevGUI.tmp.str.pcGuiVars)

    LyDevGUI.tmp.str.pcGuiOpts = "game.players["..event.player_index .. "].gui." .. LyDevGUI.options.guiPosOpts
    Ly.log("LyDevGUI.tmp.str.pcGuiOpts="..LyDevGUI.tmp.str.pcGuiOpts)
    LyDevGUI.tmp.obj.pcGuiOpts = LyUtils.getDynVar(LyDevGUI.tmp.str.pcGuiOpts)

    if LyDevGUI.tmp.obj.pcGuiVars.lyDevGUI == nil then
        LyDevGUI.tmp.obj.pcGuiVars.add{
            type = "flow",
            name="lyDevGUI",
        }
        LyDevGUI.tmp.obj.pcGuiVars.lyDevGUI.add{
            type = "table",
            colspan = 2,
            name = "lyContent",
        }

        LyDevGUI.tmp.obj.pcGuiVars.lyDevGUI.lyContent.add {
            type = "label",
            name = "vTitle",
            caption = {"lydevgui.selection.nothing"}
        }

        LyDevGUI.tmp.obj.pcGuiVars.lyDevGUI.lyContent.add {
            type = "label",
            name = "dummie",
            caption = "",
        }
    end

    if LyDevGUI.tmp.obj.pcGuiOpts.lyOptions == nil then

        LyDevGUI.tmp.obj.pcGuiOpts.add{
            type = "table",
            name="lyOptions",
            colspan = 5,
        }

        LyDevGUI.tmp.obj.pcGuiOpts.lyOptions.add{
            type = "label",
            name="modInfo",
            caption= {"lydevgui.options.title",const.MOD_NAME .. " v".. const.MOD_VERSION .." -","->"}
        }

        LyDevGUI.tmp.obj.pcGuiOpts.lyOptions.add{
            type="checkbox",
            name="showPlayerVars",
            state=LyDevGUI.options.showPlayerVars,
            caption={"lydevgui.options.show", "player"}
        }

        LyDevGUI.tmp.obj.pcGuiOpts.lyOptions.add{
            type="checkbox",
            name="showSelectedVars",
            state=LyDevGUI.options.showSelectedVars,
            caption={"lydevgui.options.show", "selected"}
        }

        LyDevGUI.tmp.obj.pcGuiOpts.lyOptions.add{
            type="checkbox",
            name="showStackVars",
            state=LyDevGUI.options.showStackVars,
            caption={"lydevgui.options.show", "stack"}
        }

        LyDevGUI.tmp.obj.pcGuiOpts.lyOptions.add{
            type="checkbox",
            name="showProtoVars",
            state=LyDevGUI.options.showProtoVars,
            caption={"lydevgui.options.show", "proto"}
        }
    end

    LyDevGUI.tmp.obj.pcGuiVars = nil
    LyDevGUI.tmp.obj.pcGuiOpts = nil
    LyDevGUI.tmp.str.pcGuiVars = nil
    LyDevGUI.tmp.str.pcGuiOpts = nil
end)

script.on_event(defines.events.on_tick, function(event)
    for i, currentPlayer in pairs(game.connected_players) do
        -- store current working player index for future functions
        Ly.playerIndex = i

        LyDevGUI.tmp.str.guiVars = "game.connected_players["..i.. "].gui." .. LyDevGUI.options.guiPosVars
        Ly.log("LyDevGUI.tmp.str.guiVars="..LyDevGUI.tmp.str.guiVars)
        LyDevGUI.tmp.obj.guiVars = LyUtils.getDynVar(LyDevGUI.tmp.str.guiVars)

        LyDevGUI.tmp.str.guiOpts = "game.connected_players["..i.. "].gui." .. LyDevGUI.options.guiPosOpts
        Ly.log("LyDevGUI.tmp.str.guiOpts="..LyDevGUI.tmp.str.guiOpts)
        LyDevGUI.tmp.obj.guiOpts = LyUtils.getDynVar(LyDevGUI.tmp.str.guiOpts)

        if nil ~= LyDevGUI.tmp.obj.guiVars.lyDevGUI then
            if nil ~= currentPlayer.selected then
                Ly.log("entity selected")
                LyDevGUI.tmp.obj.guiVars.lyDevGUI.lyContent.vTitle.caption = {"lydevgui.selection.selected"}

                if(LyDevGUI.options.showPlayerVars) then
                    Ly.log("update player labels")
                    -- update player labels
                    updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PLAYER_FIELDS,
                        LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
                    )

                    if(currentPlayer.character ~= nil) then
                        updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.CHARACTER_FIELDS,
                            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
                        )
                    else
                        updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.CHARACTER_FIELDS,
                            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN,
                            LyDevGUI.NA
                        )
                    end
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PLAYER_FIELDS
                    )

                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.CHARACTER_FIELDS
                    )
                end

                if(LyDevGUI.options.showSelectedVars) then
                    Ly.log("update selected labels")
                    -- update selected labels
                    updateLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.SELECTED_FIELDS,
                        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
                    )
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.SELECTED_FIELDS
                    )
                end

                if(LyDevGUI.options.showProtoVars) then
                    Ly.log("update selected labels")
                    -- update selected labels
                    updateLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PROTO_FIELDS,
                        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
                    )
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PROTO_FIELDS
                    )
                end

                if (currentPlayer.selected.type == "item-entity" and
                        currentPlayer.selected.name == "item-on-ground") then

                    if(LyDevGUI.options.showStackVars) then
                        Ly.log("update stack fields")
                        -- update stack labels
                        updateLabels(
                            ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.STACK_FIELDS,
                            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
                        )
                    else
                        Ly.log("destroy stack fields")
                        -- destroy stack labels
                        destroyLabels(
                            ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.STACK_FIELDS
                        )
                    end

                else
                    if(LyDevGUI.options.showStackVars) then
                        Ly.log("update stack fields")
                        -- update stack labels
                        updateLabels(
                            ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.STACK_FIELDS,
                            LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
                            LyDevGUI.NA
                        )
                    else
                        Ly.log("destroy stack fields")
                        -- destroy stack labels
                        destroyLabels(
                            ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.STACK_FIELDS
                        )
                    end
                end

            else
                LyDevGUI.tmp.obj.guiVars.lyDevGUI.lyContent.vTitle.caption = {"lydevgui.selection.nothing"}

                if(LyDevGUI.options.showPlayerVars) then
                    Ly.log("update player labels")
                    -- update player labels
                    updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PLAYER_FIELDS,
                        LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
                    )

                    if(currentPlayer.character ~= nil) then
                        updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.CHARACTER_FIELDS,
                            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
                        )
                    else
                        updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                            LyDevGUI.CHARACTER_FIELDS,
                            LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN,
                            LyDevGUI.NA
                        )
                    end
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PLAYER_FIELDS
                    )

                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.CHARACTER_FIELDS
                    )
                end



                if(LyDevGUI.options.showSelectedVars) then
                    Ly.log("update selected labels")
                    -- update selected labels
                    updateLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.SELECTED_FIELDS,
                        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
                        LyDevGUI.NA
                    )
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.SELECTED_FIELDS
                    )
                end

                if(LyDevGUI.options.showProtoVars) then
                    Ly.log("update selected labels")
                    -- update selected labels
                    updateLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PROTO_FIELDS,
                        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
                        LyDevGUI.NA
                    )
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.PROTO_FIELDS
                    )
                end

                if(LyDevGUI.options.showStackVars) then
                    Ly.log("update selected labels")
                    -- update selected labels
                    updateLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.STACK_FIELDS,
                        LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
                        LyDevGUI.NA
                    )
                else
                    destroyLabels(
                        ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                        LyDevGUI.STACK_FIELDS
                    )
                end
            end
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