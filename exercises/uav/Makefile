CC=gcc
CFLAGS=-Wall -fPIC

OBJ=uav-monitor.o flight.o uav.o
INCLUDES=flight.h

PROJECT=uav
MONITOR=uav-monitor

all: $(PROJECT)

%.o: %.c
	$(CC) $(CFLAGS) -c $^

$(PROJECT): $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

$(MONITOR).c: Main.hs Voting.hs
	runhaskell $^

clean:
	rm -vf $(OBJ) $(MONITOR).c $(MONITOR).h $(MONITOR)_types.h $(PROJECT)
