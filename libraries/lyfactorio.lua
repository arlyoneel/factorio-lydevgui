-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- Ly - Factorio specific
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------

function Ly.init()
    -- player index, unassigned = -1
    Ly.playerIndex = -1
    -- this enables/disables Ly.log() calls
    Ly.logEnabled = false
    -- define working context
    Ly.eventContext = CONST.CONTEXT.ON_PLAYER_CREATE;
end

function Ly.setContext(context)
    Ly.eventContext = context;
end


function Ly.getPlayerStr(index, context)
    local str

    if(context ~= nil) then
        Ly.eventContext = context
    end

    if(index == nil) then
        index = Ly.playerIndex
    end

    if( Ly.eventContext == CONST.CONTEXT.ON_PLAYER_CREATE ) then
        str = "game.players["..index.."]"
    elseif (Ly.eventContext == CONST.CONTEXT.ON_TICK) then
        str = "game.connected_players["..index.."]"
    end


    return str;
end


function Ly.getPlayer(index, context, suffix)
    local result;
    if(context ~= nil) then
        Ly.eventContext = context
    end
    if(index == nil) then
        index = Ly.playerIndex
    end
    if (nil == suffix) then
        suffix = ""
    end

    if( Ly.eventContext == CONST.CONTEXT.ON_PLAYER_CREATE ) then
        result = Ly.getDynVar("game.players["..index.."]")
    elseif (Ly.eventContext == CONST.CONTEXT.ON_TICK) then
        result = Ly.getDynVar("game.connected_players["..index.."]")
    end

    return result
end

function Ly.getGuiStr(index)
    return Ly.getPlayerStr(index) .. ".gui"
end

function Ly.getGui(index)
    return Ly.getPlayer(index,".gui");
end

function Ly.log(message)
    if(Ly.logEnabled == true) then
        log(message)
    end
end

function Ly.logTable(tab, indent, indentor)
    if (indent == nil) then
        indent = LY.STR.INDENT
    end
    if (indentor == nil) then
        indentor = LY.STR.INDENTOR
    end
    for key,value in pairs(tab) do
        if (type(value) == "table") or (type(value) == "function") or (type(value) == "userdata") then
            Ly.log(indent..Ly.brackets(key).."= " ..  Ly.rounds(type(value)) )
            if (type(value) == "table") then
                Ly.logTable(value, indent..indentor)
            end
        else
            Ly.log(indent..Ly.brackets(key).."="..Ly.toString(value).." "..Ly.rounds(type(value)))
        end
    end
end

function Ly.existGuiElement(myRoot, name)
    local result = false;
    if( type(myRoot) == "string") then
        myRoot = LyUtils.getDynVar(Ly.getGuiStr() .. myRoot)
    end

    for chKey, chValue in pairs(myRoot.children_names) do
        if (chValue == name) then
            result = true;
            break;
        end
    end

    return result
end

function Ly.destroyGuiElement(myRootStr, name, prefix, suffix)
    local result = false;
    if( nil ~= prefix) then
        prefix = ""
    end
    if( nil ~= suffix) then
        suffix = ""
    end
    if(Ly.existGuiElement(myRootStr, name)) then
        local guiElement = LyUtils.getDynVar(Ly.getGuiStr() .. myRootStr "." .. prefix .. name .. suffix)
        guiElement.destroy()
    end
end


function Ly.destroyGuiElements(myRootStr, fieldList, prefix, suffix)
    myRootStr = Ly.getGuiStr() .. myRootStr
    local myRoot = LyUtils.getDynVar(myRootStr)

    if( nil ~= prefix) then
        prefix = ""
    end
    if( nil ~= suffix) then
        suffix = ""
    end

    for element in pairs(fieldList) do
        local exist = false;
        element = prefix .. element .. suffix
        for chName in pairs(myRoot.children_names) do
            if (chName == element) then
                exist = true;
                break;
            end
        end
        if (true == exist) then
            local guiElement = LyUtils.getDynVar(Ly.getGuiStr() .. myRootStr .. "." .. element)
            guiElement.destroy()
        end
    end
end

