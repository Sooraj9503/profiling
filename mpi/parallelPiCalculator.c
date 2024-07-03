#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <math.h>

#define N 999999

int main(int argc, char** argv) {
    int rank, size, i;
    double area, pi;
    double dx, y, x;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    int chunkSize=N/size;
    int start=rank*chunkSize;
    int end=(rank+1)*(chunkSize);
    if(rank==size-1) end=N;

    dx = 1.0 / N;
    x = 0.0;
    area = 0.0;
    double start_time=MPI_Wtime();
    for (i = start; i < end; i++) {
        x = i * dx;
        y = sqrt(1 - x * x);
        area += y * dx;
    }
    
    double totalArea=0.0;
    MPI_Reduce(&area, &totalArea, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    double end_time=MPI_Wtime();

    if(rank==0){
        pi = 4.0 * totalArea;
    printf("\nValue of pi is: %.5f\nExecution time is: %.6f seconds\n", pi, end_time-start_time);
    }
    MPI_Finalize();
    return 0;
}
