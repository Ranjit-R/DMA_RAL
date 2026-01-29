class dma_agent extends uvm_agent;
  `uvm_component_utils(dma_agent)

  dma_driver    dma_drv;
  dma_sequencer dma_seqr;
  dma_monitor   dma_mon;

  uvm_analysis_port #(dma_seq_item) mon_ap;

  function new(string name = "dma_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  // ---------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    dma_mon = dma_monitor::type_id::create("dma_mon", this);

    mon_ap = new("mon_ap", this);

    if (is_active == UVM_ACTIVE) begin
      `uvm_info("AGENT", "Active Agent", UVM_MEDIUM)
      dma_drv  = dma_driver::type_id::create("dma_drv", this);
      dma_seqr = dma_sequencer::type_id::create("dma_seqr", this);
    end
    else 
	`uvm_info("AGENT", "Passive Agent", UVM_MEDIUM)
  endfunction

  // ---------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);


    if (is_active == UVM_ACTIVE) begin
      dma_drv.seq_item_port.connect(dma_seqr.seq_item_export);
    end

    dma_mon.mon_port.connect(mon_ap);
  endfunction

endclass
