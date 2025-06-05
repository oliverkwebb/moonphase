import std/math

# Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
func moonphase*(ud: float64): float64 =
  template fixAngle(a: float64): float64 = ((a mod 360) + 360) mod 360

  const
    eccent = 0.016718
    elonge = 278.833540
    elongp = 282.596403

  let
    day = (ud / 86400.0 + 2440587.5) - 2444238.5
    m = degToRad fixAngle(((360.0 / 365.2422) * day) + elonge - elongp)

  var
    e = m
    delta = e - eccent * e.sin - m

  e = e - delta / (1 - eccent * cos e)

  while delta.abs > 1E-6:
    delta = e - eccent * e.sin - m
    e = e - delta / (1 - eccent * cos e)

  var ec = 2 * (sqrt((1 + eccent) / (1 - eccent)) * tan(e / 2)).arctan

  let
    lambdasun = fixAngle((ec * (180 / PI)) + elongp)
    ml = fixAngle(13.1763966 * day + 64.975464)
    mm = fixAngle(ml - 0.1114041 * day - 349.383063)
    ev = 1.2739 * sin(degToRad(2.0 * (ml - lambdasun) - mm))
    ae = 0.1858 * sin m
    mmp = degToRad(mm + ev - ae - (0.37 * sin m))
    lp = ml + ev + (6.2886 * sin(mmp) - ae + (0.214 * sin(2.0 * mmp)))
    lpp = lp + (0.6583 * sin(degToRad(2.0 * (lp - lambdasun))))
    moonAge = lpp - lambdasun

  degToRad moonAge

when isMainModule:
  func illumfrac(d: float64): float64 = ((1 - cos d) / 2) * 100

  doAssert illumfrac(moonphase(-178070400.0)).round(1) == 1.2
  doAssert illumfrac(moonphase(361411200.0)).round(1) == 93.6
  doAssert illumfrac(moonphase(1704931200.0)).round(1) == 0.4
  doAssert illumfrac(moonphase(2898374400.0)).round(1) == 44.2
