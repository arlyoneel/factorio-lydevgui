
script.on_event({ defines.events.onSelectionChange }, function(event)
    -- store current selected entity
    global.lastSelection[event.player.index] = event.player.selected
end)