#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern double moonphase(double ud);

int main(int argc, char **argv) {
  time_t now = time(0);
  if (argc >= 2)
    now = atol(argv[1]);
  printf("%2.1f", ((1 - cos(moonphase(now))) / 2) * 100);
}
