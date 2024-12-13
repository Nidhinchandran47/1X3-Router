class router_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(router_scoreboard)

  uvm_tlm_analysis_fifo #(source_xtn) fifo_src;
  uvm_tlm_analysis_fifo #(dest_xtn) fifo_dst[];

  source_xtn src_data;
  dest_xtn dest_data;
  source_xtn cov_src_data;
  dest_xtn cov_dest_data;


  router_env_config m_cfg;

  int data_verified_count;

  covergroup router_cov1;
    option.per_instance = 1;
    ADDRESS: coverpoint cov_src_data.header[1:0] {
      bins ZERO = {2'b00}; bins ONE = {2'b01}; bins TWO = {2'b10};
    }
    P_SIZE: coverpoint cov_src_data.header[7:2] {
      bins SMALL = {[1 : 15]}; bins MED = {[16 : 30]}; bins BIG = {[32 : 63]};
    }
    ADDRESS_X_SIZE: cross ADDRESS, P_SIZE;
  endgroup

  covergroup router_cov2;
    option.per_instance = 1;
    ADDRESS: coverpoint cov_dest_data.header[1:0] {
      bins ZERO = {2'b00}; bins ONE = {2'b01}; bins TWO = {2'b10};
    }
    P_SIZE: coverpoint cov_dest_data.header[7:2] {
      bins SMALL = {[1 : 15]}; bins MED = {[16 : 30]}; bins BIG = {[32 : 63]};
    }
    ADDRESS_X_SIZE: cross ADDRESS, P_SIZE;
  endgroup

  function new(string name = "router_scoreboard", uvm_component parent);
    super.new(name, parent);
    router_cov1 = new();
    router_cov2 = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg))
      `uvm_fatal("CONFIG", "can't get router_env_config from scoreboard")
    src_data  = source_xtn::type_id::create("src_data", this);
    dest_data = dest_xtn::type_id::create("dest_data", this);

    fifo_dst  = new[m_cfg.number_of_dest];
    fifo_src  = new("fifo_src", this);
    foreach (fifo_dst[i]) fifo_dst[i] = new($sformatf("fifo_dst[%0d]", i), this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      fifo_src.get(src_data);
      `uvm_info("SCOREBOARD", "Source data", UVM_LOW)
      src_data.print;
      cov_src_data = src_data;
      router_cov1.sample();

//since only one destination will recive data at a time, Only need to get from that destination.

      if (src_data.header[1:0] == 2'b00) fifo_dst[0].get(dest_data);
      if (src_data.header[1:0] == 2'b01) fifo_dst[1].get(dest_data);
      if (src_data.header[1:0] == 2'b10) fifo_dst[2].get(dest_data);

      `uvm_info("SCOREBOARD", "Destination data", UVM_LOW)
      dest_data.print;

      check_data();
      cov_dest_data = dest_data;
      router_cov2.sample();

    end
  endtask

  function void check_data();
    bit [7:0] prt;  // Calcuation local parity for reference model
    prt = dest_data.header ^ 0;
    foreach (dest_data.payload[i]) begin
      prt = dest_data.payload[i] ^ prt;
    end
    if (src_data.header == dest_data.header)
      `uvm_info("SCOREBOARD", "HEADER MATCHED SUCCESSFULLY", UVM_LOW)
    else `uvm_info("SCOREBOARD", "HEADER MISMATCHED", UVM_LOW)

    if (src_data.payload == dest_data.payload)
      `uvm_info("SCOREBOARD", "PAYLOAD MATCHED SUCCESSFULLY", UVM_LOW)
    else `uvm_info("SCOREBOARD", "PAYLOAD MISMATCHED", UVM_LOW)

    if (src_data.parity == dest_data.parity)   // Source == Destination
      `uvm_info("SCOREBOARD", "PARITY MATCHED SUCCESSFULLY", UVM_LOW)
    else `uvm_info("SCOREBOARD", "PARITY MISMATCHED", UVM_LOW)


    if (prt == dest_data.parity)             //  Local Parity == sent/recieved parity
      `uvm_info("SCOREBOARD", "PARITY CHECK SUCCESSFULLY", UVM_LOW)
    else `uvm_info("SCOREBOARD", "ERROR IN PARITY", UVM_LOW)

    data_verified_count++;
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf(
              "\nReport : Number of data verified in SCOREBOARD %0d", data_verified_count), UVM_LOW)
  endfunction

endclass
