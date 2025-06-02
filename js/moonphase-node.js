// Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
function moonphase(ud) {
    let eccent = 0.016718; // Eccentricity of Earth's orbit
    let elonge = 278.833540; // Ecliptic longitude of the Sun at epoch 1980.0
    let elongp = 282.596403; // Ecliptic longitude of the Sun at perigee
    let torad = Math.PI / 180.0;
    const fixangle = a => ((a % 360) + 360) % 360;
    // Calculation of the Sun's position
    let Day = (ud / 86400 + 2440587.5) - 2444238.5; // Date within epoch
    let M = torad * fixangle(((360 / 365.2422) * Day) + elonge - elongp); // Convert from perigee co-ordinates to epoch 1980.0
    // Solve equation of Kepler
    let e = M;
    let delta;
    do {
        delta = e - eccent * Math.sin(e) - M;
        e -= delta / (1 - eccent * Math.cos(e));
    } while (Math.abs(delta) > 1E-6);
    let Ec = e;
    Ec = 2 * Math.atan(Math.sqrt((1 + eccent) / (1 - eccent)) * Math.tan(Ec / 2)); //  True anomaly
    let Lambdasun = fixangle(((Ec) * (180.0 / Math.PI)) + elongp); // Sun's geocentric ecliptic longitude
    let ml = fixangle(13.1763966 * Day + 64.975464); // Moon's mean lonigitude at the epoch
    let MM = fixangle(ml - 0.1114041 * Day - 349.383063); // 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
    let Ev = 1.2739 * Math.sin(torad * (2 * (ml - Lambdasun) - MM)); // Evection
    let Ae = 0.1858 * Math.sin(M); // Annual equation
    let MmP = torad * (MM + Ev - Ae - (0.37 * Math.sin(M))); // Corrected anomaly
    let lP = ml + Ev + (6.2886 * Math.sin(MmP)) - Ae + (0.214 * Math.sin(2 * MmP)); // Corrected longitude
    let lPP = lP + (0.6583 * Math.sin(torad * (2 * (lP - Lambdasun)))); // True longitude
    let MoonAge = lPP - Lambdasun; // Age of the Moon in degrees
    return MoonAge * torad;
}

// I want this stuff as Copy-Pastable as possible, no boilerplate in the main files if the language can help it

module.exports = {
	moonphase: moonphase
}
