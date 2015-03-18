# Extractor Controller
Rather then suppling the Extractor 4MW of power, I have written this program to switch the gear ratio. This program is for a switching a power plant made of up 4 Hydrokinetic Engines. This is a rather late game build for this machine.

## Extractor Setup

I recommend that all intervening shafts be made of diamond. If you have made it this far in this mod, you have the diamonds. But some shaft sections could be steel. I would also not connect your gearbox to power till you are ready. Not even diamond can handle the torque these engines can output.

First connect 4 Hydrokinetic Engines with a 60 block water fall. This will use I think, 16mb/sec of lubricate.

Next place down a x8 Gearbox set for speed. And then a CVT Unit, set to redstone control. High signal x32 Speed and low x16 Speed. Next another shaft, then your bevel to the Extractor.

I like to place the Redstone I/O on top of the CVT Unit. You will also need to connect a cable to anywhere on the line of shafts. That will let the program access the Extractor's API.

## Server Setup

This build requires the use of a server. This version of this controller uses the Extractor's OpenComputer API, thus needs to be able to handle all of the components that made up the power plant. Rotarycraft is odd that if you connect to anywhere in the shaft network you can see all of the attached machines. 

I am using a tier I server with tier II parts. The controller requires a network card as I am working on a display program. You will need a tier I component addon to handle all of the attached Rotarycarft machines.

## Other Power plants

To use other power setups would require you to add another state. And rework the redstone controls.
