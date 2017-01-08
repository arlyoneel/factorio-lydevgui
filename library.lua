-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- LyUtils - NON FACTORIO STUFF
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------

LyUtils = {}
function LyUtils.getDynVar(field)
    Ly.log("LyUtils.getDynVar() field=" .. field)
    if(debug.getinfo(2) ~= nil and debug.getinfo(2).name ~= nil) then
        Ly.log("LyUtils.getDynVar() caller="..debug.getinfo(2).name)
    end
    local fn = loadstring(
        "return " .. field
    )
    return fn()
end
-- "constants" idea from -> http://andrejs-cainikovs.blogspot.com.ar/2009/05/lua-constants.html
function LyUtils.protectConstants(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                    tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

function LyUtils.varToString(variable)
    if nil == variable then
        variable = "NIL";
    end

    if ("boolean" == type(variable)) then
        if (true == variable) then
            variable = "TRUE";
        else
            variable = "FALSE";
        end
    end
    return variable;
end

function LyUtils.printTable(table)
    local indent = " "
    for key,value in pairs(table) do
        if type(value) == "table" then
            print(indent..key.."["..type(value).."]")
            printEventTableDump(value, indent..indentor)
        else
            if type(value) == "boolean" then
                if value then
                    print(indent..key.."["..type(value).."]=".."TRUE")
                else
                    print(indent..key.."["..type(value).."]=".."FALSE")
                end
            else
                if (type(value) == "function") or (type(value) == "userdata") then
                    print(indent..key.."["..type(value).."]")
                else
                    print(indent..key.."["..type(value).."]="..value)
                end
            end
        end
    end
end

function LyUtils.string_split(str, pattern, results)
    if not results then
        results = {}
    end

    for i in string.gmatch(str, "([^".. pattern .."]*)") do
        table.insert( results, i)
    end
    return results;
end

-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- Lua extensions
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------

function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- LyUtils - Factorio specific
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------

Ly = {
    playerIndex = -1,
    logEnabled = false,
}
function Ly.getPlayerStr(index)
    local str
    if (nil == index) then
        str = "game.connected_players["..Ly.playerIndex.."]"
    else
        str ="game.connected_players["..index.."]"
    end
    return str;
end
function Ly.getPlayer(index, suffix)
    local result;
    if (nil == suffix) then
        suffix = ""
    end

    if (nil == index) then
        result = LyUtils.getDynVar("game.connected_players["..Ly.playerIndex.."]"..suffix)
    else
        result = LyUtils.getDynVar("game.connected_players["..index.."]"..suffix)
    end
    return result
end

function Ly.getGuiStr(index)
    return Ly.getPlayerStr(index) .. ".gui"
end

function Ly.getGui(index)
    return Ly.getPlayer(index,".gui");
end

function Ly.logTable(table)
    local indent = " "
    for key,value in pairs(table) do
        if type(value) == "table" then
            Ly.log(indent..key.."["..type(value).."]")
            Ly.logTable(value, indent)
        else
            if type(value) == "boolean" then
                if value then
                    Ly.log(indent..key.."["..type(value).."]=".."TRUE")
                else
                    Ly.log(indent..key.."["..type(value).."]=".."FALSE")
                end
            else
                if (type(value) == "function") or (type(value) == "userdata") then
                    Ly.log(indent..key.."["..type(value).."]")
                else
                    Ly.log(indent..key.."["..type(value).."]="..value)
                end
            end
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

function Ly.log(message)
    if(Ly.logEnabled == true) then
        log(message)
    end
end