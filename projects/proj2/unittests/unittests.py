from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    def test_minus_one(self):
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", -1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()
        

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_with_zeros(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 0, 0, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 0, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_one_element(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([-99])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_empty_array(self):
        t = AssemblyTest(self, "relu.s")        
        array0 = t.array([])        
        t.input_array("a0", array0)        
        t.input_scalar("a1", len(array0))        
        t.call("relu")        
        t.execute(78)

    def test_zero_length(self):
        t = AssemblyTest(self, "relu.s")        
        array0 = t.array([1,2,3])        
        t.input_array("a0", array0)        
        t.input_scalar("a1", 0)        
        t.call("relu")        
        t.execute(78)

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 8)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_first_index_largest(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, 3, -5, -6, 3, -8, -9])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 2)
        t.execute()

    def test_with_zeros(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 0, 0])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 2)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_one_element(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-111])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_empty_array(self):
        t = AssemblyTest(self, "argmax.s")
        array0 = t.array([])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("argmax")
        t.execute(77)

    def test_zero_length(self):
        t = AssemblyTest(self, "argmax.s")
        array0 = t.array([1,2,3])
        t.input_array("a0", array0)
        t.input_scalar("a1", 0)
        t.call("argmax")
        t.execute(77)

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 1*1 + 2*2 + 3*3 + 4*4 + 5*5 + 6*6 + 7*7 + 8*8 + 9*9)
        t.execute()

    def test_stride(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 1*1 + 2*3 + 3*5)
        t.execute()

    def test_mix(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, -2, -3, -4, 0, 1, 0])
        array1 = t.array([1, 2, 3, -4, 0, 0, 1])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 1*1 + -2*2 + -3*3 + -4*-4)
        t.execute()

    def test_zero_length(self):
        t = AssemblyTest(self, "dot.s")
        array0 = t.array([1, -2, -3, -4, 0, 1, 0])
        array1 = t.array([1, 2, 3, -4, 0, 0, 1])
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        t.call("dot")
        t.execute(75)

    def test_v0_zero_stride(self):
        t = AssemblyTest(self, "dot.s")
        array0 = t.array([1, -2, -3, -4, 0, 1, 0])
        array1 = t.array([1, 2, 3, -4, 0, 0, 1])
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 1)
        t.call("dot")
        t.execute(76)

    def test_v1_zero_stride(self):
        t = AssemblyTest(self, "dot.s")
        array0 = t.array([1, -2, -3, -4, 0, 1, 0])
        array1 = t.array([1, 2, 3, -4, 0, 0, 1])
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 0)
        t.call("dot")
        t.execute(76)

    def test_v0_v1_zero_stride(self):
        t = AssemblyTest(self, "dot.s")
        array0 = t.array([1, -2, -3, -4, 0, 1, 0])
        array1 = t.array([1, 2, 3, -4, 0, 0, 1])
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 0)
        t.call("dot")
        t.execute(76)

    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)
        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)        
        # load address of output array
        t.input_array("a6", array_out)

        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)

        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )

    def test_non_square(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6], 3, 2,
            [1, 2, 3, 4, 5, 6], 2, 3,
            [1*1+2*4, 1*2+2*5, 1*3+2*6, 3*1+4*4, 3*2+4*5, 3*3+4*6, 5*1+6*4, 5*2+6*5, 5*3+6*6]
        )

    def test_row_col(self):
        self.do_matmul(
            [1, 2, 3], 3, 1,
            [1, 2, 3], 1, 3,
            [1, 2, 3, 2*1, 2*2, 2*3, 3*1, 3*2, 3*3]
        )

    def test_single_element_m0(self):
        self.do_matmul(
            [-1], 1, 1,
            [1, 2, 3], 1, 3,
            [-1, -2, -3]
        )

    def test_single_element_m1(self):
        self.do_matmul(
            [1, 2, 3], 3, 1,
            [-10], 1, 1,
            [-10, -20, -30]
        )

    def test_unity_m0(self):
        self.do_matmul(
            [1, 0, 0, 0, 1, 0, 0, 0, 1], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9]
        )

    def test_unity_m1(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 0, 0, 0, 1, 0, 0, 0, 1], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9]
        )

    def test_m0_neg_rows_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], -3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 72
        )

    def test_m0_neg_cols_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, -3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 72
        )

    def test_m0_zero_rows_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 0, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 72
        )

    def test_m0_zero_cols_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 0,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 72
        )

    def test_m1_neg_rows_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], -3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 73
        )

    def test_m1_neg_cols_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, -3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 73
        )

    def test_m1_zero_rows_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 0, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 73
        )

    def test_m1_zero_cols_num(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 0,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 73
        )

    def test_mismatched_dims_m0(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 2,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 74
        )

    def test_mismatched_dims_m1(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 2, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150], 74
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    def do_read_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", "inputs/test_read_matrix/test_input.bin")

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        t.check_array(rows, [3])
        t.check_array(cols, [3])
        t.check_array_pointer("a0", [1, 2, 3, 4, 5, 6, 7, 8, 9])

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.do_read_matrix()

    def test_fail_malloc(self):
        self.do_read_matrix("malloc", 88)

    def test_fail_fopen(self):
        self.do_read_matrix("fopen", 90)

    def test_fail_fread(self):
        self.do_read_matrix("fread", 91)

    def test_fail_fclose(self):
        self.do_read_matrix("fclose", 92)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    def do_write_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")
        outfile = "outputs/test_write_matrix/student.bin"
        # load output file name into a0 register
        t.input_write_filename("a0", outfile)
        # load input array and other arguments
        matrix = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.input_array("a1", matrix)
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 3)
        # call `write_matrix` function
        t.call("write_matrix")
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        # compare the output file against the reference
        if code == 0:
            t.check_file_output(outfile, "outputs/test_write_matrix/reference.bin")

    def test_simple(self):
        self.do_write_matrix()

    def test_fail_fopen(self):
        self.do_write_matrix("fopen", 93)

    def test_fail_fwrite(self):
        self.do_write_matrix("fwrite", 94)

    def test_fail_fclose(self):
        self.do_write_matrix("fclose", 95)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        reffile = "outputs/test_basic_main/simple0/bin/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 2)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("2\n")

    def test_simple0_input1(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student1.bin"
        reffile = "outputs/test_basic_main/simple0/bin/reference1.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input1.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 2)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("2\n")

    def test_simple0_input2(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student2.bin"
        reffile = "outputs/test_basic_main/simple0/bin/reference2.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input2.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 2)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("2\n")

    def test_simple1_input0(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple1/bin/student0.bin"
        reffile = "outputs/test_basic_main/simple1/bin/reference0.bin"
        args = ["inputs/simple1/bin/m0.bin", "inputs/simple1/bin/m1.bin",
                "inputs/simple1/bin/inputs/input0.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 1)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("1\n")

    def test_simple1_input1(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple1/bin/student1.bin"
        reffile = "outputs/test_basic_main/simple1/bin/reference1.bin"
        args = ["inputs/simple1/bin/m0.bin", "inputs/simple1/bin/m1.bin",
                "inputs/simple1/bin/inputs/input1.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 4)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("4\n")

    def test_simple1_input2(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple1/bin/student2.bin"
        reffile = "outputs/test_basic_main/simple1/bin/reference2.bin"
        args = ["inputs/simple1/bin/m0.bin", "inputs/simple1/bin/m1.bin",
                "inputs/simple1/bin/inputs/input2.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 1)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("1\n")

    def test_simple2_input0(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple2/bin/student0.bin"
        reffile = "outputs/test_basic_main/simple2/bin/reference0.bin"
        args = ["inputs/simple2/bin/m0.bin", "inputs/simple2/bin/m1.bin",
                "inputs/simple2/bin/inputs/input0.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 7)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("7\n")

    def test_simple2_input1(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple2/bin/student1.bin"
        reffile = "outputs/test_basic_main/simple2/bin/reference1.bin"
        args = ["inputs/simple2/bin/m0.bin", "inputs/simple2/bin/m1.bin",
                "inputs/simple2/bin/inputs/input1.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 4)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("4\n")

    def test_simple2_input2(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple2/bin/student2.bin"
        reffile = "outputs/test_basic_main/simple2/bin/reference2.bin"
        args = ["inputs/simple2/bin/m0.bin", "inputs/simple2/bin/m1.bin",
                "inputs/simple2/bin/inputs/input2.bin", outfile]
        # allow print_classification
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 10)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("10\n")

    def test_simple0_input0_no_stdout0(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        reffile = "outputs/test_basic_main/simple0/bin/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # disallow print_classification
        t.input_scalar("a2", 1)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 2)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("")

    def test_simple0_input0_no_stdout1(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        reffile = "outputs/test_basic_main/simple0/bin/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # disallow print_classification
        t.input_scalar("a2", -1)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args)
        # check classification output
        t.check_scalar("a0", 2)
        # compare the output file
        t.check_file_output(outfile, reffile)
        # compare the classification output with `check_stdout`
        t.check_stdout("")

    def test_simple0_input0_no_m0(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        args = ["inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, code=89)

    def test_simple0_input0_no_m1(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        args = ["inputs/simple0/bin/m0.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, code=89)

    def test_simple0_input0_no_input(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin", outfile]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, code=89)

    def test_simple0_input0_no_output(self):
        t = self.make_test()
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m0.bin",
                "inputs/simple0/bin/inputs/input0.bin"]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, code=89)

    def test_simple0_input0_two_args(self):
        t = self.make_test()
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m0.bin"]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, code=89)

    def test_simple0_input0_no_args(self):
        t = self.make_test()
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=None, code=89)

    def test_simple0_input0_five_args(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, code=89)

    def test_simple0_input0_fail_malloc(self):
        t = self.make_test()
        outfile = "outputs/test_basic_main/simple0/bin/student0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", outfile]
        # disallow print_classification
        t.input_scalar("a2", 99)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus        
        t.execute(args=args, fail="malloc", code=88)

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


class TestMain(TestCase):

    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin", f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"
        t = AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args, verbose=False)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
        self.run_main("inputs/simple1/bin", "1", "1")
