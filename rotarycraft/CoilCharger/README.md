# Coil Charger

This is a program to monitor the charging and discharging of RotaryCraft Industrial Coils.

I have four Industrial Coils setup to run a Bedrock Breaker. I also have them connected to two Gasoline Engines, this program controls the automatic swaping of them from a charging state to a discharging state.

One of the Coils has a comparator connected to it. Once the redstone signal reaches the set level the Gas engines are turned off and and redstone signal is applied to the coils, turning them on.

The program also checkes it's own battery power from time to time, it will turn off the gas engines if it's running out of power. This is because the coils will explode if they are over charged.


