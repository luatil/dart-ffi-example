// native_math.c
// Simple C library with math functions

#include <stdint.h>

// Simple add function
int32_t add(int32_t a, int32_t b) {
    return a + b;
}

// Multiply function
int32_t multiply(int32_t a, int32_t b) {
    return a * b;
}

// A slightly more complex function - calculate factorial
int32_t factorial(int32_t n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
