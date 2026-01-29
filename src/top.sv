`include "dma_pkg.sv"
`include "dma_interface.sv"
`include "design.sv"
module top;


  import uvm_pkg::*;
  import dma_pkg::*;
  `include "uvm_macros.svh"

  logic clk = 0;
  logic rst = 0;
  
  initial begin
    rst = 0;
    #10;
    rst = 1;
  end
  
  always #5 clk = ~clk;

  dma_interface dma_if (.clk(clk),.rst(rst));

  dma_design dut (
    .clk   (clk),
    .rst_n (rst),
    .wr_en (dma_if.wr_en),
    .rd_en (dma_if.rd_en),
    .addr  (dma_if.addr),
    .wdata (dma_if.wdata),
    .rdata (dma_if.rdata)
  );

  initial begin
    uvm_config_db#(virtual dma_interface)::set( null, "*", "vif", dma_if );
    run_test("dma_test");
  end

endmodule
