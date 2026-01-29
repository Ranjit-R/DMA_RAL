class dma_env extends uvm_env;
  `uvm_component_utils(dma_env)

  // ---------------------------------------------------------
  // Components
  // ---------------------------------------------------------
  dma_agent                  dma_agt;
  dma_scoreboard             dma_scb;
  top_dma_reg_block          dma_regmodel;
  top_dma_adapter            dma_adapter;
  uvm_reg_predictor #(dma_seq_item) dma_predictor_inst;

  function new(string name = "dma_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  // ---------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Agent & scoreboard
    dma_agt = dma_agent::type_id::create("dma_agt", this);
    dma_scb = dma_scoreboard::type_id::create("dma_scb", this);

    // Register model
    dma_regmodel = top_dma_reg_block::type_id::create("dma_regmodel", this);
    dma_regmodel.build();
    dma_regmodel.lock_model();

    // Adapter
    dma_adapter = top_dma_adapter::type_id::create("dma_adapter", this);

    // Predictor
    dma_predictor_inst = uvm_reg_predictor#(dma_seq_item)::type_id::create("dma_predictor_inst", this);
  endfunction

  // ---------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

 
    // Agent -> Scoreboard
    //dma_agt.dma_mon.mon_port.connect(dma_scb.scb_port);

    // -------------------------------------------------------
    // RAL frontdoor setup
    // -------------------------------------------------------
    dma_regmodel.dma_map.set_sequencer( dma_agt.dma_seqr,  dma_adapter);

    dma_regmodel.dma_map.set_base_addr('h0);
    dma_regmodel.dma_map.set_auto_predict(0);

    // -------------------------------------------------------
    // Predictor setup
    // -------------------------------------------------------
    dma_predictor_inst.map     = dma_regmodel.dma_map;
    dma_predictor_inst.adapter = dma_adapter;

    // Agent -> Predictor
    dma_agt.dma_mon.mon_port.connect(dma_predictor_inst.bus_in);

  endfunction

endclass
