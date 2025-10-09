# CS 61C Project 1: Image Manipulation in C

This project features two powerful C programs for image manipulation: a sophisticated implementation of Conway's Game of Life and a steganography tool for revealing hidden messages in images. Both programs operate on PPM (P3) image files.

## Features

- **Conway's Game of Life**: A cellular automaton that evolves based on a given hexadecimal rule. The evolution happens on the bit level of the RGB color channels, creating intricate and mesmerizing patterns.
- **Steganography Decoder**: A tool to reveal hidden messages in an image. It works by extracting the least significant bit (LSB) of the blue channel of each pixel and creating a new black and white image from these bits.

## Compilation

To compile the project, simply run the `make` command in the project's root directory:

```bash
make
```

This will create two executables: `gameOfLife` and `steganography`.

## Usage

### Conway's Game of Life

To run the Game of Life simulation, use the following command:

```bash
./gameOfLife <input_file.ppm> <rule>
```

- `<input_file.ppm>`: The path to the input PPM image file.
- `<rule>`: A hexadecimal number (e.g., `0x1808`) that defines the rules for the simulation.

The program will output the next generation of the image to standard output. You can redirect this output to a file to save the new image:

```bash
./gameOfLife inputs/glider.ppm 0x1808 > output.ppm
```

### Steganography Decoder

To decode a hidden message from an image, use the following command:

```bash
./steganography <input_file.ppm>
```

- `<input_file.ppm>`: The path to the input PPM image file containing the hidden message.

The program will output a new black and white image to standard output, revealing the hidden message. You can redirect this output to a file to save the decoded image:

```bash
./steganography inputs/secret.ppm > decoded_message.ppm
```

## Image Format

This project uses the PPM (P3) image format. This is a simple, text-based format for storing color images. You can find many PPM images online, or you can create your own using an image editor like GIMP.
