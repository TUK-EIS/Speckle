** SPEC2017 Port **

   This branch is a WIP and changes Speckle's usage model. 

   Key changes:
   - Host and Target configurations are provided.
   - A target SPEC2017 build is done to generate target binaries
   - A host SPEC2017 runsetup is done to complete generate a working directories
     for each benchmark.
   - The host directory is copyied to the overlay directory, host binaries are replaced
     with target binaries
   - A run script(run.sh) is generated that executes all the inputs for the benchmark

**Purpose**

   The goal of this repository is to help you compile and run SPEC. This will
   NOT verify the output of SPEC.


**Purpose of this fork**
   The run scripts are adapted to be directly protable to the FPGA prototype without needing to change anything.
   Additionally, a script to run all benchmarks consecutively has been added. 

**Requirements**

   - you must have your own copy of SPEC CPU2017 
   - you must have built the tools in SPEC CPU2017


**Details**

   We will compile the binaries "in vivo", calling into the actual SPEC CPU2017
   directory. Once completed, the binaries are copied into this directory (./build/overlay). 
   
   The reasoning is that compiling the benchmarks is complicated and difficult (so
   why redo that effort?), but we want better control over executing the binaries.  Of
   course, we are forgoing the validation and results building infrastructure of
   SPEC. 


**Setup**

   - set the $SPEC_DIR variable in your environment to point to your copy of CPU2017
   - modify Speckle/riscv.cfg as desired. It will get copied over to
     $SPEC_DIR/configs when compiling the benchmarks. Important: do not modify the label!
   - modify the BENCHMARKS variable in gen_binaries.sh as required to set which
     benchmarks you would like to compile and run.


**To compile binaries**

        ./gen_binaries.sh --compile --suite intspeed/intbase --input ref/test

   You only need to compile SPEC once for a given SPEC input ("test", "train",
   "ref"). 


**To run binaries with metrics**
In addition to directly running the benchmarks, there are also suite-specific
scripts that collect performance metrics and configure tests. These will be
available in build/overlay/SUITE/INPUT. To run (for example) intspeed for the perl benchmark with
one thread:

    ./intspeed.sh 600.perlbench_s --threads 1

Three outputs will be available in ~/outputs:
   - BENCHNAME.out: stdout for the benchmark
   - BENCHNAME.err: stderr for the benchmark
   - BENCHNAME.csv: csv-formatted metrics




