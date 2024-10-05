package fifo_scoreboard_pkg;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)
        uvm_analysis_export #(fifo_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
        fifo_seq_item seq_item_sb;

        // parameters
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        // correct and error counter
        int error_count = 0;
        int correct_count = 0;

        // reference outputs
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        
        // internal signals
        int count = 0;
        
        // queue to verify FIFO functionality
        reg [FIFO_WIDTH-1:0] queue_ref[$];

        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        // connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        // run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);
                // compare
                if (seq_item_sb.data_out !== data_out_ref) begin
                    error_count++;
                    $display("error in data out at %0d", error_count);
                    `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                    seq_item_sb.convert2string(), data_out_ref));
                end
                else begin
                    `uvm_info("run_phase", $sformatf("correct fifo out: %s", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        // reference model
        task ref_model (fifo_seq_item seq_item_chk);
            // assigning reference variables
            if(!seq_item_chk.rst_n) begin
                full_ref = 0;
                empty_ref = 1;
                queue_ref.delete();
                underflow_ref = 0;
                almostfull_ref = 0;
                almostempty_ref = 0;
                wr_ack_ref = 0;
                overflow_ref = 0;
                count = 0;
            end
            else begin
                // writing
                if (seq_item_chk.wr_en && count < FIFO_DEPTH) begin
                    queue_ref.push_back(seq_item_chk.data_in); // filling queue
                    wr_ack_ref = 1;
                end
                else begin
                    wr_ack_ref = 0;
                end

                // reading
                if (seq_item_chk.rd_en && count != 0) begin
                    data_out_ref = queue_ref.pop_front(); // evacuating queue
                end

                // sequential flags
                if(count == 0 && seq_item_chk.rd_en) underflow_ref = 1; else underflow_ref = 0;
                if(count == FIFO_DEPTH && seq_item_chk.wr_en) overflow_ref = 1; else overflow_ref = 0; 
                
                // count combinations
                if (({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) && empty_ref)
                    count = count + 1;
                else if (({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) && full_ref)
                    count = count - 1;
                else if (({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b10) && !full_ref)
                    count = count + 1;
                else if (({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b01) && !empty_ref)
                    count = count - 1;
                
                // flags
                if(count == FIFO_DEPTH) full_ref = 1; else full_ref = 0;
                if(count == 0) empty_ref = 1; else empty_ref = 0;      
                if(count == FIFO_DEPTH-1) almostfull_ref = 1; else almostfull_ref = 0;
                if(count == 1) almostempty_ref = 1; else almostempty_ref = 0;
            end
        endtask
        
        // report
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total successful transactions: %0d", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("total failed transactions: %0d", error_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage
