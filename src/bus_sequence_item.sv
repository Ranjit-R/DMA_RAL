class dma_bus_item extends uvm_sequence_item;
  `uvm_object_utils(dma_bus_item)

  rand bit        write;          // 1 = write, 0 = read
  rand bit [31:0] addr;
  rand bit [31:0] data;

  // Optional response field
  bit [31:0] rdata;

  // Address range constraint (DMA register space)
  constraint addr_c {
    addr inside {
      32'h400, 32'h404, 32'h408, 32'h40C,
      32'h410, 32'h414, 32'h418, 32'h41C,
      32'h420, 32'h424
    };
  }

  // Random read/write mix
  constraint rw_c {
    write dist { 1 := 50, 0 := 50 };
  }

  function new(string name = "dma_bus_item");
    super.new(name);
  endfunction
endclass
