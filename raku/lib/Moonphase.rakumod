unit module Moonphase;

sub moonphase($ud) is export {
    my $eccent  =   0.016718;    # Eccentricity of Earth's orbit
    my $elonge  = 278.833540;    # Ecliptic longitude of the Sun at epoch 1980.0
    my $elongp  = 282.596403;    # Ecliptic longitude of the Sun at perigee
    my $torad   = pi / 180;

    sub fixangle($a) { $a mod 360 }

    my $Day = ($ud / 86400 + 2440587.5) - 2444238.5;

    my $M = $torad * fixangle(((360 / 365.2422) * $Day) + $elonge - $elongp);

    # Solve equation of Kepler
    my $e = $M;
    my $delta;

    repeat {
        $delta = $e - $eccent * sin($e) - $M;
        $e -= $delta / (1 - $eccent * cos($e));
    } while abs($delta) > 1e-6;

    my $Ec = 2 * atan(sqrt((1 + $eccent) / (1 - $eccent)) * tan($e / 2));
    my $Lambdasun = fixangle(($Ec * (180 / pi)) + $elongp);

    my $ml = fixangle(13.1763966 * $Day + 64.975464);
    my $MM = fixangle($ml - 0.1114041 * $Day - 349.383063);

    my $Ev = 1.2739 * sin($torad * (2 * ($ml - $Lambdasun) - $MM));
    my $Ae = 0.1858 * sin($M);
    my $MmP = $torad * ($MM + $Ev - $Ae - (0.37 * sin($M)));

    my $lP = $ml + $Ev + (6.2886 * sin($MmP)) - $Ae + (0.214 * sin(2 * $MmP));
    my $lPP = $lP + (0.6583 * sin($torad * (2 * ($lP - $Lambdasun))));

    my $MoonAge = $lPP - $Lambdasun;

    return $MoonAge * $torad;
}
