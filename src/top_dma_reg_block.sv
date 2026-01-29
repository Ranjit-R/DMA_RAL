class top_dma_reg_block extends uvm_reg_block;
  `uvm_object_utils(top_dma_reg_block)

  // ------------------------------------------------------------
  // Register instances
  // ------------------------------------------------------------
  rand intr_reg            intr_reg_inst;
  rand ctrl_reg            ctrl_reg_inst;
  rand io_addr_reg         io_addr_reg_inst;
  rand mem_addr_reg        mem_addr_reg_inst;
  rand extra_info_reg      extra_info_reg_inst;
  rand status_reg          status_reg_inst;
  rand transfer_count_reg  transfer_count_reg_inst;
  rand descriptor_addr_reg descriptor_addr_reg_inst;
  rand error_status_reg    error_status_reg_inst;
  rand config_reg          config_reg_inst;

  // Address map
  uvm_reg_map dma_map;

  // ------------------------------------------------------------
  function new(string name = "top_dma_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  // ------------------------------------------------------------
  function void build();
    
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
   
    // ---------------- INTR ----------------
    intr_reg_inst = intr_reg::type_id::create("intr_reg_inst");
    intr_reg_inst.build();
    intr_reg_inst.configure(this);
    void'(intr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- CTRL ----------------
    ctrl_reg_inst = ctrl_reg::type_id::create("ctrl_reg_inst");
    ctrl_reg_inst.build();
    ctrl_reg_inst.configure(this);
    void'(ctrl_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- IO_ADDR ----------------
    io_addr_reg_inst = io_addr_reg::type_id::create("io_addr_reg_inst");
    io_addr_reg_inst.build();
    io_addr_reg_inst.configure(this);
    void'(io_addr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- MEM_ADDR ----------------
    mem_addr_reg_inst = mem_addr_reg::type_id::create("mem_addr_reg_inst");
    mem_addr_reg_inst.build();
    mem_addr_reg_inst.configure(this);
    void'(mem_addr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- EXTRA_INFO ----------------
    extra_info_reg_inst = extra_info_reg::type_id::create("extra_info_reg_inst");
    extra_info_reg_inst.build();
    extra_info_reg_inst.configure(this);
    void'(extra_info_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- STATUS ----------------
    status_reg_inst = status_reg::type_id::create("status_reg_inst");
    status_reg_inst.build();
    status_reg_inst.configure(this);
    void'(status_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- TRANSFER_COUNT ----------------
    transfer_count_reg_inst =
      transfer_count_reg::type_id::create("transfer_count_reg_inst");
    transfer_count_reg_inst.build();
    transfer_count_reg_inst.configure(this);
    void'(transfer_count_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- DESCRIPTOR_ADDR ----------------
    descriptor_addr_reg_inst =
      descriptor_addr_reg::type_id::create("descriptor_addr_reg_inst");
    descriptor_addr_reg_inst.build();
    descriptor_addr_reg_inst.configure(this);
    void'(descriptor_addr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- ERROR_STATUS ----------------
    error_status_reg_inst =
      error_status_reg::type_id::create("error_status_reg_inst");
    error_status_reg_inst.build();
    error_status_reg_inst.configure(this);
    void'(error_status_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ---------------- CONFIG ----------------
    config_reg_inst = config_reg::type_id::create("config_reg_inst");
    config_reg_inst.build();
    config_reg_inst.configure(this);
    void'(config_reg_inst.set_coverage(UVM_CVR_FIELD_VALS));

    // ------------------------------------------------------------
    // BACKDOOR
    // ------------------------------------------------------------

    add_hdl_path("top.dut", "RTL");

    // INTR
    intr_reg_inst.add_hdl_path_slice("intr_mask",   16, 16);
    intr_reg_inst.add_hdl_path_slice("intr_status", 0,  16);

    // CTRL
    ctrl_reg_inst.add_hdl_path_slice("ctrl_start_dma", 0,  1);
    ctrl_reg_inst.add_hdl_path_slice("ctrl_w_count",   1, 15);
    ctrl_reg_inst.add_hdl_path_slice("ctrl_io_mem",   16,  1);

    // IO_ADDR
    io_addr_reg_inst.add_hdl_path_slice("io_addr", 0, 32);

    // MEM_ADDR
    mem_addr_reg_inst.add_hdl_path_slice("mem_addr", 0, 32);

    // EXTRA_INFO
    extra_info_reg_inst.add_hdl_path_slice("extra_info", 0, 32);

    // STATUS (RO)
    status_reg_inst.add_hdl_path_slice("status_busy",          0, 1);
    status_reg_inst.add_hdl_path_slice("status_done",          1, 1);
    status_reg_inst.add_hdl_path_slice("status_error",         2, 1);
    status_reg_inst.add_hdl_path_slice("status_paused",        3, 1);
    status_reg_inst.add_hdl_path_slice("status_current_state", 4, 4);
    status_reg_inst.add_hdl_path_slice("status_fifo_level",    8, 8);

    // TRANSFER_COUNT (RO)
    transfer_count_reg_inst.add_hdl_path_slice("transfer_count", 0, 32);

    // DESCRIPTOR_ADDR
    descriptor_addr_reg_inst.add_hdl_path_slice("descriptor_addr", 0, 32);

    // ERROR_STATUS
    error_status_reg_inst.add_hdl_path_slice("error_bus",          0, 1);
    error_status_reg_inst.add_hdl_path_slice("error_timeout",      1, 1);
    error_status_reg_inst.add_hdl_path_slice("error_alignment",    2, 1);
    error_status_reg_inst.add_hdl_path_slice("error_overflow",     3, 1);
    error_status_reg_inst.add_hdl_path_slice("error_underflow",    4, 1);
    error_status_reg_inst.add_hdl_path_slice("error_code",         8, 8);
    error_status_reg_inst.add_hdl_path_slice("error_addr_offset", 16, 16);

    // CONFIG
    config_reg_inst.add_hdl_path_slice("config_priority",         0, 2);
    config_reg_inst.add_hdl_path_slice("config_auto_restart",     2, 1);
    config_reg_inst.add_hdl_path_slice("config_interrupt_enable", 3, 1);
    config_reg_inst.add_hdl_path_slice("config_burst_size",       4, 2);
    config_reg_inst.add_hdl_path_slice("config_data_width",       6, 2);
    config_reg_inst.add_hdl_path_slice("config_descriptor_mode",  8, 1);

    // ------------------------------------------------------------
    // Address Map
    // ------------------------------------------------------------
    dma_map = create_map("dma_map", 'h400, 4, UVM_LITTLE_ENDIAN);

    dma_map.add_reg(intr_reg_inst,            'h400, "RO");
    dma_map.add_reg(ctrl_reg_inst,            'h404, "RW");
    dma_map.add_reg(io_addr_reg_inst,         'h408, "RW");
    dma_map.add_reg(mem_addr_reg_inst,        'h40C, "RW");
    dma_map.add_reg(extra_info_reg_inst,      'h410, "RW");
    dma_map.add_reg(status_reg_inst,          'h414, "RO");
    dma_map.add_reg(transfer_count_reg_inst,  'h418, "RO");
    dma_map.add_reg(descriptor_addr_reg_inst, 'h41C, "RW");
    dma_map.add_reg(error_status_reg_inst,    'h420, "RW");
    dma_map.add_reg(config_reg_inst,          'h424, "RW");

    lock_model();
  endfunction

endclass
