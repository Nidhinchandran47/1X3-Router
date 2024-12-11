class dest_agent_config extends uvm_object;
  `uvm_object_utils(dest_agent_config)

  virtual router_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  static int mon_rcvd_count = 0;
  static int drv_sent_count = 0;
  function new(string name = "dest_agent_config");
    super.new(name);
  endfunction  //new()
endclass 
