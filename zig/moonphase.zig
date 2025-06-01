// Adapted from "moontool.c" by John Walker: See http://www.fourmilab.ch/moontool/
pub fn moonphase(unix_date: f64) f64 {
    const std = @import("std");
    const math = std.math;
    const eccent: f64 = 0.016718; // Eccentricity of Earth's orbit
    const elonge: f64 = 278.833540; // Ecliptic longitude of the Sun at epoch 1980.0
    const elongp: f64 = 282.596403; // Ecliptic longitude of the Sun at perigee
    const torad: f64 = math.pi / 180.0;

    const T = struct {
        fn fixangle(d: f64) f64 {
            return @mod(((@mod(d, 360.0)) + 360.0), 360.0);
        }
    };

    const fixangle = T.fixangle;

    // Calculation of the Sun's position
    const Day = (unix_date / 86400.0 + 2440587.5) - 2444238.5; // Date within epoch
    const M = torad * fixangle(((360.0 / 365.2422) * Day) + elonge - elongp); // Convert from perigee co-ordinates to epoch 1980.0

    // Solve equation of Kepler
    var e = M;
    var delta = e - eccent * math.sin(e) - M;
    e = e - delta / (1.0 - eccent * math.cos(e));
    while (@abs(delta) > 1E-6) {
        delta = e - eccent * math.sin(e) - M;
        e = e - delta / (1.0 - eccent * math.cos(e));
    }
    var Ec = e;
    Ec = 2.0 * math.atan(math.sqrt((1.0 + eccent) / (1.0 - eccent)) * math.tan(Ec / 2.0)); //  True anomaly

    const Lambdasun = fixangle(((Ec) * (180.0 / math.pi)) + elongp); // Sun's geocentric ecliptic longitude
    const ml = fixangle(13.1763966 * Day + 64.975464); // Moon's mean lonigitude at the epoch
    const MM = fixangle(ml - 0.1114041 * Day - 349.383063); // 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
    const Ev = 1.2739 * math.sin(torad * (2.0 * (ml - Lambdasun) - MM)); // Evection
    const Ae = 0.1858 * math.sin(M); // Annual equation
    const MmP = torad * (MM + Ev - Ae - (0.37 * math.sin(M))); // Corrected anomaly
    const lP = ml + Ev + (6.2886 * math.sin(MmP)) - Ae + (0.214 * math.sin(2.0 * MmP)); // Corrected longitude
    const lPP = lP + (0.6583 * math.sin(torad * (2.0 * (lP - Lambdasun)))); // True longitude
    const MoonAge = lPP - Lambdasun; // Age of the Moon in degrees

    return MoonAge * torad;
}

test moonphase {
    const std = @import("std");
    try std.testing.expectApproxEqAbs(((1.0 - std.math.cos(moonphase(-178070400.0))) / 2.0) * 100.0, 1.2, 0.1);
    try std.testing.expectApproxEqAbs(((1.0 - std.math.cos(moonphase(361411200.0))) / 2.0) * 100.0, 93.6, 0.1);
    try std.testing.expectApproxEqAbs(((1.0 - std.math.cos(moonphase(1704931200.0))) / 2.0) * 100.0, 0.4, 0.1);
    try std.testing.expectApproxEqAbs(((1.0 - std.math.cos(moonphase(2898374400.0))) / 2.0) * 100.0, 44.2, 0.1);
}
