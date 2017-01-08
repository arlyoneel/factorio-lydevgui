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
            name = "fTitle",
            caption = const.MOD_NAME .. " v".. const.MOD_VERSION,
        }

        LyDevGUI.tmp.obj.pcGuiVars.lyDevGUI.lyContent.add {
            type = "label",
            name = "vTitle",
            caption = "Nothing selected",
        }
        --currentPlayer.gui.center.lyOptions.add{
        --    type="checkbox",
        --    name="showPlayerVars",
        --    caption="Show player variables"
        --}
    end

    if LyDevGUI.tmp.obj.pcGuiOpts.lyOptions == nil then
        LyDevGUI.tmp.obj.pcGuiOpts.add {
            type = "table",
            name="lyOptions",
            colspan=1
        }
        LyDevGUI.tmp.obj.pcGuiOpts.lyOptions.add{
            type = "label",
            name="optsLabel",
            caption="LyGUIOptions"
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
                LyDevGUI.tmp.obj.guiVars.lyDevGUI.lyContent.vTitle.caption = "Entity selected"

                Ly.log("update player fields")
                -- update player labels
                updateLabels(".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                    LyDevGUI.PLAYER_FIELDS,
                    LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
                )

                Ly.log("update selected fields")
                -- update player labels
                updateLabels(
                    ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                    LyDevGUI.SELECTED_FIELDS,
                    LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN
                )

                if (currentPlayer.selected.type == "item-entity" and
                        currentPlayer.selected.name == "item-on-ground") then

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
                LyDevGUI.tmp.obj.guiVars.lyDevGUI.lyContent.vTitle.caption = "Nothing selected"

                -- update player labels
                Ly.log("update player fields")
                updateLabels(
                    ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                    LyDevGUI.PLAYER_FIELDS,
                    LyDevGUI.FIELDS_PLAYER_REMOVE_PATTERN
                )

                -- update selected labels
                Ly.log("update selected fields, FORCED to N/A")
                updateLabels(
                    ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                    LyDevGUI.SELECTED_FIELDS,
                    LyDevGUI.FIELDS_SELECTED_REMOVE_PATTERN,
                    LyDevGUI.NA
                )

                -- update stack labels
                Ly.log("destroy stack fields")
                destroyLabels(
                    ".".. LyDevGUI.options.guiPosVars ..".lyDevGUI.lyContent",
                    LyDevGUI.STACK_FIELDS
                )
            end
        end
    end
end)
