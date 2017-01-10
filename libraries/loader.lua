-- correct loading order
--log("Lua version: " .. _VERSION)

-- external libraries

-- ly libraries
require("libraries.lyconstants")
require("libraries.ly")
require("libraries.lyfactorio")
require("libraries.lymod")

-- after this, this constants are read only
CONST   = Ly.protectConstants(CONST)
LY      = Ly.protectConstants(LY)

Ly.init()
