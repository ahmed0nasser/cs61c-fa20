#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

void processCLI(int argc, char **argv, char **filename) {
  if (argc != 2) {
    printf("usage: %s filename\n", argv[0]);
    printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
    exit(-1);
  }
  *filename = argv[1];
}

int main(int argc, char **argv) {
  Image *image;
  uint32_t rule;
  char *filename;
  processCLI(argc, argv, &filename);
  image = readData(filename);
  writeData(image);
  freeImage(image);
}