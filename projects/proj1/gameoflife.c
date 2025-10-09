#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#define COLOR_BITS_NUM 8
#define NEIGHBOURS_NUM 8

// Adds the alive clr's bits to clr_alive_neighbours
void addColorAliveNeighbours(uint8_t clr_alive_neighbours[], uint8_t clr) {
  for (int i = 0; i < COLOR_BITS_NUM; i++) {
    clr_alive_neighbours[i] += (clr >> i) & 1;
  }
}

// Evaluates color of the next generation given clr_alive_neighbours, current
// clr and the rule
uint8_t evaluateNewColor(uint8_t clr_alive_neighbours[], uint8_t clr,
                         uint32_t rule) {
  uint8_t new_clr = 0;
  for (int i = 0; i < COLOR_BITS_NUM; i++) {
    uint8_t bit = (clr >> i) & 1;
    new_clr += ((rule >> (bit * 9 + clr_alive_neighbours[i])) & 1) << i;
  }
  return new_clr;
}

// Determines what color the cell at the given row/col should be. This function
// allocates space for a new Color. Note that you will need to read the eight
// neighbors of the cell in question. The grid "wraps", so we treat the top row
// as adjacent to the bottom row and the left column as adjacent to the right
// column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule) {
  if (image == NULL) {
    printf("Error: image is NULL\n");
    exit(-1);
  }

  int last_row = image->rows - 1, last_col = image->cols - 1;
  int prev_row = row == 0 ? last_row : row - 1,
      next_row = row == last_row ? 0 : row + 1,
      prev_col = col == 0 ? last_col : col - 1,
      next_col = col == last_col ? 0 : col + 1;

  int neighbour_cells[][2] = {{prev_row, prev_col}, {prev_row, col},
                              {prev_row, next_col}, {row, prev_col},
                              {row, next_col},      {next_row, prev_col},
                              {next_row, col},      {next_row, next_col}};

  uint8_t red_alive_neighbours[COLOR_BITS_NUM];
  uint8_t green_alive_neighbours[COLOR_BITS_NUM];
  uint8_t blue_alive_neighbours[COLOR_BITS_NUM];
  for (int i = 0; i < COLOR_BITS_NUM; i++) {
    red_alive_neighbours[i] = green_alive_neighbours[i] =
        blue_alive_neighbours[i] = 0;
  }

  for (int i = 0; i < NEIGHBOURS_NUM; i++) {
    int neighbour_row = neighbour_cells[i][0];
    int neighbour_col = neighbour_cells[i][1];
    Color *neighbour_color = image->image[neighbour_row] + neighbour_col;
    addColorAliveNeighbours(red_alive_neighbours, neighbour_color->R);
    addColorAliveNeighbours(green_alive_neighbours, neighbour_color->G);
    addColorAliveNeighbours(blue_alive_neighbours, neighbour_color->B);
  }

  Color *clr = image->image[row] + col;
  Color *new_clr = (Color *)malloc(sizeof(Color));
  if (new_clr == NULL) {
    printf("Failed to allocate memory for color\n");
    exit(-1);
  }
  new_clr->R = evaluateNewColor(red_alive_neighbours, clr->R, rule);
  new_clr->G = evaluateNewColor(green_alive_neighbours, clr->G, rule);
  new_clr->B = evaluateNewColor(blue_alive_neighbours, clr->B, rule);

  return new_clr;
}

// The main body of Life; given an image and a rule, computes one iteration of
// the Game of Life. You should be able to copy most of this from
// steganography.c
Image *life(Image *image, uint32_t rule) {
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
      Color *new_clr = evaluateOneCell(image, i, j, rule);
      clr->R = new_clr->R;
      clr->B = new_clr->B;
      clr->G = new_clr->G;
      free(new_clr);
    }
  }

  return new_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then
prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this
will be a string. You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you
should exit with code -1. Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv) {
  if (argc != 3) {
    printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file "
           "(type P3) with maximum value 255.\nrule is a hex number beginning "
           "with 0x; Life is 0x1808.\n");
    return -1;
  }

  char *filename = argv[1];
  char *rule_str = argv[2];
  char *endptr;

  uint32_t rule = strtol(rule_str, &endptr, 16);
  if (*endptr != '\0') {
    printf("Failed to read rule: %s", rule_str);
    return -1;
  }

  Image *image = readData(filename);
  Image *new_image = life(image, rule);
  writeData(new_image);
  freeImage(image);
  freeImage(new_image);
  return 0;
}
