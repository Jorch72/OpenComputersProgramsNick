
local component = require("component")
local gpu = component.gpu
local unicode = require("unicode")
local event = require "event"
local w, h = gpu.getResolution()

gpu.fill(1, 1, w, h, " ") -- clears the screen
gpu.setForeground(0x000000)
gpu.setBackground(0xFFFFFF)

gpu.fill(1, 2, 1, h, unicode.char(2502) )
gpu.fill(w, 2, 1, h, unicode.char(2502) )



function unknownEvent()
  -- do nothing if the event wasn't relevant
end
 
-- table that holds all event handlers, and in case no match can be found returns the dummy function unknownEvent
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
 

function myEventHandlers.touch(screenAddress, x, y, button, playerName)

end
 
-- The main event handler as function to separate eventID from the remaining arguments
function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end

-- main event loop which processes all events, or sleeps if there is nothing to do
while true do
  handleEvent(event.pull()) -- sleeps until an event is available, then process it
end
