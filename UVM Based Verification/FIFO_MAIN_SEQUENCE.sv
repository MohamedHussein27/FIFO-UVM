package fifo_main_sequence_pkg;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_main_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(fifo_main_sequence);
        fifo_seq_item seq_item;

        function new(string name = "fifo_main_sequence");
            super.new(name);
        endfunction

        task body;
            repeat(1000)begin
                seq_item = fifo_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage