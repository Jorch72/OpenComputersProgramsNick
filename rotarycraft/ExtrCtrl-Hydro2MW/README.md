# Extractor Controller
Rather then suppling the Extractor 4MW of power, I have written this program to switch the gear ratio. This program is for a switching a power plant made of up 4 Hydrokinetic Engines. This is a rather late game build for this machine.

## Setup

First connect 4 Hydrokinetic Engines with a 60 block water fall. This will use I think, 16mb/sec of lubricate.
All connecting shafts must be made of diamond. Next place a x8 Gearbox set for speed. And then a CVT Unit, set to redstone control. High signal x32 Speed and low x16 Speed.
I like to place the Redstone I/O on top of the CVT Unit. You will also need to connect a cable to anywhere on the line of shafts. That will let the program access the Extractor's API.

## Other Power plants

To use other power setups would require you to add another state. And rework the redstone controls.
