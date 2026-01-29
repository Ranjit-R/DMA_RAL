class dma_reg_base_sequence extends uvm_sequence #(uvm_reg_item);
  `uvm_object_utils(dma_reg_base_sequence)
  
  top_dma_reg_block dma_rm;
  uvm_status_e      status;
  uvm_reg_data_t rand_value = 10000;
  uvm_reg_data_t corner_vals[$];
  
  function new(string name="dma_reg_base_sequence");
    super.new(name);
  endfunction
  
  task pre_body();
    if (dma_rm == null)
      `uvm_fatal(get_type_name(), "dma_rm is NULL")
  endtask
  
  task fd_write(uvm_reg rg, uvm_reg_data_t data);
    rg.write(status, data, UVM_FRONTDOOR);
  endtask
  
  task fd_read(uvm_reg rg, output uvm_reg_data_t data);
    rg.read(status, data, UVM_FRONTDOOR);
  endtask
  
  task bd_read(uvm_reg rg, output uvm_reg_data_t data);
    rg.peek(status, data);
  endtask
  
  task bd_write(uvm_reg rg, uvm_reg_data_t data);
    rg.poke(status, data);
  endtask
  
  function uvm_reg_data_t rand_data();
    uvm_reg_data_t d;
    void'(std::randomize(d));
    return d;
  endfunction
endclass

class dma_random_bus_sequence extends uvm_sequence #(dma_bus_item);
  `uvm_object_utils(dma_random_bus_sequence)

  int num_txn = 1000;

  function new(string name = "dma_random_bus_sequence");
    super.new(name);
  endfunction

  task body();
    dma_bus_item req;

    repeat (num_txn) begin
      req = dma_bus_item::type_id::create("req");

      start_item(req);
      if (!req.randomize())
        `uvm_error(get_type_name(), "Randomization failed");
      finish_item(req);
    end
  endtask
endclass


class intr_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(intr_reg_sequence)

  intr_reg        intr;
  uvm_reg_data_t  wdata;
  uvm_reg_data_t  rdata;

  function new(string name = "intr_reg_sequence");
    super.new(name);
  endfunction

  task body();

    intr = dma_rm.intr_reg_inst;

    corner_vals = '{
      32'hFFFF_0000,
      32'hAAAA_0000,
      32'h5555_0000,
      32'h0001_0000,
      32'h8000_0000,
      32'h0000_0000
    };

    `uvm_info("INTR_SEQ", "Starting INTR register test", UVM_MEDIUM)

    foreach (corner_vals[i]) begin
      fd_write(intr, corner_vals[i]);
      fd_read (intr, rdata);
      intr.mirror(status, UVM_CHECK);
    end

    repeat (rand_value) begin
      wdata = rand_data() & 32'hFFFF_0000;
      fd_write(intr, wdata);
      fd_read (intr, rdata);
      intr.mirror(status, UVM_CHECK);
    end

    intr.reset();
    fd_read(intr, rdata);
    intr.mirror(status, UVM_CHECK);

    `uvm_info("INTR_SEQ", "INTR register test completed", UVM_MEDIUM)
  endtask

endclass


class ctrl_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(ctrl_reg_sequence)

  ctrl_reg        ctrl;
  uvm_reg_data_t  wdata, rdata;
  uvm_reg_data_t  corners[$];

  task body();
    ctrl = dma_rm.ctrl_reg_inst;

    corner_vals = '{      
      32'h0001_0001,
      32'h0000_FFFE,
      32'h0001_8000,
      32'h0000_0000
    };

    foreach (corner_vals[i]) begin
      fd_write(ctrl, corner_vals[i]);
      fd_read(ctrl, rdata);
      ctrl.mirror(status, UVM_CHECK);
    end

    fd_write(ctrl, 32'h0000_0001);
    bd_read(ctrl, rdata);
    assert(rdata[0] == 0);

    repeat (rand_value) begin
      wdata = rand_data() & 32'h0001_FFFE;
      fd_write(ctrl, wdata);
      fd_read(ctrl, rdata);
      ctrl.mirror(status, UVM_CHECK);
    end
  endtask
endclass

class io_addr_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(io_addr_reg_sequence)

  io_addr_reg    rg;
  uvm_reg_data_t wdata;
  uvm_reg_data_t corners[$];

  task body();
    rg = dma_rm.io_addr_reg_inst;

    corner_vals = '{
      32'h0000_0000,
      32'hFFFF_FFFF,
      32'h0000_1000,
      32'h8000_0000
    };

    foreach (corner_vals[i]) begin
      fd_write(rg, corner_vals[i]);
      rg.mirror(status, UVM_CHECK);
    end

    repeat (rand_value) begin
      wdata = rand_data();
      fd_write(rg, wdata);
      rg.mirror(status, UVM_CHECK);
    end
  endtask
endclass

class mem_addr_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(mem_addr_reg_sequence)

  mem_addr_reg   rg;
  uvm_reg_data_t wdata;

  task body();
    rg = dma_rm.mem_addr_reg_inst;

   corner_vals = '{
      32'h0000_0000, 
      32'hFFFF_FFFF,
      32'h1000_0000,  
      32'h2000_0000,  
      32'h8000_0000, 
      32'hC000_0000, 
      32'h0000_1000   
    };

    foreach (corner_vals[i]) begin
      fd_write(rg, corner_vals[i]);
      rg.mirror(status, UVM_CHECK);
    end

    repeat (rand_value) begin
      wdata = rand_data();
      fd_write(rg, wdata);
      rg.mirror(status, UVM_CHECK);
    end
  endtask
endclass

class extra_info_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(extra_info_reg_sequence)

  extra_info_reg rg;
  uvm_reg_data_t wdata;

  task body();
    rg = dma_rm.extra_info_reg_inst;

    repeat (rand_value) begin
      wdata = rand_data();
      fd_write(rg, wdata);
      rg.mirror(status, UVM_CHECK);
    end
  endtask
endclass

class status_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(status_reg_sequence)

  status_reg     rg;
  uvm_reg_data_t r1, r2;

  task body();
    rg = dma_rm.status_reg_inst;

    bd_read(rg, r1);
    bd_read(rg, r2);
    assert(r2 >= r1);
 
    repeat(5) begin
	    fd_read(rg, r1);
	    fd_read(rg, r2);
	    assert(r1 == r2);
    end

    fd_write(rg, 32'hFFFF_FFFF);
    bd_read(rg, r2);
    assert(r1 == r2);

    fd_write(rg, 32'h0000_0000);
    bd_read(rg, r2);
    assert(r2 >= r1);
    
  endtask
endclass

class transfer_count_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(transfer_count_reg_sequence)

  transfer_count_reg rg;
  uvm_reg_data_t     r1, r2;

  task body();
    rg = dma_rm.transfer_count_reg_inst;

    bd_read(rg, r1);
    bd_read(rg, r2);
    assert(r2 >= r1);

    repeat(5) begin
	    fd_read(rg, r1);
	    fd_read(rg, r2);
	    assert(r1 == r2);
    end

    fd_write(rg, 32'hFFFF_FFFF);
    bd_read(rg, r2);
    assert(r2 >= r1);

    fd_write(rg, 32'h0000_0000);
    bd_read(rg, r2);
    assert(r2 >= r1);
  endtask
endclass

class descriptor_addr_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(descriptor_addr_reg_sequence)

  descriptor_addr_reg rg;
  uvm_reg_data_t      wdata;



  task body();
    rg = dma_rm.descriptor_addr_reg_inst;
 
   corner_vals = '{
      32'h0000_0000,  
      32'hFFFF_FFF0,  
      32'h1000_0000,  
      32'h8000_0000,  
      32'hDEAD_BEE0,  
      32'hCAFE_BAB0   
    };

    foreach (corner_vals[i]) begin
      fd_write(rg, corner_vals[i]);
      rg.mirror(status, UVM_CHECK);
    end

    repeat (rand_value) begin
      wdata = rand_data() & 32'hFFFF_FFF0;
      fd_write(rg, wdata);
      rg.mirror(status, UVM_CHECK);
    end
  endtask
endclass

class error_status_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(error_status_reg_sequence)

  error_status_reg rg;
  uvm_reg_data_t   rdata;

  task body();
    rg = dma_rm.error_status_reg_inst;

    corner_vals = '{
      32'h0000_001F,
      32'h0000_0000,
      32'hFFFF_FFFF 
    };

    foreach (corner_vals[i]) begin
      fd_write(rg, corner_vals[i]);
      rg.mirror(status, UVM_CHECK);
    end
  
    bd_write(rg, 32'h0000_001F);
    fd_read(rg, rdata);
    assert(rdata[4:0] != 0);

    fd_write(rg, 32'h0000_001F);
    fd_read(rg, rdata);
    assert(rdata[4:0] == 0);
  endtask
endclass

class config_reg_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(config_reg_sequence)

  config_reg     rg;
  uvm_reg_data_t wdata;
  uvm_reg_data_t corners[$];

  task body();
    rg = dma_rm.config_reg_inst;

    corner_vals = '{
      32'h0000_0000,  
      32'h0000_01FF, 
      32'h0000_0003,  
      32'h0000_0004,  
      32'h0000_0008,  
      32'h0000_0030,  
      32'h0000_00C0, 
      32'h0000_0100,  
      32'hFFFF_FFFF   
    };

    foreach (corner_vals[i]) begin
      fd_write(rg, corner_vals[i]);
      rg.mirror(status, UVM_CHECK);
    end

    repeat (rand_value) begin
      wdata = rand_data() & 32'h0000_01FF;
      fd_write(rg, wdata);
      rg.mirror(status, UVM_CHECK);
    end
  endtask
endclass


class dma_virtual_sequence extends dma_reg_base_sequence;
  `uvm_object_utils(dma_virtual_sequence)


  dma_random_bus_sequence      bus_seqr;
  intr_reg_sequence            intr_seq;
  ctrl_reg_sequence            ctrl_seq;
  io_addr_reg_sequence         io_addr_seq;
  mem_addr_reg_sequence        mem_addr_seq;
  extra_info_reg_sequence      extra_seq;
  status_reg_sequence          status_seq;
  transfer_count_reg_sequence  tcnt_seq;
  descriptor_addr_reg_sequence desc_seq;
  error_status_reg_sequence    err_seq;
  config_reg_sequence          cfg_seq;

  function new(string name="dma_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("VSEQ", "Starting DMA VIRTUAL register sequence", UVM_LOW)

    bus_seqr = dma_random_bus_sequence::type_id::create("rand_bus_seq");
    bus_seqr.start(m_sequencer);

    // INTR
    intr_seq = intr_reg_sequence::type_id::create("intr_seq");
    intr_seq.dma_rm = dma_rm;
    intr_seq.start(m_sequencer);

    // CTRL
    ctrl_seq = ctrl_reg_sequence::type_id::create("ctrl_seq");
    ctrl_seq.dma_rm = dma_rm;
    ctrl_seq.start(m_sequencer);

    // IO_ADDR
    io_addr_seq = io_addr_reg_sequence::type_id::create("io_addr_seq");
    io_addr_seq.dma_rm = dma_rm;
    io_addr_seq.start(m_sequencer);

    // MEM_ADDR
    mem_addr_seq = mem_addr_reg_sequence::type_id::create("mem_addr_seq");
    mem_addr_seq.dma_rm = dma_rm;
    mem_addr_seq.start(m_sequencer);

    // EXTRA_INFO
    extra_seq = extra_info_reg_sequence::type_id::create("extra_seq");
    extra_seq.dma_rm = dma_rm;
    extra_seq.start(m_sequencer);

    // STATUS (RO)
    status_seq = status_reg_sequence::type_id::create("status_seq");
    status_seq.dma_rm = dma_rm;
    status_seq.start(m_sequencer);

    // TRANSFER_COUNT (RO)
    tcnt_seq = transfer_count_reg_sequence::type_id::create("tcnt_seq");
    tcnt_seq.dma_rm = dma_rm;
    tcnt_seq.start(m_sequencer);

    // DESCRIPTOR_ADDR
    desc_seq = descriptor_addr_reg_sequence::type_id::create("desc_seq");
    desc_seq.dma_rm = dma_rm;
    desc_seq.start(m_sequencer);

    // ERROR_STATUS (RW1C)
    err_seq = error_status_reg_sequence::type_id::create("err_seq");
    err_seq.dma_rm = dma_rm;
    err_seq.start(m_sequencer);

    // CONFIG
    cfg_seq = config_reg_sequence::type_id::create("cfg_seq");
    cfg_seq.dma_rm = dma_rm;
    cfg_seq.start(m_sequencer);

    `uvm_info("VSEQ", "DMA VIRTUAL register sequence DONE", UVM_LOW)
  endtask

endclass

