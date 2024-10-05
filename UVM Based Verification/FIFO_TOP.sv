import fifo_test_pkg::*;
import fifo_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module fifo_top();
    bit clk;

    initial begin
        forever #10 clk = ~clk;
    end

    fifo_if fifoif (clk);
    fifo DUT (fifoif);

    // binding assertions
    bind fifo fifo_sva fifo_assertions (fifoif);
    // setting the virtual interface to be accessible by the test
    initial begin
        uvm_config_db #(virtual fifo_if)::set(null, "uvm_test_top", "fifo_V", fifoif);
        run_test ("fifo_test");
    end
endmodule