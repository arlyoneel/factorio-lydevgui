
script.on_init(function()
    if (Ly.lastSelection == nil) then
        Ly.lastSelection = {};
    end
    if ( global.isSelectedEntity == nil ) then
        global.isSelectedEntity = false;
    end
end)

