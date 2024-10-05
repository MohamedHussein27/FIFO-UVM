module fifo_sva(fifo_if.DUT fifoif);

    parameter FIFO_WIDTH = 16;  
    parameter FIFO_DEPTH = 8;

    // properties
    // immediate signals
    always_comb begin
        if(!fifoif.rst_n) begin
            count_aa: assert final(DUT.count == 0);
            wr_ptr_aa: assert final(DUT.wr_ptr == 0);
            rd_ptr_aa: assert final(DUT.rd_ptr == 0);
            full_aa: assert final(fifoif.full == 0);
            empty_aa: assert final(fifoif.empty == 1);
            underflow_aa: assert final(fifoif.underflow == 0);
            almostfull_aa: assert final(fifoif.almostfull == 0);
            almostempty_aa: assert final(fifoif.almostempty == 0);
            wr_ack_aa: assert final(fifoif.wr_ack == 0);
            overflow_aa: assert final(fifoif.overflow == 0); 
        end
        if((DUT.count == FIFO_DEPTH))
            full_a: assert final(fifoif.full == 1);
        if((DUT.count == 0))
            empty_a: assert final(fifoif.empty == 1);
        if((DUT.count == FIFO_DEPTH - 1))
            almostfull_a: assert final(fifoif.almostfull == 1);
        if((DUT.count == 1))
            almostempty_a: assert final(fifoif.almostempty == 1);
    end
    // output flags
    property ack_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) fifoif.wr_en && (DUT.count < FIFO_DEPTH) |=> fifoif.wr_ack ;
    endproperty

    property overflow_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) ((DUT.count == FIFO_DEPTH) && fifoif.wr_en) |=> (fifoif.overflow == 1);
    endproperty

    property underflow_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (fifoif.empty) && (fifoif.rd_en) |=> fifoif.underflow;
    endproperty // here

    // internal signals
    property wr_ptr_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (fifoif.wr_en) && (DUT.count < FIFO_DEPTH) |=> (DUT.wr_ptr == $past(DUT.wr_ptr) + 1'b1);
    endproperty

    property rd_ptr_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (fifoif.rd_en) && (DUT.count != 0) |=> (DUT.rd_ptr == $past(DUT.rd_ptr) + 1'b1);
    endproperty

    property count_write_priority_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (fifoif.wr_en) && (fifoif.rd_en) && (fifoif.empty) |=> (DUT.count == $past(DUT.count) + 1);
    endproperty

    property count_read_priority_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (fifoif.wr_en) && (fifoif.rd_en) && (fifoif.full) |=> (DUT.count == $past(DUT.count) - 1);
    endproperty

    property count_w_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (fifoif.wr_en) && (!fifoif.rd_en) && (!fifoif.full) |=> (DUT.count == $past(DUT.count) + 1);
    endproperty

    property count_r_p;
        @(posedge fifoif.clk) disable iff (fifoif.rst_n == 0) (!fifoif.wr_en) && (fifoif.rd_en) && (!fifoif.empty) |=> (DUT.count == $past(DUT.count) - 1);	
    endproperty

    // Assertions
    ack_a: assert property (ack_p);
    overflow_a: assert property (overflow_p);
    underflow_a: assert property (underflow_p);
    wr_ptr_a: assert property (wr_ptr_p);
    rd_ptr_a: assert property (rd_ptr_p);
    count_write_priority_a: assert property (count_write_priority_p);
    count_read_priority_a: assert property (count_read_priority_p);
    count_w_a: assert property (count_w_p);
    count_r_a: assert property (count_r_p);
    

    // cover
    ack_c: cover property (ack_p);
    overflow_c: cover property (overflow_p);
    underflow_c: cover property (underflow_p);
    wr_ptr_c: cover property (wr_ptr_p);
    rd_ptr_c: cover property (rd_ptr_p);
    count_write_priority_c: cover property (count_write_priority_p);
    count_read_priority_c: cover property (count_read_priority_p);
    count_w_c: cover property (count_w_p);
    count_r_c: cover property (count_r_p);
endmodule