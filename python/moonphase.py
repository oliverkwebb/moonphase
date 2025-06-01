# Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
def moonphase(date):
  import math, calendar
  ud = calendar.timegm(date)
  eccent = 0.016718 # Eccentricity of Earth's orbit
  elonge = 278.833540 # Ecliptic longitude of the Sun at epoch 1980.0
  elongp = 282.596403 # Ecliptic longitude of the Sun at perigee
  torad = math.pi / 180.0
  fixangle = (lambda a: ((a % 360) + 360) % 360)

  # Calculation of the Sun's position
  Day = (ud / 86400 + 2440587.5) - 2444238.5 # Date within epoch
  M = torad * fixangle(((360 / 365.2422) * Day) + elonge - elongp) # Convert from perigee co-ordinates to epoch 1980.0

  # Solve equation of Kepler
  e = M
  delta = e - eccent * math.sin(e) - M
  e = e - delta / (1 - eccent * math.cos(e))
  while (abs(delta) > 1E-6):
    delta = e - eccent * math.sin(e) - M
    e = e - delta / (1 - eccent * math.cos(e))
  Ec = e;
  Ec = 2 * math.atan(math.sqrt((1 + eccent) / (1 - eccent)) * math.tan(Ec / 2)) #  True anomaly

  Lambdasun = fixangle(((Ec) * (180.0 / math.pi)) + elongp) # Sun's geocentric ecliptic longitude
  ml = fixangle(13.1763966 * Day + 64.975464) # Moon's mean lonigitude at the epoch
  MM = fixangle(ml - 0.1114041 * Day - 349.383063) # 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
  Ev = 1.2739 * math.sin(torad * (2 * (ml - Lambdasun) - MM)) # Evection
  Ae = 0.1858 * math.sin(M) # Annual equation
  MmP = torad * (MM + Ev - Ae - (0.37 * math.sin(M))) # Corrected anomaly
  lP = ml + Ev + (6.2886 * math.sin(MmP)) - Ae + (0.214 * math.sin(2 * MmP)) # Corrected longitude
  lPP = lP + (0.6583 * math.sin(torad * (2 * (lP - Lambdasun)))) # True longitude
  MoonAge = lPP - Lambdasun # Age of the Moon in degrees

  return MoonAge * torad
