# Copyright (c) 2016 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
### Settings ###
HW_NAME=zed_block_design_wrapper_hw_platform_0
CONSTRAINT_FILE=constrs/pin_assign.xdc


### Params ###
HWSPEC_FILE=zed_block_design_wrapper.hdf
PROJECT_DIRECTORY=./
BUILD_SPACE=build_space_project
PROJECT_NAME=$(BUILD_SPACE)
WORKSPACE_SDK=$(PROJECT_NAME).sdk
DEVICE_PARTS=xc7z020clg484-1
DESIGN_NAME=design_1

SETTING_FILE=builder/settings.tcl

.PHONY: all
all: $(SETTING_FILE) generate_project synthesis implementation export_hardware \
	generate_fsbl generate_bif generate_bootimage

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

.PHONY: generate_project
generate_project:
	@echo "*** Generate Project ***"
	@echo

.PHONY: synthesis
synthesis:
	@echo "*** Synthesis ***"
	@echo

.PHONY: implementation
implementation:
	@echo "*** Implementation ***"
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

