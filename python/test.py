#!/usr/bin/env python
from moonphase import moonphase
import math, time

ilf = (lambda d: round(((1-math.cos(moonphase(d)))/2)*100, 1))

assert ilf(time.gmtime(-178070400)) == 1.2
assert ilf(time.gmtime(361411200)) == 93.6
assert ilf(time.gmtime(1704931200)) == 0.4
assert ilf(time.gmtime(2898374400)) == 44.2
