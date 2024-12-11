class router_source_driver extends uvm_driver #(source_xtn);

  `uvm_component_utils(router_source_driver)

  virtual router_if.SRC_DRV_MP vif;

  source_agent_config m_cfg;

  extern function new(string name = "router_source_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(source_xtn xtn);
  extern function void report_phase(uvm_phase phase);

endclass

function router_source_driver::new(string name = "router_source_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void router_source_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(source_agent_config)::get(this, "", "source_agent_config", m_cfg))
    `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void router_source_driver::connect_phase(uvm_phase phase);
  vif = m_cfg.vif;
endfunction

task router_source_driver::run_phase(uvm_phase phase);
  @(vif.src_drv_cb);
  vif.src_drv_cb.resetn <= 1'b0;
  @(vif.src_drv_cb);
  vif.src_drv_cb.resetn <= 1'b1;
  forever begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
endtask

task router_source_driver::send_to_dut(source_xtn xtn);

  /*
  @(vif.src_drv_cb);
  wait (!vif.src_drv_cb.busy)
  $display("d b %b",vif.src_drv_cb.busy);
  $display("d h %d",xtn.header); 
  vif.src_drv_cb.pkt_valid <= 1;
  vif.src_drv_cb.data_in <= xtn.header;
  @(vif.src_drv_cb);
  foreach (xtn.payload[i]) begin
    $display("d b %b",vif.src_drv_cb.busy);
    $display("d p %d",xtn.payload[i]);
    wait (!vif.src_drv_cb.busy) 
    vif.src_drv_cb.data_in <= xtn.payload[i];
    @(vif.src_drv_cb);
  end
  $display("d b %b",vif.src_drv_cb.busy);
  $display("d r %d",xtn.parity);
  wait (!vif.src_drv_cb.busy) vif.src_drv_cb.pkt_valid <= 0;
  vif.src_drv_cb.data_in <= xtn.parity;
  repeat (2) 
    @(vif.src_drv_cb);
  m_cfg.drv_sent_count++;
*/
 ///*
  @(vif.src_drv_cb);
  while (vif.src_drv_cb.busy) 
    @(vif.src_drv_cb);
  vif.src_drv_cb.pkt_valid <= 1;
  vif.src_drv_cb.data_in<= xtn.header;
  @(vif.src_drv_cb);

  foreach (xtn.payload[i]) begin
    while (vif.src_drv_cb.busy) 
      @(vif.src_drv_cb);
    vif.src_drv_cb.data_in <= xtn.payload[i];  //
    @(vif.src_drv_cb);
  end

  while (vif.src_drv_cb.busy) 
    @(vif.src_drv_cb);
  vif.src_drv_cb.pkt_valid <= 0;
  vif.src_drv_cb.data_in   <= xtn.parity;
  repeat (3) 
    @(vif.src_drv_cb);
  xtn.error = vif.src_drv_cb.error;
  m_cfg.drv_sent_count++;
  //*/
`uvm_info("ROUTER_SOURCE_DRIVER", $sformatf("printing from driver \n %s", xtn.sprint()), UVM_LOW)

  //xtn.print();

endtask

function void router_source_driver::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf(
            "\nReport : router source driver sent %0d packets", m_cfg.drv_sent_count), UVM_LOW)
endfunction
