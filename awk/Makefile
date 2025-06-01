all: test

test:
	awk -f moonphase.awk -e '(((1-cos(moonphase($$1)))/2)*100) ""  != $$2 {print $$NR " failed: " $$2 " vs " (((1-cos(moonphase($$1)))/2)*100)}' testfile
