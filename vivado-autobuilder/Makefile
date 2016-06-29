# Copyright (c) 2016 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
### Settings ###
HW_NAME=zed_block_design_wrapper_hw_platform_0
CONSTRAINT_FILE=constras/pin_assign.xdc


### Params ###
HWSPEC_FILE=zed_block_design_wrapper.hdf
PROJECT_DIRECTORY=./
BUILD_SPACE=build_space_project
PROJECT_NAME=$(BUILD_SPACE)
WORKSPACE_SDK=$(PROJECT_NAME).sdk
DEVICE_PARTS=xc7z020clg484-1
DESIGN_NAME=design_1

SETTING_FILE=builder/settings.tcl

VIVADO=vivado
VIVADO_OPTIONS=

.PHONY: all
all: $(SETTING_FILE) build export_hardware generate_fsbl generate_bif generate_bootimage

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
	@if [ ! "$(BLOCK_DESIGN_TCL_FILE)" = "" ]; \
		then echo "set design_bd_tcl_file "\"bd/$(BLOCK_DESIGN_TCL_FILE)\" \
		>> settings.tcl.tmp; \
		fi
	mv settings.tcl.tmp $(SETTING_FILE)
	@echo

.PHONY: build
build:
	@echo "*** BUILD ***"
	$(VIVADO) $(VIVADO_OPTIONS) -mode batch -source ./builder/build.tcl
	@echo

.PHONY: export_hardware
export_hardware:
	@echo "*** Export Hardware ***"
	@echo

.PHONY: generate_fsbl
generate_fsbl:
	@echo "*** Genarate FSBL ***"
	@echo

.PHONY: generate_bif
generate_bif:
	@echo "*** Genarate BIF ***"
	@echo

.PHONY: generate_bootimage
generate_bootimage:
	@echo "*** Genarate Bootimage ***"
	@echo

.PHONY: clean
clean:
	rm -rf $(PROJECT_NAME).*
	rm -rf *.log *.jou
	rm -f $(SETTING_FILE)
	rm -f u-boot.elf

