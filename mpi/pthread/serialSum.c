#include <stdio.h>
#include <stdlib.h>

#define rows 4000
#define cols 4000

void sum(int **arr1, int **arr2, int **arr3) {
    // Dividing array elements
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            arr3[i][j] = arr1[i][j] + arr2[i][j];
        }
    }
}

int main() {
    int **arr1 = malloc(rows * sizeof(int *));
    int **arr2 = malloc(rows * sizeof(int *));
    int **arr3 = malloc(rows * sizeof(int *));
    
    for (int i = 0; i < rows; i++) {
        arr1[i] = malloc(cols * sizeof(int));
        arr2[i] = malloc(cols * sizeof(int));
        arr3[i] = malloc(cols * sizeof(int));
    }
    
    // Array initialization
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            arr1[i][j] = j + 1;
            arr2[i][j] = j + 2;
            arr3[i][j] = 0;
        }
    }

    sum(arr1, arr2, arr3);

    for (int i = 0; i < rows; i++) {
        free(arr1[i]);
        free(arr2[i]);
        free(arr3[i]);
    }
    
    free(arr1);
    free(arr2);
    free(arr3);

    return 0;
}