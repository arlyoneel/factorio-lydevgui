

LyDevGUI = {
    options = {
        -- position of UI tables
        guiPosMain = "top",
        guiPosVars = "left",
        guiPosOpts = "center",

        -- default UI statuses
        showVarsWOValues = false,
        showPlayerVars = true,
        showSelectedVars = true,
        showStackVars = false,
        showProtoVars = false,
        enableOutputJSON = false,
    },
    gui = {
        initialized = true,
        -- options root
        mainRootName = "tMain",
        varsRootName = "tVars",
        optsRootName = "tOpts",
        -- variable root
        varsRoot = "",
        mainRoot = "",
        optsRoot = "",
    },

    DIRECTION_NAMES = {
        [0] = {"txt.direction.north"},
        [1] = {"txt.direction.northeast"},
        [2] = {"txt.direction.east"},
        [3] = {"txt.direction.southeast"},
        [4] = {"txt.direction.south"},
        [5] = {"txt.direction.southwest"},
        [6] = {"txt.direction.west"},
        [7] = {"txt.direction.northwest"},
    },

    PREFIX_VALUE = "v",
    PREFIX_FIELD = "f",
    FIELDS_PLAYER_REMOVE_PATTERN="%.",
    FIELDS_SELECTED_REMOVE_PATTERN=".selected.",

    --[[
     you can add or remove fields from fieldtables "*_FIELDS" without any code modification
    --]]
    STACK_FIELDS = {
        StackName=".selected.stack.name",
        StackType=".selected.stack.type",
        StackCount=".selected.stack.count",
        StackProtoType=".selected.stack.prototype.type",
        StackProtoName=".selected.stack.prototype.name",
        StackProtoStackSize=".selected.stack.prototype.stack_size",
        StackProtoFuelValue=".selected.stack.prototype.fuel_value",
        StackProtoOrder=".selected.stack.prototype.order",
        StackProtoGroupName=".selected.stack.prototype.group.name",
        StackProtoGroupType=".selected.stack.prototype.group.type",
        StackProtoSubgroupName=".selected.stack.prototype.subgroup.name",
        StackProtoSubgroupType=".selected.stack.prototype.subgroup.type",
    },
    SELECTED_FIELDS= {
        Type = ".selected.type",
        Name = ".selected.name",
        Destructible = ".selected.destructible",
        Minable = ".selected.minable",
        Rotatable = ".selected.rotatable",
        Health = ".selected.health",
        Energy = ".selected.energy",
        Amount = ".selected.amount",
        SupportsDirection = ".selected.supports_direction",
        Orientation = ".selected.orientation",
        UnitNumber = ".selected.unit_number",
        BackerName = ".selected.backer_name",
        EffectivityModifier = ".selected.effectivity_modifier",
        ConsumptionModifier = ".selected.consumption_modifier",
        FrictionModifier = ".selected.friction_modifier",
        ElectricDrain = ".selected.electric_drain",
        ElectricEmissions = ".selected.electric_emissions",
        ElectricOFlowLimit = ".selected.electric_output_flow_limit",
        ElectricIFlowLimit = ".selected.electric_input_flow_limit",
        ElectricBufferSize = ".selected.electric_buffer_size",
    },
    PROTO_FIELDS = {
        ProtoType=".selected.prototype.type",
        ProtoName=".selected.prototype.name",
        ProtoOrder=".selected.prototype.order",
        ProtoGroupName=".selected.prototype.group.name",
        ProtoGroupType=".selected.prototype.group.type",
        ProtoSubgroupName=".selected.prototype.subgroup.name",
        ProtoSubgroupType=".selected.prototype.subgroup.type",
    },
    PLAYER_FIELDS = {
        PlayerIndex = ".index",
        PlayerName = ".name",
        PlayerPosX = ".position.x",
        PlayerPosY = ".position.y",
    },
    CHARACTER_FIELDS = {
        PlayerHealth = ".character.health",
    },
    GHOST_FIELDS = {
        GhostType = ".selected.ghost_type",
        GhostName = ".selected.ghost_name",
    }
}



function updateLabels(myRootStr, fieldList, patternToRemoveInFields, forceValue)
    Ly.log("updateLabels()")

    local myPlayerStr = Ly.getPlayerStr()
    local myRootStr = Ly.getGuiStr() .. myRootStr

    Ly.log("myPlayerStr="..myPlayerStr)
    Ly.log("myRootStr="..myRootStr)

    local myRoot = Ly.getDynVar(myRootStr);

    for fKey, fValue in pairs(fieldList) do
        Ly.log("for fieldList -> fieldKey="..fKey.." fieldValue="..fValue)
        local exist = Ly.existGuiElement(myRoot, LyDevGUI.PREFIX_FIELD..fKey);
        Ly.log("existGUIElement()".."fTargetName="..LyDevGUI.PREFIX_FIELD..fKey.." result=".. Ly.toString(exist))

        local fieldName
        if(patternToRemoveInFields ~= nil) then
            fieldName = string.gsub(fValue, patternToRemoveInFields, "")
        else
            fieldName = fValue
        end

        local valueName;
        if(nil ~= forceValue) then
            valueName = forceValue
        else
            valueName = Ly.getDynVar(myPlayerStr .. fValue)
        end


        if (exist == false) then
            -- Ly.log("addLabel fieldname="..fieldName.." name="..LyDevGUI.PREFIX_FIELD..fKey)
            myRoot.add{
                type="label",
                name=LyDevGUI.PREFIX_FIELD..fKey,
                caption=fieldName,
            }
            -- Ly.log("addLabel fieldname(dynvar or forced)="..valueName.." name="..LyDevGUI.PREFIX_VALUE..fKey)
            myRoot.add{
                type="label",
                name=LyDevGUI.PREFIX_VALUE..fKey,
                caption=valueName
            }
        else
            Ly.log("updatingLabelCaption")
            Ly.log("caption target="..myRootStr.."."..LyDevGUI.PREFIX_VALUE.. fKey .. ".caption")
            local guiElement = Ly.getDynVar(myRootStr.."."..LyDevGUI.PREFIX_VALUE.. fKey)

            if valueName ~= nil or valueName ~= "" then
                guiElement.caption = valueName;
            else
                guiElement.caption = {"txt.na"}
            end
            --Ly.log("caption new value="..Ly.toString(valueName))
        end

    end
end

function destroyLabels(myRootStr, fieldList)
    Ly.log("destroyLabels()")
    myRootStr = Ly.getGuiStr() .. myRootStr
    local myRoot = Ly.getDynVar(myRootStr)
    Ly.log("myRootStr="..myRootStr)
    for fdKey, fdValue in pairs(fieldList) do
        if (true == Ly.existGuiElement(myRoot, LyDevGUI.PREFIX_FIELD .. fdKey)) then
            local objV, objF
            Ly.log("objV="..myRootStr .. "." .. LyDevGUI.PREFIX_VALUE .. fdKey)
            objV = Ly.getDynVar(myRootStr .. "." .. LyDevGUI.PREFIX_VALUE .. fdKey)
            objV.destroy()

            Ly.log("objF="..myRootStr .. "." .. LyDevGUI.PREFIX_FIELD .. fdKey)
            objF = Ly.getDynVar(myRootStr .. "." .. LyDevGUI.PREFIX_FIELD .. fdKey)
            objF.destroy()
        end
    end
end


function initGlobals()
    global.lastSelection = {}
    global.lastPlayerInfo = {}

    if ( global.isSelectedEntity == nil ) then
        global.isSelectedEntity = false;
    end

    global.lyConnectedPlayersIndexCache = {}
    global.lyPlayerIndexCache = {}
end

function initGuiRoots()

    Ly.log("initGuiRoots()")

    -- prepare guiRootString to check if exist
    local guiMainRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosMain) .. "." .. LyDevGUI.gui.mainRootName
    local guiVarsRootStr
    local guiOptsRootStr

    Ly.log(Ly.stringConcat(2, "initGuiRoots() - guiMainRootStr=", guiMainRootStr))


    if(Ly.getDynVar(guiMainRootStr) == nil) then
        guiVarsRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosVars) .. "." .. LyDevGUI.gui.varsRootName
        guiOptsRootStr = Ly.getGuiStr(LyDevGUI.options.guiPosOpts) .. "." .. LyDevGUI.gui.optsRootName

        Ly.log(Ly.stringConcat(2, "initGuiRoots() - guiVarsRootStr=", guiVarsRootStr))
        Ly.log(Ly.stringConcat(2, "initGuiRoots() - guiOptsRootStr=", guiOptsRootStr))

        -- if not, i obtain the selected pos in guiPosOpts game.player...gui.POS (parent of guiOptsRootStr)
        local guiPosMain = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosMain))
        local guiPosVars = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosVars))
        local guiPosOpts = Ly.getDynVar(Ly.getGuiStr(LyDevGUI.options.guiPosOpts))

        -- add main child objects
        guiPosMain.add{ type="table", colspan=4, name=LyDevGUI.gui.mainRootName }
        guiPosVars.add{ type="table", colspan=2, name=LyDevGUI.gui.varsRootName }
        guiPosOpts.add{ type="flow",  name=LyDevGUI.gui.optsRootName }

        -- table roots
        local mainRoot = Ly.getDynVar(guiMainRootStr)
        local varsRoot = Ly.getDynVar(guiVarsRootStr)
        local optsRoot = Ly.getDynVar(guiOptsRootStr)

        -- add GUIobjects to table(s)

        -- options and title
        mainRoot.add{ type = "button", name = "showOptions", caption = "..." }

        varsRoot.add{ type = "label", name="modInfo",
            caption= Ly.stringConcat(3, CONST.INFO.MOD_NAME," v", CONST.INFO.MOD_VERSION)
        }
        varsRoot.add { type = "label", name = "selection", caption = {"txt.mod.selection.nothing"} }

        LyDevGUI.gui.mainRoot = mainRoot;
        LyDevGUI.gui.varsRoot = varsRoot;
        LyDevGUI.gui.optsRoot = optsRoot;

        -- refresh labels
        game.raise_event(defines.events.onPlayerPositionChange, {
            player = Ly.getPlayer(),
        })
    end
end



