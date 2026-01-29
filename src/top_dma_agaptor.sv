import uvm_pkg::*;
`include "uvm_macros.svh"

class top_dma_adapter extends uvm_reg_adapter;
  `uvm_object_utils(top_dma_adapter)

  function new(string name = "top_dma_adapter");
    super.new(name);

    supports_byte_enable = 0;
    provides_responses   = 0;
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    dma_seq_item dma_item;

    dma_item = dma_seq_item::type_id::create("dma_item");
    dma_item.addr  = rw.addr[31:0];
    dma_item.wr_en = (rw.kind == UVM_WRITE);
    dma_item.wdata = rw.data;

    return dma_item;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    dma_seq_item dma_item;

    if (!$cast(dma_item, bus_item)) begin
      `uvm_fatal("ADAPTER", "bus_item is not dma_seq_item")
    end

    rw.kind   = dma_item.wr_en ? UVM_WRITE : UVM_READ;
    rw.addr   = dma_item.addr;
    rw.data   = dma_item.wr_en ? dma_item.wdata : dma_item.rdata;
    rw.status = UVM_IS_OK;
  endfunction

endclass
