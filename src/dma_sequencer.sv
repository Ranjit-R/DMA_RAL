class dma_sequencer extends uvm_sequencer #(dma_seq_item);
  `uvm_component_utils(dma_sequencer)
  
  function new(string name = "dma_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass

class bus_sequencer extends uvm_sequencer #(dma_bus_item);
  `uvm_component_utils(dma_sequencer)
  
  function new(string name = "dma_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass

