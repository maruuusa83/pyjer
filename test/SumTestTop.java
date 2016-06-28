import synthesijer.rt.*;

import synthesijer.hdl.*;
import synthesijer.hdl.expr.*;

@synthesijerhdl
public class SumTestTop {
    public static int ADDR_WIDTH = 32;
    public static int DATA_WIDTH = 32;

    public static void main(Sting... args)
    {
        /* TopModule */
        HDLModule sumTestTop = new HDLModule("SumTestTop", "clk", "reset");
        HDLPort mem_addr   = sumTestTop.newPort("mem_addr", HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort mem_d      = sumTestTop.newPort("mem_d", HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort mem_we     = sumTestTop.newPort("mem_we", HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort mem_q      = sumTestTop.newPort("mem_q", HDLPort.DIR.IN, HDLPrimitiveType.genVectorType(DATA_WIDTH));

        HDLPort comm_d     = sumTestTop.newPort("comm_d", HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort comm_enq   = sumTestTop.newPort("comm_enq", HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort comm_full  = sumTestTop.newPort("comm_full", HDLPort.DIR.IN, HDLPrimitiveType.genBitType());
        HDLPort comm_q     = sumTestTop.newPort("comm_q", HDLPort.DIR.IN, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort comm_deq   = sumTestTop.newPort("comm_deq", HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort comm_empty = sumTestTop.newPort("comm_empty", HDLPort.DIR.IN, HDLPrimitiveType.genBitType());

        /* SumTestModule */
        HDLModule sumTest = new HDLModule("SumTest", "clk", "reset");
        HDLPort sumtest_mem_addr_out  = sumTest.newPort("o_mem_addr_out",   HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort sumtest_mem_d_out     = sumTest.newPort("o_mem_d_out",      HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort sumtest_mem_we_out    = sumTest.newPort("o_mem_we_out",     HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort sumtest_mem_q_in      = sumTest.newPort("i_mem_q_in",       HDLPort.DIR.IN,  HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort sumtest_mem_q_we      = sumTest.newPort("i_mem_q_we",       HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());

        HDLPort sumtest_comm_d_out    = sumTest.newPort("o_comm_d_out",     HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort sumtest_comm_enq_out  = sumTest.newPort("o_comm_enq_out",   HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort sumtest_comm_full_in  = sumTest.newPort("i_comm_full_in ",  HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort sumtest_comm_full_we  = sumTest.newPort("i_comm_full_we ",  HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort sumtest_comm_q_in     = sumTest.newPort("i_comm_q_in ",     HDLPort.DIR.IN,  HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort sumtest_comm_q_we     = sumTest.newPort("i_comm_q_we ",     HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort sumtest_comm_deq_out  = sumTest.newPort("o_comm_deq_out",   HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort sumtest_comm_empty_in = sumTest.newPort("i_comm_empty_in ", HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort sumtest_comm_empty_we = sumTest.newPort("i_comm_empty_we ", HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());

        /* Instance */
        HDLInstance instanceSumTest = sumTest.newModuleInstance(sumTest, "sumtest");
        instanceSumTest.getSignalForPort("clk").setAssign(null, sumTest.getSysClk().getSignal());
        instanceSumTest.getSignalForPort("reset").setAssign(null, sumTest.getSysReset().getSignal());

        mem_addr.getSignal().setAssign(null, instanceSumTest.getSignalForPort(core_mem_addr_out.getName()));
        mem_d.getSignal().setAssign(null, instanceSumTest.getSignalForPort(core_mem_d_out.getName()));
        mem_we.getSignal().setAssign(null, instanceSumTest.getSignalForPort(core_mem_we_out.getName()));
        instanceSumTest.getSignalForPort(core_mem_q_in.getName()).setAssign(null, mem_q.getSignal());
        instanceSumTest.getSignalForPort(core_mem_q_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);

        comm_d.getSignal().setAssign(null, instanceSumTest.getSignalForPort(core_comm_d_out.getName()));
        comm_enq.getSignal().setAssign(null, instanceSumTest.getSignalForPort(core_comm_enq_out.getName()));
        instanceSumTest.getSignalForPort(core_comm_full_in.getName()).setAssign(null, comm_full.getSignal());
        instanceSumTest.getSignalForPort(core_comm_full_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);
        instanceSumTest.getSignalForPort(core_comm_q_in.getName()).setAssign(null, comm_q.getSignal());
        instanceSumTest.getSignalForPort(core_comm_q_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);
        comm_deq.getSignal().setAssign(null, instanceSumTest.getSignalForPort(core_comm_deq_out.getName()));
        instanceSumTest.getSignalForPort(core_comm_empty_in.getName()).setAssign(null, comm_empty.getSignal());
        instanceSumTest.getSignalForPort(core_comm_empty_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);

        /* Generate Verilog Files */
        HDLUtils.generate(sumTestTop, HDLUtils.Verilog);
    }
}

