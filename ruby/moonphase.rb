# Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
def moonphase(date)
  require 'time'
  ud = date.to_i
  eccent = 0.016718 # Eccentricity of Earth's orbit
  elonge = 278.833540 # Ecliptic longitude of the Sun at epoch 1980.0
  elongp = 282.596403 # Ecliptic longitude of the Sun at perigee
  torad = Math::PI / 180.0
  fixangle = lambda { |a| ((a % 360) + 360) % 360 }

  # Calculation of the Sun's position
  day = (ud / 86400.0 + 2440587.5) - 2444238.5 # Date within epoch
  m = torad * fixangle.call(((360.0 / 365.2422) * day) + elonge - elongp) # Convert from perigee co-ordinates to epoch 1980.0

  # Solve equation of Kepler
  e = m
  delta = e - eccent * Math.sin(e) - m
  e = e - delta / (1 - eccent * Math.cos(e))
  while delta.abs > 1E-6
    delta = e - eccent * Math.sin(e) - m
    e = e - delta / (1 - eccent * Math.cos(e))
  end
  ec = e
  ec = 2 * Math.atan(Math.sqrt((1 + eccent) / (1 - eccent)) * Math.tan(ec / 2)) # True anomaly

  lambdasun = fixangle.call(((ec) * (180.0 / Math::PI)) + elongp) # Sun's geocentric ecliptic longitude
  ml = fixangle.call(13.1763966 * day + 64.975464) # Moon's mean lonigitude at the epoch
  mm = fixangle.call(ml - 0.1114041 * day - 349.383063) # 349: Mean longitude of the perigee at the epoch, Moon's mean anomaly
  ev = 1.2739 * Math.sin(torad * (2 * (ml - lambdasun) - mm)) # Evection
  ae = 0.1858 * Math.sin(m) # Annual equation
  mmp = torad * (mm + ev - ae - (0.37 * Math.sin(m))) # Corrected anomaly
  lp = ml + ev + (6.2886 * Math.sin(mmp)) - ae + (0.214 * Math.sin(2 * mmp)) # Corrected longitude
  lpp = lp + (0.6583 * Math.sin(torad * (2 * (lp - lambdasun)))) # True longitude
  moonage = lpp - lambdasun # Age of the Moon in degrees

  moonage * torad
end
