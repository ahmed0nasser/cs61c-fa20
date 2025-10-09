# CS 61C Project 2: Neural Network Classification in RISC-V

This project involves implementing a simple neural network for classification in RISC-V assembly. The project is divided into two parts: Part A, which focuses on the core mathematical operations, and Part B, which handles file I/O and the main classification logic.

## Project Structure

```
.
├── inputs              # Test inputs for the neural network
├── outputs             # Reference outputs for testing
├── README.md           # Project description
├── src                 # Source code for the assembly files
│   ├── argmax.s        # (Part A) Find the index of the maximum value in an array
│   ├── classify.s      # (Part B) Main classification logic
│   ├── dot.s           # (Part A) Compute the dot product of two vectors
│   ├── main.s          # Main entry point
│   ├── matmul.s        # (Part A) Perform matrix multiplication
│   ├── read_matrix.s   # (Part B) Read a matrix from a file
│   ├── relu.s          # (Part A) Apply the ReLU activation function
│   ├── utils.s         # Utility functions
│   └── write_matrix.s  # (Part B) Write a matrix to a file
├── tools               # Helper tools for the project
│   ├── convert.py      # Script to convert matrix files
│   └── venus.jar       # RISC-V simulator
└── unittests           # Unit tests for the project
    ├── assembly        # Generated assembly files from the unit tests
    ├── framework.py    # Testing framework
    └── unittests.py    # Unit tests for Part A and Part B
```

## Part A: Neural Network Primitives

Part A focuses on implementing the fundamental building blocks of a neural network in RISC-V assembly. The following functions need to be implemented:

- `relu`: Applies the Rectified Linear Unit (ReLU) activation function to each element of a vector. If an element is negative, it is set to 0; otherwise, it remains unchanged.
- `argmax`: Finds and returns the index of the largest element in a vector.
- `dot`: Computes the dot product of two vectors.
- `matmul`: Performs matrix multiplication of two matrices.

## Part B: File I/O and Classification

Part B involves handling file operations and implementing the main classification logic. The following functions need to be implemented:

- `read_matrix`: Reads a matrix from a binary file. The file format is `[rows, cols, data...]`.
- `write_matrix`: Writes a matrix to a binary file in the same format as `read_matrix`.
- `classify`: This is the main function that ties everything together. It reads the model's weight matrices (`m0.bin`, `m1.bin`) and an input vector, performs the forward pass of the neural network using the functions from Part A, and writes the output to a specified file.

## How to Run and Test

### Running the Unit Tests

To test your implementation, you can run the provided unit tests using Python. The tests will call your assembly functions and verify their correctness against various test cases.

```bash
python3 unittests/unittests.py
```

### Running the Classifier

To run the full classification program, you will use the Venus RISC-V simulator. The `main.s` file is the entry point for the program. The command-line arguments specify the paths to the model's weight matrices, the input vector, and the output file.

```bash
java -jar tools/venus.jar src/main.s \
    inputs/simple0/bin/m0.bin \
    inputs/simple0/bin/m1.bin \
    inputs/simple0/bin/inputs/input0.bin \
    outputs/my_output.bin
```

### Tools

- `tools/venus.jar`: A RISC-V simulator used to run and debug your assembly code.
- `tools/convert.py`: A Python script to convert matrices between text and binary formats. This is useful for creating your own test cases.
