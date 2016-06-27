import synthesijer.rt.*;
import synthesijer.hdl.*;

@synthesijerhdl
public class MulTest
{
    public int o_mem_addr;
    public int o_mem_d;
    public boolean o_mem_we;
    public int i_mem_q;

    public int o_comm_d;
    public boolean o_comm_enq;
    public boolean i_comm_full;
    public int i_comm_q;
    public boolean o_comm_deq;
    public boolean i_comm_empty;

    @auto
    public void multest()
    {
        while (1){
            while (i_comm_empty);
            while (!i_comm_empty){
                o_comm_deq = true;
                for (int j = 0; j < 1; j++);
                o_comm_deq = false;
            }

            o_mem_addr = 0x0000;
            for (int i = 0; i < 1; i++);
            a = i_mem_q;
            o_mem_addr = 0x0001;
            for (int i = 0; i < 1; i++);
            b = i_mem_q;

            result = a + b;

            o_mem_addr = 0x002;
            o_mem_d = result;
            o_mem_we = true;
            for (int j = 0; j < 1; j++);
            o_mem_we = false;
        }
    }
}

