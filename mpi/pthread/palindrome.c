#include <stdio.h>
#include <pthread.h>

// Define a structure to hold the data
typedef struct {
    int num;
    int reverse;
} Data;

// Function to reverse the number
void* rev_fun(void* arg) {
    Data* data = (Data*)arg; // Correctly cast the argument to Data*
    int num = data->num;
    int rev = 0;

    while (num != 0) {
        int remainder = num % 10;
        rev = rev * 10 + remainder;
        num /= 10;
    }

    data->reverse = rev;
    pthread_exit(NULL);
    return NULL;
}

// Function to check if the number is a palindrome
void* check_fun(void* arg) {
    Data* data = (Data*)arg; // Correctly cast the argument to Data*

    if (data->reverse == data->num)
        printf("Entered number IS a palindrome.\n");
    else
        printf("Entered number IS NOT a palindrome.\n");

    pthread_exit(NULL);
    return NULL;
}

int main() {
    pthread_t t1, t2;
    Data data;

    printf("Enter an integer number to check if it is a palindrome: ");
    scanf("%d", &data.num);

    // Create thread to reverse the number
    pthread_create(&t1, NULL, rev_fun, (void*)&data);
    pthread_join(t1, NULL); // Wait for the reverse function to finish
    printf("Reversed number is: %d\n", data.reverse);

    // Create thread to check if the number is a palindrome
    pthread_create(&t2, NULL, check_fun, (void*)&data);
    pthread_join(t2, NULL); // Wait for the check function to finish

    return 0;
}
