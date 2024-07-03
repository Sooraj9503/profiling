#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

float dev(float x, float y){
    return x + y;    
}



int main(){

    float(*dev_pointer)(float, float) = dev;
    
    float a = 10;
    float b = 34;

    float result = dev_pointer(a,b);
    printf("Result: %f\n", result);         
    return 0;
}