lydevGUI = {
    playerIndex = -1
}

function updateLabels(myRootStr, fieldList, valueToRemoveInFields, forceValue)
    log("updateLabels()")

    local myPlayerStr = Ly.getPlayerStr()
    local myRootStr = Ly.getGuiStr() .. myRootStr

    log("myPlayerStr="..myPlayerStr)
    log("myRootStr="..myRootStr)

    local myRoot = LyUtils.getDynVar(myRootStr);

    for fKey, fValue in pairs(fieldList) do
        log("for fieldList -> fieldKey="..fKey.." fieldValue="..fValue)
        local exist = Ly.existGuiElement(myRoot, const.PREFIX_FIELD..fKey);
        log("existGUIElement()".."fTargetName="..const.PREFIX_FIELD..fKey.." result=".. LyUtils.smartVarToString(exist))

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

        log("pre-processed caption values")
        if(valueName ~= nil) then
            log("valueName="..LyUtils.smartVarToString(valueName))
        else
            log("valueName=NIL")
        end
        if(valueName ~= nil) then
            log("fieldName="..LyUtils.smartVarToString(fieldName))
        else
            log("fieldName=NIL")
        end


        if (exist == false) then
            log("addLabel fieldname="..fieldName.." name="..const.PREFIX_FIELD..fKey)
            myRoot.add{
                type="label",
                name=const.PREFIX_FIELD..fKey,
                caption=fieldName,
            }
            log("addLabel fieldname(dynvar or forced)="..valueName.." name="..const.PREFIX_VALUE..fKey)
            myRoot.add{
                type="label",
                name=const.PREFIX_VALUE..fKey,
                caption=valueName
            }
        else
            log("updatingLabelCaption")
            log("caption target="..myRootStr.."."..const.PREFIX_VALUE.. fKey .. ".caption")
            local guiElement = LyUtils.getDynVar(myRootStr.."."..const.PREFIX_VALUE.. fKey)

            if valueName ~= nil or valueName ~= "" then
                guiElement.caption = valueName;
            else
                guiElement.caption = const.NA
            end
            log("caption new value="..LyUtils.smartVarToString(valueName))
        end

    end
end

function destroyLabels(myRootStr, fieldList)
    log("destroyLabels()")
    myRootStr = Ly.getGuiStr() .. myRootStr
    local myRoot = LyUtils.getDynVar(myRootStr)
    log("myRootStr="..myRootStr)
    for fdKey, fdValue in pairs(fieldList) do
        if (true == Ly.existGuiElement(myRoot, const.PREFIX_FIELD .. fdKey)) then
            local objV, objF
            log("objV="..myRootStr .. "." .. const.PREFIX_VALUE .. fdKey)
            objV = LyUtils.getDynVar(myRootStr .. "." .. const.PREFIX_VALUE .. fdKey)
            objV.destroy()

            log("objF="..myRootStr .. "." .. const.PREFIX_FIELD .. fdKey)
            objF = LyUtils.getDynVar(myRootStr .. "." .. const.PREFIX_FIELD .. fdKey)
            objF.destroy()
        end
    end
end


