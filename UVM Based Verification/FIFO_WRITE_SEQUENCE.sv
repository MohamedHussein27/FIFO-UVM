package fifo_write_sequence_pkg;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_write_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(fifo_write_sequence);
        fifo_seq_item seq_item;
        
        // constructor 
        function new(string name = "fifo_write_sequence");
            super.new(name);
        endfunction

        task body;
            repeat(10) begin
                seq_item = fifo_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.rst_n = 1;
                seq_item.data_in = $random;
                seq_item.wr_en = 1;
                seq_item.rd_en = 0;
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage
