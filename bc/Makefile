all: test

test:
	test `echo "scale=100;((1-c(p(-178070400)))/2)*100" | bc -ls moonphase.bc | head -c3` = 1.1
	test `echo "scale=100;((1-c(p(361411200)))/2)*100"  | bc -ls moonphase.bc | head -c4` = 93.6
	test `echo "scale=100;((1-c(p(1704931200)))/2)*100" | bc -ls moonphase.bc | head -c2` = .3
	test `echo "scale=100;((1-c(p(2898374400)))/2)*100" | bc -ls moonphase.bc | head -c4` = 44.2
	test `echo "scale=100;((1-c(moonphase(-178070400)))/2)*100" | bc -l moonphase.gnu.bc | head -c3` = 1.1
	test `echo "scale=100;((1-c(moonphase(361411200)))/2)*100"  | bc -l moonphase.gnu.bc | head -c4` = 93.6
	test `echo "scale=100;((1-c(moonphase(1704931200)))/2)*100" | bc -l moonphase.gnu.bc | head -c2` = .3
	test `echo "scale=100;((1-c(moonphase(2898374400)))/2)*100" | bc -l moonphase.gnu.bc | head -c4` = 44.2
