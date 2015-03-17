local machine = require('statemachine')
local sides = require("sides")
local event = require ("event")
local component = require("component")
local m = component.modem
local serial = require("serialization")
local shell = require("shell")
local rs = component.redstone
local extr = component.Extractor


-- local args, options = shell.parse(...)
-- if #args == 0 then
--  io.write("Usage:\n")
--  io.write("  extCtrl <side>\n")
--  return
-- end

local ioSide   = sides.bottom

local loggerPort = 10536
local powerlevel = 2097152
local sleepSec = 90

local signal = {
 grinding = 15,
 slurry   = 0
}

local turnOnRedStoneSignal = function(signal)
 rs.setOutput(ioSide, signal)
end

local sendStatusMessage = function(s, mymsg) 
 local sm = serial.serialize({state = s, msg= mymsg})
 m.broadcast(loggerPort, sm)
 print("State: " .. s .. " Msg: " .. mymsg  .. "\n")
end

local fsm = machine.create({
  initial = 'stopped',
  events = {
    { name = 'startUp',     from = 'stopped'      , to = 'grindingOre'   },
    { name = 'nextStage', from = 'grindingOre'  , to = 'burningSlurry'   },
    { name = 'nextStage', from = 'burningSlurry'  , to = 'grindingOre' },
    { name = 'waterTankEmpty', from = '*', to = 'stopped' },
    { name = 'noPower',        from = '*', to = 'stopped' },
    { name = 'manualStop',     from = '*', to = 'stopped' },
  },
  callbacks = {
    ongrindingOre   = function(self, event, from, to, msg) turnOnRedStoneSignal(signal.grinding) sendStatusMessage('Grinding Ore', msg) end,
    onburningSlurry = function(self, event, from, to, msg) turnOnRedStoneSignal(signal.slurry)   sendStatusMessage('Burning Slurry', msg) end,
    onstopped       = function(self, event, from, to, msg) sendStatusMessage('Stopped', msg) end
  }
})



function changeState(mymsg)
 if(fsm:can('nextStage')) then
   fsm:nextStage(mymsg)
 end
end

function doSystemCheck() 
 local pwr = extr.getPower()

 if(fsm:is('stopped')) then
  -- check water and power
  if(extr.isTankFull(0) and pwr == powerlevel) then 
   print("looks good starting up")
   fsm:startUp("Starting")
  end
 end

 if(not extr.isTankFull(0)) then
   fsm:waterTankEmpty("Check Water tank")
   return true
 end
 
 if(pwr < powerlevel) then
   fsm:noPower("Low Power! Current Power is: " .. pwr)
   return true
 end
 return false
end

function getOreNameInSlot(n)
 local d = {extr.getSlot(n)}
 return d[4]
end

function isSlotFull(n) 
 local d = {extr.getSlot(n)}
 if d[3] == nil then
  return false
 end
 return d[3] > 45
end

function isSlotEmpty(n)
 local d = {extr.getSlot(n)}
 if d[3] == nil then
  return false
 end
 return d[3] < 25
end

local checkInv = function()
   if(doSystemCheck() ) then
     return 1
   end

   if(fsm:is('grindingOre') and isSlotFull(5)) then
     local slot5 = getOreNameInSlot(5)
     changeState(slot5)
     return 1
   end   
   if(fsm:is('burningSlurry') and isSlotEmpty(2) ) then
     local slot3 = getOreNameInSlot(2)
     changeState(slot3)
     return 1     
   end
   -- debuging
   print("Nothing to do this cycle")
end

function unknownEvent()
  -- do nothing if the event wasn't relevant
end
 
-- table that holds all event handlers, and in case no match can be found returns the dummy function unknownEvent
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
 

 
-- The main event handler as function to separate eventID from the remaining arguments
function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end
 
checkInv()
event.timer(sleepSec, checkInv, math.huge)

-- main event loop which processes all events, or sleeps if there is nothing to do
while true do
  handleEvent(event.pull()) -- sleeps until an event is available, then process it
end
