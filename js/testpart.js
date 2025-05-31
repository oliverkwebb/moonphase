var mp = require('./moonphase-node');
let mi = (d) => ((1 - Math.cos(mp.moonphase(d))) / 2)*100;
console.assert(mi(-178070400).toFixed(1) == 1.2);
console.assert(mi(361411200).toFixed(1) == 93.6);
console.assert(mi(1704931200).toFixed(1) == 0.4);
console.assert(mi(2898374400).toFixed(1) == 44.2);
