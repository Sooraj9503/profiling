#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdbool.h>

#define MAX 1000000

int upto;
int N;
bool is_prime[MAX + 1];

void *calculate_primes(void *rank) {
    long my_rank = (long)rank;
    int start = my_rank * (upto / N);
    int end = (my_rank + 1) * (upto / N) - 1;

    if (my_rank == 0) {
        start = 2; 
    }
    if (my_rank == N - 1) {
        end = upto; 
    }

    for (int i = start; i <= end; i++) {
        if (i <= 1) {
            is_prime[i] = false;
        } else {
            is_prime[i] = true;
        }
    }

    for (int i = 2; i * i <= upto; i++) {
        if (is_prime[i]) {
            for (int j = i * i; j <= upto; j += i) {
                if (j >= start && j <= end) {
                    is_prime[j] = false;
                }
            }
        }
    }

    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <upper limit> <number of threads>\n", argv[0]);
        return -1;
    }

    upto = strtol(argv[1], NULL, 10);
    N = strtol(argv[2], NULL, 10);

    if (upto > MAX) {
        printf("Upper limit too high. Please use a value less than or equal to %d.\n", MAX);
        return -1;
    }

    pthread_t *t = malloc(N * sizeof(pthread_t));

    for (long thread = 0; thread < N; thread++) {
        pthread_create(&t[thread], NULL, calculate_primes, (void *)thread);
    }

    for (long thread = 0; thread < N; thread++) {
        pthread_join(t[thread], NULL);
    }

    printf("Prime numbers up to %d are:\n", upto);
    for (int i = 2; i <= upto; i++) {
        if (is_prime[i]) {
            printf("%d ", i);
        }
    }
    printf("\n");

    free(t);
    return 0;
}