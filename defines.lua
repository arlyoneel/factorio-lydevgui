--[[
 you can add or remove fields from fieldtables without any code modification
 NOTE: Keep in mind that fields are not null safe, is the good and the bad of this design
  ]]


const = {
    NA = "N/A",
    MOD_NAME = "LyDevGUI",
    MOD_VERSION = "0.0.1",
    PREFIX_VALUE = "v",
    PREFIX_FIELD = "f",
    FIELDS_PLAYER_REMOVE_PATTERN="%.",
    FIELDS_SELECTED_REMOVE_PATTERN=".selected.",
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
        Health = ".selected.rotatable",
        SupportsDirection = ".selected.supports_direction",
        Orientation = ".selected.orientation",

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
    }
}
const = LyUtils.protectConstants(const)
