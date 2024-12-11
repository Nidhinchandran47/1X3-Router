class router_dest_monitor extends uvm_monitor;

  `uvm_component_utils(router_dest_monitor)

  virtual router_if.DEST_MON_MP vif;

  dest_agent_config m_cfg;

  uvm_analysis_port #(dest_xtn) monitor_port;

  extern function new(string name = "router_dest_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();

endclass

function router_dest_monitor::new(string name = "router_dest_monitor", uvm_component parent);
  super.new(name, parent);
  monitor_port = new("monitor_port", this);
endfunction

function void router_dest_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(dest_agent_config)::get(this, "", "dest_agent_config", m_cfg))
    `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void router_dest_monitor::connect_phase(uvm_phase phase);
  vif = m_cfg.vif;
endfunction

task router_dest_monitor::run_phase(uvm_phase phase);
  forever begin
    collect_data();
  end
endtask

task router_dest_monitor::collect_data();
  dest_xtn xtn;
  xtn = dest_xtn::type_id::create("xtn");
  //@(vif.dest_mon_cb);
  // while (!vif.dest_mon_cb.valid_out)
  //   @(vif.dest_mon_cb);
  while (vif.dest_mon_cb.read_enb !== 1 )begin
    @(vif.dest_mon_cb);
    // $display("readenb a %b",vif.dest_mon_cb.read_enb);
    // $display("v out a %b",vif.dest_mon_cb.valid_out);
  end
  @(vif.dest_mon_cb);
  xtn.header = vif.dest_mon_cb.data_out;
  xtn.payload = new[xtn.header[7:2]];
  @(vif.dest_mon_cb);
  foreach (xtn.payload[i]) begin
    xtn.payload[i] = vif.dest_mon_cb.data_out;
    @(vif.dest_mon_cb);
  end
  xtn.parity = vif.dest_mon_cb.data_out;
  @(vif.dest_mon_cb);
  
  m_cfg.mon_rcvd_count++;

  `uvm_info("ROUTER_DEST_MONITOR", $sformatf("printing from monitor \n %s", xtn.sprint()),
           UVM_LOW)

  monitor_port.write(xtn);
endtask