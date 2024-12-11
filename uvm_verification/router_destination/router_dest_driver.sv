class router_dest_driver extends uvm_driver #(dest_xtn);

  `uvm_component_utils(router_dest_driver)

  virtual router_if.DEST_DRV_MP vif;

  dest_agent_config m_cfg;

  extern function new(string name = "router_dest_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(dest_xtn xtn);

endclass

function router_dest_driver::new(string name = "router_dest_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void router_dest_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(dest_agent_config)::get(this, "", "dest_agent_config", m_cfg))
    `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void router_dest_driver::connect_phase(uvm_phase phase);
  vif = m_cfg.vif;
endfunction

task router_dest_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
endtask

task router_dest_driver::send_to_dut(dest_xtn xtn);
  begin
    
    `uvm_info("ROUTER_DEST_DRIVER", $sformatf("printing from driver \n %s", xtn.sprint()), UVM_LOW)
    
    @(vif.dest_drv_cb);
    while (!vif.dest_drv_cb.valid_out) 
      @(vif.dest_drv_cb);
    vif.dest_drv_cb.read_enb <= 0;
    repeat (xtn.delay) 
      @(vif.dest_drv_cb);
    vif.dest_drv_cb.read_enb <= 1;
    while (vif.dest_drv_cb.valid_out) 
      @(vif.dest_drv_cb);
    vif.dest_drv_cb.read_enb <= 0;
    m_cfg.drv_sent_count++;
    @(vif.dest_drv_cb);

  end
endtask
