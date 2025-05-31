-- Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
function moonphase(ud)
  local eccent = 0.016718 -- Eccentricity of Earth's orbit
  local elonge = 278.833540 -- Ecliptic longitude of the Sun at epoch 1980.0
  local elongp = 282.596403 -- Ecliptic longitude of the Sun at perigee
  local torad = math.pi / 180.0
  local fixangle = function (a) return ((a % 360) + 360) % 360 end

  -- Calculation of the Sun's position
  local Day = (ud / 86400 + 2440587.5) - 2444238.5 -- Date within epoch
  local M = torad * fixangle(((360 / 365.2422) * Day) + elonge - elongp) -- Convert from perigee co-ordinates to epoch 1980.0

  -- Solve equation of Kepler
  local e = M
  local delta
  delta = e - eccent * math.sin(e) - M
  e = e - delta / (1 - eccent * math.cos(e))
  while math.abs(delta) > 1E-6 do
    delta = e - eccent * math.sin(e) - M
    e = e - delta / (1 - eccent * math.cos(e))
  end
  local Ec = e;
  Ec = 2 * math.atan(math.sqrt((1 + eccent) / (1 - eccent)) * math.tan(Ec / 2)) --  True anomaly

  local Lambdasun = fixangle(((Ec) * (180.0 / math.pi)) + elongp) -- Sun's geocentric ecliptic longitude
  local ml = fixangle(13.1763966 * Day + 64.975464) -- Moon's mean lonigitude at the epoch
  local MM = fixangle(ml - 0.1114041 * Day - 349.383063) -- 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
  local Ev = 1.2739 * math.sin(torad * (2 * (ml - Lambdasun) - MM)) -- Evection
  local Ae = 0.1858 * math.sin(M) -- Annual equation
  local MmP = torad * (MM + Ev - Ae - (0.37 * math.sin(M))) -- Corrected anomaly
  local lP = ml + Ev + (6.2886 * math.sin(MmP)) - Ae + (0.214 * math.sin(2 * MmP)) -- Corrected longitude
  local lPP = lP + (0.6583 * math.sin(torad * (2 * (lP - Lambdasun)))) -- True longitude
  local MoonAge = lPP - Lambdasun -- Age of the Moon in degrees

  return MoonAge * torad
end
