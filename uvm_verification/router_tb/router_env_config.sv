class router_env_config extends uvm_object;

  // Configuration flags
  bit has_scoreboard = 1;
  bit has_source_agent = 1;
  bit has_dest_agent = 1;
  bit has_virtual_sequencer = 1;

  // Agent configurations
  source_agent_config m_src_agent_cfg[];
  dest_agent_config m_dest_agent_cfg[];

  // Number of components
  int number_of_source = 1;
  int number_of_dest = 3;
  int number_of_duts = 1;

  // Register the class with UVM
  `uvm_object_utils(router_env_config)

  // Constructor
  function new(string name = "router_env_config");
    super.new(name);
  endfunction

endclass

