class router_base_test extends uvm_test;

  `uvm_component_utils(router_base_test)

  router_env envh;
  router_env_config m_env_cfg;

  source_agent_config m_src_cfg[];
  dest_agent_config m_dest_cfg[];

  int has_dest_agent = 1;
  int has_source_agent = 1;
  int number_of_dest = 3;
  int number_of_source = 1;
  int number_of_duts = 1;

  function new(string name = "router_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    m_env_cfg = router_env_config::type_id::create("m_env_cfg");

    if (has_dest_agent) m_env_cfg.m_dest_agent_cfg = new[number_of_dest];
    if (has_source_agent) m_env_cfg.m_src_agent_cfg = new[number_of_source];

    config_router;

    uvm_config_db#(router_env_config)::set(this, "*", "router_env_config", m_env_cfg);

    super.build_phase(phase);
    envh = router_env::type_id::create("envh", this);
  endfunction

  function void config_router();
    if (has_dest_agent) begin
      m_dest_cfg = new[number_of_dest];
      foreach (m_dest_cfg[i]) begin
        m_dest_cfg[i] = dest_agent_config::type_id::create($sformatf("m_dest_cfg[%0d]", i));

        if (!uvm_config_db#(virtual router_if)::get(
                this, "", $sformatf("vifd_%0d", i), m_dest_cfg[i].vif
            ))
          `uvm_fatal("VIF CONFIG",
                     "cannot get()interface vif from uvm_config_db. Have you set() it?")
        m_dest_cfg[i].is_active = UVM_ACTIVE;
        m_env_cfg.m_dest_agent_cfg[i] = m_dest_cfg[i];
      end
    end
    if (has_source_agent) begin
      m_src_cfg = new[number_of_source];
      foreach (m_src_cfg[i]) begin
        m_src_cfg[i] = source_agent_config::type_id::create($sformatf("m_src_cfg[%0d]", i));

        if (!uvm_config_db#(virtual router_if)::get(
                this, "", $sformatf("vifs_%0d", i), m_src_cfg[i].vif
            ))
          `uvm_fatal("VIF CONFIG",
                     "cannot get()interface vif from uvm_config_db. Have you set() it?")
        m_src_cfg[i].is_active = UVM_ACTIVE;
        m_env_cfg.m_src_agent_cfg[i] = m_src_cfg[i];
      end
    end
    m_env_cfg.has_dest_agent   = has_dest_agent;
    m_env_cfg.has_source_agent = has_source_agent;
    m_env_cfg.number_of_dest   = number_of_dest;
    m_env_cfg.number_of_source = number_of_source;
    m_env_cfg.number_of_duts   = number_of_duts;
  endfunction
endclass

class router_small_test extends router_base_test;

  `uvm_component_utils(router_small_test)
  router_small_vseq router_seqh;

  bit [1:0] addr;

  function new(string name = "router_small_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    repeat (10) begin
      addr = {$urandom} % 3;
      uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
      phase.raise_objection(this);
      router_seqh = router_small_vseq::type_id::create("router_seqh");
      router_seqh.start(envh.v_sequencer);
      #30;
      phase.drop_objection(this);
    end
  endtask


endclass  //router_small_test extends router_base_test

class router_med_test extends router_base_test;

  `uvm_component_utils(router_med_test)
  router_med_vseq router_seqh;
  bit [1:0] addr;
  function new(string name = "router_med_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    repeat (10) begin
      addr = {$urandom} % 3;
      uvm_config_db#(bit [1:0])::set(this, "*", "bit[1:0]", addr);
      phase.raise_objection(this);
      router_seqh = router_med_vseq::type_id::create("router_seqh");
      router_seqh.start(envh.v_sequencer);
      #30;
      phase.drop_objection(this);
    end
  endtask

endclass

class router_big_test extends router_base_test;

  `uvm_component_utils(router_big_test)
  router_big_vseq router_seqh;
  bit [1:0] addr;

  function new(string name = "router_big_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    repeat (10) begin
      addr = {$urandom} % 3;
      uvm_config_db#(bit [1:0])::set(this, "*", "bit[1:0]", addr);
      phase.raise_objection(this);
      router_seqh = router_big_vseq::type_id::create("router_seqh");
      router_seqh.start(envh.v_sequencer);
      #30;
      phase.drop_objection(this);
    end
  endtask
endclass

class router_soft_test extends router_base_test;

  `uvm_component_utils(router_soft_test)
  router_soft_vseq router_seqh;
  bit [1:0] addr;

  function new(string name = "router_soft_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
      addr = {$urandom} % 3;
      uvm_config_db#(bit [1:0])::set(this, "*", "bit[1:0]", addr);
      phase.raise_objection(this);
      router_seqh = router_soft_vseq::type_id::create("router_seqh");
      router_seqh.start(envh.v_sequencer);
      #30;
      phase.drop_objection(this);
  endtask
endclass

class router_error_test extends router_base_test;

  `uvm_component_utils(router_error_test)
  router_small_vseq router_seqh;
  bit [1:0] addr;

  function new(string name = "router_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(source_xtn::get_type(), error_xtn::get_type());
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    uvm_config_db#(bit [1:0])::set(this, "*", "bit[1:0]", addr);
    phase.raise_objection(this);
    router_seqh = router_small_vseq::type_id::create("router_seqh");
    router_seqh.start(envh.v_sequencer);
    #30;
    phase.drop_objection(this);
  endtask

endclass
