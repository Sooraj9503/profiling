#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>

#define N 999999

int main() {
    int i;
    double area, pi;
    double dx, y, x;
    double exe_time;

    struct timeval stop_time, start_time;

    dx = 1.0 / N;
    x = 0.0;
    area = 0.0;

    gettimeofday(&start_time, NULL);

    for (i = 0; i < N; i++) {
        x = i * dx;
        y = sqrt(1 - x * x);
        area += y * dx;
    }

    gettimeofday(&stop_time, NULL);
    exe_time = (stop_time.tv_sec - start_time.tv_sec) + (stop_time.tv_usec - start_time.tv_usec) / 1000000.0;

    pi = 4.0 * area;
    printf("\nValue of pi is = %.16lf\nExecution time is = %6f seconds\n", pi, exe_time);

    return 0;
}
