TOPMODULE=userlogic
RTL=userlogic.v $(BFTOP) $(BFMOD) $(BFVMOD)
THREAD=ctrl_thread.py
TEST=testbench.v

USERTEST=--usertest=$(TEST)
ROOTDIR=./PyCoRAM/
MEM=$(ROOTDIR)/mem-incr.hex
MEMIMG=--memimg=$(MEM)
CONFIG=$(ROOTDIR)/default.config
INCLUDE=-I $(ROOTDIR)/include/

include $(ROOTDIR)/base.mk
