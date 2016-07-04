# Copyright (c) 2016 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
### Settings ###
HW_NAME=zed_block_design_wrapper_hw_platform_0
CONSTRAINT_FILE=constras/pin_assign.xdc

SYNTH_FLOW="Vivado Synthesis 2015"
SYNTH_STRATEGY="Vivado Synthesis Defaults"
IMPL_FLOW="Vivado Implementation 2015"
IMPL_STRATEGY="Vivado Implementation Defaults"


### Params ###
HWSPEC_FILE=zed_block_design_wrapper.hdf
PROJECT_DIRECTORY=./
BUILD_SPACE=build_space_project
PROJECT_NAME=$(BUILD_SPACE)
WORKSPACE_SDK=$(PROJECT_NAME).sdk
DEVICE_PARTS=xc7z020clg484-1
DESIGN_NAME=design_1

SETTING_FILE=builder/settings.tcl

BIF_FILE=$(WORKSPACE_SDK)/fsbl/fsbl.bif
VIVADO=vivado
VIVADO_OPTIONS=
XILINX_SDK=xsdk
XILINX_SDK_OPTIONS=
BOOTGEN=bootgen
BOOTGEN_OPTIONS=
BOOTIMAGE_DIR=$(WORKSPACE_SDK)/fsbl/bootimage
BOOT_BIN=$(BOOTIMAGE_DIR)/BOOT.bin

.PHONY: all
all: $(SETTING_FILE) u-boot.elf build export_hardware generate_fsbl generate_bif generate_bootimage

$(SETTING_FILE):
	@echo "*** Generate settings.tcl ***"
	mkdir -p $(WORKSPACE_SDK)/fsbl
	@echo "set project_directory "\"$(PROJECT_DIRECTORY)\" > settings.tcl.tmp
	@echo "set project_name "\"$(PROJECT_NAME)\" >> settings.tcl.tmp
	@echo "set device_parts "\"$(DEVICE_PARTS)\" >> settings.tcl.tmp
	@echo "set hw_name "\"$(HW_NAME)\" >> settings.tcl.tmp
	@echo "set hwspec_file "\"$(HWSPEC_FILE)\" >> settings.tcl.tmp
	@echo "set design_constraint_file "\"$(CONSTRAINT_FILE)\" >> settings.tcl.tmp
	@echo "set design_name "\"$(DESIGN_NAME)\" >> settings.tcl.tmp
	@echo "set synth_1_flow "\"$(SYNTH_FLOW)\" >> settings.tcl.tmp
	@echo "set synth_1_strategy "\"$(SYNTH_STRATEGY)\" >> settings.tcl.tmp
	@echo "set impl_1_flow "\"$(IMPL_FLOW)\" >> settings.tcl.tmp
	@echo "set impl_1_strategy "\"$(IMPL_STRATEGY)\" >> settings.tcl.tmp
	@if [ ! "$(BLOCK_DESIGN_TCL_FILE)" = "" ]; \
		then echo "set design_bd_tcl_file "\"bd/$(BLOCK_DESIGN_TCL_FILE)\" \
		>> settings.tcl.tmp; \
		fi
	mv settings.tcl.tmp $(SETTING_FILE)
	@echo

u-boot.elf:
	@echo "********** Create u-boot.elf **********"
	mkdir -p work
	cd work; git clone https://github.com/Xilinx/u-boot-xlnx.git
	cd work/u-boot-xlnx/; git checkout -b xilinx-v2015.4 xilinx-v2015.4
	cd work/u-boot-xlnx/; patch -p0 < ../../sdboot.patch
	make -C work/u-boot-xlnx/ zynq_zed_config CROSS_COMPILE=arm-xilinx-linux-gnueabi- ARCH=arm
	make -C work/u-boot-xlnx/ CROSS_COMPILE=arm-xilinx-linux-gnueabi- ARCH=arm
	cp work/u-boot-xlnx/u-boot ./u-boot.elf
	@echo

.PHONY: build
build:
	@echo "*** BUILD ***"
	$(VIVADO) $(VIVADO_OPTIONS) -mode batch -source ./builder/build.tcl
	@echo

.PHONY: export_hardware
export_hardware:
	@echo "*** Export Hardware ***"
	$(VIVADO) $(VIVADO_OPTIONS) -mode batch -source ./builder/hw_export.tcl
	@echo

.PHONY: generate_fsbl
generate_fsbl:
	@echo "*** Genarate FSBL ***"
	$(XILINX_SDK) $(XILINX_SDL_OPTIONS) -batch -source ./builder/build_fsbl.tcl
	@echo

.PHONY: generate_bif
generate_bif:
	@echo "*** Genarate BIF ***"
	@echo the_ROM_image: > fsbl.bif.tmp
	@echo "{" >> fsbl.bif.tmp
	@echo [bootloader]$(WORKSPACE_SDK)/fsbl/Debug/fsbl.elf >> fsbl.bif.tmp
	@echo $(WORKSPACE_SDK)/$(HW_NAME)/$(BIT_FILE) >> fsbl.bif.tmp
	@echo $(U_BOOT) >> fsbl.bif.tmp
	@echo "}" >> fsbl.bif.tmp
	mv fsbl.bif.tmp $(BIF_FILE)
	@echo

.PHONY: generate_bootimage
generate_bootimage:
	@echo "*** Genarate Bootimage ***"
	mkdir -p $(BOOTIMAGE_DIR)
	$(BOOTGEN) $(BOOTGEN_OPTIONS) -image $(BIF_FILE) -o $(BOOT_BIN) -w on 
	@echo

.PHONY: clean
clean:
	rm -rf $(PROJECT_NAME).*
	rm -rf *.log *.jou
	rm -f $(SETTING_FILE)
	rm -rf work/

