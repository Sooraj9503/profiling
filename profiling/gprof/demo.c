#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Function 1: calculates the factorial of a number
int factorial(int n) {
    if (n == 0) {
        return 1;
    } else {
        return n * factorial(n-1);
    }
}

// Function 2: calculates the Fibonacci sequence
int fibonacci(int n) {
    if (n == 0) {
        return 0;
    } else if (n == 1) {
        return 1;
    } else {
        return fibonacci(n-1) + fibonacci(n-2);
    }
}

// Function 3: calculates the greatest common divisor (GCD) of two numbers
int gcd(int a, int b) {
    if (b == 0) {
        return a;
    } else {
        return gcd(b, a % b);
    }
}

// Function 4: calculates the least common multiple (LCM) of two numbers
int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}

// Function 5: calculates the sum of an array of integers
int sum_array(int arr[], int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }
    return sum;
}

// Function 6: calculates the average of an array of integers
float average_array(int arr[], int n) {
    return (float)sum_array(arr, n) / n;
}

// Function 7: calculates the standard deviation of an array of integers
float std_dev_array(int arr[], int n) {
    float avg = average_array(arr, n);
    float sum_squares = 0;
    for (int i = 0; i < n; i++) {
        sum_squares += pow(arr[i] - avg, 2);
    }
    return sqrt(sum_squares / n);
}

// Function 8: calculates the median of an array of integers
float median_array(int arr[], int n) {
    int mid = n / 2;
    if (n % 2 == 0) {
        return (arr[mid-1] + arr[mid]) / 2.0;
    } else {
        return arr[mid];
    }
}

// Main function
int main() {
    int arr[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int n = sizeof(arr) / sizeof(arr[0]);

    int fact = factorial(5);
    int fib = fibonacci(8);
    int gcd_val = gcd(12, 15);
    int lcm_val = lcm(12, 15);
    int sum = sum_array(arr, n);
    float avg = average_array(arr, n);
    float std_dev = std_dev_array(arr, n);
    float median = median_array(arr, n);

    printf("Factorial of 5: %d\n", fact);
    printf("Fibonacci of 8: %d\n", fib);
    printf("GCD of 12 and 15: %d\n", gcd_val);
    printf("LCM of 12 and 15: %d\n", lcm_val);
    printf("Sum of array: %d\n", sum);
    printf("Average of array: %f\n", avg);
    printf("Standard deviation of array: %f\n", std_dev);
    printf("Median of array: %f\n", median);

    return 0;
}