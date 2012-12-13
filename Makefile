all:
	dmd -w -wi -O test.d inigear.d -oftest

clean:
	rm -f test test.o test.ini
