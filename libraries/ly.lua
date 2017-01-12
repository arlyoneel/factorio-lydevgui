LY = {
    STR = {
        TRUE = "[TRUE]",
        FALSE = "[FALSE]",
        NIL = "[NIL]",
        OPEN = "[",
        CLOSE = "]",
        PRINT_INDENT = " ",
    },
}

-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- Ly - Generic functions
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
Ly = {
    new = function(init)
        local self = setmetatable({}, Ly)
        self.value = init
        return self
    end
}
Ly.__index = Ly

setmetatable(Ly, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

--[[
-- accepts quantity of variables and N variables to concatenate
-- nil are represented with [NIL]
-- booleans are represented with [TRUE] and [FALSE]
 ]]
function Ly.stringConcat(quantity, ...)
    local args  = {...}
    local text = ""
    local lastIndex = 0

    if(assert(type(quantity) == "number", "first parameter must be a number")) then

        for i,v in pairs(args) do
            while( lastIndex + 1 < i) do
                -- possible starting / middle nils
                text = text .. LY.STR.NIL
                lastIndex = lastIndex + 1
            end

            if(type(v) == "boolean") then
                if(type(v) == true) then
                    text = text .. LY.STR.TRUE
                else
                    text = text .. LY.STR.FALSE
                end
            elseif (type(v) == "table") or (type(v) == "function") or (type(v) == "userdata") then
                text = text .. LY.STR.OPEN .. type(v) .. LY.STR.CLOSE
            else
                text = text .. v
            end
            lastIndex = i;
        end

        -- possible trailing nils
        while (tonumber(lastIndex) < quantity) do
            text = text .. LY.STR.NIL
            lastIndex = lastIndex + 1
        end
    end -- asert

    return text;
end

--[[
-- check if variable is empty
 - positive values:
 string: "", "0", "0.0"
 NIL
 boolean: false
 number: 0, 0.0
 table: with no elements

 emulates PHP behavior
 ]]
function Ly.isEmpty( variable )
    local result = true;
    if(variable == nil) then
        local varType = type(variable)
        if(varType == "table") then
            for k, v in pairs ( variable ) do
                result = false;
                break;
            end
        elseif(varType == "userdata" or varType == "function" ) then
            result = false
        elseif(varType == "boolean" and variable == true) then
            result = false
        elseif(varType == "string" and variable ~= "" and
                variable ~= "0" and variable ~= "0.0") then
            result = false
        elseif(varType == "number" and variable ~= 0 and
                variable ~= 0.0) then
            result = false
        end
    end
    return result
end

function Ly.inTable(table, needle)
    for _,v in pairs(table) do
        if (v == needle) then
            return true
        end
    end
    return false
end

function Ly.toString(variable)
    return Ly.stringConcat(1, variable);
end

function Ly.stringSplit(str, pattern, results)
    if not results then
        results = {}
    end

    for i in string.gmatch(str, "([^".. pattern .."]*)") do
        table.insert( results, i)
    end
    return results;
end

function Ly.curlys(str)
    return Ly.stringConcat(3, "{", str, "}")
end

function Ly.brackets(str)
    return Ly.stringConcat(3, "[", str, "]")
end

function Ly.rounds(str)
    return Ly.stringConcat(3, "(", str, ")")
end

function Ly.angle(str)
    return Ly.stringConcat(3, "<", str, ">")
end

function Ly.printTable(tab, indent, ignoreChildTables)
    if (indent == nil) then
        indent = LY.STR.PRINT_INDENT
    end
    for key,value in pairs(tab) do
        if (type(value) == "table") or (type(value) == "function") or (type(value) == "userdata") then
            print(indent..Ly.brackets(key).."= " ..  Ly.rounds(type(value)) )
            if (type(value) == "table" and ignoreChildTables ~= true) then
                Ly.printTable(value, indent..indent)
            end
        else
            print(indent..Ly.brackets(key).."="..Ly.toString(value).." "..Ly.rounds(type(value)))
        end
    end
end

function Ly.getDynVar(field)
    -- Ly.log("LyUtils.getDynVar() field=" .. field)
    if(debug.getinfo(2) ~= nil and debug.getinfo(2).name ~= nil) then
        -- Ly.log("LyUtils.getDynVar() caller="..debug.getinfo(2).name)
    end

    local fn
    local str = "return " .. field

    if(Ly.stringConcat(1, field) == LY.STR.NIL) then
        -- value is null
        return nil;
    elseif( pcall(fnStr) ) then
        -- valid fn
        fn = load(fnStr)
        return fn()
    else
        -- value of value is null
        return nil;
    end
end


-- "constants" idea from -> http://andrejs-cainikovs.blogspot.com.ar/2009/05/lua-constants.html
function Ly.protectConstants(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                    tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

function Ly.requireFiles ( files )
    for k, v in pairs ( files ) do
        require ( v )
    end
end

-- this function is taken from http://lua.space/general/assert-usage-caveat
-- Like assert() but with support for a function argument
function Ly.assertFn(a, ...)
    if (a) then
        -- if true, returns true and go on
        return a, ...
    end

    local f = ...

    if type(f) == "function" then
        local args = {...}
        table.remove(args, 1)
        error(f(unpack(args)), 2)
    else
        error(f or "assertion failed!", 2)
    end
end

-- this modified version auto-concatenates all remaining variables
function Ly.assert(a, ...)
    if (a) then
        -- if true, returns true and go on
        return a, ...
    end

    local args  = {... }
    local text = ""

    for _,v in ipairs(args) do
        text = stringConcat(3, text, " ", v)
    end

    error(text or "assertion failed!", 2)

end

function Ly.fileRead(file, mode)
    if( mode == nil) then
        mode = "r"
    end

    local f = io.open(file, mode)
    local content = f:read("*all")
    f:close()
    return content
end
