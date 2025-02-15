# Testbenches for Mersenne Prime factoring HDL

This directory contains the testbenches for the Mersenne prime factoring HDL. It uses [Cocotb](https://www.cocotb.org/) to run all the tests, which are split up individually per component. Since the files can get large, eventually I want to add functionality to include or exclude the generated .fst files through the commands, and add different categories of tests for different things that change. 

## Structure

Since I wasn't a fan of re-running every test every time I changed something, these tests are broken up into directories for every component. Each directory has its own test code, including Makefile, Python, and tb.v code.<br/>
The [Makefile](Makefile) in this directory has the code for making this all work, and [common.mk](common.mk) has some common options for every test being run (simulator being used, HDL used, etc.). Each directory contains its own Makefile specifying component specific options. This includes the Verilog files being used, and the source directory, to eventually segment the project into folders. <br/>
The [top](top/) directory contains the code for testing the uppermost layer of the project.

## Running

To run the whole suite of tests:
```
make -B -j$(nproc)
```
The `-j` flag is to run multiple tests in parallel, which greatly improves speed.

To run just one test:
```
make -B [Test (such as full)]
```

## Viewing results

The success of the tests should be visible in the command line, but if .fst output is enabled, you can view them with
```
gtkwave tb.fst
```
