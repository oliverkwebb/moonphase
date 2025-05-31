// Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
function moonphase(ud) {
    var eccent = 0.016718; // Eccentricity of Earth's orbit
    var elonge = 278.833540; // Ecliptic longitude of the Sun at epoch 1980.0
    var elongp = 282.596403; // Ecliptic longitude of the Sun at perigee
    var torad = Math.PI / 180.0;
    var fixangle = function (a) { return ((a % 360) + 360) % 360; };
    // Calculation of the Sun's position
    var Day = (ud / 86400 + 2440587.5) - 2444238.5; // Date within epoch
    var M = torad * fixangle(((360 / 365.2422) * Day) + elonge - elongp); // Convert from perigee co-ordinates to epoch 1980.0
    // Solve equation of Kepler
    var e = M;
    var delta;
    delta = e - eccent * Math.sin(e) - M;
    e = e - delta / (1 - eccent * Math.cos(e));
    while (Math.abs(delta) > 1E-6) {
        delta = e - eccent * Math.sin(e) - M;
        e = e - delta / (1 - eccent * Math.cos(e));
    }
    var Ec = e;
    Ec = 2 * Math.atan(Math.sqrt((1 + eccent) / (1 - eccent)) * Math.tan(Ec / 2)); //  True anomaly
    var Lambdasun = fixangle(((Ec) * (180.0 / Math.PI)) + elongp); // Sun's geocentric ecliptic longitude
    var ml = fixangle(13.1763966 * Day + 64.975464); // Moon's mean lonigitude at the epoch
    var MM = fixangle(ml - 0.1114041 * Day - 349.383063); // 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
    var Ev = 1.2739 * Math.sin(torad * (2 * (ml - Lambdasun) - MM)); // Evection
    var Ae = 0.1858 * Math.sin(M); // Annual equation
    var MmP = torad * (MM + Ev - Ae - (0.37 * Math.sin(M))); // Corrected anomaly
    var lP = ml + Ev + (6.2886 * Math.sin(MmP)) - Ae + (0.214 * Math.sin(2 * MmP)); // Corrected longitude
    var lPP = lP + (0.6583 * Math.sin(torad * (2 * (lP - Lambdasun)))); // True longitude
    var MoonAge = lPP - Lambdasun; // Age of the Moon in degrees
    return MoonAge * torad;
}
