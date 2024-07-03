#include<stdio.h>
#include<pthread.h>
#include<stdlib.h>
#define N 50;
long sum = 0;
void *add(void *threadId){
    long tid = *((*long)threadId);
    sum += tid;
}

int main(){
    pthread_t t;
    t = malloc(sizeof * N(long));
    for(t = 1; t <= 10; t++){
    pthread_createL(t, NULL, add, (void*)&t)
    }
    for(t = 1; t <= 10; t++){
    pthread_join(t, NULL);
    }

    printf("Sum of natural numbers upto %d is %ld\n", N, sum);
    return 0;
}