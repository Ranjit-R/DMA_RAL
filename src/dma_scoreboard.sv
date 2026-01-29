class dma_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dma_scoreboard)

  uvm_analysis_imp#(dma_seq_item, dma_scoreboard) scb_port;

  bit [31:0] exp_mem [bit [31:0]];

  function new(string name = "dma_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_port = new("scb_port", this);
  endfunction

 function void write(dma_seq_item scb_item);

    `uvm_info("SCO", $sformatf("SCO RX | wr=%0b addr=0x%0h wdata=0x%0h rdata=0x%0h",scb_item.wr_en,scb_item.addr,scb_item.wdata,scb_item.rdata),UVM_LOW)

    if (scb_item.wr_en) begin
      exp_mem[scb_item.addr] = scb_item.wdata;

      `uvm_info("SCO",$sformatf("WRITE stored: addr=0x%0h data=0x%0h",scb_item.addr, scb_item.wdata),UVM_LOW)
    end
    else begin
      if (exp_mem.exists(scb_item.addr)) begin
        if (scb_item.rdata !== exp_mem[scb_item.addr]) begin
          `uvm_error("SCO",$sformatf("READ MISMATCH addr=0x%0h exp=0x%0h got=0x%0h",scb_item.addr,exp_mem[scb_item.addr],scb_item.rdata))
        end
        else begin
          `uvm_info("SCO",$sformatf("READ MATCH addr=0x%0h data=0x%0h",scb_item.addr, scb_item.rdata),UVM_LOW)
        end
      end
      else begin
        `uvm_warning("SCO",$sformatf("READ from unwritten addr=0x%0h data=0x%0h",scb_item.addr, scb_item.rdata))
      end
    end

  endfunction

endclass
