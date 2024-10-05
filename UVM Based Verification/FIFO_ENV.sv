package fifo_env_pkg;
    import fifo_seq_item_pkg::*;
    import fifo_reset_sequence_pkg::*;
    import fifo_main_sequence_pkg::*;
    import fifo_sequencer_pkg::*;
    import fifo_agent_pkg::*;
    import fifo_coverage_collector_pkg::*;
    import fifo_scoreboard_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_env extends uvm_env;
        `uvm_component_utils (fifo_env)

        // agent, scoreboard and coverage collector
        fifo_agent agt;
        fifo_scoreboard sb;
        fifo_coverage_collector cov;
    
        // construction
        function new (string name = "fifo_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            agt = fifo_agent::type_id::create("agt",this);            
            sb = fifo_scoreboard::type_id::create("sb", this);
            cov = fifo_coverage_collector::type_id::create("cov", this);
        endfunction

        // connection between agent and scoreboard and between agent and coverage collector
        function void connect_phase (uvm_phase phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cov.cov_export);
        endfunction
    endclass
endpackage