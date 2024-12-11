class router_source_monitor extends uvm_monitor;

  `uvm_component_utils(router_source_monitor)

  virtual router_if.SRC_MON_MP vif;

  source_agent_config m_cfg;

  uvm_analysis_port #(source_xtn) monitor_port;

  extern function new(string name = "router_source_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
  extern function void report_phase(uvm_phase phase);

endclass

function router_source_monitor::new(string name = "router_source_monitor", uvm_component parent);
  super.new(name, parent);
  monitor_port = new("monitor_port", this);
endfunction

function void router_source_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(source_agent_config)::get(this, "", "source_agent_config", m_cfg))
    `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void router_source_monitor::connect_phase(uvm_phase phase);
  vif = m_cfg.vif;
endfunction

task router_source_monitor::run_phase(uvm_phase phase);
  forever collect_data();
endtask

task router_source_monitor::collect_data();
  source_xtn xtn;
  xtn = source_xtn::type_id::create("xtn");
 
  @(vif.src_mon_cb);
  wait (!vif.src_mon_cb.busy )
  wait (vif.src_mon_cb.pkt_valid) 
  //while(vif.src_mon_cb.busy)            // we are checking here becuase if busy is high it will sample same data so we are checking here
//		@(vif.src_mon_cb);
//	while(vif.src_mon_cb.pkt_valid==0)
//		@(vif.src_mon_cb);
  xtn.header = vif.src_mon_cb.data_in;
  xtn.payload = new[xtn.header[7:2]];
  @(vif.src_mon_cb);
  foreach (xtn.payload[i]) begin
    wait (!vif.src_mon_cb.busy) 
    xtn.payload[i] = vif.src_mon_cb.data_in;
    @(vif.src_mon_cb);
  end
  wait (!vif.src_mon_cb.busy)
  wait (!vif.src_mon_cb.pkt_valid) 
  xtn.parity = vif.src_mon_cb.data_in;
  repeat (2) @(vif.src_mon_cb);
  m_cfg.mon_rcvd_count++;
  
///*
 /* @(vif.src_mon_cb);
  while(vif.src_mon_cb.busy===1)
    @(vif.src_mon_cb);
  while (vif.src_mon_cb.pkt_valid===0) 
    @(vif.src_mon_cb);
  xtn.header = vif.src_mon_cb.data_in;
  xtn.payload = new[xtn.header[7:2]];

  @(vif.src_mon_cb);
  foreach (xtn.payload[i]) begin
    while (vif.src_mon_cb.busy) 
      @(vif.src_mon_cb);
    xtn.payload[i] = vif.src_mon_cb.data_in;
    @(vif.src_mon_cb);
  end

  //while (vif.src_mon_cb.pkt_valid) 
    //@(vif.src_mon_cb);
  while(vif.src_mon_cb.busy)
    @(vif.src_mon_cb);
  xtn.parity = vif.src_mon_cb.data_in;
  repeat (2) @(vif.src_mon_cb);
  xtn.error = vif.src_mon_cb.error;
  m_cfg.mon_rcvd_count++;
//*/
  `uvm_info("ROUTER_SOURCE_MONITOR", $sformatf("printing from monitor \n %s", xtn.sprint()),
            UVM_LOW)
  monitor_port.write(xtn);
  //xtn.print();

endtask

function void router_source_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf(
            "\nReport : router source monitor recived %0d Packects", m_cfg.mon_rcvd_count), UVM_LOW)
endfunction