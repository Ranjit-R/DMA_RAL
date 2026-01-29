
// ============================================================
// INTR Register (0x400)
// ============================================================
class intr_reg extends uvm_reg;
  `uvm_object_utils(intr_reg)

  uvm_reg_field intr_status; 
  rand uvm_reg_field intr_mask;

  covergroup intr_status_cov;
    option.per_instance = 1;
    coverpoint intr_status.value[15:0] {
      bins status_hit = {[0:16'hFFFF]};
     }
  endgroup

  covergroup intr_mask_cov;
    option.per_instance = 1;
    coverpoint intr_mask.value[31:16] {
      bins mask_hit = {[0:16'hFFFF]};
    }
  endgroup

  function new(string name="intr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    intr_status_cov = new();
    intr_mask_cov   = new();
  endfunction

  virtual function void sample(
    uvm_reg_data_t data,
    uvm_reg_data_t byte_en,
    bit is_read,
    uvm_reg_map map
  );
    intr_status_cov.sample();
    intr_mask_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    intr_status_cov.sample();
    intr_mask_cov.sample();
  endfunction

  function void build();
    intr_status = uvm_reg_field::type_id::create("intr_status");
    intr_status.configure(this,16,0,"RO",0,16'h0,1,1,1);

    intr_mask = uvm_reg_field::type_id::create("intr_mask");
    intr_mask.configure(this,16,16,"RW",0,16'h0,1,1,1);
  endfunction
endclass

// ============================================================
// CTRL Register (0x404)
// ============================================================
class ctrl_reg extends uvm_reg;
  `uvm_object_utils(ctrl_reg)

  rand uvm_reg_field start_dma;   
  rand uvm_reg_field w_count;     
  rand uvm_reg_field io_mem;      
  uvm_reg_field reserved;         

  covergroup start_dma_cov;
    coverpoint start_dma.value[0];
  endgroup

  covergroup w_count_cov;
    option.per_instance = 1;
    coverpoint w_count.value[15:1] {
      bins low  = {[1:64]};
      bins med  = {[65:1024]};
      bins high = {[1025:32767]};
    }
  endgroup

  covergroup io_mem_cov;
    coverpoint io_mem.value[16];
  endgroup


  function new(string name="ctrl_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    start_dma_cov = new();
    w_count_cov   = new();
    io_mem_cov    = new();
  endfunction

  virtual function void sample(
    uvm_reg_data_t data,
    uvm_reg_data_t byte_en,
    bit is_read,
    uvm_reg_map map
  );
    start_dma_cov.sample();
    w_count_cov.sample();
    io_mem_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    start_dma_cov.sample();
    w_count_cov.sample();
    io_mem_cov.sample();
  endfunction

  function void build();
    start_dma = uvm_reg_field::type_id::create("start_dma");
    start_dma.configure(this,1,0,"RW",0,1'h0,1,1,1);

    w_count = uvm_reg_field::type_id::create("w_count");
    w_count.configure(this,15,1,"RW",0,15'h0,1,1,1);

    io_mem = uvm_reg_field::type_id::create("io_mem");
    io_mem.configure(this,1,16,"RW",0,1'h0,1,1,1);

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(this,15,17,"RO",0,15'h0,1,1,1);
  endfunction
endclass

// ============================================================
// IO_ADDR Register (0x408)
// ============================================================
class io_addr_reg extends uvm_reg;
  `uvm_object_utils(io_addr_reg)

  rand uvm_reg_field io_addr;

  covergroup io_addr_cov;
    coverpoint io_addr.value[31:0];
  endgroup

  function new(string name="io_addr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    io_addr_cov = new();
  endfunction

 virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
  io_addr_cov.sample();
endfunction


  virtual function void sample_values();
    super.sample_values();
    io_addr_cov.sample();
  endfunction

  function void build();
    io_addr = uvm_reg_field::type_id::create("io_addr");
    io_addr.configure(this,32,0,"RW",0,32'h0,1,1,1);
  endfunction
endclass

// ============================================================
// MEM_ADDR Register (0x40C)
// ============================================================
class mem_addr_reg extends uvm_reg;
  `uvm_object_utils(mem_addr_reg)

  rand uvm_reg_field mem_addr;

  covergroup mem_addr_cov;
    coverpoint mem_addr.value[31:0];
  endgroup

  function new(string name="mem_addr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    mem_addr_cov = new();
  endfunction

   virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    mem_addr_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    mem_addr_cov.sample();
  endfunction

  function void build();
    mem_addr = uvm_reg_field::type_id::create("mem_addr");
    mem_addr.configure(this,32,0,"RW",0,32'h0,1,1,1);
  endfunction
endclass

// ============================================================
// EXTRA_INFO Register (0x410)
// ============================================================
class extra_info_reg extends uvm_reg;
  `uvm_object_utils(extra_info_reg)

  rand uvm_reg_field extra_info;

  covergroup extra_info_cov;
    option.per_instance = 1;
    coverpoint extra_info.value[31:0];
  endgroup

  function new(string name="extra_info_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    extra_info_cov = new();
  endfunction

 virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    extra_info_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    extra_info_cov.sample();
  endfunction

  function void build();
    extra_info = uvm_reg_field::type_id::create("extra_info");
    extra_info.configure(this,32,0,"RW",0,32'h0,1,1,1);
  endfunction
endclass

// ============================================================
// STATUS Register (0x414)
// ============================================================
class status_reg extends uvm_reg;
  `uvm_object_utils(status_reg)

  uvm_reg_field busy, done, error, paused;
  uvm_reg_field current_state;
  uvm_reg_field fifo_level;
  uvm_reg_field reserved;

  covergroup status_cov;

  coverpoint busy.value[0] {
    bins busy_bin = {[0:1]};
    }

  coverpoint done.value[1] {
    bins done_bin= {[0:1]};
  }

  coverpoint error.value[2] {
    bins error_bin = {[0:1]};
  }

  coverpoint paused.value[3] {
    bins paused_bin = {[0:1]};
   }

  coverpoint current_state.value[7:4] {
    bins current_state_bins = {[0:7]}; 
  }

  coverpoint fifo_level.value[15:8] {
    bins fifo_level_bin  = {[0:255]};
   }

endgroup


  function new(string name="status_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    status_cov = new();
  endfunction

 virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    status_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    status_cov.sample();
  endfunction

  function void build();
    busy          = uvm_reg_field::type_id::create("busy");
    done          = uvm_reg_field::type_id::create("done");
    error         = uvm_reg_field::type_id::create("error");
    paused        = uvm_reg_field::type_id::create("paused");
    current_state = uvm_reg_field::type_id::create("current_state");
    fifo_level    = uvm_reg_field::type_id::create("fifo_level");
  	reserved      = uvm_reg_field::type_id::create("reserved");
    
    
    busy.configure(this,1,0,"RO",0,1'h0,1,1,1);
    done.configure(this,1,1,"RO",0,1'h0,1,1,1);
    error.configure(this,1,2,"RO",0,1'h0,1,1,1);
    paused.configure(this,1,3,"RO",0,1'h0,1,1,1);
    current_state.configure(this,4,4,"RO",0,4'h0,1,1,1);
    fifo_level.configure(this,8,8,"RO",0,8'h0,1,1,1);
    reserved.configure(this,16,16,"RO",0,16'h0,1,1,1);
  endfunction
endclass

// ============================================================
// TRANSFER_COUNT Register (0x418)
// ============================================================
class transfer_count_reg extends uvm_reg;
  `uvm_object_utils(transfer_count_reg)

  uvm_reg_field transfer_count;

  covergroup transfer_count_cov;

  coverpoint transfer_count.value[31:0] {
    bins transfer_count_bin      = {[0:$]};
    }

endgroup


  function new(string name="transfer_count_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    transfer_count_cov = new();
  endfunction

  virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    transfer_count_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    transfer_count_cov.sample();
  endfunction

  function void build();
    transfer_count = uvm_reg_field::type_id::create("transfer_count");
    transfer_count.configure(this,32,0,"RO",0,32'h0,1,1,1);
  endfunction
endclass

// ============================================================
// DESCRIPTOR_ADDR Register (0x41C)
// ============================================================
class descriptor_addr_reg extends uvm_reg;
  `uvm_object_utils(descriptor_addr_reg)

  rand uvm_reg_field descriptor_addr;

  covergroup descriptor_addr_cov;
    coverpoint descriptor_addr.value[31:0];
  endgroup

  function new(string name="descriptor_addr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    descriptor_addr_cov = new();
  endfunction

   virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    descriptor_addr_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    descriptor_addr_cov.sample();
  endfunction

  function void build();
    descriptor_addr = uvm_reg_field::type_id::create("descriptor_addr");
    descriptor_addr.configure(this,32,0,"RW",0,32'h0,1,1,1);
  endfunction
endclass

// ============================================================
// ERROR_STATUS Register (0x420)
// ============================================================
class error_status_reg extends uvm_reg;
  `uvm_object_utils(error_status_reg)

  rand uvm_reg_field bus_error, timeout_error, alignment_error;
  rand uvm_reg_field overflow_error, underflow_error;
  uvm_reg_field reserved, error_code, error_addr_offset;

 covergroup error_cov;
  coverpoint error_code.value[15:8] {
    bins b = {[0:8'hFF]};
  }
  coverpoint error_addr_offset.value[31:16] {
    bins b = {[0:16'hFFFF]};
  }

endgroup


  function new(string name="error_status_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    error_cov = new();
  endfunction

 virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    error_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    error_cov.sample();
  endfunction

 function void build();
  bus_error         = uvm_reg_field::type_id::create("bus_error");
  timeout_error     = uvm_reg_field::type_id::create("timeout_error");
  alignment_error   = uvm_reg_field::type_id::create("alignment_error");
  overflow_error    = uvm_reg_field::type_id::create("overflow_error");
  underflow_error   = uvm_reg_field::type_id::create("underflow_error");
  reserved          = uvm_reg_field::type_id::create("reserved");
  error_code        = uvm_reg_field::type_id::create("error_code");
  error_addr_offset = uvm_reg_field::type_id::create("error_addr_offset");

  bus_error.configure(this,1,0,"W1C",0,1'h0,1,1,1);
  timeout_error.configure(this,1,1,"W1C",0,1'h0,1,1,1);
  alignment_error.configure(this,1,2,"W1C",0,1'h0,1,1,1);
  overflow_error.configure(this,1,3,"W1C",0,1'h0,1,1,1);
  underflow_error.configure(this,1,4,"W1C",0,1'h0,1,1,1);
  reserved.configure(this,3,5,"RO",0,3'h0,1,1,1);
  error_code.configure(this,8,8,"RO",0,8'h0,1,1,1);
  error_addr_offset.configure(this,16,16,"RO",0,16'h0,1,1,1);
endfunction

endclass

// ============================================================
// CONFIG Register (0x424)
// ============================================================
class config_reg extends uvm_reg;
  `uvm_object_utils(config_reg)

  rand uvm_reg_field priority1, auto_restart, interrupt_enable;
  rand uvm_reg_field burst_size, data_width, descriptor_mode;
  uvm_reg_field reserved;

  covergroup config_cov;
  coverpoint priority1.value[1:0] {
    bins b = {[0:3]};}
  //coverpoint auto_restart.value[2] {
  //  bins b = {1}; }
  //coverpoint interrupt_enable.value[3] {
  //  bins b = {1}; }
  coverpoint burst_size.value[5:4] {
    bins b = {[0:3]};  }
  coverpoint data_width.value[7:6] {
    bins b = {[0:3]};  }
  //coverpoint descriptor_mode.value[8] {
  // bins b = {1};  }
  coverpoint reserved.value[31:9] {
    bins b = {0};  }

endgroup

  function new(string name="config_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    config_cov = new();
  endfunction

   virtual function void sample(
  uvm_reg_data_t data,
  uvm_reg_data_t byte_en,
  bit            is_read,
  uvm_reg_map    map
);
    config_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    config_cov.sample();
  endfunction

 function void build();
  priority1         = uvm_reg_field::type_id::create("priority1");
  auto_restart      = uvm_reg_field::type_id::create("auto_restart");
  interrupt_enable  = uvm_reg_field::type_id::create("interrupt_enable");
  burst_size        = uvm_reg_field::type_id::create("burst_size");
  data_width        = uvm_reg_field::type_id::create("data_width");
  descriptor_mode   = uvm_reg_field::type_id::create("descriptor_mode");
  reserved          = uvm_reg_field::type_id::create("reserved");

  priority1.configure(this,2,0,"RW",0,2'h0,1,1,1);
  auto_restart.configure(this,1,2,"RW",0,1'h0,1,1,1);
  interrupt_enable.configure(this,1,3,"RW",0,1'h0,1,1,1);
  burst_size.configure(this,2,4,"RW",0,2'h0,1,1,1);
  data_width.configure(this,2,6,"RW",0,2'h0,1,1,1);
  descriptor_mode.configure(this,1,8,"RW",0,1'h0,1,1,1);
  reserved.configure(this,23,9,"RO",0,23'h0,1,1,1);
endfunction

endclass


