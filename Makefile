# Copyright (c) 2016 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php

### Settings ###
TOP=

### Environment Settings ###
SYNTHESIJER_VERSION=20160511
SYNTHESIJER=$(PWD)/synthesijer/synthesijer_$(SYNTHESIJER_VERSION).jar
SYNTHESIJER_LIB=$(PWD)/synthesijer/synthesijer_lib_$(SYNTHESIJER_VERSION)

PYCORAM=$(PWD)/pycoram/PyCoRAM/pycoram
PYCORAM_BUILD_CMD=build
PYCORAM_GENDIR=./pycoram/pycoram_userlogic_v1_00_a
PYCORAM_USERLOGIC_V=$(PYCORAM_GENDIR)/hdl/verilog/pycoram_userlogic.v

ENV_INSTALL_LOG=$(PWD)/env_install.log

CURL=curl
FIND=find

.PHONY: all
all: init synthesijer_build

.PHONY: synthesijer_build
synthesijer_build: build_modules $(TOP:.java=.v)

$(TOP:.java=.v): $(TOP) $(MODULES:.java=.v)
	@echo "*** Synthesijer Top Module ***"
	$(JAVAC) -cp $(SYNTHESIJER):. $(TOP)
	$(JAVA) -cp $(SYNTHESIJER):. $(TOP:.java=)
	@echo

.PHONY: build_modules
build_modules: $(MODULES) $(WRAPPERS)
	@echo "*** Synthesijer Submodules ***"
	$(JAVA) -cp $(SYNTHESIJER) synthesijer.Main --verilog $(MODULES) $(WRAPPERS)
	@echo

.PHONY: build_pycoram
build_pycoram:
	@echo "*** PyCoRAM ***"
	cp ./*.v pycoram/
	$(MAKE) -C pycoram/ BFTOP="$(TOP:.java=.v)" BFMOD="$(MODULES:.java=.v)" BFVMOD="$(DEPEND_MODULES)" $(PYCORAM_BUILD_CMD)
	cat $(PYCORAM_USERLOGIC_V) | $(SED) -e 's/;assign .* = / = /g' | $(SED) -e 's/\([0-9]\+\)parameter/\1, parameter/g' > $(PYCORAM_USERLOGIC_V).tmp
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

.PHONY: clean
clean:
	rm -f env_install.log
	rm -f *_scheduler_board_*
	rm -f $(TOP:.java=.v) $(TOP:.java=.class)
	rm -f $(MODULES:.java=.v)

.PHONY: reset
reset:
	rm -rf pycoram/ synthesijer/
	$(MAKE) -C ./ clean

