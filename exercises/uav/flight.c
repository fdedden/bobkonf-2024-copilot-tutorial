#include <stdint.h>
#include <time.h>

#include "flight.h"

#define SCALE 2

// External variables.
double uptime = 0;
double actual_altitude = 0;
double altimeter0 = 0;
double altimeter1 = 0;
double altimeter2 = 0;

// Internal variable.
double _time_start;


// Calculate the altitude given a point in time.
void calc_altitude(double t) {
  static double segment0, segment1 = 0;

  if (t < 2.0) {
    actual_altitude = t*t*SCALE;
    segment0 = actual_altitude;
  }
  else if (t < 5.0) {
    double t0 = t-2.0;
    actual_altitude = segment0 + t0*SCALE;
    segment1 = actual_altitude;
  }
  else if (t < 8.0) {
    double t0 = t-5.0;
    actual_altitude = segment1 - t0*t0 * SCALE;
  }
  if (actual_altitude < 0) {
    actual_altitude = 0;
  }
}

void init_sensors() {
  // Log the start time of the system.
  struct timespec ts;
  clock_gettime(CLOCK_REALTIME, &ts);
  _time_start = ts.tv_sec + ts.tv_nsec / 1e9;
}

// Update all sensor values.
void read_sensors() {
  // Calculate the current uptime.
  struct timespec ts;
  clock_gettime(CLOCK_REALTIME, &ts);
  uptime = (ts.tv_sec + ts.tv_nsec / 1e9) - _time_start;

  calc_altitude(uptime);

  // Depending on the time, create some faulty sensor readings.
  if ((uptime > 3.1 && uptime < 3.3) || (uptime > 5.3 && uptime < 5.9)) {
    altimeter0 = actual_altitude + uptime * 10;
  } else {
    altimeter0 = actual_altitude;
  }
  altimeter1 = actual_altitude;
  if (uptime > 5.6 && uptime < 6.5) {
    altimeter2 = actual_altitude - uptime * 5;
  } else {
    altimeter2 = actual_altitude;
  }
}
