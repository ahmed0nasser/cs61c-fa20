#include "transpose.h"
#define MIN(a, b) ((a) < (b) ? (a) : (b))

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
     for (int by = 0; by < n; by+=blocksize) {
         for (int bx = 0; bx < n; bx+=blocksize) {
             for (int y = by; y < MIN(by + blocksize, n); y++) {
                 for (int x = bx; x < MIN(bx + blocksize, n); x++) {
                     dst[y + x * n] = src[x + y * n];
                 }
             }
         }
     }
 }
