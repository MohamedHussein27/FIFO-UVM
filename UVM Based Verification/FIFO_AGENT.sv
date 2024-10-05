package fifo_agent_pkg;
    import fifo_config_obj_pkg::*;
    import fifo_driver_pkg::*;
    import fifo_monitor_pkg::*;
    import fifo_seq_item_pkg::*;
    import fifo_reset_sequence_pkg::*;
    import fifo_main_sequence_pkg::*;
    import fifo_sequencer_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent)

        fifo_config_obj fifo_cfg; // configuration object
        fifo_driver drv; // driver
        fifo_monitor mon; // monitor
        fifo_sequencer sqr; // sequencer
        
        uvm_analysis_port #(fifo_seq_item) agt_ap; // will be used to connect scoreboard and coverage collector

        function new (string name = "fifo_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(fifo_config_obj)::get(this,"","CFG", fifo_cfg)) begin
                    `uvm_fatal("build_phase","agent error");
            end
            // creation
            drv = fifo_driver::type_id::create("driver", this);
            mon = fifo_monitor::type_id::create("mon", this);
            sqr = fifo_sequencer::type_id::create("sqr", this);
            agt_ap = new("agt_ap", this); // connection point
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.fifo_vif = fifo_cfg.fifo_vif;
            mon.fifo_vif = fifo_cfg.fifo_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap); // connect monitor share point with agent share point so the monitor will be able to get data from the scoreboard and the cov collector
        endfunction
    endclass
endpackage