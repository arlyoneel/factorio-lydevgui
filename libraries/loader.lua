-- correct loading order
--log("Lua version: " .. _VERSION)

-- ly libraries
require("libraries.lyconstants")
require("libraries.ly")
require("libraries.lyfactorio")
require("libraries.lymod")

-- external libraries
require("libraries.external.dkjson") -- http://dkolf.de/src/dkjson-lua.fsl/home

-- after this, this constants are read only
CONST   = Ly.protectConstants(CONST)
LY      = Ly.protectConstants(LY)

Ly.init()
