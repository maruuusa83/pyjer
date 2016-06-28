`include "pycoram.v"

`define THREAD_NAME "ctrl_thread"

module userlogic #  
  (
   parameter W_A = 13,
   parameter W_D = 32,
   parameter W_COMM_A = 4
   )
  (
   input CLK,
   input RST
   );

  wire [W_A-1:0] mem_addr;
  wire [W_D-1:0] mem_d;
  wire           mem_we;
  wire [W_D-1:0] mem_q;
  
  wire [W_D-1:0] comm_d;
  wire           comm_enq;
  wire           comm_full;
  wire [W_D-1:0] comm_q;
  wire           comm_deq;
  wire           comm_empty;
  
  SumTestTop
  sumTestTop
  (.clk(CLK),
   .reset(RST),
   .mem_addr(mem_addr),
   .mem_d(mem_d),
   .mem_we(mem_we),
   .mem_q(mem_q),
   .comm_d(comm_d),
   .comm_enq(comm_enq),
   .comm_full(comm_full),
   .comm_q(comm_q),
   .comm_deq(comm_deq),
   .comm_empty(comm_empty)
  );


  CoramMemory1P
  #(
    .CORAM_THREAD_NAME(`THREAD_NAME),
    .CORAM_ID(0),
    .CORAM_SUB_ID(0),
    .CORAM_ADDR_LEN(W_A),
    .CORAM_DATA_WIDTH(W_D)
    )
  inst_data_memory
  (.CLK(CLK),
   .ADDR(mem_addr),
   .D(mem_d),
   .WE(mem_we),
   .Q(mem_q)
   );

  CoramChannel
  #(
    .CORAM_THREAD_NAME(`THREAD_NAME),
    .CORAM_ID(0),
    .CORAM_ADDR_LEN(W_COMM_A),
    .CORAM_DATA_WIDTH(W_D)
    )
  inst_comm_channel
  (.CLK(CLK),
   .RST(RST),
   .D(comm_d),
   .ENQ(comm_enq),
   .FULL(comm_full),
   .Q(comm_q),
   .DEQ(comm_deq),
   .EMPTY(comm_empty)
   );

endmodule
  
