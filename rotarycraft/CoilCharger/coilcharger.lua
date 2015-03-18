local machine = require('statemachine')

local sides = require("sides")
local event = require ("event")
local computer = require("computer")

local rs = component.redstone

local settings = {
 coilsOnSide = sides.right,
 enginesControlSide = sides.back,
 feedbackSide = sides.left,
 manualStopSide   = sides.up,
 powercheckInv = 120,
 feedbackHigh = 10,
 feedbackLow  = 3,
 lowbattery = 3000,
}

local state = {
  stopped.signal = 0
  discharging.signal = 15
}

local fsm = machine.create({
  initial = 'stopped',
  events = {
    { name = 'startUp',    from = 'stopped'  , to = 'charging'   },
    { name = 'nextStage',  from = 'charging' , to = 'discharging'   },
    { name = 'lowBattery', from = '*', to = 'stopped' },
    { name = 'manualStop', from = '*', to = 'stopped' },
  },
  callbacks = {
    ondischarging = chargingEnginesOffCoilsOn,
    onstopped     = chargingEnginesOffCoilsOff,
    oncharging    = chargingEnginesOnCoilsOff
  }
})

checkPower = function() 
 local energy = computer.energy()
 if engergy < settings.lowbattery then
  fsm:lowBattery()
 else
  if fsm:is('stopped') then 
   fsm:startUp()
  end
 end
end

local chargingEnginesOffCoilsOn = function(self, event, from, to)
 rs.setOutput(settings.enginesControlSide, 15)
 rs.setOutput(settings.coilsOnSide, 15)
end

local chargingEnginesOffCoilsOff = function(self, event, from, to)
 rs.setOutput(settings.enginesControlSide, 15)
 rs.setOutput(settings.coilsOnSide, 0)
end

local chargingEnginesOnCoilsOff = function(self, event, from, to)
 rs.setOutput(settings.enginesControlSide, 0)
 rs.setOutput(settings.coilsOnSide, 0)
end

function unknownEvent()
  -- do nothing if the event wasn't relevant
end
 
-- table that holds all event handlers, and in case no match can be found returns the dummy function unknownEvent
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
 
function myEventHandlers.redstone_changed(address, side)
  if (side == settings.feedbackSide) then
   local signal = rs.getInput(side)
   if(signal >= settings.feedbackHigh and fsm:is('charging') ) then
    fsm:nextStage()
   else
    if(signal <= setttings.feedbackLow and fsm:is('discharging') ) then 
     fsm:nextStage()
    end
   end
  end
  if side == manualStopSide then
    fsm:manualStop()
  end
end
 
-- The main event handler as function to separate eventID from the remaining arguments
function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end
 
checkPower()
event.timer(settings.powercheckInv,checkPower ,math.huge)

-- main event loop which processes all events, or sleeps if there is nothing to do
while true do
  handleEvent(event.pull()) -- sleeps until an event is available, then process it
end
