class dma_driver extends uvm_driver #(dma_seq_item);
  `uvm_component_utils(dma_driver)
  
  virtual dma_interface vif;
  dma_seq_item req;
  
  function new(string name = "dma_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dma_interface)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Virtual interface not set for dma_driver")
  endfunction
  
  task run_phase(uvm_phase phase);
    reset_dut();
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask
 
  task reset_dut();
    `uvm_info("DRV", "Waiting for reset deassertion", UVM_MEDIUM)
    vif.wr_en <= 0;
    vif.rd_en <= 0;
    vif.addr  <= '0;
    vif.wdata <= '0;
    wait (vif.rst == 0); 
    wait (vif.rst == 1); 
    @(posedge vif.clk);
    `uvm_info("DRV", "Reset deasserted", UVM_MEDIUM)
  endtask
  
  task drive_item(dma_seq_item req);
    if (req.wr_en) begin
      @(posedge vif.clk);
      vif.addr  <= req.addr;
      vif.wr_en <= 1;
      vif.rd_en <= 0;
      vif.wdata <= req.wdata;
      `uvm_info("DRV", $sformatf("WRITE addr=0x%0h data=0x%0h", req.addr, req.wdata), UVM_LOW)
      
      @(posedge vif.clk);
      vif.wr_en <= 0;
      vif.addr  <= '0;
      vif.wdata <= '0;
    end
    else begin
      @(posedge vif.clk);
      vif.addr  <= req.addr;
      vif.wr_en <= 0;
      vif.rd_en <= 1;
      vif.wdata <= '0;
      `uvm_info("DRV", $sformatf("READ addr=0x%0h", req.addr), UVM_LOW)

      repeat(2)@(posedge vif.clk);
      req.rdata = vif.rdata;
      `uvm_info("DRV", $sformatf("READ DATA = 0x%0h", req.rdata), UVM_LOW)

      vif.rd_en <= 0;
      vif.addr  <= '0;
    end
  endtask
endclass
