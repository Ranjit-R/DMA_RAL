class dma_monitor extends uvm_monitor;
  `uvm_component_utils(dma_monitor)
  
  uvm_analysis_port #(dma_seq_item) mon_port;
  virtual dma_interface vif;
  
  function new(string name="dma_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_port = new("mon_port", this);
    if (!uvm_config_db#(virtual dma_interface)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Virtual interface not set for dma_monitor")
  endfunction
  
  task run_phase(uvm_phase phase);
    dma_seq_item mon_item;
    forever begin
      @(posedge vif.clk);
      
      // Skip monitoring during reset
      if (!vif.rst) continue;
      
      // ==================== MONITOR WRITE ====================
      if (vif.wr_en && !vif.rd_en) begin
        mon_item = dma_seq_item::type_id::create("mon_item", this);
        mon_item.addr  = vif.addr;
        mon_item.wr_en = 1'b1;
        mon_item.wdata = vif.wdata;
        mon_item.rdata = '0;
        `uvm_info("MON", $sformatf("WRITE addr=0x%0h data=0x%0h", mon_item.addr, mon_item.wdata), UVM_LOW)
        mon_port.write(mon_item);
      end
      
      // ==================== MONITOR READ ====================
      // Capture address when rd_en is asserted
      if (vif.rd_en && !vif.wr_en) begin
        mon_item = dma_seq_item::type_id::create("mon_item", this);
        mon_item.addr  = vif.addr;
        mon_item.wr_en = 1'b0;
        mon_item.wdata = '0;
        
        
        // Sample data on next cycle
        @(posedge vif.clk);
        mon_item.rdata = vif.rdata;
        
        `uvm_info("MON", $sformatf("READ addr=0x%0h data=0x%0h", mon_item.addr, mon_item.rdata), UVM_LOW)
        mon_port.write(mon_item);
      end
    end
  endtask
endclass
