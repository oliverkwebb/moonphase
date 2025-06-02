#!/usr/bin/env raku

use lib './lib';
use Moonphase;

sub moon-illumination($timestamp) {
    my $inst = Instant.from-posix: $timestamp;

    return ((1 - cos moonphase($inst)) / 2) * 100;
}

say "Running assertions…";

my &mi = &moon-illumination;

# Using POSIX timestamps
die "Failed 1" unless &mi(-178070400).round(0.1) ==  1.2;
die "Failed 2" unless &mi( 361411200).round(0.1) == 93.6;
die "Failed 3" unless &mi(1704931200).round(0.1) ==  0.4;
die "Failed 4" unless &mi(2898374400).round(0.1) == 44.2;

say "All tests passed.";
