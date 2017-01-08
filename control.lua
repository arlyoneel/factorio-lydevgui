require("library")
require("defines")
require("lydevgui")

script.on_event(defines.events.on_player_created, function(event)
    local currentPlayer = game.players[event.player_index]

    if currentPlayer.gui.top.lyDevGUI == nil then

        currentPlayer.gui.top.add { type = "flow", name = "lyDevGUI", }

        currentPlayer.gui.top.lyDevGUI.add {
            type = "table",
            colspan = 2,
            name = "lyContent",
        }

        currentPlayer.gui.top.lyDevGUI.lyContent.add { type = "label", name = "fTitle", caption = const.MOD_NAME .. " v".. const.MOD_VERSION, }
        currentPlayer.gui.top.lyDevGUI.lyContent.add { type = "label", name = "vTitle", caption = "Nothing selected", }
    end
end)

script.on_event(defines.events.on_tick, function(event)
    for i, currentPlayer in pairs(game.connected_players) do
        -- store current working player index for future functions
        Ly.playerIndex = i

        if nil ~= currentPlayer.gui.top.lyDevGUI then
            if nil ~= currentPlayer.selected then
                log("entity selected")
                currentPlayer.gui.top.lyDevGUI.lyContent.vTitle.caption = "Entity selected"

                log("update player fields")
                -- update player labels
                updateLabels(".top.lyDevGUI.lyContent",
                    const.PLAYER_FIELDS,
                    const.FIELDS_PLAYER_REMOVE_PATTERN
                )

                log("update selected fields")
                -- update player labels
                updateLabels(".top.lyDevGUI.lyContent",
                    const.SELECTED_FIELDS,
                    const.FIELDS_SELECTED_REMOVE_PATTERN
                )

                if (currentPlayer.selected.type == "item-entity" and
                        currentPlayer.selected.name == "item-on-ground") then

                    log("update stack fields")
                    -- update stack labels
                    updateLabels(
                        ".top.lyDevGUI.lyContent",
                        const.STACK_FIELDS,
                        const.FIELDS_SELECTED_REMOVE_PATTERN
                    )
                else
                    log("destroy stack fields")
                    -- destroy stack labels
                    destroyLabels(
                        ".top.lyDevGUI.lyContent",
                        const.STACK_FIELDS
                    )
                end

            else
                currentPlayer.gui.top.lyDevGUI.lyContent.vTitle.caption = "Nothing selected"

                -- update player labels
                log("update player fields")
                updateLabels(".top.lyDevGUI.lyContent",
                    const.PLAYER_FIELDS,
                    const.FIELDS_PLAYER_REMOVE_PATTERN
                )

                -- update selected labels
                log("update selected fields, FORCED to N/A")
                updateLabels(".top.lyDevGUI.lyContent",
                    const.SELECTED_FIELDS,
                    const.FIELDS_SELECTED_REMOVE_PATTERN,
                    const.NA
                )

                -- update stack labels
                log("destroy stack fields")
                destroyLabels(
                    ".top.lyDevGUI.lyContent",
                    const.STACK_FIELDS
                )
            end
        end
    end
end)
