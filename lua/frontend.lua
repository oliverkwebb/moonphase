#!/usr/bin/env lua
require("moonphase")
print(string.format("%2.1f", ((1 - math.cos(moonphase(tonumber(arg[1])))) / 2)*100))
