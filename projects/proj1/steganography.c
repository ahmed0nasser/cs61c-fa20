#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

// Determines what color the cell at the given row/col should be. This should
// not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col) {
  if (image == NULL) {
    printf("Error: image is NULL\n");
    exit(-1);
  }

  uint8_t clr_val = image->image[row][col].B & 1 ? 255 : 0;
  Color *clr = (Color *)malloc(sizeof(Color));
  if (clr == NULL) {
    printf("Failed to allocate memory for color\n");
    exit(-1);
  }
  clr->R = clr->G = clr->B = clr_val;

  return clr;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image) {
  if (image == NULL) {
    printf("Error: image is NULL\n");
    exit(-1);
  }

  Image *new_image = (Image *)malloc(sizeof(Image));
  if (new_image == NULL) {
    printf("Failed to allocate memory for image\n");
    exit(-1);
  }
  new_image->rows = image->rows;
  new_image->cols = image->cols;

  new_image->image = (Color **)malloc(new_image->rows * sizeof(Color *));
  if (new_image->image == NULL) {
    printf("Failed to allocate memory for image rows = %" PRIu32 "\n",
           new_image->rows);
    exit(-1);
  }
  for (uint32_t i = 0; i < new_image->rows; i++) {
    new_image->image[i] = (Color *)malloc(new_image->cols * sizeof(Color));
    if (new_image->image[i] == NULL) {
      printf("Failed to allocate memory for image cols at row = %" PRIu32 "\n",
             i);
      exit(-1);
    }
  }

  for (uint32_t i = 0; i < new_image->rows; i++) {
    for (uint32_t j = 0; j < new_image->cols; j++) {
      Color *clr = new_image->image[i] + j;
      Color *new_clr = evaluateOnePixel(image, i, j);
      clr->R = new_clr->R;
      clr->B = new_clr->B;
      clr->G = new_clr->G;
      free(new_clr);
    }
  }

  return new_image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with
printf) a new image, where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not
necessarily with .ppm file extension). If the input is not correct, a malloc
fails, or any other error occurs, you should exit with code -1. Otherwise, you
should return from main with code 0. Make sure to free all memory before
returning!
*/
int main(int argc, char **argv) {
  char *filename = argv[1];
  Image *image = readData(filename);
  Image *new_image = steganography(image);
  writeData(new_image);
  freeImage(image);
  freeImage(new_image);
  return 0;
}
