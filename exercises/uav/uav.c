#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>

#include "flight.h"
#include "uav-monitor.h"

void monitor(double alt) {
  printf("\tAltitude violation: %f\n", alt);
}

void debug
  ( double time
  , double altAvg
  , double daltAvg
  , double altVoted
  , double daltVoted
  , bool daltVoted_trustworthy
  ) {
  printf(
      "time:%.3f, "
      "actualAlt:%.3f, "
      "altAvg:%.3f, "
      "davg:%.3f, "
      "altVoted:%.3f, "
      "dvoted:%.3f, "
      "trustw:%s\n"
    , time
    , actual_altitude
    , altAvg
    , daltAvg
    , altVoted
    , daltVoted
    , daltVoted_trustworthy ? "yes" : "no"
  );
}

void avg_violated(double d) {
  printf("\t>>> Violation: delta average altitude: %.3f <<<\n", d);
}

void voted_violated(double d) {
  printf("\t>>> Violation: delta voted altitude: %.3f <<<\n", d);
}

void voted_not_trustworthy() {
  printf("\t>>> Violation: voted altitude not trustworthy! <<<\n");
}

int main (int argc, char **argv) {
  printf("Starting UAV...\n");

  init_sensors();
  read_sensors();

  while (uptime < 10.0) {
    // Wait 137ms to simulate a busy mainloop.
    usleep(137e3);

    read_sensors();

    step();
  }
  printf("Shutting down...\n");
}
