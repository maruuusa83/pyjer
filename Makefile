# Copyright (c) 2016 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php

### Settings ###
TOP=
MODULES=
WRAPPERS=
VERILOG_MODULES=

PYCORAM_TOPRTL=userlogic.v
PYCORAM_TOPMODULE=$(PYCORAM_TOPRTL:.v=)
PYCORAM_THREAD=ctrl_thread.py
PYCORAM_TEST=testbench.v
PYCORAM_DIR=pycoram
PYCORAM_FILES=$(PYCORAM_DIR)/$(PYCORAM_TOPRTL) $(PYCORAM_DIR)/$(PYCORAM_THREAD) $(PYCORAM_DIR)/$(PYCORAM_TEST)

### Environment Settings ###
SYNTHESIJER_VERSION=20160511
SYNTHESIJER=$(PWD)/synthesijer/synthesijer_$(SYNTHESIJER_VERSION).jar
SYNTHESIJER_LIB=$(PWD)/synthesijer/synthesijer_lib_$(SYNTHESIJER_VERSION)

PYCORAM_DIR=$(PWD)/pycoram
PYCORAM=$(PYCORAM_DIR)/PyCoRAM/pycoram
PYCORAM_BUILD_CMD=build
PYCORAM_IP_NAME=pycoram_userlogic_v1_00_a
PYCORAM_GENDIR=$(PYCORAM_DIR)/$(PYCORAM_IP_NAME)
PYCORAM_USERLOGIC_V=$(PYCORAM_GENDIR)/hdl/verilog/pycoram_userlogic.v

VIVADO_AUTOBUILDER=./vivado-autobuilder
VIVADO_AUTOBUILDER_IPS=$(VIVADO_AUTOBUILDER)/ips

ENV_INSTALL_LOG=$(PWD)/env_install.log

### Command Settings ###
JAVA=java
JAVAC=javac

CURL=curl
FIND=find
SED=sed

.SUFFIXES: .java .v

.PHONY: all
all: init build_ip

.PHONY: build_ip
build_ip: synthesijer_build pycoram_build vivado_build

.PHONY:synthesijer_build
synthesijer_build: $(MODULES:.java=.v) $(TOP:.java=.v)

.PHONY: pycoram_build
pycoram_build: $(PYCORAM_USERLOGIC_V)

.PHONY: vivado_build
vivado_build:
	@echo "*** Vivado ***"
	cp -r $(PYCORAM_GENDIR)/ $(VIVADO_AUTOBUILDER_IPS)
	$(MAKE) -C $(VIVADO_AUTOBUILDER)
	@echo

$(TOP:.java=.v): $(TOP) $(MODULES:.java=.v)
	@echo "*** Synthesijer Top Module ***"
	$(JAVAC) -cp $(SYNTHESIJER):. $(TOP)
	$(JAVA) -cp $(SYNTHESIJER):. $(TOP:.java=)
	@echo

.java.v:
	$(JAVA) -cp $(SYNTHESIJER) synthesijer.Main --verilog $<

$(PYCORAM_USERLOGIC_V): $(MODULES:.java=.v) $(TOP:.java=.v) $(PYCORAM_FILES)
	@echo "*** PyCoRAM ***"
	cp ./*.v pycoram/
	$(MAKE) -C pycoram/ \
		TOPMODULE="$(PYCORAM_TOPMODULE)" \
		RTL="$(PYCORAM_TOPRTL) $(TOP:.java=.v) $(MODULES:.java=.v) $(DEPEND_MODULES)" \
		THREAD="$(PYCORAM_THREAD)" \
		TEST="$(PYCORAM_TEST)" \
		$(PYCORAM_BUILD_CMD)
	cat $(PYCORAM_USERLOGIC_V) \
		| $(SED) -e 's/;assign .* = / = /g' \
		| $(SED) -e 's/\([0-9]\+\)parameter/\1, parameter/g' \
		> $(PYCORAM_USERLOGIC_V).tmp
	mv $(PYCORAM_USERLOGIC_V).tmp $(PYCORAM_USERLOGIC_V)
	@echo

.PHONY: init
init:
	@$(MAKE) -C ./ construct_env

.PHONY: construct_env
construct_env:
	$(if $(shell $(FIND) -name env_install.log),, $(touch_install_log))
	$(if $(shell $(FIND) -name synthesijer_$(SYNTHESIJER_VERSION).jar),, $(install_synthesijer))
	$(if $(shell $(FIND) -name synthesijer_lib_$(SYNTHESIJER_VERSION).zip),, $(install_synthesijer_lib))
	$(if $(shell $(FIND) -name pycoram.py),, $(install_pycoram)) 

define install_synthesijer
	@echo Getting Synthesijer...
	@mkdir synthesijer
	@cd synthesijer; $(CURL) -O http://synthesijer.github.io/web/dl/$(SYNTHESIJER_VERSION)/synthesijer_$(SYNTHESIJER_VERSION).jar >> $(ENV_INSTALL_LOG) 2>&1
	@echo Done.
endef

define install_synthesijer_lib
	@echo Getting Synthesijer Library...
	@cd synthesijer; $(CURL) -O http://synthesijer.github.io/web/dl/$(SYNTHESIJER_VERSION)/synthesijer_lib_$(SYNTHESIJER_VERSION).zip >> $(ENV_INSTALL_LOG) 2>&1
	@cd synthesijer; unzip $(SYNTHESIJER_LIB).zip >> $(ENV_INSTALL_LOG) 2>&1
	@echo Done.
endef

define install_pycoram
	@echo Getting PyCoRAM...
	@mkdir -p pycoram
	@cd pycoram; git clone https://github.com/shtaxxx/PyCoRAM.git >> $(ENV_INSTALL_LOG) 2>&1
	@cd pycoram/PyCoRAM; git clone https://github.com/shtaxxx/Pyverilog.git >> $(ENV_INSTALL_LOG) 2>&1
	@cd pycoram/PyCoRAM/pycoram; ln -s ../Pyverilog/pyverilog >> $(ENV_INSTALL_LOG) 2>&1
	@echo Done.
endef

define touch_install_log
	@touch $(ENV_INSTALL_LOG)
endef

.PHONY: test
test:
	@echo "Prepairing..."
	@cp test/*.java ./
	@cp test/pycoram/* ./pycoram/
	@mkdir -p vivado-autobuilder/constras
	@cp test/vivado-autobuilder/constras/* ./vivado-autobuilder/constras/
	@echo "Start Build Test"
	@$(MAKE) -C ./ \
		TOP="SumTestTop.java" \
		MODULES="SumTest.java Dummy.java" \
		all
	@echo
	@echo "Cleanup"
	@$(MAKE) -C ./ \
		TOP="SumTestTop.java" \
		MODULES="SumTest.java Dummy.java" \
		clean
	@$(RM) SumTestTop.java SumTest.java Dummy.java
	@cd pycoram; $(RM) ctrl_thread.py testbench.v userlogic.v
	@$(RM) $(VIVADO_AUTOBUILDER_IPS)/$(PYVCORAM_IP_NAME)
	@$(RM) ./vivado-autobuilder/constras/*
	@echo "Done."

.PHONY: clean
clean:
	$(RM) -f env_install.log
	$(RM) -f *_scheduler_board_*
	$(RM) -f $(TOP:.java=.v) $(TOP:.java=.class)
	$(RM) -f $(MODULES:.java=.v) $(MODULES:.java=.class)
	cd pycoram; $(RM) -f $(TOP:.java=.v) $(MODULES:.java=.v) $(VERILOG_MODULES)
	$(RM) -rf $(PYCORAM_GENDIR)
	$(RM) -rf $(VIVADO_AUTOBUILDER_IPS)/
	$(MAKE) -C pycoram/ clean
	$(MAKE) -C vivado-autobuilder/ clean

.PHONY: reset
reset:
	$(MAKE) -C ./ clean TOP=$(TOP) MODULES=$(MODULES)
	rm -rf pycoram/PyCoRAM/ synthesijer/

