class dma_test extends uvm_test;
  `uvm_component_utils(dma_test)

  // Environment
  dma_env dma_e;

  // Sequences
  dma_virtual_sequence     vseq;
  dma_random_bus_sequence  rand_seq;

  function new(string name = "dma_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  // ---------------------------------------------------------
  // Build phase
  // ---------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create environment
    dma_e = dma_env::type_id::create("dma_e", this);

    // Create sequences
    vseq     = dma_virtual_sequence::type_id::create("vseq");
    rand_seq = dma_random_bus_sequence::type_id::create("rand_seq");
  endfunction

  // ---------------------------------------------------------
  // End of elaboration
  // ---------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    print();
  endfunction

  // ---------------------------------------------------------
  // Run phase
  // ---------------------------------------------------------
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Provide register model to virtual sequence
    vseq.dma_rm = dma_e.dma_regmodel;

    `uvm_info("DMA_TEST", "Starting RANDOM + VIRTUAL sequences", UVM_LOW)
   
      begin
        rand_seq.start(dma_e.dma_agt.dma_seqr);
   
        vseq.start(dma_e.dma_agt.dma_seqr);
      end

    phase.phase_done.set_drain_time(this, 100ns);

    `uvm_info("DMA_TEST", "DMA test completed", UVM_LOW)

    phase.drop_objection(this);
  endtask

endclass
