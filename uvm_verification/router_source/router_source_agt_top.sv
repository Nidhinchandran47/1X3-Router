class router_source_agt_top extends uvm_env;

  `uvm_component_utils(router_source_agt_top)

  router_source_agent agenth[];

  router_env_config   m_cfg;

  extern function new(string name = "router_source_agt_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function router_source_agt_top::new(string name = "router_source_agt_top", uvm_component parent);
  super.new(name, parent);
endfunction

function void router_source_agt_top::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg))
    `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
  agenth = new[m_cfg.number_of_source];
  foreach (agenth[i]) begin
    agenth[i] = router_source_agent::type_id::create($sformatf("agenth[%0d]", i), this);
    uvm_config_db#(source_agent_config)::set(this, $sformatf("agenth[%0d]*", i),
                                             "source_agent_config", m_cfg.m_src_agent_cfg[i]);
  end
endfunction

task router_source_agt_top::run_phase(uvm_phase phase);
  uvm_top.print_topology;
endtask

