#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_VALUE 255

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image *readData(char *filename) {
  FILE *fp = fopen(filename, "r");
  if (fp == NULL) {
    printf("Failed to open file: %s\n", filename);
    exit(-1);
  }

  Image *image = (Image *)malloc(sizeof(Image));
  if (image == NULL) {
    printf("Failed to allocate memory for image\n");
    exit(-1);
  }
  if (fscanf(fp, "%*s\n%" SCNu32 " %" SCNu32 "\n%*d\n", &image->cols,
             &image->rows) != 2) {
    printf("Failed to read .ppm P3 file header: %s\n", filename);
    exit(-1);
  }

  image->image = (Color **)malloc(image->rows * sizeof(Color *));
  if (image->image == NULL) {
    printf("Failed to allocate memory for image rows = %" PRIu32 "\n", image->rows);
    exit(-1);
  }
  for (uint32_t i = 0; i < image->rows; i++) {
    image->image[i] = (Color *)malloc(image->cols * sizeof(Color));
    if (image->image[i] == NULL) {
      printf("Failed to allocate memory for image cols at row = %" PRIu32 "\n", i);
      exit(-1);
    }
  }

  for (uint32_t i = 0; i < image->rows; i++) {
    for (uint32_t j = 0; j < image->cols; j++) {
      Color *clr = image->image[i] + j;
      if (fscanf(fp, "%" SCNu8 "%" SCNu8 "%" SCNu8, &clr->R, &clr->G,
                 &clr->B) != 3) {
        printf("Failed to read pixel at (row, col): (%" PRIu32 ", %" PRIu32
               ")\n",
               i, j);
        exit(-1);
      }
    }
  }

  fclose(fp);
  return image;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the
// image's data.
void writeData(Image *image) {
  if (image == NULL) {
    printf("Failed to write image: image is NULL\n");
    exit(-1);
  }

  // .ppm P3 file header
  printf("P3\n%" PRIu32 " %" PRIu32 "\n%" PRIu8 "\n", image->cols, image->rows,
         MAX_VALUE);

  for (uint32_t i = 0; i < image->rows; i++) {
    for (uint32_t j = 0; j < image->cols; j++) {
      Color *clr = image->image[i] + j;
      printf("%3" PRIu8 " %3" PRIu8 " %3" PRIu8, clr->R, clr->G, clr->B);
      if (j < image->cols - 1)
        printf("   ");
    }
    printf("\n");
  }
}

// Frees an image
void freeImage(Image *image) {
  if (image == NULL) {
    printf("Failed to free image: image is NULL\n");
    exit(-1);
  }

  for (uint32_t i = 0; i < image->rows; i++) {
    free(image->image[i]);
  }
  free(image->image);
  free(image);
}