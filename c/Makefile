all: test

build:
	cc frontend.c moonphase.c -lm -o frontend

test: build
	test `./frontend -178070400` = 1.2
	test `./frontend 361411200` = 93.6
	test `./frontend 1704931200` = 0.4
	test `./frontend 2898374400` = 44.2
