-- native events
require("events.on_init")
require("events.on_gui_click")
require("events.on_player_created")
require("events.on_tick")

-- custom events
events = defines.events
events.onSelectionChange = script.generate_event_name()
events.onEmptySelection = script.generate_event_name()
events.onEntitySelection = script.generate_event_name()
events.onPlayerPositionChange = script.generate_event_name()

require("events.onEmptySelection")
require("events.onSelectionChange")
require("events.onEntitySelection")
require("events.onPlayerPositionChange")