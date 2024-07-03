#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

#define rows 4000
#define cols 4000

int arr1[rows][cols];
int arr2[rows][cols];
int arr3[rows][cols];
int N;

void * Pth_mat_vect(void* rank) {
    long my_rank = (long)rank;
    
    // Defining work among pthreads
    int chunkSize = rows / N;
    int start = my_rank * chunkSize;
    int end = (my_rank + 1) * chunkSize;

    // Dividing work among pthreads
    for (int i = start; i < end; i++) {
        for (int j = 0; j < cols; j++) {
            arr3[i][j] = arr1[i][j] + arr2[i][j];
        }
    }
    return NULL;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <number of threads>\n", argv[0]);
        return -1;
    }

    N = strtol(argv[1], NULL, 10);

    // Array initialization
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            arr1[i][j] = j + 1;
            arr2[i][j] = j + 2;
            arr3[i][j] = 0;
        }
    }

    // Creating pthreads
    pthread_t* t = malloc(N * sizeof(pthread_t));
    for (long thread = 0; thread < N; thread++) {
        pthread_create(&t[thread], NULL, Pth_mat_vect, (void*)thread);
    }

    // Joining all pthreads
    for (long thread = 0; thread < N; thread++) {
        pthread_join(t[thread], NULL);
    }

    // Display the addition of arrays
    // printf("Addition of both Arrays:\n");
    // for (int i = 0; i < rows; i++) {
    //     for (int j = 0; j < cols; j++) {
    //         printf("%d ", arr3[i][j]);
    //     }
    //     printf("\n");
    // }

    free(t);

    return 0;
}