import synthesijer.rt.*;

import synthesijer.hdl.*;
import synthesijer.hdl.expr.*;

@synthesijerhdl
public class MulTestTop {
    public static int ADDR_WIDTH = 32;
    public static int DATA_WIDTH = 32;

    public static void main(Sting... args)
    {
        /* TopModule */
        HDLModule mulTestTop = new HDLModule("MulTestTop", "clk", "reset");
        HDLPort mem_addr   = mulTestTop.newPort("mem_addr", HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort mem_d      = mulTestTop.newPort("mem_d", HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort mem_we     = mulTestTop.newPort("mem_we", HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort mem_q      = mulTestTop.newPort("mem_q", HDLPort.DIR.IN, HDLPrimitiveType.genVectorType(DATA_WIDTH));

        HDLPort comm_d     = mulTestTop.newPort("comm_d", HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort comm_enq   = mulTestTop.newPort("comm_enq", HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort comm_full  = mulTestTop.newPort("comm_full", HDLPort.DIR.IN, HDLPrimitiveType.genBitType());
        HDLPort comm_q     = mulTestTop.newPort("comm_q", HDLPort.DIR.IN, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort comm_deq   = mulTestTop.newPort("comm_deq", HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort comm_empty = mulTestTop.newPort("comm_empty", HDLPort.DIR.IN, HDLPrimitiveType.genBitType());

        /* MulTestModule */
        HDLModule mulTest = new HDLModule("MulTest", "clk", "reset");
        HDLPort multest_mem_addr_out  = mulTest.newPort("o_mem_addr_out",   HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort multest_mem_d_out     = mulTest.newPort("o_mem_d_out",      HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort multest_mem_we_out    = mulTest.newPort("o_mem_we_out",     HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort multest_mem_q_in      = mulTest.newPort("i_mem_q_in",       HDLPort.DIR.IN,  HDLPrimitiveType.genVectorType(DATA_WIDTH));
        HDLPort multest_mem_q_we      = mulTest.newPort("i_mem_q_we",       HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());

        HDLPort multest_comm_d_out    = mulTest.newPort("o_comm_d_out",     HDLPort.DIR.OUT, HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort multest_comm_enq_out  = mulTest.newPort("o_comm_enq_out",   HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort multest_comm_full_in  = mulTest.newPort("i_comm_full_in ",  HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort multest_comm_full_we  = mulTest.newPort("i_comm_full_we ",  HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort multest_comm_q_in     = mulTest.newPort("i_comm_q_in ",     HDLPort.DIR.IN,  HDLPrimitiveType.genVectorType(ADDR_WIDTH));
        HDLPort multest_comm_q_we     = mulTest.newPort("i_comm_q_we ",     HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort multest_comm_deq_out  = mulTest.newPort("o_comm_deq_out",   HDLPort.DIR.OUT, HDLPrimitiveType.genBitType());
        HDLPort multest_comm_empty_in = mulTest.newPort("i_comm_empty_in ", HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());
        HDLPort multest_comm_empty_we = mulTest.newPort("i_comm_empty_we ", HDLPort.DIR.IN,  HDLPrimitiveType.genBitType());

        /* Instance */
        HDLInstance instanceBeamformerCore = beamformerTop.newModuleInstance(beamformerCore, "beamformercore");
        instanceBeamformerCore.getSignalForPort("clk").setAssign(null, beamformerTop.getSysClk().getSignal());
        instanceBeamformerCore.getSignalForPort("reset").setAssign(null, beamformerTop.getSysReset().getSignal());

        mem_addr.getSignal().setAssign(null, instanceBeamformerCore.getSignalForPort(core_mem_addr_out.getName()));
        mem_d.getSignal().setAssign(null, instanceBeamformerCore.getSignalForPort(core_mem_d_out.getName()));
        mem_we.getSignal().setAssign(null, instanceBeamformerCore.getSignalForPort(core_mem_we_out.getName()));
        instanceBeamformerCore.getSignalForPort(core_mem_q_in.getName()).setAssign(null, mem_q.getSignal());
        instanceBeamformerCore.getSignalForPort(core_mem_q_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);

        comm_d.getSignal().setAssign(null, instanceBeamformerCore.getSignalForPort(core_comm_d_out.getName()));
        comm_enq.getSignal().setAssign(null, instanceBeamformerCore.getSignalForPort(core_comm_enq_out.getName()));
        instanceBeamformerCore.getSignalForPort(core_comm_full_in.getName()).setAssign(null, comm_full.getSignal());
        instanceBeamformerCore.getSignalForPort(core_comm_full_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);
        instanceBeamformerCore.getSignalForPort(core_comm_q_in.getName()).setAssign(null, comm_q.getSignal());
        instanceBeamformerCore.getSignalForPort(core_comm_q_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);
        comm_deq.getSignal().setAssign(null, instanceBeamformerCore.getSignalForPort(core_comm_deq_out.getName()));
        instanceBeamformerCore.getSignalForPort(core_comm_empty_in.getName()).setAssign(null, comm_empty.getSignal());
        instanceBeamformerCore.getSignalForPort(core_comm_empty_we.getName()).setAssign(null, HDLPreDefinedConstant.HIGH);

        /* Generate Verilog Files */
        HDLUtils.generate(mulTestTop, HDLUtils.Verilog);
    }
}
