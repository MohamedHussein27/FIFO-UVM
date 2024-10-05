package fifo_test_pkg;
    import fifo_config_obj_pkg::*;
    import fifo_env_pkg::*;
    import fifo_reset_sequence_pkg::*;
    import fifo_write_sequence_pkg::*;
    import fifo_read_sequence_pkg::*;
    import fifo_write_read_sequence_pkg::*;
    import fifo_main_sequence_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)

        fifo_env env; // environment object
        fifo_config_obj fifo_cfg; // configuration object     
        virtual fifo_if fifo_vif; // virtual interface
        // sequences
        fifo_reset_sequence reset_seq; // reset sequence
        fifo_write_sequence write_seq; // write sequence
        fifo_read_sequence read_seq; // read sequence
        fifo_write_read_sequence write_read_seq; // write read sequence
        fifo_main_sequence main_seq; // main sequence


        // construction function
        function new(string name = "fifo_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // build both environmnet and configuration objects
        // env = new; , als_cfg = new;
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env  = fifo_env::type_id::create("env", this);
            fifo_cfg = fifo_config_obj::type_id::create("fifo_cfg");
            // sequences creation
            reset_seq = fifo_reset_sequence::type_id::create("reset_seq", this);
            write_seq = fifo_write_sequence::type_id::create("write_seq", this);
            read_seq = fifo_read_sequence::type_id::create("read_seq", this);
            write_read_seq = fifo_write_read_sequence::type_id::create("write_read_seq", this);
            main_seq = fifo_main_sequence::type_id::create("main_seq", this);

            //getting the real interface and assign it to the virtual one in the configuration object
            if (!uvm_config_db #(virtual fifo_if)::get(this,"","fifo_V", fifo_cfg.fifo_vif))
                `uvm_fatal("build_phase", "test unable");

            // setting the entire object to be visible by all under the fifo_test umbrella
            uvm_config_db #(fifo_config_obj)::set(this,"*","CFG", fifo_cfg);
        endfunction
        // run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this); // incerement static var.
            // reset sequence
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "reset dasserted", UVM_LOW)

            // write sequence
            `uvm_info("run_phase", "write asserted", UVM_LOW)
            write_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "write dasserted", UVM_LOW)

            // read sequence
            `uvm_info("run_phase", "read asserted", UVM_LOW)
            read_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "read dasserted", UVM_LOW)

            // write read sequence
            `uvm_info("run_phase", "write_read asserted", UVM_LOW)
            write_read_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "write_read dasserted", UVM_LOW)

            // main sequence
            `uvm_info("run_phase", "main asserted", UVM_MEDIUM)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "main dasserted", UVM_LOW)
            
            phase.drop_objection(this); // decrement static var.
        endtask
    endclass: fifo_test
endpackage