#include <math.h>

/* Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/ */
double moonphase(double ud)
{
  double eccent = 0.016718; /* Eccentricity of Earth's orbit */
  double elonge = 278.833540; /* Ecliptic longitude of the Sun at epoch 1980.0 */
  double elongp = 282.596403; /* Ecliptic longitude of the Sun at perigee */
  double torad = M_PI / 180.0;

  /* Calculation of the Sun's position */
  double Day = (ud / 86400 + 2440587.5) - 2444238.5 ; /* Date within epoch */
  double M = torad * fmod(fmod((((360 / 365.2422) * Day) + elonge - elongp), 360) + 360, 360); /* Convert from perigee co-ordinates to epoch 1980.0 */

  /* Solve equation of Kepler */
  double e = M, delta;
  do {
    delta = e - eccent * sin(e) - M;
    e -= delta / (1 - eccent * cos(e));
  } while (fabs(delta) > 1E-6);
  double Ec = e;
  Ec = 2 * atan(sqrt((1 + eccent) / (1 - eccent)) * tan(Ec / 2)); /* True anomaly */

  double Lambdasun = fmod(fmod((((Ec) * (180.0 / M_PI)) + elongp), 360) + 360, 360); /* Sun's geocentric ecliptic longitude */
  double ml = fmod(fmod((13.1763966 * Day + 64.975464), 360) + 360, 360); /* Moon's mean lonigitude at the epoch */
  double MM = fmod(fmod((ml - 0.1114041 * Day - 349.383063), 360) + 360, 360); /* 349:  Mean longitude of the perigee at the epoch */ /* Moon's mean anomaly */
  double Ev = 1.2739 * sin(torad * (2 * (ml - Lambdasun) - MM)); /* Evection */
  double Ae = 0.1858 * sin(M); /* Annual equation */
  double MmP = torad * (MM + Ev - Ae - (0.37 * sin(M))); /* Corrected anomaly */
  double lP = ml + Ev + (6.2886 * sin(MmP)) - Ae + (0.214 * sin(2 * MmP)); /* Corrected longitude */
  double lPP = lP + (0.6583 * sin(torad * (2 * (lP - Lambdasun)))); /* True longitude */
  double MoonAge = lPP - Lambdasun; /* Age of the Moon in degrees */

  return MoonAge * torad;
}
