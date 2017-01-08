

LyDevGUI = {
    options = {
        guiPosOpts = "top",
        guiPosVars = "left",
        showPlayerVars = true,
        showSelectedVars = true,
        showStackVars = false,
        showProtoVars = false,
    },
    tmp = {
        obj = {
            -- pcGui* are used on_player_created
            pcGuiVars,
            pcGuiOpts,
            -- gui* are used on_tick
            guiVars,
            guiOpts
        },
        str = {
            -- pcGui* are used on_player_created
            pcGuiVars,
            pcGuiOpts,
            -- gui* are used on_tick
            guiVars,
            guiOpts
        }
    },


    NA="N/A",
    PREFIX_VALUE = "v",
    PREFIX_FIELD = "f",
    FIELDS_PLAYER_REMOVE_PATTERN="%.",
    FIELDS_SELECTED_REMOVE_PATTERN=".selected.",

--[[
 you can add or remove fields from fieldtables "*_FIELDS" without any code modification
 NOTE: Keep in mind that fields aren't null safe, is the good and the bad of this design
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
        SupportsDirection = ".selected.supports_direction",
        Orientation = ".selected.orientation",
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
    }
}



function updateLabels(myRootStr, fieldList, valueToRemoveInFields, forceValue)
    Ly.log("updateLabels()")

    local myPlayerStr = Ly.getPlayerStr()
    local myRootStr = Ly.getGuiStr() .. myRootStr

    Ly.log("myPlayerStr="..myPlayerStr)
    Ly.log("myRootStr="..myRootStr)

    local myRoot = LyUtils.getDynVar(myRootStr);

    for fKey, fValue in pairs(fieldList) do
        Ly.log("for fieldList -> fieldKey="..fKey.." fieldValue="..fValue)
        local exist = Ly.existGuiElement(myRoot, LyDevGUI.PREFIX_FIELD..fKey);
        Ly.log("existGUIElement()".."fTargetName="..LyDevGUI.PREFIX_FIELD..fKey.." result=".. LyUtils.varToString(exist))

        local fieldName
        if(valueToRemoveInFields ~= nil) then
            fieldName = string.gsub(fValue, valueToRemoveInFields, "")
        else
            fieldName = fValue
        end

        local valueName;
        if(nil ~= forceValue) then
            valueName = forceValue
        else
            valueName = LyUtils.getDynVar(myPlayerStr .. fValue)
        end

        Ly.log("pre-processed caption values")
        if(valueName ~= nil) then
            Ly.log("valueName="..LyUtils.varToString(valueName))
        else
            Ly.log("valueName=NIL")
        end
        if(valueName ~= nil) then
            Ly.log("fieldName="..LyUtils.varToString(fieldName))
        else
            Ly.log("fieldName=NIL")
        end


        if (exist == false) then
            Ly.log("addLabel fieldname="..fieldName.." name="..LyDevGUI.PREFIX_FIELD..fKey)
            myRoot.add{
                type="label",
                name=LyDevGUI.PREFIX_FIELD..fKey,
                caption=fieldName,
            }
            Ly.log("addLabel fieldname(dynvar or forced)="..valueName.." name="..LyDevGUI.PREFIX_VALUE..fKey)
            myRoot.add{
                type="label",
                name=LyDevGUI.PREFIX_VALUE..fKey,
                caption=valueName
            }
        else
            Ly.log("updatingLabelCaption")
            Ly.log("caption target="..myRootStr.."."..LyDevGUI.PREFIX_VALUE.. fKey .. ".caption")
            local guiElement = LyUtils.getDynVar(myRootStr.."."..LyDevGUI.PREFIX_VALUE.. fKey)

            if valueName ~= nil or valueName ~= "" then
                guiElement.caption = valueName;
            else
                guiElement.caption = LyDevGUI.NA
            end
            Ly.log("caption new value="..LyUtils.varToString(valueName))
        end

    end
end

function destroyLabels(myRootStr, fieldList)
    Ly.log("destroyLabels()")
    myRootStr = Ly.getGuiStr() .. myRootStr
    local myRoot = LyUtils.getDynVar(myRootStr)
    Ly.log("myRootStr="..myRootStr)
    for fdKey, fdValue in pairs(fieldList) do
        if (true == Ly.existGuiElement(myRoot, LyDevGUI.PREFIX_FIELD .. fdKey)) then
            local objV, objF
            Ly.log("objV="..myRootStr .. "." .. LyDevGUI.PREFIX_VALUE .. fdKey)
            objV = LyUtils.getDynVar(myRootStr .. "." .. LyDevGUI.PREFIX_VALUE .. fdKey)
            objV.destroy()

            Ly.log("objF="..myRootStr .. "." .. LyDevGUI.PREFIX_FIELD .. fdKey)
            objF = LyUtils.getDynVar(myRootStr .. "." .. LyDevGUI.PREFIX_FIELD .. fdKey)
            objF.destroy()
        end
    end
end


