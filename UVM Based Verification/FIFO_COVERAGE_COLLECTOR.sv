package fifo_coverage_collector_pkg;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_coverage_collector extends uvm_component;
        `uvm_component_utils(fifo_coverage_collector)
        uvm_analysis_export #(fifo_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;

        fifo_seq_item fifo_item_cov;


        // cover group
        covergroup FIFO_Group; // all crosses will be with read enable and write enable and each one of the output signals
            // cover points
            cp_wr_en: coverpoint fifo_item_cov.wr_en;
            cp_rd_en: coverpoint fifo_item_cov.rd_en;
            cp_ack: coverpoint fifo_item_cov.wr_ack;
            cp_overflow: coverpoint fifo_item_cov.overflow;
            cp_full: coverpoint fifo_item_cov.full;
            cp_empty: coverpoint fifo_item_cov.empty;
            cp_almostfull: coverpoint fifo_item_cov.almostfull;
            cp_almostempty: coverpoint fifo_item_cov.almostempty; 
            cp_underflow: coverpoint fifo_item_cov.underflow;
            // cross coverage
            wr_ack_C: cross cp_wr_en, cp_rd_en, cp_ack{
                illegal_bins zero_zero_one = binsof(cp_wr_en) intersect {0} && binsof(cp_ack) intersect {1}; 
            } // cross coverage for wr_ack, note that a wr_ack can't be done if the wr_en is zero so i made this case illegal
            overflow_C: cross cp_wr_en, cp_rd_en, cp_overflow{
                illegal_bins zero_w_one = binsof(cp_wr_en) intersect {0} && binsof(cp_overflow) intersect {1}; 
            } // cross coverage for overflow, note that an overflow can't be done if there is no wr_en, so i made it illegal
            full_C: cross cp_wr_en, cp_rd_en, cp_full{
                illegal_bins one_r_one = binsof(cp_rd_en) intersect {1} && binsof(cp_full) intersect {1}; 
            } // cross coverage for full, note that a full signal can't be riased if there is read process, so i made it illegal
            empty_C: cross cp_wr_en, cp_rd_en, cp_empty; // cross coverage for empty
            almostfull_C: cross cp_wr_en, cp_rd_en, cp_almostfull; // cross coverage for almostfull signal
            almostempty_C: cross cp_wr_en, cp_rd_en, cp_almostempty; // cross coverage for almostempty signal
            underflow_C: cross cp_wr_en, cp_rd_en, cp_underflow{
                illegal_bins zero_r_one = binsof(cp_rd_en) intersect {0} && binsof(cp_underflow) intersect {1};
            } // cross coverage for underflow signal, note that an underflow can't be done if no read operation occurs, so i made it illegal
        endgroup

        function new (string name = "fifo_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
            FIFO_Group = new;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(fifo_item_cov);        
                FIFO_Group.sample();
            end
        endtask
    endclass
endpackage
