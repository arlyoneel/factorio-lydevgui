-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- Ly - Factorio specific
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------

function Ly.init()
    -- player index, unassigned = -1
    Ly.playerIndex = CONST.INITIAL.INDEX
    -- this enables/disables Ly.log() calls
    Ly.logEnabled = CONST.INITIAL.LOG_ENABLED
    -- define working context
    Ly.eventContext = CONST.CONTEXT.ON_PLAYER_CREATED;
end

function Ly.setContext(context)
    Ly.eventContext = context;
end

function Ly.setPlayerIndex(idx)
    Ly.playerIndex = idx;
end


function Ly.getPlayerStr(index, context, suffix)
    local str

    if(context ~= nil) then
        Ly.eventContext = context
    end
    if(index == nil) then
        index = Ly.playerIndex
    end

    Ly.log(Ly.stringConcat(4, "Ly.getPlayerStr() index=", index, " context=", context, " suffix=", suffix))
    if( Ly.eventContext == CONST.CONTEXT.ON_PLAYER_CREATED ) then
        str = "game.players[" .. index .. "]"
    elseif (Ly.eventContext == CONST.CONTEXT.ON_TICK) then
        str = "game.connected_players[" .. index .. "]"
    end

    Ly.log(Ly.stringConcat(2, "Ly.getPlayerStr() result==", str))

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

    Ly.log(Ly.stringConcat(4, "Ly.getPlayer() index=", index, " context=",context, " suffix=", suffix))
    result = Ly.getDynVar(Ly.getPlayerStr(index, context, suffix))
    Ly.log(Ly.stringConcat(1, result))

    return result
end

function Ly.getGuiStr(guiPos, index, context)
    if(guiPos == nil ) then
        guiPos = ""
    end
    Ly.log(Ly.stringConcat(6,"Ly.getGuiStr() guiPos=", guiPos, " index=", index,  " context=", context))
    local result = Ly.getPlayerStr(index, context) .. ".gui." .. guiPos
    Ly.log(Ly.stringConcat(2,"Ly.getGuiStr() result==", result))
    return result
end

function Ly.getGui(guiPos, index, context)
    Ly.log(Ly.stringConcat(6,"Ly.getGui() guiPos=", guiPos, " index=", index,  " context=", context))
    return Ly.getDynVar(Ly.getGuiStr(guiPos, index, context))
end

function Ly.log(message)
    if(Ly.logEnabled == true) then
        if(type(message) == 'userdata') then
            message = type(message)
        end
        if(debug.getinfo(2) ~= nil and debug.getinfo(2).name ~= nil) then
            log(Ly.stringConcat(4, "Ly.log() from=", debug.getinfo(2).name, " msg=", message))
        else
            log(message)
        end
    end
end

function Ly.logTable(tab, indent, ignoreChildTables)
    if (indent == nil) then
        indent = LY.STR.PRINT_INDENT
    end
    for key,value in pairs(tab) do
        if (type(value) == "table") or (type(value) == "function") or (type(value) == "userdata") then
            Ly.log(indent..Ly.brackets(key).."= " ..  Ly.rounds(type(value)) )
            if (type(value) == "table" and ignoreChildTables ~= true) then
                Ly.logTable(value, indent..indent)
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


function Ly.destroyGuiElements(myRootStr, nameList, prefix, suffix)
    myRootStr = Ly.getGuiStr() .. myRootStr
    local myRoot = LyUtils.getDynVar(myRootStr)

    if( nil ~= prefix) then
        prefix = ""
    end
    if( nil ~= suffix) then
        suffix = ""
    end

    for element in pairs(nameList) do
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


--[[
-- writes a file to .factorio/script-output directory,
-- it automatically creates parent folder if needed.
 ]]
function Ly.writeEntity(file, contentTable)
    local content = json.encode(contentTable, {indent = true})
    Ly.log(Ly.stringConcat(6,"Ly.writeEntity() file=", file, " contentTable=", contentTable,  " content(json)=", content))
    game.write_file(file, content)
end


function Ly.getDynVar(field)
    Ly.log(Ly.stringConcat(2, "field=", field))
    if(debug.getinfo(2) ~= nil and debug.getinfo(2).name ~= nil) then
        Ly.log(Ly.stringConcat(2, "Ly.getDynVar() caller=", debug.getinfo(2).name))
    end
    local fnStr = Ly.stringConcat(2, "return ", field)

    Ly.log(Ly.stringConcat(2, "Ly.getDynVar() fnStr=", fnStr))
    if(Ly.stringConcat(1, field) == LY.STR.NIL) then
        -- value is null
        return nil;
    elseif( CONST.INITIAL.DYN_VAR_PROTECTED_MODE ) then -- protected mode
        Ly.log("Ly.getDynVar() - protected mode is enabled")
        local fn = load(fnStr)
        if( pcall( fn ) ) then
            local result = fn()
            Ly.log(Ly.stringConcat(2, "Ly.getDynVar() - valid!, result=", result))
            return result
        else
            Ly.log("Ly.getDynVar() - invalid!, result=[NIL]")
            return nil
        end
    elseif(false == CONST.INITIAL.DYN_VAR_PROTECTED_MODE) then
        local fn = load(fnStr)
        local result = fn()
        Ly.log(Ly.stringConcat(2, "Ly.getDynVar(), result=",result))
        return result
    end
end


function Ly.print(message)
    if (Ly.playerIndex ~= CONST.INITIAL.INDEX) then
        local p = Ly.getPlayer()
        p.print(message)
    else
        Ly.log(Ly.stringConcat(2,"[ERROR] Cannot print, playerIndex not defined: ", message))
    end
end

function Ly.printTable(tab, indent, ignoreChildTables)
    if (indent == nil) then
        indent = LY.STR.PRINT_INDENT
    end
    for key,value in pairs(tab) do
        if (type(value) == "table") or (type(value) == "function") or (type(value) == "userdata") then
            Ly.print(indent..Ly.brackets(key).."= " ..  Ly.rounds(type(value)) )
            if (type(value) == "table" and ignoreChildTables ~= true) then
                Ly.printTable(value, indent..indent)
            end
        else
            Ly.print(indent..Ly.brackets(key).."="..Ly.toString(value).." "..Ly.rounds(type(value)))
        end
    end
end

function Ly.refreshConnectedPlayerIndexCache()
    for k,v in pairs(game.connected_players) do
        global.lyConnectedPlayersIndexCache[v.name] = k
    end
end

function Ly.refreshPlayerIndexCache()
    for k,v in pairs(game.players) do
        global.lyPlayersIndexCache[v.name] = k
    end
end

function Ly.getPlayerIndexFromTable(playerList, targetName)
    local idx;
    for k,v in pairs(playerList) do
        if (v.name == targetName) then
            idx = k
        end
    end
    return idx
end


