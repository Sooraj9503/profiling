#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define SIZE 1000

void matrixMultiply(int **A, int **B, int **C, int num_threads) {
    #pragma omp parallel for num_threads(8)
    for (int i = 0; i < SIZE; ++i) {
        for (int j = 0; j < SIZE; ++j) {
            int sum = 0;
            for (int k = 0; k < SIZE; ++k) {
                sum += A[i][k] * B[k][j];
            }
            C[i][j] = sum;
        }
    }
}

int main() {
    int **A = (int **)malloc(SIZE * sizeof(int *));
    int **B = (int **)malloc(SIZE * sizeof(int *));
    int **C = (int **)malloc(SIZE * sizeof(int *));
    for (int i = 0; i < SIZE; ++i) {
        A[i] = (int *)malloc(SIZE * sizeof(int));
        B[i] = (int *)malloc(SIZE * sizeof(int));
        C[i] = (int *)malloc(SIZE * sizeof(int));
    }

    for (int i = 0; i < SIZE; ++i) {
        for (int j = 0; j < SIZE; ++j) {
            A[i][j] = rand() % 100;
            B[i][j] = rand() % 100;
        }
    }

    int num_threads = 8; // Adjust the number of threads as needed

    double start_time = omp_get_wtime();
    matrixMultiply(A, B, C, num_threads);
    double end_time = omp_get_wtime();

    printf("Time taken: %f seconds\n", end_time - start_time);

    for (int i = 0; i < SIZE; ++i) {
        free(A[i]);
        free(B[i]);
        free(C[i]);
    }
    free(A);
    free(B);
    free(C);

    return 0;
}

