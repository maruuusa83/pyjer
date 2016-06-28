# coding:utf-8
DSIZE = 4
RAMSIZE = 1024

CORAM_OFFSET = 0x0000000
DRAM_OFFSET = 0x10000000

iochannel = CoramIoChannel(idx = 0, datawidth = 32)
ram = CoramMemory(idx = 0, datawidth = DSIZE * 8, size = RAMSIZE, length = 1, scattergather = False)
channel = CoramChannel(idx = 0, datawidth = 32, size = 16)

def body():
    # Wait request
    unused_val_1 = iochannel.read()

    # Request processing
    ram.write(CORAM_OFFSET, DRAM_OFFSET, 2) # from DRAM to BlockRAM 4byte * 2
    channel.write(0)

    # Return data
    unused_val_2 = channel.read()
    ram.read(CORAM_OFFSET + 2, DRAM_OFFSET + 2, 1) # from BlockRAM to DRAM 4byte
    iochannel.write(0)

while True:
    body()
