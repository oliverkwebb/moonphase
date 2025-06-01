all: build test

build:
	cat moonphase.js node-bp.js > moonphase-node.js

# Buncha console.asserts
test:
	test `node testpart.js | wc -c` = 0