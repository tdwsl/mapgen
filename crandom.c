/* crandom.c */

#include <stdlib.h>
#include <time.h>

void seed_random() {
    srand(time(0));
}
