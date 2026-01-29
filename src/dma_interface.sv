
`include "global_para.svh"
interface dma_interface(input logic clk, rst);
  
  logic [`data_width-1:0] wdata;
  logic [`data_width-1:0] rdata;
  logic [`addr_width-1:0] addr;
  logic wr_en;
  logic rd_en;
  
  clocking driver_cb@(posedge clk);
    default input #0 output #0;
    input rst;
    output wdata, addr, wr_en, rd_en;
  endclocking
  
  clocking monitor_cb@(posedge clk);
    default input #0 output #0;
    input rdata;
    input wdata, addr, wr_en, rd_en, rst;
  endclocking
  
  modport driver_mod(clocking driver_cb, input clk);
  modport monitor_mod(clocking monitor_cb, input clk);
      
endinterface
      
