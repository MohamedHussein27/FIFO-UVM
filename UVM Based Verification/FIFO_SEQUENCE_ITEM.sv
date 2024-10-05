package fifo_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class fifo_seq_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_seq_item)

        // fifo constraints
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        bit clk;
        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;


        function new(string name = "fifo_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s data_in = 0b%0b , rst_n = 0b%0b , wr_en = 0b%0b , rd_en = 0b%0b , data_out = 0b%0b , wr_ack = 0b%0b , overflow = 0b%0b , 
            full = 0b%0b , empty = 0b%0b ,  almostfull = 0b%0b , almostempty = 0b%0b , underflow = 0b%0b  ",
            super.convert2string(), data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("%s data_in = 0b%0b , rst_n = 0b%0b , wr_en = 0b%0b , rd_en = 0b%0b",
            super.convert2string(), data_in, rst_n, wr_en, rd_en);
        endfunction


        // constraints
        constraint reset_con {
            rst_n dist {0:/2, 1:/98};  // reset is asserted less 
        }

        constraint wr_en_con {
            wr_en dist {1:=70, 0:=(30)}; // wr_en has probability of 70 to happen
        }

        constraint rd_en_con {
            rd_en dist {1:=30, 0:=(70)}; // rd_en has probability of 30 to happen
        }
    endclass
endpackage