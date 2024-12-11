class router_dest_agent extends uvm_agent;

  `uvm_component_utils(router_dest_agent)

  dest_agent_config m_cfg;

  router_dest_driver drvh;
  router_dest_monitor monh;
  router_dest_sequencer seqrh;

  extern function new(string name = "router_dest_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

function router_dest_agent::new(string name = "router_dest_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void router_dest_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(dest_agent_config)::get(this, "", "dest_agent_config", m_cfg))
		`uvm_fatal("CONFIG", "cannot get m_cfg from dest_agent")
  monh  = router_dest_monitor::type_id::create("monh", this);
  if(m_cfg.is_active == UVM_ACTIVE)
		begin
      drvh  = router_dest_driver::type_id::create("drvh", this);
      seqrh = router_dest_sequencer::type_id::create("seqrh", this);
    end
endfunction

function void router_dest_agent::connect_phase(uvm_phase phase);
  drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
