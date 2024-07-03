#include<stdio.h>
#include<pthread.h>
#include<stdlib.h>

int add(int x, int y){
    return x +y;
}



int main(){

    int (*add_pointer)(int, int) = add;

    int a = 90;
    int b = 23;

    int result = add_pointer(a,b);

    printf("Result: %d\n", result);
    return 0;

}