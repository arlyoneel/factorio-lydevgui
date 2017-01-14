-- native events
require("events.on_init")
require("events.on_gui_click")
require("events.on_player_created")
require("events.on_tick")

-- custom events
defines.events.onSelectionChange = script.generate_event_name()
defines.events.onEmptySelection = script.generate_event_name()
defines.events.onEntitySelection = script.generate_event_name()
defines.events.onPlayerPositionChange = script.generate_event_name()

require("events.onEmptySelection")
require("events.onSelectionChange")
require("events.onEntitySelection")
require("events.onPlayerPositionChange")