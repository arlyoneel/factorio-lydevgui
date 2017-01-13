script.on_event(defines.events.on_gui_click, function(event)
    local evtName

    -- workaround for fake events, event object is read only
    if (global.fakeEvent) then
        evtName = global.fakeEvent
        global.fakeEvent = false;
    else
        evtName = event.element.name
    end

    if (evtName == "showOptions") then
        if(LyDevGUI.gui.optsRoot.frame == nil) then

            LyDevGUI.gui.optsRoot.add{ type="frame", name="frame", caption="", direction="vertical" }
            LyDevGUI.gui.optsRoot.frame.add{ type="table", name="frameTitle", colspan=3 }

            -- hack to use X to close
            LyDevGUI.gui.optsRoot.frame.frameTitle.add{
                type="label", name="frameTitle", caption={"txt.mod.options.frameTitle", CONST.INFO.MOD_NAME .. " v" ..  CONST.INFO.MOD_VERSION}
            }
            LyDevGUI.gui.optsRoot.frame.frameTitle.add{
                type="label", name="frameSeparator", caption="                 "
            }
            LyDevGUI.gui.optsRoot.frame.frameTitle.add{
                type="button", name="frameTitleClose", caption=" X "
            }

            -- option misc label
            LyDevGUI.gui.optsRoot.frame.add{ type="label",
                name="generalLabel", caption={"txt.mod.options.generalLabel" }
            }
            -- option misc
            LyDevGUI.gui.optsRoot.frame.add{ type="checkbox",
                name="showVarsWOValues", state=LyDevGUI.options.showVarsWOValues,
                caption={"txt.mod.options.showVarsWOValues"}
            }

            -- option vars label
            LyDevGUI.gui.optsRoot.frame.add{ type="label", name="contentLabel",
                caption={"txt.mod.options.varsLabel" }
            }
            -- option vars table
            LyDevGUI.gui.optsRoot.frame.add{ type="table", name="varTbl", colspan=2 }
            -- options vars
            LyDevGUI.gui.optsRoot.frame.varTbl.add{
                type="checkbox", name="showPlayerVars",
                state=LyDevGUI.options.showPlayerVars,
                caption={"txt.show1", "player"}
            }

            LyDevGUI.gui.optsRoot.frame.varTbl.add{
                type="checkbox", name="showSelectedVars",
                state=LyDevGUI.options.showSelectedVars,
                caption={"txt.show1", "selected"}
            }

            LyDevGUI.gui.optsRoot.frame.varTbl.add{
                type="checkbox", name="showStackVars",
                state=LyDevGUI.options.showStackVars,
                caption={"txt.show1", "stack"}
            }

            LyDevGUI.gui.optsRoot.frame.varTbl.add{
                type="checkbox", name="showProtoVars",
                state=LyDevGUI.options.showProtoVars,
                caption={"txt.show1", "prototype"}
            }
        else
            -- call event with "frameTitleClose"
            -- fake event, because original event is read only
            global.fakeEvent = "frameTitleClose"
            game.raise_event(events.on_gui_click, { event = {}, })
        end
    elseif (evtName == "frameTitleClose") then
        if(LyDevGUI.gui.optsRoot.frame ~= nil) then
            LyDevGUI.gui.optsRoot.frame.destroy()
            -- refresh labels
            game.raise_event(events.onEmptySelection, {
                player = Ly.getPlayer(),
            })
        end
    elseif (evtName == "showPlayerVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showPlayerVars = true;
        else
            LyDevGUI.options.showPlayerVars = false;
        end
    elseif (evtName == "showStackVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showStackVars = true;
        else
            LyDevGUI.options.showStackVars = false;
        end
    elseif (evtName == "showProtoVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showProtoVars = true;
        else
            LyDevGUI.options.showProtoVars = false;
        end
    elseif( evtName == "showSelectedVars") then
        if (event.element.state == true) then
            LyDevGUI.options.showSelectedVars = true;
        else
            LyDevGUI.options.showSelectedVars = false;
        end
    elseif( evtName == "showVarsWOValues") then
        if (event.element.state == true) then
            LyDevGUI.options.showVarsWOValues = true;
        else
            LyDevGUI.options.showVarsWOValues = false;
        end
    end

end)