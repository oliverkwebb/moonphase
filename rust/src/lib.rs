// Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
fn moonphase(ud: f64) -> f64 {
    let eccent = 0.016718; // Eccentricity of Earth's orbit
    let elonge = 278.833540; // Ecliptic longitude of the Sun at epoch 1980.0
    let elongp = 282.596403; // Ecliptic longitude of the Sun at perigee
    let torad = std::f64::consts::PI / 180.0;
    let fixangle = |a| ((a % 360.0) + 360.0) % 360.0;
    // Calculation of the Sun's position
    let day = (ud / 86400.0 + 2440587.5) - 2444238.5; // Date within epoch
    let M = torad * fixangle(((360.0 / 365.2422) * day) + elonge - elongp); // Convert from perigee co-ordinates to epoch 1980.0
    // Solve equation of Kepler
    let mut e = M;
    let mut delta;
    delta = e - eccent * e.sin() - M;
    e = e - delta / (1.0 - eccent * e.cos());
    while delta.abs() > 1E-6 {
        delta = e - eccent * e.sin() - M;
        e = e - delta / (1.0 - eccent * e.cos());
    }
    let mut ec = e;
    ec = 2.0 * (((1.0 + eccent) / (1.0 - eccent)).sqrt() * (ec / 2.0).tan()).atan(); //  True anomaly
    let lambdasun = fixangle(((ec) * (180.0 / std::f64::consts::PI)) + elongp); // Sun's geocentric ecliptic longitude
    let ml = fixangle(13.1763966 * day + 64.975464); // Moon's mean lonigitude at the epoch
    let MM = fixangle(ml - 0.1114041 * day - 349.383063); // 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
    let Ev = 1.2739 * (torad * (2.0 * (ml - lambdasun) - MM)).sin(); // Evection
    let Ae = 0.1858 * M.sin(); // Annual equation
    let MmP = torad * (MM + Ev - Ae - (0.37 * M.sin())); // Corrected anomaly
    let lP = ml + Ev + (6.2886 * MmP.sin() - Ae + (0.214 * (2.0 * MmP).sin())); // Corrected longitude
    let lPP = lP + (0.6583 * (torad * (2.0 * (lP - lambdasun))).sin()); // True longitude
    let MoonAge = lPP - lambdasun; // Age of the Moon in degrees
    return MoonAge * torad;
}

#[cfg(test)]

mod tests {
    use super::*;

    fn illumfrac(d: f64) -> f64 {
    	((1.0-d.cos())/2.0)*100.0
    }

    #[test]
    fn test_moonphase() {
        assert_eq!(format!("{:.1}", illumfrac(moonphase(-178070400.0))), "1.2");
        assert_eq!(format!("{:.1}", illumfrac(moonphase(361411200.0))), "93.6");
        assert_eq!(format!("{:.1}", illumfrac(moonphase(1704931200.0))), "0.4");
        assert_eq!(format!("{:.1}", illumfrac(moonphase(2898374400.0))), "44.2");
    }
}
