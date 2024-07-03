#include<stdio.h>
#include<pthread.h>
#include<stdlib.h>

void *thread(void *value){
    long num = *((long*) value);
    printf("Printing the value: %ld\n", num);
    
    return NULL;
}

int main(){
    pthread_t t1, t2;
    

    long val1 = 1;
    long val2 = 10;
    // thread((void*)&val1);
    // thread((void*)&val2);
    pthread_create(&t1, NULL, thread,(void*)&val1);
    pthread_create(&t2, NULL, thread,(void*)&val2);    
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    return 0;
}