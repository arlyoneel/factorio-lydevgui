
script.on_init(function()
    if (Ly.lastSelection == nil) then
        Ly.lastSelection = {}
        Ly.lastPlayerInfo = {}
    end
    if ( global.isSelectedEntity == nil ) then
        global.isSelectedEntity = false;
    end
end)

