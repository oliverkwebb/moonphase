# Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/

function fixangle(a) {
	return ((a % 360) + 360) % 360;
}

function moonphase(d,  torad, r, ev, mm, lambdasun, ml, mmm, ae, mmp, lp, lpp, delta, ec, ee, day) {
  torad = (4*atan2(1,1)) / 180.0;

  # Calculation of the Sun's position
  day = (d / 86400 + 2440587.5) - 2444238.5; # Date within epoch
  mm = torad * fixangle(((360 / 365.2422) * day) + 278.833540 -  282.596403); # Convert from perigee co-ordinates to epoch 1980.0

  # Solve equation of Kepler
  ee = mm;
  delta = ee - 0.016718 * sin(ee) - mm;
  ee -= delta / (1 - 0.016718 * cos(ee));
  while (delta > 1E-6 || delta < -1E-6) {
    delta = ee - 0.016718 * sin(ee) - mm;
    ee -= delta / (1 - 0.016718 * cos(ee));
  }
  ec = ee;
  ec = 2 * atan2(sqrt((1 + 0.016718) / (1 - 0.016718)) * (sin(ec / 2)/cos(ec / 2)), 1); # True anomaly
  lambdasun = fixangle(ec * (180.0 / (4*atan2(1,1))) +  282.596403) # Sun's geocentric ecliptic longitude
  ml = fixangle(13.1763966 * day + 64.975464) # Moon's mean lonigitude at the epoch
  mmm = fixangle(ml - 0.1114041 * day - 349.383063) # 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
  ev = 1.2739 * sin(torad * (2 * (ml - lambdasun) - mmm)); # Evection
  ae = 0.1858 * sin(mm);                           # Annual equation
  mmp = torad * (mmm + ev - ae - (0.37 * sin(mm))); # Corrected anomaly
  lp = ml + ev + (6.2886 * sin(mmp)) - ae + (0.214 * sin(2 * mmp)); # Corrected longitude
  lpp = lp + (0.6583 * sin(torad * (2 * (lp - lambdasun)))); # True longitude

  return((lpp - lambdasun) * torad);
}