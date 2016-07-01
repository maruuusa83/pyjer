PyJer
=====

A Framework for Prototyping of IoT Devices
with High Level Synthesis Tools and SoC  

Copyright (c) 2016 Daichi Teruya  
Released under the MIT license  
[http://opensource.org/licenses/mit-license.php]

## Requirement
 * Java SE8
 * Python 3.x
 * Jinjer2
 * Vivado v2015.4
 * Xilinx SDK v2015.4

## HOW TO USE
### Initialize
First, run next command to construct environment.
``` bash
$ make init
```

If necessary, run `make test` command to check wherher
PyJer will work well.

### Develop your HW
Place your codes as shown below:

 * Synthesijer codes: under the project root
 * PyCoRAM codes: under `pycoram` directory
 * `pin_assing.xdc`: under `vivado-autobuilder/constras` directory

**Example:**  
The sample project in `test` directory will be placed as next:
```
/ -- synthesijer/
  |- pycoram/
  |  |- ctrl_thread.py
  |  |- testbench.v
  |  |- userlogic.v
  |- vivado-autobuilder/
  |  |- constras/
  |     |- pin_assign.xdc
  |- SumTestTop.java
  |- SumTest.java
  |- Dummy.java
```

### Synthesis your HW
Firstly, set some parameters of top of `Makefile` which is in the project root.

 * TOP : File name of a top module for Synthesijer
 * MODULES : List of file names of Synthesijer modules
 * WRAPPERS : List of file names of Synthesijer verilog wrappers
 * VERILOG\_MODULES : List of file names of Verilog modules which is used by Synthesijer

**Example:**  
``` make
TOP=SumTestTop.java
MODULES=SumTest.java Dummy.java
WRAPPERS=
VERILOG_MODULES=
```

When you name files for PyCoRAM as same as `test/pycoram` files, PyCoRAM settings is
unnecessary.
If necessary, you can rewrite macro definitions about PyCoRAM.


After that, run `make all` command. Make will generate `BOOT.bin` into `vivado-autobuilder/build\_space\_project.sdk/fsbl/bootimage`.

(If you want to synthesize only Java, you can use `synthesijer_build` command.)

